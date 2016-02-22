# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#

class BrideICAResolve extends MatriceItem
    constructor: ( @bride_children, @assemblage, @ForceAxiale, @U_resultat2 ) ->
        super()
        
        @_name.set "Resolve"
        @_viewable.set false
        

        if @bride_children?
            @resolve()
    
    
    resolve: ( ) ->
        #assemblage
        matrice_globale4 = @m_copy @assemblage.matrice_globale4
        effort = @assemblage.effort
        k_poutre =  @assemblage.k_poutre
        
        #ajout contact
        contact = @bride_children[5].contact
        k_contact = @bride_children[5].k_contact
        
        #maillage
        wsup = @bride_children[4].wsup.get()
        winf = @bride_children[4].winf.get()
        noeud = @bride_children[4].noeud.get()
        wa1 = @bride_children[4].wa1.get()
        wb1 = @bride_children[4].wb1.get()
        wa2 = @bride_children[4].wa2.get()
        wb2 = @bride_children[4].wb2.get()
        
        wc1 = @bride_children[4].wc1.get()
        wc2 = @bride_children[4].wc2.get()
        wd1 = @bride_children[4].wd1.get()
        wd2 = @bride_children[4].wd2.get()
        
        we1 = @bride_children[4].we1.get()
        we2 = @bride_children[4].we2.get()
        wf1 = @bride_children[4].wf1.get()
        wf2 = @bride_children[4].wf2.get()
        
        wpression11 = @bride_children[4].wpression11.get()
        wpression12 = @bride_children[4].wpression12.get()
        wpression21 = @bride_children[4].wpression21.get()
        wpression22 = @bride_children[4].wpression22.get()
          
        #souplesse   
        Angle_sect = @bride_children[3].Angle_sect.get()  
          
        #reglages
        epsiloncontact = @bride_children[2].epsiloncontact.get()
          
        #données
        Diametre_resultat = @bride_children[1].Diametre_resultat.get() 
        hauteur_resultat = @bride_children[1].hauteur_resultat.get()  
        L_serree = @bride_children[1].L_serree.get()
        h_plaque1 = @bride_children[1].h_plaque1.get()
        h_plaque2 = @bride_children[1].h_plaque2.get()
        D_int_plaque1 = @bride_children[1].D_int_plaque1.get()
        D_int_plaque2 = @bride_children[1].D_int_plaque2.get()              
        angle_tube_incline2 = @bride_children[1].angle_tube_incline2.get()
        angle_tube_incline1 = @bride_children[1].angle_tube_incline1.get()
        Pression = @bride_children[1].Pression.get()
        MomentOrthoRad = @bride_children[1].MomentOrthoRad.get()
        coef_mag = @bride_children[1].coef_mag.get()
        
        #géométrie
        Nombre_increments = @bride_children[0].chargement.Pas_de_chargement.get()
        precontrainte = @bride_children[0].chargement.Precharge.get()

        #spécifique
        ForceAxiale = @ForceAxiale
        U_resultat2 = @U_resultat2

        #résolution----------------------------------------------------------------------------------------------------------
        
        #--------------------------------------
        #    Initialisation effort et contact
        #--------------------------------------
        
        matrice_globale5 = @m_copy matrice_globale4
        effort = math.transpose(effort)
        
        # Il est intéréssant de bloquer les 2 points intérieurs des plaques pour le
        # cas d'un montage parfaitement symétrique, enlever les relations
        # cinématiques d'assemblage.m, appliquer deux efforts symétriques et
        # vérifier : 1) que la matrice globale est bien la concaténation de 2
        # matrices identique 2) vérifier que la solution engendre des déformations
        # parfaitements symétriques:

        #effort(3*wd1-1)= -1*precontrainte;
        #effort(3*wd2-1)= 1*precontrainte;
        
        length_effort = @m_length(effort)
        @m_set effort, (length_effort - 1), 1, (1*precontrainte)
        @m_set effort, (length_effort - 4), 1, (-1*precontrainte)

        contact_actif = [1 .. contact.length]
        matrice = @ajout_contact(matrice_globale5, contact_actif, k_contact, contact)
       
        #--------------------------------------
        #    Tout ce qui est bloquage
        #--------------------------------------
        
        effort = @m_pop_lin effort, (3*(winf-1)+3)
        effort = @m_pop_lin effort, (3*(winf-1)+2)
        effort = @m_pop_lin effort, (3*(winf-1)+1)
        
        matrice = @m_pop_lin matrice, (3*(winf-1)+3)
        matrice = @m_pop_lin matrice, (3*(winf-1)+2)
        matrice = @m_pop_lin matrice, (3*(winf-1)+1)
        
        matrice = @m_pop_col matrice, (3*(winf-1)+3)
        matrice = @m_pop_col matrice, (3*(winf-1)+2)
        matrice = @m_pop_col matrice, (3*(winf-1)+1)
        
        effort = @m_pop_lin effort, (3*(wsup-1)+1)
        matrice = @m_pop_lin matrice, (3*(wsup-1)+1)
        matrice = @m_pop_col matrice, (3*(wsup-1)+1)
        
        

        #%%%%%%%%%%%%%%%%%%%%%%%%%%
        #Resolution du systeme F=KU
        #%%%%%%%%%%%%%%%%%%%%%%%%%%

        console.log matrice
        Inv = math.inv(matrice)
        console.log Inv
        console.log math.transpose(effort)
#         console.log math.det(matrice)
#         
        U = math.multiply( Inv , effort)
        console.log math.transpose(U)

        
        U = math.lusolve(matrice,effort)
        console.log math.transpose(U)
        
        #Rajout des points bloqués pour retrouver l'indexage initial
#         U = [ U(1:3*(wsup-1)) ; 0; U(3*(wsup-1)+1:length(U)) ];
        U = @m_push_lin U, (3*(wsup-1)), 0
#         console.log U
#         matrice.subset(math.index(i-1,j-1), val)
#         
#         
#         U = [ U(1:3*(winf-1)) ; 0; 0; 0; U(3*(winf-1)+1:length(U)) ];
        # Pour le test de symetrie
        # U=[0;0;0;U];
        # U=[U(1:3*wsup);0;0;0;U(3*wsup+1:length(U))];     
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    ajout_contact : (matrice_ajout,contact_actif,k_contact,contact)->

        matrice = @m_copy matrice_ajout
        
        for tett in [1 .. contact_actif.length]
            #Matrice de raideur dans le repere local
            k_ressort = math.zeros(6,6)
            @m_set k_ressort, 1, 1, @m_get( k_contact, 1, contact_actif[tett-1] )
            @m_set k_ressort, 1, 4, (- @m_get( k_contact, 1, contact_actif[tett-1] )) 
            @m_set k_ressort, 4, 1, (- @m_get( k_contact, 1, contact_actif[tett-1] ))
            @m_set k_ressort, 4, 4, @m_get( k_contact, 1, contact_actif[tett-1] )
            
            #Matrice de passage
            pressort = math.zeros(6,6)
            @m_set pressort, 1, 2, 1
            @m_set pressort, 2, 1, -1
            @m_set pressort, 3, 3, -1
            @m_set pressort, 4, 5, 1
            @m_set pressort, 5, 4, -1
            @m_set pressort, 6, 6, -1
            
            #Matrice dans le repere global
            k_ressort_global = @m_change_rep pressort,k_ressort
            noeud1 = contact[contact_actif[tett-1]-1].noeudmaitre
            noeud2 = contact[contact_actif[tett-1]-1].noeudesclave
            
            #Implantation dans la matrice globale
            @m_set matrice, 3*noeud1-1, 3*noeud1-1, (@m_get(matrice, 3*noeud1-1, 3*noeud1-1) + @m_get(k_ressort_global, 2, 2))
            @m_set matrice, 3*noeud1-1, 3*noeud2-1, (@m_get(matrice, 3*noeud1-1, 3*noeud2-1) + @m_get(k_ressort_global, 2, 5))
            @m_set matrice, 3*noeud2-1, 3*noeud1-1, (@m_get(matrice, 3*noeud2-1, 3*noeud1-1) + @m_get(k_ressort_global, 5, 2))
            @m_set matrice, 3*noeud2-1, 3*noeud2-1, (@m_get(matrice, 3*noeud2-1, 3*noeud2-1) + @m_get(k_ressort_global, 5, 5))
            
        return matrice
