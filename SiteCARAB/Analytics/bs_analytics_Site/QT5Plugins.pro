#-------------------------------------------------
#
# Project created by QtCreator 2014-12-02T14:11:46
#
#-------------------------------------------------

QT      += core
QT      += network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = ana_site
TEMPLATE = app


SOURCES += main.cpp\
    Soca/Com/ClientLoop.cpp \
    Soca/Com/SodaClient.cpp \
    Soca/Database/Database.cpp \
    Soca/Model/Bool.cpp \
    Soca/Model/Directory.cpp \
    Soca/Model/Lst.cpp \
    Soca/Model/LstWithType.cpp \
    Soca/Model/Model.cpp \
    Soca/Model/ModelWithAttr.cpp \
    Soca/Model/ModelWithAttrAndName.cpp \
    Soca/Model/Path.cpp \
    Soca/Model/Ptr.cpp \
    Soca/Model/Str.cpp \
    Soca/Model/Val.cpp \
    Soca/Sys/BinRd.cpp \
    Soca/MP.cpp \
    Soca/Updater.cpp \
    config.cpp \
    Launcher.cpp \

HEADERS  += \
    Soca/Com/ClientLoop.h \
    Soca/Com/ClientLoop_parser.h \
    Soca/Com/SodaClient.h \
    Soca/Database/Database.h \
    Soca/Model/Bool.h \
    Soca/Model/Directory.h \
    Soca/Model/Lst.h \
    Soca/Model/LstWithType.h \
    Soca/Model/Model.h \
    Soca/Model/ModelWithAttr.h \
    Soca/Model/ModelWithAttrAndName.h \
    Soca/Model/Path.h \
    Soca/Model/Ptr.h \
    Soca/Model/Str.h \
    Soca/Model/TypedArray.h \
    Soca/Model/Val.h \
    Soca/Sys/BinOut.h \
    Soca/Sys/BinRd.h \
    Soca/Sys/S.h \
    Soca/MP.h \
    Soca/Updater.h \
    Launcher.h \
    config.h \

OTHER_FILES += \
    pluggin.conf \
    README.txt

INCLUDEPATH += /usr/include/python2.7
LIBS += -lpython2.7

