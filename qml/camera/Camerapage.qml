import QtQuick 2.0

Item{
    id: rootPage
    anchors.fill: parent
    Rectangle{
        id: videoRect
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height*4/5
        width: parent.width/2
        color: "blue"
    }

    Cameratoolbar{
        id: toolBar
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.top: videoRect.bottom
    }
}
