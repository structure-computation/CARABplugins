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
class SiteServiceView extends UnitSiteView
    constructor: ( @site_item, @el, @viewstyle) ->
        super @site_item
        
        @elwidth = @el.offsetWidth
        
        service_editor = new_dom_element
            parentNode : @el
            nodeName   : "div" 
            style      :
                width      : "100%"
                cssFloat   : "left" 
                margin     : "10px 0px 10px 0"
                
        slogan_div = new_dom_element
            parentNode : service_editor
            nodeName   : "div"  
            style      :
                width      : if @site_item.width? then @site_item.width.get() else "160px"
                height     : if @site_item.height? then @site_item.height.get() else "160px"
                textAlign  : "center"
                fontWeight : "bold"
                fontSize   : "25px"
                color      : @site_item.color
                margin     : "0px 30px 0px 0"
                background : @site_item.background
                cssFloat   : "left"
        
        if @site_item.src?
            new_dom_element
                parentNode : slogan_div
                nodeName   : "img"  
                src        : @site_item.src.get()
                width      : if @site_item.width? then @site_item.width.get() else "160px"
#                 style      :  
#                     margin  : "50px 0px 0px 0"
        else
            slogan_txt = new_dom_element
                parentNode : slogan_div
                nodeName   : "div"  
                txt        : if @site_item.slogan? then @site_item.slogan.get() else ""
                style      :  
                    width   : if @site_item.width? then @site_item.width.get() else "160px"
                    margin  : "50px 0px 0px 0"
    #                 border     : "1px solid grey"
    
        if @viewstyle == "phone"
            slogan_div.style.width = "100%"
            slogan_div.style.height = "100px"
            slogan_div.style.height = if @site_item.width? then (@site_item.width.get()+30) else "190px"
            if slogan_txt?
                slogan_txt.style.width = "100%"
            
        
        width_txt = 800
        if @viewstyle != "phone"
            if @site_item.width?
                width_txt = @elwidth - @site_item.width.get() - 50
            else  
                width_txt = @elwidth - 160 - 50
        else 
            width_txt = @elwidth
            
        title = new_dom_element
            parentNode : service_editor
            nodeName   : "div" 
            txt        : @site_item.title.get()
            style      :
                width      : width_txt
#                 height     : "30px"
                textAlign  : "left"
                fontWeight : "bold"
                fontSize   : "23px"
                margin     : "0px 0px 0px 0"
                cssFloat   : "left"  
                
        texte = new_dom_element
            parentNode : service_editor
            nodeName   : "div" 
            txt        : @site_item.description.get()
            style      :
                width      : width_txt
                textAlign  : "left"
                margin     : "0px 0px 0px 0"
                cssFloat   : "left"
            
        if @viewstyle == "phone"
            title.style.textAlign = "center"
            texte.style.textAlign = "justify"
    
    