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
            Precharge :  if params?.chargement?.Precharge? then params.chargement.Precharge else 4100
            Fe_tension :   if params?.chargement?.Fe_tension? then params.chargement.Fe_tension else 10000
            Pas_de_chargement :  if params?.chargement?.Pas_de_chargement? then params.chargement.Pas_de_chargement else 5
            
    accept_child: ( ch ) ->
        false # AppItem

          