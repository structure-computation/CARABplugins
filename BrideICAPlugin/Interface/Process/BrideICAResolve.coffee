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
        
        matrice = @m_pop_col matrice, (3*(winf-1)+3)
        matrice = @m_pop_col matrice, (3*(winf-1)+2)
        matrice = @m_pop_col matrice, (3*(winf-1)+1)
        
        matrice = @m_pop_lin matrice, (3*(winf-1)+3)
        matrice = @m_pop_lin matrice, (3*(winf-1)+2)
        matrice = @m_pop_lin matrice, (3*(winf-1)+1)
        
        effort = @m_pop_lin effort, (3*(wsup-1)+1)
        matrice = @m_pop_col matrice, (3*(wsup-1)+1)
        matrice = @m_pop_lin matrice, (3*(wsup-1)+1)
        

        #%%%%%%%%%%%%%%%%%%%%%%%%%%
        #Resolution du systeme F=KU
        #%%%%%%%%%%%%%%%%%%%%%%%%%%
        U = math.multiply( math.inv(matrice), effort)
        
        #Rajout des points bloqués pour retrouver l'indexage initial
        U = @m_push_lin U, (3*(wsup-1)), 0
        U = @m_push_lin U, (3*(winf-1)), 0
        U = @m_push_lin U, (3*(winf-1)+1), 0
        U = @m_push_lin U, (3*(winf-1)+2), 0

        # Pour le test de symetrie
        # U=[0;0;0;U];
        # U=[U(1:3*wsup);0;0;0;U(3*wsup+1:length(U))];    
               
        #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        #Traitement contact Convergence contact
        #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        #Initialisation
        contact_actif_next = []
        for i in [1 .. contact.length]
            if ( (@m_get(U, (3*contact[i-1].noeudmaitre-1), 1) < 0) and (@m_get(U, (3*contact[i-1].noeudesclave-1), 1) > 0) ) or ( @m_get(U, (3*contact[i-1].noeudmaitre-1), 1) - @m_get(U, (3*contact[i-1].noeudesclave-1), 1) <= epsiloncontact )
                contact_actif_next.push i
      
        #Heredite
        while sum != 0
            
            contact_actif = contact_actif_next
            matrice = @ajout_contact(matrice_globale5, contact_actif, k_contact, contact)
            
            matrice = @m_pop_lin matrice, (3*(winf-1)+3)
            matrice = @m_pop_lin matrice, (3*(winf-1)+2)
            matrice = @m_pop_lin matrice, (3*(winf-1)+1)
            
            matrice = @m_pop_col matrice, (3*(winf-1)+3)
            matrice = @m_pop_col matrice, (3*(winf-1)+2)
            matrice = @m_pop_col matrice, (3*(winf-1)+1)
            
            matrice = @m_pop_lin matrice, (3*(wsup-1)+1)
            matrice = @m_pop_col matrice, (3*(wsup-1)+1)            

            # Pour le test de symetrie:
            # matrice(3*wsup+1,:)=[]; % On supprime la ligne correspondante
            # matrice(:,3*wsup+1)=[]; % On supprime la colonne correspodante
            # matrice(3*wsup+1,:)=[]; % On supprime la ligne correspondante
            # matrice(:,3*wsup+1)=[]; % On supprime la colonne correspodante
            # matrice(3*wsup+1,:)=[]; % On supprime la ligne correspondante
            # matrice(:,3*wsup+1)=[]; % On supprime la colonne correspodante
            # matrice(1,:)=[]; % On supprime la ligne correspondante
            # matrice(:,1)=[]; % On supprime la colonne correspodante
            # matrice(1,:)=[]; % On supprime la ligne correspondante
            # matrice(:,1)=[]; % On supprime la colonne correspodante
            # matrice(1,:)=[]; % On supprime la ligne correspondante
            # matrice(:,1)=[]; % On supprime la colonne correspodante
            
            U = math.multiply( math.inv(matrice), effort)

            U = @m_push_lin U, (3*(wsup-1)), 0
            U = @m_push_lin U, (3*(winf-1)), 0
            U = @m_push_lin U, (3*(winf-1)), 0
            U = @m_push_lin U, (3*(winf-1)), 0

            contact_actif_next = []
            for i in [1 .. contact.length]
                if ( @m_get(U, (3*contact[i-1].noeudmaitre-1), 1) < 0 and @m_get(U, (3*contact[i-1].noeudesclave-1), 1) > 0 ) or ( @m_get(U, (3*contact[i-1].noeudmaitre-1), 1) - @m_get(U, (3*contact[i-1].noeudesclave-1), 1) <= epsiloncontact )                
                    contact_actif_next.push i
            
            sum = -1    
            if contact_actif_next.length == contact_actif.length    
                sum = 0
                for i in [1 .. contact_actif_next.length]
                    if contact_actif_next[i-1] != contact_actif[i-1]
                        sum += 1
                                    
        #Déplacement vertical 
        decal_noeuds = @m_get(U, (@m_length(U)-1), 1) - @m_get(U, (@m_length(U)-4), 1)
        
        # Pour le test de symetrie:
        # display('Taille matrice globale 4 : ')
        # L=length(matrice_globale4)
        # display('la moitier : ')
        # l=L/2
        # A1=matrice_globale4(1:l,1:l);
        # A2=matrice_globale4(l+1:L,l+1:L);
        # display('A1 taille:')
        # size(A1)
        # display('A2 taille:')
        # size(A2)
        # display('A1 et A2 ont meme contenu en valeur absolu :')
        # 0==sum(sum(abs(full(A1))~=abs(full(A2))))
        # 
        # a1=U(1:3:3*wsup);
        # a2=U(3*wsup+1:3:3*winf);
        # b1=U(2:3:3*wsup);
        # b2=U(3*wsup+2:3:3*winf);
        # c1=U(3:3:3*wsup);
        # c2=U(3*wsup+3:3:3*winf);
        # display('Y a t il symetrie des déplacements :')
        # a1==a2
        # b1==-b2
        # c1==-c2
        # 
        # sum(a1-a2)/length(a1)
        # sum(b1+b2)/length(b1)
        # sum(c1+c2)/length(c1)


        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %%%Calcul des contraintes dans la vis :
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
        dep = math.zeros(1,6)
        @m_set dep,1,1, (- @m_get(U, (@m_length(U)-7), 1)) 
        @m_set dep,1,2, (@m_get(U, (@m_length(U)-8), 1)) 
        @m_set dep,1,3, (- @m_get(U, (@m_length(U)-6), 1)) 
        @m_set dep,1,4, (- @m_get(U, (@m_length(U)-4), 1)) 
        @m_set dep,1,5, (@m_get(U, (@m_length(U)-5), 1)) 
        @m_set dep,1,6, (- @m_get(U, (@m_length(U)-3), 1)) 
        
        traction_vis1 = @m_get(U, (3*(noeud.length-1) - 1), 1) - @m_get(U, (3*noeud.length - 1), 1)
        
        #Calcul de F1r,F1z,M1 et de F2r,F2z et de M2
        force = math.multiply(k_poutre, math.transpose(dep))
        
        #Calcul des efforts, des moments et des contraintes
        Effort_axial = math.zeros(1,2)
        Sigma_axiale = math.zeros(1,2)
        Moment_flexion = math.zeros(1,2)
        Sigma_flexion = math.zeros(1,2)
        Sigma_totale = math.zeros(1,2)
        Decollement_Rint = math.zeros(1,2)
        Decollement_Rext = math.zeros(1,2)
        
        @m_set Effort_axial,1,1, (- @m_get(force,1,1))
        @m_set Sigma_axiale,1,1, (4 * @m_get(Effort_axial,1,1) / (Math.PI * Diametre_resultat * Diametre_resultat))
        @m_set Moment_flexion,1,1, ( (@m_get(force,6,1) + @m_get(force,3,1)) / L_serree * hauteur_resultat - @m_get(force,3,1) )
        @m_set Sigma_flexion,1,1, ( Math.abs( 32 * @m_get(Moment_flexion,1,1) / (Math.PI * Diametre_resultat * Diametre_resultat * Diametre_resultat)))
        @m_set Sigma_totale,1,1, ( @m_get(Sigma_axiale,1,1) + @m_get(Sigma_flexion,1,1) )
        @m_set Decollement_Rint,1,1, ( noeud[ contact[ Math.min.apply(Math, contact_actif) - 1].noeudmaitre - 1 ].r )
        @m_set Decollement_Rext,1,1, ( noeud[ contact[ Math.max.apply(Math, contact_actif) - 1].noeudmaitre - 1 ].r )
          
#         console.log Effort_axial
#         console.log Sigma_axiale
#         console.log Moment_flexion
#         console.log Sigma_flexion
#         console.log Sigma_totale
#         console.log Decollement_Rint
#         console.log Decollement_Rext
        
        # %%%%%%%
        # %%PLOTS
        # %%%%%%%
        @U = new Lst
        for i in [ 1 .. @m_length(U)]
            @U.push @m_get(U, i, 1)
        
        
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
            @m_set pressort, 2, 1, (-1)
            @m_set pressort, 3, 3, (-1)
            @m_set pressort, 4, 5, 1
            @m_set pressort, 5, 4, (-1)
            @m_set pressort, 6, 6, (-1)
            
            #Matrice dans le repere global
            k_ressort_global = @m_change_rep pressort,k_ressort
            noeud1 = contact[contact_actif[tett-1]-1].noeudmaitre
            noeud2 = contact[contact_actif[tett-1]-1].noeudesclave
            
            #Implantation dans la matrice globale
            @m_set matrice, (3*noeud1-1), (3*noeud1-1), (@m_get(matrice, (3*noeud1-1), (3*noeud1-1)) + @m_get(k_ressort_global, 2, 2))
            @m_set matrice, (3*noeud1-1), (3*noeud2-1), (@m_get(matrice, (3*noeud1-1), (3*noeud2-1)) + @m_get(k_ressort_global, 2, 5))
            @m_set matrice, (3*noeud2-1), (3*noeud1-1), (@m_get(matrice, (3*noeud2-1), (3*noeud1-1)) + @m_get(k_ressort_global, 5, 2))
            @m_set matrice, (3*noeud2-1), (3*noeud2-1), (@m_get(matrice, (3*noeud2-1), (3*noeud2-1)) + @m_get(k_ressort_global, 5, 5))
            
        return matrice
