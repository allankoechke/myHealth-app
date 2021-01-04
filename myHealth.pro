QT += quick positioning network widgets sql

android{
    QT += androidextras
}

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        cpp/main.cpp \
        cpp/qmlinterface.cpp \
        cpp/serialportinterface.cpp \
        cpp/socketclientinterface.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

ANDROID_ABIS = armeabi-v7a x86 x86_64

HEADERS += \
    cpp/WebInterfaceRunnable.h \
    cpp/databaseinterface.h \
    cpp/qmlinterface.h \
    cpp/serialportinterface.h \
    cpp/socketclientinterface.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    cpp/QmlInterface.qml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
android: include(/home/koech/Android/Sdk/android_openssl/openssl.pri)
