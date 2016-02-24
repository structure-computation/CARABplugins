# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class BICA2_MateriauxItem extends BICA_Base
    constructor: ( name = "Materiaux", params = {} ) ->
        super()

        @_name.set name
        @_viewable.set false
          
        @add_attr
            E_bride_sup :        205000
            poisson_bride_sup :  0.3
            E_bride_inf :        205000
            poisson_bride_inf :  0.3
            E_fixation :         205000
            poisson_fixation :   0.3
            
    accept_child: ( ch ) ->
        false # AppItem

          