#include "cameramanager.h"
#include <QCamera>

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

void CameraManager::init()
{
    cameraInfoUpdate();
}

