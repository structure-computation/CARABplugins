# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class BICA2_TrouItem extends BICA_Base
    constructor: ( name = "Trou", params = {} ) ->
        super()

        @_name.set name
        @_viewable.set true
          
        @add_attr
            diametre_implantation : params.boulon.diametre_implantation
            diametre_trou_passage : params.boulon.diametre_trou_passage
            _bridesup_h_plaque: params.bridesup.h_plaque
            _brideinf_h_plaque: params.brideinf.h_plaque
            mesh_ligne: new Mesh
            mesh_trou: new Mesh
        @mesh_ligne.visualization.display_style.set "Wireframe" 
        @mesh_trou.visualization.display_style.set "Wireframe"    
        @bind =>
            if @diametre_implantation.has_been_modified() or @diametre_trou_passage.has_been_modified() or @_bridesup_h_plaque.has_been_modified() or @_brideinf_h_plaque.has_been_modified()
                @render()
        
    render: (  )->
        @mesh_ligne.points.clear()
        @mesh_trou.points.clear()
        @mesh_ligne._elements.clear()
        @mesh_trou._elements.clear()
        @make_mesh_ligne()
        @make_mesh_trou()
        
    cosmetic_attribute: ( name ) ->
        super( name ) or ( name in [ "mesh_ligne", "mesh_trou" ] )
         
         
    make_mesh_ligne: (  ) ->
        current_point = @mesh_ligne.points.length
        for coord in [ [ @diametre_implantation.get(), @_bridesup_h_plaque.get() + 50, 0 ], [ @diametre_implantation.get(), -@_brideinf_h_plaque.get() - 50, 0  ], ]
            @mesh_ligne.add_point coord
        
        @mesh_ligne.add_element new Element_BoundedSurf [
            { o: +1, e: new Element_Line [ current_point + 0, current_point + 1 ] }
        ]
    
    make_mesh_trou: (  ) ->
        current_point = @mesh_trou.points.length
        for coord in [ [ @diametre_implantation.get() - @diametre_trou_passage / 2, -@_brideinf_h_plaque.get(), 0 ], [ @diametre_implantation.get() + @diametre_trou_passage / 2, -@_brideinf_h_plaque.get(), 0  ], [ @diametre_implantation.get() + @diametre_trou_passage / 2, @_bridesup_h_plaque.get(), 0 ], [ @diametre_implantation.get() - @diametre_trou_passage / 2, @_bridesup_h_plaque.get(), 0 ] ]
            @mesh_trou.add_point coord
            
        @mesh_trou.add_element new Element_BoundedSurf [
            { o: +1, e: new Element_Line [ current_point + 0, current_point + 1 ] }
            { o: +1, e: new Element_Line [ current_point + 1, current_point + 2 ] }
            { o: +1, e: new Element_Line [ current_point + 2, current_point + 3 ] }
            { o: +1, e: new Element_Line [ current_point + 3, current_point + 0 ] }
        ]
        
    accept_child: ( ch ) ->
        false # AppItem

    sub_canvas_items: ->
        [ @mesh_ligne, @mesh_trou ]             