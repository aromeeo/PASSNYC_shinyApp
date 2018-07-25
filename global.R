library(dplyr)
library(tidyr)
library(readr)
library(DT)
library(leaflet)
library(plotly)
library(shinydashboard)

# load PassNYC data
passnyc <- read_csv("passnyc.csv")

# load D5 SHSAT sata
shsat <- read_csv("D5 SHSAT Registrations and Testers.csv")

#icon maker for SHSAT schools
schoolIcons <- awesomeIcons(
  icon = "graduation-cap",
  iconColor = "blue",
  library = "fa"
)

# students who took SHSAT
took <- shsat %>% 
  group_by(`School name`) %>% 
  select(`Number of students who took the SHSAT`) %>% 
  summarise(total_took = sum(`Number of students who took the SHSAT`)) %>% 
  arrange(desc(total_took))

# students who registered
registered <- shsat %>% 
  group_by(`School name`) %>% 
  select(`Number of students who registered for the SHSAT`) %>% 
  summarise(total_reg = sum(`Number of students who registered for the SHSAT`)) %>% 
  arrange(desc(total_reg))

#merge both took and registered
all_shsat <- left_join(registered, took, by = "School name")

#joined csv containing SHSAT schools and their stats from passnyc
df <- inner_join(passnyc, shsat, by = c("Location_Code" = "DBN"))

# coordinates of shsat schools
shsat_coords <- df %>% 
  select(School_Name, Latitude, Longitude)


#GeoJSON containig DOE districts -- I didn't use this, it was ugly.
#nyc_districts <- readOGR("schoolDistricts.geojson", "OGRGeoJSON", verbose = F)

# create variable with colnames as choice
vars <- c("Average School Income", "Economic Need Index")
stat <- c(
  "Percent Asian" = "Percent_Asian",
  "Percent Black" = "Percent_Black",
  "Percent ELL" = "Percent_ELL",
  "Percent Hispanic" = "Percent_Hispanic",
  "Percent White" = "Percent_White",
  "Economic Need Index" = "Economic_Need_Index",
  "School Income Estimate" = "School_Income_Estimate")
stat2 <- c(
  "Percent Asian" = "Percent_Asian",
  "Percent Black" = "Percent_Black",
  "Percent ELL" = "Percent_ELL",
  "Percent Hispanic" = "Percent_Hispanic",
  "Percent White" = "Percent_White",
  "Economic Need Index" = "Economic_Need_Index",
  "School Income Estimate" = "School_Income_Estimate"
)

# calculate correlationss for features
passnyc %>% 
  select(10:20, 22, 24, 26, 28, 30, 33, 34) %>% 
  na.omit() -> features

correlation <- round(cor(features), 3)
nms <- names(features)


# calculate medians of demographics per district
passnyc %>%
  group_by(District) %>%
  summarise(med_EcoIndex = median(Economic_Need_Index, na.rm = TRUE),
            med_AvgIncome = median(School_Income_Estimate, na.rm = TRUE),
            med_Hisp = median(Percent_Hispanic, na.rm = TRUE)) -> medians

# # create df for proficiency by race -- not used -- misleading
# passnyc %>% 
#   select(School_Name, Asian = Percent_Asian, Black = Percent_Black, 
#          Hispanic = Percent_Hispanic, White = Percent_White, 
#          Average_ELA_Proficiency, Average_Math_Proficiency) %>% 
#   gather(key = 'race', value = 'score', 
#          Asian, White, Black, Hispanic) -> subject_scores

