class BrideICA2DemoItem extends TreeItem
    constructor: (name = 'plot 3D')->
        super()
                
        @_name.set name
        
        @add_attr
            edited_by : 'Structure Computation'
            stamp: "img/BrideICA.png"
            txt: "BrideICA"
            demo_app : "BrideICA2DemoItem"
            directory : "BrideICA"
            video_link : undefined
            publication_link : undefined

    associated_application: ()->
        apps = new Lst
        apps.push new TreeAppApplication_BrideICA2
        return apps
    
    run_demo : (app_data)->
        app = new TreeAppApplication
        a = app.add_item_depending_selected_tree app_data, BrideICA2ComputeItem
            
    onclick_function: ()->
        window.location = "softpage.html#" +  @demo_app