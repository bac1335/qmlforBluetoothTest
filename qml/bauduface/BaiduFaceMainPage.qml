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
            var strpath = fileDialog.fileUrl.toString()
            console.log("You chose: " + strpath)

            var str = BaiduFaceManager.start(strpath)
            if(str !== ""){
                 facePage.doJsonData(str)
            }

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

    ListModel{
        id: listModel

        function addItem(str1,str2){
             listModel.append({name: str1,value: str2})
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

    Rectangle {
        id: preView
        anchors.fill: parent
        visible: false
        color: "#424242"
        //         opacity: 0.6

        Image {
            id: priImg
            anchors.centerIn: parent
            //             anchors.fill: parent
            //             source: "file"


            Rectangle{
                id: faceRecr
                x: 0
                y: 0
                color: "transparent"
                border.color: "red"
                border.width: 1
                width: 0
                height: 0
                rotation: 0
                visible: false
            }

        }

        Rectangle{
            id: imgDetail
            anchors.right: priImg.right
            anchors.top: priImg.top
            width: priImg.implicitWidth * 1/3
            height: /*priImg.implicitHeight * 3/5*/imgListDetial.implicitHeight
            opacity: 0.6
            color: "#808080"
            ListView{
                id: imgListDetial
//                anchors.fill: parent
                width: parent.width
                implicitHeight:30* count + 10*count
                flickableDirection: Flickable.AutoFlickDirection
                orientation: ListView.Vertical
                spacing: 10
                model: listModel
                delegate: Item{
                    width: imgDetail.width
                    height: 30
                    Row{
                        anchors.fill: parent
                        anchors.topMargin: 10
                        Text {
                            color: "red"
                            font.pixelSize: 18
                            font.family: "微软雅黑"
                            text: name + ":"
                        }
                        Text {
                            color: "red"
                            font.pixelSize: 18
                            font.family: "微软雅黑"
                            text: value
                        }
                    }
                }
            }
        }

        function clearElement(){
            listModel.clear()
        }

        function setFaceRect(x1,y1,width1,height1,rotation1){
            faceRecr.visible = true
            faceRecr.x = x1
            faceRecr.y = y1
            faceRecr.width = width1
            faceRecr.height = height1
            faceRecr.rotation = rotation1
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                preView.visible = false
                preView.clearElement()
            }
        }

        function loadImg(imgPath){
            priImg.source = imgPath
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

    Component.onCompleted: {
        return;
        var data =
                    {
                        "cached" : 0,
                        "error_code" : 0,
                        "error_msg" : "SUCCESS",
                        "log_id" : 555792018445,
                        "result" :
                        {
                            "face_list" :
                            [
                                {
                                    "age" : 23,
                                    "angle" :
                                    {
                                        "pitch" : 18.420000000000002,
                                        "roll" : -27.100000000000001,
                                        "yaw" : 5.4400000000000004
                                    },
                                    "face_probability" : 1,
                                    "face_token" : "1592af153cffde5b550141bc940c2290",
                                    "liveness" :
                                    {
                                        "livemapscore" : 0.089999999999999997
                                    },
                                    "location" :
                                    {
                                        "height" : 362,
                                        "left" : 283.41000000000003,
                                        "rotation" : -21,
                                        "top" : 295,
                                        "width" : 369
                                    }
                                }
                            ],
                            "face_num" : 1
                        },
                        "timestamp" : 1594482024
                    }


        doJsonData(data)
    }

    function doChoiceImg(img){

        var path = qsTr(img.toString())
        if(path == "") return
        var obj = imgDelete.createObject(imgShow);
        console.log("=================================" + path)
        obj.setImage(path)
    }

    function doJsonData(str){
        var obj = JSON.parse(str)

        if(obj.error_code == 0){

            preView.visible = true
            preView.loadImg(fileDialog.fileUrl.toString())
            sigImgPreview(fileDialog.fileUrl.toString())
            doChoiceImg(fileDialog.fileUrl)

            var data = (obj.result.face_list)[0]
            if(data.hasOwnProperty("face_probability")){
                console.log("===============doJsonData================== " + data.face_probability)

                if(data.hasOwnProperty("age")){
                    listModel.addItem("age", data.age)
                }
                if(data.hasOwnProperty("face_probability")){
                    listModel.addItem("face_probability", data.face_probability)
                }

                if(data.hasOwnProperty("location")){
                    var rect = data.location
                    preView.setFaceRect(rect.left,rect.top,rect.width,rect.height,rect.rotation)
                }
            }
        }
        else{
            console.log("==========================================112")
            //不是人物图像
        }

    }
}
