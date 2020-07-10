import QtQuick 2.0
import ".././button"

Item {
    property int  pageType: config.pageType_baiduFace
    Text {
        anchors.centerIn: parent
        text: qsTr("text")
    }
    LLSBUtton{
        id: faceshowBtn
        anchors.centerIn: parent
        Component.onCompleted:{
            faceshowBtn.setBtnType("showFace",config.btnTypeshiwFace)
        }

    }
}
