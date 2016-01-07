# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICAAssemblage extends TreeItem
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
        for i in [1 .. elem.length - 3 ]
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
                    
                    Pr_transpose = math.transpose(Pr)
                    k_presque_global = math.multiply(Pr_transpose, k_elem)
                    @k_global = math.multiply(k_presque_global, Pr)

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
                        P_transpose = math.transpose(P)
                        k_presque_global = math.multiply(P_transpose, k_elem)
                        @k_global = math.multiply(k_presque_global, P)
                        
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
                        P_transpose = math.transpose(P)
                        k_presque_global = math.multiply(P_transpose, k_elem)
                        @k_global = math.multiply(k_presque_global, P)                          
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
                        P_transpose = math.transpose(P)
                        k_presque_global = math.multiply(P_transpose, k_elem)
                        @k_global = math.multiply(k_presque_global, P)
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
                        P_transpose = math.transpose(P)
                        k_presque_global = math.multiply(P_transpose, k_elem)
                        @k_global = math.multiply(k_presque_global, P)
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
                    
                    pb_transpose = math.transpose(pb)
                    k_presque_global = math.multiply(pb_transpose, k_elem)
                    @k_global = math.multiply(k_presque_global, pb)
                    k_poutre = k_elem
            
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
                    matrice_globale.subset(math.index(a-1, b-1), matrice_globale.subset(math.index(a-1, b-1)) + @k_global.subset(math.index(u-1, j-1)))
                    
        matrice_globale1 = matrice_globale
        Betta=math.max(matrice_globale.subset(math.index(3*(contact[contact.length-1].noeudesclave)-2, 3*(contact[contact.length - 1].noeudesclave)-2)), matrice_globale.subset(math.index(3 * ( contact[contact.length - 1].noeudmaitre)-2, 3*(contact[contact.length - 1].noeudmaitre)-2)))
        matrice_globale_size = math.size(matrice_globale)
        matrice_globale_length = matrice_globale_size.subset(math.index(0))
        for i in [ 1 .. matrice_globale_length - 1 ]
            if i != 3 * ( contact[contact.length - 1].noeudmaitre)-2 and i != 3 * ( contact[contact.length - 1].noeudesclave)-2
                for j in [ 1 .. matrice_globale_length - 1 ]
                    if j == 3 * ( contact[contact.length - 1].noeudesclave) - 2
                        matrice_globale1.subset(math.index(i - 1,j - 1), matrice_globale.subset(math.index(i - 1,j - 1)) + matrice_globale.subset(math.index( i, 3 * (contact[contact.length - 1].noeudmaitre)-2)))
                    else if j == 3 * ( contact[contact.length - 1].noeudmaitre)-2
                        matrice_globale1.subset(math.index(i - 1,j - 1), 0)
                    else
                        matrice_globale1.subset(math.index(i - 1,j - 1), matrice_globale.subset(math.index(i - 1,j - 1)))
            else if i == 3 * ( contact[contact.length - 1].noeudesclave) - 2
                for i in [ 1 .. matrice_globale_length - 1 ]
                    if j == 3 * ( contact[contact.length - 1].noeudmaitre ) - 2 
                        matrice_globale1.subset(math.index(i - 1, j - 1), 0)
                    else if j == 3 * ( contact[contact.length - 1].noeudesclave ) - 2
                        matrice_globale1.subset(math.index(i-1,j-1), 
                        matrice_globale1.subset(math.index(i-1,j-1)) + 
                        matrice_globale.subset(math.index(3 * ( contact[contact.length - 1].noeudmaitre) - 2, 3 * ( contact[contact.length - 1].noeudmaitre ) - 2 )) + 
                        matrice_globale.subset(math.index(i, 3 * ( contact[contact.length - 1].noeudmaitre ) - 2 )) + 
                        matrice_globale.subset(math.index( 3 * ( contact[contact.length - 1].noeudmaitre ) - 2, j )))                        
                    else
                        matrice_globale1.subset(math.index(i-1,j-1), matrice_globale.subset(math.index(i-1,j-1)) + matrice_globale.subset(math.index(3 * ( contact[contact.length - 1].noeudmaitre)-2, j - 1)))
            else if i == 3 * ( contact[contact.length - 1].noeudmaitre ) - 2
                for i in [ 1 .. matrice_globale_length - 1]
                    if j == 3 * ( contact[contact.length - 1].noeudmaitre ) - 2
                        matrice_globale1.subset(math.index(i-1,j-1), Betta)
                    else if j == 3 * ( contact[contact.length - 1].noeudesclave ) - 2
                        matrice_globale1.subset(math.index(i-1,j-1), -Betta)
                    else
                        matrice_globale1.subset(math.index(i-1,j-1), 0)

        noeud_maitre = wd1
        noeud_esclave = noeud.length - 2
        matrice_globale2 = matrice_globale1
        deltar = Math.abs(noeud[noeud_esclave - 1].r - noeud[noeud_maitre - 1].r)
        deltaz = noeud[noeud_esclave - 1].z - noeud[noeud_maitre - 1].z
        Betta1 = math.max(matrice_globale1.subset(math.index(3 * noeud_maitre - 2, 3 * noeud_maitre - 2 )), matrice_globale1.subset(math.index(3 * noeud_esclave - 2, 3 * noeud_esclave - 2 )))
        Betta2 = math.max(matrice_globale1.subset(math.index(3 * noeud_maitre - 1, 3 * noeud_maitre - 1 )), matrice_globale1.subset(math.index(3 * noeud_esclave - 1, 3 * noeud_esclave - 1 )))
        Betta3 = math.max(matrice_globale1.subset(math.index(3 * noeud_maitre, 3 * noeud_maitre)), matrice_globale1.subset(math.index(3 * noeud_esclave, 3 * noeud_esclave )))
        matrice_globale2_size = math.size(matrice_globale2)
        matrice_globale2_length = matrice_globale2_size.subset(math.index(0))
        
        for i in [ 1 .. matrice_globale2_length - 1 ]
            if ( i != 3 * noeud_maitre - 2 ) and ( i != 3 * noeud_esclave - 2 ) and ( i != 3 * noeud_maitre - 1 ) and ( i != 3 * noeud_esclave - 1 ) and ( i != 3 * noeud_maitre ) and ( i != 3 * noeud_esclave )
                for j in [1 .. matrice_globale2_length - 1 ]
                    if j == 3 * noeud_maitre - 2
                        matrice_globale2.subset(math.index(i-1,j-1), matrice_globale1.subset(math.index(i-1,j-1)) + matrice_globale1.subset(math.index(i,3*noeud_esclave-2)))
                    else if j == 3 * noeud_maitre - 1
                        matrice_globale2.subset(math.index(i-1,j-1), matrice_globale1.subset(math.index(i-1,j-1)) + matrice_globale2.subset(math.index(i,3*noeud_esclave-1)))
                    else if j == 3 * noeud_maitre
                        matrice_globale2.subset(math.index(i-1,j-1), matrice_globale1.subset(math.index(i-1,j-1)) + matrice_globale1.subset(math.index(i,3*noeud_esclave)) - deltar * matrice_globale1.subset(math.index(i-1, 3*noeud_esclave-1)))
                    else if j == 3 * noeud_esclave - 2 or j == 3 * noeud_esclave - 1 or j == 3 * noeud_esclave
                        matrice_globale2.subset(math.index(i-1,j-1), 0)
                    else
                        matrice_globale2.subset(math.index(i-1,j-1), matrice_globale1.subset(math.index(i-1,j-1)))
            
            else if i == 3 * noeud_maitre - 2
                for j in [1 .. matrice_globale2_length - 1 ]
                    if j == 3 * noeud_maitre - 2
                        matrice_globale2.subset(math.index(i-1,j-1), matrice_globale1.subset(math.index(i-1,j-1)) + matrice_globale1.subset(math.index(3*noeud_esclave-2,j-1)) + matrice_globale1.subset(math.index(3*noeud_esclave-2,3*noeud_esclave-2)) + matrice_globale1.subset(math.index(i,3*noeud_esclave-2)))
                    else if j == 3 * noeud_maitre - 1
                        matrice_globale2.subset(math.index(i-1,j-1), matrice_globale1.subset(math.index(i-1,j-1)) + matrice_globale1.subset(math.index(i,3*noeud_esclave-1)) + matrice_globale1.subset(math.index(3*noeud_esclave-2,j-1)) + matrice_globale1.subset(math.index(3*noeud_esclave-2,3*noeud_esclave-1)))
                    else if j == 3 * noeud_maitre
                        matrice_globale2.subset(math.index(i-1,j-1), matrice_globale1.subset(math.index(i-1,j-1)) + matrice_globale1.subset(math.index(i,3*noeud_esclave)) - deltar * ( matrice_globale1.subset(math.index(i-1, 3*noeud_esclave-1)) + matrice_globale1.subset(math.index(3*noeud_esclave-2,3*noeud_esclave-1))) + matrice_globale1.subset(math.index(3*noeud_esclave-2,3*noeud_maitre)) + matrice_globale1.subset(math.index(3*noeud_esclave-2,3*noeud_esclave)))
                    else if j == 3 * noeud_esclave - 2 or j == 3 * noeud_esclave - 1 or j == 3 * noeud_esclave
                        matrice_globale2.subset(math.index(i-1,j-1), 0)
                    else
                        matrice_globale2.subset(math.index(i-1,j-1), matrice_globale1.subset(math.index(i-1,j-1)) + matrice_globale1.subset(math.index(3*noeud_esclave-2,j-1)))
                        console.log matrice_globale2
                        
                        
                        
                        
                        
                        
#                                                                       JE ME SUIS ARRETÉ LIGNE 572 DU FICHIER ASSEMBLAGE !

#                                                                                  BON COURAGE POUR LA SUITE :)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
            
                
                
                
                