import QtQuick 2.0

Item {
    property int  pageType: config.pageType_booth
    signal switchPage(int pageType)
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
            if(btnType === config.btnTypeShowBluetooth){
               rootList.doClick(btnType)
            }
            else if(btnType === config.btnTypeShowBaiduFace){
               switchPage(config.pageType_baiduFace)
            }
        }
    }

    Connections{
        target: window
        onGetDevice:{
            rootList.addList(str)
        }
    }
}
