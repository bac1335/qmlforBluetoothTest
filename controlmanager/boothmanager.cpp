#include "boothmanager.h"
#include <QDebug>

BoothManage::BoothManage(QObject *parent):
    QObject (parent)
{
    init();
}

void BoothManage::startDisCoverBlueTooth()
{
    m_pBoothtooth->start();
}

void BoothManage::stopDisCoverBlueTooth()
{
//    m_pBoothtooth->stop();
}

void BoothManage::onDeviceDiscovered(const QBluetoothDeviceInfo &info)
{
    BluetoothDevice device;
    device.name = info.name();
    device.address = info.address();
    emit sigDeviceName(device.name);
    m_deviceList.push_back(device);
}

void BoothManage::init()
{
    m_pBoothtooth = new QBluetoothDeviceDiscoveryAgent(this);
    connect(m_pBoothtooth,&QBluetoothDeviceDiscoveryAgent::deviceDiscovered,this,&BoothManage::onDeviceDiscovered);
}
