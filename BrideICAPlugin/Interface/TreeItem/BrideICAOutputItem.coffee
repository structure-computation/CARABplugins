# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class BrideICAOutputItem extends MatriceItem
    constructor: ( name = "Maillage de sortie", @bride_children, @color = "red" ) ->
        super()

        @_name.set name
        @_viewable.set true
          
        @add_attr
            force_axiale: new ConstrainedVal
            facteur_echelle: new ConstrainedVal( 1, { min: 1, max: 100 } ) 
            _U: new Lst

        @add_attr
            _canvas_points: []

        @bind =>
            if @_U.has_been_directly_modified() or @facteur_echelle.val.has_been_modified() or @force_axiale.val.has_been_modified()
                if @_U.length > 0
                    @render()

    render: (  ) ->   
        @_canvas_points.clear()
        
        plot = @make_coord @_U[ @force_axiale.val.get() ]
        
        if @color == "red"
            color1 = new Color( 155, 0, 0, 255 )
            color2 = new Color( 255, 0, 0, 255 )
        else if @color == "blue"
            color1 = new Color( 0, 0, 155, 255 )
            color2 = new Color( 0, 0, 255, 255 )      
        else
            color1 = new Color( 0, 0, 0, 255 )
            color2 = new Color( 0, 0, 0, 255 )         
            
        @make_points_from_coord plot[0], plot[1], color1   
        @make_points_from_coord plot[2], plot[3], color2   
            
    cosmetic_attribute: ( name ) ->
        super( name ) or ( name in [ "_canvas_points" ] )
        
    make_points_from_coord: ( x, y, color ) ->
        for i in [ 0 .. x.length - 1 ]
            p = new CanvasPoint [ x[i], y[i], 0 ],
                radius: 2
                color: color
            @_canvas_points.push p
   
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
        @_canvas_points
