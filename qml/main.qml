import QtQuick 2.0
import QtQuick.Window 2.12


Window{
    id: window
    width: config.windowsWidth
    height: config.windowsHeight
    color: config.bgColor
    visible: true
    signal getDevice(string str);

    QtConfig{
        id:config
    }

    BluetoothBody{
        id: rootBody
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: window.width - rootList.width
    }

    BluetoothList{
        id: rootList
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 0
    }

    ConnectionsAddr{
        id: connections
    }
}
