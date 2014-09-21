library(shiny)
library(dplyr)

shinyServer(function(input, output, session) {

    output$stationtable <- renderDataTable({
        stnstable %.%
            filter(
                #is.null(input$statelist) | State %in% input$statelist
                State %in% input$statelist
            )
    })
    
    output$tempGraph <- renderPlot({
        # If no states selected don't graph the whole country
        if (is.null(input$statelist))
            return(NULL)

          stl <- input$statelist
          sdt <- input$datrng[1]
          edt <- input$datrng[2]
        
        statset <- stns[stns$state %in% stl,"id"]
        
        select <- (meas$id %in% statset) &
                  (meas$elem == "TMAX") &
                  (meas$time >= sdt) &
                  (meas$time <= edt)
        
        # no records in range, no graph
        if(!sum(select))
            return(NULL)
        
        maxTemp <- meas[select,]
        meanMax <- aggregate(value ~ time,data=maxTemp,mean)
        meanMax$value <- (meanMax$value/10) * (9/5) + 32
        
        select <- (meas$id %in% statset) &
          (meas$elem == "TMIN") &
          (meas$time >= input$datrng[1]) &
          (meas$time <= input$datrng[2])
        minTemp <- meas[select,]
        meanMin <- aggregate(value ~ time,data=minTemp,mean)
        meanMin$value <- (meanMin$value/10) * (9/5) + 32
        
        plot(meanMax$time,meanMax$value,type="l",
             main = "Mean Temperature (selected stations)",
             xlab = "Year",
             ylab = "Temp (F)",
             xlim = range(meanMax$time,meanMin$time),
             ylim = range(meanMax$value,meanMin$value),
             col = 'red')
        lines(meanMin$time,meanMin$value,type="l",
              col = 'blue')
    })
    
    output$rainGraph <- renderPlot({
        # If no states selected don't graph the whole country
        if (is.null(input$statelist))
            return(NULL)

        stl <- input$statelist
        sdt <- input$datrng[1]
        edt <- input$datrng[2]
        
        statset <- stns[stns$state %in% stl,"id"]
        
        select <- (meas$id %in% statset) &
          (meas$elem == "PRCP") &
          (meas$time >= sdt) &
          (meas$time <= edt)
        
        # no records in range, no graph
        if(!sum(select))
          return(NULL)
        
        precip <- meas[select,]
        meanPrcp <- aggregate(value ~ time,data=precip,mean)
        meanPrcp$value <- (meanPrcp$value/1000) * 2.54

        plot(meanPrcp$time,meanPrcp$value,type="l",
             main = "Mean Precipitation (selected stations)",
             xlab = "Year",
             ylab = "Rain (in.)",
             xlim = range(meanPrcp$time),
             ylim = range(meanPrcp$value),
             col = 'green')
    })
})