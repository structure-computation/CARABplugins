# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2015 Jérémie Bellec
#
class CanvasJSChartView extends View
    constructor: ( @el, @mydata, params = {} ) ->  
        super @mydata
            
        @type = if params.type? then params.type else "line"  #area, line, column, scatter
        @title = if params.title? then params.title else ""
        @color = if params.color? then params.color else "blue"
        @fontColor = if params.fontColor? then params.fontColor else "blue"
        @backgroundColor = if params.backgroundColor? then params.backgroundColor else "#e5e5e5"
        @data_ = []
        @el.id = @get_unit_view_id()
        @drawChart()

    @_id_view = 0
    get_unit_view_id : () ->
        id = "CanvasJSChartView_" + CanvasJSChartView._id_view
        CanvasJSChartView._id_view += 1
        return id

    drawChart: ()->
        if @mydata.has_been_directly_modified  
            delete @chart if @chart?
            @data_ = []
            dataPoints_ = []
            for j in  [ 0 ... @mydata[0].length ]
                dataPoints_.push {x: @mydata[0][j].get(),y: @mydata[1][j].get()}
            
            content_0 = 
                type: @type,
                color: @color
                dataPoints: dataPoints_
            
            @data_.push content_0
            
            @chart = new CanvasJS.Chart @el.id, 
                title: 
                  text: @title
                  fontColor: @fontColor
                backgroundColor: @backgroundColor
                axisY: 
                  labelAutoFit: true 
                  gridThickness: 0
                axisX:
                  minimum: 28.5
                  maximum: 100
#                   interval: 20
                data : @data_
                
            @chart.render()                
                
     

#     onchange: ->
#         @drawChart()
#               
        

    
            
            
            
            