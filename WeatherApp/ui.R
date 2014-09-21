
shinyUI(
    fluidPage(
        titlePanel("US Weather History (GSN) (runs slowly)"),
        
        HTML("<a href='./Help.html'>Help</a>"),
        
        column(4,
               wellPanel(
                   selectInput("statelist", "States", c("All states"="", structure(states$code, names=states$name)), multiple=TRUE),
                   dateRangeInput("datrng","Dates",bdate,edate,startview = "year")
               )
        ),
        
        column(9,
               h2("List of Weather Stations"),
               hr(),
               dataTableOutput("stationtable")
        ),
        
        column(6,
               hr(),
               plotOutput("tempGraph",height=300)
        ),
        column(6,
               hr(),
               plotOutput("rainGraph",height=300)
        )
    )
)