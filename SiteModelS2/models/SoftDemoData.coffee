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
class SoftDemoData extends TreeItem
    constructor: ( params = {}) ->
        super()

        @_name._set if params.name? then params.name else "Name" 
            
        @add_attr
            # tree
            project_name : if params.project_name? then params.project_name else "Project name"
            demo_application : if params.demo_application? then params.demo_application else undefined
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
            
        if @demo_application?
          eval "var app = new #{ @demo_application };"
          @demo_app = app
        
        
        @run_test_2()
    

    add_menu_item: () ->
        menu = new SitePartItem 
                name : 'menu'
                type : 'menu'
        @add_child menu
        
        #ajout de bouton au menu------------------------------------------------------------------------------------
        bm0 = new MenuButtonItem "Demo", '#demo'
        bm1 = new MenuButtonItem "Tutorial", '#tutorial'
        bm2 = new MenuButtonItem "Vidéo", '#video'
        bm3 = new MenuButtonItem "Editor", '#editor'
        menu.add_child bm0
        menu.add_child bm1
        menu.add_child bm2
        menu.add_child bm3
        
        
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
    
    
    add_demo_item: () ->
        demo = new SitePartItem 
                name : 'Demo'
                type : 'text'
                balise : 'demo'
                title : true
                separator  : true
                background : @backgroundColor.first
        @add_child demo
        
        demo_window = new SiteTextItem
            name: 'pyramide'
            txt: '<iframe src="http://localhost:8888/journal_demo_theme.html#' + @demo_application  + '" width="1100" height="600" frameborder="0" style="border:0"></iframe>'
            fontSize: "18px"
            textAlign: "center"
        demo.add_child demo_window 
        
        
    
    run_test_2: () ->
        #parts------------------
#         @add_presentation_item()
        @add_demo_item()
        
        #menu--------------------
        @add_menu_item()
        
        
        
        
      
    
        
        
         
        
        
        
        
            
        
        
        
        
        
        
        
        
        
            
    
            