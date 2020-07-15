#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "llscontrol.h"
#include "boothmanager.h"
#include "baidufacemanager.h"
#include "cameramanager.h"
#include <QCoreApplication>

LLSControlManager::LLSControlManager(QQmlApplicationEngine* engine,QObject *parent):
    QObject (parent),m_pEngine(engine)
{
    init();
}

void LLSControlManager::init()
{

    m_pEngine = new QQmlApplicationEngine(this);
    m_pBoothManager = new BoothManage(this);
    m_pBaiduFaceManage = new BaiduFaceManager(this);

    //需要再QQmlApplicationEngine导入界面之前注册信号槽
    registerqmlConnect();

    m_pEngine->load(QUrl("qrc:/qml/main.qml"));

    //需要再QQmlApplicationEngine导入界面之前注册类型
    registerqmlType();
}

void LLSControlManager::registerqmlType()
{
    connect(m_pBoothManager,SIGNAL(sigDeviceName(QString)),m_pEngine->rootObjects().first(),SIGNAL(getDevice(QString)));
    m_pEngine->rootContext()->setContextProperty("BluetoothManager",m_pBoothManager);
    m_pEngine->rootContext()->setContextProperty("BaiduFaceManager",m_pBaiduFaceManage);
}

void LLSControlManager::registerqmlConnect()
{
    CameraManager* m_pCameraManager = new CameraManager(this);
    m_pEngine->rootContext()->setContextProperty("CameraManager",m_pCameraManager);
    m_pEngine->addImageProvider("CodeImage",m_pCameraManager->getImgProvider());
}
