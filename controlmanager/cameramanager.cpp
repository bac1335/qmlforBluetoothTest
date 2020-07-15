#include "cameramanager.h"

#include <highgui.h>    //opencv
#include <cv.h>         //opencv

#include <QCamera>
#include <QTimerEvent>

//using namespace cv;
CameraManager::CameraManager(QObject *parent):
    QObject (parent)
{
    init();
}

void CameraManager::cameraInfoUpdate()
{
    QList<QCameraInfo> infoList = QCameraInfo::availableCameras(QCamera::FrontFace) + QCameraInfo::availableCameras(QCamera::BackFace);
    foreach(QCameraInfo info,infoList){
        CameraType type;
        type.position = info.position();
        type.deviceName = info.deviceName();
        type.description = info.description();
        m_deviceList << type;
    }
}

QVariantList CameraManager::cameraDeviceList(int type)
{
    QVariantList list;
    foreach(CameraType device,m_deviceList){
        if(device.position == type){
            list << device.description;
        }
    }
    return list;
}

bool CameraManager::openCamera()
{
    qDebug()<<"--->lls_startCamera<-----" << __FUNCTION__ << m_deviceList.count();

//    if(m_deviceList.count() <= 0) return false;

    m_pCam = cvCreateCameraCapture(0);

    if(m_pCam){
        if(m_iTimeFlag == -1){
            m_iTimeFlag = this->startTimer(30);
            return true;
        }
    }
    return false;
}

bool CameraManager::stopCamera()
{
    if(m_pCam){
        cvReleaseCapture(&m_pCam);
        m_pCam = nullptr;
    }

    if(m_iTimeFlag != -1){
        this->killTimer(m_iTimeFlag);
        m_iTimeFlag = -1;
        return true;
    }
    return false;
}

void CameraManager::timerEvent(QTimerEvent *event)
{
    if(event->timerId() == m_iTimeFlag){
        doTimeOut();
    }
}

void CameraManager::init()
{
    cameraInfoUpdate();

    m_pImageProvider = QSharedPointer<ImageProvider>(new ImageProvider());
}

void CameraManager::doTimeOut()
{
    IplImage* Frame = cvQueryFrame(m_pCam);
    if(Frame){
        QSharedPointer<QImage> img = QSharedPointer<QImage>(new QImage((unsigned char*)Frame->imageData,Frame->width,Frame->height,Frame->widthStep,QImage::Format_RGB888));

        m_pImageProvider->setImg(img.data());
        emit sigSendImgUpdate();
    }
}

