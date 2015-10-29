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




class SliderItem extends TreeItem
    constructor: ( params = {} ) ->
        super()

        @_name.set if params.name? then params.name else "new slider"
        @_viewable.set false
         
        @add_attr
            nb_image : if params.nb_image? then params.nb_image else 3
            time_slide : if params.time_slide? then params.time_slide else 2000
            time_pause : if params.time_pause? then params.time_pause else 2000
            
    accept_child: ( ch ) ->
        true # AppItem
        

          