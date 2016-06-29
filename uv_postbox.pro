TEMPLATE = app
TARGET = uv_postbox

QT += quick bluetooth positioning location texttospeech

# Input
HEADERS += deviceinfo.h \
           uvFurniture.h \
    contact.h \
    calendar.h \
    calendarevent.h
SOURCES += deviceinfo.cpp \
           uvFurniture.cpp \
           main.cpp \
    contact.cpp \
    calendarevent.cpp \
    calendar.cpp

OTHER_FILES += assets/*.qml \
               assets/tags/*.qml \
               assets/*.js

RESOURCES += \
             resources.qrc \
    i18n/i18n.qrc

INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    assets/tags/bus_station.qml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

TRANSLATIONS    = i18n/uvFurniture_en.ts \
                  i18n/uvFurniture_fr.ts \
                  i18n/uvFurniture_de.ts \
                  i18n/uvFurniture_zh.ts

lupdate_only {
    SOURCES = $$OTHER_FILES
}

CODECFORSRC     = UTF-8
