import QtQuick 2.0

Rectangle{
    id: root
    color: "#424242"
    property bool aniState: false
    property int  with_: 0

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

    onWidthChanged: {
        with_ = root.width;
    }

    function doClick(){
        if(!widthAni.running){
            aniState = !aniState;
            widthAni.start()
        }

        listShow.removeList("1123")
    }
}
