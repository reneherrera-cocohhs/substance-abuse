# Introduction #### 
# query essence api for
# total ed visits (the denominator)
# and the following numerators/denominators (for rate)
# overdose - opioid and alcohol
# overdose - by sex 
# overdose - by age 
# overdose - by hospital 
# overdose - by race 


# Setup #### 
# package libraries 
library(here)
library(tidyverse)
library(Rnssp)
library(janitor)
library(lubridate)

# set Rnnsp credentials
myProfile <- Credentials$new(
  username = askme("Enter your username: "),
  password = askme()
)

# function to query the essence api for counts
query_essence_data_details <- function(x){
  # set url 
  url <- x
  
  # query ESSENCE 
  api_data <- get_api_data(url)
  
  # check variable names 
  names(api_data)
  
  # create a tidy data table 
  api_data_cts <- api_data$dataDetails %>%
    clean_names() %>%
    as_tibble() %>%
    mutate(
      date = mdy(date)
    ) %>%
    mutate(
      across(where(is.character), str_to_lower)
    )
}

Sys.Date()

opioid_facility <- query_essence_data_details(
  "https://essence.syndromicsurveillance.org/nssp_essence/api/dataDetails?endDate=31Dec2023&ddInformative=1&geography=15919&geography=33622&geography=33177&percentParam=noPercent&datasource=va_hosp&admissionTypeCategory=e&startDate=1Sep2021&medicalGroupingSystem=essencesyndromes&userId=4887&aqtTarget=DataDetails&ddAvailable=1&ccddCategory=cdc%20opioid%20overdose%20v3&geographySystem=hospital&detector=probrepswitch&timeResolution=daily&patientLoc=az_coconino&hasBeenE=1"
)

glimpse(opioid_facility)

opioid_facility %>%
  distinct(hospital_name)

tab_opioid_page <- opioid_facility %>%
  filter(hospital_name == "az-banner page hospital") %>%
  group_by(date) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  complete(
    date = seq.Date(
      date("2021-09-01"), 
      date(Sys.Date()), 
           by = "day"
    ),
    fill = list(n = 0),
    explicit = FALSE
  ) %>%
  mutate(
    hospital_name = "az-banner page hospital"
  )

tab_opioid_fmc <- opioid_facility %>%
  filter(hospital_name == "az-flagstaff medical center") %>%
  group_by(date) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  complete(
    date = seq.Date(
      date("2021-09-01"), 
      date(Sys.Date()), 
      by = "day"
    ),
    fill = list(n = 0),
    explicit = FALSE
  ) %>%
  mutate(
    hospital_name = "az-flagstaff medical center"
  )

tab_opioid_tcrhc <- opioid_facility %>%
  filter(hospital_name == "az-tuba city regional health care corporation") %>%
  group_by(date) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  complete(
    date = seq.Date(
      date("2021-09-01"), 
      date(Sys.Date()), 
      by = "day"
    ),
    fill = list(n = 0),
    explicit = FALSE
  ) %>%
  mutate(
    hospital_name = "az-tuba city regional health care corporation"
  )

install.packages("incidence2")
library(incidence2)

opioid_facility %>%
  group_by(hospital_name, date) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  incidence(
    date_index = date,
    groups = hospital_name,
    interval = "month"
  )
  
  ggplot() +
  geom_line(
    mapping = aes(
      x = date,
      y = n,
      group = hospital_name,
      color = hospital_name
    )
  )

write_csv(
  x = tab_opioid,
  file = "data-tidy/table-opioid-overdose.csv"
)

opioid_facility %>%
  # filter(date > as.Date("2021-09-01")) %>%
  ggplot() +
  geom_bar(
    mapping = aes(
      x = month_year,
      fill = hospital_name
    )
  )

alcohol_facility <- query_essence_data_details(
  "https://essence.syndromicsurveillance.org/nssp_essence/api/dataDetails?endDate=31Dec2023&ddInformative=1&geography=15919&geography=33622&geography=33177&percentParam=noPercent&datasource=va_hosp&admissionTypeCategory=e&startDate=1Sep2021&medicalGroupingSystem=essencesyndromes&userId=4887&aqtTarget=DataDetails&ddAvailable=1&ccddCategory=cdc%20alcohol%20v1&geographySystem=hospital&detector=probrepswitch&timeResolution=daily&patientLoc=az_coconino&hasBeenE=1"
)

glimpse(alcohol_facility)

alcohol_facility %>%
  # filter(date > as.Date("2021-09-01")) %>%
  ggplot() +
  geom_bar(
    mapping = aes(
      x = month_year,
      fill = hospital_name
    )
  )

