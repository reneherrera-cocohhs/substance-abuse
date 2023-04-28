# Prepare the pin board for use

# Setup ####
# load package libraries #### 
library(here) # project oriented workflow
library(pins) # data access
library(tidyverse)

# Pins ####
substance_abuse_pb <- board_folder("S:/HIPAA Compliance/substance-abuse")

substance_abuse_pb %>%
  pin_list()

# Hospital discharge data #### 
hdd_pb <- board_folder("S:/HIPAA Compliance/Hospital Discharge Data/r-pin-board-rds-files/")

hdd_pb %>%
  pin_list()

# the one we want is: 
# "hdd_2015_2021_transformed"

# hdd_df <- hdd_df %>% 
#   pin_read(
#   name = "hdd_2015_2021_transformed"
# )

# Vital statistics and mortality data ####
mortality_pb <- board_folder("S:/HIPAA Compliance/SAS Files/Coconino Deaths/mortality-data")

mortality_pb %>%
  pin_list()

# The one we want is: 
# "mortality-data-tidy-transformed-2010-2023"

# mortality_df <- mortality_pb %>%
#   pin_read(
#     name = "mortality-data-tidy-transformed-2010-2023"
#   )
  
# ESSENCE Syndromic surveillance #### 



# # The pins package helps you publish data sets, models, and other R objects, making it easy to share them across projects and with your colleagues.
# # create a pin board ####
# # here for now, need to consider where the best place for this should really be
# sa_pins <- board_folder("S:/HIPAA Compliance/SAS Files/Coconino Deaths/Substance Abuse/data-raw")
# 
# # list the pins located on the pin board ####
# sa_pins %>%
#   pin_list()
# 
# # hospital discharge data ####
# hdd_pins <- board_folder("S:/HIPAA Compliance/Hospital Discharge Data/r-pin-board-rds-files")
# 
# # list the pins located on the pin board 
# hdd_pins %>%
#   pin_list()
# 
# # check which board?
# pin_meta(board = hdd_pins, name = "hdd_2015_2021_transformed")
# 
# # read hdd to environment 
# hdd_df <- hdd_pins %>%
#   pin_read(name = "hdd_2015_2021_transformed")
# 
# # read icd-10 codes to environment
# icd10 <- sa_pins %>%
#   pin_read(name = "icd_10_codes")
# 
# icd10 <- icd10 %>%
#   paste(collapse = "|")
# 
# # inspect hdd
# glimpse(hdd_df)
# 
# # TESTING & Exploratory Analysis #### 
# # count of hospitals by year 
# library(janitor)
# count(hdd_df, discharge_year)
# 
# # count and percentage 
# hdd_df %>%
#   tabyl(discharge_year)
# 
# # generate a sequence of numbers
# seq(2017,2021,1)
# 
# # subset to diagnosis codes matching substance abuse 
# hdd_df_sa <- hdd_df %>%
#   filter( # most recent five years 
#     discharge_year %in% seq(2017,2021,1)
#   ) %>%
#   mutate( # create new logical variable
#     substance_abuse = if_any(contains("diagnosis"), ~str_detect(.x, icd10))
#     # substance_abuse = if_any(everything(), ~str_detect(.x, icd10))
#   ) %>%
#   filter(substance_abuse == TRUE)
# 
# # subset where diagnosis codes match opioid
# hdd_df_opioid <- hdd_df %>%
#   filter(
#     discharge_year %in% seq(2017,2021,1)
#   ) %>%
#   mutate(
#     opioid = if_any(contains("diagnosis"), ~str_detect(.x, "t40"))
#   ) %>%
#   filter(opioid == TRUE)
# 
# # inspect 
# glimpse(hdd_df_opioid)
# 
# # subset where diagnosis codes match fentanyl
# hdd_df_fentanyl <- hdd_df_sa %>%
#   mutate(
#     fentanyl = if_any(contains("diagnosis"), ~str_detect(.x, "t404"))
#   ) %>%
#   filter(fentanyl == TRUE) 
# 
# # query where age is less than 18 years 
# hdd_df_fentanyl %>%
#   filter(age_calc < 18) %>%
#   glimpse()
# 
# # query hdd where diagnosis contains opioid 
# hdd_df %>%
#   filter(
#     discharge_year %in% seq(2017,2021,1)
#   ) %>%
#   filter(if_any(contains("diagnosis"), ~str_detect(.x, "t40")))
# 
# # query hdd where any variable contains "veteran"
# hdd_df %>%
#   filter(
#     discharge_year %in% seq(2017,2021,1)
#   ) %>%
#   filter(if_any(everything(), ~str_detect(.x, "veteran")))
# 
# # query hdd where any variable contains "military"
# hdd_df %>%
#   filter(
#     discharge_year %in% seq(2017,2021,1)
#   ) %>%
#   filter(if_any(everything(), ~str_detect(.x, "military"))) %>%
#   glimpse()
# 
# # 