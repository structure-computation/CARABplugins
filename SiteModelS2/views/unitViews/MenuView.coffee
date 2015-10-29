# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
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
class MenuView extends UnitSiteView
    constructor: ( @site_item, full_menu, menu, full_cb, cb) ->
        super @site_item
        
        
        menu.style.height = 35
        cb.style.height = 30
        full_cb.style.top    = 45
       
        
        centre_button = @site_item.detect_child ( x ) -> x instanceof MenuCentralButtonItem
        if centre_button?
            soft_hub_data = @soft_hub_data
            div_cb = new_dom_element
                parentNode : cb
                nodeName   : "div" 
                width      : "100px"                # largeur obligatoire pour être centré */ 
                textAlign  : "center"
                id         : "center_button"
                balise     : centre_button.balise.get()
                onclick: ( evt ) ->
                    $(document.body).animate
                        scrollTop:   0 #$(@balise).offset().top - 110
                        1000
                        

            width = cb.offsetWidth
            
            div_cb.style.marginLeft = (width - 60) / 2

            image = new_dom_element
                parentNode : div_cb
                nodeName  : "img"
                src       : centre_button.src.get()
                
            image.width = 60
            
            $("#center_button").hide()
        
        logo = @site_item.detect_child ( x ) -> x instanceof MenuLogoItem
        if logo?
            soft_hub_data = @soft_hub_data
            div_logo = new_dom_element
                parentNode : menu
                nodeName   : "div" 

            menu_presentation = new_dom_element
                parentNode : div_logo
                nodeName   : "img" 
                src        : logo.src.get()
                balise     : logo.balise.get()
                style       :
                    margin : "0 20 0 0"
                    cssFloat : "left"
                onclick: ( evt ) ->
                    window.location = @balise 
                    
        #centrage du menu   
        width_menu = menu.offsetWidth
        nb_button = 0
        for bm in @site_item._children
            if bm instanceof MenuButtonItem or bm instanceof MenuLinkItem 
                nb_button += 1
        
        width_button = (width_menu / nb_button) - 1.0

        
        
        
        if @site_item.display_big_logo.get()
            @div_logo_menu =  new_dom_element
                parentNode : menu
                nodeName  : "div"
                id: 'big_logo_menu'
                style :
                    width : "100%"
                    padding : "0 0 20 0"
                    textAlign : "center"
        
            big_logo = new SiteImageItem
                src : if @site_item.src? then @site_item.src else "img/bigSpinalComLogo_1.png"
                margin : "0 0 0 0"
                width  : "300"
            div_logo = new SiteImageView big_logo, @div_logo_menu
                

        for bm in @site_item._children
            if bm instanceof MenuButtonItem
                button = new_dom_element
                    parentNode : menu
                    nodeName   : "div" 
                    className  : "indexMenuButton"
                    txt        : bm.txt.get()
                    balise     : bm.balise.get()
                    onclick: ( evt ) ->
                        $(document.body).animate
                            scrollTop:   $(@balise).offset().top - 110
                            1000
#                 console.log "je passe dans le menu boutton"
                if bm.cssFloat? then button.style.cssFloat = bm.cssFloat
                if bm.color? then button.style.color = bm.color
                if bm.fontFamily? then button.style.fontFamily = bm.fontFamily
                if bm.fontSize? then button.style.fontSize = bm.fontSize
                
                button.style.width = width_button

        special_link = @site_item.detect_child ( x ) -> x instanceof MenuLinkItem
        if special_link?
            menu_login = new_dom_element
                parentNode : menu
                nodeName   : "div" 
                className  : "indexMenuButton"
                txt        : special_link.txt.get()
                balise     : special_link.balise.get()
                style : 
                    fontWeight : "bold"
                    fontSize   : "23px"
                    fontFamily: "'Indie Flower', sans-serif"
                onclick: ( evt ) ->
                    window.location = @balise 
                    
            menu_login.style.width = width_button
                    
            if special_link.color? then menu_login.style.color = special_link.color