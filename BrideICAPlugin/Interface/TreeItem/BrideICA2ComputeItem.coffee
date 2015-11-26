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

#         
#       Ajout des enfants
        @add_child geometrie

    
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
            txt: "calcul du Maillage"
            ico: "img/picto_play_maillage.png"
            fun: ( evt, app ) =>
                @calcul_donnees()
                @calcul_reglages()
                @calcul_souplesse()
                @calcul_maillage( app )
                

        context_action.push
            txt: "calcul de la souplesse"
            ico: "img/picto_play_souplesse.png"
            fun: ( evt, app ) =>
                @calcul_calcul_contact()

                
    calcul_donnees: ( )  ->
        donnees = new BrideICADonnees @_children[0]
        @add_child donnees
    
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
