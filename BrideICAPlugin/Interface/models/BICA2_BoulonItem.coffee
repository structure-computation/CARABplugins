# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class BICA2_BoulonItem extends BICA_Base
    constructor: ( name = "Boulon", params = {} ) ->
        super()

        @_name.set name
        @_viewable.set true
          
        @add_attr                                                               # Rappel des Variable de BrideICA2Item
            diametre_nominal :          5
            diametre_tete :             8.3
            diametre_implantation :     74
            longueur_filetee :          0
            longueur_non_filetee :      6
            nombre_de_fixations :       20
            diametre_trou_passage :     5.4
            _bridesup_h_plaque:         if  params?.bridesup?.h_plaque? then params.bridesup.h_plaque else 3
            _brideinf_h_plaque:         if  params?.brideinf?.h_plaque? then params.brideinf.h_plaque else 3
            hauteur_tete :              5
            
            mesh_tete: new Mesh( not_editable: true )                 #
            mesh_ecrou: new Mesh( not_editable: true )                #
            mesh_vis: new Mesh( not_editable: true )                  # Initialisation des Differents Maillages
            mesh_ligne: new Mesh( not_editable: true )                #
            mesh_trou: new Mesh( not_editable: true )                 #
        
        @mesh_tete.visualization.display_style.set "Wireframe"          #
        @mesh_ecrou.visualization.display_style.set "Wireframe"         #
        @mesh_vis.visualization.display_style.set "Wireframe"           # Choix de l'affichage sur la fenetre 3D
        @mesh_ligne.visualization.display_style.set "Wireframe"         #
        @mesh_trou.visualization.display_style.set "Wireframe"          #
        
        
                    # Recreation du Maillage en fonction de la modification d'une variable
        @bind =>
            if @diametre_nominal.has_been_modified() or @diametre_tete.has_been_modified() or @diametre_implantation.has_been_modified() or @diametre_trou_passage.has_been_modified() or @_bridesup_h_plaque.has_been_modified() or @_brideinf_h_plaque.has_been_modified() or @hauteur_tete.has_been_modified()
                @render()

    draw: ( info ) ->
        app_data = @get_app_data()
        sel_items = app_data.selected_tree_items[0]
        if sel_items?.has_been_directly_modified()
            if sel_items[ sel_items.length-1 ] == this
                @colorize "blue"
            else
                @colorize() 
        
                    # Creation de la fonction de recreation de Maillage
    render: (  )->
        @mesh_tete.points.clear()
        @mesh_ecrou.points.clear()
        @mesh_vis.points.clear()
        @mesh_ligne.points.clear()
        @mesh_trou.points.clear()
        @mesh_tete._elements.clear()
        @mesh_ecrou._elements.clear()
        @mesh_vis._elements.clear()
        @mesh_ligne._elements.clear()
        @mesh_trou._elements.clear()
        @make_mesh_tete()
        @make_mesh_ecrou()
        @make_mesh_vis()
        @make_mesh_ligne()
        @make_mesh_trou()

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
   
                # Ce sont des attributs d'affichage
    cosmetic_attribute: ( name ) ->
        super( name ) or ( name in [ "mesh_tete", "mesh_ecrou", "mesh_vis", "mesh_ligne", "mesh_trou" ] )
         
         
                # Creation du Maillage mesh_tete en donnant 4 Coordonnees
    make_mesh_tete: (  ) ->
        current_point = @mesh_tete.points.length
        for coord in [ [ @diametre_implantation.get()/2 - @diametre_tete.get() / 2, @_bridesup_h_plaque.get(), 0 ], [ @diametre_implantation.get()/2 + @diametre_tete.get() / 2, @_bridesup_h_plaque.get(), 0 ], [ @diametre_implantation.get()/2 + @diametre_tete.get() / 2, @hauteur_tete.get(), 0 ], [ @diametre_implantation.get()/2 - @diametre_tete.get() / 2, @hauteur_tete.get(), 0 ] ]
            @mesh_tete.add_point coord
            
        @mesh_tete.add_element new Element_BoundedSurf [
            { o: +1, e: new Element_Line [ current_point + 0, current_point + 1 ] }
            { o: +1, e: new Element_Line [ current_point + 1, current_point + 2 ] }
            { o: +1, e: new Element_Line [ current_point + 2, current_point + 3 ] }
            { o: +1, e: new Element_Line [ current_point + 3, current_point + 0 ] }
        ]

                # Creation du Maillage mesh_ecrou en donnant 4 Coordonnees
    make_mesh_ecrou: (  ) ->
        current_point = @mesh_ecrou.points.length
        for coord in [ [ @diametre_implantation.get()/2 - @diametre_tete.get() / 2, -@_brideinf_h_plaque.get(), 0 ], [ @diametre_implantation.get()/2 + @diametre_tete.get() / 2, -@_brideinf_h_plaque.get(), 0 ], [ @diametre_implantation.get()/2 + @diametre_tete.get() / 2, -@hauteur_tete.get(), 0 ], [ @diametre_implantation.get()/2 - @diametre_tete.get() / 2, -@hauteur_tete.get(), 0 ] ]
            @mesh_ecrou.add_point coord
            
        @mesh_ecrou.add_element new Element_BoundedSurf [
            { o: +1, e: new Element_Line [ current_point + 0, current_point + 1 ] }
            { o: +1, e: new Element_Line [ current_point + 1, current_point + 2 ] }
            { o: +1, e: new Element_Line [ current_point + 2, current_point + 3 ] }
            { o: +1, e: new Element_Line [ current_point + 3, current_point + 0 ] }
        ]
        
                # Creation du Maillage mesh_vis en donnant 4 Coordonnees

    make_mesh_vis: (  ) ->
        current_point = @mesh_vis.points.length
        for coord in [ [ @diametre_implantation.get()/2 - @diametre_nominal.get() / 2, @_bridesup_h_plaque.get(), 0 ], [ @diametre_implantation.get()/2 + @diametre_nominal.get() / 2, @_bridesup_h_plaque.get(), 0 ], [ @diametre_implantation.get()/2 + @diametre_nominal.get() / 2, -@_brideinf_h_plaque.get() , 0 ], [ @diametre_implantation.get()/2 - @diametre_nominal.get() / 2, -@_brideinf_h_plaque.get() , 0 ] ]
            @mesh_vis.add_point coord
            
        @mesh_vis.add_element new Element_BoundedSurf [
            { o: +1, e: new Element_Line [ current_point + 0, current_point + 1 ] }
            { o: +1, e: new Element_Line [ current_point + 1, current_point + 2 ] }
            { o: +1, e: new Element_Line [ current_point + 2, current_point + 3 ] }
            { o: +1, e: new Element_Line [ current_point + 3, current_point + 0 ] }
        ]
    
                # Creation du Maillage mesh_ligne en donnant 2 Coordonnees
    
    make_mesh_ligne: (  ) ->
        current_point = @mesh_ligne.points.length
        for coord in [ [ @diametre_implantation.get()/2, @_bridesup_h_plaque.get() + 50, 0 ], [ @diametre_implantation.get()/2, -@_brideinf_h_plaque.get() - 50, 0  ], ]
            @mesh_ligne.add_point coord
        
        @mesh_ligne.add_element new Element_BoundedSurf [
            { o: +1, e: new Element_Line [ current_point + 0, current_point + 1 ] }
        ]
    
                # Creation du Maillage mesh_trou en donnant 4 Coordonnees
    
    make_mesh_trou: (  ) ->
        current_point = @mesh_trou.points.length
        for coord in [ [ @diametre_implantation.get()/2 - @diametre_trou_passage / 2, -@_brideinf_h_plaque.get(), 0 ], [ @diametre_implantation.get()/2 + @diametre_trou_passage / 2, -@_brideinf_h_plaque.get(), 0  ], [ @diametre_implantation.get()/2 + @diametre_trou_passage / 2, @_bridesup_h_plaque.get(), 0 ], [ @diametre_implantation.get()/2 - @diametre_trou_passage / 2, @_bridesup_h_plaque.get(), 0 ] ]
            @mesh_trou.add_point coord
            
        @mesh_trou.add_element new Element_BoundedSurf [
            { o: +1, e: new Element_Line [ current_point + 0, current_point + 1 ] }
            { o: +1, e: new Element_Line [ current_point + 1, current_point + 2 ] }
            { o: +1, e: new Element_Line [ current_point + 2, current_point + 3 ] }
            { o: +1, e: new Element_Line [ current_point + 3, current_point + 0 ] }
        ]
    
                # Cette Classe n'accepte pas d'enfants
    accept_child: ( ch ) ->
        false # AppItem

                # Affichage des Maillages préalablement construits
    sub_canvas_items: ->
        [ @mesh_tete, @mesh_ecrou, @mesh_vis, @mesh_ligne, @mesh_trou ]

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