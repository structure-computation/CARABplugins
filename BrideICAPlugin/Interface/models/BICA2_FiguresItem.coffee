# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class BICA2_FiguresItem extends BICA_Base
    constructor: ( name = "Parametre des Figures", params = {} ) ->
        super()

        @_name.set name
        @_viewable.set false
          
        @add_attr
            Amplification_deplacement : if params?.figures?.Amplification_deplacement? then params.figures.Amplification_deplacement else 1
            
    accept_child: ( ch ) ->
        false # AppItem

          