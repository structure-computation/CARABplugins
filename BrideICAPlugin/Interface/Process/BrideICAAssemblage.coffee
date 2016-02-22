# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#

class BrideICAAssemblage extends MatriceItem
    constructor: ( @bride_children ) ->
        super()
        
        @_name.set "Assemblage"
        @_viewable.set false
        

        if @bride_children?
            @assemblage()
    
    
    assemblage: ( ) ->
        noeud = @bride_children[4].noeud.get()
        elem = @bride_children[4].elem.get()
        contact = @bride_children[5].contact
        wsup = @bride_children[4].wsup.get()
        winf = @bride_children[4].winf.get()
        wd1 = @bride_children[4].wd1.get()
        wd2 = @bride_children[4].wd2.get()
        E_fixation = @bride_children[1].E_fixation.get()
        Ae = @bride_children[3].Ae.get()
        nu_fixation = @bride_children[1].nu_fixation.get()
        nombredefixation = @bride_children[1].nombredefixation.get()
        angle_tube_incline1 = @bride_children[1].angle_tube_incline1.get()
        angle_tube_incline2 = @bride_children[1].angle_tube_incline2.get()

        
        Nombre_noeuds = noeud.length
        ddl = 3
        taille = Nombre_noeuds * ddl
        matrice_globale = math.zeros(taille, taille)
        @k_poutre = 0
        indelp = 0
        @k_global = []
        @ELPAK = 0
        for i in [1 .. elem.length ]
            switch elem[i - 1].type
                when 1
                    ra = noeud[elem[i - 1].noeud2 - 1].r
                    rb = noeud[elem[i - 1].noeud1 - 1].r
                    h = elem[i - 1].geom3
                    e = elem[i - 1].E
                    nu = elem[i - 1].nu
                    l = ra - rb
                    rbra2 = Math.pow( ( rb / ra ), 2 )
                    ra2 = ra * ra
                    ra3 = ra * ra * ra
                    c1 = ( ( 1 + nu ) / 2 ) * ( rb / ra ) * Math.log( ra / rb ) + ( ( 1 - nu ) / 4 ) * ( ( ra / rb ) - ( rb / ra ) )
                    c2 = 0.25 * ( 1 - rbra2 * ( 1 + 2 * Math.log( ra / rb ) ) )
                    c3 = ( rb / ( 4 * ra ) ) * ( ( rbra2 + 1 ) * Math.log( ra / rb ) + rbra2 - 1 )
                    c4 = 0.5 * ( ( 1 + nu ) * rb / ra + ( 1 - nu ) * ra / rb )
                    c5 = 0.5 * ( 1 - rbra2 )
                    c6 = ( rb / ( 4 * ra ) ) * ( rbra2 - 1 + 2 * Math.log( ra / rb ) )
                    c8 = 0.5 * ( 1 + nu + ( 1 - nu ) * rbra2 )
                    c9 = ( rb / ra ) * ( ( ( 1 + nu ) / 2 ) * Math.log( ra / rb ) + ( ( 1 - nu ) / 4 ) * ( 1 - rbra2 ) )
                    f = ( 2 * Math.PI * rb / nombredefixation )
                    D = ( e * ( h * h * h ) ) / ( 12 * ( 1 - nu * nu ) )
                    Dpl = f * D / ( ( c2 * c6 - c3 * c5 ) )
                    


                    k_elem = math.matrix( [ [ ( 2 * Math.PI * e * h / ( nombredefixation * ( 1 - nu * nu ) ) ) * ( ( -1.5 - nu - rb / l + 0.5 * ( ( rb / l ) * ( rb / l ) ) * ( ra * ra / ( rb * rb ) - 1 ) + ( 1 + 2 * rb / l + rb * rb / ( l * l ) ) * Math.log( ra / rb ) ) ),0, 0, ( 2 * Math.PI * e * h / ( nombredefixation * ( 1 - nu * nu ) ) ) * ( 0.5 + rb / l - 0.5 * ( ( rb / l ) * ( rb / l ) ) * ( ra * ra / ( rb * rb ) - 1 ) - ( rb / l + rb * rb / ( l * l ) ) * Math.log( ra / rb ) ), 0, 0 ],
                                            
                                            [ 0, Dpl * c5 / ra3, Dpl * ( c1 * c5 - c4 * c2 ) / ra2, 0, - ( Dpl * c5 / ra3 ), Dpl * c2 / ra2 ],
                                            
                                            [ 0, Dpl * ( c1 * c5 - c4 * c2 ) / ra2, Dpl * ( c1 * c6 - c3 * c4 ) / ra, 0, ( - Dpl * c6 / ra2 ), Dpl * c3 / ra ],
                                            
                                            [ ( 2 * Math.PI * e * h / ( nombredefixation * ( 1 - nu * nu ) ) ) * ( 0.5 + rb / l - 0.5 * ( ( rb / l ) * ( rb / l ) ) * ( ra * ra / ( rb * rb ) - 1 ) - ( rb / l + rb * rb / ( l * l ) ) * Math.log( ra / rb ) ), 0, 0, ( 2 * Math.PI * e * h / ( nombredefixation * ( 1 - nu * nu ) ) ) * ( 0.5 + nu - rb / l + 0.5 * ( ( rb / l ) * ( rb / l ) ) * ( ra * ra / ( rb * rb ) - 1 ) + ( rb * rb / ( l * l ) ) * Math.log( ra / rb ) ), 0, 0 ],
                                            
                                            [ 0, - ( Dpl * c5 / ra3 ), ( - Dpl * c6 / ra2 ), 0, Dpl * c5 / ra3, -Dpl * c2 / ra2 ],
                                            
                                            [ 0, Dpl * c2 / ra2, Dpl * c3 / ra, 0, -Dpl * c2 / ra2, Dpl * ( c2 * c9 - c8 * c3 ) / rb ]
                                        
                                        ] )
                    
                    
                    
                    Pr = math.zeros(6, 6)
                    Pr.subset(math.index(0, 0), 1)
                    Pr.subset(math.index(1, 1), 1)
                    Pr.subset(math.index(2, 2), -1)
                    Pr.subset(math.index(3, 3), 1)
                    Pr.subset(math.index(4, 4), 1)
                    Pr.subset(math.index(5, 5), -1)
                    
#                     Pr_transpose = math.transpose(Pr)
#                     k_presque_global = math.multiply(Pr_transpose, k_elem)
#                     @k_global = math.multiply(k_presque_global, Pr)
                    @k_global = @m_change_rep Pr, k_elem

                when 2
                    P = math.zeros(6, 6)
                    P.subset(math.index(0, 1), -1)
                    P.subset(math.index(1, 0), 1)
                    P.subset(math.index(2, 2), 1)
                    P.subset(math.index(3, 4), -1)
                    P.subset(math.index(4, 3), 1)
                    P.subset(math.index(5, 5), 1)
                    
                    L = ( Math.abs(noeud[elem[i - 1].noeud2 - 1].z - noeud[elem[i - 1].noeud1 - 1].z ) )
                    r0 = noeud[elem[i - 1].noeud1 - 1].r
                    E = elem[i - 1].E
                    nu = elem[i - 1].nu
                    t = elem[i - 1].geom3

                    k_elem = math.matrix( [ [ nombredefixation * ( 1 / ( elem[i - 1].geom2 ) ),
                                              Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                              1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                              -( nombredefixation * ( 1 / ( elem[i - 1].geom2 ) ) ),
                                              Math.PI * E * t / ( 1 - nu * nu ) * nu, 
                                              -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu ],
                                            
                                            [ Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                              2 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L * L + 35 * t * t * r0 * r0 ) / ( L * L * L ) / r0,
                                              1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                              - Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                              1 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( 9 * L * L * L * L - 70 * t * t * r0 * r0 ) / ( L * L * L ) / r0,
                                              -1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L * L - 210 * t * t * r0 * r0 ) / ( L * L ) / r0 ],
                                            
                                            [ 1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                              1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                              2 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( L * L * L * L + 35 * t * t * r0 * r0 ) / L / r0,
                                              -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                              1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L * L - 210 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                              -1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( 3 * L * L * L * L - 70 * t * t * r0 * r0 ) / L / r0 ],
                                            
                                            [ -( nombredefixation * ( 1 / ( elem[i - 1].geom2 ) ) ),
                                              - Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                              -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                              nombredefixation * ( 1 / ( elem[i - 1].geom2 ) ),
                                              - Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                              1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu ],
                                            
                                            [ Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                              1 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( 9 * L * L * L * L - 70 * t * t * r0 * r0 ) / ( L * L * L ) / r0,
                                              1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L * L - 210 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                              - Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                              2 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L * L + 35 * t * t * r0 * r0 ) / ( L * L * L ) / r0,
                                              - 1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0 ],
                                            
                                            [ -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                              -1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L * L - 210 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                              -1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( 3 * L * L * L * L - 70 * t * t * r0 * r0 ) / L / r0,
                                              1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                              - 1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                              2 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( L * L * L * L + 35 * t * t * r0 * r0 ) / L / r0 ]
                                        ] )
                    
                    k_elem = math.divide(k_elem, nombredefixation)
                    P_transpose = math.transpose(P)
                    
                    if noeud[elem[i - 1].noeud1 - 1].z < noeud[elem[i - 1].noeud2 - 1].z
                        k_presque_global = math.multiply(P_transpose, k_elem)
                        @k_global = math.multiply(k_presque_global, P)
                                                
                    else if noeud[elem[i - 1].noeud1 - 1].z > noeud[elem[i - 1].noeud2 - 1].z
                        P2 = math.zeros(6, 6)
                        P2.subset(math.index(0, 0), 1)
                        P2.subset(math.index(1, 1), -1)
                        P2.subset(math.index(2, 2), -1)
                        P2.subset(math.index(3, 3), 1)
                        P2.subset(math.index(4, 4), -1)
                        P2.subset(math.index(5, 5), -1)
                        k_global1 = math.multiply(P2, P_transpose)
                        k_global2 = math.multiply(k_global1, k_elem)
                        k_global3 = math.multiply(k_global2, P)
                        @k_global = math.multiply(k_global3, P2)
                    
                    
                    
                when 3
                    P = math.zeros(6, 6)
                    P.subset(math.index(0, 1), -1)
                    P.subset(math.index(1, 0), 1)
                    P.subset(math.index(2, 2), 1)
                    P.subset(math.index(3, 4), -1)
                    P.subset(math.index(4, 3), 1)
                    P.subset(math.index(5, 5), 1)
                    
                    L = ( Math.abs(noeud[elem[i - 1].noeud2 - 1].z - noeud[elem[i - 1].noeud1 - 1].z ) )
                    r0 = noeud[elem[i - 1].noeud1 - 1].r
                    E = elem[i - 1].E
                    nu = elem[i - 1].nu
                    t = elem[i - 1].geom3
                    
                    if noeud[elem[i - 1].noeud1 - 1].z < noeud[elem[i - 1].noeud2 - 1].z
                        k_elem = math.matrix( [ [ 2 * Math.PI * E * t / ( 1 - nu * nu ) / L * r0,
                                                 Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                 1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                 -2 * Math.PI * E * t / ( 1 - nu * nu ) / L * r0,
                                                 Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                 -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu ],
                        
                                                [ Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  2 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L * L + 35 * t * t * r0 * r0 ) / ( L * L * L ) / r0,
                                                  1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                                  - Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  1 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( 9 * L * L * L * L - 70 * t * t * r0 * r0 ) / ( L * L * L ) / r0,
                                                  -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu ],
                                              
                                                [ 1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                                  2 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( L * L * L * L + 35 * t * t * r0 * r0 ) / L / r0,
                                                  -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L * L - 210 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                                  -1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( 3 * L * L * L * L - 70 * t * t * r0 * r0 ) / L / r0 ],
                                                
                                                [ -2 * Math.PI * E * t / ( 1 - nu * nu ) / L * r0,
                                                  - Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  2 * Math.PI * E * t / ( 1 - nu * nu ) / L * r0,
                                                  - Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu ],
                                                
                                                [ Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  1 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( 9 * L * L * L * L - 70 * t * t * r0 * r0 ) / ( L * L * L ) / r0,
                                                  1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L * L - 210 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                                  - Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  2 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L * L + 35 * t * t * r0 * r0 ) / ( L * L * L ) / r0,
                                                  - 1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0 ],
                                                
                                                [ -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  -1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( 3 * L * L * L * L - 70 * t * t * r0 * r0 ) / L / r0,
                                                  -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu ,
                                                  - 1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                                  2 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( L * L * L * L + 35 * t * t * r0 * r0 ) / L / r0 ]      
                                            ] )
                        
                        k_elem = math.divide(k_elem, nombredefixation)
                        
#                         P_transpose = math.transpose(P)
#                         k_presque_global = math.multiply(P_transpose, k_elem)
#                         @k_global = math.multiply(k_presque_global, P)
                        @k_global = @m_change_rep P, k_elem
                        
                    else if noeud[elem[i - 1].noeud1 - 1].z > noeud[elem[i - 1].noeud2 - 1].z
                        P = math.zeros(6, 6)
                        P.subset(math.index(0, 1), -1)
                        P.subset(math.index(1, 0), 1)
                        P.subset(math.index(2, 2), 1)
                        P.subset(math.index(3, 4), -1)
                        P.subset(math.index(4, 3), 1)
                        P.subset(math.index(5, 5), 1)
                        
                        k_elem = math.matrix( [ [ 2 * Math.PI * E * t / ( 1 - nu * nu ) / L * r0,
                                                  Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  -2 * Math.PI * E * t / ( 1 - nu * nu ) / L * r0,
                                                  Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu ],
                                                
                                                [ -Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  2 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L* L + 35 * t * t *r0 * r0 ) / L * L * L / r0,
                                                  -1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                                  Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  -1 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( -9 * L * L * L * L + 70 * t * t * r0 * r0 ) / L * L * L / r0,
                                                  -1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( -13 * L * L * L * L + 210 * t * t * r0 * r0 ) / L * L / r0 ],
                                                
                                                [ 1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  -1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                                  2 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( L * L * L * L + 35 * t * t * r0 * r0 ) / L / r0,
                                                  -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  -1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( -13 * L * L * L * L + 210 * t * t * r0 * r0 ) / L * L / r0,
                                                  1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( -3 * L * L * L * L + 70 * t * t * r0 * r0 ) / L / r0 ],
                                                
                                                [ -2 * Math.PI * E * t / ( 1 - nu * nu ) / L * r0,
                                                  Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  2 * Math.PI * E * t / ( 1 - nu * nu ) / L * r0,
                                                  Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu ],
                                                
                                                [ -Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  -1 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( -9 * L * L * L * L + 70 * t * t * r0 * r0 ) / L * L * L / r0,
                                                  -1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( -13 * L * L * L * L + 210 * t * t * r0 * r0 ) / L * L / r0,
                                                  Math.PI * E * t / ( 1 - nu * nu ) * nu,
                                                  2 / 35 * Math.PI * E * t / ( 1 - nu * nu ) * ( 13 * L * L * L* L + 35 * t * t *r0 * r0 ) / L * L * L / r0,
                                                  1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0 ],
                                                
                                                [ -1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  -1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( -13 * L * L * L * L + 210 * t * t * r0 * r0 ) / L * L / r0,
                                                  1 / 210 * Math.PI * E * t / ( 1 - nu * nu ) * ( -3 * L * L * L * L + 70 * t * t * r0 * r0 ) / L / r0,
                                                  1 / 6 * Math.PI * E * t / ( 1 - nu * nu ) * L * nu,
                                                  1 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( 11 * L * L * L * L + 105 * t * t * r0 * r0 ) / ( L * L ) / r0,
                                                  2 / 105 * Math.PI * E * t / ( 1 - nu * nu ) * ( L * L * L * L + 35 * t * t * r0 * r0 ) / L / r0 ]
                                            ] )
                                                
                        k_elem = math.divide(k_elem, nombredefixation)
                        
#                         P_transpose = math.transpose(P)
#                         k_presque_global = math.multiply(P_transpose, k_elem)
#                         @k_global = math.multiply(k_presque_global, P) 
                        @k_global = @m_change_rep P, k_elem
                when 4
                    P = math.zeros(6, 6)
                    P.subset(math.index(0, 1), -1)
                    P.subset(math.index(1, 0), 1)
                    P.subset(math.index(2, 2), 1)
                    P.subset(math.index(3, 4), -1)
                    P.subset(math.index(4, 3), 1)
                    P.subset(math.index(5, 5), 1)
                    L = ( Math.abs(noeud[elem[i - 1].noeud2 - 1].z - noeud[elem[i - 1].noeud1 - 1].z ) )
                    r0 = noeud[elem[i - 1].noeud1 - 1].r
                    E = elem[i - 1].E
                    nu = elem[i - 1].nu
                    t = elem[i - 1].geom2
                    
                    if noeud[elem[i - 1].noeud1 - 1].z < noeud[elem[i - 1].noeud2 - 1].z
                        calcul_k_cone_incline1 = new BrideICACalculKConeIncline
                            phi : angle_tube_incline1 + 180
                            E : E
                            nu : nu
                            t : t
                            L : L
                            r : r0
                        k_elem = calcul_k_cone_incline1.k_elem
                        k_elem = math.divide(k_elem, nombredefixation)
#                         P_transpose = math.transpose(P)
#                         k_presque_global = math.multiply(P_transpose, k_elem)
#                         @k_global = math.multiply(k_presque_global, P)
                        @k_global = @m_change_rep P, k_elem
                        
#                         console.log "k_elem = " + k_elem
                    else if noeud[elem[i - 1].noeud1 - 1].z > noeud[elem[i - 1].noeud2 - 1].z
                        calcul_k_cone_incline2 = new BrideICACalculKConeIncline
                            phi : angle_tube_incline2 + 180
                            E : E
                            nu : nu
                            t : t
                            L : L
                            r : r0
                        k_elem = calcul_k_cone_incline2.k_elem
                        k_elem = math.divide(k_elem, nombredefixation)
                        
#                         P_transpose = math.transpose(P)
#                         k_presque_global = math.multiply(P_transpose, k_elem)
#                         @k_global = math.multiply(k_presque_global, P)
                        @k_global = @m_change_rep P, k_elem
                    
                when 5
                    E = elem[i - 1].E
                    nu = elem[i - 1].nu
                    S = elem[i - 1].geom1
                    I = elem[i - 1].geom2
                    L = Math.abs(noeud[elem[i - 1].noeud1 - 1].z - noeud[elem[i - 1].noeud2 - 1].z)
                    test = []
                    test.push [E * S / L, 0, 0, -E * S / L, 0, 0]
                    test.push [0, 12 * E * I / ( L * L * L ), 6 * E * I / ( L * L ), 0, -12 * E * I / ( L * L * L ), 6 * E * I / ( L * L )]
                    test.push [0, 6 * E * I / ( L * L ), 4 * E * I / L, 0, -6 * E * I / ( L * L ), 2 * E * I / (L)]
                    test.push [-E * S / L, 0, 0, E * S / L, 0, 0]
                    test.push [0, -12 * E * I / (L * L * L), -6 * E * I / ( L * L ), 0, 12 * E * I / ( L * L * L ), -6 * E * I / ( L * L )]
                    test.push [0, 6 * E * I / ( L * L ), 2 * E * I / L, 0, -6 * E * I / ( L * L ), 4 * E * I / L]     
                    k_elem = math.matrix(test)
                    if ((noeud[elem[i - 1].noeud1 - 1].z - noeud[elem[i - 1].noeud2 - 1].z) < 0)
                        pb = math.zeros(6, 6)
                        pb.subset(math.index(0, 1), 1)
                        pb.subset(math.index(1, 0), -1)
                        pb.subset(math.index(2, 2), -1)
                        pb.subset(math.index(3, 4), 1)
                        pb.subset(math.index(4, 3), -1)
                        pb.subset(math.index(5, 5), -1)
                        
                    else
                        pb = math.zeros(6, 6)
                        pb.subset(math.index(0, 1), -1)
                        pb.subset(math.index(1, 0), 1)
                        pb.subset(math.index(2, 2), -1)
                        pb.subset(math.index(3, 4), -1)
                        pb.subset(math.index(4, 3), 1)
                        pb.subset(math.index(5, 5), -1)
                    
#                     pb_transpose = math.transpose(pb)
#                     k_presque_global = math.multiply(pb_transpose, k_elem)
#                     @k_global = math.multiply(k_presque_global, pb)
                    @k_global = @m_change_rep pb, k_elem
                    @k_poutre = k_elem
            
            for u in [1 .. 6]
                if u <= 3
                    a = 3 * ( elem[i - 1].noeud1 - 1 ) + u
                else
                    a = 3 * ( elem[i - 1].noeud2 - 1 ) + ( u - 3 )
                for j in [1.. 6]
                    if j <= 3
                        b = 3 * ( elem[i - 1].noeud1 - 1 ) + j
                    else
                        b = 3 * ( elem[i - 1].noeud2 - 1 ) + ( j - 3 )
#                     matrice_globale.subset(math.index(a-1, b-1), matrice_globale.subset(math.index(a-1, b-1)) + @k_global.subset(math.index(u-1, j-1)))
                    @m_set matrice_globale, a, b, ( @m_get(matrice_globale, a, b) + @m_get(@k_global, u, j) )

        
#         ###################################################################################################
#         ######################### FIN de l'assemblage de la matrice rigidite globale !! ###################
#         ###################################################################################################            
            
        matrice_globale1 = @m_copy matrice_globale
        Betta = math.max( @m_get(matrice_globale, (3 * ( contact[contact.length - 1].noeudesclave) - 2), (3 * ( contact[contact.length - 1].noeudesclave ) - 2)), @m_get(matrice_globale, (3 * ( contact[contact.length - 1].noeudmaitre) - 2), (3 * ( contact[contact.length - 1].noeudmaitre ) - 2)) )
        matrice_globale_size = math.size(matrice_globale)
        matrice_globale_length = matrice_globale_size.subset(math.index(0))
        for i in [ 1 .. matrice_globale_length ]
            if i != 3 * ( contact[contact.length - 1].noeudmaitre)-2 and i != 3 * ( contact[contact.length - 1].noeudesclave)-2
                for j in [ 1 .. matrice_globale_length ]
                    if j == 3 * ( contact[contact.length - 1].noeudesclave) - 2
                        @m_set matrice_globale1, i , j, ( @m_get(matrice_globale, i, j) + @m_get(matrice_globale, i, (3 * (contact[contact.length - 1].noeudmaitre)-2)) )
                    else if j == 3 * ( contact[contact.length - 1].noeudmaitre) - 2
                        @m_set matrice_globale1, i, j, 0
                    else
                        @m_set matrice_globale1, i, j, @m_get(matrice_globale, i, j)
            else if i == 3 * ( contact[contact.length - 1].noeudesclave) - 2
                for j in [ 1 .. matrice_globale_length ]
                    if j == 3 * ( contact[contact.length - 1].noeudmaitre ) - 2 
                        @m_set matrice_globale1, i, j, 0
                    else if j == 3 * ( contact[contact.length - 1].noeudesclave ) - 2
                        @m_set matrice_globale1, i, j, ( @m_get(matrice_globale, i, j) + @m_get(matrice_globale, (3 * ( contact[contact.length - 1].noeudmaitre) - 2), (3 * ( contact[contact.length - 1].noeudmaitre ) - 2)) + @m_get(matrice_globale, i, (3 * ( contact[contact.length - 1].noeudmaitre ) - 2)) + @m_get(matrice_globale, (3 * ( contact[contact.length - 1].noeudmaitre) - 2), j) )                   

                    else
                        @m_set matrice_globale1, i, j, ( @m_get(matrice_globale, i, j) + @m_get(matrice_globale, (3 * ( contact[contact.length - 1].noeudmaitre) - 2), j) )
            else if i == 3 * ( contact[contact.length - 1].noeudmaitre ) - 2
                for j in [ 1 .. matrice_globale_length ]
                    if j == 3 * ( contact[contact.length - 1].noeudmaitre ) - 2
                        @m_set matrice_globale1, i, j, Betta
                    else if j == 3 * ( contact[contact.length - 1].noeudesclave ) - 2
                        @m_set matrice_globale1, i, j, -Betta
                    else
                        @m_set matrice_globale1, i, j, 0  

        # test
#         for i in [ 1 .. @m_length matrice_globale ]
#             if @m_get(matrice_globale, 46, i) != 0
#                 console.log i
#                 console.log @m_get(matrice_globale, 46, i)
# 
#         for i in [ 1 .. @m_length matrice_globale1 ]
#             if @m_get(matrice_globale1, 46, i) != 0
#                 console.log i
#                 console.log @m_get(matrice_globale1, 46, i)
            
#         ###################################################################################################
#         ######################### FIN de l'assemblage de la matrice rigidite globale1!! ###################
#         ###################################################################################################            
            

        noeud_maitre = wd1
        noeud_esclave = noeud.length - 1
        matrice_globale2 = @m_copy matrice_globale1
        deltar = Math.abs(noeud[noeud_esclave - 1].r - noeud[noeud_maitre - 1].r)
        deltaz = noeud[noeud_esclave - 1].z - noeud[noeud_maitre - 1].z
        Betta1 = math.max( @m_get(matrice_globale1, (3 * noeud_maitre - 2), (3 * noeud_maitre - 2)), @m_get(matrice_globale1, (3 * noeud_esclave - 2), (3 * noeud_esclave - 2)) )
        Betta2 = math.max( @m_get(matrice_globale1, (3 * noeud_maitre - 1), (3 * noeud_maitre - 1)), @m_get(matrice_globale1, (3 * noeud_esclave - 1), (3 * noeud_esclave - 1)) )
        Betta3 = math.max( @m_get(matrice_globale1, (3 * noeud_maitre), (3 * noeud_maitre)), @m_get(matrice_globale1, (3 * noeud_esclave), (3 * noeud_esclave)) )
        matrice_globale2_size = math.size(matrice_globale2)
        matrice_globale2_length = matrice_globale2_size.subset(math.index(0))
        
        for i in [ 1 .. matrice_globale2_length ]
            if ( i != 3 * noeud_maitre - 2 ) and ( i != 3 * noeud_esclave - 2 ) and ( i != 3 * noeud_maitre - 1 ) and ( i != 3 * noeud_esclave - 1 ) and ( i != 3 * noeud_maitre ) and ( i != 3 * noeud_esclave )
                for j in [1 .. matrice_globale2_length ]
                    if j == 3 * noeud_maitre - 2
                        @m_set matrice_globale2, i , j, ( @m_get(matrice_globale1, i, j) + @m_get(matrice_globale1, i, (3 * noeud_esclave - 2)) )
                    else if j == 3 * noeud_maitre - 1
                        @m_set matrice_globale2, i , j, ( @m_get(matrice_globale1, i, j) + @m_get(matrice_globale1, i, (3 * noeud_esclave - 1)) )
                    else if j == 3 * noeud_maitre
                        @m_set matrice_globale2, i , j, ( @m_get(matrice_globale1, i, j) + @m_get(matrice_globale1, i, (3 * noeud_esclave)) - deltar * @m_get(matrice_globale1, i, (3 * noeud_esclave - 1)) )
                    else if j == 3 * noeud_esclave - 2 or j == 3 * noeud_esclave - 1 or j == 3 * noeud_esclave
                        @m_set matrice_globale2, i , j, 0
                    else
                        @m_set matrice_globale2, i , j, ( @m_get(matrice_globale1, i, j) )
            
            else if i == 3 * noeud_maitre - 2
                for j in [1 .. matrice_globale2_length ]
                    if j == 3 * noeud_maitre - 2
                        @m_set matrice_globale2, i , j, ( @m_get(matrice_globale1, i, j) + @m_get(matrice_globale1, (3 * noeud_esclave - 2), j) + @m_get(matrice_globale1, (3 * noeud_esclave - 2), (3 * noeud_esclave - 2) ) + @m_get(matrice_globale1, i, (3 * noeud_esclave - 2) ) )
                    else if j == 3 * noeud_maitre - 1
                        @m_set matrice_globale2, i , j, ( @m_get(matrice_globale1, i, j) + @m_get(matrice_globale1, i, (3 * noeud_esclave - 1)) + @m_get(matrice_globale1, (3 * noeud_esclave - 2), j) + @m_get(matrice_globale1, (3 * noeud_esclave - 2), (3 * noeud_esclave - 1) ) )
                    else if j == 3 * noeud_maitre
                        @m_set matrice_globale2, i , j, ( @m_get(matrice_globale1, i, j) + @m_get(matrice_globale1, i, (3 * noeud_esclave)) - deltar * ( @m_get(matrice_globale1, i, (3 * noeud_esclave - 1)) + @m_get(matrice_globale1, (3 * noeud_esclave - 2), (3 * noeud_esclave - 1)) ) + @m_get(matrice_globale1, (3 * noeud_esclave - 2), (3 * noeud_maitre)) + @m_get(matrice_globale1, (3 * noeud_esclave - 2), (3 * noeud_esclave)) )
                    else if j == 3 * noeud_esclave - 2 or j == 3 * noeud_esclave - 1 or j == 3 * noeud_esclave
                        @m_set matrice_globale2, i , j, 0
                    else
                        @m_set matrice_globale2, i , j, ( @m_get(matrice_globale1, i, j) + @m_get(matrice_globale1, (3 * noeud_esclave - 2), j) )
            #test            
            else if i == 3 * noeud_maitre - 1
                for j in [1 .. matrice_globale2_length ]
                    if j == 3 * noeud_maitre - 2
                        val = @m_get( matrice_globale1, i, j) + @m_get( matrice_globale1, i, (3*noeud_esclave-2)) + 
                              @m_get( matrice_globale1, (3*noeud_esclave-1), j) + 
                              @m_get( matrice_globale1, (3*noeud_esclave-1), (3*noeud_esclave-2))       
                        @m_set matrice_globale2, i, j, val
                    else if j == 3 * noeud_maitre - 1
                        val = @m_get(matrice_globale1, i, j) + @m_get(matrice_globale1, i,(3*noeud_esclave-1)) +
                              @m_get(matrice_globale1,(3*noeud_esclave-1),j) + @m_get(matrice_globale1,(3*noeud_esclave-1),(3*noeud_esclave-1))      
                        @m_set matrice_globale2, i, j, val          
                    else if j == 3 * noeud_maitre
                        val = @m_get(matrice_globale1,i,j) + @m_get(matrice_globale1,i,(3*noeud_esclave)) -
                              deltar * (@m_get(matrice_globale1,i,(3*noeud_esclave-1)) + @m_get(matrice_globale1,(3*noeud_esclave-1),(3*noeud_esclave-1))) +
                              @m_get(matrice_globale1,(3*noeud_esclave-1),(3*noeud_maitre)) + @m_get(matrice_globale1,(3*noeud_esclave-1),(3*noeud_esclave))      
                        @m_set matrice_globale2, i, j, val           
                    else if (j == 3 * noeud_esclave - 2) or (j == 3 * noeud_esclave - 1) or (j == 3 * noeud_esclave)
                        @m_set matrice_globale2, i, j, 0  
                    else
                        @m_set matrice_globale2, i, j, ( @m_get(matrice_globale1,i,j) + @m_get(matrice_globale1,(3*noeud_esclave-1),j) )         
                        
            #test            
            else if i == 3 * noeud_maitre
                for j in [1 .. matrice_globale2_length ]
                    if j == 3 * noeud_maitre - 2
                        val = @m_get( matrice_globale1,i,j)+@m_get( matrice_globale1,i,(3*noeud_esclave-2))+
                              @m_get( matrice_globale1,(3*noeud_esclave),j)+@m_get( matrice_globale1,(3*noeud_esclave),(3*noeud_esclave-2))-
                              deltar*(@m_get( matrice_globale1,(3*noeud_maitre-1),j)+@m_get( matrice_globale1,(3*noeud_maitre-1),(3*noeud_esclave-2)))       
                        @m_set matrice_globale2, i, j, val
                    else if j == 3 * noeud_maitre - 1
                        val= @m_get( matrice_globale1,i,j)+@m_get( matrice_globale1,i,(3*noeud_esclave-1))+
                              @m_get( matrice_globale1,(3*noeud_esclave),j)+@m_get( matrice_globale1,(3*noeud_esclave),(3*noeud_esclave-1))-
                              deltar*(@m_get( matrice_globale1,(3*noeud_maitre-1),j)+@m_get( matrice_globale1,(3*noeud_maitre-1),(3*noeud_esclave-1)))    
                        @m_set matrice_globale2, i, j, val          
                    else if j == 3 * noeud_maitre
                        val = @m_get( matrice_globale1,i,j)+@m_get( matrice_globale1,i,(3*noeud_esclave))+
                              @m_get( matrice_globale1,(3*noeud_esclave),j)+@m_get( matrice_globale1,(3*noeud_esclave),(3*noeud_esclave))-
                              deltar*(@m_get( matrice_globale1,(3*noeud_maitre-1),j)+@m_get( matrice_globale1,(3*noeud_maitre-1),(3*noeud_esclave)))-
                              deltar*(@m_get( matrice_globale1,(3*noeud_maitre),(3*noeud_esclave-1))+@m_get( matrice_globale1,(3*noeud_esclave),(3*noeud_esclave-1)))+
                              deltar*deltar*(@m_get( matrice_globale1,(3*noeud_maitre-1),(3*noeud_esclave-1)))     
                        @m_set matrice_globale2, i, j, val           
                    else if (j == 3 * noeud_esclave - 2) or (j == 3 * noeud_esclave - 1) or (j == 3 * noeud_esclave)
                        @m_set matrice_globale2, i, j, 0  
                    else
                        @m_set matrice_globale2, i, j, ( @m_get( matrice_globale1,i,j)+@m_get( matrice_globale1,(3*noeud_esclave),j)-deltar*@m_get( matrice_globale1,(3*noeud_maitre-1),j) )               
              
            
            #Definition des couplages cinematiques
            else if i==3 * noeud_esclave - 2
                for j in [1 .. matrice_globale2_length ]
                    if j == 3 * noeud_maitre - 2
                        @m_set matrice_globale2, i, j, (-Betta1) 
                    else if j == 3 * noeud_maitre
                        @m_set matrice_globale2, i, j, (-Betta1 * deltaz)
                    else if j == 3 * noeud_esclave - 2
                        @m_set matrice_globale2, i, j, (Betta1)
                    else
                        @m_set matrice_globale2, i, j, 0

            
            #Definition des couplages cinematiques
            else if i==3 * noeud_esclave - 1
                for j in [1 .. matrice_globale2_length ]
                    if j == 3 * noeud_maitre - 1
                        @m_set matrice_globale2, i, j, (-Betta2)  
                    else if j == 3 * noeud_maitre
                        @m_set matrice_globale2, i, j, (Betta2 * deltar)
                    else if j == 3 * noeud_esclave - 1
                        @m_set matrice_globale2, i, j, (Betta2)
                    else
                        @m_set matrice_globale2, i, j, 0
            
            
            #Definition des couplages cinematiques
            else if i==3 * noeud_esclave
                for j in [1 .. matrice_globale2_length ]
                    if j == 3 * noeud_maitre
                        @m_set matrice_globale2, i, j, (-Betta3)  
                    else if j == 3 * noeud_esclave
                        @m_set matrice_globale2, i, j, (Betta3)
                    else
                        @m_set matrice_globale2, i, j, 0
            
#         for i in [ 1 .. @m_length matrice_globale2 ]
#             if @m_get(matrice_globale2, 200, i) != 0
#                 console.log i
#                 console.log @m_get(matrice_globale2, 200, i)
        
        # Definition de la liaison glissiere
        # On commence a prendre les cas ou il faut creer un noeud additionel (glissiere-Albin) pour l application de la precontrainte:
        # Liste des cas ou l element poutre rigide (dont un des noeuds est
        # glissiere) existe:
        # 1)Assemblage visse a la bague ou au support
        # 2)Assemblage boulonne a la bague (car l encastrement se fait du cote
        # support)
        # 3)Assemblage boulonne au support avec un support de type hub

        # Definition d une nouvelle matrice
        matrice_globale3 = math.zeros(matrice_globale2_length + 3, matrice_globale2_length + 3)
        for i in [1 .. matrice_globale2_length ]
            for j in [1 .. matrice_globale2_length ]
                @m_set matrice_globale3, i, j, @m_get(matrice_globale2,i,j)

        #matrice_globale3=matrice_globale2;
        #matrice_globale3(length(matrice_globale3)+3,length(matrice_globale3)+3)=0;

        # La precontrainte est toujours integree du cote du noeud 2 de la vis ( du
        # cote oppose a la tete de vis ou assimile-comme cas essais)
        # On ajoute le noeud supplementaire

        # On recherche maintenant le numero du noeud dans le maillage secondaire
        # ayant les memes coordonnees que le noeud trouve precedement
        # On a trouve le numero du noeud d'accrochage
        noeud_accrochage = wd2     
        # Connaissant maintenant le numero du noeud d accrochage dans la matrice, on va aller modifier la matrice de raideur de l assemblage en integrant
        # l element rigide (element poutre un module d elasticite et une section grande)
        # Definition de la matrice de l element poutre
        # Definition des proprietes a integrer pour la matrice
        E = E_fixation * 1000
        S = Ae
        nu = nu_fixation
        I = elem[elem.length - 1].geom2
        L = Math.abs(noeud[noeud_accrochage - 1].r - noeud[noeud.length - 1].r)
        # Calcul de la matrice de l element rigide
        K_poutre = math.zeros(6, 6)
        
        @m_set K_poutre,1,1,(E*S/L)
        @m_set K_poutre,1,2,0 
        @m_set K_poutre,1,3,0 
        @m_set K_poutre,1,4,(-E*S/L) 
        @m_set K_poutre,1,5,0 
        @m_set K_poutre,1,6,0 
        @m_set K_poutre,2,1,@m_get(K_poutre,1,2) 
        @m_set K_poutre,2,2,(12*E*I/(L*L*L))
        @m_set K_poutre,2,3,(6*E*I/(L*L))
        @m_set K_poutre,2,4,0 
        @m_set K_poutre,2,5,(-12*E*I/(L*L*L))
        @m_set K_poutre,2,6,(6*E*I/(L*L))
        @m_set K_poutre,3,1,@m_get(K_poutre,1,3) 
        @m_set K_poutre,3,2,@m_get(K_poutre,2,3) 
        @m_set K_poutre,3,3,(4*E*I/L)
        @m_set K_poutre,3,4,0 
        @m_set K_poutre,3,5,(-6*E*I/(L*L))
        @m_set K_poutre,3,6,(2*E*I/L)
        @m_set K_poutre,4,1,@m_get(K_poutre,1,4) 
        @m_set K_poutre,4,2,@m_get(K_poutre,2,4) 
        @m_set K_poutre,4,3,@m_get(K_poutre,3,4) 
        @m_set K_poutre,4,4,(E*S/L)
        @m_set K_poutre,4,5,0 
        @m_set K_poutre,4,6,0 
        @m_set K_poutre,5,1,@m_get(K_poutre,1,5) 
        @m_set K_poutre,5,2,@m_get(K_poutre,2,5) 
        @m_set K_poutre,5,3,@m_get(K_poutre,3,5) 
        @m_set K_poutre,5,4,@m_get(K_poutre,4,5) 
        @m_set K_poutre,5,5,(12*E*I/(L*L*L))
        @m_set K_poutre,5,6,(-6*E*I/(L*L))
        @m_set K_poutre,6,1,@m_get(K_poutre,1,6) 
        @m_set K_poutre,6,2,@m_get(K_poutre,2,6) 
        @m_set K_poutre,6,3,@m_get(K_poutre,3,6) 
        @m_set K_poutre,6,4,@m_get(K_poutre,4,6) 
        @m_set K_poutre,6,5,@m_get(K_poutre,5,6) 
        @m_set K_poutre,6,6,(4*E*I/(L))

        pb2 = math.zeros(6, 6)
        if noeud[noeud_accrochage - 1].r > noeud[noeud.length - 1].r
            # L angle entre les 2 reperes est egal a 180;
            @m_set pb2,1,1,-1
            @m_set pb2,2,2,-1
            @m_set pb2,3,3,-1
            @m_set pb2,4,4,-1
            @m_set pb2,5,5,-1
            @m_set pb2,6,6,-1
        # else L angle entre les 2 reperes est egal a 0;    
        else
            @m_set pb2,1,1,1
            @m_set pb2,2,2,1
            @m_set pb2,3,3,-1
            @m_set pb2,4,4,1
            @m_set pb2,5,5,1
            @m_set pb2,6,6,-1
                
        #k_global_poutre = pb2'*K_poutre*pb2
        k_global_poutre = @m_change_rep pb2, K_poutre
#         console.log @m_length k_global_poutre
#         console.log @m_length K_poutre
#         console.log @m_length matrice_globale3
#         console.log noeud.length
        
        for u in [1 .. 6]
            if u <= 3
                a = 3 * ( noeud_accrochage - 1 ) + u
            else
                a = 3 * ( noeud.length + 1 - 1 ) + ( u - 3 ) # TEST JEREMIE
            for j in [1 .. 6]
                if j <= 3
                    b = 3 * (noeud_accrochage - 1 ) + j
                else
                    b = 3 * ( noeud.length + 1 - 1 ) + ( j - 3 ) # TEST JEREMIE
                
#                 console.log "a = " + a
#                 console.log "b = " + b
#                 console.log "u = " + u
#                 console.log "j = " + j
                @m_set matrice_globale3, a, b, ( @m_get( matrice_globale3, a, b) + @m_get( k_global_poutre, u, j) )
          

        #Couplage du noeud d accorchage et du noeud de la poutre suivant les degres de liberte R et Tetta

        Bettar = Math.max( @m_get( matrice_globale3, (3*noeud.length-2), (3*noeud.length-2) ), @m_get( matrice_globale3, (@m_length(matrice_globale3)-2), (@m_length(matrice_globale3)-2) ) )
        Bettatetta= Math.max( @m_get( matrice_globale3, (3*noeud.length), (3*noeud.length) ), @m_get( matrice_globale3, @m_length(matrice_globale3), @m_length(matrice_globale3) ) )
        matrice_globale4 = @m_copy matrice_globale3
        for i in [1 .. @m_length(matrice_globale3)]
            if ( i != 3 * noeud.length-2 ) and ( i != @m_length(matrice_globale3)-2 ) and ( i != 3*noeud.length ) and ( i != @m_length(matrice_globale3) )
                for j in [ 1 .. @m_length(matrice_globale3)]
                    if j == @m_length(matrice_globale3)-2
                        @m_set matrice_globale4, i, j, ( @m_get( matrice_globale3, i, j ) + @m_get( matrice_globale3, i, (3*noeud.length-2) ) )
                    else if j == @m_length(matrice_globale3)
                        @m_set matrice_globale4, i, j, ( @m_get( matrice_globale3, i, j ) + @m_get( matrice_globale3, i, (3*noeud.length) ) )
                    else if j == 3*noeud.length-2
                        @m_set matrice_globale4, i, j, 0
                    else if j == 3*noeud.length
                        @m_set matrice_globale4, i, j, 0
                    else
                        @m_set matrice_globale4, i, j, @m_get matrice_globale3, i, j

            else if ( i == @m_length(matrice_globale3)-2 )
                for j in [1 .. @m_length(matrice_globale3)]
                    if ( j == 3*noeud.length-2 )
                        @m_set matrice_globale4, i, j, 0
                    else if ( j == @m_length(matrice_globale3)-2 )             
                        val = @m_get(matrice_globale3,i,j) + @m_get(matrice_globale3,(3*noeud.length-2),(3*noeud.length-2)) + 
                              @m_get(matrice_globale3,i,(3*noeud.length-2)) + @m_get(matrice_globale3,(3*noeud.length-2),j)
                        @m_set matrice_globale4, i, j, val         
                    else if ( j == @m_length(matrice_globale3) )                      
                        val = @m_get(matrice_globale3,i,j) + @m_get(matrice_globale3,(3*noeud.length-2),j) + @m_get(matrice_globale3,i,(3*noeud.length)) + 
                              @m_get(matrice_globale3,(3*noeud.length-2),(3*noeud.length))
                        @m_set matrice_globale4, i, j, val                          
                    else if ( j == 3*noeud.length )
                        @m_set matrice_globale4, i, j, 0
                    else
                        @m_set matrice_globale4, i, j, @m_get(matrice_globale3,i,j) + @m_get(matrice_globale3, (3*noeud.length-2), j)

            else if ( i == @m_length(matrice_globale3) )
                for j in [1 .. @m_length(matrice_globale3)]
                    if ( j == 3*noeud.length-2 )
                        @m_set matrice_globale4, i, j, 0
                    else if (j == @m_length(matrice_globale3)-2)                           
                        val = @m_get(matrice_globale3,i,j) + @m_get(matrice_globale3,i,(3*noeud.length-2)) + 
                              @m_get(matrice_globale3,(3*noeud.length),(3*noeud.length-2)) + @m_get(matrice_globale3,(3*noeud.length),j)
                        @m_set matrice_globale4, i, j, val
                    else if (j == @m_length(matrice_globale3))
                        val = @m_get(matrice_globale3,i,j) + @m_get(matrice_globale3,(3*noeud.length),j) + @m_get(matrice_globale3,i,(3*noeud.length)) +
                              @m_get(matrice_globale3,(3*noeud.length),(3*noeud.length))
                        @m_set matrice_globale4, i, j, val      
                              
                    else if (j == 3*noeud.length)
                        @m_set matrice_globale4, i, j, 0
                    else
                        @m_set matrice_globale4, i, j, @m_get(matrice_globale3,i,j) + @m_get(matrice_globale3, (3*noeud.length), j)

            else if (i == 3*noeud.length-2)
                for j in [1 .. @m_length(matrice_globale3)]
                    if ( j== 3*noeud.length-2)
                        @m_set matrice_globale4, i, j, Bettar
                    else if (j == @m_length(matrice_globale3)-2)
                        @m_set matrice_globale4, i, j, (-Bettar)
                    else
                        @m_set matrice_globale4, i, j, 0

            else if (i == 3*noeud.length)
                for j in [1 .. @m_length(matrice_globale3)]
                    if ( j == 3*noeud.length )
                        @m_set matrice_globale4, i, j, Bettatetta
                    else if (j == @m_length(matrice_globale3))
                        @m_set matrice_globale4, i, j, (-Bettatetta)
                    else
                        @m_set matrice_globale4, i, j, 0


        #output
        @matrice_globale4 = matrice_globale4   
        @effort = math.zeros(1, @m_length(matrice_globale4))
       
        
    

   
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
            
                
                
                
                