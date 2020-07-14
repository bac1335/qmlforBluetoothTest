import QtQuick 2.0

QtObject{
    property string bgColor: "#242424"
    property int  windowsWidth: 860
    property int  windowsHeight: 680

    property int  btnType: 100
    property int  btnTypeShowBluetooth: btnType + 1
    property int  btnTypeShowBaiduFace: btnType + 2
    property int  btnTypeshowCamera: btnType + 3
    property int  btnTypeshowFace: btnType + 4
    property int  btnTypeCameraPlay: btnType + 5


    property int  pageType: 1000
    property int  pageType_booth: pageType + 1
    property int  pageType_baiduFace: pageType + 2
    property int  pageType_CameraFace: pageType + 3
}
