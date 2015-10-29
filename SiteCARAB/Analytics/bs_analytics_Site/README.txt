Ce connecteur simple sert de base pour la création de l'ensemble des connecteurs dédié.
Il a été testé sur ubuntu et sur raspberry

1/ creer un nouveau connecteur------------
pour créer un nouveau connecteur dédié :
    - copeir coller ce répertoire dans un nouveau répertoire "connecteur_dédié"
    - ! attention ! le répertoire Soca est un lien symbolique vers ../Soca/src/Soca. il faut copier en dur le répertoire pour avoir les source sur raspberry
    - modifier le fichier config pour vous loguer au bon serveur/port/container de données
    - ! attention ! cela suppose que vous avez une nstance de serveur sc fonctionnelle et que vous avez décrit et créer un container de données en javascript


2/ creer un container de données sur le serveur sc en javascript
