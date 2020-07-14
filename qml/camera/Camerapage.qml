import QtQuick 2.0
import QtMultimedia 5.12

Item{
    id: rootPage
    anchors.fill: parent
    Item{
        id: videoRect
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height*4/5
        width: parent.width


         Loader {
             id:cameraLoad
             property bool isFirst: true
             property bool isPlayed: true
             anchors.fill: parent
         }


        Component{
            id: cameraCom
            Item {
                Camera {
                    id: camera

                    imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

                    exposure {
                        exposureCompensation: -1.0
                        exposureMode: Camera.ExposurePortrait
                    }

                    flash.mode: Camera.FlashRedEyeReduction

                    imageCapture {

                        onImageCaptured: {
                            photoPreview.source = preview  // Show the preview in an Image
//                            var str = BaiduFaceManager.start(preview)
//                            if(str !== "" && str !== "-1"){
////                                facePage.doJsonData(str,isAdd,strpath)
//                           }
                        }

                    }
                    }


                MouseArea{
                    anchors.fill: parent;
                    onClicked:camera.imageCapture.capture();

                }

                VideoOutput {
                    source: camera
                    anchors.fill: parent
                    focus : visible // to receive focus and capture key events when visible
                }

                Image {
                    anchors.fill: parent
                    id: photoPreview
                }

                function start(){
                    camera.start()
                }
                function stop(){
                    camera.stop()
                }
            }
        }
    }


    Cameratoolbar{
        id: toolBar
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.top: videoRect.bottom
    }

    Connections{
        target: toolBar
        onSigBtnClick:{
            console.log("=============================== + " + type)
            if(config.btnTypeCameraPlay == type){
                if(cameraLoad.isFirst){
                    cameraLoad.isFirst = false
                    cameraLoad.sourceComponent = cameraCom
                }
                else{
                    if(cameraLoad.isPlayed){
                        cameraLoad.item.stop()
                    }
                    else{
                        cameraLoad.item.start()
                    }

                    cameraLoad.isPlayed = !cameraLoad.isPlayed
                }
            }
        }


    }
}
