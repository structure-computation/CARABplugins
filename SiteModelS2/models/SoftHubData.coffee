# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



#
class SoftHubData extends TreeItem
    constructor: ( params = {}) ->
        super()

        @_name._set if params.name? then params.name else "Name" 
            
        @add_attr
            # tree
            project_name : if params.project_name? then params.project_name else "Project name"
            balise_logo : '#presentation'
            backgroundColor :
                first : "#262626"
                second : "#ffffff"
                separator : "#e6e6e6"
                highlight : "#4dbce9"
                specific : "transparent url( 'img/MoucetiBackgroud.png' ) center top repeat"
                
            textColor :
                first : "#f6f6f6"
                second : "#262626"
                highlight : "#4dbce9"
                
            lineColor :
                first : "1px solid #f6f6f6 "
                second : "1px solid #262626 "
                highlight : "1px solid #4dbce9 "
            
        
        @run_test_2()
    
    
    run_test: () ->
        #ajout de parts ----------------------------
        menu = new SitePartItem 
                name : 'menu'
                type : 'menu'
        @add_child menu

        presentation = new SitePartItem 
                name : 'Présentation'
                type : 'illustratedText'
                balise : 'presentation'
                title : false
                separator  : false
                background : @backgroundColor.specific
        @add_child presentation
        
        soft_list = new SitePartItem
                name : 'soft list'
                type : 'stamps'
                balise : 'soft_list'
        @add_child soft_list
      
    
        #ajout de bouton au menu---------------
        bm0 = new MenuButtonItem "présentation", '#presentation'
        bm1 = new MenuButtonItem "soft list", '#soft_list'
        menu.add_child bm0
        menu.add_child bm1
         
        #ajout de la presentation---------------
        pres = new IllustratedTextItem
            name: 'presentation DICCIT HUB'
            src: 'img/bigDICCITlogo.png'
            width: '400px'
            txt: "DICCIT HUB provide you the latest demo for software development realized in association with DICCIT research program"
        presentation.add_child pres
        
        #test ajout d'applications--------------- 
        for i in [0..10]
            soft = new CorrelationAppItem
            soft_list.add_child soft
#         @add_soft test_soft


    add_menu_item: () ->
        menu = new SitePartItem 
                name : 'menu'
                type : 'menu'
        @add_child menu
        
        #ajout de bouton au menu------------------------------------------------------------------------------------
        bm0 = new MenuButtonItem "Présentation", '#presentation'
        bm1 = new MenuButtonItem "Consortium", '#consortium'
        bm2 = new MenuButtonItem "Work packages", '#work_packages'
        bm3 = new MenuButtonItem "News", '#news'
        bm4 = new MenuButtonItem "Softhub", "#softhub"
        menu.add_child bm0
        menu.add_child bm1
        menu.add_child bm2
        menu.add_child bm3
        menu.add_child bm4
        
        
    add_presentation_item: () ->
        presentation = new SitePartItem 
                name : 'Présentation'
                type : 'illustratedText'
                balise : 'presentation'
                title : false
                separator  : false
                background : @backgroundColor.specific
        @add_child presentation
        
        objectifs = new SitePartItem 
                name : 'Objectifs'
                type : 'illustratedText'
                balise : 'objectifs'
        @add_child objectifs
        
        #ajout de la presentation---------------
        pres = new IllustratedTextItem
            name: 'presentation DICCIT HUB'
            src: 'img/bigDICCITlogo.png'
            width: '400px'
            txt: "<b>D</b>igital <b>I</b>mage <b>C</b>orrelation for interfacing test and <br>
              simulation of materials and structures with dedicated <br>
              <b>C</b>omparison and <b>I</b>dentification <b>T</b>ools"
        presentation.add_child pres
        
        obj = new IllustratedTextItem
            name: 'pyramide'
            src: 'img/pyramide_DICCIT.png'
            width: '400px'
            fontSize: "18px"
            textAlign: "justify"
            txt: "Les mesures de champs cinématiques par corrélation d’images en tant que moyen métrologiquement quantitatif sont un
                          candidat encore sous exploité industriellement pour répondre à la mise en place effective du Virtual Structural Testing
                          dans le domaine de l’analyse structurale (dimensionnement, validation, surveillance...).
                          L’offre actuelle est décevante au regard du potentiel de cette technologie. Les résultats ne se traduisent qu’en
                          cartographies colorées et qualitatives. L’ambition de DICCIT est de coupler ce type de mesure à une démarche
                          métrologique en amont, et à une plateforme de data fusion en aval permettant le dialogue entre les données mesurées
                          et simulées provenant d’un calcul numérique. Il sera alors possible d’y intégrer des outils d’analyse spécifiques
                          d’identification de paramètres pour ne citer que cet exemple et d’étendre cette technologie à d’autres cas d’applications."
        objectifs.add_child obj
        
    add_consortium_item: () ->
        #consortium-----
        consortium = new SitePartItem 
                name : 'Consortium'
                type : 'column'
                balise : 'consortium'
                separator  : false
        @add_child consortium
        
        financeurs = new SitePartItem 
                name : 'Financeurs'
                type : 'column'
                balise : 'financeurs'
        @add_child financeurs
        
        #ajout du consortium---------------
        cons_col_1 = new SitePartItem 
              type : "image"
        consortium.add_child cons_col_1    
              
        cons_col_2 = new SitePartItem
              type : "image"
        consortium.add_child cons_col_2    
              
        cons_col_3 = new SitePartItem
              type : "image"
        consortium.add_child cons_col_3
              
        cons_col_4 = new SitePartItem
              type : "image"
        consortium.add_child cons_col_4
              
        
        cons_col_1.add_child new SiteImageItem
            name : "logo Airbus"
            src  :  "img/logo_Airbus.png"
            width : "160"
            
        cons_col_1.add_child new SiteImageItem
            name : "logo Safran MBD"
            src  :  "img/logo_SAFRAN_MBD.png"
            width : "160"
            
        cons_col_1.add_child new SiteImageItem
            name : "logo Safran Snecma"
            src  :  "img/logo_SAFRAN_snecma.png"
            width : "160"
            
        cons_col_2.add_child new SiteImageItem
            name : "logo Scrome"
            src  :  "img/logo_scrome.png"
            width : "160"   
            
        cons_col_2.add_child new SiteImageItem
            name : "logo Sopemea"
            src  :  "img/logo_sopemea.png"
            width : "160"
            
        cons_col_3.add_child new SiteImageItem
            name : "logo LMT"
            src  :  "img/logo_LMT.png"
            width : "160"   
            
        cons_col_3.add_child new SiteImageItem
            name : "logo Afnor"
            src  :  "img/logo_afnor.png"
            width : "160"
            
        cons_col_4.add_child new SiteImageItem
            name : "logo SC"
            src  :  "img/Logo_StructureComputation_160.png"
            width : "160"   
            
        cons_col_4.add_child new SiteImageItem
            name : "logo Stereolabs"
            src  :  "img/logo_stereolabs.png"
            width : "160"
            
        cons_col_4.add_child new SiteImageItem
            name : "logo RFF"
            src  :  "img/logo_RFF.png"
            width : "160"
        
        #ajout des financeurs---------------
        fin_col_1 = new SitePartItem 
              type : "image"
        financeurs.add_child fin_col_1    
              
        fin_col_2 = new SitePartItem
              type : "image"
        financeurs.add_child fin_col_2    
              
        fin_col_3 = new SitePartItem
              type : "image"
        financeurs.add_child fin_col_3
              
        fin_col_4 = new SitePartItem
              type : "image"
        financeurs.add_child fin_col_4
              
        
        fin_col_1.add_child new SiteImageItem
            name : "logo essone"
            src  :  "img/logo_ESSONE.png"
            width : "160"
            
        fin_col_2.add_child new SiteImageItem
            name : "logo BPI"
            src  :  "img/logo_BPI_France.png"
            width : "160"
            margin : "35 0 0 0"
            
        fin_col_3.add_child new SiteImageItem
            name : "logo Astech"
            src  :  "img/logo_astech.png"
            width : "160"
            
        fin_col_4.add_child new SiteImageItem
            name : "logo Systematic"
            src  :  "img/logo_systematic.png"
            width : "160" 
            margin : "40 0 0 0"
    
    add_work_packages_item: () ->
        #work packages-----
        illustration = new SitePartItem 
                name : 'Work packages'
                type : 'illustratedText'
                balise : 'work_packages'
                separator  : false
        @add_child illustration
        
        WP = new SitePartItem 
                name : 'WP'
                type : 'services'
                balise : 'WP'
                title : false 
        @add_child WP
        
        #ajout ddes workpackages--------------- 
        WP_illustration = new IllustratedTextItem
            name: 'illustration work packages'
            src: 'img/schema_WP.png'
            width: '700px'
            txt: ""
        illustration.add_child WP_illustration
        
        WP_1 = new SiteServiceItem
            background : @backgroundColor.highlight
            slogan : 'WP1'
            title : "MANAGEMENT, DISSEMINATION"
            description : "<b> Participants : tout le consortium </b> <br>
                <ul type='circle'>
                <li>  <b> Accord de consoritum : </b> gestion de relation avec les juristes.  </li>
                <li>  <b> Conduite du projet : </b> annimation et déroulement conformément à la feuille de route. </li>
                <li>  <b> Dissémination : </b> communication, article de recherche, organisation de formations... </li>
                </ul>"
                
        WP_2 = new SiteServiceItem
            background : @backgroundColor.highlight
            slogan : 'WP2'
            title : "MESURES ET TECHNOLOGIES"
            description : "<b> Participants : SCROME, AIRBUS, STEREOLABS, LMT-CACHAN </b> <br>
                <ul type='circle'>
                <li>  <b> Métrologie et normalisation : </b> stratégie d’évaluation métrologique « in-situ » intégrant l’ensemble de la chaîne de mesure.  </li>
                <li>  <b> Nouveaux capteurs optiques : </b> nouvelle architecture LUIMOP adaptée au support expérimental. </li>
                <li>  <b> Reconstruction 3D : </b> méthodologies de calibration faible à partir d’images stéréoscopiques. </li>
                </ul>"
                
        WP_3 = new SiteServiceItem
            background : @backgroundColor.highlight
            slogan : 'WP3'
            title : "ANALYSE ET METHODOLOGIE"
            description : "<b> Participants : SNECMA, MESSIER, LMT-CACHAN, AIRBUS, AFNOR </b> <br>
                <ul type='circle'>
                <li>  <b> Procédure d'identification : </b> méthode de recalage de modèles éléments finis.  </li>
                <li>  <b> Modèle élastoplastique : </b> développement de la méthode d'identification et adaptation au cas industriel. </li>
                <li>  <b> Modèle d'endomagement : </b> développement de la méthode d'identification et adaptation au cas industriel. </li>
                <li>  <b> Extention : </b> adaptation des méthodes précédente à l'échelle structurale. </li>
                </ul>"
                
        WP_4 = new SiteServiceItem
            background : @backgroundColor.highlight
            slogan : 'WP4'
            title : "IMPLEMENTATION LOGICIEL"
            description : "<b> Participants : STRUCTURE COMPUTATION, LMT, AIRBUS, SNECMA, MESSIER  </b> <br>
                <ul type='circle'>
                <li>  <b> Transfert de méthodes : </b> valorisation des résultat du WP3.  </li>
                <li>  <b> Développement logiciels : </b> développement de la plate-forme DataFusion. </li>
                <li>  <b> Plate-forme web : </b> difusion facilité des logiciels en cloud computing </li>
                </ul>"
                
        WP_5 = new SiteServiceItem
            background : @backgroundColor.highlight
            slogan : 'WP5'
            title : "ESSAIS ET DEMONSTRATIONS"
            description : "<b> Participants : tout le consortium </b> <br>
                <ul type='circle'>
                <li>  <b> Essais d'évaluation : </b> identification les aléas, difficultés, spécificités liées aux essais d'identification. </li>
                <li>  <b> Essais d'identification : </b> comparaison avec les valeurs mesurées par des techniques conventionnelles. </li>
                <li>  <b> Démonstrateurs : </b> démontrer la performance des techniques de mesures de champs cinématiques par corrélation d’images. </li>
                </ul>"
            
        
        WP.add_child WP_1
        WP.add_child WP_2
        WP.add_child WP_3
        WP.add_child WP_4
        WP.add_child WP_5
        
    
    add_news_item: () ->
        #news-----
        news = new SitePartItem 
                name : 'News'
                type : 'news'
                balise : 'news'
        @add_child news
        
        #ajout des news--------------- 
        
        news_1 = new SiteNewsItem
            date : '28-07-2014'
            title : "mise en ligne de la plate-forme web DICCIT"
            description : "La première version de la plate-forme web DICCIT est en ligne. 
            elle comprend ce site, un journal de démonstration en ligne public ainsi qu'un espace privé pour les membres du consortium."
        news.add_child news_1
        
        
    add_softlist_item: () ->
        #demohub-----
        softlist = new SitePartItem
                name : 'Softhub'
                type : 'stamps'
                balise : "softhub"
                background : @backgroundColor.first
                textColor : @textColor.first
                separator  : true
                
        @add_child softlist
        
        #ajout d'applications--------------- 
        soft = new CorrelationAppItem
        softlist.add_child soft
#         for i in [0..10]
#             soft = new CorrelationAppItem
#             softlist.add_child soft
#         @add_soft test_soft
    
    
    run_test_2: () ->
        #parts------------------
        @add_presentation_item()
        @add_consortium_item()
        @add_work_packages_item()
        @add_news_item()
        @add_softlist_item()
        
        #menu--------------------
        @add_menu_item()
        
        
        
        
      
    
        
        
         
        
        
        
        
            
        
        
        
        
        
        
        
        
        
            
    
            