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
class IssimSoftPageData extends TreeItem
    constructor: ( params = {}) ->
        super()

        @_name._set if params.name? then params.name else "Name" 
            
        @add_attr
            # tree
            display_big_logo : if params.display_big_logo? then params.display_big_logo else true
            project_name : if params.project_name? then params.project_name else "Project name"
            demo_application : if params.demo_application? then params.demo_application else undefined
            balise_logo : '#presentation'
            
              
            menu_background : "#ececec "
              
            backgroundColor :
                first : "#ececec"
                second : "#ffffff"
                third : "#ececec"
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
            
        if @demo_application?
          eval "var app = new #{ @demo_application };"
          @demo_app = app
        
        @run_test_2()
    
    
    add_menu_item: () ->
    
#         menu = new SitePartItem 
#                 name : 'menu'
#                 type : 'menu'
#                 src  : "img/Carab.png"
#                 background : @backgroundColor.first
#         @add_child menu
#        
#             
#         #ajout de bouton au menu------------------------------------------------------------------------------------
#         logo = new MenuCentralButtonItem '#presentation', "img/logo_spinalcom_120.png"
#         
#         bm0 = new MenuButtonItem "Présentation", '#presentation'
#             color: @textColor.highlight
#         bm1 = new MenuButtonItem "Consortium", '#consortium'
#             color: @textColor.highlight
#         bm2 = new MenuButtonItem "Work packages", '#work_packages'
#             color: @textColor.highlight
#         bm3 = new MenuButtonItem "News", '#news'
#             color: @textColor.highlight
#         bm4 = new MenuButtonItem "Softhub", "#softhub"
#             color: @textColor.highlight
#         
       
# #         
#         menu.add_child logo
#         menu.add_child bm0
#         menu.add_child bm1
#         menu.add_child bm2
#         menu.add_child bm3
#         menu.add_child bm4
# #         menu.add_child link
        
    
        menu = new SitePartItem 
                name : 'menu'
                type : 'menu'
#                 src : "img/Carab.png"
                display_big_logo : @display_big_logo.get()
                background : @backgroundColor.third
        @add_child menu
        
        #ajout de bouton au menu------------------------------------------------------------------------------------
#         logo = new MenuLogoItem "img/Carab.png", 'index.html'
#         big_logo = new SiteImageItem
#             src : "img/CARAB.png"
        bm0 = new MenuButtonItem "Demo", '#demo'
        bm1 = new MenuButtonItem "Video", '#video'
        bm2 = new MenuButtonItem "Publications", '#publication'
        bm3 = new MenuButtonItem "Tutorial", '#tutorial'
        bm4 = new MenuButtonItem "Editor", '#editor'
        link = new MenuLinkItem 
            name: "CARAB site ->" 
            balise: 'index.html'
            color: @textColor.highlight
#         bm5 = new MenuButtonItem "CARAB", 'http://localhost:8888/CARAB.html'
        
#         menu.add_child logo
        menu.add_child link
        menu.add_child bm0
#         menu.add_child bm1
#         menu.add_child bm2
#         menu.add_child bm3
#         menu.add_child bm4

#         menu.add_child bm5
        if @demo_app.video_link? then menu.add_child bm1
        if @demo_app.publication_link? then menu.add_child bm2
        if @demo_app.tutorial_link? then menu.add_child bm3
        if @demo_app.editor_info? then menu.add_child bm4
        
    
    
    add_demo_item: () ->
        demo = new SitePartItem 
                name : 'Online demo for ' + @demo_app.txt.get() + " / " + @demo_app.edited_by.get()
                type : 'text'
                balise : 'demo'
                title : true
                separator  : true
                background : @backgroundColor.third
                color : @textColor.first
        @add_child demo
        
        demo_window = new IFrameItem
            src : "softdemo.html#" + @demo_application
        demo.add_child demo_window 
        
        demo_window_text = new SiteTextItem
            txt: 'This online demo is provided by is-sim. All the data used and loaded 
                in this demo are public and will be saved in the archive. '
            fontSize: "13px"
            textAlign: "center"
        demo.add_child demo_window_text 
        
        demo_window_link = new SiteTextItem
            txt: 'full screen demo ->'
            fontSize: "17px"
            textAlign: "center"
            balise: "softdemo.html#" + @demo_application 
            fontFamily: "'Indie Flower', sans-serif"
            cursor: "pointer"
        demo.add_child demo_window_link 
        
        
    add_video_item: () ->
        video = new SitePartItem 
                name : 'Video'
                type : 'text'
                balise : 'video'
                title : true
                separator  : true
                background : @backgroundColor.third
        @add_child video
        
        video_window = new SiteTextItem
            name: 'pyramide'
            txt: @demo_app.video_link.get()
            fontSize: "18px"
            textAlign: "center"
        video.add_child video_window 
        
        
    add_publication_item: () ->
        publication = new SitePartItem 
                name : 'Publication'
                type : 'text'
                balise : 'publication'
                title : true
                separator  : true
                background : @backgroundColor.third
        @add_child publication
        
        publication_window = new SiteTextItem
            name: 'pyramide'
            txt: @demo_app.publication_link.get()
            fontSize: "18px"
            textAlign: "center"
        publication.add_child publication_window 
        
        
    
    run_test_2: () ->
        #parts------------------
#         @add_presentation_item()
        @add_demo_item()
        console.log @demo_app.video_link
        if @demo_app.video_link?
            @add_video_item()
        if @demo_app.publication_link?
            @add_publication_item()
        #menu--------------------
        @add_menu_item()