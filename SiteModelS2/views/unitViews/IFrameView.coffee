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
class IFrameView extends UnitSiteView
    constructor: ( @site_item, @el, @viewstyle) ->
        super @site_item
        
        
#         for @site_item in @site_item._@site_itemren
        image = new_dom_element
            parentNode : @el
            nodeName  : "iframe"
            src       : @site_item.src.get()
            style :
                margin : if @site_item.margin? then @site_item.margin else undefined
                
        if @site_item.width? 
            if @site_item.width <= @el.offsetWidth
                image.width = @site_item.width
                image.height = @site_item.width / 2.0 
            else
                image.width = @el.offsetWidth - 20
                image.height = @el.offsetWidth / 2.0  
        
        else
            image.width = @el.offsetWidth - 20
            image.height = @el.offsetWidth / 2.0  
                
    
    
    