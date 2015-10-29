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




class SitePartItem extends TreeItem
    constructor: ( params = {} ) ->
        super()

        @_name.set if params.name? then params.name else "new part"
        @_viewable.set false
          
        @add_attr
            type  : new Choice( 1, [ "menu", "standard", "stamps", "column"] )
            balise : if params.balise? then params.balise else ""
            title : if params.title? then params.title else true
            separator : if params.separator? then params.separator else true
            background : if params.background? then params.background else undefined
            color : if params.color? then params.color else undefined
            highlight : if params.highlight? then params.highlight else undefined
            column_marge : if params.column_marge? then params.column_marge else undefined
            textAlign : if params.textAlign? then params.textAlign else "center"
            ratio : if params.ratio? then params.ratio else 100  #for the stamps
            stamps_title : if params.stamps_title? then params.stamps_title else undefined  #for the stamps
            src : if params.src? then params.src else undefined  #for menu big logo
            display_big_logo : if params.display_big_logo? then params.display_big_logo else true  #for menu big logo
         
        if params.type? then @type._set params.type
    
    accept_child: ( ch ) ->
        true # AppItem
        

          