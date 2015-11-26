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
            Taille_maillage_bride : if params?.maillage?.Taille_maillage_bride? then params.maillage.Taille_maillage_bride else 1
            Taille_maillage_virole :  if params?.maillage?.Taille_maillage_virole? then params.maillage.Taille_maillage_virole else 5
            
    accept_child: ( ch ) ->
        false # AppItem

          