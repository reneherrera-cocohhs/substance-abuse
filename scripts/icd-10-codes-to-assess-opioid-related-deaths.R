# package libraries 
library(here)
library(tidyverse)

# icd-10 codes for opioid related deaths, underlying cause of death, contributing cause of death
# source: https://mnprc.org/wp-content/uploads/2019/01/using-icd-10-codes-to-assess-opioid-related-overdose-deaths.pdf
# accidental poisoning ####
icd_ap_uc <- c(
    "x40", # Accidental poisoning by and exposure to non-opioid analgesics, antipyretics and anti-rheumatics
    "x41", # Accidental poisoning by and exposure to antiepileptic, sedative-hypnotic, anti-parkinsonism and psychotropic drugs, not elsewhere classified
    "x42", # Accidental poisoning by and exposure to narcotics and psychodysleptics [hallucinogens], not elsewhere classified
    "x43", # Accidental poisoning by and exposure to other drugs acting on the autonomic nervous system
    "x44", # Accidental poisoning by and exposure to other and unspecified drugs, medicaments and biological substances
    "t40.0", # Poisoning by Opium
    "t40.1", # Poisoning by Heroin
    "t40.2", # Poisoning by Other Opioids
    "t40.3", # Poisoning by Methadone
    "t40.4", # Poisoning by Other Synthetic Narcotics
    "t40.6" # Poisoning by Other and Unspecified Narcotics
    ) %>%
    str_to_lower() %>%
    str_remove("[:punct:]")

# intentional self-poisoning (suicide) ####
icd_suicide <- c(
    "X60", # Intentional self-poisoning by and exposure to non-opioid analgesics, antipyretics and anti-rheumatics
    "X61", # Intentional self-poisoning by and exposure to antiepileptic, sedative-hypnotic, anti-parkinsonism and psychotropic drugs, not elsewhere classified
    "X62", # Intentional self-poisoning by and exposure to narcotics and psychodysleptics [hallucinogens], not elsewhere classified
    "X63", # Intentional self-poisoning by and exposure to other drugs acting on the autonomic nervous system
    "X64", # Intentional self-poisoning by and exposure to other and unspecified drugs, medicaments and biological substances
    "T40.0", # Poisoning by Opium
    "T40.1", # Poisoning by Heroin
    "T40.2", # Poisoning by Other Opioids
    "T40.3", # Poisoning by Methadone
    "T40.4", # Poisoning by Other Synthetic Narcotics
    "T40.6" # Poisoning by Other and Unspecified Narcotics
    ) %>%
    str_to_lower() %>%
    str_remove("[:punct:]")

# Assault (Homicide) ####
icd_homicide <- c(
    "X85", # Assault by drugs, medicaments and biological substances
    "T40.0", # Poisoning by Opium
    "T40.1", # Poisoning by Heroin
    "T40.2", # Poisoning by Other Opioids
    "T40.3", # Poisoning by Methadone
    "T40.4", # Poisoning by Other Synthetic Narcotics
    "T40.6" # Poisoning by Other and Unspecified Narcotics
    ) %>%
    str_to_lower() %>%
    str_remove("[:punct:]")

# Poisoning, # Undetermined Intent ####
icd_undetermined <- c(
    "Y10", # Poisoning by and exposure to non-opioid analgesics, antipyretics and anti-rheumatics, undetermined intent
    "Y11", # Poisoning by and exposure toantiepileptic, sedative-hypnotic,antiparkinsonism and psychotropic drugs,not elsewhere classified, undetermined intent
    "Y12", # Poisoning by and exposure to narcotics and psychodysleptics [hallucinogens], not elsewhere classified, undetermined intent
    "Y13", # Poisoning by and exposure to other drugs acting on the autonomic nervous system, undetermined intent
    "Y14", # Poisoning by and exposure to other and unspecified drugs, medicaments and biological substances, undetermined intent
    "T40.0", # Poisoning by Opium
    "T40.1", # Poisoning by Heroin
    "T40.2", # Poisoning by Other Opioids
    "T40.3", # Poisoning by Methadone
    "T40.4", # Poisoning by Other Synthetic Narcotics
    "T40.6" # Poisoning by Other and Unspecified Narcotics
    ) %>%
    str_to_lower() %>%
    str_remove("[:punct:]")
