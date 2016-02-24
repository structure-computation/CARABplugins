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
            Precharge :         4100
            Fe_tension :        10000
            Pas_de_chargement :   5
            
    accept_child: ( ch ) ->
        false # AppItem

          