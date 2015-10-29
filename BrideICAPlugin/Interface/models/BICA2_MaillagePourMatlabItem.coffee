# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class BICA2_MaillagePourMatlabItem extends BICA_Base
    constructor: ( name = "Parametres de Maillage", params = {} ) ->
        super()

        @_name.set name
        @_viewable.set false
          
        @add_attr
            Taille_maillage_bride : params.maillage.Taille_maillage_bride
            Taille_maillage_virole : params.maillage.Taille_maillage_virole
            
    accept_child: ( ch ) ->
        false # AppItem

          