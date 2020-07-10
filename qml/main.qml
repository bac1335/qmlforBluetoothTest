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
                    stackPage.pop()
                    switch(pageType){
                        case config.pageType_booth:

                        break;
                        case config.pageType_baiduFace:
                            stackPage.replace(baiduFacePage)
                        break;
                    }
                }
            }
        }
    }

    Component{
        id: baiduFacePage
        BaiduFaceMainPage{}
    }


    StackView{
        id: stackPage
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

}
