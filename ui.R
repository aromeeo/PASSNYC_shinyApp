dashboardPage(
  skin = "black",
  dashboardHeader(title = "NYCDOE Schools", titleWidth = 300),
  dashboardSidebar(width = 150,    
    sidebarMenu(
      id = "sideMenu",
      menuItem("Welcome Page", tabName = "welcomePage"),
      menuItem("Schools Map", tabName = "schoolsMap", icon = icon("map")),
      menuItem("Correlations", tabName = "correlations", icon = icon("signal")),
      menuItem("SHSAT EDA", tabName = "shsat", icon = icon("graduation-cap")),
      menuItem("Data Explorer", tabName = "data", icon = icon("table")))
    ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "welcomePage",
              fluidRow(
                column(width = 4,
                       box(width = 12,
                           status = "success",
                           solidHeader = TRUE,
                           title = "A Return to School",
                           collapsibile = TRUE, collapsed = FALSE,
                           includeMarkdown("welcomePage.md")
                       ),
                       box(width = 12,
                           solidHeader = TRUE,
                           color = "navy",
                           title = "Who is 'PASSNYC' ?",
                           collapsible = TRUE, collapsed = FALSE,
                           includeMarkdown("PASSNYC.md")
                       )
                ),
                column(width = 8,
                       box(
                         width = 12,
                         status = "success",
                         solidHeader = TRUE,
                         title = "Relevant Information",
                         collapsible = TRUE, collapsed = FALSE,
                         includeMarkdown("relevant.md")
                       ))
              )
      ),
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
                         checkboxInput("checkbox", label = "Schools Taking SHSAT", value = TRUE),
                         actionButton(inputId='ab1', label="Learn More About A School", 
                                      icon = icon("Question"), 
                                      onclick =
                                        "window.open('https://www.schools.nyc.gov/find-a-school?keyword=&grade_levels=&school_borough=&pg=12', '_blank')")
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
                       box(width = NULL, height = 650,
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
              )
      )
    )
  )
)
