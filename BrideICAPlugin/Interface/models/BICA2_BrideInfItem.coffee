# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class BICA2_BrideInfItem extends BICA_Base
    constructor: ( name = "Bride Inferieur", params = {} ) ->
        super()

        @_name.set name
        @_viewable.set true
          
        @add_attr
            D_ext_plaque :              86
            D_int_plaque :              57
            h_plaque :                  3
            D_ext_tube :                61                                           # Se referer aux commentaires de BICA2_BoulonItem
            D_int_tube :                57.1
            h_tube_incline :            60
            angle_tube_incline :        0
            h_tube :                    56
            mesh: new Mesh( not_editable: true )
            mesh_droite: new Mesh( not_editable: true )
            mesh_incline: new Mesh( not_editable: true )
            
        @mesh_droite.visualization.display_style.set "Wireframe"
        @mesh_incline.visualization.display_style.set "Wireframe"
        @mesh.visualization.display_style.set "Wireframe"    
        @bind =>
            if @D_ext_plaque.has_been_modified() or @D_int_plaque.has_been_modified() or @h_plaque.has_been_modified() or @D_ext_tube.has_been_modified() or @D_int_tube.has_been_modified() or @h_tube_incline.has_been_modified() or @angle_tube_incline.has_been_modified() or @h_tube.has_been_modified()
                @render()

    draw: ( info ) ->
        app_data = @get_app_data()
        sel_items = app_data.selected_tree_items[0]
        if sel_items?.has_been_directly_modified()
            if sel_items[ sel_items.length-1 ] == this
                @colorize "blue"
            else
                @colorize() 
    
    render: (  ) ->
        @mesh_droite.points.clear()
        @mesh_incline.points.clear()
        @mesh_droite._elements.clear()
        @mesh_incline._elements.clear()        
        @mesh.points.clear()
        @mesh._elements.clear()
        @make_mesh_droite()
        @make_mesh_incline()
        @make_mesh()         

    colorize: ( color ) ->
        for drawable in @sub_canvas_items() 
            if color == "blue"
                drawable.visualization.line_color.r.val.set 77
                drawable.visualization.line_color.g.val.set 188
                drawable.visualization.line_color.b.val.set 233
            else
                drawable.visualization.line_color.r.val.set 255
                drawable.visualization.line_color.g.val.set 255
                drawable.visualization.line_color.b.val.set 255
         
    cosmetic_attribute: ( name ) ->
        super( name ) or ( name in [ "mesh", "mesh_droite", "mesh_incline" ] )
        
    make_mesh: (  ) ->
        current_point = @mesh.points.length
        for coord in [ [ @D_int_plaque.get()/2, 0, 0 ], [ @D_ext_plaque.get()/2, 0, 0  ], [ @D_ext_plaque.get()/2, -@h_plaque.get(), 0  ], [ @D_int_plaque.get()/2, -@h_plaque.get(), 0  ] ]
            @mesh.add_point coord
        
        @mesh.add_element new Element_BoundedSurf [
            { o: +1, e: new Element_Line [ current_point + 0, current_point + 1 ] }
            { o: +1, e: new Element_Line [ current_point + 1, current_point + 2 ] }
            { o: +1, e: new Element_Line [ current_point + 2, current_point + 3 ] }
            { o: +1, e: new Element_Line [ current_point + 3, current_point + 0 ] }
        ]
        
    make_mesh_droite: (  ) ->
        current_point = @mesh_droite.points.length
        for coord in [ [ @D_int_tube.get()/2, -@h_tube_incline.get() - @h_plaque.get(), 0 ], [ @D_ext_tube.get()/2, -@h_tube_incline.get() - @h_plaque.get(), 0  ], [ @D_ext_tube.get()/2, -@h_tube_incline.get() - @h_tube.get() - @h_plaque.get(), 0  ], [ @D_int_tube.get()/2, -@h_tube_incline.get() - @h_tube.get() - @h_plaque.get(), 0  ] ]
            @mesh_droite.add_point coord
        
        @mesh_droite.add_element new Element_BoundedSurf [
            { o: +1, e: new Element_Line [ current_point + 0, current_point + 1 ] }
            { o: +1, e: new Element_Line [ current_point + 1, current_point + 2 ] }
            { o: +1, e: new Element_Line [ current_point + 2, current_point + 3 ] }
            { o: +1, e: new Element_Line [ current_point + 3, current_point + 0 ] }
        ]
        
    make_mesh_incline: (  ) ->
        current_point = @mesh_incline.points.length
        for coord in [ [ @D_int_tube.get()/2, -@h_tube_incline.get() - @h_plaque.get(), 0 ], [ @D_ext_tube.get()/2, -@h_tube_incline.get() - @h_plaque.get(), 0  ], [ @D_ext_tube.get()/2 + @h_tube_incline * Math.tan(Math.PI * @angle_tube_incline.get() / 180), -@h_plaque.get(), 0  ], [ @D_int_tube.get()/2 + @h_tube_incline * Math.tan(Math.PI * @angle_tube_incline.get() / 180), -@h_plaque.get(), 0  ] ]
            @mesh_incline.add_point coord
            
        @mesh_incline.add_element new Element_BoundedSurf [
            { o: +1, e: new Element_Line [ current_point + 0, current_point + 1 ] }
            { o: +1, e: new Element_Line [ current_point + 1, current_point + 2 ] }
            { o: +1, e: new Element_Line [ current_point + 2, current_point + 3 ] }
            { o: +1, e: new Element_Line [ current_point + 3, current_point + 0 ] }
        ]

          
    accept_child: ( ch ) ->
        false # AppItem
        
    sub_canvas_items: ->
        [ @mesh, @mesh_droite, @mesh_incline ]

    # pour récupérer le modèle global (TreeAppData) 
    is_app_data: ( item ) ->
        if item instanceof TreeAppData
            return true
        else
            return false
       
    # pour récupérer le modèle global (TreeAppData) 
    get_app_data: ->
        it = @get_parents_that_check @is_app_data
        return it[ 0 ]        