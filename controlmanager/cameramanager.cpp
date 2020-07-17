#include "cameramanager.h"
#include "baidufacemanager.h"
#include <QApplication>
#include <QCamera>
#include <QTimerEvent>
#include <Windows.h>

#include <QProcess>
#include <QFile>

#include <QElapsedTimer>
#include <QStandardPaths>

#define OldOpencv 0

using namespace std;
using namespace cv;

CameraManager::CameraManager(QThread *parent):
   QThread(parent)
{
    init();
}

CameraManager::~CameraManager()
{
    qDebug() << "--->lls<---" << __FUNCTION__ ;
    stopCamera();

    if(m_pFramcap){
        delete m_pFramcap;
        m_pFramcap = nullptr;
    }

    if(this->isRunning()){
        m_useCheacked = false;
        this->wait();
        this->quit();
    }
}

void CameraManager::cameraInfoUpdate()
{
#if 1
    QList<QCameraInfo> infoList = QCameraInfo::availableCameras();
    foreach(QCameraInfo info,infoList){
        CameraType type;
        type.position = info.position();
        type.deviceName = info.deviceName();
        type.description = info.description();
        m_deviceList << type;
    }
#else
    qDebug()<<"--->lls<---" << __FUNCTION__<< "==============start_camera_info===============";
    QProcess process;
       QString fileName = QString("%1/device.txt").arg((QStandardPaths::writableLocation(QStandardPaths::CacheLocation)));
       QString cmd = QString("%1/ffmpeg.exe -list_devices true -f dshow -i dummy 2>%2 \n")
               .arg(qApp->applicationDirPath())
               .arg(fileName);
       cmd = cmd.replace("/","\\");
       process.start("cmd");
       process.waitForStarted();
       process.write(cmd.toLocal8Bit());
       process.closeWriteChannel();
       process.waitForFinished();

       QFile device(fileName);
       if(device.exists()){
           if(device.open(QIODevice::ReadOnly)){
               while(!device.atEnd()){
                   QString line = device.readLine();
                   if(!line.contains("[dshow @")) continue;
                   if (!line.contains("DirectShow video devices")) continue;
                   if (!line.contains("Alternative name"))
                   {
                       int index = line.indexOf("\"");
                       line = line.remove(0,index);
                       line = line.remove("\"");
                       line = line.remove("\n");
                       line = line.remove("\r");

                       CameraType d;
                       d.deviceName = line;
                       m_deviceList.push_back(d);
                   }
               }
               device.close();
           }
           device.remove();
       }
#endif
       qDebug() << "==============device_count================" << __FUNCTION__ << m_deviceList.count();
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

    if(m_deviceList.count() <= 0) return false;

#if OldOpencv
    m_pCam = cvCreateCameraCapture(0);

    if(m_pCam){
        if(m_iTimeFlag == -1){
            m_iTimeFlag = this->startTimer(30);
            return true;
        }
    }
#else
    if(m_useCheacked){
        QString facePath = QApplication::applicationDirPath() + "/haarcascade_frontalface_alt2.xml";
        QString areaPath = QApplication::applicationDirPath() + "/haarcascade_eye_tree_eyeglasses.xml";

        if(!m_pFaceCascade.load(facePath.toStdString())){
            qDebug()<<"--->lls<---load face fail" << __FUNCTION__;
            return false;
        }

        if(!m_pAreCascade.load(areaPath.toStdString())){
            qDebug()<<"--->lls<---loadArea fail" << __FUNCTION__;
            return false;
        }
    }

    //打开默认的camera
    if(m_pFramcap->open(0)){
        qDebug()<<"--->lls<---" << __FUNCTION__<< "open camera";
        m_cameraState = true;
        start();
    }
#endif
    return false;
}

bool CameraManager::openVideo(QString path)
{

    if(m_cameraState) return false;
    //打开视频
    if(m_pFramcap->open(path.toStdString())){
        m_cameraState = true;
        start();
    }

    return m_cameraState;
}

bool CameraManager::stopCamera()
{
   qDebug() << "--->lls<---" << __FUNCTION__  << m_iTimeFlag;

#if OldOpencv
    m_timerFlag = 0;
    if(m_pCam){
        cvReleaseCapture(&m_pCam);
        m_pCam = nullptr;
    }

    if(m_iTimeFlag != -1){
        this->killTimer(m_iTimeFlag);
        m_iTimeFlag = -1;
        return true;
    }
#else
   m_cameraState = false;  //这一瞬间可能子线程访问的是true，导致异常
   this->wait();
   this->quit();
   m_pFramcap->release();


#endif
    return true;
}

void CameraManager::timerEvent(QTimerEvent *event)
{
    if(event->timerId() == m_iTimeFlag){
        doTimeOut();
    }
}

void CameraManager::run()
{
    QElapsedTimer eptimer;
    eptimer.start();
    while(m_cameraState)
    {
        cv::Mat frame;
        bool ok = m_pFramcap->read(frame);
        if (! ok)             // also, mandatory CHECK !
            break;

        bool hasFace = false;

        if(m_useCheacked){
            cv::Mat frame2;
            cvtColor(frame, frame2, CV_BGR2GRAY);
            DetectFace(frame,frame2,hasFace);
        }

#if 1
        QImage img = cvMat2QImage(frame);
        if(m_needTosendImg){
            if(hasFace){
                if(eptimer.elapsed() > 5000){
                    m_needTosendImg = false;
                    QSharedPointer<QImage> img2 = QSharedPointer<QImage>(new QImage);
                    *(img2.data()) = img;
                    emit sigSendServerImg(img2.data());
                }
            }
        }

        m_pImageProvider->setImg(&img);
        emit sigUpdate();
#else
        imshow("src", frame);
#endif

        cv::waitKey(m_videoFps);
    }
}

QImage CameraManager::cvMat2QImage(const cv::Mat& mat)
{
    // 8-bits unsigned, NO. OF CHANNELS = 1
    if(mat.type() == CV_8UC1)
    {
        QImage image(mat.cols, mat.rows, QImage::Format_Indexed8);
        // Set the color table (used to translate colour indexes to qRgb values)
        image.setColorCount(256);
        for(int i = 0; i < 256; i++)
        {
            image.setColor(i, qRgb(i, i, i));
        }
        // Copy input Mat
        uchar *pSrc = mat.data;
        for(int row = 0; row < mat.rows; row ++)
        {
            uchar *pDest = image.scanLine(row);
            memcpy(pDest, pSrc, mat.cols);
            pSrc += mat.step;
        }
        return image;
    }
    // 8-bits unsigned, NO. OF CHANNELS = 3
    else if(mat.type() == CV_8UC3)
    {
        // Copy input Mat
        const uchar *pSrc = (const uchar*)mat.data;
        // Create QImage with same dimensions as input Mat
        QImage image(pSrc, mat.cols, mat.rows, mat.step, QImage::Format_RGB888);
        return image.rgbSwapped();
    }
    else if(mat.type() == CV_8UC4)
    {
        qDebug() << "CV_8UC4";
        // Copy input Mat
        const uchar *pSrc = (const uchar*)mat.data;
        // Create QImage with same dimensions as input Mat
        QImage image(pSrc, mat.cols, mat.rows, mat.step, QImage::Format_ARGB32);
        return image.copy();
    }
    else
    {
        qDebug() << "ERROR: Mat could not be converted to QImage.";
        return QImage();
    }
}
cv::Mat CameraManager::QImage2cvMat(QImage image)
{
    cv::Mat mat;
    qDebug() << image.format();
    switch(image.format())
    {
    case QImage::Format_ARGB32:
    case QImage::Format_RGB32:
    case QImage::Format_ARGB32_Premultiplied:
        mat = cv::Mat(image.height(), image.width(), CV_8UC4, (void*)image.constBits(), image.bytesPerLine());
        break;
    case QImage::Format_RGB888:
        mat = cv::Mat(image.height(), image.width(), CV_8UC3, (void*)image.constBits(), image.bytesPerLine());
        cv::cvtColor(mat, mat, CV_BGR2RGB);
        break;
    case QImage::Format_Indexed8:
        mat = cv::Mat(image.height(), image.width(), CV_8UC1, (void*)image.constBits(), image.bytesPerLine());
        break;
    }
    return mat;
}


void CameraManager::init()
{
    cameraInfoUpdate();
    m_pImageProvider = new ImageProvider();
    m_pFramcap = new cv::VideoCapture;

    connect(this,&CameraManager::sigUpdate,this,[=](){
        if(m_cameraState){
           //这样处理是因为m_cameraState在主线程改变的时候,若m_cameraState在子线程访问发送sigSendImgUpdate()会崩溃
           //sigSendImgUpdate()刷新主线程最好放在主线程处理
           emit sigSendImgUpdate();
        }
    });


    connect(this,&CameraManager::sigSendServerImg,this,[=](QImage* img){
        m_baiduCheack->onSendServerImg(img);
    });
}

void CameraManager::DetectFace(cv::Mat& img,cv::Mat& imgGray,bool&  hasFace) {
//    namedWindow("src", cv::WINDOW_AUTOSIZE);
    vector<cv::Rect> faces, eyes;
    m_pFaceCascade.detectMultiScale(imgGray, faces, 1.2, 5, 0, cv::Size(30, 30));
#if 0
    for (auto b : faces) {
        cout << "输出一张人脸位置：(x,y):" << "(" << b.x << "," << b.y << ") , (width,height):(" << b.width << "," << b.height << ")" << endl;
    }
 #endif
    if (faces.size()>0) {
        hasFace = true;
        for (size_t i = 0; i<faces.size(); i++) {
            putText(img, "made by LLS", cvPoint(faces[i].x, faces[i].y - 10), cv::FONT_HERSHEY_PLAIN, 2.0, cv::Scalar(0, 0, 255));

            rectangle(img, cv::Point(faces[i].x, faces[i].y), cv::Point(faces[i].x + faces[i].width, faces[i].y + faces[i].height), cv::Scalar(0, 0, 255), 1, 8);
#if 0
            cout << faces[i] << endl;
#endif
            //将人脸从灰度图中抠出来
            cv::Mat face_ = imgGray(faces[i]);
            m_pAreCascade.detectMultiScale(face_, eyes, 1.2, 2, 0, cv::Size(30, 30));
            for (size_t j = 0; j < eyes.size(); j++) {
               cv:: Point eye_center(faces[i].x + eyes[j].x + eyes[j].width / 2, faces[i].y + eyes[j].y + eyes[j].height / 2);
                int radius = cvRound((eyes[j].width + eyes[j].height)*0.25);
                cv::circle(img, eye_center, radius, cv::Scalar(65, 105, 255), 4, 8, 0);
            }
        }
    }
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

