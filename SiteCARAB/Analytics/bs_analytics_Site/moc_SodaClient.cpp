/****************************************************************************
** Meta object code from reading C++ file 'SodaClient.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.2.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "Soca/Com/SodaClient.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'SodaClient.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.2.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_SodaClient_t {
    QByteArrayData data[16];
    char stringdata[186];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    offsetof(qt_meta_stringdata_SodaClient_t, stringdata) + ofs \
        - idx * sizeof(QByteArrayData) \
    )
static const qt_meta_stringdata_SodaClient_t qt_meta_stringdata_SodaClient = {
    {
QT_MOC_LITERAL(0, 0, 10),
QT_MOC_LITERAL(1, 11, 9),
QT_MOC_LITERAL(2, 21, 0),
QT_MOC_LITERAL(3, 22, 17),
QT_MOC_LITERAL(4, 40, 4),
QT_MOC_LITERAL(5, 45, 26),
QT_MOC_LITERAL(6, 72, 3),
QT_MOC_LITERAL(7, 76, 17),
QT_MOC_LITERAL(8, 94, 15),
QT_MOC_LITERAL(9, 110, 6),
QT_MOC_LITERAL(10, 117, 1),
QT_MOC_LITERAL(11, 119, 14),
QT_MOC_LITERAL(12, 134, 21),
QT_MOC_LITERAL(13, 156, 1),
QT_MOC_LITERAL(14, 158, 13),
QT_MOC_LITERAL(15, 172, 12)
    },
    "SodaClient\0new_event\0\0SodaClient::Event\0"
    "quit\0reg_type_callback_auto_reg\0ptr\0"
    "reg_type_callback\0change_callback\0"
    "Model*\0m\0force_callback\0load_for_reg_callback\0"
    "n\0load_callback\0disconnected\0"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_SodaClient[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   59,    2, 0x06,
       4,    0,   62,    2, 0x06,

 // slots: name, argc, parameters, tag, flags
       5,    1,   63,    2, 0x08,
       7,    1,   66,    2, 0x08,
       8,    1,   69,    2, 0x08,
      11,    0,   72,    2, 0x08,
      12,    2,   73,    2, 0x08,
      14,    2,   78,    2, 0x08,
      15,    0,   83,    2, 0x08,

 // signals: parameters
    QMetaType::Void, 0x80000000 | 3,    2,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void, QMetaType::ULongLong,    6,
    QMetaType::Void, QMetaType::ULongLong,    6,
    QMetaType::Void, 0x80000000 | 9,   10,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 9, QMetaType::Int,   10,   13,
    QMetaType::Void, 0x80000000 | 9, QMetaType::Int,   10,   13,
    QMetaType::Void,

       0        // eod
};

void SodaClient::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        SodaClient *_t = static_cast<SodaClient *>(_o);
        switch (_id) {
        case 0: _t->new_event((*reinterpret_cast< SodaClient::Event(*)>(_a[1]))); break;
        case 1: _t->quit(); break;
        case 2: _t->reg_type_callback_auto_reg((*reinterpret_cast< quint64(*)>(_a[1]))); break;
        case 3: _t->reg_type_callback((*reinterpret_cast< quint64(*)>(_a[1]))); break;
        case 4: _t->change_callback((*reinterpret_cast< Model*(*)>(_a[1]))); break;
        case 5: _t->force_callback(); break;
        case 6: _t->load_for_reg_callback((*reinterpret_cast< Model*(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 7: _t->load_callback((*reinterpret_cast< Model*(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 8: _t->disconnected(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (SodaClient::*_t)(SodaClient::Event );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&SodaClient::new_event)) {
                *result = 0;
            }
        }
        {
            typedef void (SodaClient::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&SodaClient::quit)) {
                *result = 1;
            }
        }
    }
}

const QMetaObject SodaClient::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_SodaClient.data,
      qt_meta_data_SodaClient,  qt_static_metacall, 0, 0}
};


const QMetaObject *SodaClient::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SodaClient::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_SodaClient.stringdata))
        return static_cast<void*>(const_cast< SodaClient*>(this));
    return QObject::qt_metacast(_clname);
}

int SodaClient::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 9)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 9;
    }
    return _id;
}

// SIGNAL 0
void SodaClient::new_event(SodaClient::Event _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void SodaClient::quit()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}
QT_END_MOC_NAMESPACE
