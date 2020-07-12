import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import "./bauduface"
import "./bluetooth"

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

    Component{
        id: mainRootPage
        MainPage{
            id: mainRoo
            Connections{
                target: mainRoo
                onSwitchPage:{
                    console.log("======================================" + pageType)
//                    pageManager.pop()
                    switch(pageType){
                        case config.pageType_booth:

                        break;
                        case config.pageType_baiduFace:
                            pageManager.replace(baiduFacePage)
                        break;
                    }
                }
            }
        }
    }

    Component{
        id: baiduFacePage
        BaiduFaceMainPage{
            id: facePage
            Connections{
                target: facePage
                onSigReturnClicked:{
                    pageManager.replace(mainRootPage)
                }
            }

            Connections{
                target: facePage
                onSigImgPreview:{
//                    preView.visible = true
//                    preView.loadImg(strpath)
//                    var str = BaiduFaceManager.start(strpath)
//                    if(str !== ""){
//                         facePage.doJsonData(str)
//                    }
                    
                }
            }
        }
    }

//静态保存页面内容方式
     SwipeView{
         id: pageManager
         anchors.fill: parent
         currentIndex: 0

         Loader{
             id: blueToothLoad
             sourceComponent: mainRootPage
         }

         Loader{
             id: baiduFaceLoad
             sourceComponent: baiduFacePage
         }


         function replace(page){

             if(page == mainRootPage){
                 pageManager.currentIndex = 0
             }
             else if(page == baiduFacePage){
                 pageManager.currentIndex = 1
             }
         }
     }

//     Rectangle {
//         id: preView
//         anchors.fill: parent
//         visible: false
//         color: "#424242"
////         opacity: 0.6

//         Image {
//             id: priImg
//             anchors.centerIn: parent
////             anchors.fill: parent
////             source: "file"
//         }

//         MouseArea{
//             anchors.fill: parent
//             onClicked: {
//                preView.visible = false
//             }
//         }

//         function loadImg(imgPath){
//             priImg.source = imgPath
//         }
//     }




/*  动态页面切换方式每次切换会重新生成相应的页面
    StackView{
        id: pageManager
        anchors.fill: parent
        initialItem: baiduFacePage
//        pushEnter: Transition {
//            id: pushEnter
//            ParallelAnimation {
//                PropertyAction { property: "x"; value: pushEnter.ViewTransition.item.pos }
//                NumberAnimation { properties: "y"; from: pushEnter.ViewTransition.item.pos + stackView.offset; to: pushEnter.ViewTransition.item.pos; duration: 400; easing.type: Easing.OutCubic }
//                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 800; easing.type: Easing.OutCubic }
//            }
//        }
//        popExit: Transition {
//            id: popExit
//            ParallelAnimation {
//                PropertyAction { property: "x"; value: popExit.ViewTransition.item.pos }
//                NumberAnimation { properties: "y"; from: popExit.ViewTransition.item.pos; to: popExit.ViewTransition.item.pos + stackView.offset; duration: 400; easing.type: Easing.OutCubic }
//                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 800; easing.type: Easing.OutCubic }
//            }
//        }
    }
*/

}
