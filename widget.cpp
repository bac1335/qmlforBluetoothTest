#include "widget.h"
#include <QDebug>
#include <QQmlApplicationEngine>
#include "llscontrol.h"

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
    m_pEngle->load(QUrl("qrc:/qml/main.qml"));

    m_pLLsManager = new LLSControlManager(m_pEngle,this);
}
