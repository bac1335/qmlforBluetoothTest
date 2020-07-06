#ifndef WIDGET_H
#define WIDGET_H
#include <QBluetoothDeviceDiscoveryAgent>
#include <QObject>

class QQmlApplicationEngine;
class Widget : public QObject
{
    Q_OBJECT

public:
    Widget(QObject *parent = 0);
    ~Widget();

private slots:
    void onBluetoothDiscover(QBluetoothDeviceInfo);

private:
    void init();

private:
    QQmlApplicationEngine*      m_pEngle = nullptr;

};

#endif // WIDGET_H
