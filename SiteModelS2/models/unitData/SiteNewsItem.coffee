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


class SiteNewsItem extends TreeItem
    constructor: ( params = {} ) ->
        super()

        @_name.set if params.name? then params.name else "new service"
        @_viewable.set false
          
        @add_attr
            date : if params.date? then params.date else undefined
            title  : if params.title? then params.title else undefined
            description  : if params.description? then params.description else undefined
            color    : if params.color? then params.color else undefined
            background : if params.background? then params.background else "blue"
            
    accept_child: ( ch ) ->
        false # AppItem
        
    get_model_editor_parameters: ( res ) ->
       res.model_editor[ "description" ] = ModelEditorItem_TextArea
        

          