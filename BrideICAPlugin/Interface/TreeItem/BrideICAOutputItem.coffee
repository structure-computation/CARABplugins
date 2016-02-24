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
            canvas_points: []

        @bind =>
            if @_U.has_been_directly_modified() or @facteur_echelle.val.has_been_modified()
                if @_U.length > 0
                    @render()

    render: (  ) ->   
        @canvas_points.clear()
        
        plot1 = @make_coord @_U
        red = new Color( 200, 0, 0, 255 )
        blue = new Color( 0, 0, 200, 255 )
        @make_points_from_coord plot1[0], plot1[1], blue   
        @make_points_from_coord plot1[2], plot1[3], red   
         
            
    cosmetic_attribute: ( name ) ->
        super( name ) or ( name in [ "p_mesher" ] )
        
    make_points_from_coord: ( x, y, color ) ->
        for i in [ 0 .. x.length - 1 ]
            pm = new CanvasPoint [ x[i], y[i], 0 ],
                radius: 2
                color: color
            @canvas_points.push pm
   
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
        @canvas_points
