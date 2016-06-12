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
               assets/*.js

RESOURCES += \
             resources.qrc

INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
#    android/build.gradle \

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
