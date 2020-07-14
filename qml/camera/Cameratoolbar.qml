import QtQuick 2.0

Item {
    id: root
    Rectangle{
        anchors.fill: parent
        color: "red"
    }

    Item {
        id: locatorItem
        width: box1.width + box2.width + box3.width + 15*2
        height: box1.height
        anchors.centerIn: parent

        Row{
           id: row
           anchors.fill: parent
           spacing: 15

           Loader{
               id: box1
               sourceComponent: boxItem
           }

           Loader{
               id: box2
               sourceComponent: boxItem
           }

           Loader{
               id: box3
               sourceComponent: boxItem
           }

        }

        Component{
            id: boxItem
            Rectangle{
               width: 60
               height: 60
               radius: 60
               color: "yellow"
            }
        }

    }
}
