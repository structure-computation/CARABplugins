# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.
class BrideICA2Item extends TreeItem
    constructor: ( name = "Donnees Geometriques" ) ->
        super()

        @_name.set name
        @_viewable.set false
        
 
        # Appel des differentes Classes + nom + les parametres
        
        @add_child new BICA2_BrideSupItem "Bride Superieur"
        @add_child new BICA2_BrideInfItem "Bride Inferieur"
        
        @add_attr 
            bridesup : @_children[0]
            brideinf : @_children[1]
        
        @add_child new BICA2_BoulonItem "Boulon", this
        @add_attr boulon : @_children[2]
        @add_child new BICA2_MateriauxItem "Donnees Materiaux", this
        @add_attr materiaux : @_children[3]
        @add_child new BICA2_LoadsItem "Donnees Chargement", this
        @add_attr chargement : @_children[4]
        @add_child new BICA2_MaillagePourMatlabItem "Parametre de Maillage", this
        @add_attr maillage : @_children[5]
        @add_child new BICA2_FiguresItem "Parametre des Figures", this
        @add_attr figures : @_children[6]

            