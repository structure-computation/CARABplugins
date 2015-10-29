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


class SiteTextItem extends TreeItem
    constructor: ( params = {} ) ->
        super()

        @_name.set if params.name? then params.name else "unit_site_text"
        @_viewable.set false
          
        @add_attr
            title : if params.title? then params.title else ""
            txt : if params.txt? then params.txt else ""
            balise : if params.balise? then params.balise else undefined
            textAlign  : if params.textAlign? then params.textAlign else "center"
            fontSize : if params.fontSize? then params.fontSize else undefined
            fontFamily : if params.fontFamily? then params.fontFamily else undefined
            fontWeight : if params.fontWeight? then params.fontWeight else undefined
            color : if params.color? then params.color else undefined
            cursor : if params.cursor? then params.cursor else undefined
            
    accept_child: ( ch ) ->
        false # AppItem
        
    get_model_editor_parameters: ( res ) ->
       res.model_editor[ "txt" ] = ModelEditorItem_TextArea
          