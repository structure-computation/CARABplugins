# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICAMaillage extends TreeItem
    constructor: ( @bride_children, app ) ->
        super()
        
        @_name.set "Maillage"
        @_viewable.set false
        
        @add_attr
            noeud : []
            elem : []
            wa1 : 0
            wa2 : 0
            wb1 : 0
            wb2 : 0
            wc1 : 0
            wc2 : 0
            wd1 : 0
            wd2 : 0
            we1 : 0
            we2 : 0
            wf1 : 0
            wf2 : 0
            wsup : 0
            winf : 0
            wpression11 : 0
            wpression12 : 0
            wpression21 : 0
            wpression22 : 0
            _bride_sup : new Lst 
            _bride_inf : new Lst 
            
        if @bride_children?
            @calcul_maillage( app )
    
    
    lst_mult_lst: ( lst_1, lst_2 ) ->    
        lst_3 = []
        if lst_1.length == lst_2.length
            taille = lst_1.length
            for i in [ 0 .. taille - 1 ]
                mult = lst_1[i] * lst_2[i]
                lst_3.push mult
            return lst_3
        else
            console.log "Les deux array n'ont pas la meme taille"
 
 
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
            console.log "Les deux array n'ont pas la meme taille"
  
    
    lst_sort: ( lst ) ->
        len = lst.length
        for i in [ len - 1 .. 0 ]
            for j in [ 1 .. i ]
                if ( lst[j-1] > lst[j] )
                    tmp = lst[j-1]
                    lst[j-1] = lst[j]
                    lst[j] = tmp
        return lst
      
    lst_sort_to_index: ( lst, lst_index ) ->
        lst_sort_to_index_array = []
        if lst.length == lst_index.length
            for i in [ 0 .. lst.length - 1 ]
                lst_sort_to_index_array.push lst[ lst_index[i] ]
            return lst_sort_to_index_array
        else
            console.log "Les deux array n'ont pas la même taille"
      
    lst_sort_index: ( lst_1, lst_2 ) ->
        lst_3 = []
        if lst_1.length == lst_2.length
            taille = lst_1.length
            for i in [ 0 .. taille - 1 ]
                for j in [ 0 .. taille - 1 ]
                    if ( lst_1[i] == lst_2[j] )
                        lst_3.push j
            return lst_3
        else
            console.log "Les deux array n'ont pas la même taille"
                
    strncmp: ( lst_1, lst_2, lgth ) ->
    
        s1 = (lst_1 + '')
        .substr(0, lgth);
        s2 = (lst_2 + '')
        .substr(0, lgth);
        return ( ( s1 == s2 ) ? 0 : ( ( s1 > s2 ) ? 1 : -1 ) )
    
    getTop: ( l ) ->
      if l.offsetParent?
          return l.offsetTop + @getTop( l.offsetParent )
      else
          return l.offsetTop
    
    getLeft: ( l ) ->
      if l.offsetParent?
          return l.offsetLeft + @getLeft( l.offsetParent )
      else
          return l.offsetLeft
        
    onPopupClose: ( app ) =>
        document.onkeydown = undefined
        app.active_key.set true
    
    calcul_maillage:( app ) ->
#définition des variables ----------------------------------------------------------------------------------------------------------------------
        A = [1, 2, 3, 4, 5]
        ones_1_5 = [1, 1, 1, 1, 1]
        maillage_bride = @bride_children[0].maillage.Taille_maillage_bride.get()
        maillage_virole = @bride_children[0].maillage.Taille_maillage_virole.get()
        sp = @bride_children[3].sp
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
        
# # # # # # # # # # # # # # # # # # # # # # # # # # # #  definition noeuds principaux de bride sup inf et vis # # # # # # # # # # # # # # # # # # # # #       
#   r : coordonnees radiales d un noeud
#   z : coordonnnes axiales d un noeud
#   nom : le nom du noeud:R pour plaque, h pour hybride,
#   T pour tube b pour dire quil est relatif a la bague et le numero pour designer le numero du noeud,
#   couleur pour definir la couleur pour pouvoir generer apres un nuage depoints en couleur
        
        
#       Definissons les noeuds des plaques
        
        taille_secondaire = maillage_virole + 0
        taille_secondaire_plaque = maillage_bride + 0
        
#       Plaque bords interieurs 
        
        bride_sup = []
        bride_inf = []
        
        bride_sup.push {}
        bride_sup[0].r = 0.5 * D_int_plaque1
        bride_sup[0].z = 0
        bride_sup[0].nom = "plaque_sup_bord_interieur"
        bride_sup[0].couleur = "rouge"       
                  
        bride_inf.push {}
        bride_inf[0].r = 0.5 * D_int_plaque2
        bride_inf[0].z = 0
        bride_inf[0].nom = "plaque_inf_bord_interieur"
        bride_inf[0].couleur = "bleu"

# # # # # # # # # # # # # # # # # # # # # # # # # # # #         

#       Plaque coins interieurs 1
        bride_sup.push {}
        bride_sup[1].r = 0.5 * D_int_base_tube_incline1
        bride_sup[1].z = 0
        bride_sup[1].nom = "plaque_sup_coin_interieur"
        bride_sup[1].couleur = "rouge"
        
        bride_inf.push {}
        bride_inf[1].r = 0.5 * D_int_base_tube_incline2
        bride_inf[1].z = 0
        bride_inf[1].nom = "plaque_inf_coin_interieur"
        bride_inf[1].couleur = "bleu"
# # # # # # # # # # # # # # # # # # # # # # # # # # # #  
#         console.log "D_int_base_tube_incline1 = " + D_int_base_tube_incline1
#         console.log "D_int_base_tube_incline2 = " + D_int_base_tube_incline2
#       Connections tuyaux

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
# # # # # # # # # # # # # # # # # # # # # # # # # # # #  

#       Emplacements elements hybride        

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
# # # # # # # # # # # # # # # # # # # # # # # # # # # #  

#       Plaque bords exterieurs 

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
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #         

# Projection éventuelle de ces 5 points respectivement sur les deux plaques :
# 2 condition absolues : le point a projeter doit etre comprit sur la plaque
# opposé 'et' aucun point de la plaque opposée ne doit cohincider au moment
# de la projection. Toujours le meme test.

        @N_bride_sup = 5
        @N_bride_inf = 5
        
# Projection SUP/INF puis INF/SUP
        
        bride_sup_r = []
        bride_inf_r = []
        bride_sup_z = []
        bride_inf_z = []

        for k in [0 .. 4]
            bride_sup_r.push bride_sup[k].r
            bride_inf_r.push bride_inf[k].r
            bride_sup_z.push bride_sup[k].z
            bride_inf_z.push bride_inf[k].z
#         console.log "D_int_plaque2 = " + D_int_plaque2
#         console.log " = " + 
#         console.log "D_ext_plaque2 = " + D_ext_plaque2
#         console.log " = " + 
#         console.log "D_int_plaque1 = " + D_int_plaque1
#         console.log " = " + 
#         console.log "D_ext_plaque1 = " + D_ext_plaque1
        
        for i in [ 0 .. 4 ]
#             console.log "bride_sup[i].r = " + bride_sup[i].r
#             console.log "bride_inf[i].r = " + bride_inf[i].r
            if ( ( 0.5 * D_int_plaque2 ) < bride_sup[i].r and bride_sup[i].r < ( 0.5 * D_ext_plaque2 ) )    # On vérifie qu'il existe bien une projection
                
                bride_sup_r_ones = @lst_mult_val(ones_1_5, bride_sup_r[i])
                compare = @lst_compar(bride_sup_r_ones, bride_inf_r)
                compare_mult = @lst_mult_lst(compare, A)
                testindice = @add_in_lst(compare_mult)
                if ( testindice != 0 ) 
#                     console.log "je passe dans le bon if"
                    nomtmp = bride_inf[testindice - 1].nom
                    bride_inf[testindice - 1].nom = ( bride_inf[testindice - 1].nom + " + projection_sup/inf de : " + bride_sup[i].nom )
                    bride_sup[i].nom = ( bride_sup[i].nom + " + projection_inf/sup : " + nomtmp )
                else
#                     console.log "je passe dans le else"
                    @N_bride_inf = @N_bride_inf + 1
                    bride_inf.push {}
                    bride_inf[@N_bride_inf - 1].r = bride_sup[i].r
                    bride_inf[@N_bride_inf - 1].z = 0
                    bride_inf[@N_bride_inf - 1].nom = ( "projection_sup/inf de :" + bride_sup[i].nom )
                    bride_inf[@N_bride_inf - 1].couleur = "bleu"
            
            if ( ( 0.5 * D_int_plaque1 ) < bride_inf[i].r and bride_inf[i].r < ( 0.5 * D_ext_plaque1 ) )
#                 console.log "je passe dans le mauvais if"
                bride_inf_r_ones = @lst_mult_val(ones_1_5, bride_inf_r[i])
                compare = @lst_compar(bride_inf_r_ones, bride_sup_r)
                compare_mult = @lst_mult_lst(compare, A)
                testindice = @add_in_lst(compare_mult)
#                 console.log "testindice = " + testindice
                if ( testindice == 0 )
                    @N_bride_sup = @N_bride_sup + 1
                    bride_sup.push {}
                    bride_sup[@N_bride_sup - 1].r = bride_inf[i].r
                    bride_sup[@N_bride_sup - 1].z = 0
                    bride_sup[@N_bride_sup - 1].nom = ( "projection_inf/sup de : " + bride_inf[i].nom )
                    bride_sup[@N_bride_sup - 1].couleur = "rouge"

#         console.log bride_sup
#         console.log bride_inf
# A ce stade on trie la structure par indexe croissant
#       il faut donc imaginer que l'indexage sur la plaque est
#       croissant de gauche à droite            
        
        bride_sup_r_cpy = bride_sup_r.slice()
        bride_sup_r_sort = @lst_sort(bride_sup_r)
        sort_index_sup = @lst_sort_index(bride_sup_r_cpy, bride_sup_r_sort)      
#         console.log bride_sup_r_cpy
#         console.log bride_sup
        bride_sup = @lst_sort_to_index(bride_sup, sort_index_sup)
      
        bride_inf_r_cpy = bride_inf_r.slice()
        bride_inf_r_sort = @lst_sort(bride_inf_r)
        sort_index_inf = @lst_sort_index(bride_inf_r_cpy, bride_inf_r_sort)      
        bride_inf = @lst_sort_to_index(bride_inf, sort_index_inf)

# On continue le maillage principale
  
# Haut de lelemnt hybride

        @N_bride_sup = @N_bride_sup + 1
        @N_bride_inf = @N_bride_inf + 1
#         console.log @N_bride_inf
        bride_sup.push {}
        bride_sup[@N_bride_sup - 1].r = r_moyen1
        bride_sup[@N_bride_sup - 1].z = h_plaque1 / 2
        bride_sup[@N_bride_sup - 1].nom = "Haut de lelement hybride"
        bride_sup[@N_bride_sup - 1].couleur = "rouge"
        bride_inf.push {}
        bride_inf[@N_bride_inf - 1].r = r_moyen2
        bride_inf[@N_bride_inf - 1].z = -h_plaque2 / 2
        bride_inf[@N_bride_inf - 1].nom = "Haut de lelement hybride"
        bride_inf[@N_bride_inf - 1].couleur = "bleu"
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   

# Plaque coin interieur 2
        @N_bride_sup = @N_bride_sup + 1
        @N_bride_inf = @N_bride_inf + 1
        bride_sup.push {}
        bride_sup[@N_bride_sup - 1].r = dbase1 / 2
        bride_sup[@N_bride_sup - 1].z = h_plaque1 / 2
        bride_sup[@N_bride_sup - 1].nom = "plaque_sup_coin_interieur2"
        bride_sup[@N_bride_sup - 1].couleur = "rouge"
        bride_inf.push {}
        bride_inf[@N_bride_inf - 1].r = dbase2 / 2
        bride_inf[@N_bride_inf - 1].z = -h_plaque2 / 2
        bride_inf[@N_bride_inf - 1].nom = "plaque_inf_coin_interieur2"
        bride_inf[@N_bride_inf - 1].couleur = "bleu"
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #  

# Jonction_tube_incline_tube
        d1 = ( D_int_tube1 + D_ext_tube1 ) / 2
        d2 = ( D_int_tube2 + D_ext_tube2 ) / 2
        
        @N_bride_sup = @N_bride_sup + 1
        @N_bride_inf = @N_bride_inf + 1
        bride_sup.push {}
        bride_sup[@N_bride_sup - 1].r = 0.5 * d1
        bride_sup[@N_bride_sup - 1].z = h_tube_incline1 + 0.5 * h_plaque1
        bride_sup[@N_bride_sup - 1].nom = "Jonction_tube_incline_tube"
        bride_sup[@N_bride_sup - 1].couleur = "rouge"
        bride_inf.push {}
        bride_inf[@N_bride_inf - 1].r = 0.5 * d2
        bride_inf[@N_bride_inf - 1].z = - ( h_tube_incline2 + 0.5 * h_plaque2 )
        bride_inf[@N_bride_inf - 1].nom = "jonction_tube_incline_tube"
        bride_inf[@N_bride_inf - 1].couleur = "bleu"
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #      

# Fin tube
        d1 = ( D_int_tube1 + D_ext_tube1 ) / 2
        d2 = ( D_int_tube2 + D_ext_tube2 ) / 2
        
        @N_bride_sup = @N_bride_sup + 1
        @N_bride_inf = @N_bride_inf + 1
        bride_sup.push {}
        bride_sup[@N_bride_sup - 1].r = 0.5 * d1
        bride_sup[@N_bride_sup - 1].z = h_tube_incline1 + 0.5 * h_plaque1 + h_tube1
        bride_sup[@N_bride_sup - 1].nom = "Fin_tube_sup"
        bride_sup[@N_bride_sup - 1].couleur = "rouge"
        bride_inf.push {}
        bride_inf[@N_bride_inf - 1].r = 0.5 * d2
        bride_inf[@N_bride_inf - 1].z = - ( h_tube_incline2 + 0.5 * h_plaque2 + h_tube2 )
        bride_inf[@N_bride_inf - 1].nom = "Fin_tube_inf"
        bride_inf[@N_bride_inf - 1].couleur = "bleu"
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# definition des noeuds principaux de la vis
# On va definir les noeuds selon l orientation de mon element de fixation

        @vis = []
# # # # # # # # # # # # #         
        @vis.push {}
        @vis[0].r = 0.5 * di
        @vis[0].z = h_plaque1
        @vis[0].nom = "V1"
        @vis[0].couleur = "rose"
# # # # # # # # # # # # #

# # # # # # # # # # # # # 
        @vis.push {}
        @vis[1].r = 0.5 * di
        @vis[1].z = - h_plaque2
        @vis[1].nom = "V2"
        @vis[1].couleur = "rose"
# # # # # # # # # # # # #         

        N_vis = 2
        
# Definition des indices des noeuds
# A,B,C,D,E,F,G dans la structure
# Tels que AB=zone1,CD=zone2,EF=zone3,FG=zone4
# Zone 1: zone qui modelise les elements plaques de la bride
# Zone 2: zone qui modelise les elements hybrides ou tubes
# Zone 3: zone qui modelise l element tube incline
# Zone 4: zone qui modelise l element tube

#----------------------------------------------BRIDE SUPERIEUR---------------------------------------------------#         
        a1 = 1
        b1 = @N_bride_sup - 4
        c1 = 1
                    
        while ( ! ( @strncmp(bride_sup[c1 - 1].nom, "plaque_sup_emplacemant_el_hybride", 33) ) )
            c1 = c1 + 1
        
        d1 = @N_bride_sup - 3
        e1 = 1
        
        while ( ! ( @strncmp(bride_sup[e1 - 1].nom, "plaque_sup_conection_tuyau", 26) ) )
            e1 = e1 + 1
        
        f1 = @N_bride_sup - 1
        g1 = @N_bride_sup
        
#----------------------------------------------BRIDE INFERIEUR----------------------------------------------------#
        a2 = 1
        b2 = @N_bride_inf - 4
        c2 = 1
        while ( ! ( @strncmp(bride_inf[c2 - 1].nom, "plaque_inf_emplacemant_el_hybride", 33) ) )
            c2 = c2 + 1
            
        d2 = @N_bride_inf - 3
        e2 = 1
        
        while ( ! ( @strncmp(bride_inf[e2 - 1].nom, "plaque_inf_conection_tuyau", 26) ) )
            e2 = e2 + 1
        f2 = @N_bride_inf - 1
        g2 = @N_bride_inf
        
#         ###################################################################################################
#         ##############################FIN definition noeuds principaux#####################################
#         ###################################################################################################
        
        
#         ###################################################################################################
#         ##############################Definition noeuds secondaire#########################################
#         ###################################################################################################
                    
        w = 1 # Variable locale pour definir le numero des noeuds
        x = 0 # Variable locale pour pouvoir definir les numero des elements
        elem = []
        noeud = []
#         wa = 0
#         wb = 0
#         wc = 0
#         wd = 0
#         we = 0
#         wf = 0
#         wpression1 = 0
#         wpression2 = 0
#         console.log "w = " + w
#         on definir 2 structures pour pouvoir stocker toutes les donnees relatives aux noeuds et aux elements
  
#         for i in [0 .. bride_sup.length-1]
#             console.log i + 1
#             console.log "bride_sup[i].r = " + bride_sup[i].r
#             console.log "bride_sup[i].z = " + bride_sup[i].z
#             console.log "bride_inf[i].r = " + bride_inf[i].r
#             console.log "bride_inf[i].z = " + bride_inf[i].z
  
# # # # # # # # # # # # # # # # # # # # # # # # Maillage secondaire de la bride sup  
        brideICA_maillage_secondaire1 = new BrideICAMaillageSecondaire
            string : "sup"
            w : w
            x : x
            elem : elem
            noeud : noeud
            bride_sup : bride_sup
            N_bride_sup : @N_bride_sup
            sp : sp
            a1 : a1
            b1 : b1
            c1 : c1
            d1 : d1
            e1 : e1
            f1 : f1
            g1 : g1
            r_moyen1 : r_moyen1
            Angle_sect : Angle_sect
            h_plaque1 : h_plaque1
            D_ext_plaque1 : D_ext_plaque1
            D_int_plaque1 : D_int_plaque1
            D_ext_tube1 : D_ext_tube1
            D_int_tube1 : D_int_tube1
            h_tube1 : h_tube1
            h_tube_incline1 : h_tube_incline1
            D_ext_base_tube_incline1 : D_ext_base_tube_incline1
            D_int_base_tube_incline1 : D_int_base_tube_incline1
            angle_tube_incline1 : angle_tube_incline1
            di : di
            dt : dt
            E_bride_sup : E_bride_sup
            nu_bride_sup : nu_bride_sup
            E_bride_inf : E_bride_inf
            nu_bride_inf : nu_bride_inf
            taille_secondaire : taille_secondaire
            taille_secondaire_plaque : taille_secondaire_plaque
        
        w = parseFloat(brideICA_maillage_secondaire1.w)
        x = parseFloat(brideICA_maillage_secondaire1.x) 
#         elem = brideICA_maillage_secondaire1.elem
#         @noeud = brideICA_maillage_secondaire1.noeud
        @wa1 = brideICA_maillage_secondaire1.wa
        @wb1 = brideICA_maillage_secondaire1.wb
        @wc1 = brideICA_maillage_secondaire1.wc
        @wd1 = brideICA_maillage_secondaire1.wd
        @we1 = brideICA_maillage_secondaire1.we
        @wf1 = brideICA_maillage_secondaire1.wf
        @wpression11 = brideICA_maillage_secondaire1.wpression1
        @wpression12 = brideICA_maillage_secondaire1.wpression2
        @wsup.set w

    
    
# # # # # # # # # # # # # # # # # # # # # # # # Maillage secondaire de la bride inf
        w = w + 1
        brideICA_maillage_secondaire2 = new BrideICAMaillageSecondaire
            string : "inf"
            taille_secondaire : taille_secondaire
            taille_secondaire_plaque : taille_secondaire_plaque
            w : w
            x : x
            elem : elem
            noeud : noeud
            bride_sup : bride_inf
            N_bride_sup : @N_bride_inf
            sp : sp
            a1 : a2
            b1 : b2
            c1 : c2
            d1 : d2
            e1 : e2
            f1 : f2
            g1 : g2
            r_moyen1 : r_moyen2
            Angle_sect : Angle_sect
            h_plaque1 : h_plaque2
            D_ext_plaque1 : D_ext_plaque2
            D_int_plaque1 : D_int_plaque2
            D_ext_tube1 : D_ext_tube2
            D_int_tube1 : D_int_tube2
            h_tube1 : h_tube2
            h_tube_incline1 : h_tube_incline2
            D_ext_base_tube_incline1 : D_ext_base_tube_incline2
            D_int_base_tube_incline1 : D_int_base_tube_incline2
            angle_tube_incline1 : angle_tube_incline2
            di : di
            dt : dt
            E_bride_sup : E_bride_sup
            nu_bride_sup : nu_bride_sup
            E_bride_inf : E_bride_inf
            nu_bride_inf : nu_bride_inf
        noeuds_support = brideICA_maillage_secondaire2.w # Je recupere le numero du dernier noeud du support pour pouvoir apres definir les noeuds de contact
        
        
        
#         elem = brideICA_maillage_secondaire2.elem
#         @noeud = brideICA_maillage_secondaire2.noeud
        w = parseFloat(brideICA_maillage_secondaire2.w)
        x = parseFloat(brideICA_maillage_secondaire2.x)
        @wa2 = brideICA_maillage_secondaire2.wa
        @wb2 = brideICA_maillage_secondaire2.wb
        @wc2 = brideICA_maillage_secondaire2.wc
        @wd2 = brideICA_maillage_secondaire2.wd
        @we2 = brideICA_maillage_secondaire2.we
        @wf2 = brideICA_maillage_secondaire2.wf
        @wpression21 = brideICA_maillage_secondaire2.wpression1
        @wpression22 = brideICA_maillage_secondaire2.wpression2
        @winf.set w
#         console.log elem
# # # # # # # # # # # # # # # # # # Maillage secondaire de la vis traité
#       Un seul element poutre pour le maillage de la vis
        w = w + 1
#         console.log w
        noeud.push {}
        noeud[w - 1].r = 0.5 * di
        noeud[w - 1].z = @vis[0].z      
        w = w + 1
        noeud.push {}
        noeud[w - 1].r = 0.5 * di
        noeud[w - 1].z = @vis[1].z
        x = x + 1
#         console.log @noeud
#         console.log x
        elem.push {}
        elem[x - 1].noeud1 = w - 1
        elem[x - 1].noeud2 = w
        elem[x - 1].E = E_fixation # Le module d elasticite de l element de fixation
        elem[x - 1].nu = nu_fixation # Le coefficient de Poisson de l element de fixation
        elem[x - 1].type = 5
#       Geom1, geom2 et geom3  representent les proprietes des elements qui
#       seront utilisees pour calculer les termes de la matrice de raideur
        elem[x - 1].geom1 = Ae # Section equivalente calculee dans la fonction souplesse
        elem[x - 1].geom2 = Ie # Moment quadratique equivalent calcule dans la fonction souplesse
        elem[x - 1].geom3 = 0
#         console.log elem
        @_bride_sup.set bride_sup
        @_bride_inf.set bride_inf        
        @plot_maillage(app)
        
        @elem.set elem
        @noeud.set noeud
#         console.log @elem
        
# # # # # # # # # # # # # # # # # # # # # # # # # #  Fin definition noeuds secondaire # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 
# # # # # # # # # # # # # # # # # # # # # # # # # #  Dessin  des graphes  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 
 
    plot_maillage:(app)->
 
        x1 = []
        y1 = []
        for k in [0 .. 8]
            x1.push @_bride_sup[k].r
            y1.push @_bride_sup[k].z
#         xsec = []
#         ysec = []              
#         
#         for k in [0 .. wsup - 1]
#             xsec.push noeud[k].r
#             ysec.push noeud[k].z
        
        x2 = []
        y2 = []
        for k in [0 ..8]
            x2.push @_bride_inf[k].r
            y2.push @_bride_inf[k].z
        
#         x2sec = []
#         y2sec = []
#         
#         for k in [wsup .. winf - 1]
#             x2sec.push noeud[k].r
#             y2sec.push noeud[k].z
        
        
# # # # # # # # # # # # # # # # # # # # # # # # # AFFICHAGE DE LA POP-UP # # # # # # # # # # # # # # # # # # # # # # # # # #       
        inst = undefined
        for inst_i in app.selected_canvas_inst()
            inst = inst_i             
                
        if (inst.divCanvas)?
            Ptop   = @getTop( inst.div )  
            Pleft  = @getLeft( inst.div )  
            Pwidth = inst.divCanvas.offsetWidth - 20
            Pheight = inst.divCanvas.offsetHeight
            Pheight = Pheight + 22
        else
            Ptop   = 100
            Pleft  = 100
            Pwidth = 800 
            Pheight = 500          
        

        p = new_popup "Image Viewer", top_x: Pleft, top_y: Ptop, width: Pwidth, height: Pheight, onclose: =>
            @onPopupClose( app )
        app.active_key.set false 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
        
        p1 = new_dom_element
            parentNode: p
            nodeName: "div"
            style: 
              height: Pheight - 40
              width: "49%"
              cssFloat: "left"
#               backgroundColor: "red"
        
        p2 = new_dom_element
            parentNode: p
            nodeName: "div"
            style: 
              height: Pheight - 40
              width: "49%"
              cssFloat: "right"
#               backgroundColor: "blue"
        
        my_data1 = new Lst
        my_data1.push x1
        my_data1.push y1
#         console.log my_data1
        cjscv1 = new CanvasJSChartView p1, my_data1,
            title:"Bride Superieur"
            fontColor:"red"
            color:"red"
#             backgroundColor: "blue"
        
        my_data2 = new Lst
        my_data2.push x2
        my_data2.push y2
        
        cjscv2 = new CanvasJSChartView p2, my_data2,
            title:"Bride Inferieur"
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
      
      
        