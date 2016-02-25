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
        
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %                                 SERRAGE
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %                                 SERRAGE
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
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
        Effort_axial = math.zeros(2,1)
        Sigma_axiale = math.zeros(2,1)
        Moment_flexion = math.zeros(2,1)
        Sigma_flexion = math.zeros(2,1)
        Sigma_totale = math.zeros(2,1)
        Decollement_Rint = math.zeros(2,1)
        Decollement_Rext = math.zeros(2,1)
        
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
        @U_serrage = new Lst
        for i in [ 1 .. @m_length(U)]
            @U_serrage.push @m_get(U, i, 1)
        
        
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %                              CONTRAINTES
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %                              CONTRAINTES
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
        
        matrice_globale6 = @m_copy matrice_globale4
        
        
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %Relation lineaire des 2 noeuds d app de precontrainte
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        Bettaz = Math.max( @m_get( matrice_globale6, (3*noeud.length-1), (3*noeud.length-1) ), @m_get( matrice_globale6, (@m_length(matrice_globale6)-1), (@m_length(matrice_globale6)-1) ) )

        for i in [1 .. @m_length(matrice_globale5)]
            if ( i != 3 * noeud.length-1 ) and ( i != @m_length(matrice_globale5)-1 )
                for j in [ 1 .. @m_length(matrice_globale5)]
                    if j == j == 3*noeud.length-1
                        @m_set matrice_globale6, i, j, 0
                    else if j == @m_length(matrice_globale5)-1
                        @m_set matrice_globale6, i, j, ( @m_get( matrice_globale5, i, j ) + @m_get( matrice_globale5, i, (3*noeud.length-1) ) )
                    else
                        @m_set matrice_globale6, i, j, @m_get matrice_globale5, i, j        
        
            else if i == @m_length(matrice_globale5)-1
                for j in [ 1 .. @m_length(matrice_globale5)]
                    if j == j == 3*noeud.length-1
                        @m_set matrice_globale6, i, j, 0
                    else if j == @m_length(matrice_globale5)-1
                        @m_set matrice_globale6, i, j, ( @m_get( matrice_globale5, i, j ) + @m_get( matrice_globale5, i, (3*noeud.length-1) ) + @m_get( matrice_globale5, (3*noeud.length-1), j) + @m_get( matrice_globale5, (3*noeud.length-1), (3*noeud.length-1) ) )
                    else
                        @m_set matrice_globale6, i, j, ( @m_get( matrice_globale5, i, j ) + @m_get( matrice_globale5, (3*noeud.length-1), j) )            
        
            else if i == 3 * noeud.length-1
                for j in [ 1 .. @m_length(matrice_globale5)]
                    if j == j == 3*noeud.length-1
                        @m_set matrice_globale6, i, j, (-Bettaz)
                    else if j == @m_length(matrice_globale5)-1
                        @m_set matrice_globale6, i, j, Bettaz
                    else
                        @m_set matrice_globale6, i, j, 0
                        
                        
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %%%%%Initialisation effort et contact
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        effort = math.zeros( @m_length(matrice_globale5), 1 )
        
        for i in [1 .. @m_length(matrice_globale5) ]
            if ( i != 3 * noeud.length-1 ) and ( i != @m_length(matrice_globale5)-1 )
                @m_set effort, i, 1, ( decal_noeuds * @m_get(matrice_globale5, i, (3 * noeud.length-1)) ) 
            else if i == @m_length(matrice_globale5)-1
                @m_set effort, i, 1, ( decal_noeuds * ( @m_get(matrice_globale5, i, (3 * noeud.length-1)) + @m_get( matrice_globale5, (3*noeud.length-1), (3*noeud.length-1)) ) ) 
            else if i == 3 * noeud.length-1
                @m_set effort, i, 1, Bettaz * decal_noeuds        
        
        effort1 = @app_charge(noeud,contact,contact_actif,Nombre_increments,Nombre_increments,effort,Pression,ForceAxiale,MomentOrthoRad,Angle_sect,D_int_plaque1,D_int_plaque2,angle_tube_incline1,angle_tube_incline2,h_plaque1,h_plaque2,wa1,wa2,wf1,wf2,wpression11,wpression12,wpression21,wpression22,winf,wsup)
        effortinit = @v_copy effort1
        matrice = @ajout_contact(matrice_globale6,contact_actif,k_contact,contact)
        
        #--------------------------------------
        #    Tout ce qui est bloquage
        #--------------------------------------
        
        effort1 = @m_pop_lin effort1, (3*(winf-1)+3)
        effort1 = @m_pop_lin effort1, (3*(winf-1)+2)
        effort1 = @m_pop_lin effort1, (3*(winf-1)+1)
        
        matrice = @m_pop_col matrice, (3*(winf-1)+3)
        matrice = @m_pop_col matrice, (3*(winf-1)+2)
        matrice = @m_pop_col matrice, (3*(winf-1)+1)
        
        matrice = @m_pop_lin matrice, (3*(winf-1)+3)
        matrice = @m_pop_lin matrice, (3*(winf-1)+2)
        matrice = @m_pop_lin matrice, (3*(winf-1)+1)
        
        effort1 = @m_pop_lin effort1, (3*(wsup-1)+1)
        matrice = @m_pop_col matrice, (3*(wsup-1)+1)
        matrice = @m_pop_lin matrice, (3*(wsup-1)+1)
        

        #%%%%%%%%%%%%%%%%%%%%%%%%%%
        #Resolution du systeme F=KU
        #%%%%%%%%%%%%%%%%%%%%%%%%%%
        U = math.multiply( math.inv(matrice), effort1)
        
        #Rajout des points bloqués pour retrouver l'indexage initial
        U = @m_push_lin U, (3*(wsup-1)), 0
        U = @m_push_lin U, (3*(winf-1)), 0
        U = @m_push_lin U, (3*(winf-1)+1), 0
        U = @m_push_lin U, (3*(winf-1)+2), 0

        #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        #Convergence contact et convergence pression
        #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        #Initialisation
        contact_actif_next = []
        for i in [1 .. contact.length]
            if ( (@m_get(U, (3*contact[i-1].noeudmaitre-1), 1) < 0) and (@m_get(U, (3*contact[i-1].noeudesclave-1), 1) > 0) ) or ( @m_get(U, (3*contact[i-1].noeudmaitre-1), 1) - @m_get(U, (3*contact[i-1].noeudesclave-1), 1) <= epsiloncontact )
                contact_actif_next.push i
      
        #Heredite
        while sum2 != 0
            while sum1 != 0
                
                contact_actif = contact_actif_next
                matrice = @ajout_contact(matrice_globale6, contact_actif, k_contact, contact)
                
                matrice = @m_pop_lin matrice, (3*(winf-1)+3)
                matrice = @m_pop_lin matrice, (3*(winf-1)+2)
                matrice = @m_pop_lin matrice, (3*(winf-1)+1)
                
                matrice = @m_pop_col matrice, (3*(winf-1)+3)
                matrice = @m_pop_col matrice, (3*(winf-1)+2)
                matrice = @m_pop_col matrice, (3*(winf-1)+1)
                
                matrice = @m_pop_lin matrice, (3*(wsup-1)+1)
                matrice = @m_pop_col matrice, (3*(wsup-1)+1)            

                U = math.multiply( math.inv(matrice), effort1)

                U = @m_push_lin U, (3*(wsup-1)), 0
                U = @m_push_lin U, (3*(winf-1)), 0
                U = @m_push_lin U, (3*(winf-1)), 0
                U = @m_push_lin U, (3*(winf-1)), 0

                contact_actif_next = []
                for i in [1 .. contact.length]
                    if ( @m_get(U, (3*contact[i-1].noeudmaitre-1), 1) < 0 and @m_get(U, (3*contact[i-1].noeudesclave-1), 1) > 0 ) or ( @m_get(U, (3*contact[i-1].noeudmaitre-1), 1) - @m_get(U, (3*contact[i-1].noeudesclave-1), 1) <= epsiloncontact )                
                        contact_actif_next.push i
                
                sum1 = -1    
                if contact_actif_next.length == contact_actif.length    
                    sum1 = 0
                    for i in [1 .. contact_actif_next.length]
                        if contact_actif_next[i-1] != contact_actif[i-1]
                            sum1 += 1

            #Ici le contact a convergé donc contact _actif_next==contact _actif
            # et la matrice est OK
            #Maintenant nous connaissons le nouveau contact stable.
            #Il y a donc peut etre un nouvel effort1 à prendre en compte 
            effort1 = @app_charge(noeud,contact,contact_actif,Nombre_increments,Nombre_increments,effort,Pression,ForceAxiale,MomentOrthoRad,Angle_sect,D_int_plaque1,D_int_plaque2,angle_tube_incline1,angle_tube_incline2,h_plaque1,h_plaque2,wa1,wa2,wf1,wf2,wpression11,wpression12,wpression21,wpression22,winf,wsup)
    
            effort1 = @m_pop_lin effort1, (3*(winf-1)+3)
            effort1 = @m_pop_lin effort1, (3*(winf-1)+2)
            effort1 = @m_pop_lin effort1, (3*(winf-1)+1)    
            
            effort1 = @m_pop_lin effort1, (3*(wsup-1)+1)
            
            U = math.multiply( math.inv(matrice), effort1)

            U = @m_push_lin U, (3*(wsup-1)), 0
            U = @m_push_lin U, (3*(winf-1)), 0
            U = @m_push_lin U, (3*(winf-1)), 0
            U = @m_push_lin U, (3*(winf-1)), 0            

            #Si l'effort1 n'a pas changé la solution non plus et contact actif next
            #devrait etre aussi inchangé. Si c'est le cas la boucle se terminera
            contact_actif_next = []
            for i in [1 .. contact.length]
                if ( @m_get(U, (3*contact[i-1].noeudmaitre-1), 1) < 0 and @m_get(U, (3*contact[i-1].noeudesclave-1), 1) > 0 ) or ( @m_get(U, (3*contact[i-1].noeudmaitre-1), 1) - @m_get(U, (3*contact[i-1].noeudesclave-1), 1) <= epsiloncontact )                
                    contact_actif_next.push i            

            sum2 = -1    
            if contact_actif_next.length == contact_actif.length    
                sum2 = 0
                for i in [1 .. contact_actif_next.length]
                    if contact_actif_next[i-1] != contact_actif[i-1]
                        sum2 += 1        
                
        
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %%%Calcul des contraintes dans la vis :
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
        dep2 = math.zeros(1,6)
        @m_set dep2,1,1, (- @m_get(U, (@m_length(U)-7), 1)) 
        @m_set dep2,1,2, (@m_get(U, (@m_length(U)-8), 1)) 
        @m_set dep2,1,3, (- @m_get(U, (@m_length(U)-6), 1)) 
        @m_set dep2,1,4, (- @m_get(U, (@m_length(U)-4), 1)) 
        @m_set dep2,1,5, (@m_get(U, (@m_length(U)-5), 1)) 
        @m_set dep2,1,6, (- @m_get(U, (@m_length(U)-3), 1)) 
        
        traction_vis2 = @m_get(U, (3*(noeud.length-1) - 1), 1) - @m_get(U, (3*noeud.length - 1), 1)
        
        #Calcul de F1r,F1z,M1 et de F2r,F2z et de M2
        force = math.multiply(k_poutre, math.transpose(dep2))
        
        #Calcul des efforts, des moments et des contraintes
        
        @m_set Effort_axial,2,1, (- @m_get(force,1,1))
        @m_set Sigma_axiale,2,1, (4 * @m_get(Effort_axial,2,1) / (Math.PI * Diametre_resultat * Diametre_resultat))
        @m_set Moment_flexion,2,1, ( (@m_get(force,6,1) + @m_get(force,3,1)) / L_serree * hauteur_resultat - @m_get(force,3,1) )
        @m_set Sigma_flexion,2,1, ( Math.abs( 32 * @m_get(Moment_flexion,2,1) / (Math.PI * Diametre_resultat * Diametre_resultat * Diametre_resultat)))
        @m_set Sigma_totale,2,1, ( @m_get(Sigma_axiale,2,1) + @m_get(Sigma_flexion,2,1) )
        @m_set Decollement_Rint,2,1, ( noeud[ contact[ Math.min.apply(Math, contact_actif) - 1].noeudmaitre - 1 ].r )
        @m_set Decollement_Rext,2,1, ( noeud[ contact[ Math.max.apply(Math, contact_actif) - 1].noeudmaitre - 1 ].r )
          
        
        # %%%%%%%
        # %%PLOTS
        # %%%%%%%
        @U_pression = new Lst
        for i in [ 1 .. @m_length(U)]
            @U_pression.push @m_get(U, i, 1)        
            
            
            
            
        
# ===========================================================================================================================================================================

    # %%%%%%%%%%%%%%%%%%%%%%%
    # %Fonction ajout_contact
    # %%%%%%%%%%%%%%%%%%%%%%%     
        
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


    # %%%%%%%%%%%%%%%%%%%%
    # %Fonction app_charge
    # %%%%%%%%%%%%%%%%%%%%

    app_charge : ( noeud, contact, contact_actif, l, Nombre_increments, effort, Pression, ForceAxiale, MomentOrthoRad, Angle_sect, D_int_plaque1, D_int_plaque2, angle_tube_incline1, angle_tube_incline2, h_plaque1, h_plaque2, wa1, wa2, wf1, wf2, wpression11, wpression12, wpression21, wpression22, winf, wsup ) ->
        effort1 = @v_copy effort
        
        Pression = Pression / 1000000
        
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        # %Forces toujours présentes quelque soit le contact
        # %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        #Force axiale appliquée au tube sup
        @m_set effort1, (3*wsup-1), 1, ( @m_get( effort1, (3*wsup-1), 1) + ForceAxiale * l / Nombre_increments )
        #Moment orthoradial appliqué à l'extrémité sup
        @m_set effort1, (3*wsup), 1, ( @m_get( effort1, (3*wsup), 1) + MomentOrthoRad * l / Nombre_increments )
        #Pression suivant R s'appliquant sur les deux premiers points
        surf = D_int_plaque1 * Angle_sect * h_plaque1 / 2
        forceu = surf * Pression * l / Nombre_increments
        @m_set effort1, (3*wa1-2), 1, ( @m_get( effort1, (3*wa1-2), 1) + forceu )
        surf = D_int_plaque2 * Angle_sect * h_plaque2 / 2
        forceu = surf * Pression * l / Nombre_increments
        @m_set effort1, (3*wa2-2), 1, ( @m_get( effort1, (3*wa2-2), 1) + forceu )        
        
        # # SUP
        #Pression sur le petit bout intérieur de la plaque1
        for k in [ wa1+1 .. wpression11 ]
            surf = Math.abs((((noeud[k-1].r)*(noeud[k-1].r))-((noeud[k-2].r)*(noeud[k-2].r)))*Math.PI*Angle_sect/(2*Math.PI))
            forcev = surf*Pression*l/Nombre_increments
            @m_set effort1, (3*(k-1)-1), 1, ( @m_get( effort1, (3*(k-1)-1), 1) - forcev / 2 )
            @m_set effort1, (3*(k-1)), 1, ( @m_get( effort1, (3*(k-1)), 1) - forcev / 2 )
        
        #Pression sur l interieur du tube incline 
        for k in [ wpression12+1 .. wf1 ]
            taille_r = Math.abs( noeud[k-1].r-noeud[k-2].r )
            taille_z = Math.abs( noeud[k-1].z-noeud[k-2].z )
            L = Math.sqrt( taille_r*taille_r + taille_z*taille_z )
            surf = L*Angle_sect*noeud[k-2].r
            forceu = Math.abs((surf*Pression*l/Nombre_increments)*@cosd(angle_tube_incline1))
            forcev = Math.abs((surf*Pression*l/Nombre_increments)*@sind(angle_tube_incline1))
            @m_set effort1, (3*(k-1)-2), 1, ( @m_get( effort1, (3*(k-1)-2), 1) - forceu / 2 )
            @m_set effort1, (3*k-2), 1, ( @m_get( effort1, (3*k-2), 1) - forceu / 2 )
            @m_set effort1, (3*(k-1)-1), 1, ( @m_get( effort1, (3*(k-1)-1), 1) - forcev / 2 )
            @m_set effort1, (3*k-1), 1, ( @m_get( effort1, (3*k-1), 1) - forcev / 2 )            
           
        #Pression sur l interieur du tube
        for k in [ wf1+1 .. wsup ]
            surf = Math.abs(((noeud[k-1].z)-(noeud[k-2].z))*(noeud[k-2].r)*Angle_sect)
            forceu = surf*Pression*l/Nombre_increments
            @m_set effort1, (3*(k-1)-2), 1, ( @m_get( effort1, (3*(k-1)-2), 1) - forceu / 2 )
            @m_set effort1, (3*k-2), 1, ( @m_get( effort1, (3*k-2), 1) - forceu / 2 )            

        # # INF
        #Pression sur le petit bout intérieur de la plaque2
        for k in [ wa2+1 .. wpression21 ]
            surf = Math.abs((((noeud[k-1].r)*(noeud[k-1].r))-((noeud[k-2].r)*(noeud[k-2].r)))*Math.PI*Angle_sect/(2*Math.PI))
            forcev = surf*Pression*l/Nombre_increments
            @m_set effort1, (3*(k-1)-1), 1, ( @m_get( effort1, (3*(k-1)-1), 1) - forcev / 2 )
            @m_set effort1, (3*(k-1)), 1, ( @m_get( effort1, (3*(k-1)), 1) - forcev / 2 )

        #Pression sur l interieur du tube incline 
        for k in [ wpression22+1 .. wf2 ]
            taille_r = Math.abs( noeud[k-1].r-noeud[k-2].r )
            taille_z = Math.abs( noeud[k-1].z-noeud[k-2].z )
            L = Math.sqrt( taille_r*taille_r + taille_z*taille_z )
            surf = L*Angle_sect*noeud[k-2].r
            forceu = Math.abs((surf*Pression*l/Nombre_increments)*@cosd(angle_tube_incline2))
            forcev = Math.abs((surf*Pression*l/Nombre_increments)*@sind(angle_tube_incline2))
            @m_set effort1, (3*(k-1)-2), 1, ( @m_get( effort1, (3*(k-1)-2), 1) - forceu / 2 )
            @m_set effort1, (3*k-2), 1, ( @m_get( effort1, (3*k-2), 1) - forceu / 2 )
            @m_set effort1, (3*(k-1)-1), 1, ( @m_get( effort1, (3*(k-1)-1), 1) - forcev / 2 )
            @m_set effort1, (3*k-1), 1, ( @m_get( effort1, (3*k-1), 1) - forcev / 2 )  
        
        #Pression sur l interieur du tube
        for k in [ wf2+1 .. winf ]
            surf = Math.abs(((noeud[k-1].z)-(noeud[k-2].z))*(noeud[k-2].r)*Angle_sect)
            forceu = surf*Pression*l/Nombre_increments
            @m_set effort1, (3*(k-1)-2), 1, ( @m_get( effort1, (3*(k-1)-2), 1) - forceu / 2 )
            @m_set effort1, (3*k-2), 1, ( @m_get( effort1, (3*k-2), 1) - forceu / 2 )     

        #Eventuel chevauchement des plaques a l'interieur
        if (D_int_plaque1 > D_int_plaque2) #Si linf dépasse de la sup
            for k in [ wa2+1 .. contact[0].noeudesclave ]
                surf = Math.abs((((noeud[k-1].r)*(noeud[k-1].r))-((noeud[k-2].r)*(noeud[k-2].r)))*Math.PI*Angle_sect/(2*Math.PI))
                forcev = surf*Pression*l/Nombre_increments
                @m_set effort1, (3*(k-1)-1), 1, ( @m_get( effort1, (3*(k-1)-1), 1) - forcev / 2 )
                @m_set effort1, (3*k-1), 1, ( @m_get( effort1, (3*k-1), 1) - forcev / 2 )                 
        else if (D_int_plaque1 < D_int_plaque2) #Si la sup dépasse de linf
            for k in [ wa1+1 .. contact[0].noeudmaitre ]
                surf = Math.abs((((noeud[k-1].r)*(noeud[k-1].r))-((noeud[k-2].r)*(noeud[k-2].r)))*Math.PI*Angle_sect/(2*Math.PI))
                forcev = surf*Pression*l/Nombre_increments
                @m_set effort1, (3*(k-1)-1), 1, ( @m_get( effort1, (3*(k-1)-1), 1) - forcev / 2 )
                @m_set effort1, (3*k-1), 1, ( @m_get( effort1, (3*k-1), 1) - forcev / 2 )  


        #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        #%%%%%%%%%%%%%%%%%%%%Forces dependantes du contact
        #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        # Si infiltration de la pression
        
        if (contact_actif.length == 0)
            alert('LES DEUX PLAQUES SE SONT DECOLLEES => LES RESULTATS OBTENUS NE VEULENT RIEN DIRE !!!')
        else
            dernierdecollement = contact[ Math.min.apply(Math, contact_actif) - 1 ].noeudmaitre
            if ( Math.min.apply(Math, contact_actif) > 1 )
                for k in [ 2 .. dernierdecollement ]
                    surf = Math.abs((((noeud[k-1].r)*(noeud[k-1].r))-((noeud[k-2].r)*(noeud[k-2].r)))*Math.PI*Angle_sect/(2*Math.PI))
                    forcev = surf*Pression*l/Nombre_increments
                    @m_set effort1, (3*(contact[k-1].noeudmaitre-1)-1), 1, ( @m_get( effort1, (3*(contact[k-1].noeudmaitre-1)-1), 1) - forcev / 2 )
                    @m_set effort1, (3*contact[k-1].noeudmaitre-1), 1, ( @m_get( effort1, (3*contact[k-1].noeudmaitre-1), 1) - forcev / 2 )
                    @m_set effort1, (3*(contact[k-1].noeudesclave-1)-1), 1, ( @m_get( effort1, (3*(contact[k-1].noeudesclave-1)-1), 1) - forcev / 2 )
                    @m_set effort1, (3*contact[k-1].noeudesclave-1), 1, ( @m_get( effort1, (3*contact[k-1].noeudesclave-1), 1) - forcev / 2 )
        
        return effort1

    cosd: ( a ) ->
        return Math.cos(a*Math.PI/180)
      
    sind: ( a ) ->
        return Math.sin(a*Math.PI/180)