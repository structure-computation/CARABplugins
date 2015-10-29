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
class ColumnView extends UnitSiteView
    constructor: ( @site_part_item, @el, @viewstyle) ->
        super @site_part_item
        
        nb_columns = @site_part_item._children.length        
        col_marge = if @site_part_item.column_marge? then @site_part_item.column_marge else 0
        el_width = @get_width @el        
        col_width_temp = (el_width / nb_columns) - 2*col_marge
        col_width_temp_2 = el_width - 2*col_marge
        col_width = if @viewstyle != "phone" then col_width_temp else col_width_temp_2        
        block = new_dom_element
            parentNode : @el
            nodeName   : "div"
            style :
              width  : "100%"
              textAlign  : "center"
              cssFloat : "left"
        
        @columns = []
        for child in @site_part_item._children
            @columns.push new_dom_element
                parentNode : block
                nodeName   : "div"
                style :
                  width  : col_width
                  textAlign  : "center"
                  cssFloat : "left"
                  margin : "0 " + (col_marge-2) + " 10 " + (col_marge-2)                  
        
    
    