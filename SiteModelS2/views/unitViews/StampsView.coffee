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
class StampsView extends UnitSiteView
    constructor: ( @site_part_item, @el, @nb_stamps_per_lign = 4, @viewstyle) ->
        super @site_part_item
        
        if @site_part_item.stamps_title?
            title = new_dom_element
                parentNode : @el
                nodeName  : "div"
                txt       : @site_part_item.stamps_title.get()
                style      :
                    textAlign  : "center"
                    fontSize : if @site_part_item.fontSize? then @site_part_item.fontSize.get()  else 18
                    fontWeight : "bold"
                    margin : "5 0 5 0"
                    
            if @site_part_item.color? then title.style.color = @site_part_item.color.get() 
        
        @el.style.textAlign = "left"
#         @el.style.borderBottom = "1px solid #262626 "
#         @el.style.borderTop = "1px solid #262626 "
        
        v_marge = 3
        
        el_width = @get_width @el
        v_width = (el_width / @nb_stamps_per_lign) - 2*v_marge
        v_height = v_width * @site_part_item.ratio / 100
#         console.log v_width
        
        
        for child in @site_part_item._children
            console.log child.demo_app.get()
            image = new_dom_element
                parentNode : @el
                nodeName   : "div"
                item : child.demo_app.get()
                style :
                  width  : v_width
                  height : v_width
                  textAlign  : "center"
                  cssFloat : "left"
#                   margin : "0 " + (v_marge-2) + " 0 " + (v_marge-2)
                  marginBottom : "5px"
                  cursor : "pointer"
                onclick: ( evt ) ->
                  window.location = "softpage.html#" +  @item
                
#             image.style.border = "1px solid #262626 "

            new_dom_element
                parentNode : image
                nodeName   : "div"
                txt        : "online demo ->"
                style :
                  margin : "0 0 0 0"
                  width  : "100%"
#                   height : 30
                  textAlign  : "center"
                  fontWeight : "bold"
                  color : @site_part_item.highlight
                  fontFamily: "'Indie Flower', sans-serif"
            
            new_dom_element
                parentNode : image
                nodeName  : "img"
                src       : child.stamp.get()
                width     : (v_width - 20)
                height    : (v_height - 20)
                style :
                  marginTop : v_marge
                  cursor : "pointer"
                       
            new_dom_element
                parentNode : image
                nodeName   : "div"
                txt        : child.txt.get() + " / " +  child.edited_by.get()
                style :
                  margin : "8 0 0 0"
                  width  : "100%"
#                   height : 20
                  textAlign  : "center"
                  fontWeight : "bold"
                  
            
                  
            
#             
#             new_dom_element
#                 parentNode : @el
#                 nodeName   : "div" 
#                 txt        : @child.txt.get()  
#                 style      :
#                     textAlign  : @child.textAlign.get() 
#                     fontSize : @child.fontSize.get() 
    
    
    