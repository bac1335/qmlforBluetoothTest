import QtQuick 2.0

Item {
    id: root
    ListView{
        id: listView
        visible: count>0?true:false
        anchors.fill: parent
        highlight:highlightrec
        delegate: component
        model: listModel
        currentIndex: -1
    }

    Image {
        id: loading
        width: 50
        height: 50
        anchors.centerIn: parent
        visible: listView.width>100&&listView.count<=0?true:false
        source: "qrc:/skin/loading/loading.png"

        Timer{
            interval: 5
            repeat: true
            running: loading.visible
            onTriggered: {
                loading.rotation++
            }
        }
    }

    Component{
        id: component
        Item{
            id: listItem
            width: root.width
            height: 40
            visible: width > comText.implicitWidth?true:false
            Text {
                id: comText
                anchors.centerIn: parent
                color: "white"
                text: name
                font.pixelSize: 15
                font.family: "微软雅黑"
            }

            MouseArea{
                anchors.fill: parent
                onClicked:{
                    if(listItem.ListView.view.currentIndex === index){
                       listItem.ListView.view.currentIndex = -1
                    }
                    else{
                        listItem.ListView.view.currentIndex = index
                    }
                }
            }
        }
    }

    Component{
        id:highlightrec
        Rectangle{
            width: root.width
            height: 40
            color: "gray"
            radius: 5
            border.width: 1
            border.color: "white"
        }
   }

    ListModel{
        id: listModel
    }

    function addList(addName){
        console.log("================================" + addName)
        for(var i = 0;i<listModel.count;i++){
            if(listModel.get(i).name === addName){
                return;
            }
        }
        listModel.append({name: addName})
    }

    function removeList(removeName){
        for(var i = 0;i<listModel.count;i++){
            if(listModel.get(i).name === removeName){
                listModel.remove(i)
                removeList(removeName)
                break;
            }
        }
    }

    function removeAll(){
        if(listModel.count>0){
            listModel.clear()
        }
    }
}
