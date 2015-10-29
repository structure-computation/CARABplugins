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
class PhoneMenuView extends UnitSiteView
    constructor: ( @site_item, full_menu, menu, full_cb, cb) ->
        super @site_item
         
        full_menu.style.padding= "5px 0 5px 0"
        menu.style.height = 35   
        
        full_menu.style.background = "transparent"
        menu.style.background = "transparent"
            
        

        #ajout du bouton de menu sur la droite
        div_buton_menu =  new_dom_element
            parentNode  : menu
            nodeName    : "img"
            id          : 'div_buton_menu'
            src         : "img/icon_menu_60.png"
            width       : 35
            style :
                margin  : "0 10 0 0"
                cssFloat : "right"
        div_buton_menu.onmouseover = ( evt ) =>
            div_buton_menu.style.cursor = "pointer"
            $("#div_menu_deroulant").show()
        #ajout du bouton de logo sur la gauche
        div_buton_top_menu =  new_dom_element
            parentNode  : menu
            nodeName    : "img"
            id          : 'div_top_buton_menu'
            src         : "img/logo_spinalcom_120_rond.png"
            width       : 35
            style :
                margin  : "0 10 0 0"
                cssFloat : "right"   
            onclick: ( evt ) ->
                $("#div_menu_deroulant").hide()
                $(document.body).animate
                    scrollTop:   0
                    1000
        div_buton_top_menu.onmouseover = ( evt ) =>
            div_buton_top_menu.style.cursor = "pointer"
        
        
        #ajout du menu déroulant
        div_menu_deroulant =  new_dom_element
            parentNode  : menu
            nodeName    : "div"
            id          : 'div_menu_deroulant'
            style :
                position : "fixed"
                top      : 0
                right    : 0
                width    : "100%"
                margin   : "0 0 0 0"
                background : "#262626"
            onmouseover : ( evt ) =>
                $("#div_menu_deroulant").show()
            onmouseout : ( evt ) =>
                $("#div_menu_deroulant").hide()

        $("#div_menu_deroulant").hide()
        
        
#         #centrage du menu   
        for bm in @site_item._children
            if bm instanceof MenuButtonItem
                button_cont = new_dom_element
                    parentNode : div_menu_deroulant
                    nodeName   : "div" 
                    balise     : bm.balise.get()
                    style      :
                        width  : "100%"
                        height : "40px"
                        borderBottom : "1px solid #fcfcfc"
                    onclick: ( evt ) ->
                        $("#div_menu_deroulant").hide()
                        $(document.body).animate
                            scrollTop:   $(@balise).offset().top - 30
                            1000
                    onmouseover : ( evt ) =>
                        style.cursor = "pointer"
                  
                button = new_dom_element
                    parentNode : button_cont
                    nodeName   : "div" 
                    className  : "indexMenuButton"
                    txt        : bm.txt.get()
                    style      :
                        textAlign : "center"
                        width  : "100%"
                        fontFamily : "'Indie Flower', sans-serif"
                        margin : "5 0 0 0"
                        color  : "#ececec"
                   
        button_cont = new_dom_element
            parentNode : div_menu_deroulant
            nodeName   : "div" 
            style      :
                width  : "100%"
                height : "40px"
                background : "#5ba1e3"
                borderBottom : "1px solid #fcfcfc"
            onclick: ( evt ) ->
                $("#div_menu_deroulant").hide()
            onmouseover : ( evt ) =>
                style.cursor = "pointer"
          
        button = new_dom_element
            parentNode : button_cont
            nodeName   : "div" 
            className  : "indexMenuButton"
            txt        : "Fermer"
            style      :
                fontFamily : "'Indie Flower', sans-serif"
                textAlign : "center"
                width  : "100%"
                padding : "5 0 0 0"
                color  : "#ececec"