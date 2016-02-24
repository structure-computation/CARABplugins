# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class BrideICAOutputItem extends MatriceItem
    constructor: ( @bride_children ) ->
        super()

        @_name.set "Maillage de sortie"
        @_viewable.set true
          
        @add_attr
            force_axiale: new ConstrainedVal
            facteur_echelle: new ConstrainedVal( 1, { min: 1, max: 1000 } ) 
            _U: new Lst

        @add_attr
            mesh_bride_sup: new Mesh( not_editable: true )    
            mesh_bride_inf: new Mesh( not_editable: true )  
            p_mesher: []
            
        @mesh_bride_sup.visualization.display_style.set "Wireframe"    
        @mesh_bride_inf.visualization.display_style.set "Wireframe"   


        @bind =>
            if @_U.has_been_directly_modified() or @facteur_echelle.val.has_been_modified()
                if @_U.length > 0
                    @render()
                    @draw()
    
    draw: ( info ) ->
        app_data = @get_app_data()
        sel_items = app_data.selected_tree_items[0]
        if sel_items?.has_been_directly_modified()
            if sel_items[ sel_items.length-1 ] == this
                @colorize "blue"
            else
                @colorize() 

    render: (  ) ->   
        @p_mesher.clear()
        
        @mesh_bride_sup.points.clear()
        @mesh_bride_sup._elements.clear()
        @mesh_bride_inf.points.clear()
        @mesh_bride_inf._elements.clear()      
        
        plot1 = @make_coord @_U
        @make_mesh_from_coord @mesh_bride_sup, plot1[0], plot1[1]   
        @make_mesh_from_coord @mesh_bride_inf, plot1[2], plot1[3]   
         
    colorize: ( color ) ->
        for drawable in @sub_canvas_items() when drawable instanceof Mesh
            if color == "blue"
                drawable.visualization.line_color.r.val.set 77
                drawable.visualization.line_color.g.val.set 188
                drawable.visualization.line_color.b.val.set 233
            else
                drawable.visualization.line_color.r.val.set 200
                drawable.visualization.line_color.g.val.set 0
                drawable.visualization.line_color.b.val.set 0
            
    cosmetic_attribute: ( name ) ->
        super( name ) or ( name in [ "mesh_bride_sup", "mesh_bride_inf", "p_mesher" ] )
        
    make_mesh_from_coord: ( mesh, x, y ) ->
        current_point = mesh.points.length
        for i in [ 0 .. x.length - 1 ]
            mesh.add_point [ x[i], y[i], 0 ]
            pm = new PointMesher [ x[i], y[i], 0 ], 2, 2
            @p_mesher.push pm
        
#         for i in [0 .. mesh.points.length-2 ]
#             mesh.add_element new Element_Line [ i, i+1 ]
#         mesh.add_element new Element_Line [ mesh.points.length-1, 0 ]
        
   
    make_coord: ( U ) -> 
        noeud = @bride_children[4].noeud.get()
        wsup = @bride_children[4].wsup.get()
        winf = @bride_children[4].winf.get()    
        
        xsec1 = []
        ysec1 = []
        x2sec1 = []
        y2sec1 = []
        xsec2 = []
        ysec2 = []
        x2sec2 = []
        y2sec2 = []
        
        #Separation des noeuds des deux brides
        for i in [1 .. wsup]
            xsec1.push noeud[i-1].r
            ysec1.push noeud[i-1].z
        for i in [wsup+1 .. winf]
            x2sec1.push noeud[i-1].r
            y2sec1.push noeud[i-1].z  
        #Noeuds déplacés          
        for i in [1 .. wsup]
            xsec2.push ( xsec1[i-1] + @facteur_echelle.val.get() * U[3*i-3].get() ) 
            ysec2.push ( ysec1[i-1] + @facteur_echelle.val.get() * U[3*i-2].get() )
        for i in [wsup+1 .. winf]
            x2sec2.push ( x2sec1[i-1-wsup] + @facteur_echelle.val.get() * U[3*i-3].get() )
            y2sec2.push ( y2sec1[i-1-wsup] + @facteur_echelle.val.get() * U[3*i-2].get() )  
        
        return [ xsec2, ysec2, x2sec2, y2sec2 ]
   
   
    accept_child: ( ch ) ->
        false # AppItem
    
    sub_canvas_items: ->
        @p_mesher

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