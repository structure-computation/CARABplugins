# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#
# This file is part of Soda.


class MenuCentralButtonItem extends TreeItem
    constructor: ( link = "#link", src_ ="" ) ->
        super()

        @_name.set "name"
        @_viewable.set false
          
        @add_attr
            balise : link
            src : src_
            
    accept_child: ( ch ) ->
        false # AppItem
        

          