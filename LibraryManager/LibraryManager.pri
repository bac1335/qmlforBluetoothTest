######################################
#@brief         c++库的集合
#@date          2020-07-20
######################################

INCLUDEPATH += $$PWD

include($$PWD/curl_x86-windows/curl.pri)
include($$PWD/jsoncpp_x86-windows/jsoncpp.pri)
include($$PWD/openssl-windows_x86-windows/openssl.pri)
win32 {
    CONFIG(release, debug|release) {
       include($$PWD/opencv/opencv.pri)
    }
}
