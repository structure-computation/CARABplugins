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
class IllustratedTextView extends UnitSiteView
    constructor: ( @site_item, @el) ->
        super @site_item
        
        @el.style.textAlign = "center"
        
        if @site_item?
#             console.log @site_item.width.get()
            image = @add_col(1, @el)
            new_dom_element
                parentNode : image
                nodeName  : "img"
                src       : @site_item.src.get()
#                 width     : @site_item.width.get()
                
            
            text = new_dom_element
                parentNode : @el
                nodeName   : "div" 
                txt        : @site_item.txt.get()  
                style      :
                    textAlign  : @site_item.textAlign.get() 
                    fontSize : @site_item.fontSize.get()  
                    
            if @site_item.fontFamily? then text.style.fontFamily = @site_item.fontFamily.get()  
        