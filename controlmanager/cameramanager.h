#ifndef CAMERAMANAGER_H
#define CAMERAMANAGER_H

/**
    * @projectName   facedetection
    * @brief         获取摄像头帧数进行处理每一帧数据
    */

#include <QThread>
#include <QCameraInfo>
#include <QtQuick/QQuickImageProvider>
#include "opencv2/opencv.hpp"
#include "opencv2/videoio.hpp"

class QCamera;
class CvCapture;
class ImageProvider;
class BaiduFaceManager;
class VideoCapture;

class CameraManager : public QThread{
    Q_OBJECT
public:
    struct CameraType{
        QString deviceName;
        QString description;
        QCamera::Position position;
    };
    explicit CameraManager(QThread* parent = nullptr);
    ~CameraManager();
    void  cameraInfoUpdate();
    ImageProvider* getImgProvider(){return m_pImageProvider;}
    void setBaiduCheack(BaiduFaceManager* baidu){m_baiduCheack = baidu;};

    Q_INVOKABLE QVariantList cameraDeviceList(int type);
    Q_INVOKABLE bool openCamera();
    Q_INVOKABLE bool openVideo(QString path);
    Q_INVOKABLE bool stopCamera();

protected:
    void timerEvent(QTimerEvent *event);
    void run();

private:
    void init();
    inline void doTimeOut();
    void DetectFace(cv::Mat& img,cv::Mat& imgGray);
    inline QImage cvMat2QImage(const cv::Mat& mat);
    inline cv::Mat QImage2cvMat(QImage image);

signals:
    void sigSendImgUpdate();

private:
    QCamera*            m_camara = nullptr;
    BaiduFaceManager*   m_baiduCheack = nullptr;
    QList<QString>      m_camaraList;
    QList<CameraType>   m_deviceList;
    CvCapture*          m_pCam = nullptr;// 视频获取结构， 用来作为视频获取函数的一个参数
    int                 m_iTimeFlag = -1;
    ImageProvider*      m_pImageProvider = nullptr;
    int                 m_timerFlag = 1;
    bool                test = true;
    bool                m_cameraState = false;
    cv::VideoCapture*   m_pFramcap = nullptr;
    int                 m_videoFps = 30;   //fps
    cv::CascadeClassifier m_pFaceCascade;
    cv::CascadeClassifier m_pAreCascade;
    bool                m_useCheacked = true;
};



/**
    * @projectName   facedetection
    * @brief         摘要
    * @date          这个QQuickImageProvider对象不可以设置父类，不可用智能指针，否则析构会报错，LLSControlManager析构的时候会自动析构这个类，原因不明
    */
class ImageProvider : public QQuickImageProvider{
public:
    ImageProvider(): QQuickImageProvider(QQmlImageProviderBase::Image){}
    ~ImageProvider(){qDebug() << "--->lls<---" << __FUNCTION__ ;}
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
    {
          return QPixmap::fromImage(*m_pImg);
    }

    QImage requestImage(const QString &id, QSize *size, const QSize& requestedSize){
        return *m_pImg;
    }

    void setImg(QImage* img){
        m_pImg = img;
    }

private:
    QImage*         m_pImg = nullptr;
};

#endif // CAMERAMANAGER_H
