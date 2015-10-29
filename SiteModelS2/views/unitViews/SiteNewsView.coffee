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
class SiteNewsView extends UnitSiteView
    constructor: ( @site_item, @el, @viewstyle) ->
        super @site_item
        
        news_editor = new_dom_element
            parentNode : @el
            nodeName   : "div" 
            style      :
                cssFloat   : "left" 
                margin     : "10px 0px 10px 0"
        
        
        date_div = new_dom_element
            parentNode : news_editor
            nodeName   : "div" 
            txt        : @site_item.date
            style      :
                width      : "20%"
                textAlign  : "left"
                fontWeight : "bold"
                fontSize   : "23px"
                margin     : "5px 0px 5px 0"
                cssFloat   : "left" 
                
        title_div = new_dom_element
            parentNode : news_editor
            nodeName   : "div" 
            txt        : @site_item.title
            style      :
                width      : "75%"
                textAlign  : "left"
                fontWeight : "bold"
                fontSize   : "23px"
                margin     : "5px 0px 5px 0"
                cssFloat   : "left" 
                  
        if @viewstyle == "phone"
                date_div.style.width = "100%"
                title_div.style.width = "100%"
                
        new_dom_element
            parentNode : news_editor
            nodeName   : "div" 
            txt        : @site_item.description
            style      :
                width      : "100%"
                textAlign  : "left"
                margin     : "0px 0px 0px 0"
                cssFloat   : "left"    