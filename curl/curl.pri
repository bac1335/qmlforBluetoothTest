
LIBS += -L$$PWD/lib/ -llibcurl_a
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
