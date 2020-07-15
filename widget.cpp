#include "widget.h"
#include <QDebug>
#include <QQmlApplicationEngine>
#include "llscontrol.h"
#include "llsnetworkdetection.h"
#include "cameramanager.h"

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
    if(LLSNDState){
        qInfo("=====================start_network_cheack===========================");
    }
    m_pLLsManager = new LLSControlManager(m_pEngine,this);
}

