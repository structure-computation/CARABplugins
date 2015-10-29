/****************************************************************************
** Meta object code from reading C++ file 'ClientLoop.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.2.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "Soca/Com/ClientLoop.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'ClientLoop.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.2.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_ClientLoop_t {
    QByteArrayData data[12];
    char stringdata[116];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    offsetof(qt_meta_stringdata_ClientLoop_t, stringdata) + ofs \
        - idx * sizeof(QByteArrayData) \
    )
static const qt_meta_stringdata_ClientLoop_t qt_meta_stringdata_ClientLoop = {
    {
QT_MOC_LITERAL(0, 0, 10),
QT_MOC_LITERAL(1, 11, 12),
QT_MOC_LITERAL(2, 24, 0),
QT_MOC_LITERAL(3, 25, 5),
QT_MOC_LITERAL(4, 31, 6),
QT_MOC_LITERAL(5, 38, 10),
QT_MOC_LITERAL(6, 49, 6),
QT_MOC_LITERAL(7, 56, 5),
QT_MOC_LITERAL(8, 62, 9),
QT_MOC_LITERAL(9, 72, 12),
QT_MOC_LITERAL(10, 85, 19),
QT_MOC_LITERAL(11, 105, 9)
    },
    "ClientLoop\0disconnected\0\0_load\0Model*\0"
    "n_callback\0_model\0_type\0readyRead\0"
    "aboutToClose\0readChannelFinished\0"
    "send_data\0"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ClientLoop[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       8,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   54,    2, 0x06,
       3,    2,   55,    2, 0x06,
       6,    1,   60,    2, 0x06,
       7,    1,   63,    2, 0x06,

 // slots: name, argc, parameters, tag, flags
       8,    0,   66,    2, 0x08,
       9,    0,   67,    2, 0x08,
      10,    0,   68,    2, 0x08,
      11,    0,   69,    2, 0x08,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 4, QMetaType::Int,    2,    5,
    QMetaType::Void, 0x80000000 | 4,    2,
    QMetaType::Void, QMetaType::ULongLong,    2,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

       0        // eod
};

void ClientLoop::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        ClientLoop *_t = static_cast<ClientLoop *>(_o);
        switch (_id) {
        case 0: _t->disconnected(); break;
        case 1: _t->_load((*reinterpret_cast< Model*(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 2: _t->_model((*reinterpret_cast< Model*(*)>(_a[1]))); break;
        case 3: _t->_type((*reinterpret_cast< quint64(*)>(_a[1]))); break;
        case 4: _t->readyRead(); break;
        case 5: _t->aboutToClose(); break;
        case 6: _t->readChannelFinished(); break;
        case 7: _t->send_data(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (ClientLoop::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&ClientLoop::disconnected)) {
                *result = 0;
            }
        }
        {
            typedef void (ClientLoop::*_t)(Model * , int );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&ClientLoop::_load)) {
                *result = 1;
            }
        }
        {
            typedef void (ClientLoop::*_t)(Model * );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&ClientLoop::_model)) {
                *result = 2;
            }
        }
        {
            typedef void (ClientLoop::*_t)(quint64 );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&ClientLoop::_type)) {
                *result = 3;
            }
        }
    }
}

const QMetaObject ClientLoop::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_ClientLoop.data,
      qt_meta_data_ClientLoop,  qt_static_metacall, 0, 0}
};


const QMetaObject *ClientLoop::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ClientLoop::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_ClientLoop.stringdata))
        return static_cast<void*>(const_cast< ClientLoop*>(this));
    return QObject::qt_metacast(_clname);
}

int ClientLoop::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 8)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 8;
    }
    return _id;
}

// SIGNAL 0
void ClientLoop::disconnected()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void ClientLoop::_load(Model * _t1, int _t2)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void ClientLoop::_model(Model * _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void ClientLoop::_type(quint64 _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}
QT_END_MOC_NAMESPACE
