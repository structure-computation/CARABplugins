#include <iostream>
#include <qglobal.h>
#include "Launcher.h"



Launcher::Launcher(){  
    increment = 0;
};

Launcher::~Launcher(){
    qDebug() << "CLOSE LOOP";
};


void Launcher::launch(SodaClient::Event event){
    if(event.event_num == 1){  //evennement issu du timer
        MP input = mp_list[0];
        MP children = input["_children"];

        if (increment % 3 == 0){
            input["menu_background"] = "#ffffff";
        }
        else if (increment % 3 == 1){
            input["menu_background"] = "#ececec";
        }
        else {
            input["menu_background"] = "#4dbce9";
        }
        qDebug() << "input : " << input["menu_background"];
//      qDebug() << "input : " << children[0]["_name"];

        increment++;

        input.flush();
    }

    if(event.event_num != 1){  //evennement issu d'une modification de l'objet sur le serveur
        MP input = event.mp();
    }
};


