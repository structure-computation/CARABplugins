# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class BICA2_LoadsItem extends BICA_Base
    constructor: ( name = "Donnees de Chargement", params = {} ) ->
        super()

        @_name.set name
        @_viewable.set false
          
        @add_attr
            Precharge : params.chargement.Precharge
            Fe_tension : params.chargement.Fe_tension
            Pas_de_chargement : params.chargement.Pas_de_chargement
            
    accept_child: ( ch ) ->
        false # AppItem

          