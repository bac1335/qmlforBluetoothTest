#ifndef WIDGET_H
#define WIDGET_H
#include <QObject>

class QQmlApplicationEngine;
class BoothManage;
class Widget : public QObject
{
    Q_OBJECT

public:
    Widget(QObject *parent = 0);
    ~Widget();

private:
    void init();

private:
    QQmlApplicationEngine*      m_pEngle = nullptr;
    BoothManage*                m_pBoothManager = nullptr;

};

#endif // WIDGET_H
