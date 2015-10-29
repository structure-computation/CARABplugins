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
#         donnees = new BrideICADonnees geometrie
#         reglages = new BrideICAReglages geometrie
#         
#       Ajout des enfants
        @add_child geometrie
#         @add_child donnees
#         @add_child reglages
        
        
    display_suppl_context_actions: ( context_action )  ->
        context_action.push
            txt: "calcul des donnees"
            ico: "img/picto_play_donnees.png"
            fun: ( evt, app ) =>
                @calcul_donnees()
        context_action.push
            txt: "calcul des reglages"
            ico: "img/picto_play_reglages.png"
            fun: ( evt, app ) =>
                @calcul_reglages()
        context_action.push
            txt: "calcul de la souplesse"
            ico: "img/picto_play_souplesse.png"
            fun: ( evt, app ) =>
                @calcul_souplesse()
#         context_action.push
#             txt: "calcul du Maillage"
#             ico: "img/picto_play_maillage.png"
#             fun: ( evt, app ) =>
#                 @calcul_maillage()
                
    calcul_donnees: ( )  ->
        donnees = new BrideICADonnees @_children[0]
        @add_child donnees
    
    calcul_reglages: ( )  ->
        reglages = new BrideICAReglages @_children[0]
        @add_child reglages
      
    calcul_souplesse: ( )  ->
        souplesse = new BrideICASouplesse @_children
        @add_child souplesse
        
    calcul_maillage: ( )  ->
        maillage = new BrideICAMaillage @_children
        @add_child maillage