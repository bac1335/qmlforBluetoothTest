#ifndef CAMERAMANAGER_H
#define CAMERAMANAGER_H

/**
    * @projectName   facedetection
    * @brief         获取摄像头帧数进行处理每一帧数据
    */

#include <QObject>
#include <QCameraInfo>
#include <QtQuick/QQuickImageProvider>

class QCamera;
class CvCapture;
class ImageProvider;
class CameraManager : public QObject{
    Q_OBJECT
public:
    struct CameraType{
        QString deviceName;
        QString description;
        QCamera::Position position;
    };

    explicit CameraManager(QObject* parent = nullptr);
    void  cameraInfoUpdate();
    ImageProvider* getImgProvider(){return m_pImageProvider.data();}

    Q_INVOKABLE QVariantList cameraDeviceList(int type);
    Q_INVOKABLE bool openCamera();
    Q_INVOKABLE bool stopCamera();

protected:
    void timerEvent(QTimerEvent *event);

private:
    void init();
    inline void doTimeOut();

signals:
    void sigSendImgUpdate();

private:
    QCamera*            m_camara = nullptr;
    QList<QString>      m_camaraList;
    QList<CameraType>   m_deviceList;
    CvCapture*          m_pCam = nullptr;// 视频获取结构， 用来作为视频获取函数的一个参数
    int                 m_iTimeFlag = -1;
    QSharedPointer<ImageProvider>      m_pImageProvider;
};


class ImageProvider : public QQuickImageProvider{
public:
    ImageProvider(): QQuickImageProvider(QQmlImageProviderBase::Image){}

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
