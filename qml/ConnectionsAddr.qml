import QtQuick 2.0

Item{
    Connections{
        target: rootBody
        onShowListClicked:{
           rootList.doClick(btnType)
        }
    }

    Connections{
        target: window
        onGetDevice:{
            rootList.addList(str)
        }
    }
}
