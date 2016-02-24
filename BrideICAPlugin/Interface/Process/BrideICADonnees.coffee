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
            h_plaque1 : if @bride_ica?.bridesup?.h_plaque? then @bride_ica.bridesup.h_plaque else 3
            D_ext_plaque1 : if @bride_ica?.bridesup?.D_ext_plaque? then @bride_ica.bridesup.D_ext_plaque else 86
            D_int_plaque1 : if @bride_ica?.bridesup?.D_int_plaque? then @bride_ica.bridesup.D_int_plaque else 57
            D_ext_tube1 : if @bride_ica?.bridesup?.D_ext_tube? then @bride_ica.bridesup.D_ext_tube else 61
            D_int_tube1 : if @bride_ica?.bridesup?.D_int_tube? then @bride_ica.bridesup.D_int_tube else 57.1
            h_tube1 : if @bride_ica?.bridesup?.h_tube? then @bride_ica.bridesup.h_tube else 56
            h_tube_incline1 : if @bride_ica?.bridesup?.h_tube_incline? then @bride_ica.bridesup.h_tube_incline else 60
            angle_tube_incline1 : if @bride_ica?.bridesup?.angle_tube_incline? then @bride_ica.bridesup.angle_tube_incline else 0
        @add_attr#                         Conséquences :
            D_int_base_tube_incline1 : parseFloat(@D_int_tube1 + Math.abs( Math.tan(Math.PI * @angle_tube_incline1 / 180 ) * @h_tube_incline1 ) * 2)
            
        @add_attr
            D_ext_base_tube_incline1 : @D_int_base_tube_incline1.get() + ( @D_ext_tube1.get() - @D_int_tube1.get() )
        
        @add_attr #                         Données géometriques relatives à la bride inferieur 2 :  
            h_plaque2 : if @bride_ica?.brideinf?.h_plaque? then @bride_ica.brideinf.h_plaque else 3
            D_ext_plaque2 : if @bride_ica?.brideinf?.D_ext_plaque? then @bride_ica.brideinf.D_ext_plaque else 86
            D_int_plaque2 : if @bride_ica?.brideinf?.D_int_plaque? then @bride_ica.brideinf.D_int_plaque else 57
            D_ext_tube2 : if @bride_ica?.brideinf?.D_ext_tube? then @bride_ica.brideinf.D_ext_tube else 61
            D_int_tube2 : if @bride_ica?.brideinf?.D_int_tube? then @bride_ica.brideinf.D_int_tube else 57.1
            h_tube2 : if @bride_ica?.brideinf?.h_tube? then @bride_ica.brideinf.h_tube else 56
            h_tube_incline2 : if @bride_ica?.brideinf?.h_tube_incline? then @bride_ica.brideinf.h_tube_incline else 60
            angle_tube_incline2 : if @bride_ica?.brideinf?.angle_tube_incline? then (180 - @bride_ica.brideinf.angle_tube_incline.get()) else 180
        
        @add_attr #                         Conséquences :
            D_int_base_tube_incline2 : parseFloat(@D_int_tube2 + Math.abs( Math.tan(Math.PI * @bride_ica.brideinf.angle_tube_incline.get() / 180 ) * @h_tube_incline2 ) * 2)
            
            
        @add_attr
            D_ext_base_tube_incline2 : @D_int_base_tube_incline2.get() + ( @D_ext_tube2.get() - @D_int_tube2.get() ) 
        
        @add_attr#                         Données communes aux deux brides & Données fixations :
            E_bride_sup : if @bride_ica?.materiaux?.E_bride_sup? then @bride_ica.materiaux.E_bride_sup else 205000
            nu_bride_sup : if @bride_ica?.materiaux?.poisson_bride_sup? then @bride_ica.materiaux.poisson_bride_sup else 0.3
            E_bride_inf : if @bride_ica?.materiaux?.E_bride_inf? then @bride_ica.materiaux.E_bride_inf else 205000
            nu_bride_inf : if @bride_ica?.materiaux?.poisson_bride_inf? then @bride_ica.materiaux.poisson_bride_inf else 0.3
            E_fixation : if @bride_ica?.materiaux?.E_fixation? then @bride_ica.materiaux.E_fixation else 205000
            nu_fixation : if @bride_ica?.materiaux?.poisson_fixation? then @bride_ica.materiaux.poisson_fixation else 0.3
            di : if @bride_ica?.boulon?.diametre_implantation? then @bride_ica.boulon.diametre_implantation else 74
            nombredefixation : if @bride_ica?.boulon?.nombre_de_fixations? then @bride_ica.boulon.nombre_de_fixations else 20
            dt : if @bride_ica?.boulon?.diametre_trou_passage? then @bride_ica.boulon.diametre_trou_passage else 5.4
            diametre_nominal : if @bride_ica?.boulon?.diametre_nominal? then @bride_ica.boulon.diametre_nominal else 5
            Da : if @bride_ica?.boulon?.diametre_tete? then @bride_ica.boulon.diametre_tete else 8.3
            longueur_non_filetee : if @bride_ica?.boulon?.longueur_non_filetee? then @bride_ica.boulon.longueur_non_filetee else 6
            longueur_filetee : if @bride_ica?.boulon?.longueur_filetee? then @bride_ica.boulon.longueur_filetee else 0
        
        @add_attr #                         Conséquences :
            l0 : parseFloat(@longueur_non_filetee.get() + 0)
            
        @add_attr
            l1 : parseFloat(@h_plaque1.get() + @h_plaque2.get() - @l0.get())
            L_serree : parseFloat(@h_plaque1.get() + @h_plaque2.get())             
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
            precontrainte : if @bride_ica?.chargement?.Precharge? then @bride_ica.chargement.Precharge else 4100
            ForceAxiale : if @bride_ica?.chargement?.Fe_tension? then @bride_ica.chargement.Fe_tension else 10000
            MomentOrthoRad : 0
            
        @add_attr#                           Autres :
            calage_contact : 0
            Nombre_increments : 40
            hauteur_resultat : ( @h_plaque1.get() + @h_plaque2.get() ) / 2
            Diametre_resultat : @diametre_nominal.get() + 0
            
            coef_mag : if @bride_ica?.figures?.Amplification_deplacement? then @bride_ica.figures.Amplification_deplacement else 1
            maillage_bride : if @bride_ica?.maillage?.Taille_maillage_bride? then @bride_ica.maillage.Taille_maillage_bride else 1
            maillage_virole : if @bride_ica?.maillage?.Taille_maillage_virole? then @bride_ica.maillage.Taille_maillage_virole else 5
            _partie : new Lst
#                             Définition de la partie 1
        @_partie.push new Model
        @_partie[0].add_attr
          diametre : @diametre_nominal.get()
          longueur : @l0.get()
          filetage : 0
#                             Définition de la partie 2
        @_partie.push new Model
        @_partie[1].add_attr
          diametre : @diametre_nominal.get()
          longueur : @l1.get()
          filetage : 0
        
        @add_attr
            partie_0 : @_partie[0]
            partie_1 : @_partie[1]
            n : @_partie.length
            
#                             Recréation du Maillage en fonction de la modification d'une variable            
        @bind =>
            if @bride_ica?.has_been_modified()
                @compute()
                
    compute: (  ) ->

        @D_int_base_tube_incline1.set parseFloat(@D_int_tube1.get() + Math.abs( Math.tan(Math.PI * @angle_tube_incline1.get() / 180 ) * @h_tube_incline1.get() ) * 2)
        @D_ext_base_tube_incline1.set @D_int_base_tube_incline1.get() + ( @D_ext_tube1.get() - @D_int_tube1.get() )
        
        @D_int_base_tube_incline2.set parseFloat(@D_int_tube2.get() + Math.abs( Math.tan(Math.PI * @angle_tube_incline2.get() / 180 ) * @h_tube_incline2.get() ) * 2)
        @D_ext_base_tube_incline2.set @D_int_base_tube_incline2.get() + ( @D_ext_tube2.get() - @D_int_tube2.get() ) 
        
        @l0.set parseFloat(@longueur_non_filetee.get() + 0)
        
        @l1.set parseFloat(@h_plaque1.get() + @h_plaque2.get() - @l0.get())
        @L_serree.set parseFloat(@h_plaque1.get() + @h_plaque2.get())   
        
#         console.log "l0 = " + @l0
#         console.log "l1 = " + @l1
#         console.log "L_serree = " + @L_serree
        
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
          diametre : @diametre_nominal.get()
          longueur : @l0.get()
          filetage : 0
          
        @_partie.push new Model
        @_partie[1].add_attr
          diametre : @diametre_nominal.get()
          longueur : @l1.get()
          filetage : 0
    
        @partie_0 = @_partie[0]
        @partie_1 = @_partie[1]
        @n.set @_partie.length