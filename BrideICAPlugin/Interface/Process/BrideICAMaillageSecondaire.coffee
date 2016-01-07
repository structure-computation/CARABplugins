# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICAMaillageSecondaire extends Model
    constructor: ( @param = {} ) ->
        super()
        
        @add_attr
            elem : []
            noeud : []
            w : 0
            x : 0
            wa : 0
            we : 0
            wc : 0
            wb : 0
            wd : 0
            wf : 0
            wpression1 : 0
            wpression2 : 0
            
        @maillage_secondaire()   
    
    strcmp: ( s1, s2 ) ->
        return ( ( s1 == s2 ) ? 0 : ( ( s1 > s2 ) ? 1 : -1 ) )
    
    maillage_secondaire: ( ) ->
        string = @param.string
        taille_secondaire = @param.taille_secondaire
        taille_secondaire_plaque = @param.taille_secondaire_plaque
        w = @param.w
        x = @param.x
        elem = @param.elem
        noeud = @param.noeud
        bride_sup = @param.bride_sup
        N_bride_sup = @param.N_bride_sup
        sp = @param.sp
        a1 = @param.a1
        b1 = @param.b1
        c1 = @param.c1
        d1 = @param.d1
        e1 = @param.e1
        f1 = @param.f1
        g1 = @param.g1
        r_moyen1 = @param.r_moyen1
        Angle_sect = @param.Angle_sect
        h_plaque1 = @param.h_plaque1
        D_ext_plaque1 = @param.D_ext_plaque1
        D_int_plaque1 = @param.D_int_plaque1
        D_ext_tube1 = @param.D_ext_tube1
        D_int_tube1 = @param.D_int_tube1
        h_tube1 = @param.h_tube1
        h_tube_incline1 = @param.h_tube_incline1
        D_ext_base_tube_incline1 = @param.D_ext_base_tube_incline1
        D_int_base_tube_incline1 = @param.D_int_base_tube_incline1
        angle_tube_incline1 = @param.angle_tube_incline1
        di = @param.di
        dt = @param.dt
        E_bride_sup = @param.E_bride_sup
        nu_bride_sup = @param.nu_bride_sup
        E_bride_inf = @param.E_bride_inf
        nu_bride_inf = @param.nu_bride_inf
        taille_secondaire = @param.taille_secondaire
        taille_secondaire_plaque = @param.taille_secondaire_plaque
        epaisseur_tube_incline1 = Math.abs( ( D_ext_tube1 - D_int_tube1 ) * Math.cos( angle_tube_incline1 * Math.PI / 180 ) / 2 )
#         console.log "angle_tube_incline1 = " + angle_tube_incline1                                   
        if ( @strcmp(string, "sup") )
            noeud.push {}
            elem.push {}
            noeud[w - 1].r = bride_sup[0].r
            noeud[w - 1].z = bride_sup[0].z
            wa = w
            for i in [ 2 .. b1 ]
                taille_globale = Math.abs( bride_sup[i - 1].r - bride_sup[i - 2].r )
                if ( taille_globale < taille_secondaire_plaque )
                    nombre_elements = 1
                else
                    nombre_elements = Math.round(taille_globale / taille_secondaire_plaque )
                if ( nombre_elements == 1 )
                    w = w + 1
                    noeud.push {}
                    elem.push {}
                    noeud[w - 1].r = bride_sup[i - 1].r
                    noeud[w - 1].z = bride_sup[i - 1].z
                    x = x + 1
                    elem[x - 1].noeud1 = w - 1
                    elem[x - 1].noeud2 = w
                    elem[x - 1].E = E_bride_sup
                    elem[x - 1].nu = nu_bride_sup
                    elem[x - 1].type = 1
                    elem[x - 1].geom1 = noeud[w - 1].r
                    elem[x - 1].geom2 = noeud[w - 2].r
                    if ( ( dt * dt / 4 ) - Math.pow( ( ( noeud[w - 1].r + noeud[w - 2].r) / 2 - di / 2 ), 2 ) > 0 )
                        numeps = Math.pow( ( Math.pow( ( 0.5 * dt ), 2) - Math.pow( ( ( ( noeud[w - 1].r + noeud[w - 2].r ) / 2 ) - ( 0.5 * di ) ), 2 ) ), 0.5 )
                        denumeps = 0.5 * Angle_sect * ( ( noeud[w - 1].r + noeud[w - 2].r ) / 2 )
                        epsilon = 1 - numeps / denumeps
                        elem[x - 1].geom3 = h_plaque1 * ( Math.pow( epsilon, 1/3 ) )
                    else
                        elem[x - 1].geom3 = h_plaque1
                else
                    for ww in [ (w + 1) .. (w + nombre_elements) ]
                        w = ww
                        noeud.push {}
                        elem.push {}
                        n = n + 1
                        noeud[w - 1].r = noeud[w - 2].r + taille_globale / nombre_elements                      
                        noeud[w - 1].z = noeud[w - 2].z
                        x = x + 1
                        elem[x - 1].noeud1 = w - 1
                        elem[x - 1].noeud2 = w
                        elem[x - 1].E = E_bride_sup
                        elem[x - 1].nu = nu_bride_sup
                        elem[x - 1].type = 1
                        elem[x - 1].geom1 = noeud[w - 2].r
                        elem[x - 1].geom2 = noeud[w - 1].r
                        if ( ( dt * dt / 4 ) - Math.pow( ( ( noeud[w - 1].r + noeud[w - 2].r) / 2 - di / 2 ), 2 ) > 0 )
                            
                            numeps = Math.pow( ( Math.pow( ( 0.5 * dt ), 2) - Math.pow( ( ( ( noeud[w - 1].r + noeud[w - 2].r ) / 2 ) - ( 0.5 * di ) ), 2 ) ), 0.5 )
                            denumeps = 0.5 * Angle_sect * ( ( noeud[w - 1].r + noeud[w - 2].r ) / 2 )
                            epsilon = 1 - numeps / denumeps
                            
                            elem[x - 1].geom3 = h_plaque1 * ( Math.pow( epsilon, 1/3 ) )
                            
                        else
                            
                            elem[x - 1].geom3 = h_plaque1
                            
                if ( i == c1 )
                    wc = w
                else if ( i == e1 )
                    we = w
                else if ( i == b1 )
                    wb = w
                else if ( ( bride_sup[i - 1].r == D_int_base_tube_incline1 / 2 ) and ( bride_sup[i - 1].z == 0 ) )
                    wpression1 = w
                    
            wb = noeud.length
            taille_globale = Math.abs( bride_sup[d1 - 1].z - bride_sup[c1 - 1].z )
            if ( taille_globale < taille_secondaire )
                nombre_elements = 1
            else
                nombre_elements = Math.round(taille_globale / taille_secondaire )
            if ( nombre_elements == 1 )
                w = w + 1
                noeud.push {}
                elem.push {}
                
                noeud[w - 1].r = bride_sup[d1 - 1].r
                noeud[w - 1].z = bride_sup[d1 - 1].z
                x = x + 1
                elem[x - 1].noeud1 = wc
                elem[x - 1].noeud2 = w
                elem[x - 1].E = E_bride_sup
                elem[x - 1].nu = nu_bride_sup
                elem[x - 1].type = 2
                elem[x - 1].geom1 = noeud[wc - 1].r
                elem[x - 1].geom2 = sp[0] / nombre_elements
                elem[x - 1].geom3 = ( D_ext_plaque1 - D_int_plaque1 ) / 2
            else
                tmp = w + 1
                for ww3 in [ tmp .. w + nombre_elements ]
                    w = ww3
                    if ( w == tmp )
                        
                        noeud.push {}
                        elem.push {}
                        noeud[w - 1].r = noeud[wc - 1].r
                        noeud[w - 1].z = noeud[wc - 1].z + taille_globale / nombre_elements
                        x = x + 1
                        elem[x - 1].noeud1 = wc
                        elem[x - 1].noeud2 = w
                        elem[x - 1].E = E_bride_sup
                        elem[x - 1].nu = nu_bride_sup
                        elem[x - 1].type = 2
                        elem[x - 1].geom1 = noeud[wc - 1].r
                        elem[x - 1].geom2 = sp[0] / nombre_elements
                        elem[x - 1].geom3 = ( D_ext_plaque1 - D_int_plaque1 ) / 2
                    else
                        noeud.push {}
                        elem.push {}
                        noeud[w - 1].r = noeud[w - 2].r
                        noeud[w - 1].z = noeud[w - 2].z + taille_globale / nombre_elements
                        x = x + 1
                        elem[x - 1].noeud1 = w - 1
                        elem[x - 1].noeud2 = w
                        elem[x - 1].E = E_bride_sup
                        elem[x - 1].nu = nu_bride_sup
                        elem[x - 1].type = 2
                        elem[x - 1].geom1 = noeud[wc - 1].r
                        elem[x - 1].geom2 = sp[0] / nombre_elements
                        elem[x - 1].geom3 = ( D_ext_plaque1 - D_int_plaque1 ) / 2
            wd = noeud.length
            taille_r = Math.abs(bride_sup[f1 - 2].r - bride_sup[e1 - 1].r)
            taille_z = Math.abs(bride_sup[f1 - 2].z - bride_sup[e1 - 1].z)
            taille_globale = Math.sqrt(taille_r * taille_r + taille_z * taille_z)
            if ( taille_globale < taille_secondaire )
                nombre_elements = 1
            else
                nombre_elements = Math.round(taille_globale / taille_secondaire )
            if ( nombre_elements == 1 )
                w = w + 1
                wpression2 = w
                noeud.push {}
                elem.push {}
                noeud[w - 1].r = bride_sup[f1 - 2].r
                noeud[w - 1].z = bride_sup[f1 - 2].z
                x = x + 1
                elem[x - 1].noeud1 = we
                elem[x - 1].noeud2 = w
                elem[x - 1].E = E_bride_sup
                elem[x - 1].nu = nu_bride_sup
                elem[x - 1].type = 4
                elem[x - 1].geom1 = angle_tube_incline1
                elem[x - 1].geom2 = epaisseur_tube_incline1
                elem[x - 1].geom3 = 0
            else
                tmp = w + 1
                for ww4 in [ tmp .. w + nombre_elements ]
                    w = ww4
                    if ( w == tmp )
                        noeud.push {}
                        elem.push {}
                        noeud[w - 1].r = noeud[we - 1].r - taille_r / nombre_elements
                        noeud[w - 1].z = noeud[we - 1].z + taille_z / nombre_elements
                        x = x + 1
                        elem[x - 1].noeud1 = we
                        elem[x - 1].noeud2 = w
                        elem[x - 1].E = E_bride_sup
                        elem[x - 1].nu = nu_bride_sup
                        elem[x - 1].type = 4
                        elem[x - 1].geom1 = angle_tube_incline1
                        elem[x - 1].geom2 = epaisseur_tube_incline1
                        elem[x - 1].geom3 = 0
                    else
                        noeud.push {}
                        elem.push {}
                        noeud[w - 1].r = noeud[w - 2].r - taille_r / nombre_elements
                        noeud[w - 1].z = noeud[w - 2].z + taille_z / nombre_elements
                        x = x + 1
                        elem[x - 1].noeud1 = w - 1
                        elem[x - 1].noeud2 = w
                        elem[x - 1].E = E_bride_sup
                        elem[x - 1].nu = nu_bride_sup
                        elem[x - 1].type = 4
                        elem[x - 1].geom1 = angle_tube_incline1
                        elem[x - 1].geom2 = epaisseur_tube_incline1
                        elem[x - 1].geom3 = 0
                    wpression2 = w
            taille_r = Math.abs(bride_sup[f1 - 1].r - bride_sup[f1 - 2].r)
            taille_z = Math.abs(bride_sup[f1 - 1].z - bride_sup[f1 - 2].z)
            taille_globale = Math.sqrt(taille_r * taille_r + taille_z * taille_z)
            if ( taille_globale < taille_secondaire )
                nombre_elements = 1
            else
                nombre_elements = Math.round(taille_globale / taille_secondaire )
            if ( nombre_elements == 1 )
                w = w + 1
                noeud.push {}
                elem.push {}
                noeud[w - 1].r = bride_sup[f1 - 1].r
                noeud[w - 1].z = bride_sup[f1 - 1].z
                x = x + 1
                elem[x - 1].noeud1 = w - 1
                elem[x - 1].noeud2 = w
                elem[x - 1].E = E_bride_sup
                elem[x - 1].nu = nu_bride_sup
                elem[x - 1].type = 4
                elem[x - 1].geom1 = angle_tube_incline1
                elem[x - 1].geom2 = epaisseur_tube_incline1
                elem[x - 1].geom3 = 0
            else
                for ww1 in [ w + 1 .. w + nombre_elements ]
                    w = ww1
                    noeud.push {}
                    elem.push {}
                    noeud[w - 1].r = noeud[w - 2].r - taille_r / nombre_elements
                    noeud[w - 1].z = noeud[w - 2].z + taille_z / nombre_elements
                    x = x + 1
                    elem[x - 1].noeud1 = w - 1
                    elem[x - 1].noeud2 = w
                    elem[x - 1].E = E_bride_sup
                    elem[x - 1].nu = nu_bride_sup
                    elem[x - 1].type = 4
                    elem[x - 1].geom1 = angle_tube_incline1
                    elem[x - 1].geom2 = epaisseur_tube_incline1
                    elem[x - 1].geom3 = 0
            wf = noeud.length
            
            taille_globale = Math.abs(bride_sup[g1 - 1].z - bride_sup[f1 - 1].z)
            if ( taille_globale < taille_secondaire )
                nombre_elements = 1
            else
                nombre_elements = Math.round(taille_globale / taille_secondaire )
            if ( nombre_elements == 1 )
                w = w + 1
                noeud.push {}
                elem.push {}
                noeud[w - 1].r = bride_sup[g1 - 1].r
                noeud[w - 1].z = bride_sup[g1 - 1].z
                x = x + 1
                elem[x - 1].noeud1 = w - 1
                elem[x - 1].noeud2 = w
                elem[x - 1].E = E_bride_sup
                elem[x - 1].nu = nu_bride_sup
                elem[x - 1].type = 3
                elem[x - 1].geom1 = noeud[w - 1].r
                elem[x - 1].geom2 = 0
                elem[x - 1].geom3 = ( D_ext_tube1 - D_int_tube1 ) / 2
            else
                for ww2 in [ w + 1 .. w + nombre_elements ]
                    w = ww2
                    noeud.push {}
                    elem.push {}
                    noeud[w - 1].r = noeud[w - 2].r
                    noeud[w - 1].z = noeud[w - 2].z + taille_globale / nombre_elements
                    x = x + 1
                    elem[x - 1].noeud1 = w - 1
                    elem[x - 1].noeud2 = w
                    elem[x - 1].E = E_bride_sup
                    elem[x - 1].nu = nu_bride_sup
                    elem[x - 1].type = 3
                    elem[x - 1].geom1 = noeud[w - 1].r
                    elem[x - 1].geom2 = 0
                    elem[x - 1].geom3 = ( D_ext_tube1 - D_int_tube1 ) / 2
            wg = noeud.length
            @elem.set elem
            @noeud.set noeud
            @w.set w
            @x.set x
            @wa.set wa
            @wb.set wb
            @wc.set wc
            @wd.set wd
            @we.set we
            @wf.set wf
            @wpression1.set wpression1
            @wpression2.set wpression2

        else if ( @strcmp(string, "inf") )
            noeud.push {}
            elem.push {}
            noeud[w - 1].r = bride_sup[0].r
            noeud[w - 1].z = bride_sup[0].z
            wa = w
            for i in [ 2 .. b1 ]
                taille_globale = Math.abs( bride_sup[i - 1].r - bride_sup[i - 2].r )
                if ( taille_globale < taille_secondaire_plaque )
                    nombre_elements = 1
                else
                    nombre_elements = Math.round(taille_globale / taille_secondaire_plaque )
                if ( nombre_elements == 1 )
                    w = w + 1
                    
                    noeud.push {}
                    elem.push {}
                    noeud[w - 1].r = bride_sup[i - 1].r
                    noeud[w - 1].z = bride_sup[i - 1].z
                    x = x + 1
                    elem[x - 1].noeud1 = w - 1
                    elem[x - 1].noeud2 = w
                    elem[x - 1].E = E_bride_inf
                    elem[x - 1].nu = nu_bride_inf
                    elem[x - 1].type = 1
                    elem[x - 1].geom1 = noeud[w - 2].r
                    elem[x - 1].geom2 = noeud[w - 1].r
                    
                    if ( ( dt * dt / 4 ) - Math.pow( ( ( noeud[w - 1].r + noeud[w - 2].r) / 2 - di / 2 ), 2 ) > 0 )
                        numeps = Math.pow( ( Math.pow( ( 0.5 * dt ), 2) - Math.pow( ( ( ( noeud[w - 1].r + noeud[w - 2].r ) / 2 ) - ( 0.5 * di ) ), 2 ) ), 0.5 )
                        denumeps = 0.5 * Angle_sect * ( ( noeud[w - 1].r + noeud[w - 2].r ) / 2 )
                        epsilon = 1 - numeps / denumeps
                        elem[x - 1].geom3 = h_plaque1 * ( Math.pow( epsilon, 1/3 ) )
                    else
                        elem[x - 1].geom3 = h_plaque1
                else
                    for ww in [ (w + 1) .. (w + nombre_elements) ]
                        w = ww
                        noeud.push {}
                        elem.push {}
#                         console.log "w = " + w
                        noeud[w - 1].r = noeud[w - 2].r + taille_globale / nombre_elements                      
                        noeud[w - 1].z = noeud[w - 2].z
                        x = x + 1
                        elem[x - 1].noeud1 = w - 1
                        elem[x - 1].noeud2 = w
                        elem[x - 1].E = E_bride_inf
                        elem[x - 1].nu = nu_bride_inf
                        elem[x - 1].type = 1
                        elem[x - 1].geom1 = noeud[w - 2].r
                        elem[x - 1].geom2 = noeud[w - 1].r
                        
                        if ( ( dt * dt / 4 ) - Math.pow( ( ( noeud[w - 1].r + noeud[w - 2].r) / 2 - di / 2 ), 2 ) > 0 )
                            
                            numeps = Math.pow( ( Math.pow( ( 0.5 * dt ), 2) - Math.pow( ( ( ( noeud[w - 1].r + noeud[w - 2].r ) / 2 ) - ( 0.5 * di ) ), 2 ) ), 0.5 )
                            denumeps = 0.5 * Angle_sect * ( ( noeud[w - 1].r + noeud[w - 2].r ) / 2 )
                            epsilon = 1 - numeps / denumeps
                            
                            elem[x - 1].geom3 = h_plaque1 * ( Math.pow( epsilon, 1/3 ) )
                            
                        else
                            
                            elem[x - 1].geom3 = h_plaque1
                            
                if ( i == c1 )
                    wc = w
                else if ( i == e1 )
                    we = w
                else if ( i == b1 )
                    wb = w
                else if ( ( bride_sup[i - 1].r == D_int_base_tube_incline1 / 2 ) and ( bride_sup[i - 1].z == 0 ) )
                    wpression1 = w                   
            wb = noeud.length
#             console.log bride_sup[d1-1].z
            taille_globale = Math.abs( bride_sup[d1 - 1].z - bride_sup[c1 - 1].z )
            if ( taille_globale < taille_secondaire )
                nombre_elements = 1
            else
                nombre_elements = Math.round(taille_globale / taille_secondaire )
            if ( nombre_elements == 1 )
                w = w + 1
                noeud.push {}
                elem.push {}
#                 console.log "w = " + w                
                noeud[w - 1].r = bride_sup[d1 - 1].r
                noeud[w - 1].z = bride_sup[d1 - 1].z
#                 console.log noeud[w - 1].r
#                 console.log noeud[w - 1].z
                x = x + 1
                elem[x - 1].noeud1 = wc
                elem[x - 1].noeud2 = w
                elem[x - 1].E = E_bride_inf
                elem[x - 1].nu = nu_bride_inf
                elem[x - 1].type = 2
                elem[x - 1].geom1 = noeud[wc - 1].r
                elem[x - 1].geom2 = sp[1] / nombre_elements
                elem[x - 1].geom3 = ( D_ext_plaque1 - D_int_plaque1 ) / 2
            else
                tmp = w + 1
                for ww3 in [ tmp .. w + nombre_elements ]
                    w = ww3
                    if ( w == tmp )                        
                        noeud.push {}
                        elem.push {}
                        noeud[w - 1].r = noeud[wc - 1].r
                        noeud[w - 1].z = noeud[wc - 1].z - taille_globale / nombre_elements
                        x = x + 1
                        elem[x - 1].noeud1 = wc
                        elem[x - 1].noeud2 = w
                        elem[x - 1].E = E_bride_inf
                        elem[x - 1].nu = nu_bride_inf
                        elem[x - 1].type = 2
                        elem[x - 1].geom1 = noeud[wc - 1].r
                        elem[x - 1].geom2 = sp[1] / nombre_elements
                        elem[x - 1].geom3 = ( D_ext_plaque1 - D_int_plaque1 ) / 2
                    else
                        noeud.push {}
                        elem.push {}
                        noeud[w - 1].r = noeud[w - 2].r
                        noeud[w - 1].z = noeud[w - 2].z - taille_globale / nombre_elements
                        x = x + 1
                        elem[x - 1].noeud1 = w - 1
                        elem[x - 1].noeud2 = w
                        elem[x - 1].E = E_bride_inf
                        elem[x - 1].nu = nu_bride_inf
                        elem[x - 1].type = 2
                        elem[x - 1].geom1 = noeud[wc - 1].r
                        elem[x - 1].geom2 = sp[1] / nombre_elements
                        elem[x - 1].geom3 = ( D_ext_plaque1 - D_int_plaque1 ) / 2
            wd = noeud.length
            taille_r = Math.abs(bride_sup[f1 - 2].r - bride_sup[e1 - 1].r)
            taille_z = Math.abs(bride_sup[f1 - 2].z - bride_sup[e1 - 1].z)
            taille_globale = Math.sqrt(taille_r * taille_r + taille_z * taille_z)
            if ( taille_globale < taille_secondaire )
                nombre_elements = 1
            else
                nombre_elements = Math.round(taille_globale / taille_secondaire )
            if ( nombre_elements == 1 )
                w = w + 1
                wpression2 = w
                noeud.push {}
                elem.push {}
                noeud[w - 1].r = bride_sup[f1 - 2].r
                noeud[w - 1].z = bride_sup[f1 - 2].z
                x = x + 1
                elem[x - 1].noeud1 = we
                elem[x - 1].noeud2 = w
                elem[x - 1].E = E_bride_inf
                elem[x - 1].nu = nu_bride_inf
                elem[x - 1].type = 4
                elem[x - 1].geom1 = angle_tube_incline1
                elem[x - 1].geom2 = epaisseur_tube_incline1
                elem[x - 1].geom3 = 0
            else
                tmp = w + 1
                for ww4 in [ tmp .. w + nombre_elements ]
                    w = ww4
                    if ( w == tmp )
                        noeud.push {}
                        elem.push {}
                        noeud[w - 1].r = noeud[we - 1].r - taille_r / nombre_elements
                        noeud[w - 1].z = noeud[we - 1].z - taille_z / nombre_elements
                        x = x + 1
                        elem[x - 1].noeud1 = we
                        elem[x - 1].noeud2 = w
                        elem[x - 1].E = E_bride_inf
                        elem[x - 1].nu = nu_bride_inf
                        elem[x - 1].type = 4
                        elem[x - 1].geom1 = angle_tube_incline1
                        elem[x - 1].geom2 = epaisseur_tube_incline1
                        elem[x - 1].geom3 = 0
                    else
                        noeud.push {}
                        elem.push {}
                        noeud[w - 1].r = noeud[w - 2].r - taille_r / nombre_elements
                        noeud[w - 1].z = noeud[w - 2].z + taille_z / nombre_elements
                        x = x + 1
                        elem[x - 1].noeud1 = w - 1
                        elem[x - 1].noeud2 = w
                        elem[x - 1].E = E_bride_inf
                        elem[x - 1].nu = nu_bride_inf
                        elem[x - 1].type = 4
                        elem[x - 1].geom1 = angle_tube_incline1
                        elem[x - 1].geom2 = epaisseur_tube_incline1
                        elem[x - 1].geom3 = 0
                    wpression2 = w
            taille_r = Math.abs(bride_sup[f1 - 1].r - bride_sup[f1 - 2].r)
            taille_z = Math.abs(bride_sup[f1 - 1].z - bride_sup[f1 - 2].z)
            taille_globale = Math.sqrt(taille_r * taille_r + taille_z * taille_z)
            if ( taille_globale < taille_secondaire )
                nombre_elements = 1
            else
                nombre_elements = Math.round(taille_globale / taille_secondaire )
            if ( nombre_elements == 1 )
                w = w + 1
                noeud.push {}
                elem.push {}
                noeud[w - 1].r = bride_sup[f1 - 1].r
                noeud[w - 1].z = bride_sup[f1 - 1].z
                x = x + 1
                elem[x - 1].noeud1 = w - 1
                elem[x - 1].noeud2 = w
                elem[x - 1].E = E_bride_inf
                elem[x - 1].nu = nu_bride_inf
                elem[x - 1].type = 4
                elem[x - 1].geom1 = angle_tube_incline1
                elem[x - 1].geom2 = epaisseur_tube_incline1
                elem[x - 1].geom3 = 0
            else
                for ww1 in [ w + 1 .. w + nombre_elements ]
                    w = ww1
                    noeud.push {}
                    elem.push {}
                    noeud[w - 1].r = noeud[w - 2].r - taille_r / nombre_elements
                    noeud[w - 1].z = noeud[w - 2].z - taille_z / nombre_elements
#                     console.log "w = " + w
                    
#                     console.log "r = " + noeud[w - 1].r
#                     console.log "z = " + noeud[w - 1].z
                    x = x + 1
                    elem[x - 1].noeud1 = w - 1
                    elem[x - 1].noeud2 = w
                    elem[x - 1].E = E_bride_inf
                    elem[x - 1].nu = nu_bride_inf
                    elem[x - 1].type = 4
                    elem[x - 1].geom1 = angle_tube_incline1
                    elem[x - 1].geom2 = epaisseur_tube_incline1
                    elem[x - 1].geom3 = 0
            wf = noeud.length
            
            taille_globale = Math.abs(bride_sup[g1 - 1].z - bride_sup[f1 - 1].z)
            if ( taille_globale < taille_secondaire )
                nombre_elements = 1
            else
                nombre_elements = Math.round(taille_globale / taille_secondaire )
            if ( nombre_elements == 1 )
                w = w + 1
                noeud.push {}
                elem.push {}
                noeud[w - 1].r = bride_sup[g1 - 1].r
                noeud[w - 1].z = bride_sup[g1 - 1].z
                x = x + 1
                elem[x - 1].noeud1 = w - 1
                elem[x - 1].noeud2 = w
                elem[x - 1].E = E_bride_inf
                elem[x - 1].nu = nu_bride_inf
                elem[x - 1].type = 3
                elem[x - 1].geom1 = noeud[w - 1].r
                elem[x - 1].geom2 = 0
                elem[x - 1].geom3 = ( D_ext_tube1 - D_int_tube1 ) / 2
            else
                for ww2 in [ w + 1 .. w + nombre_elements ]
                    w = ww2
                    noeud.push {}
                    elem.push {}
                    noeud[w - 1].r = noeud[w - 2].r
                    noeud[w - 1].z = noeud[w - 2].z - taille_globale / nombre_elements
                    x = x + 1
                    elem[x - 1].noeud1 = w - 1
                    elem[x - 1].noeud2 = w
                    elem[x - 1].E = E_bride_inf
                    elem[x - 1].nu = nu_bride_inf
                    elem[x - 1].type = 3
                    elem[x - 1].geom1 = noeud[w - 1].r
                    elem[x - 1].geom2 = 0
                    elem[x - 1].geom3 = ( D_ext_tube1 - D_int_tube1 ) / 2
            wg = noeud.length        
                    
            @elem.set elem
            @noeud.set noeud
            @w.set w
            @x.set x
            @wa.set wa
            @wb.set wb
            @wc.set wc
            @wd.set wd
            @we.set we
            @wf.set wf
            @wpression1.set wpression1
            @wpression2.set wpression2
            
#         console.log @elem
    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    