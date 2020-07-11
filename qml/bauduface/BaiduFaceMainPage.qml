import QtQuick 2.0
import QtQuick.Dialogs 1.0
import ".././button"

Item {
    property int  pageType: config.pageType_baiduFace
    signal sigReturnClicked()
    signal sigImgPreview(string strpath)
    Flow{
        id: imgShow
        spacing: 10
        anchors.fill: parent
        anchors.margins: 20
    }


    FileDialog {
        id: fileDialog
        title: "请选择一张图片"
        folder: shortcuts.home
        nameFilters: [ "*.jpg *.png"]
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
            sigImgPreview(fileDialog.fileUrl.toString())

            doChoiceImg(fileDialog.fileUrl)
        }
        onRejected: {
            console.log("Canceled")
        }
    }


    Rectangle{
        id: showFlag
        width: 45
        height: parent.height
        anchors.left: parent.left
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#242424" }
            GradientStop { position: 1.0; color: "#444" }
        }
        opacity: 0
    }

    Image{
        id: leftBtn
        width: 25
        height: 50
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        source: "qrc:/skin/button/turnLeft.png"
        opacity: 0.3

        MouseArea{
            cursorShape:Qt.DragCopyCursor
//            acceptedButtons: Qt.NoButton
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {
                leftBtn.opacity = 0.8
                showFlag.opacity = 0.5
            }

            onExited: {
                leftBtn.opacity = 0.3
                showFlag.opacity = 0
            }

            onPressed: {
                leftBtn.opacity = 0.9
                showFlag.opacity = 0.9
            }

            onReleased: {
                if(showFlag.opacity != 0){
                    leftBtn.opacity = 0.8
                    showFlag.opacity = 0.5
                }
            }

            onClicked: {
                sigReturnClicked()
                console.log("trun_home_page")
            }
        }
    }

    LLSBUtton{
        id: faceshowBtn
        opacity: 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        Component.onCompleted:{
            faceshowBtn.setBtnType("添加",config.btnTypeshiwFace)
        }

        Connections{
            target: faceshowBtn
            onShowListClicked:{
                 fileDialog.open()
            }
        }

    }

    Component{
        id: imgDelete
        Image {
            id: imgshowDelete
            width: 150
            height: 150

            MouseArea{
                onClicked: {

                }
            }
            Component.onCompleted: {
//                    imgshowDelete.source = "qrc:/skin/photo_error.png"
            }
            function setImage(imgpath){
                imgshowDelete.source = imgpath
            }
        }
    }

    function doChoiceImg(img){

        var path = qsTr(img.toString())
        if(path == "") return
        var obj = imgDelete.createObject(imgShow);
        console.log("=================================" + path)
        obj.setImage(path)
    }
}
