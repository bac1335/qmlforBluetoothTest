import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12

Button{
    id: buttonCom
    width: 100
    height: 60
    property int  btnType: config.btnType
    signal showListClicked(int btnType)
    style: ButtonStyle{
        background: Rectangle{
            implicitWidth: 20
            implicitHeight: 20
            radius: 10
            border.width: control.pressed ? 2 : 1
            border.color: control.pressed ? "#aaa" : "#eee"
            layer.enabled: true
            layer.effect: DropShadow {
                //                   transparentBorder: true
                //                   samples: 20
                radius: 8
                samples: 17
                horizontalOffset: 5
                verticalOffset: 10
                spread: 0

            }

        }
    }
    Text {
        id: buttonText
        anchors.centerIn: parent
        text: qsTr("show")
        font.family: "微软雅黑"
        font.pixelSize: 15
    }
    onClicked: showListClicked(btnType)

    function setBtnType(str,type){
        buttonText.text = str
        buttonCom.btnType = type
    }
}

