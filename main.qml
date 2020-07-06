import QtQuick 2.0
import QtQuick.Window 2.12


Window{
    id: window
    width: 860
    height: 680
    color: "#242424"
    visible: true

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

    Connections{
        target: rootBody
        onShowListClicked:{
           rootList.doClick()
        }
    }
}
