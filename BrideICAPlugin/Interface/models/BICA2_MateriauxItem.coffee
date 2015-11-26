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
            E_bride_sup :       if params?.materiaux?.E_bride_sup? then params.materiaux.E_bride_sup else 205000
            poisson_bride_sup : if params?.materiaux?.poisson_bride_sup? then params.materiaux.poisson_bride_sup else 0.3
            E_bride_inf :       if params?.materiaux?.E_bride_inf? then params.materiaux.E_bride_inf else 205000
            poisson_bride_inf : if params?.materiaux?.poisson_bride_inf? then params.materiaux.poisson_bride_inf else 0.3
            E_fixation :        if params?.materiaux?.E_fixation? then params.materiaux.E_fixation else 205000
            poisson_fixation :  if params?.materiaux?.poisson_fixation? then params.materiaux.poisson_fixation else 0.3
            
    accept_child: ( ch ) ->
        false # AppItem

          