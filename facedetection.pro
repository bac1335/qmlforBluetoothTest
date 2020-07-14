#-------------------------------------------------
#
# Project created by QtCreator 2020-07-06T20:09:17
#
#-------------------------------------------------

QT       += core gui bluetooth qml
QT       += multimedia
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

include($$PWD/baiduface/baiduface.pri)
include($$PWD/ToolManager/ToolManager.pri)

INCLUDEPATH += ToolManager baiduface controlmanager bluetooth tool
CONFIG(release,release|debug){
    DESTDIR += $$PWD/bin/
}
MOC_DIR += $$PWD/tem/
OBJECTS_DIR += $$PWD/tem/

TARGET = facedetection
TEMPLATE = app

RC_FILE += logo.rc
# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CONFIG += c++11

SOURCES += \
        controlmanager/baidufacemanager.cpp \
        controlmanager/boothmanager.cpp \
        controlmanager/cameramanager.cpp \
        controlmanager/llscontrol.cpp \
        main.cpp \
        tool/llsetting.cpp \
        tool/llsnetworkdetection.cpp \
        widget.cpp

HEADERS += \
        controlmanager/baidufacemanager.h \
        controlmanager/boothmanager.h \
        controlmanager/cameramanager.h \
        controlmanager/llscontrol.h \
        tool/llsetting.h \
        tool/llsnetworkdetection.h \
        widget.h

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES +=

RESOURCES += \
    qml.qrc
