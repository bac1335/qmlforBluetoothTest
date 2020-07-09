#/*
#     @projectName  bluetoothtest
#     @brief        LibCurl是免费的客户端URL传输库，支持FTP,FTPS, HTTP, HTTPS, SCP, SFTP, TFTP, TELNET, DICT, FILE ，LDAP等协议，
#                   其主页是http://curl.haxx.se/。具备线程安全与IPv6兼容
#     @date         2020-07-08
#     ps: 支持vs2017编译器,其它编译器支持需在github下载进行重新cmake
#*/
CONFIG(release,debug|release)
{
    win32:LIBS += -L$$PWD/lib/ -llibcurl
}

CONFIG(debug,debug|release)
{
    win32:LIBS += -L$$PWD/debug/lib/ -llibcurl
}

INCLUDEPATH += $$PWD/include/curl $$PWD/include/

HEADERS += \
    $$PWD/include/curl/curl.h \
    $$PWD/include/curl/curlver.h \
    $$PWD/include/curl/easy.h \
    $$PWD/include/curl/mprintf.h \
    $$PWD/include/curl/multi.h \
    $$PWD/include/curl/stdcheaders.h \
    $$PWD/include/curl/system.h \
    $$PWD/include/curl/typecheck-gcc.h \
    $$PWD/include/curl/urlapi.h
