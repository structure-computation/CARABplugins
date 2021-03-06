# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
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
class adminSiteData extends Model
    constructor: ->
        super()

        @add_attr
            # tree
            tree_items         : new Lst # root items 
            selected_tree_items: new Lst # path list
            visible_tree_items : new Model # panel_id: [ model_1, ... ]
            closed_tree_items  : new Lst
            # canvas
            selected_canvas_pan: new Lst # panel_id of selected panels
            last_canvas_pan    : new Str #
            # loaded application
            applications       : new Lst
            
            # loaded modules
            base_modules       : new Lst
            modules            : new Lst
            #context_actions    : new Lst
            focus              : -1
            time               : new ConstrainedVal( 0, { min: 0, max: 100 } )
    
    
    watch_item: ( item ) ->
        for p in @panel_id_list()
            if not @visible_tree_items[ p ]?
                @visible_tree_items.add_attr p, []
            if not @visible_tree_items[ p ].contains_ref item
                @visible_tree_items[ p ].push item
            
    close_item: ( item ) ->
        @closed_tree_items.push item
        
    open_item: ( item ) ->
        for it, index in @closed_tree_items
            if item.equals it
                @closed_tree_items.splice index, 1        
    
    display_framework: ->
        d = new DisplaySettingsItem
            sep_norm: 0
            children: [ 
                {
                    panel_id: "ContextBar"
                    immortal: true
                    min_size: [60,0]
                    max_size: [65,1e5]
                }, {
                sep_norm: 0
                
                children: [ 
                    {
                        panel_id: "TreeView"
                        immortal: true
                    }, {
                        panel_id: "EditView"
                        strength: 3,
                    } ]
                }
            ]
        return d
    
    
    new_session: ( name = "Session" ) ->
        s = new SessionItem name, this
        @add_session s   
        d = @display_framework()
        s._children.push d
        return s
        
    add_session: ( session ) ->
        @tree_items.push session
        
    #
    selected_session: ->
        for session in @tree_items
            if @has_a_selected_child session
                return session
        return @tree_items[ 0 ]

    # return current DisplaySettingsItem
    selected_display_settings: ->
        session = @selected_session()
        session._children.detect ( x ) -> x instanceof DisplaySettingsItem

    #
    panel_id_list: ->
        d = @selected_display_settings()
        d._layout.panel_id_of_term_panels().filter ( x ) -> x not in [ "EditView", "TreeView","ContextBar","IcoBar" ]
    
    #
    rm_selected_panels: ->
        d = @selected_display_settings()
        for panel_id in @selected_canvas_pan
            d._layout.rm_panel panel_id
    
    # removed 
    # d -> DisplaySettingsItem
    update_associated_layout_data: ( d ) ->
        pil = d._layout.panel_id_of_term_panels()
        
        for key in ( key for key in @visible_tree_items._attribute_names when key not in pil )
            @visible_tree_items.rem_attr key
            
        for key in ( key for key in @selected_canvas_pan when key not in pil )
            @selected_canvas_pan.remove key
        if not @selected_canvas_pan.length
            @selected_canvas_pan.push pil[ pil.length-1 ]
        
        if @last_canvas_pan not in pil
            @last_canvas_pan.set pil[ pil.length-1 ]
            
    
    # return selected cam
    get_current_cam: ->
        panel_id = @last_canvas_pan.get()
        for i in [ 0 ... @selected_display_settings()._children.length ]
            if @selected_display_settings()._children[ i ]._panel_id.get() == panel_id
                return @selected_display_settings()._children[ i ].cam

    # return true if tree item $item is selected or has a selected child
    has_a_selected_child: ( item ) ->
        if item in @selected_tree_items
            return true
        for c in item._children
            if @has_a_selected_child c
                return true
        return false
    
    #return list of child from "item" that corresponding to instance of "type"
    get_child_of_type: ( item, type ) ->
        res = []
        visited = {}
        @_get_child_of_type_rec res, visited, item, type
        return res
                    
    # return item selected (not the path)
    get_selected_tree_items: ->
        items = new Lst
        for path in @selected_tree_items
            items.push path[ path.length-1 ]
        return items
    
    get_root_path_in_selected: ( item ) ->
        for path in @selected_tree_items
            for it in path
                if it.model_id == item.model_id
                    return path

    get_root_path: ( item ) ->
        res = []
        path = []
        for root in @tree_items
            path.push root
            if item.equals root
                res.push path.slice(0)
            else
                node = root
                @get_root_path_rec path, item, node, res
            return res
                
    get_root_path_rec: ( path, item, node, res ) ->
        for child in node._children
            if item.equals child
                path.push child
                res.push path.slice(0)
                path.pop()
                return path
                
        for child in node._children
            path.push child
            @get_root_path_rec path, item, child, res
            path.pop()
    
    # root is a boolean to differenciate primary call item (root) from recursive call item
    delete_from_tree: ( item, root = true ) ->
        # delete children
        child = false
        if item._children.length
            for i in [ item._children.length - 1 .. 0 ]
                c = item._children[ i ]
                if c._children.length > 0
                    @delete_from_tree c, false
                child = true
                item.rem_child c
                @closed_tree_items.remove c
                for p in @panel_id_list()
                    @visible_tree_items[ p ].remove c
            
        if not child or root
            # delete item
            parent = @_get_parent item
            parent.rem_child item
            @closed_tree_items.remove item
            for p in @panel_id_list()
                @visible_tree_items[ p ].remove item
    
    _get_parent: ( item ) ->
        path = item._parents
        if path[ 0 ].length <= 2
            parent = path[ 0 ][ 0 ]
        else
            parent = path[ 0 ][ path[ 0 ].length - 2 ]
        if parent == item
            i = 1
            while parent == item and i < 50
                if path[ i ].length > 1
                    parent = path[ i ][ path[ i ].length - 2 ]
                i++
        return parent
    
    _get_child_of_type_rec: ( res, visited, item, type ) ->
        if not visited[ item.model_id ]?
            visited[ item.model_id ] = true
            if item instanceof type
                res.push item
            if item._children?
                for ch in item._children
                    @_get_child_of_type_rec res, visited, ch, type
            