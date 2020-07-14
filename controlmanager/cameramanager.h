#ifndef CAMERAMANAGER_H
#define CAMERAMANAGER_H

/**
    * @projectName   facedetection
    * @brief         获取摄像头帧数进行处理每一帧数据
    */

#include <QObject>
#include <QCameraInfo>

class QCamera;
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
    Q_INVOKABLE QVariantList cameraDeviceList(int type);

private:
    void init();

private:
    QCamera*            m_camara = nullptr;
    QList<QString>      m_camaraList;
    QList<CameraType>   m_deviceList;
};


#endif // CAMERAMANAGER_H
