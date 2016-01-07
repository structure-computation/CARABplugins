# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICACalculContact extends TreeItem
    constructor: ( @bride_children ) ->
        super()
        
        @_name.set "Ajout Contact"
        @_viewable.set false
        
#         @k_contact = 0
#         @sp_contact = 0
#         @contact = []
        
        
        if @bride_children?
            @calcul_contact()
        
      
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

        
#  -----------------------------------------------------------------------------------------------------------------------------------------------------------       
        i = 0
        noeudprimb = noeud
        noeudprims = noeud
        @contact = []
        for k in [wa1 .. wb1]
            for j in [wa2 .. wb2]
                if (Math.abs(noeudprims[j - 1].r - noeudprimb[k - 1].r) == 0)
                    i = i + 1
                    @contact.push {}
                    @contact[i - 1].noeudmaitre = k
                    @contact[i - 1].noeudesclave = j
        contact_length = @contact.length
        switch calage_contact
            when 1
                @sp_contact = Crep * sptotale
                raideur_contact = 1 / @sp_contact
                rayon_externe = noeudprimb[@contact[contact_length - 1].noeudmaitre].r
                rayon_interne = noeudprimb[@contact[0].noeudmaitre].r
                surf_contact = Math.PI * ( rayon_externe * rayon_externe ) / nombredefixation - Math.PI * ( rayon_interne * rayon_interne ) / nombredefixation
                
                @k_contact = math.zeros(1, contact_length)
                surf = []
                for i in [ 1 .. contact_length - 1 ]
                    r_int = noeudprimb[@contact[i - 1].noeudmaitre].r
                    r_ext = noeudprimb[@contact[i].noeudmaitre].r
                    surf.push {}
                    surf[i - 1] = Math.PI * ( r_ext * r_ext - r_int * r_int ) / nombredefixation
                    @k_contact.subset(math.index(0, i - 1), (@k_contact.get([0, i - 1]) + 0.5 * raideur_contact * surf[i - 1] / surf_contact ) )
                    @k_contact.subset(math.index(0, i), (@k_contact.get([0, i]) + 0.5 * raideur_contact * sur[i - 1] / surf_contact ) )
                
            when 0
                @k_contact = math.zeros(1, contact_length)
                for i in [ 1 .. contact_length - 1 ]
                    r_int = noeudprimb[@contact[i - 1].noeudmaitre - 1].r
                    r_ext = noeudprimb[@contact[i].noeudmaitre - 1].r
                    
#                     console.log "r_int = " + r_int
#                     console.log "r_ext = " + r_ext
                    if ( Math.abs(0.5 * di - 0.5 * ( r_int + r_ext ) ) < 0.5 * dt )
                        ep_vide = 2 * Math.sqrt( Math.pow( ( 0.5 * dt ), 2 ) - Math.pow( ( ( r_int + r_ext ) / 2 - ( 0.5 * di ) ), 2 ) )
                        A = ep_vide * Math.abs( r_ext - r_int )
                    else
                        A = Math.PI * ( Math.pow( r_ext, 2 ) - Math.pow( r_int, 2) ) / nombredefixation
                    k_bride1 = 2 * E_bride_sup * A / h_plaque1
                    k_bride2 = E_bride_inf * A / h_plaque2
                    contact_eq = ( k_bride1 * k_bride2 ) / ( k_bride1 + k_bride2 )
                    @k_contact.subset(math.index(0, i - 1), (@k_contact.get([0, i - 1]) + 0.5 * contact_eq))
                    @k_contact.subset(math.index(0, i), (@k_contact.get([0, i]) + 0.5 * contact_eq))
                @sp_contact = 1 / math.sum(@k_contact)
        

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                