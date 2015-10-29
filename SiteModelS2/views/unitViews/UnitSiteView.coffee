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
class UnitSiteView extends View
    
    
    constructor: ( ) ->
    
    @_id_unit_view = 0
    get_unit_view_id : () ->
        id = "unit_view_" + UnitSiteView._id_unit_view
        UnitSiteView._id_unit_view += 1
        return id
    
    get_width: ( div ) ->
        txt_id = ""
        divid = div.id
        if divid?
            txt_id = "#" + divid
        
        else
            div.id = @get_unit_view_id()
            txt_id = "#" + div.id
#         console.log txt_id
        width = $(txt_id).width()
        return width
    
    add_col : ( subdivision, parent ) ->  
        nb_sub = Math.floor(100/subdivision)
        col = new_dom_element
            parentNode : parent
            nodeName   : "div" 
            style :
                width   : nb_sub + "%"
                cssFloat   : "left"
                textAlign : "center"
                margin: "0 0 20px 0"
                
        return col