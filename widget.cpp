#include "widget.h"
#include <QDebug>
#include <QQmlApplicationEngine>

Widget::Widget(QObject *parent)
    : QObject(parent)
{
    init();
}

Widget::~Widget()
{

}


void Widget::onBluetoothDiscover(QBluetoothDeviceInfo info)
{
    qDebug() << "===================================" << info.name();
}

void Widget::init()
{
    m_pEngle = new QQmlApplicationEngine(this);
    m_pEngle->load(QUrl("qrc:/main.qml"));


    QBluetoothDeviceDiscoveryAgent* bluetooth = new QBluetoothDeviceDiscoveryAgent(this);
    connect(bluetooth,&QBluetoothDeviceDiscoveryAgent::deviceDiscovered,this,&Widget::
            onBluetoothDiscover);
    bluetooth->start();
}
