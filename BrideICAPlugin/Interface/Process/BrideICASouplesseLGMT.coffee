# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICASouplesseLGMT extends Model
    constructor: ( @param = {} ) ->
        super()
        
        
        @add_attr
            R_tube : 0
            Ap_support : 0
        
        @calcul_souplesse_lgmt()
        
    calcul_souplesse_lgmt: ( ) ->
        # initialisation des paramètres
        D_ext_plaque_contact = @param.D_ext_plaque_contact
        D_int_plaque_contact = @param.D_int_plaque_contact
        dt = @param.dt
        di = @param.di
        Da = @param.Da
        Angle_sect = @param.Angle_sect
        H_s = @param.H_serree
        
        
        
        R_ext_contact = 0.5 * D_ext_plaque_contact
        R_int_contact = 0.5 * D_int_plaque_contact
        ri = 0.5 * di
        Angle_sect = 0.5 * Angle_sect
        Perimetre = Angle_sect * ( R_ext_contact + R_int_contact ) + ( R_ext_contact - R_int_contact )
        

        
        
        N1 = Math.round( 180 * ( Angle_sect * ( R_ext_contact ) / Perimetre ) )
        N2 = Math.round( 180 * ( R_ext_contact - R_int_contact ) / Perimetre )
        N3 = Math.round( 180 * ( Angle_sect * ( R_int_contact ) / Perimetre ) )
        @Ap_support.set 0
        somme_sect = 0
        somme_cdg = 0


#----------------------------------------------------------------- CALCUL POUR LA ZONE 1 ------------------------------------------------------------------------------
       
        theta_secteur = []
        for i in [ 0 .. (N1 - 1) ]
#         Calcul des proprietes du premier coté du secteur -----------------------------------------------------------------------------------------------------------
            theta1 = Angle_sect * ( i ) / N1
            R1 = Math.sqrt( Math.pow( ( R_ext_contact * Math.cos( theta1 ) - ri ) , 2 ) + Math.pow( ( R_ext_contact * Math.sin( theta1 ) ), 2 ) )
            psi1 = Math.asin( R_ext_contact * Math.sin( theta1 ) / R1 )
            
            theta2 = Angle_sect * ( i + 1 ) / N1
            R2 = Math.sqrt( Math.pow( ( R_ext_contact * Math.cos( theta2 ) - ri ) , 2 ) + Math.pow( ( R_ext_contact * Math.sin( theta2 ) ), 2 ) )
            psi2 = Math.asin( R_ext_contact * Math.sin( theta2 ) / R2 )
            
#         Calcul du rayon equivalent moyen du secteur ----------------------------------------------------------------------------------------------------------------
            k = i + 0
            
            v = Math.abs( psi2 - psi1 )
            theta_secteur.push v
            theta = Angle_sect * ( i + 0.5 ) / N1
            R_eq = Math.sqrt( Math.pow( ( R_ext_contact * Math.cos( theta ) - ri ) , 2 ) + Math.pow( ( R_ext_contact * Math.sin( theta ) ), 2 ) )
            D_eq = 2 * R_eq
            
            
#         Calcul de la section equivalente --------------------------------------------------------------------------------------------------------------------------
            if dt >= D_eq
                alert "ERREUR-revoir les dimensions du trou de fixation"
            else
                Dp = D_eq / Da
                Lp = H_s / Da
                Dt = dt / Da
                
#         Calcul du parametre Ap qui est la section equivalente selon la relation de Rasmussen ----------------------------------------------------------------------
                m = ( 0.35 * Math.sqrt( Lp ) + Math.sqrt( 1 + 2 * Lp ) - 1 ) / ( 2.04 * ( Dp * Dp - Dt * Dt ) )
                A_eq_cyl = ( 0.25 * Math.PI * ( 1 - Dt * Dt ) + 0.61 * ( Dp * Dp - 1 ) * Math.atan( m ) ) * Da * Da
                A_eq_sect = A_eq_cyl * theta_secteur[k] / ( 2 * Math.PI )

                @Ap_support.set (@Ap_support.get() + A_eq_sect)
                somme_cdg = somme_cdg + A_eq_sect * Math.cos( 0.5 * ( psi1 + psi2 ) )

#----------------------------------------------------------------- CALCUL POUR LA ZONE 2 ------------------------------------------------------------------------------
        
        pas_discretisation = ( R_ext_contact - R_int_contact ) / N2
        
        for i in [ 0 .. N2 - 1 ]
            k = k + 1
            L1 = R_ext_contact - i * pas_discretisation
            L2 = R_ext_contact - ( i + 1 ) * pas_discretisation
            L31 = Math.sqrt( L1 * L1 + ri * ri - 2 * L1 * ri * Math.cos( Angle_sect ) )
            L32 = Math.sqrt( L2 * L2 + ri * ri - 2 * L2 * ri * Math.cos( Angle_sect ) )
            alfa1 = Math.acos( ( L1 * L1 - ( L31 * L31 + ri * ri ) ) / ( -2 * L31 * ri ) )
            alfa2 = Math.acos( ( L2 * L2 - ( L32 * L32 + ri * ri ) ) / ( -2 * L32 * ri ) )
            w = Math.abs( alfa2 - alfa1 )
            theta_secteur.push w
            L3 = L2 + 0.5 * pas_discretisation
            L3_eq = Math.sqrt( L3 * L3 + ri * ri - 2 * L3 * ri * Math.cos( Angle_sect ) )
            alfa = Math.PI - Math.acos( ( L3 * L3 - ( L3_eq * L3_eq + ri * ri ) ) / ( -2 * L3_eq * ri ) )
            D_eq = 2 * L3_eq
            if dt >= D_eq
                alert "ERREUR-revoir les dimensions du trou de fixation"
            else
                Dp = D_eq / Da
                Lp = H_s / Da
                Dt = dt / Da
                m = ( 0.35 * Math.sqrt( Lp ) + Math.sqrt( 1 + 2 * Lp ) - 1 ) / ( 2.04 * ( Dp * Dp - Dt * Dt ) )
                A_eq_cyl = ( 0.25 * Math.PI * ( 1 - Dt * Dt ) + 0.61 * ( Dp * Dp - 1 ) * Math.atan( m ) ) * Da * Da
                A_eq_sect = A_eq_cyl * theta_secteur[k] / ( 2 * Math.PI)
                @Ap_support.set ( @Ap_support.get() + A_eq_sect )
                somme_cdg = somme_cdg + A_eq_sect * Math.cos( Math.PI - 0.5 * ( alfa1 + alfa2 ) )

                
#----------------------------------------------------------------- CALCUL POUR LA ZONE 3 ------------------------------------------------------------------------------

        for i in [ 0 .. N3 - 1 ]
            k = k + 1
            theta1 = Angle_sect * ( N3 - i ) / N3
            R1 = Math.sqrt( Math.pow( ( ri - R_int_contact * Math.cos( theta1 ) ) , 2 ) + Math.pow( ( R_int_contact * Math.sin( theta1 ) ), 2 ) )
            psi1 = Math.asin( R_int_contact * Math.sin( theta1 ) / R1 )
            theta2 = Angle_sect * ( N3 - i - 1 ) / N3
            R2 = Math.sqrt( Math.pow( ( ri - R_int_contact * Math.cos( theta2 ) ) , 2 ) + Math.pow( ( R_int_contact * Math.sin( theta2 ) ), 2 ) )
            psi2 = Math.asin( ( R_int_contact * Math.sin( theta2 ) / R2 ) )
            x = Math.abs( psi2 - psi1 )
            theta_secteur.push x
            theta = Angle_sect * ( N3 - i - 0.5 ) / N3
            R_eq = Math.sqrt( Math.pow( ( ri - R_int_contact * Math.cos( theta ) ) , 2 ) + Math.pow( ( R_int_contact * Math.sin( theta ) ), 2 ) )
            D_eq = 2 * R_eq
            if dt >= D_eq
                alert "ERREUR-revoir les dimensions du trou de fixation"
            else
                Dp = D_eq / Da
                Lp = H_s / Da
                Dt = dt / Da
                m = ( 0.35 * Math.sqrt( Lp ) + Math.sqrt( 1 + 2 * Lp ) - 1 ) / ( 2.04 * ( Dp * Dp - Dt * Dt ) )
                A_eq_cyl = ( 0.25 * Math.PI * ( 1 - Dt * Dt ) + 0.61 * ( Dp * Dp - 1 ) * Math.atan( m ) ) * Da * Da
                A_eq_sect = A_eq_cyl * theta_secteur[k] / ( 2 * Math.PI )
                @Ap_support.set ( @Ap_support.get() + A_eq_sect )
                somme_cdg = somme_cdg + A_eq_sect * Math.cos(Math.PI - 0.5 * ( psi1 + psi2 ) )
                somme_sect = somme_sect + theta_secteur[k]
                
        cdg = ( somme_cdg / @Ap_support.get() ) * 0.25 * ( Da + dt )
        @R_tube.set ri + cdg
        @Ap_support.set ( @Ap_support.get() * 2 )
