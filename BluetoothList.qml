import QtQuick 2.0

Rectangle{
    id: root
    color: "#424242"
    property bool aniState: false
    property int  with_: 0
    property bool isLooking: false

    ListShow{
       id: listShow
       anchors.fill: parent
    }


    NumberAnimation on width {
        id: widthAni
        from: aniState? 0 : 240
        to: aniState? 240 : 0
        duration: 500
        running: false
    }

    function doClick(){
        if(!widthAni.running){
            aniState = !aniState;
            if(aniState && !isLooking){
                isLooking= false
                BtoothManager.startDisCoverBlueTooth()
            }
            else{
//                BtoothManager.stopDisCoverBlueTooth()
//                listShow.removeAll()
            }

            widthAni.start()
        }
    }

    function addList(str){
        listShow.addList(str)
    }
}
