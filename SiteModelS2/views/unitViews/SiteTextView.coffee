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
class SiteTextView extends UnitSiteView
    constructor: ( @site_item, @el, @viewstyle) ->
        super @site_item
        
        if @site_item.title != ""
            title = new_dom_element
                parentNode : @el
                nodeName  : "div"
                txt       : @site_item.title.get()
                style      :
                    textAlign  : "center"
                    fontSize : if @site_item.fontSize? then @site_item.fontSize.get()  else 18
                    fontWeight : "bold"
                    margin : "0 0 10 0"
                    
            if @site_item.color? then title.style.color = @site_item.color.get()  
        
        balise = if @site_item.balise? then @site_item.balise else undefined
        
        text = new_dom_element
            parentNode : @el
            nodeName  : "div"
            txt       : @site_item.txt.get()
            style      :
                textAlign  : @site_item.textAlign.get() 
            onclick: ( evt ) ->
                if balise? then window.location = balise
              
        if @site_item.fontSize?
            
            if @viewstyle == "phone" and @site_item.fontSize.get() > 30
                text.style.fontSize = 30
            else  
                text.style.fontSize = @site_item.fontSize.get() 
        
            
        if @site_item.color? then text.style.color = @site_item.color.get()  
        if @site_item.fontFamily? then text.style.fontFamily = @site_item.fontFamily.get()  
        if @site_item.fontWeight? then text.style.fontWeight = @site_item.fontWeight.get()
        if @site_item.cursor? then text.style.cursor = @site_item.cursor.get()
        
        
        

                
    
    
    