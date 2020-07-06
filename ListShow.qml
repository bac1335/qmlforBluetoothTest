import QtQuick 2.0

Item {
    id: root
    ListView{
        anchors.fill: parent
        delegate: component
        model: listModel

    }

    Component{
        id: component
        Item{
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
        }
    }

    ListModel{
        id: listModel
        ListElement{
            name: "4532"
        }
        ListElement{
            name: "1123"
        }
        ListElement{
            name: "2222"
        }
        ListElement{
            name: "1123"
        }
        ListElement{
            name: "1123"
        }
        ListElement{
            name: "1123"
        }
        ListElement{
            name: "411231"
        }
    }

    function addList(addName){
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
}
