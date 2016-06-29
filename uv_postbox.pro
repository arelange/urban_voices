TEMPLATE = app
TARGET = uv_postbox

QT += quick bluetooth positioning location

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
#    android/build.gradle \

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

TRANSLATIONS    = i18n/uvFurniture_en.ts \
                  i18n/uvFurniture_fr.ts \
                  i18n/uvFurniture_de.ts \
                  i18n/uvFurniture_zh.ts

lupdate_only {
    SOURCES = $$OTHER_FILES
}

CODECFORSRC     = UTF-8

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../build-qtspeech-Desktop_Qt_$${QT_MAJOR_VERSION}_$${QT_MINOR_VERSION}_$${QT_PATCH_VERSION}_GCC_64bit-Release/lib/release/ -lQt5TextToSpeech
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../build-qtspeech-Desktop_Qt_$${QT_MAJOR_VERSION}_$${QT_MINOR_VERSION}_$${QT_PATCH_VERSION}_GCC_64bit-Debug/lib/debug/ -lQt5TextToSpeech
else:unix:CONFIG(release, debug|release): LIBS += -L$$PWD/../build-qtspeech-Desktop_Qt_$${QT_MAJOR_VERSION}_$${QT_MINOR_VERSION}_$${QT_PATCH_VERSION}_GCC_64bit-Release/lib/ -lQt5TextToSpeech
else:unix:CONFIG(debug, debug|release): LIBS += -L$$PWD/../build-qtspeech-Desktop_Qt_$${QT_MAJOR_VERSION}_$${QT_MINOR_VERSION}_$${QT_PATCH_VERSION}_GCC_64bit-Debug/lib/ -lQt5TextToSpeech

INCLUDEPATH += $$PWD/../build-qtspeech-Desktop_Qt_$${QT_MAJOR_VERSION}_$${QT_MINOR_VERSION}_$${QT_PATCH_VERSION}_GCC_64bit-Release/include
DEPENDPATH += $$PWD/../build-qtspeech-Desktop_Qt_$${QT_MAJOR_VERSION}_$${QT_MINOR_VERSION}_$${QT_PATCH_VERSION}_GCC_64bit-Release/include
