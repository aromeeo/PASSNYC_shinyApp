shinyServer(function(input, output){
  
  output$map <- renderLeaflet({
    leaflet(nyc_districts) %>%
      addTiles() %>% 
      addPolygons(popup = ~school_dist,
                  weight = 1,
                  fillColor = ~pal(medians$med_AvgIncome),
                  stroke = FALSE, 
                  smoothFactor = 0.5, 
                  fillOpacity = 0.7,
                  label = ~paste0(school_dist, ": ", format(medians$med_AvgIncome, big.mark = ","))) %>% 
      addLegend(pal = pal, values = ~medians$med_AvgIncome, opacity = 1.0) %>%
      addProviderTiles("CartoDB.Positron")
  })
  
  output$schoolsMap = renderLeaflet({
    leaflet(passnyc) %>% 
      addProviderTiles("CartoDB.Positron") %>% 
      setView(lng = -73.93479, lat = 40.69293, zoom = 11)
  })
  
  
  
  output$heat = renderPlotly({
    plot_ly(x = nms, y = nms, z = correlation,
            key = correlation, type = "heatmap", source = "heatplot", colors = "RdYlGn",
            height = 600) %>%
      colorbar(limits = c(-1, 1)) %>% 
      layout(xaxis = list(title = ""),
             yaxis = list(title = ""))
  })
  
  output$corrs <- renderPlotly({
    s <- event_data(event = "plotly_click", source = "heatplot")
    if (length(s)) {
      vars <- c(s[["x"]], s[["y"]])
      d <- setNames(features[vars], c("x", "y"))
      # yhat <- fitted(lm(y ~ x, data = d))
      plot_ly(d, x = ~x) %>% 
        add_markers(y = ~y) %>% 
        # add_lines(y = ~yhat) %>% 
        layout(xaxis = list(title = s[["x"]]),
               yaxis = list(title = s[["y"]]),
               showlegend = FALSE)
    } else{
      plotly_empty()
    }
  })
  
  output$allshsat <- DT::renderDataTable({
    all_shsat
  })
  
  output$shsat_dist <- renderPlotly({
    plot_ly(all_shsat, x = ~`School name`, y = ~total_reg,
            type = "bar", 
            name = "Total Registered", 
            marker = list(color = 'Blue'),
            height = 600) %>% 
      add_trace(y = ~total_took, name = "Total Took", marker = list(color = 'Red')) %>% 
      layout(yaxis= list(title = "Count", showticklabels = FALSE),
             xaxis = list(title = "School", showticklabels = FALSE),
             barmode = 'dodge'
             ) %>% 
    layout(legend = list(x = 0.1, y = 0.9))
  })
  
  output$passNYC <- DT::renderDataTable({
    passnyc
  })
  
  output$shsat <- DT::renderDataTable({
    shsat
  })
  
  #Observer function for checkbox controlling visibility of icons representing D5 schools
  observe({
    proxy <- leafletProxy("schoolsMap", data = shsat_coords)
    proxy %>% 
      clearGroup(group = "Icons")
    if(input$checkbox) {
      proxy %>% addAwesomeMarkers(data = shsat_coords, ~shsat_coords$Longitude, ~shsat_coords$Latitude, 
                                  icon = schoolIcons,
                                  label = ~shsat_coords$School_Name,
                                  group = "Icons") 
      }
    })
  
  # Observer function for color and size options representing school on schoolsMap
  observe({
    colorBy <- input$color
    sizeBy <- input$size
    colorData <- passnyc[[colorBy]]
    
    # Update colorBin for School Income Estimate
    if (colorBy == "School_Income_Estimate") {
      pal2 <- colorBin("RdYlGn", domain = colorData)
    } else if(colorBy == "Economic_Need_Index"){
      pal2 <- colorBin("RdYlGn", domain = colorData, reverse = TRUE)
    } else {
      pal2 = colorBin("BrBG", domain = colorData)
    }


    # Update radius of Circle Markers
    if (sizeBy == "School_Income_Estimate") {
      radius <- passnyc$School_Income_Estimate / 10000
    } else if (sizeBy == "Economic_Need_Index") {
      radius <- passnyc$Economic_Need_Index * 10
    }
    else {
      radius <- passnyc[[sizeBy]] * 10
    }
    
    # Change schoolsMap based on changes in size/colorBy
    leafletProxy("schoolsMap", data = passnyc) %>%
      clearGroup(group = "schoolMarkers") %>%
      addCircleMarkers(~Longitude, ~Latitude,
                       color = "white",
                       fillColor = ~pal2(colorData), 
                       radius = radius, 
                       fillOpacity = 0.8, 
                       weight = 1, 
                       popup = ~School_Name,
                       group = "schoolMarkers") %>% 
      addLegend("bottomleft", pal = pal2, values = colorData, 
                title = colorBy, 
                layerId="colorLegend")
  })
})