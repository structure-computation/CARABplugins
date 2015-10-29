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
class SpinalComSiteView extends View
    constructor: ( @el, @soft_hub_data, params = {} ) ->
        super @soft_hub_data
        for key, val of params
            this[ key ] = val
    
        @num_part = 0
        @page_width = 1200
        @menu_background = @soft_hub_data.menu_background
        @page_container = new_dom_element
            nodeName  : "div"
            parentNode: @el
        
        window.onresize = ()=>
            @onchange()
        window.onscroll = ()=>
            @getScrollXY()    
        
              
        @container_bakground = new_dom_element
            parentNode : @page_container
            nodeName   : "div" 
            className  : "indexBackground"    
        
        
    onchange: ->
#         console.log @el.offsetWidth
#         console.log @el.offsetHeight
        @eloffsetWidth = @el.offsetWidth
        @eloffsetHeight = @el.offsetHeight
        @viewstyle = "screen"
        
        if @eloffsetWidth <= 820
            @viewstyle = "pad"
        if @eloffsetWidth <= 700
            @viewstyle = "phone"
    
        old_scrOfY = @scrOfY
    
        @clear_page()
        @render()
        
        $(document.body).animate
            scrollTop:   old_scrOfY
            1
        
    
    getScrollXY: ()-> 
        @scrOfX = 0 
        @scrOfY = 0
        if (typeof( window.pageYOffset ) == 'number' )
#             //Netscape compliant
            @scrOfY = window.pageYOffset
            @scrOfX = window.pageXOffset
        else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) )
#           //DOM compliant
          @scrOfY = document.body.scrollTop
          @scrOfX = document.body.scrollLeft
        else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) )
#           //IE6 standards compliant mode
          @scrOfY = document.documentElement.scrollTop
          @scrOfX = document.documentElement.scrollLeft  
        
        
        if @scrOfY > 100
            $("#big_logo_menu").slideUp "fast", ()->
                $("#center_button").slideDown "fast"
        else if @scrOfY <= 100 
            $("#center_button").slideUp "fast", ()->
                $("#big_logo_menu").slideDown "fast"
                                
    clear_page: ->
        while @container_bakground.firstChild?
            @container_bakground.removeChild @container_bakground.firstChild
            
    add_part_separator: ->
        part = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            className  : "indexpart"
            style :
                height : 200
                background : @soft_hub_data.backgroundColor.separator
                
    add_full_part: ( name, background = "", color = "", fixed = "" ) ->
        part = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            className  : "indexpart"
        if background != ""
            part.style.background = background
            part.style.color = color
        if fixed != ""
            part.style.position = "fixed"
            part.style.top      = 0
            part.style.width    = "100%"
        center_part = new_dom_element
            parentNode : part
            nodeName   : "div" 
            id         : name
        if @eloffsetWidth <= @page_width
            center_part.className  = "indexcenterpart_inf"
        else if @eloffsetWidth > @page_width
            center_part.className  = "indexcenterpart"
            
        return [part, center_part]
    
    add_full_part_2: ( name, background = "", color = "", fixed = "" ) ->
        part = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div"
        if background != ""
            part.style.background = background
            part.style.color = color
        
        if fixed != ""
            part.style.position = "fixed"
            part.style.top      = 0
            part.style.width    = "100%"
                
        center_part = new_dom_element
            parentNode : part
            nodeName   : "div" 
            id         : name

        if @eloffsetWidth <= @page_width
            center_part.className  = "indexcenterpart_inf"
        else if @eloffsetWidth > @page_width
            center_part.className  = "indexcenterpart"
        
        return [part, center_part]
    
    
    add_part: ( name, background = "", color = "", fixed = "" ) ->
        part = new_dom_element
            parentNode : @container_bakground
            nodeName   : "div" 
            className  : "indexpart"
        if background != ""
            part.style.background = background
            part.style.color = color
        
        if fixed != ""
            part.style.position = "fixed"
            part.style.top      = 0
            part.style.width    = "100%"
                
        center_part = new_dom_element
            parentNode : part
            nodeName   : "div" 
            id         : name
            
        if @eloffsetWidth <= @page_width
            center_part.className  = "indexcenterpart_inf"
        else if @eloffsetWidth > @page_width
            center_part.className  = "indexcenterpart"
            
        return center_part
    
# menu ---------------------------------------------------
    create_menu: (site_part_item) ->
        [full_menu, menu] = @add_full_part "menu", @menu_background, @soft_hub_data.textColor.first, "fixed"  # @soft_hub_data.backgroundColor.first
        [full_cb, cb] = @add_full_part_2 "cb", "transparent", @soft_hub_data.textColor.first, "fixed"  #"transparent"
        
   
        if @viewstyle == "phone" 
            new PhoneMenuView site_part_item, full_menu, menu, full_cb, cb
        else
            new MenuView site_part_item, full_menu, menu, full_cb, cb
            
            
    create_unit_view: (site_part_item, new_part) ->
#         console.log site_part_item._name
        if site_part_item.type.get() == "column"
            column_list = new ColumnView site_part_item, new_part, @viewstyle
            for col, i in column_list.columns
                @create_unit_view site_part_item._children[i], col, @viewstyle
        else if site_part_item.type.get() == "stamps"
            nb_stamps = 4
            if @viewstyle == "pad"
                nb_stamps = 2
            if @viewstyle == "phone"
                nb_stamps = 1
            new StampsView site_part_item, new_part, nb_stamps, @viewstyle
        else
            for child in site_part_item._children
                if child instanceof IllustratedTextItem
                    new IllustratedTextView child, new_part, @viewstyle
                else if child instanceof SiteServiceItem
                    new SiteServiceView child, new_part, @viewstyle
                else if child instanceof SiteNewsItem
                    new SiteNewsView child, new_part, @viewstyle
                else if child instanceof SiteImageItem
                    new SiteImageView child, new_part, @viewstyle
                else if child instanceof SiteTextItem
                    new SiteTextView child, new_part, @viewstyle
                else if child instanceof IFrameItem
                    new IFrameView child, new_part, @viewstyle    
                else if child instanceof SliderItem
                    new SliderView child, new_part, @viewstyle    
                else if child instanceof ThermometerItem
                    new ThermometerView child, new_part, @viewstyle
                    
    create_part: (site_part_item) ->
        if site_part_item.type.get() == "menu"
            @create_menu site_part_item
        else
            background = if site_part_item.background? then site_part_item.background else @soft_hub_data.backgroundColor.second
            color = if site_part_item.color? then site_part_item.color else @soft_hub_data.textColor.second
            new_part = @add_part site_part_item.balise.get(), background, color 
            new_part.style.textAlign = site_part_item.textAlign
            #titre si necessaire-----------------------------------------------
            if site_part_item.title.get()
                title =  new_dom_element
                    parentNode : new_part
                    nodeName   : "div" 
                    txt        : site_part_item._name.get() 
                    className  : "indexcenterpartTitle"
            #specific unit view -----------------------------------------------
            @create_unit_view site_part_item, new_part
            #séparator si necessaire-------------------------------------------
            if site_part_item.separator.get()
                @add_part_separator()
                
                
    #bottom of the page--------------------------------------------
    create_bottom: ->
        bottom = @add_part "bottom", @soft_hub_data.backgroundColor.first, @soft_hub_data.textColor.first
        bottom_part =  new_dom_element
            parentNode : bottom
            nodeName   : "div" 
            style      :
                width      : "100%"
                height     : "500px"
                textAlign  : "center"
                fontSize   : "14px";
        bottom_cont =  new_dom_element
            parentNode : bottom_part
            nodeName   : "div" 
            txt        : "Designed and built by <b><a href='http://www.is-sim.com' > is-sim</a>  </b> team. <br>
                          &copy; Structure Computation 2015.  <br> <br>
                          <b> is-sim </b> is a trademark of Structure Computation.<br> "
            style      :
                width      : "100%"
                textAlign  : "center"
                padding : "0 0 0 0"
        new_dom_element
            parentNode : bottom_part
            nodeName   : "img" 
            src        : "img/Logo_StructureComputation_gris.png"
            width      : "200"
    # index  ---------------------------------------------------------------------------------------------   
    render: ->
    
        #place pour le menu----------------
        top = @add_part "top", @menu_background
        top_size =  new_dom_element
            parentNode : top
            nodeName   : "div" 
            style      :
                background : @menu_background
                height     : if @soft_hub_data.display_big_logo.get() then "180px" else "30px"
                width : "100%"
                textAlign : "center"
                  
                  
        if @viewstyle == "phone"        
            big_logo = new SiteImageItem
                src : @soft_hub_data.src
                margin : "0 0 0 0"
                width  : "300"
                  
            top_size.style.height = "140px" 
            div_logo = new SiteImageView big_logo, top_size
            
        
        #parts---------------------------------------------------
        for part_ in @soft_hub_data._children
            @create_part part_

        #page bottom----------------------------------------------------------
        @create_bottom()