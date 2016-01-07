# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICACalculKConeIncline extends Model
    constructor: ( @param = {} ) ->
        super()
        
        @calcul_k_cone_incline()
        
        
    cos: ( a ) ->
        return Math.cos(a)
      
    sin: ( a ) ->
        return Math.sin(a)
      
    cosd: ( a ) ->
        return Math.cos(a*Math.PI/180)
      
    sind: ( a ) ->
        return Math.sin(a*Math.PI/180)
    
    
    integrale: ( fp, p1, p2, nb_pas = 50 ) ->
        res = 0
        delta_p = (p2 - p1) / nb_pas
        for i in [ 0 .. nb_pas - 1 ]
            fi1 = fp(p1 + i * delta_p)
            fi2 = fp(p1 + (i + 1) * delta_p)
            res += (fi1 + fi2) / 2 * delta_p
        return res
    
    calcul_k_cone_incline: ( ) ->
        cos = @cos
        cosd = @cosd
        sin = @sin
        sind = @sind
    
        phi = @param.phi
        E = @param.E
        nu = @param.nu
        t = @param.t
        L = @param.L
        r = @param.r
#         console.log "phi = " + phi
#         console.log "E = " + E
#         console.log "nu = " + nu
#         console.log "t = " + t
#         console.log "L = " + L
#         console.log "r = " + r
        
        B = math.matrix( [ [ -cosd(phi) / L, -Math.sin(phi * Math.PI / 180) / L, 0, cosd(phi) / L, Math.sin(phi * Math.PI / 180) / L, 0 ] ] )
        
        D = math.matrix( [ [ 1, nu, 0, 0 ], [ nu, 1, 0, 0 ], [ 0, 0, t * t / 12, nu * t * t / 12 ], [ 0, 0, nu * t * t / 12,t * t / 12 ] ] )
        
        K = math.zeros(6, 6)
#         console.log "B" + B
#         console.log B.subset(math.index(0, 0))
        
        k11 = (p)->
            (B.subset(math.index(0,0))*(D.subset(math.index(0,0))*B.subset(math.index(0,0))+D.subset(math.index(0,1))*((1-p)*cosd(phi)*sind(phi)/r-(1-3*p*p+2*p*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r)))+((1-p)*cosd(phi)*sind(phi)/r-(1-3*p*p+2*p*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r))*(D.subset(math.index(1,0))*B.subset(math.index(0,0))+D.subset(math.index(1,1))*((1-p)*cosd(phi)*sind(phi)/r-(1-3*p*p+2*p*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r)))+(-1/L*L*(-6+12*p)*sind(phi))*(D.subset(math.index(2,2))*(-1/L*L*(-6+12*p)*sind(phi))+D.subset(math.index(2,3))*(1/L*(-6*p+6*p*p)*sind(phi)*sind(phi)/r))+(1/L*(-6*p+6*p*p)*sind(phi)*sind(phi)/r)*(D.subset(math.index(3,2))*(-1/L*L*(-6+12*p)*sind(phi))+D.subset(math.index(3,3))*(1/L*(-6*p+6*p*p)*sind(phi)*sind(phi)/r)))*r*L
        K.subset(math.index(0, 0), @integrale(k11, 0, 1))

        k12 = (p)->
            (B.subset(math.index(0,0))*(D.subset(math.index(0,0))*B.subset(math.index(0,1))+D.subset(math.index(0,1))*((1-p)*sind(phi)*sind(phi)/r+(1-3*p*p+2*p*p*p)*cosd(phi)*cosd(phi)/r))+((1-p)*cosd(phi)*sind(phi)/r-(1-3*p*p+2*p*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r))*(D.subset(math.index(1,0))*B.subset(math.index(0,1))+D.subset(math.index(1,1))*((1-p)*sind(phi)*sind(phi)/r+(1-3*p*p+2*p*p*p)*cosd(phi)*cosd(phi)/r))+(-1/L*L*(-6+12*p)*sind(phi))*(D.subset(math.index(2,2))*(1/L*L*(-6+12*p)*cosd(phi))+D.subset(math.index(2,3))*(-1/L*(-6*p+6*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r)))+(1/L*(-6*p+6*p*p)*sind(phi)*sind(phi)/r)*(D.subset(math.index(3,2))*(1/L*L*(-6+12*p)*cosd(phi))+D.subset(math.index(3,3))*(-1/L*(-6*p+6*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r))))*r*L
        K.subset(math.index(0, 1), @integrale(k12, 0, 1))
    
        k13 = (p)->
            (B.subset(math.index(0,0))*(D.subset(math.index(0,0))*B.subset(math.index(0,2))+D.subset(math.index(0,1))*(-L*(p-2*p*p+p*p*p)*cosd(phi)/r))+((1-p)*cosd(phi)*sind(phi)/r-(1-3*p*p+2*p*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r))*(D.subset(math.index(1,0))*B.subset(math.index(0,2))+D.subset(math.index(1,1))*(-L*(p-2*p*p+p*p*p)*cosd(phi)/r))+(-1/L*L*(-6+12*p)*sind(phi))*(D.subset(math.index(2,2))*(-1/L*(-4+6*p))+D.subset(math.index(2,3))*((1-4*p+3*p*p)*sind(phi)/r))+(1/L*(-6*p+6*p*p)*sind(phi)*sind(phi)/r)*(D.subset(math.index(3,2))*(-1/L*(-4+6*p))+D.subset(math.index(3,3))*((1-4*p+3*p*p)*sind(phi)/r)))*r*L
        K.subset(math.index(0, 2), @integrale(k13, 0, 1))
        
        k14 = (p)->
            (B.subset(math.index(0,0))*(D.subset(math.index(0,0))*B.subset(math.index(0,3))+D.subset(math.index(0,1))*(p*sind(phi)*cosd(phi)/r-(3*p*p-2*p*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r)))+((1-p)*cosd(phi)*sind(phi)/r-(1-3*p*p+2*p*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r))*(D.subset(math.index(1,0))*B.subset(math.index(0,3))+D.subset(math.index(1,1))*(p*sind(phi)*cosd(phi)/r-(3*p*p-2*p*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r)))+(-1/L*L*(-6+12*p)*sind(phi))*(D.subset(math.index(2,2))*(-1/L*L*(6-12*p)*sind(phi))+D.subset(math.index(2,3))*(-1/L*(6*p-6*p*p)*Math.sin(2*phi*Math.PI/180)/(2*r)))+(1/L*(-6*p+6*p*p)*sind(phi)*sind(phi)/r)*(D.subset(math.index(3,2))*(-1/L*L*(6-12*p)*sind(phi))+D.subset(math.index(3,3))*(1/L*(6*p-6*p*p)*sind(phi)*sind(phi)/r)))*r*L
        K.subset(math.index(0, 3), @integrale(k14, 0, 1))
        
        k15 = (p)->
            (B.subset(math.index(0,0))*(D.subset(math.index(0,0))*B.subset(math.index(0,4))+D.subset(math.index(0,1))*(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r))+((1-p)*cosd(phi)*sind(phi)/r-(1-3*p*p+2*p*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(1,0))*B.subset(math.index(0,4))+D.subset(math.index(1,1))*(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r))+(-1/L*L*(-6+12*p)*sind(phi))*(D.subset(math.index(2,2))*(1/L*L*(6-12*p)*cosd(phi))+D.subset(math.index(2,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r)))+(1/L*(-6*p+6*p*p)*sind(phi)*sind(phi)/r)*(D.subset(math.index(3,2))*(1/L*L*(6-12*p)*cosd(phi))+D.subset(math.index(3,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r))))*r*L
        K.subset(math.index(0, 4), @integrale(k15, 0, 1))
        
        k16 = (p)->
            (B.subset(math.index(0,0))*(D.subset(math.index(0,0))*B.subset(math.index(0,5))+D.subset(math.index(0,1))*(-L*(-p*p+p*p*p)*cosd(phi)/r))+((1-p)*cosd(phi)*sind(phi)/r-(1-3*p*p+2*p*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(1,0))*B.subset(math.index(0,5))+D.subset(math.index(1,1))*(-L*(-p*p+p*p*p)*cosd(phi)/r))+(-1/L*L*(-6+12*p)*sind(phi))*(D.subset(math.index(2,2))*(-1/L*(-2+6*p))+D.subset(math.index(2,3))*((-2*p+3*p*p)*sind(phi)/r))+(1/L*(-6*p+6*p*p)*sind(phi)*sind(phi)/r)*(D.subset(math.index(3,2))*(-1/L*(-2+6*p))+D.subset(math.index(3,3))*((-2*p+3*p*p)*sind(phi)/r)))*r*L
        K.subset(math.index(0, 5), @integrale(k16, 0, 1))
        
        k22 = (p)->
            (B.subset(math.index(0,1))*(D.subset(math.index(0,0))*B.subset(math.index(0,1))+D.subset(math.index(0,1))*((1-p)*sind(phi)*sind(phi)/r+(1-3*p*p+2*p*p*p)*cosd(phi)*cosd(phi)/r))+((1-p)*sind(phi)*sind(phi)/r+(1-3*p*p+2*p*p*p)*cosd(phi)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,1))+D.subset(math.index(1,1))*((1-p)*sind(phi)*sind(phi)/r+(1-3*p*p+2*p*p)*cosd(phi)*cosd(phi)/r))+(1/L*L*(-6+12*p)*cosd(phi))*(D.subset(math.index(2,2))*(1/L*L*(-6+12*p)*cosd(phi))+D.subset(math.index(2,3))*(-1/L*(-6*p+6*p*p)*sind(2*phi)/(2*r)))+(-1/L*(-6*p+6*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(3,2))*(1/L*L*(-6+12*p)*cosd(phi))+D.subset(math.index(3,3))*(-1/L*(-6*p+6*p*p)*sind(2*phi)/(2*r))))*r*L
        K.subset(math.index(1, 1), @integrale(k22, 0, 1))
        
        k23 = (p)->
            (B.subset(math.index(0,1))*(D.subset(math.index(0,0))*B.subset(math.index(0,2))+D.subset(math.index(0,1))*(-L*(p-2*p*p+p*p*p)*cosd(phi)/r))+((1-p)*sind(phi)*sind(phi)/r+(1-3*p*p+2*p*p*p)*cosd(phi)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,2))+D.subset(math.index(1,1))*(-L*(p-2*p*p+p*p*p)*cosd(phi)/r))+(1/L*L*(-6+12*p)*cosd(phi))*(D.subset(math.index(2,2))*(-1/L*(-4+6*p))+D.subset(math.index(2,3))*((1-4*p+3*p*p)*sind(phi)/r))+(-1/L*(-6*p+6*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(3,2))*(-1/L*(-4+6*p))+D.subset(math.index(3,3))*((1-4*p+3*p*p)*sind(phi)/r)))*r*L
        K.subset(math.index(1, 2), @integrale(k23, 0, 1))
        
        k24 = (p)->
            (B.subset(math.index(0,1))*(D.subset(math.index(0,0))*B.subset(math.index(0,3))+D.subset(math.index(0,1))*(p*sind(phi)*cosd(phi)/r-(3*p*p*p-2*p*p*p)*sind(2*phi)/(2*r)))+((1-p)*sind(phi)*sind(phi)/r+(1-3*p*p*p+2*p*p*p)*cosd(phi)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,3))+D.subset(math.index(1,1))*(p*sind(phi)*cosd(phi)/r-(3*p*p*p-2*p*p*p)*sind(2*phi)/(2*r)))+(1/L*L*(-6+12*p)*cosd(phi))*(D.subset(math.index(2,2))*(-1/L*L*(6-12*p)*sind(phi))+D.subset(math.index(2,3))*(-1/L*(6*p-6*p*p*p)*sind(2*phi)/(2*r)))+(-1/L*(-6*p+6*p*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(3,2))*(-1/L*L*(6-12*p)*sind(phi))+D.subset(math.index(3,3))*(1/L*(6*p-6*p*p*p)*sind(phi)*sind(phi)/r)))*r*L
        K.subset(math.index(1, 3), @integrale(k24, 0, 1))
        
        k25 = (p)->
            (B.subset(math.index(0,1))*(D.subset(math.index(0,0))*B.subset(math.index(0,4))+D.subset(math.index(0,1))*(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r))+((1-p)*sind(phi)*sind(phi)/r+(1-3*p*p+2*p*p*p)*cosd(phi)*cosd(phi)/r)*(D.subset(math.index(2,0))*B.subset(math.index(0,4))+D.subset(math.index(1,1))*(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r))+(1/L*L*(-6+12*p)*cosd(phi))*(D.subset(math.index(2,2))*(1/L*L*(6-12*p)*cosd(phi))+D.subset(math.index(2,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r)))+(-1/L*(-6*p+6*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(3,2))*(1/L*L*(6-12*p)*cosd(phi))+D.subset(math.index(3,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r))))*r*L
        K.subset(math.index(1, 4), @integrale(k25, 0, 1))
        
        k26 = (p)->
            (B.subset(math.index(0,1))*(D.subset(math.index(0,0))*B.subset(math.index(0,5))+D.subset(math.index(0,1))*(-L*(-p*p+p*p*p)*cosd(phi)/r))+((1-p)*sind(phi)*sind(phi)/r+(1-3*p*p+2*p*p*p)*cosd(phi)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,5))+D.subset(math.index(1,1))*(-L*(-p*p+p*p*p)*cosd(phi)/r))+(1/L*L*(-6+12*p)*cosd(phi))*(D.subset(math.index(2,2))*(-1/L*(-2+6*p))+D.subset(math.index(2,3))*((-2*p+3*p*p)*sind(phi)/r))+(-1/L*(-6*p+6*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(3,2))*(-1/L*(-2+6*p))+D.subset(math.index(3,3))*((-2*p+3*p*p)*sind(phi)/r)))*r*L
        K.subset(math.index(1, 5), @integrale(k26, 0, 1))
        
        k33 = (p)->
            (B.subset(math.index(0,2))*(D.subset(math.index(0,0))*B.subset(math.index(0,2))+D.subset(math.index(0,1))*(-L*(p-2*p*p+p*p*p)*cosd(phi)/r))+(-L*(p-2*p*p+p*p*p)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,2))+D.subset(math.index(1,1))*(-L*(p-2*p*p+p*p*p)*cosd(phi)/r))+(-1/L*(-4+6*p))*(D.subset(math.index(2,2))*(-1/L*(-4+6*p))+D.subset(math.index(2,3))*((1-4*p+3*p*p)*sind(phi)/r))+((1-4*p+3*p*p)*sind(phi)/r)*(D.subset(math.index(3,2))*(-1/L*(-4+6*p))+D.subset(math.index(3,3))*((1-4*p+3*p*p)*sind(phi)/r)))*r*L
        K.subset(math.index(2, 2), @integrale(k33, 0, 1))
        
        k34 = (p)->
            (B.subset(math.index(0,2))*(D.subset(math.index(0,0))*B.subset(math.index(0,3))+D.subset(math.index(0,1))*(p*sind(phi)*cosd(phi)/r-(3*p*p-2*p*p*p)*sind(2*phi)/(2*r)))+(-L*(p-2*p*p+p*p*p)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,3))+D.subset(math.index(1,1))*(p*sind(phi)*cosd(phi)/r-(3*p*p-2*p*p*p)*sind(2*phi)/(2*r)))+(-1/L*(-4+6*p))*(D.subset(math.index(2,2))*(-1/L*L*(6-12*p)*sind(phi))+D.subset(math.index(2,3))*(1/L*(6*p-6*p*p)*sind(phi)*sind(phi)/r))+((1-4*p+3*p*p)*sind(phi)/r)*(D.subset(math.index(3,2))*(-1/L*L*(6-12*p)*sind(phi))+D.subset(math.index(3,3))*(1/L*(6*p-6*p*p)*sind(phi)*sind(phi)/r)))*r*L
        K.subset(math.index(2, 3), @integrale(k34, 0, 1))
        
        k35 = (p)->
            (B.subset(math.index(0,2))*(D.subset(math.index(0,0))*B.subset(math.index(0,4))+D.subset(math.index(0,1))*(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r))+(-L*(p-2*p*p+p*p*p)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,4))+D.subset(math.index(1,1))*(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r))+(-1/L*(-4+6*p))*(D.subset(math.index(2,2))*(1/L*L*(6-12*p)*cosd(phi))+D.subset(math.index(2,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r)))+((1-4*p+3*p*p)*sind(phi)/r)*(D.subset(math.index(3,2))*(1/L*L*(6-12*p)*cosd(phi))+D.subset(math.index(3,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r))))*r*L
        K.subset(math.index(2, 4), @integrale(k35, 0, 1))
        
        k36 = (p)->
            (B.subset(math.index(0,2))*(D.subset(math.index(0,0))*B.subset(math.index(0,5))+D.subset(math.index(0,1))*(-L*(-p*p+p*p*p)*cosd(phi)/r))+(-L*(p-2*p*p+p*p*p)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,5))+D.subset(math.index(1,1))*(-L*(-p*p+p*p*p)*cosd(phi)/r))+(-1/L*(-4+6*p))*(D.subset(math.index(2,2))*(-1/L*(-2+6*p))+D.subset(math.index(2,3))*((-2*p+3*p*p)*sind(phi)/r))+((1-4*p+3*p*p)*sind(phi)/r)*(D.subset(math.index(3,2))*(-1/L*(-2+6*p))+D.subset(math.index(3,3))*((-2*p+3*p*p)*sind(phi)/r)))*r*L;
        K.subset(math.index(2, 5), @integrale(k36, 0, 1))
        
        k44 = (p)->
            (B.subset(math.index(0,3))*(D.subset(math.index(0,0))*B.subset(math.index(0,3))+D.subset(math.index(0,1))*(p*sind(phi)*cosd(phi)/r-(3*p*p-2*p*p*p)*sind(2*phi)/(2*r)))+(p*sind(phi)*cosd(phi)/r-(3*p*p-2*p*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(1,0))*B.subset(math.index(0,3))+D.subset(math.index(1,1))*(p*sind(phi)*cosd(phi)/r-(3*p*p-2*p*p*p)*sind(2*phi)/(2*r)))+(-1/L*L*(6-12*p)*sind(phi))*(D.subset(math.index(2,2))*(-1/L*L*(6-12*p)*sind(phi))+D.subset(math.index(2,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r)))+(1/L*(6*p-6*p*p)*sind(phi)*sind(phi)/r)*(D.subset(math.index(3,2))*(-1/L*L*(6-12*p)*sind(phi))+D.subset(math.index(3,3))*(1/L*(6*p-6*p*p)*sind(phi)*sind(phi)/r)))*r*L
        K.subset(math.index(3, 3), @integrale(k44, 0, 1))
        
        k45 = (p)->
            (B.subset(math.index(0,3))*(D.subset(math.index(0,0))*B.subset(math.index(0,4))+D.subset(math.index(0,1))*(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r))+(p*sind(phi)*cosd(phi)/r-(3*p*p-2*p*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(1,0))*B.subset(math.index(0,4))+D.subset(math.index(1,1))*(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r))+(-1/L*L*(6-12*p)*sind(phi))*(D.subset(math.index(2,2))*(1/L*L*(6-12*p)*cosd(phi))+D.subset(math.index(2,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r)))+(1/L*(6*p-6*p*p)*sind(phi)*sind(phi)/r)*(D.subset(math.index(3,2))*(1/L*L*(6-12*p)*cosd(phi))+D.subset(math.index(3,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r))))*r*L
        K.subset(math.index(3, 4), @integrale(k45, 0, 1))
        
        k46 = (p)->
            (B.subset(math.index(0,3))*(D.subset(math.index(0,0))*B.subset(math.index(0,5))+D.subset(math.index(0,1))*(-L*(-p*p+p*p*p)*cosd(phi)/r))+(p*sind(phi)*cosd(phi)/r-(3*p*p-2*p*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(1,0))*B.subset(math.index(0,5))+D.subset(math.index(1,1))*(-L*(-p*p+p*p*p)*cosd(phi)/r))+(-1/L*L*(6-12*p)*sind(phi))*(D.subset(math.index(2,2))*(-1/L*(-2+6*p))+D.subset(math.index(2,3))*((-2*p+3*p*p)*sind(phi)/r))+(1/L*(6*p-6*p*p)*sind(phi)*sind(phi)/r)*(D.subset(math.index(3,2))*(-1/L*(-2+6*p))+D.subset(math.index(3,3))*((-2*p+3*p*p)*sind(phi)/r)))*r*L
        K.subset(math.index(3, 5), @integrale(k46, 0, 1))
        
        k55 = (p)->
            (B.subset(math.index(0,4))*(D.subset(math.index(0,0))*B.subset(math.index(0,4))+D.subset(math.index(0,1))*(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r))+(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,4))+D.subset(math.index(1,1))*(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r))+(1/L*L*(6-12*p)*cosd(phi))*(D.subset(math.index(2,2))*(1/L*L*(6-12*p)*cosd(phi))+D.subset(math.index(2,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r)))+(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(3,2))*(1/L*L*(6-12*p)*cosd(phi))+D.subset(math.index(3,3))*(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r))))*r*L
        K.subset(math.index(4, 4), @integrale(k55, 0, 1))
        
        k56 = (p)->
            (B.subset(math.index(0,4))*(D.subset(math.index(0,0))*B.subset(math.index(0,5))+D.subset(math.index(0,1))*(-L*(-p*p+p*p*p)*cosd(phi)/r))+(p*sind(phi)*sind(phi)/r+(3*p*p-2*p*p*p)*cosd(phi)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,5))+D.subset(math.index(1,1))*(-L*(-p*p+p*p*p)*cosd(phi)/r))+(1/L*L*(6-12*p)*cosd(phi))*(D.subset(math.index(2,2))*(-1/L*(-2+6*p))+D.subset(math.index(2,3))*((-2*p+3*p*p)*sind(phi)/r))+(-1/L*(6*p-6*p*p)*sind(2*phi)/(2*r))*(D.subset(math.index(3,2))*(-1/L*(-2+6*p))+D.subset(math.index(3,3))*((-2*p+3*p*p)*sind(phi)/r)))*r*L
        K.subset(math.index(4, 5), @integrale(k56, 0, 1))
        
        k66 = (p)->
            (B.subset(math.index(0,5))*(D.subset(math.index(0,0))*B.subset(math.index(0,5))+D.subset(math.index(0,1))*(-L*(-p^2+p^3)*cosd(phi)/r))+(-L*(-p^2+p^3)*cosd(phi)/r)*(D.subset(math.index(1,0))*B.subset(math.index(0,5))+D.subset(math.index(1,1))*(-L*(-p^2+p^3)*cosd(phi)/r))+(-1/L*(-2+6*p))*(D.subset(math.index(2,2))*(-1/L*(-2+6*p))+D.subset(math.index(2,3))*((-2*p+3*p^2)*sind(phi)/r))+((-2*p+3*p^2)*sind(phi)/r)*(D.subset(math.index(3,2))*(-1/L*(-2+6*p))+D.subset(math.index(3,3))*((-2*p+3*p^2)*sind(phi)/r)))*r*L
        K.subset(math.index(5, 5), @integrale(k66, 0, 1))


        I = math.diag(math.diag(K))
        J = math.add(K, math.transpose(K))
        L = math.subtract(J,I)
        K = math.multiply(2 * Math.PI * E * t / ( 1 - nu * nu ), L)
        @k_elem = K

#         console.log "k_elem = " + @k_elem
        
        
        
        
        
        
        
        
        
        
        
        
        
        