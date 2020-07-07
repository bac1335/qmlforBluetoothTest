#ifndef BOOTHMANAGER_H
#define BOOTHMANAGER_H

#include <QObject>
#include <QBluetoothDeviceDiscoveryAgent>

class BoothManage : public QObject{
    Q_OBJECT
public:
    struct BluetoothDevice{
        QString name;
        QBluetoothAddress address;
    };

    explicit BoothManage(QObject* parent = nullptr);
    Q_INVOKABLE void startDisCoverBlueTooth();
    Q_INVOKABLE void stopDisCoverBlueTooth();

signals:
    void sigDeviceDiscover(const QBluetoothDeviceInfo &info);
    void sigDeviceName(QString);

private slots:
    void onDeviceDiscovered(const QBluetoothDeviceInfo &info);

private:
    void init();

private:
    QBluetoothDeviceDiscoveryAgent* m_pBoothtooth = nullptr;
    QList<BluetoothDevice>          m_deviceList;

};


#endif // BOOTHMANAGER_H
