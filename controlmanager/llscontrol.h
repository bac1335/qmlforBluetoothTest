#ifndef LLSCONTROL_H
#define LLSCONTROL_H

#include <QObject>
class QQmlApplicationEngine;
class BoothManage;
class BaiduFaceManager;
class CameraManager;
class LLSControlManager : public QObject{
    Q_OBJECT
public:
    explicit LLSControlManager(QQmlApplicationEngine* engine,QObject* parent = nullptr);
    ~LLSControlManager();

private:
    void init();
    //需要再QQmlApplicationEngine导入界面之前注册类型
    void registerqmlType();
     //需要再QQmlApplicationEngine导入界面之前注册信号槽
    void registerqmlConnect();

    void regisConnect();

private:
    QQmlApplicationEngine*          m_pEngine = nullptr;
    BoothManage*                    m_pBoothManager = nullptr;
    BaiduFaceManager*               m_pBaiduFaceManage = nullptr;
    CameraManager*                  m_pCameraManager = nullptr;
};

#endif // LLSCONTROL_H
