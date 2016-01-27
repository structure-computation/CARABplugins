

#clear page
MAIN_DIV = document.body
  

# launch_site = ( main = document.body ) ->
#     MAIN_DIV = main
#     main.style.overflowY = "auto"
#     main.style.overflowX = "auto"
#     
#     soft_hub_data = new SiteData
#         name        : "CARAB"
#         project_name: "CARAB"
#     softhub_view = new SpinalComSiteView main, soft_hub_data    
    
    
launch_site = ( main = document.body ) ->
    MAIN_DIV = main
    main.style.overflowY = "auto"
    main.style.overflowX = "auto"
    
    FileSystem._home_dir = "__site__"
    FileSystem._userid   = "644"
    fs = new FileSystem

    fs.load_or_make_dir FileSystem._home_dir, ( current_dir, err ) ->
        config_file = current_dir.detect ( x ) -> x.name.get() == "config_site_CARAB"
        if not config_file?
            console.log "creer le site"
            soft_hub_data = new SiteData
                name        : "CARAB"
                project_name: "CARAB"
            current_dir.add_file "config_site_CARAB", soft_hub_data, model_type: "Config"
            softhub_view = new SpinalComSiteView main, soft_hub_data      
        else
            config_file.load ( soft_hub_data, err ) =>
                softhub_view = new SpinalComSiteView main, soft_hub_data  