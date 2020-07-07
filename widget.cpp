#include "widget.h"
#include <QDebug>
#include <QQmlApplicationEngine>
#include "boothmanager.h"
#include <QQmlContext>

Widget::Widget(QObject *parent)
    : QObject(parent)
{
    init();
}

Widget::~Widget()
{

}


void Widget::init()
{
    m_pEngle = new QQmlApplicationEngine(this);
    m_pEngle->load(QUrl("qrc:/main.qml"));

    m_pBoothManager = new BoothManage(this);
    connect(m_pBoothManager,SIGNAL(sigDeviceName(QString)),m_pEngle->rootObjects().first(),SIGNAL(getDevice(QString)));
    m_pEngle->rootContext()->setContextProperty("BtoothManager",m_pBoothManager);

}
