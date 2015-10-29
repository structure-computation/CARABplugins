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
            E_bride_sup : params.materiaux.E_bride_sup
            poisson_bride_sup :params.materiaux.poisson_bride_sup
            E_bride_inf :params.materiaux.E_bride_inf
            poisson_bride_inf :params.materiaux.poisson_bride_inf
            E_fixation :params.materiaux.E_fixation
            poisson_fixation :params.materiaux.poisson_fixation
            
    accept_child: ( ch ) ->
        false # AppItem

          