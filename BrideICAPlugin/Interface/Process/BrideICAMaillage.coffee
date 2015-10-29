# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICAMaillage extends TreeItem
    constructor: ( @bride_children ) ->
        super()
        
        @_name.set "Maillage"
        @_viewable.set false
        
        @calcul_maillage()
    
    
    lst_mult_lst: ( lst_1, lst_2 ) ->    
        lst_3 = []
        if lst_1.length == lst_2.length
            taille = lst_1.length
            for i in [ 0 .. taille - 1 ]
                mult = lst_1[i] * lst_2[i]
                lst_3.push mult
            return lst_3
        else
            console.log "Les deux array n'ont pas la même taille"
 
 
    lst_mult_val: ( lst, val ) ->    
        lst_2 = []
        for i in [ 0 .. lst.length - 1 ]
            mult = val * lst[i]
            lst_2.push mult
        return lst_2
  
  
    add_in_lst: ( lst ) ->  
        add = 0
        for i in [ 0 .. lst.length - 1 ]
            add += lst[i] 
        return add
  
  
    lst_compar: ( lst_1, lst_2) -> 
        lst_3 = []
        if lst_1.length == lst_2.length
            taille = lst_1.length
            for i in [ 0 .. taille - 1 ]
                lst_3.push (0 + ( lst_1[i] == lst_2[i] ))
            return lst_3
        else
            console.log "Les deux array n'ont pas la même taille"
  
    
    lst_sort: ( lst ) ->
        len = lst.length
        for i in [ len - 1 .. 0 ]
            for j in [ 1 .. i ]
                if ( lst[j-1] > lst[j] )
                    tmp = lst[j-1]
                    lst[j-1] = lst[j]
                    lst[j] = tmp
        return lst
      
      
      lst_sort_index: ( lst_1, lst_2 ) ->
          lst_3 = []
          if lst_1.length == lst_2.length
              taille = lst_1.length
              for i in [ 0 .. taille - 1 ]
                  for j in [ 0 .. taille - 1 ]
                      if ( lst_1[i] == lst_2[j] )
                          lst_3.push j + 1
              return lst_3
          else
              console.log "Les deux array n'ont pas la même taille"
                
    
    calcul_maillage:() ->
#définition des variables ----------------------------------------------------------------------------------------------------------------------
        A = [1, 2, 3, 4, 5]
        ones_1_5 = [1, 1, 1, 1, 1]
        G = [14, 21, 3, 18, 144, 26, 37, 19, 46]
        maillage_bride = @bride_children[0].parameters.maillage.Taille_maillage_bride.get()
        maillage_virole = @bride_children[0].parameters.maillage.Taille_maillage_virole.get()
        sp = @bride_children[3].sptotale.get()
        nu_fixation = @bride_children[1].nu_fixation.get()
        E_fixation = @bride_children[1].E_fixation.get()
        Ie = @bride_children[3].Ie.get()
        Ae = @bride_children[3].Ae.get()
        Angle_sect = @bride_children[3].Angle_sect.get()
        r_moyen2 = @bride_children[3].r_moyen2.get()
        r_moyen1 = @bride_children[3].r_moyen1.get()
        angle_tube_incline2 = @bride_children[1].angle_tube_incline2.get()
        D_int_base_tube_incline2 = @bride_children[1].D_int_base_tube_incline2.get()
        D_ext_base_tube_incline2 = @bride_children[1].D_ext_base_tube_incline2.get()
        h_tube_incline2 = @bride_children[1].h_tube_incline2.get()
        h_tube2 = @bride_children[1].h_tube2.get()
        D_int_tube2 = @bride_children[1].D_int_tube2.get()
        D_ext_tube2 = @bride_children[1].D_ext_tube2.get()
        angle_tube_incline1 = @bride_children[1].angle_tube_incline1.get()
        D_int_base_tube_incline1 = @bride_children[1].D_int_base_tube_incline1.get()
        D_ext_base_tube_incline1 = @bride_children[1].D_ext_base_tube_incline1.get()
        h_tube_incline1 = @bride_children[1].h_tube_incline1.get()
        diametre_nominal = @bride_children[1].diametre_nominal.get()
        D_ext_tube1 = @bride_children[1].D_ext_tube1.get()
        D_int_tube1 = @bride_children[1].D_int_tube1.get()
        h_tube1 = @bride_children[1].h_tube1.get()
        h_plaque1 = @bride_children[1].h_plaque1.get()
        D_int_plaque1 = @bride_children[1].D_int_plaque1.get()
        D_ext_plaque1 = @bride_children[1].D_ext_plaque1.get()
        D_int_plaque2 = @bride_children[1].D_int_plaque2.get()
        D_ext_plaque2 = @bride_children[1].D_ext_plaque2.get()
        di = @bride_children[1].di.get()
        dt = @bride_children[1].dt.get()        
        h_plaque2 = @bride_children[1].h_plaque2.get()
        E_bride_sup = @bride_children[1].E_bride_sup.get()
        nu_bride_sup = @bride_children[1].nu_bride_sup.get()
        E_bride_inf = @bride_children[1].E_bride_inf.get()
        nu_bride_inf = @bride_children[1].nu_bride_inf.get()


#fonction issues du fichier matlab ----------------------------------------------------------------------------------------------------------------
        fin_hybride = 10000
        fin_hybride_support = 10000
        
        taille_secondaire = maillage_virole + 0
        taille_secondaire_plaque = maillage_bride + 0
        
        bride_sup = []
        
        bride_sup.push {}
        bride_sup[0].r = 0.5 * D_int_plaque1
        bride_sup[0].z = 0
        bride_sup[0].nom = "plaque_sup_bord_interieur"
        bride_sup[0].couleur = "rouge"
        
        bride_sup.push {}
        bride_sup[1].r = 0.5 * D_int_base_tube_incline1
        bride_sup[1].z = 0
        bride_sup[1].nom = "plaque_sup_coin_interieur"
        bride_sup[1].couleur = "rouge"
          
        bride_inf = []
        
        bride_inf.push {}
        bride_inf[0].r = 0.5 * D_int_plaque2
        bride_inf[0].z = 0
        bride_inf[0].nom = "plaque_inf_bord_interieur"
        bride_inf[0].couleur = "bleu"
        
        bride_inf.push {}
        bride_inf[1].r = 0.5 * D_int_base_tube_incline2
        bride_inf[1].z = 0
        bride_inf[1].nom = "plaque_inf_coin_interieur"
        bride_inf[1].couleur = "bleu"
        

        dbase1 = ( D_int_base_tube_incline1 + D_ext_base_tube_incline1 ) / 2
        dtube1 = ( D_int_tube1 + D_ext_tube1 ) / 2
        coeff1 = ( dbase1 - dtube1 ) * 0.5 / h_tube_incline1

        dbase2 = ( D_int_base_tube_incline2 + D_ext_base_tube_incline2 ) / 2
        dtube2 = ( D_int_tube2 + D_ext_tube2 ) / 2
        coeff2 = ( dbase2 - dtube2 ) * 0.5 / h_tube_incline2
        
        bride_sup.push {}
        bride_sup[2].r = 0.5 * dbase1 + coeff1 * h_plaque1 * 0.5
        bride_sup[2].z = 0
        bride_sup[2].nom = "plaque_sup_conection_tuyau"
        bride_sup[2].couleur = "rouge"
        
        bride_inf.push {}
        bride_inf[2].r = 0.5 * dbase2 + coeff2 * h_plaque2 * 0.5
        bride_inf[2].z = 0
        bride_inf[2].nom = "plaque_inf_conection_tuyau"
        bride_inf[2].couleur = "bleu"
        
        bride_sup.push {}
        bride_sup[3].r = r_moyen1
        bride_sup[3].z = 0
        bride_sup[3].nom = "plaque_sup_emplacemant_el_hybride"
        bride_sup[3].couleur = "rouge"
        
        bride_inf.push {}
        bride_inf[3].r = r_moyen2
        bride_inf[3].z = 0
        bride_inf[3].nom = "plaque_inf_emplacemant_el_hybride"
        bride_inf[3].couleur = "bleu"
        
        bride_sup.push {}
        bride_sup[4].r = 0.5 * D_ext_plaque1
        bride_sup[4].z = 0
        bride_sup[4].nom = "plaque_sup_bord_exterieur"
        bride_sup[4].couleur = "rouge"
        
        bride_inf.push {}
        bride_inf[4].r = 0.5 * D_ext_plaque2
        bride_inf[4].z = 0
        bride_inf[4].nom = "plaque_inf_bord_exterieur"
        bride_inf[4].couleur = "bleu"
        

        N_bride_sup = 5
        N_bride_inf = 5
        
        bride_sup_r = []
        bride_inf_r = []

        for k in [0 .. 4]
            bride_sup_r.push bride_sup[k].r
            bride_inf_r.push bride_inf[k].r
        
#         console.log "G = " + G
        G_sort = @lst_sort(G)
        console.log "H = " + H
        console.log "G_sort = " + G_sort
        sort_index = @lst_sort_index(H, G_sort)
        console.log "sort_index = " + sort_index
        for i in [ 0 .. 4 ]
            if ( ( 0.5 * D_int_plaque2 ) < bride_sup[i].r and bride_sup[i].r < ( 0.5 * D_ext_plaque2 ) )
                bride_sup_r_ones = @lst_mult_val(ones_1_5, bride_sup_r[i])
                compare = @lst_compar(bride_sup_r_ones, bride_inf_r)
                compare_mult = @lst_mult_lst(compare, A)
                testindice = @add_in_lst(compare_mult)
                if ( testindice != 0 )
                    nomtmp = bride_inf[testindice - 1].nom
                    bride_inf[testindice - 1].nom = ( bride_inf[testindice - 1].nom + " + projection_sup/inf de : " + bride_sup[i].nom )
                    bride_sup[i].nom = ( bride_sup[i].nom + " + projection_inf/sup : " + nomtmp )
                else
                    bride_inf = N_bride_inf + 1
                    bride_inf[N_bride_inf - 1].r = bride_sup[i].r
                    bride_inf[N_bride_inf - 1].z = 0
                    bride_inf[N_bride_inf - 1].nom = ( "projection_sup/inf de :" + bride_sup[i].nom )
                    bride_inf[N_bride_inf - 1].couleur = "bleu"
            
            if ( ( 0.5 * D_int_plaque1 ) < bride_inf[i].r and bride_inf[i].r < ( 0.5 * D_ext_plaque1 ) )
                bride_inf_r_ones = @lst_mult_val(ones_1_5, bride_inf_r[i])
                compare = @lst_compar(bride_inf_r_ones, bride_sup_r)
                compare_mult = @lst_mult_lst(compare, A)
                testindice = @add_in_lst(compare_mult)
#                 console.log "testindice = " + testindice
                if ( testindice == 0 )
                    N_bride_sup = N_bride_sup + 1
                    bride_sup[N_bride_sup - 1].r = bride_inf[i].r
                    bride_sup[N_bride_sup - 1].z = 0
                    bride_sup[N_bride_sup - 1].nom = ( "projection_inf/sup de : " + bride_inf[i].nom )
                    bride_sup[N_bride_sup - 1].couleur = "rouge"
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    


        