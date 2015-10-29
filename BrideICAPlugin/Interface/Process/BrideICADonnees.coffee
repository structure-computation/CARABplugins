# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICADonnees extends TreeItem
    constructor: ( @bride_ica ) ->
        super()
        
        @_name.set "Donnees"
        @_viewable.set false
        
        @add_attr #                         Données géometriques relatives à la bride superieur 1 :
            h_plaque1 : @bride_ica.parameters.bridesup.h_plaque
            D_ext_plaque1 : @bride_ica.parameters.bridesup.D_ext_plaque
            D_int_plaque1 : @bride_ica.parameters.bridesup.D_int_plaque
            D_ext_tube1 : @bride_ica.parameters.bridesup.D_ext_tube
            D_int_tube1 : @bride_ica.parameters.bridesup.D_int_tube
            h_tube1 : @bride_ica.parameters.bridesup.h_tube
            h_tube_incline1 : @bride_ica.parameters.bridesup.h_tube_incline
            angle_tube_incline1 : @bride_ica.parameters.bridesup.angle_tube_incline
        
        @add_attr#                         Conséquences :
            D_int_base_tube_incline1 : parseFloat(@D_int_tube1 + Math.abs( Math.tan(Math.PI * @angle_tube_incline1 / 180 ) * @h_tube_incline1 ) * 2)
            
        @add_attr
            D_ext_base_tube_incline1 : @D_int_base_tube_incline1.get() + ( @D_ext_tube1.get() - @D_int_tube1.get() )
        
        @add_attr #                         Données géometriques relatives à la bride inferieur 2 :  
            h_plaque2 : @bride_ica.parameters.brideinf.h_plaque
            D_ext_plaque2 : @bride_ica.parameters.brideinf.D_ext_plaque
            D_int_plaque2 : @bride_ica.parameters.brideinf.D_int_plaque
            D_ext_tube2 : @bride_ica.parameters.brideinf.D_ext_tube
            D_int_tube2 : @bride_ica.parameters.brideinf.D_int_tube
            h_tube2 : @bride_ica.parameters.brideinf.h_tube
            h_tube_incline2 : @bride_ica.parameters.brideinf.h_tube_incline
            angle_tube_incline2 : @bride_ica.parameters.brideinf.angle_tube_incline
        
        @add_attr #                         Conséquences :
            D_int_base_tube_incline2 : parseFloat(@D_int_tube2 + Math.abs( Math.tan(Math.PI * @angle_tube_incline2 / 180 ) * @h_tube_incline2 ) * 2)
            
        @add_attr
            D_ext_base_tube_incline2 : @D_int_base_tube_incline2.get() + ( @D_ext_tube2.get() - @D_int_tube2.get() ) 
        
        @add_attr#                         Données communes aux deux brides & Données fixations :
            E_bride_sup : @bride_ica.parameters.materiaux.E_bride_sup
            nu_bride_sup : @bride_ica.parameters.materiaux.poisson_bride_sup
            E_bride_inf : @bride_ica.parameters.materiaux.E_bride_inf
            nu_bride_inf : @bride_ica.parameters.materiaux.poisson_bride_inf
            E_fixation : @bride_ica.parameters.materiaux.E_fixation
            nu_fixation : @bride_ica.parameters.materiaux.poisson_fixation
            di : @bride_ica.parameters.boulon.diametre_implantation
            nombredefixation : @bride_ica.parameters.boulon.nombre_de_fixations
            dt : @bride_ica.parameters.boulon.diametre_trou_passage
            diametre_nominal : @bride_ica.parameters.boulon.diametre_nominal
            Da : @bride_ica.parameters.boulon.diametre_tete
            longueur_non_filetee : @bride_ica.parameters.boulon.longueur_non_filetee
            longueur_filetee : @bride_ica.parameters.boulon.longueur_filetee
        
        @add_attr #                         Conséquences :
            l0 : @longueur_non_filetee + 0
            
        @add_attr
            l1 : @h_plaque1 + @h_plaque2 - @l0
            L_serree : @h_plaque1 + @h_plaque2             
            pas : 0.5
            
#                             Valeur du pas en mm, en fonction du diamètre nominal de la vis (standrard pas gros) :
                 
        if @diametre_nominal <= 3
            @pas.set 0.5
        else if @diametre_nominal <= 4
            @pas.set 0.7
        else if @diametre_nominal <= 5
            @pas.set 0.8
        else if @diametre_nominal <= 7
            @pas.set 1
        else if @diametre_nominal <= 9
            @pas.set 1.25
        else if @diametre_nominal <= 10
            @pas.set 1.5
        else if @diametre_nominal <= 10
            @pas.set 1.5
        else if @diametre_nominal <= 12
            @pas.set 1.75
        else if @diametre_nominal <= 16
            @pas.set 2
        else if @diametre_nominal <= 22
            @pas.set 2.5
        else if @diametre_nominal <= 27
            @pas.set 3
        else
            @pas.set 3.5
            
        @add_attr#                           Données de Chargement :
            Pression : 0
            precontrainte : @bride_ica.parameters.chargement.Precharge
            ForceAxiale : @bride_ica.parameters.chargement.Fe_tension
            MomentOrthoRad : 0
            
        @add_attr#                           Autres :
            calage_contact : 0
            Nombre_increments : 40
            hauteur_resultat : ( @h_plaque1 + @h_plaque2 ) / 2
            Diametre_resultat : @diametre_nominal + 0
            
            coef_mag : @bride_ica.parameters.figures.Amplification_deplacement
            maillage_bride : @bride_ica.parameters.maillage.Taille_maillage_bride
            maillage_virole : @bride_ica.parameters.maillage.Taille_maillage_virole
            _partie : new Lst
#                             Définition de la partie 1
        @_partie.push new Model
        @_partie[0].add_attr
          diametre : @diametre_nominal
          longueur : @l0
          filetage : 0
#                             Définition de la partie 2
        @_partie.push new Model
        @_partie[1].add_attr
          diametre : @diametre_nominal
          longueur : @l1
          filetage : 0
        
        @add_attr
            partie_0 : @_partie[0]
            partie_1 : @_partie[1]
            n : @_partie.length
            
#                             Recréation du Maillage en fonction de la modification d'une variable            
        @bind =>
            if @bride_ica.has_been_modified()
                @compute()
                
    compute: (  ) ->

        @D_int_base_tube_incline1.set parseFloat(@D_int_tube1.get() + Math.abs( Math.tan(Math.PI * @angle_tube_incline1.get() / 180 ) * @h_tube_incline1.get() ) * 2)
        @D_ext_base_tube_incline1.set @D_int_base_tube_incline1.get() + ( @D_ext_tube1.get() - @D_int_tube1.get() )
        
        @D_int_base_tube_incline2.set parseFloat(@D_int_tube2.get() + Math.abs( Math.tan(Math.PI * @angle_tube_incline2.get() / 180 ) * @h_tube_incline2.get() ) * 2)
        @D_ext_base_tube_incline2.set @D_int_base_tube_incline2.get() + ( @D_ext_tube2.get() - @D_int_tube2.get() ) 
        
        @l0.set @longueur_non_filetee.get() + 0
        @l1.set @h_plaque1.get() + @h_plaque2.get() - @l0.get()
        @L_serree.set @h_plaque1.get() + @h_plaque2.get()   
        
        if @diametre_nominal <= 3
            @pas.set 0.5
        else if @diametre_nominal <= 4
            @pas.set 0.7
        else if @diametre_nominal <= 5
            @pas.set 0.8
        else if @diametre_nominal <= 7
            @pas.set 1
        else if @diametre_nominal <= 9
            @pas.set 1.25
        else if @diametre_nominal <= 10
            @pas.set 1.5
        else if @diametre_nominal <= 10
            @pas.set 1.5
        else if @diametre_nominal <= 12
            @pas.set 1.75
        else if @diametre_nominal <= 16
            @pas.set 2
        else if @diametre_nominal <= 22
            @pas.set 2.5
        else if @diametre_nominal <= 27
            @pas.set 3
        else
            @pas.set 3.5

        @_partie = new Lst
        
        @_partie.push new Model
        @_partie[0].add_attr
          diametre : @diametre_nominal
          longueur : @l0
          filetage : 0
          
        @_partie.push new Model
        @_partie[1].add_attr
          diametre : @diametre_nominal
          longueur : @l1
          filetage : 0
    
        @partie_0 = @_partie[0]
        @partie_1 = @_partie[1]
        @n.set @_partie.length