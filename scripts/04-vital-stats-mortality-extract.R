# Setup ####
# load packages
library(here) # project oriented workflow
library(pins) # data access
library(tidyverse)
library(janitor)
library(rlang)
library(lubridate)

# source the R script that reads the pin boards
source(
  file = "scripts/01-setup-pin-board.R",
  echo = TRUE
)

# Pins ####
# The pins package helps you publish data sets, models, and other R objects, making it easy to share them across projects and with your colleagues.

# mortality_pb <- board_folder("S:/HIPAA Compliance/SAS Files/Coconino Deaths/mortality-data")

# list the pins located on the pin board ####
mortality_pb %>%
  pin_list()

# check which board?
pin_meta(
  board = mortality_pb, 
  name = "mortality-data-tidy-transformed-2010-2023"
)

# read pin data to environment 
mortality_df <- mortality_pb %>%
  pin_read("mortality-data-tidy-transformed-2010-2023")

# inspect the data 
glimpse(mortality_df)

# inspect count of death by year 
mortality_df %>%
  tabyl(death_book_year, d_substance_abuse)

mortality_df %>%
  tabyl(death_book_year, d_substance_abuse, cdc_mannerofdeath_desc)

# check for dummy variables 
mortality_df %>%
  select(starts_with("d_")) %>%
  names()

# substance abuse variables ####
substance_abuse_var <- c(
  "d_substance_abuse",
  "d_alcohol",
  "d_opioids",
  "d_opioids_rx",
  "d_heroin",
  "d_poly"
)

# check for opioid variables
mortality_df %>%
  select(contains("opioid")) %>%
  names()

# opioid variables ####
var_opioids <- c(
  "d_opioids",
  "d_opioids_rx",
  "d_heroin",
  "d_opioids_any"
)

####
# opioid deaths in recent years? ####
# subset filter to 2019-2021

# mortality_opioid_hist <- mortality_df %>%
#   filter(
#     death_book_year %in% as.character(seq(2019, 2021, 1))
#   )
# 
# mortality_opioid_hist
# 
# 
# table_function <- function(x){
#   mortality_df %>%
#     tabyl(death_book_year, !!sym(x)) %>%
#     mutate(rate_per_1k = (1000*(`TRUE`/(`TRUE`+`FALSE`))))
#   
#   
# }
# 
# table_function(x = "d_substance_abuse")
# 
# map(
#   .x = substance_abuse_var,
#   .f = ~table_function
# ) %>%
#   map(.f = ~write_rds)

# substance abuse ####
# if any substance is detected in icd or cause of death variables then substance abuse
table_substance_abuse <- mortality_df %>%
  tabyl(death_book_year, d_substance_abuse) %>%
  mutate(rate_x_1k_deaths = (1000*(`TRUE`/(`TRUE`+`FALSE`))),
         total = `TRUE`+`FALSE`)

# save to disk 
table_substance_abuse %>%
  write_rds(
    file = "data-tidy/table-substance-abuse.rds"
  )

# alcohol ####
# if any alcohol is detected in icd or cause of death variables then substance abuse
table_alcohol <- mortality_df %>%
  tabyl(death_book_year, d_alcohol) %>%
  mutate(rate_x_1k_deaths = (1000*(`TRUE`/(`TRUE`+`FALSE`))),
         total = `TRUE`+`FALSE`)

# save to disk 
table_alcohol %>%
  write_rds(
    file = "data-tidy/table_alcohol.rds"
  )

# opioids ####
# if any opioids is detected in icd or cause of death variables then substance abuse
table_opioid <- mortality_df %>%
  tabyl(death_book_year, d_opioids) %>%
  mutate(rate_x_1k_deaths = (1000*(`TRUE`/(`TRUE`+`FALSE`))),
         total = `TRUE`+`FALSE`)

# save to disk 
table_opioid %>%
  write_rds(
    file = "data-tidy/table_opioid.rds"
  )

# d_opioids_rx ####
# if any opioids is detected in icd or cause of death variables then substance abuse
table_opioid_rx <- mortality_df %>%
  tabyl(death_book_year, d_opioids_rx) %>%
  mutate(rate_x_1k_deaths = (1000*(`TRUE`/(`TRUE`+`FALSE`))),
         total = `TRUE`+`FALSE`)

# save to disk 
table_opioid_rx %>%
  write_rds(
    file = "data-tidy/table_opioid_rx.rds"
  )

# d_non_opioids_rx ####
# if any opioids is detected in icd or cause of death variables then substance abuse
table_opioid_non_rx <- mortality_df %>%
  tabyl(death_book_year, d_non_opioids_rx) %>%
  mutate(rate_x_1k_deaths = (1000*(`TRUE`/(`TRUE`+`FALSE`))),
         total = `TRUE`+`FALSE`)

# save to disk 
table_opioid_non_rx %>%
  write_rds(
    file = "data-tidy/table_opioid_non_rx.rds"
  )

# poly ####
# if any opioids is detected in icd or cause of death variables then substance abuse
table_poly <- mortality_df %>%
  tabyl(death_book_year, d_poly) %>%
  mutate(rate_x_1k_deaths = (1000*(`TRUE`/(`TRUE`+`FALSE`))),
         total = `TRUE`+`FALSE`)

# save to disk 
table_poly %>%
  write_rds(
    file = "data-tidy/table_poly.rds"
    )

# five recent years
recent_years <- seq(
  year(today())-5,
  year(today()),
  1
) %>%
  as.character()

# Youth substance abuse 
mortality_df %>%
  mutate(
    d_age_youth = if_else(
      condition = calc_age < 18,
      true = TRUE,
      false = FALSE
    )
  ) %>%
  # filter(death_book_year %in% recent_years) %>%
  tabyl(d_age_youth, d_opioids) %>%
  adorn_title()

  

# # add new variables to indicate:
# # - overdose
# # - opioid
# 
# # new variable to flag overdose death 
# mortality_df <- mortality_df %>%
#   mutate(
#     d_overdose = str_detect(string = method_code_cdc, pattern = "overdose"))
# 
# # inspect
# mortality_df %>%
#   tabyl(date_of_death_year, overdose)
# 
# # new variable to flag opioid related death 
# # first select variables to query for relevant icd10 codes
# var_icd <- c(
#   mortality_df %>%
#     select(contains("icd")) %>%
#     names(),
#   mortality_df %>%
#     select(contains("cod_")) %>%
#     names(),
#   mortality_df %>%
#     select(contains("_cause")) %>%
#     names(),
#   mortality_df %>%
#     select(contains("cdc")) %>%
#     names()
#   )
# 
# # source script to read in icd10 codes 
# source(file = "scripts/icd-10-codes-to-assess-opioid-related-deaths.R")
# 
# # create variables as described above 
# mortality_df <- mortality_df %>%
#   mutate(
#     opioid_accident = if_any(contains(var_icd), ~str_detect(.x, icd_ap_uc)),
#     opioid_homicide = if_any(contains(var_icd), ~str_detect(.x, icd_homicide)),
#     opioid_suicide = if_any(contains(var_icd), ~str_detect(.x, icd_suicide)),
#     opioid_undetermined = if_any(contains(var_icd), ~str_detect(.x, icd_undetermined))
#   ) %>%
#   mutate(
#     opioid = case_when(
#       opioid_accident == TRUE ~ TRUE,
#       opioid_homicide == TRUE ~ TRUE,
#       opioid_suicide == TRUE ~ TRUE,
#       opioid_undetermined == TRUE ~ TRUE,
#       TRUE ~ FALSE
#     )
#   ) 
# 
# # 
# mortality_df %>%
#   tabyl(date_of_death_year, opioid)

# save to pin board 
# create new board 
substance_abuse_pb <- board_folder("S:/HIPAA Compliance/SAS Files/Coconino Deaths/Substance Abuse/data")

# save 
substance_abuse_pb %>%
  pin_write(
    x = mortality_df,
    name = "azdhs_mortality_extract_substance_abuse",
    type = "rds",
    title = "AZDHS Mortality Extract with extra substance abuse variables",
    description = "Additional variables were added to the dataset",
    metadata = list(
      owner = "Coconino HHS",
      department = "Epidemiology",
      user = "rherrera"
    )
  )
