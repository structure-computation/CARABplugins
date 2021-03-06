# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.
class BrideICA2ComputeItem extends TreeItem
    constructor: ( Bride_ICA2_Item ) ->
        super()

        @_name.set "Bride_ICA2_ComputeItem"
        @_viewable.set false
        
#       Création des variables en appelant les différentes Classes (BrideICA2Item ayant toutes les variable)
        geometrie = new BrideICA2Item
#       On met en paramètre le paramètre geometrie qui contient donc toutes les variables utiles pour ces Classes
#         @add_attr
#             in_progress : false
#             force_axiale: new ConstrainedVal
#             facteur_echelle: new ConstrainedVal( 1, { min: 1, max: 100 } ) 
#         
#       Ajout des enfants
        @add_child geometrie
        @add_output new BrideICAOutputItem "Maillage apres serrage", @_children, "red" 
        @add_output new BrideICAOutputItem "Maillage apres pression", @_children, "blue"

#         @bind =>
#             if @force_axiale.val.has_been_modified()
#                 @_output[0]?._force_axiale.set_params
#                     val: @force_axiale.val.get()
#                 @_output[1]?._force_axiale.set_params
#                     val: @force_axiale.val.get()    
#                 @_output[0]?._force_axiale._signal_change()
#                 @_output[1]?._force_axiale._signal_change()       
#                 
#             if @facteur_echelle.val.has_been_modified()
#                 @_output[0]?._facteur_echelle.set_params
#                     val: @facteur_echelle.val.get()      
#                 @_output[1]?._facteur_echelle.set_params
#                     val: @facteur_echelle.val.get()
#                 @_output[0]?._facteur_echelle._signal_change()
#                 @_output[1]?._facteur_echelle._signal_change()
                
    display_suppl_context_actions: ( context_action )  ->
#         context_action.push
#             txt: "calcul des donnees"
#             ico: "img/picto_play_donnees.png"
#             fun: ( evt, app ) =>
#                 @calcul_donnees()
#         context_action.push
#             txt: "calcul des reglages"
#             ico: "img/picto_play_reglages.png"
#             fun: ( evt, app ) =>
#                 @calcul_reglages()
#         context_action.push
#             txt: "calcul de la souplesse"
#             ico: "img/picto_play_souplesse.png"
#             fun: ( evt, app ) =>
#                 @calcul_souplesse()
        
        context_action.push
            txt: "Lancement du calcul"
            ico: "img/picto_play_maillage.png"
            fun: ( evt, app ) =>
#                 for i in [ @_children.length - 1 .. 1]
#                     if @_children[i]?
#                         @rem_child @_children[i]  
                @calcul_donnees()
                @calcul_reglages()
                @calcul_souplesse()
                @calcul_maillage( app )
                @calcul_calcul_contact()
                @calcul_assemblage()
        
        context_action.push
            txt: "Suppression du calcul en cours"
            ico: "img/picto_stop.png"
            fun: ( evt, app ) =>
                size = @_children.length
                for i in [ 1 .. size - 1 ]
                    if @_children[(size - i)]?
                        @rem_child @_children[(size - i)]

        
        context_action.push
            txt: "affichage des graph"
            ico: "img/picto_graph.png"
            fun: ( evt, app ) =>
                for child in @_children
                    if child instanceof BrideICAMaillage
                        child.plot_maillage app
                        

#         context_action.push
#             txt: "calcul de la souplesse"
#             ico: "img/picto_play_souplesse.png"
#             fun: ( evt, app ) =>
#                 @calcul_calcul_contact()
#                 @calcul_assemblage()

                
    calcul_donnees: ( )  ->
        donnees = new BrideICADonnees @_children[0]
        @add_child donnees
#         @force_axiale.set_params
#             val: 0
#             min: 0
#             max: @_children[0].chargement.Pas_de_chargement.get()
#             div: @_children[0].chargement.Pas_de_chargement.get()
        @_output[0].force_axiale.set_params
            val: 0
            min: 0
            max: @_children[0].chargement.Pas_de_chargement.get()
            div: @_children[0].chargement.Pas_de_chargement.get()
        @_output[1].force_axiale.set_params
            val: 0
            min: 0
            max: @_children[0].chargement.Pas_de_chargement.get()
            div: @_children[0].chargement.Pas_de_chargement.get()    
    
    calcul_reglages: ( )  ->
        reglages = new BrideICAReglages @_children[0]
        @add_child reglages
      
    calcul_souplesse: ( )  ->
        souplesse = new BrideICASouplesse @_children
        @add_child souplesse
        
    calcul_maillage: ( app )  ->
        maillage = new BrideICAMaillage @_children, app
        @add_child maillage
    
    calcul_calcul_contact: ( ) ->
        calcul_contact = new BrideICACalculContact @_children
        @add_child calcul_contact
        
    calcul_assemblage: ( ) ->
        console.log "debut du calcul..."
#         console.log @_children[0].chargement.Fe_tension.get()
#         console.log @_children[0].chargement.Pas_de_chargement.get()
#         console.log (@_children[0].chargement.Fe_tension.get()/@_children[0].chargement.Pas_de_chargement.get())
        U_resultat2 = []
        for ForceAxiale in [0 .. @_children[0].chargement.Fe_tension.get() ] by (@_children[0].chargement.Fe_tension.get()/@_children[0].chargement.Pas_de_chargement.get())
#             console.log ForceAxiale
            assemblage = new BrideICAAssemblage @_children
#             console.log assemblage.k_poutre
#             console.log assemblage.effort
#             console.log assemblage.matrice_globale4
#             console.log assemblage.m_get assemblage.matrice_globale4,215,215       
#             console.log assemblage.m_get assemblage.matrice_globale4,230,230       
#             console.log assemblage.m_get assemblage.matrice_globale4,240,240       
#             console.log "r = " + assemblage.m_sum assemblage.matrice_globale4
            
            
            resolv = new BrideICAResolve @_children, assemblage, ForceAxiale, U_resultat2
            @_output[0]._U.push resolv.U_serrage
            @_output[1]._U.push resolv.U_pression
            
            console.log "fin du calcul pour ForceAxiale = " + ForceAxiale + " !"
#             break
        console.log "fin du calcul !"
