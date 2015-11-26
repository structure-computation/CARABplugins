# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICACalculContact extends TreeItem
    constructor: ( @bride_children ) ->
        super()
        
        @_name.set "Ajout Contact"
        @_viewable.set false
        
        @add_attr
            k_contact : 0
            sp_contact : 0
            contact : 0
        
        
        
        @calcul_contact()
        
        
    add_in_lst: ( lst ) ->  
        add = 0
        for i in [ 0 .. lst.length - 1 ]
            add += lst[i] 
        return add
      
    calcul_contact: ( ) ->
        calage_contact = @bride_children[1].calage_contact.get()
        nombredefixation = @bride_children[1].nombredefixation.get()
        di = @bride_children[1].di.get()
        dt = @bride_children[1].dt.get()
        E_bride_sup = @bride_children[1].E_bride_sup.get()
        E_bride_inf = @bride_children[1].E_bride_inf.get()
        h_plaque1 = @bride_children[1].h_plaque1.get()
        h_plaque2 = @bride_children[1].h_plaque2.get()
        Crep = @bride_children[2].Crep.get()
        sptotale = @bride_children[3].sptotale.get()
        noeud = @bride_children[4].noeud.get()
        wa1 = @bride_children[4].wa1.get()
        wb1 = @bride_children[4].wb1.get()
        wa2 = @bride_children[4].wa2.get()
        wb2 = @bride_children[4].wb2.get()
        
#         console.log "calage_contact = " + calage_contact
#         console.log "nombredefixation = " + nombredefixation
#         console.log "di = " + di
#         console.log "dt = " + dt
#         console.log "E_bride_sup = " + E_bride_sup
#         console.log "E_bride_inf = " + E_bride_inf
#         console.log "h_plaque1 = " + h_plaque1
#         console.log "h_plaque2 = " + h_plaque2
#         console.log "Crep = " + Crep
#         console.log "sptotale = " + sptotale
#         console.log noeud
#         console.log "wa1 = " + wa1
#         console.log "wb1 = " + wb1
#         console.log "wa2 = " + wa2
#         console.log "wb2 = " + wb2

        i = 0
        contact = []
        noeudprimb = noeud
        noeudprims = noeud
        
        for k in [wa1 .. wb1]
            for j in [wa2 .. wb2]
                if (Math.abs(noeudprims[j - 1].r - noeudprimb[k - 1].r) == 0)
                    i = i + 1
                    contact.push {}
                    contact[i - 1].noeudmaitre = k
                    contact[i - 1].noeudesclave = j
        contact_length = contact.length
#         console.log contact_length
        switch calage_contact
            when 1
                sp_contact = Crep * sptotale
                raideur_contact = 1 / sp_contact
                rayon_externe = noeudprimb[contact[contact_length - 1].noeudmaitre].r
                rayon_interne = noeudprimb[contact[0].noeudmaitre].r
                surf_contact = Math.PI * ( rayon_externe * rayon_externe ) / nombredefixation - Math.PI * ( rayon_interne * rayon_interne ) / nombredefixation
                
                k_contact = math.zeros(1, contact_length)
                
                for i in [ 1 .. contact_length - 1 ]
                    r_int = noeudprimb[contact[i - 1].noeudmaitre].r
                    r_ext = noeudprimb[contact[i].noeudmaitre].r
                    surf[i - 1] = Math.PI * ( r_ext * r_ext - r_int * r_int ) / nombredefixation
                    k_contact[i - 1] = k_contact[i - 1] + 0.5 * raideur_contact * surf[i - 1] / surf_contact
                    k_contact[i] = k_contact[i] + 0.5 * raideur_contact * sur[i - 1] / surf_contact
#                     console.log "switch case 1"
                
            when 0
                k_contact = math.zeros(1, contact_length)
                console.log "k_contact = " + k_contact
                for i in [ 1 .. contact_length - 1 ]
                    r_int = noeudprimb[contact[i - 1].noeudmaitre].r
                    r_ext = noeudprimb[contact[i].noeudmaitre].r
                    if ( Math.abs(0.5 * di - 0.5 * ( r_int + r_ext ) ) < 0.5 * dt )
                        ep_vide = 2 * Math.sqrt( Math.pow( ( 0.5 * dt ), 2 ) - Math.pow( ( ( r_int + r_ext ) / 2 - ( 0.5 * di ) ), 2 ) )
                        A = ep_vide * Math.abs( r_ext - r_int )
                    else
                        A = Math.PI * ( Math.pow( r_ext, 2 ) - Math.pow( r_int, 2) ) / nombredefixation
                    k_bride1 = 2 * E_bride_sup * A / h_plaque1
                    k_bride2 = E_bride_inf * A / h_plaque2
                    contact_eq = ( k_bride1 * k_bride2 ) / ( k_bride1 + k_bride2 )
                    k_contact[i - 1] = k_contact[i - 1] + 0.5 * contact_eq
                    k_contact[i] = k_contact[i] + 0.5 * contact_eq
                sp_contact = 1 / @add_in_lst(k_contact)
                console.log r_ext - r_int
                console.log Math.abs(r_ext - r_int)
                console.log "r_int = " + r_int
                console.log "r_ext = " + r_ext
                console.log "ep_vide = " + ep_vide
                console.log "A = " + A
                

#                 console.log "switch case 0"
#         console.log k_contact
#         console.log sp_contact
#         console.log contact
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                