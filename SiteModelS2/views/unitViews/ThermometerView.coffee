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
class ThermometerView extends UnitSiteView
    constructor: ( @site_part_item, @el, @viewstyle) ->
        super @site_part_item
         
        el_width = @get_width @el    
        console.log @el.offsetWidth
        eloffsetWidth = @el.offsetWidth


        canvas = new_dom_element
            parentNode: @el
            nodeName  : "canvas"
            id      : "test"
            txt     : "no canvas"
            width : @site_part_item.width
            height: @site_part_item.height
            
        site_part_item =  @site_part_item   
        $(()->
            thermometer = new RGraph.Thermometer(
                id: "test"
                min: 0
                max: 100
                width : 100
                height: 400
                value: site_part_item.value.get()).draw()
            )
