
LIBS += -L$$PWD/lib/ -ljsoncpp
INCLUDEPATH += $$PWD/include/json $$PWD/include/

HEADERS += \
    $$PWD/include/json/allocator.h \
    $$PWD/include/json/assertions.h \
    $$PWD/include/json/autolink.h \
    $$PWD/include/json/config.h \
    $$PWD/include/json/forwards.h \
    $$PWD/include/json/json.h \
    $$PWD/include/json/json_features.h \
    $$PWD/include/json/reader.h \
    $$PWD/include/json/value.h \
    $$PWD/include/json/version.h \
    $$PWD/include/json/writer.h
