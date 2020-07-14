import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root
    signal sigBtnClick(int type)
    Item {
        id: locatorItem
        width: box1.width + box2.width + box3.width + row.spacing * 2
        height: box1.height
        anchors.centerIn: parent

        Row{
           id: row
           anchors.fill: parent
           spacing: 50

           Loader{
               id: box1
               sourceComponent: boxItem
           }

           Loader{
               id: box2
               sourceComponent: boxItem
               Component.onCompleted: {
                   box2.item.setImageAndBtnType(":../../../../skin/toolbar/player.png",config.btnTypeCameraPlay);
               }
           }

           Loader{
               id: box3
               sourceComponent: boxItem
           }

        }

        Component{
            id: boxItem
            Item{
               id: btn
               property int  btnType: config.btnType
               width: 60
               height: 60

               Image{
                   id: img
                   anchors.fill: parent
                   source: ""
               }

               MouseArea{
                   anchors.fill: parent
                   onClicked: {
                       sigBtnClick(config.btnTypeCameraPlay)
                   }
               }

               function setImageAndBtnType(imgPath,type){
                   img.source = imgPath
                   btn.btnType = type
               }
            }
        }

    }
}
