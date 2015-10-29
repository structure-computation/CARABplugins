

#clear page
MAIN_DIV = document.body
  

launch_site = ( main = document.body ) ->
    MAIN_DIV = main
    main.style.overflowY = "auto"
    main.style.overflowX = "auto"
    
    soft_hub_data = new SiteData
        name        : "CARAB"
        project_name: "CARAB"
    softhub_view = new SpinalComSiteView main, soft_hub_data    