# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICAReglages extends TreeItem
    constructor: ( @bride_ica ) ->
        super()
        
        @_name.set "Reglages"
        @_viewable.set false
   
#       Initialisation des variables
        @add_attr
            alpha_tete_boulon : 0.47
            alpha_GM_boulon : 0.47
            _T1 : new Lst
            _T2 : new Lst
            coeff_pas : 0.93815
            Crep : 0.3
            gamma : 0.5
            epsiloncontact : 0
            
#       Ajout de différentes valeurs dans les tableaux T1 et T2
        @_T1.push 1
        @_T1.push 1
        @_T1.push 1.1
        @_T1.push 1.2
        @_T1.push 1.4
        @_T1.push 1.6
        @_T1.push 1.8
        @_T1.push 2
        @_T1.push 2.2
        @_T1.push 2.5
        @_T1.push 3
        @_T1.push 3.5
        @_T1.push 4
        @_T1.push 4.5
        @_T1.push 5
        @_T1.push 6
        @_T1.push 7
        @_T1.push 8
        @_T1.push 10
        @_T1.push 12
        @_T1.push 14
        @_T1.push 16
        @_T1.push 18
        @_T1.push 20
        @_T1.push 22
        @_T1.push 24
        @_T1.push 27
        @_T1.push 30
        @_T1.push 33
        @_T1.push 36
        @_T1.push 39     
        
        @_T2.push 0.765
        @_T2.push 0.865
        @_T2.push 0.965
        @_T2.push 1.119
        @_T2.push 1.272
        @_T2.push 1.472
        @_T2.push 1.625
        @_T2.push 1.778
        @_T2.push 2.078
        @_T2.push 2.484
        @_T2.push 2.937
        @_T2.push 3.343
        @_T2.push 3.796
        @_T2.push 4.249
        @_T2.push 5.062
        @_T2.push 6.062
        @_T2.push 6.827
        @_T2.push 8.593
        @_T2.push 10.358
        @_T2.push 12.124
        @_T2.push 14.124
        @_T2.push 16.655
        @_T2.push 17.655
        @_T2.push 19.655
        @_T2.push 21.186
        @_T2.push 24.186
        @_T2.push 26.716
        @_T2.push 29.716
        @_T2.push 32.247
        @_T2.push 35.247
