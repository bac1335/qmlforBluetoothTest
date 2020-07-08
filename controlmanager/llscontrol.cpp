#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "llscontrol.h"
#include "boothmanager.h"
#include "baidufacemanager.h"

LLSControlManager::LLSControlManager(QQmlApplicationEngine* engine,QObject *parent):
    QObject (parent),m_pEngine(engine)
{
    init();
}

void LLSControlManager::init()
{

    m_pBoothManager = new BoothManage(this);
    connect(m_pBoothManager,SIGNAL(sigDeviceName(QString)),m_pEngine->rootObjects().first(),SIGNAL(getDevice(QString)));
    m_pEngine->rootContext()->setContextProperty("BluetoothManager",m_pBoothManager);

    m_pBaiduFaceManage = new BaiduFaceManager(this);
    m_pEngine->rootContext()->setContextProperty("BaiduFaceManager",m_pBaiduFaceManage);
}
