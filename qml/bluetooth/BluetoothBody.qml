import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import "../button"

Item {
   id: root
   signal showListClicked(int btnType)

   Column{
       anchors.centerIn: parent
       spacing: 50
       LLSBUtton{
           id:showBooth
           Component.onCompleted: {
              showBooth.setBtnType(/*"showBlue"*/"蓝牙",config.btnTypeShowBluetooth)
           }
           Connections{
               target: showBooth
               onShowListClicked:{
                   showListClicked(btnType)
               }
           }
       }
       LLSBUtton{
           id: showBaiduFace
           Component.onCompleted: {
              showBaiduFace.setBtnType(/*"showFace"*/"人脸识别",config.btnTypeShowBaiduFace)
           }
           Connections{
               target: showBaiduFace
               onShowListClicked:{
                   showListClicked(btnType)
               }
           }
       }
   }
}
