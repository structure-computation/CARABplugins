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
class SliderView extends UnitSiteView
    constructor: ( @site_item, @el, @viewstyle) ->
        super @site_item
        
        nb_li = @site_item._children.length        
#         col_marge = if @site_item.column_marge? then @site_item.column_marge else 0
        el_width = @get_width @el    
        console.log @el.offsetWidth
        eloffsetWidth = @el.offsetWidth
#         col_width_temp = (el_width / nb_columns) - 2*col_marge
#         col_width_temp_2 = el_width - 2*col_marge
#         col_width = if @viewstyle != "phone" then col_width_temp else col_width_temp_2        
        slideshow = new_dom_element
            parentNode : @el
            nodeName   : "div"
            className  : "slideshow"
            style     : 
              position:   "center"
              top:        0
              left:       0 
              width:      eloffsetWidth
#               background: "white"

        nb_children = @site_item._children.length
        ul = new_dom_element
            parentNode: slideshow
            nodeName  : "ul"
            style :
                width     : nb_children * 100 + "%"
        
        @li = []
        @img = []
        for child in @site_item._children
            @li.push new_dom_element
                parentNode : ul
                nodeName   : "li"
         
        for i in [ 0 ... @site_item._children.length ]
            child = @site_item._children[i]
            @img.push new_dom_element
                parentNode : @li[i]
                nodeName   : "img"
                src      : child.src.get()
                width    : eloffsetWidth / @site_item.nb_image.get()

        site_item = @site_item
        
        $(()->
          setInterval(()->
                $(".slideshow ul").animate
                    marginLeft : -eloffsetWidth / site_item.nb_image.get()
                    site_item.time_slide.get()
                    ()-> $(this).css({marginLeft:0}).find("li:last").after($(this).find("li:first"))
            site_item.time_pause.get()))