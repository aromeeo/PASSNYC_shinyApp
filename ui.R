dashboardPage(
  skin = "black",
  dashboardHeader(title = "NYC DOE Schools", titleWidth = 150),
  dashboardSidebar(width = 150,    
    sidebarMenu(
      menuItem("Schools Map", tabName = "schoolsMap", icon = icon("map")),
      menuItem("Correlations", tabName = "correlations", icon = icon("signal")),
      menuItem("SHSAT EDA", tabName = "shsat", icon = icon("graduation-cap")),
      menuItem("Data Explorer", tabName = "data", icon = icon("table")))
    ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "schoolsMap",
              fluidRow(
                column(width = 8,
                       box(width = NULL,
                           leafletOutput("schoolsMap", height = 500)
                       )
                ),
                column(width = 4,
                       box(width = NULL,
                         h2("Demographics Explorer"),
                         selectInput("size", h4("Size"), stat, selected = "School_Income_Estimate"),
                         selectInput("color", h4("Color"), stat2, selected = "Economic_Need_Index"),
                         checkboxInput("checkbox", label = "Schools Taking SHSAT", value = TRUE)
                         )
                )
              )
      ),
      tabItem(tabName = "correlations",
              fluidRow(
                column(width = 8, 
                       box(width = NULL, height = 650,
                           plotlyOutput("heat")
                       )
                ),
                column(width = 4, 
                       box(width = NULL,
                         plotlyOutput("corrs")
                       )
                )
              )
      ),
      tabItem(tabName = "shsat",
              fluidRow(
                column(width = 6,
                       box(width = NULL,
                           DT::dataTableOutput("allshsat")
                       )
                ),
                column(width = 6,
                       box(width = NULL,
                           plotlyOutput("shsat_dist")
                       )
                )
              )
      ),
      tabItem(tabName = "data",
              fluidRow(
                column(width = 9,
                       DT::dataTableOutput("passNYC")
                )
                # column(width = 3,
                #        DT::dataTableOutput("shsat"))
              )
      )
    )
  )
)
