#include <QApplication>
#include <QFont>
#include <QFile>

#include <Soca/Com/SodaClient.h>
#include <QtCore/QProcess>
#include <QtCore/QList>
#include <QtCore/QTimer>

#include "config.h"
#include "Launcher.h"


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    SodaClient::_nb_inst = 1;

// ouverture du fichier de configuration du plugin. ce fichier contient, l'IP serveur, le port, le conteneur de donnée auquel l'application doit s'inscrire
    config conf;
    conf.read_config();

// préparation de la connection au serveur et au container de données
    //instantiation du client Soda et du container de données
    QHostAddress adress1(conf.IP);                                  //adresse du serveur
    SodaClient* sc = new SodaClient( adress1, conf.port.toInt() );  //connection des client Soda avec le port
    MP object_id = sc->load(conf.data_container);                   //connection au container de données et référencement de son id temporaire
//    qDebug() << object_id;

// liste des objets suivits
    //initialisation du laucher d'application a personnalisé
    Launcher *launcher = new Launcher();
    launcher->sc = sc;
    launcher->mp_list << object_id;                                  //ajout de l'id dans la liste des objets suivits
    sc->reg_model( object_id );                                      //inscription en tant qu'observateur de l'objet d'administration global


//    launcher->get_files();                                           //ajout des devices dans la liste des objets a mettre à jour
//    for( int i = 0; i < launcher->mp_input_list.size(); ++i ) {      //ajout de tous les objets input observés (conteneur de données devices)
//        sc->reg_model( launcher->mp_input_list[i] );
//    }


    QObject::connect(sc, SIGNAL(new_event(SodaClient::Event)), launcher, SLOT(launch(SodaClient::Event)));    //inscription d'un evennement launch lors d'un signal venant de l'objet
    QObject::connect(sc, SIGNAL(quit()), &app, SLOT(quit()));                                                 //fin du programme lorsqu'un serveur s'éteint


    //ajout de tâche planifiées avec un timer
    QTimer *timer = new QTimer();
    QObject::connect(timer, SIGNAL(timeout()), sc, SLOT(force_callback( )));
    timer->start(3000);


// lancement de la boucle d'evennement
    return app.exec();

};
