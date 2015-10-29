# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class MenuButtonItem extends TreeItem
    constructor: ( name = "button", link = "#link" ) ->
        super()

        @_name.set name
        @_viewable.set false
          
        @add_attr
            txt : name
            balise : link
            
    accept_child: ( ch ) ->
        false # AppItem
        

          