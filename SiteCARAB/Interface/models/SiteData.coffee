# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2015 Jérémie Bellec


#
class SiteData extends TreeItem
    constructor: ( params = {}) ->
        super()

        @_name._set if params.name? then params.name else "Name" 
            
        @add_attr
            # tree
            display_big_logo : if params.display_big_logo? then params.display_big_logo else true
            project_name : if params.project_name? then params.project_name else "Project name"
            balise_logo : '#presentation'
            
            menu_background : "#ececec " #"#262626 "   "#ffffff" #
              
            backgroundColor :
                first : "#ececec"
                second : "#ffffff"
                separator : "#e6e6e6"
                highlight : "#4dbce9"
                specific : "transparent url( 'img/MoucetiBackgroud.png' ) center top repeat"
                
            textColor :
                first : "#262626"
                second : "#262626"
                highlight : "#4dbce9"
                
            lineColor :
                first : "1px solid #262626 "
                second : "1px solid #262626 "
                highlight : "1px solid #4dbce9 "
     
            src: "img/Carab.png"
            
        
        @run_test_2()
    

    add_menu_item: () ->
        menu = new SitePartItem 
                name : 'menu'
                type : 'menu'
                src  : "img/Carab.png"
                background : @backgroundColor.first
        @add_child menu
       
            
        #ajout de bouton au menu------------------------------------------------------------------------------------
        logo = new MenuCentralButtonItem '#presentation', "img/logo_spinalcom_120.png"
        
        bm0 = new MenuButtonItem "Présentation", '#presentation'
        bm1 = new MenuButtonItem "Consortium", '#consortium'
        bm2 = new MenuButtonItem "Work packages", '#work_packages'
        bm3 = new MenuButtonItem "News", '#news'
        bm4 = new MenuButtonItem "Softhub", "#softhub"
        
        link = new MenuLinkItem 
            name: "MECASIF Desk ->" 
            balise: 'login.html'
            color: @textColor.highlight
        
        menu.add_child logo
        menu.add_child bm0
        menu.add_child bm1
        menu.add_child bm2
        menu.add_child bm3
        menu.add_child bm4
        #menu.add_child link
        
        
        
    add_presentation_item: () ->
        presentation = new SitePartItem 
                name : 'Présentation'
                balise : 'presentation'
                title : false
                separator  : false
                background : @backgroundColor.first
        @add_child presentation
        
        pres = new SiteTextItem
            name: 'presentation CARAB'
            width: '400px'
            txt: "Conception Avancée Robuste pour les Assemblages Boulonnés"
            fontFamily : "'Indie Flower', sans-serif"
            fontSize : 40
            
        presentation.add_child pres
        
        objectifs = new SitePartItem 
                name : 'Objectifs'
                balise : 'objectifs'
                background : @backgroundColor.first
                separator  : false
        @add_child objectifs

#         obj = new SiteTextItem
#             name: 'pyramide'
#             fontSize: "18px"
#             textAlign: "center"
#             txt: ""
                        
        obj1 = new SiteTextItem
            name : 'pyramide1'
            fontSize : "18px"
            textAlign : "left"
            txt : "Les liaisons boulonnées sont des éléments omniprésents en mécanique afin d’assembler les différents modules d’une structure complexe. On peut dénombrer ainsi plus de 3 000 000 d’attaches sur A380, 50 000 sur un Rafale, 3 500 boulons sur un moteur de la gamme des CFM56 et une dizaine de vis critiques sur une vanne de prélèvement d’air.

<br><br>Bien qu’a priori bien maîtrisée, cette méthode de serrage est la source d’incertitude et de difficultés tout au long de la vie des produits aéronautiques (conception, montage, exploitation…).

<br><br>Le projet CARAB vise à répondre à ces difficultés et aux enjeux de conception actuels des assemblages boulonnés :<br>
                <ul>
                <li>  Concevoir à Coûts et Masse Objectifs  (CCMO) sans prendre de risques  </li>
                <li>  Pouvoir disposer de protocoles et de moyens d’essais performants </li>
                <li>  Enrichir les bases de connaissances sur cette thématique en alliant des compétences de différentes disciplines : tribologie, essais physiques, modélisations numériques, logiciels avancés de conception éléments finis... </li>
                </ul>"
        
#         objectifs.add_child obj
        objectifs.add_child obj1
        
        
#         logo = new IllustratedTextItem
#             name: 'presentation'
#             src: 'img/presentation.png'
#             width: '400px'
#             txt: ""
#         presentation.add_child logo
        
        
     add_consortium_item: () ->
        #consortium-----
        consortium = new SitePartItem 
                name : 'Consortium'
#                 type : 'column'
                balise : 'consortium'
                background : @backgroundColor.first
                separator  : false
        @add_child consortium
        
        #ajout du consortium---------------
#         cons_col_1 = new SitePartItem 
#         consortium.add_child cons_col_1    
              
#         cons_col_2 = new SitePartItem
#         consortium.add_child cons_col_2    
              
#         cons_col_3 = new SitePartItem
#         consortium.add_child cons_col_3
              
#         cons_col_4 = new SitePartItem
#         consortium.add_child cons_col_4
              
        slider_item = new SliderItem
            nb_image : "5"
#             time_pause : "2000"
#             time_slide : "2000"
              
        slider_item.add_child new SiteImageItem
            name : "logo Samtech "
            src  :  "img/Logo_Samtech.png"
            width : "160"
        
        slider_item.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160"            
        
        slider_item.add_child new SiteImageItem
            name : "logo Institut Clément Ader"
            src  :  "img/Logo_ICA.jpg"
            width : "160"
              
        slider_item.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160" 
        
        slider_item.add_child new SiteImageItem
            name : "logo Mecano ID"
            src  :  "img/Logo_mecano.png"
            width : "160"
            
         slider_item.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160"    
            
        slider_item.add_child new SiteImageItem
            name : "logo CADlm"
            src  :  "img/Logo_Cadlm.png"
            width : "160"
            
        slider_item.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160"     
            
        slider_item.add_child new SiteImageItem
            name : "logo LaMCoS"
            src  :  "img/Logo_Lamcos.png"
            width : "160"
              
        slider_item.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160"       
              
        slider_item.add_child new SiteImageItem
            name : "logo LMT Cachan"
            src  :  "img/Logo_Lmt.png"
            width : "160"

        slider_item.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160" 
        
        slider_item.add_child new SiteImageItem
            name : "logo Cetim"
            src  :  "img/Logo_Cetim.png"
            width : "160"  
        
        slider_item.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160" 
        
        slider_item.add_child new SiteImageItem
            name : "logo Lisi Aerospace"
            src  :  "img/Logo_Aerospace.gif"
            width : "160" 
        
        slider_item.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160" 
              
        consortium.add_child slider_item
        
        slider_item2 = new SliderItem
            nb_image : "5"
#             time_slide : "2000"
#             time_pause : "2000"  

        slider_item2.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160" 
              
        slider_item2.add_child new SiteImageItem
            name : "logo Liebherr"
            src  :  "img/Logo_Liebherr.png"
            width : "160"
              
        slider_item2.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160"       
              
        slider_item2.add_child new SiteImageItem
            name : "logo Structure Computation"
            src  :  "img/Logo_StructureComputation_gris.png"
            width : "160"
              
        slider_item2.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160"       
                    
        slider_item2.add_child new SiteImageItem
            name : "logo Safran"
            src  : "img/Logo_Safran.png"
            width : "160"
        
        slider_item2.add_child new SiteImageItem
            name : "logo Transparent "
            src  :  "img/logo_transparent.png"
            width : "160" 
        
        slider_item2.add_child new SiteImageItem
            name : "logo Alyotech"
            src  :  "img/Logo_Alyotech.png"
            width : "160"
        
        
        consortium.add_child slider_item2
            
#         cons_col_4.add_child new SiteImageItem
#             name : "logo SC"
#             src  :  "img/Logo_StructureComputation_gris.png"
#             width : "160"   
#             
#         cons_col_4.add_child new SiteImageItem
#             name : "logo Scilab"
#             src  :  "img/logo_scilab.jpg"
#             width : "160"
#             
#         cons_col_4.add_child new SiteImageItem
#             name : "logo DPS"
#             src  :  "img/logo_dps.png"
#             width : "160"
        
        #ajout des financeurs---------------
        financeurs = new SitePartItem 
                name : 'Financeurs'
                type : 'column'
                balise : 'financeurs'
                background : @backgroundColor.first
                separator  : false
        @add_child financeurs
        
        
        fin_col_1 = new SitePartItem 
        financeurs.add_child fin_col_1    
              
        fin_col_2 = new SitePartItem
        financeurs.add_child fin_col_2    
              
#         fin_col_3 = new SitePartItem
#         financeurs.add_child fin_col_3
        
        fin_col_1.add_child new SiteImageItem
            name : "logo essone"
            src  :  "img/logo_ESSONE.png"
            width : "160"
            
        fin_col_2.add_child new SiteImageItem
            name : "logo BPI"
            src  :  "img/logo_BPI_France.png"
            width : "160"
            margin : "35 0 0 0"
        
#         fin_col_3.add_child new SiteImageItem
#             name : "logo BPI"
#             src  :  "img/logo_idf.png"
#             width : "160"
#             margin : "35 0 0 0"
        
        poles = new SitePartItem 
                name : 'Poles'
                type : 'column'
                balise : 'poles'
                background : @backgroundColor.first
                separator  : false
        @add_child poles
 
        po_col_1 = new SitePartItem 
        poles.add_child po_col_1    
              
        po_col_2 = new SitePartItem
        poles.add_child po_col_2    
        
        po_col_1.add_child new SiteImageItem
            name : "logo Astech"
            src  :  "img/logo_astech.png"
            width : "160"
            
        po_col_2.add_child new SiteImageItem
            name : "logo Systematic"
            src  :  "img/logo_systematic.png"
            width : "160" 
            margin : "40 0 0 0"


    add_work_packages_item: () ->
        #work packages-----
        illustration = new SitePartItem 
                name : 'Work packages'
                balise : 'work_packages'
                separator  : false
                background : @backgroundColor.first
        @add_child illustration
        
        WP = new SitePartItem 
                name : 'WP'
                balise : 'WP'
                title : false 
                separator  : false
                background : @backgroundColor.first
        @add_child WP
        
        #ajout ddes workpackages--------------- 
        WP_illustration = new IllustratedTextItem
            name: 'illustration work packages'
            src: 'img/schema_WP.png'
            width: '700px'
            txt: ""
        illustration.add_child WP_illustration
        
        WP_0 = new SiteServiceItem
            background : "transparent"
            src : "img/chiffre_0.png"
            width : 120
            height : 200
            slogan : ''
            title : "Conception des essais de bases (M1 – M6)"
            description : "<b> Pilote : Messier </b> <br>
                <ul type='circle'>
                <li>  Etat de l’art  </li>
                <li>  Définition des cas tests </li>
                <li>  Programme de modélisation et des essais </li>
                <li>  Spécification des modèles et des logiciels </li>
                </ul>"
                
        WP_1 = new SiteServiceItem
            background : "transparent"
            src : "img/chiffre_1.png"
            width : 120
            height : 200
            slogan : ''
            title : "« Virtual Testing » (M3 – M36) "
            description : "<b>  Pilote : Cadlm   </b> <br>
                <ul type='circle'>
                <li>  Méthodologie du Virtual Testing  </li>
                <li>  Reproduction virtuelle des essais physiques </li>
                <li>  Tribologie numérique </li>
                <li>  Recommandation de conception </li>
                </ul>"
                
        WP_2 = new SiteServiceItem
            background : "transparent"
            src : "img/chiffre_2.png"
            width : 120
            height : 200
            slogan : ''
            title : "Constitution de la base d’essais de référence (M3 – M30)"
            description : "<b> Pilote : Cetim </b> <br>
                <ul type='circle'>
                <li>  Essais de caractérisation des connecteurs  </li>
                <li>  Essais à une échelle réduites </li>
                <li>  Expertise tribologique </li>
                <li>  Essais à l’échelle 1 </li>
                </ul>"
                
        WP_3 = new SiteServiceItem
            background : "transparent"
            src : "img/chiffre_3.png"
            width : 120
            height : 200
            slogan : ''
            title : "Développement de nouvelles modélisations élémentaires (M3 – M30)"
            description : "<b> Pilote : LMT Cachan </b> <br>
                <ul type='circle'>
                <li>  Méthodes simplifiées </li>
                <li>  Connecteurs éléments finis </li>
                </ul>"
                
        WP_4 = new SiteServiceItem
            background : "transparent"
            src : "img/chiffre_4.png"
            width : 120
            height : 200
            slogan : ''
            title : "Intégration industrielle (M20 – M33)"
            description : "<b> Pilote : Samtech </b> <br>
                <ul type='circle'>
                <li>  Intégration d’outils d’assistance de prédimensionnement </li>
                <li>  Intégration des connecteurs et des méthodes numériques </li>
                </ul>"
                
        WP_5 = new SiteServiceItem
            background : "transparent"
            src : "img/chiffre_5.png"
            width : 120
            height : 200
            slogan : ''
            title : "Démonstration industrielle (M30 – M36)"
            description : "<b> Pilote : Turbomeca </b> <br>
                <ul type='circle'>
                <li>  Validation des maquettes </li>
                <li>  Validation des prototypes </li>
                </ul>"
                
        WP_6 = new SiteServiceItem
            background : "transparent"
            src : "img/chiffre_6.png"
            width : 120
            height : 200
            slogan : ''
            title : "Management (M1 – M36)"
            description : "<b> Piloe : Snecma </b> <br>
                La direction et la responsabilité du projet sont assurées par le porteur du projet, la société Snecma.  Un comité de pilotage composé d’un représentant de chacun des partenaires se réunira tous les semestres, en présence des financeurs et des pôles et des réunions techniques par SP seront organisées tous les trimestres. Le comité de pilotage sera en charge de valider les résultats acquis et de réorienter, si besoin est, le projet en fonction de ces acquis et des objectifs visés. </br>"
            
        WP.add_child WP_0
        WP.add_child WP_1
        WP.add_child WP_2
        WP.add_child WP_3
        WP.add_child WP_4
        WP.add_child WP_5
        WP.add_child WP_6
    
    add_news_item: () ->
        #news-----
        news = new SitePartItem 
                name : 'News'
                balise : 'news'
                background : @backgroundColor.first
                separator  : false
        @add_child news
        
        #ajout des news--------------- 
        
        news_1 = new SiteNewsItem
            date : '20-07-2015'
            title : "mise en ligne de la plate-forme web CARAB"
            description : "La première version de la plate-forme web CARAB est en ligne."
        news.add_child news_1
    
    
    add_softlist_item: () ->
        #demohub-----
        softlist_mecanical = new SitePartItem
                name : 'Softhub'
                balise : "softhub"
                stamps_title: "<b> CARAB related software </b>"  
                type : 'stamps'
                background : @backgroundColor.first
                color : @textColor.first
                highlight : @textColor.highlight
                ratio : 60
                separator  : false
                title: true
                
        @add_child softlist_mecanical
        

        softlist_mecanical.add_child new Plot3DDemoItem
        softlist_mecanical.add_child new BrideICA2DemoItem
    
    
#     add_contact_item: ()->
#         contact = new SitePartItem
#                 name : 'Contact'
#                 balise : "contact"
#                 background : @backgroundColor.first
#                 color : @textColor.first
#                 separator  : false       
#         @add_child contact
#         
#         contact.add_child new SiteTextItem
#             txt: "86 rue de Paris, 91400 Orsay, FRANCE"  
#             
#         contact.add_child new SiteTextItem
#             a: "mailto:contact@spinalcom.com"
#             txt: "<a href='mailto:contact@spinalcom.com'> send a mail </a> <br> <br>"  
#            
#         contact.add_child new IFrameItem 
#             width : 800
#             src: "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2633.484965886882!2d2.1946309000000097!3d48.696210899999976!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47e5d61facc30587%3A0xccaaa136fb1452e7!2s86+Rue+de+Paris!5e0!3m2!1sfr!2sfr!4v1404916614372"
#         
#         contact.add_child new SiteTextItem
#             txt: '<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2633.484965886882!2d2.1946309000000097!3d48.696210899999976!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47e5d61facc30587%3A0xccaaa136fb1452e7!2s86+Rue+de+Paris!5e0!3m2!1sfr!2sfr!4v1404916614372" width="900" height="450" frameborder="0" style="border:0"></iframe>'  

    run_test_2: () ->
        #parts------------------
        @add_presentation_item()
        @add_consortium_item()
        @add_work_packages_item()
        @add_news_item()
        @add_softlist_item()
#         @add_contact_item()
        
        #menu--------------------
        @add_menu_item()