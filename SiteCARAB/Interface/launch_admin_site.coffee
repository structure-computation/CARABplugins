

#clear page
MAIN_DIV = document.body


#launch softhub page ------------------------------------------------------------------------------------------------------------    
launch_admin_site = ( main = document.body ) ->
    MAIN_DIV = main
    main.style.overflowY = "auto"
    main.style.overflowX = "auto"
    #load or create site_config file
    FileSystem._home_dir = "__site__"
    FileSystem._userid   = "644"

    
    #lab
    fs = new FileSystem

    fs.load_or_make_dir FileSystem._home_dir, ( current_dir, err ) ->
        config_file = current_dir.detect ( x ) -> x.name.get() == "config_site_CARAB"
        if not config_file?
            console.log "creer le site"

        else
            config_file.load ( config_data, err ) =>
                td = new adminSiteData
                td.new_session()                        
                td.modules.push new TreeAppModule_UndoManager
                td.modules.push new TreeAppModule_PanelManager
                td.modules.push new TreeAppModule_File
                td.modules.push new TreeAppModule_Apps
                #td.modules.push new TreeAppModule_Projects
                #td.modules.push new TreeAppModule_Animation
                td.modules.push new TreeAppModule_TreeView 
                
                td.tree_items.push config_data

                softhub_view = new TreeApp main, td
                
