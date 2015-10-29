#include <Soca/Com/SodaClient.h>
#include <QtCore/QProcess>
#include <QtCore/QList>


#include <Launcher.h>

int test( int argc, char **argv ) {
  
    
    QList< QList< QString > > list_server_object; 
    
    QList< QString > list_1; list_1 << "127.0.0.1"      << "/__users__" ;
    QList< QString > list_2; list_2 << "192.168.38.238" << "/__users__" ;
    
    list_server_object << list_1 << list_2;
//     list_server_object[0] << "127.0.0.1"      << "/__users__" ;
//     list_server_object[1] << "192.168.38.238" << "/__users__" ;
    
    QList<SodaClient*> sc_list; 
    Launcher *launcher = new Launcher(sc_list);
    QEventLoop loop;
    
    qDebug() << list_server_object.size();
    sc_list.reserve(list_server_object.size());
    
    for (int i = 0; i < list_server_object.size(); ++i) {
        QHostAddress adress1(list_server_object[i][0]);  //localhost
        sc_list << new SodaClient( adress1, 8890 );
        
        MP object_id = sc_list.last()->load("/__users__");     
        qDebug() << object_id;
        sc_list.last()->reg_model( object_id ); 
        
        launcher->connect(sc_list.last(), SIGNAL(new_event()), launcher, SLOT(launch()));
        launcher->connect(sc_list.last(), SIGNAL(quit()), &loop, SLOT(quit()));
    }
    
    loop.exec();
    qDebug() << "end of loop";
  
//     // connection server 1
//     QHostAddress adress1("127.0.0.1");  //localhost
//     SodaClient sc1( adress1, 8890 );
//     if ( not sc1.connected() ) return 1;
//     
//     // connection server 2
//     QHostAddress adress2("192.168.38.238");  //sc3
//     SodaClient sc2( adress2, 8890 );
//     if ( not sc2.connected() ) return 1;
//   
//     // load object 1
//     MP object1_id = sc1.load("/__users__");     
//     qDebug() << object1_id;
//     sc1.reg_model( object1_id ); 
//     
//     // load object 2
//     MP object2_id = sc2.load("/__users__");     
//     qDebug() << object2_id;
//     sc2.reg_model( object2_id ); 
//     
//     
//     QList<SodaClient*> sc_list; 
//     sc_list.append(&sc1);
//     sc_list.append(&sc2);
//     Launcher *launcher = new Launcher(sc_list);
//     QEventLoop loop;
//     
//     launcher->connect(&sc1, SIGNAL(new_event()), launcher, SLOT(launch()));
//     launcher->connect(&sc2, SIGNAL(new_event()), launcher, SLOT(launch()));
//     QObject::connect(&sc1, SIGNAL(quit()), &loop, SLOT(quit()));
//     QObject::connect(&sc2, SIGNAL(quit()), &loop, SLOT(quit()));
// 
//     loop.exec();
//     qDebug() << "end of loop";
}
