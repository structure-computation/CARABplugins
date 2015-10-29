class TreeAppApplication_BrideICA2 extends TreeAppApplication
    constructor: ->
        super()
        
        @unvreader = ''
        @name = 'BrideICA'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id
            
        @actions.push
            ico: "img/BrideICABouton.png"
            siz: 1
            txt: "function of t"
            ina: _ina
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                @unvreader = @add_item_depending_selected_tree app.data, BrideICA2ComputeItem
                
                
                
        
