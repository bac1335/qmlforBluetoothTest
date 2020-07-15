#ifndef WIDGET_H
#define WIDGET_H
#include <QObject>

class QQmlApplicationEngine;
class LLSControlManager;
class Widget : public QObject
{
    Q_OBJECT

public:
    Widget(QObject *parent = 0);
    ~Widget();

private:
    void init();

private:
    QQmlApplicationEngine*      m_pEngine = nullptr;
    LLSControlManager*          m_pLLsManager = nullptr;
};

#endif // WIDGET_H
