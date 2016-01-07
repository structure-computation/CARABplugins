# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.
class BrideICA2Item extends TreeItem
    constructor: ( name = "Donnees Geometriques" ) ->
        super()

        @_name.set name
        @_viewable.set false
        
        @add_attr                                # Tous les parametres
            bridesup :                                      # Parametres de la Bride et de la Virole Superieur
                D_ext_plaque                : new Val 86
                D_int_plaque                : new Val 57
                h_plaque                    : new Val 3
                D_ext_tube                  : new Val 61
                D_int_tube                  : new Val 57.1
                h_tube_incline              : new Val 60
                angle_tube_incline          : new Val 0
                h_tube                      : new Val 56
                
            brideinf :                                      # Parametres de la Bride et de la Virole Inferieur
                D_ext_plaque                : new Val 86
                D_int_plaque                : new Val 57
                h_plaque                    : new Val 3
                D_ext_tube                  : new Val 61
                D_int_tube                  : new Val 57.1
                h_tube_incline              : new Val 60
                angle_tube_incline          : new Val 0
                h_tube                      : new Val 56
            
            boulon :                                        # Parametres du Trou et du Boulon
                diametre_nominal            : new Val 5
                diametre_tete               : new Val 8.3
                diametre_implantation       : new Val 74
                longueur_filetee            : new Val 0
                longueur_non_filetee        : new Val 6
                nombre_de_fixations         : new Val 20
                diametre_trou_passage       : new Val 5.4
                hauteur_tete                : new Val 5
                
            materiaux :                                     # Parametres des Materiaux
                E_bride_sup                 : new Val 205000
                poisson_bride_sup           : new Val 0.3
                E_bride_inf                 : new Val 205000
                poisson_bride_inf           : new Val 0.3
                E_fixation                  : new Val 205000
                poisson_fixation            : new Val 0.3
            
            chargement :                                    # Parametres des Donnees de Chargement
                Precharge                   : new Val 4100
                Fe_tension                  : new Val 10000
                Pas_de_chargement           : new Val 5
                
            maillage :                                      # Parametres des Donnees de Maillage
                Taille_maillage_bride       : new Val 1
                Taille_maillage_virole      : new Val 5
            
            figures :                                       # Parametres des Donnees de Figures
                Amplification_deplacement   : new Val 1
       
       
        # Appel des differentes Classes + nom + les parametres
        
        @add_child new BICA2_BrideSupItem "Bride Superieur", @parameters
        @add_child new BICA2_BrideInfItem "Bride Inferieur", @parameters
        @add_child new BICA2_BoulonItem "Boulon", @parameters
        @add_child new BICA2_MateriauxItem "Donnees Materiaux", @parameters
        @add_child new BICA2_LoadsItem "Donnees Chargement", @parameters
        @add_child new BICA2_MaillagePourMatlabItem "Parametre de Maillage", @parameters
        @add_child new BICA2_FiguresItem "Parametre des Figures", @parameters