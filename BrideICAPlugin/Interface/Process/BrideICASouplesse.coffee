# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda
class BrideICASouplesse extends TreeItem
    constructor: ( @bride_children ) ->
        super()
        
        @_name.set "Souplesse"
        @_viewable.set false
        
        @add_attr
            sptotale : 0
            Ie : 0
            Ae : 0
            Angle_sect : 0
            r_moyen2 : 0
            r_moyen1 : 0
        
        @calcul_souplesse()
        
    calcul_souplesse:() ->
#définition des variables ----------------------------------------------------------------------------------------------------------------------
        nombredefixation = @bride_children[1].nombredefixation.get()
        pas = @bride_children[1].pas.get()
        partie = @bride_children[1]._partie.get()
        L_serree = @bride_children[1].L_serree.get()
        diametre_nominal = @bride_children[1].diametre_nominal.get()
        l0 = @bride_children[1].l0.get()
        l1 = @bride_children[1].l1.get()
        n = @bride_children[1].n.get()
        h_plaque1 = @bride_children[1].h_plaque1.get()
        D_int_plaque1 = @bride_children[1].D_int_plaque1.get()
        D_ext_plaque1 = @bride_children[1].D_ext_plaque1.get()
        D_int_plaque2 = @bride_children[1].D_int_plaque2.get()
        D_ext_plaque2 = @bride_children[1].D_ext_plaque2.get()
        di = @bride_children[1].di.get()
        dt = @bride_children[1].dt.get()
        Da = @bride_children[1].Da.get()
        h_plaque2 = @bride_children[1].h_plaque2.get()
        E_bride_sup = @bride_children[1].E_bride_sup.get()
        nu_bride_sup = @bride_children[1].nu_bride_sup.get()
        E_bride_inf = @bride_children[1].E_bride_inf.get()
        nu_bride_inf = @bride_children[1].nu_bride_inf.get()
        alpha_tete_boulon = @bride_children[2].alpha_tete_boulon.get()
        alpha_GM_boulon = @bride_children[2].alpha_GM_boulon.get()
        coeff_pas = @bride_children[2].coeff_pas.get()
        gamma = @bride_children[2].gamma.get()


#fonction issues du fichier matlab ----------------------------------------------------------------------------------------------------------------
        factrepart = 1 / gamma
        
#       Choix du type de la variable suivant le type de fixations       
        A = alpha_tete_boulon + 0
        B = alpha_GM_boulon + 0
        A0 = Math.PI * diametre_nominal * diametre_nominal / 4
        I0 = Math.PI * diametre_nominal * diametre_nominal * diametre_nominal * diametre_nominal / 64
        dsr = diametre_nominal - coeff_pas * pas        
        Asr = Math.PI * dsr * dsr / 4
        Isr = Math.PI * dsr * dsr * dsr * dsr / 64
        ds = []
        As = []
        Is = []
        
        
        
        for i in [ 1 .. n ]
            if partie[i - 1].filetage = 1
                v = (partie[i - 1].diametre - coeff_pas * pas)
                ds.push v
            else
                v = partie[i - 1].diametre
                ds.push v 
                
            
            t = Math.PI * ds[i - 1] * ds[i - 1] / 4
            As.push t
            
            t2 = Math.PI * ds[i - 1] * ds[i - 1] * ds[i - 1] * ds[i - 1] / 64
            Is.push t2
            
        if n = 1
            sumsoup = 0
            suminertie = 0
            @Ae.set L_serree / ( ( l0 + A * diametre_nominal ) / A0 + ( l1 + B * diametre_nominal ) / Asr )
            @Ie.set L_serree / ( l0 / I0 + l1 / Isr )
        else
            sumsoup = 0
            suminertie = 0
            for i in [ 1 .. n ]
                sumsoup = sumsoup + partie[i - 1].longueur / As[i - 1]
                suminertie = suminertie + partie[i - 1].longueur / Is[i - 1]
            @Ae.set L_serree / ( sumsoup + A * diametre_nominal / A0 + B * diametre_nominal / Asr )
            @Ie.set L_serree / suminertie
        
        @Angle_sect.set 2 * Math.PI / nombredefixation
        D_int_plaque_contact = Math.max( D_int_plaque1, D_int_plaque2 )
        D_ext_plaque_contact = Math.min( D_ext_plaque1, D_ext_plaque2 )
        
        H_serree = h_plaque1 + h_plaque2
        
        
        brideICA_souplesse_LGMT_1 = new BrideICASouplesseLGMT
            D_ext_plaque_contact : D_ext_plaque_contact
            D_int_plaque_contact : D_int_plaque_contact
            dt : dt
            di : di
            Da : Da
            Angle_sect : @Angle_sect
            H_serree : H_serree
        @sptotale.set H_serree / ( ( E_bride_sup + E_bride_inf ) * 0.5 * brideICA_souplesse_LGMT_1.Ap_support )
         
        brideICA_souplesse_LGMT_2 = new BrideICASouplesseLGMT
            D_ext_plaque_contact : D_ext_plaque_contact
            D_int_plaque_contact : D_int_plaque_contact
            dt : dt
            di : di
            Da : Da
            Angle_sect : @Angle_sect
            H_serree : h_plaque1 * 2
        AP_1 = brideICA_souplesse_LGMT_2.Ap_support.get()
        @r_moyen1.set brideICA_souplesse_LGMT_2.R_tube.get()
        sp_plaque1 = H_serree / ( E_bride_sup * AP_1 )
        
        brideICA_souplesse_LGMT_3 = new BrideICASouplesseLGMT
            D_ext_plaque_contact : D_ext_plaque_contact
            D_int_plaque_contact : D_int_plaque_contact
            dt : dt
            di : di
            Da : Da
            Angle_sect : @Angle_sect
            H_serree : h_plaque2 * 2
        AP_2 = brideICA_souplesse_LGMT_3.Ap_support.get()
        @r_moyen2.set brideICA_souplesse_LGMT_3.R_tube.get()
        sp_plaque2 = H_serree / ( E_bride_sup * AP_2 )
