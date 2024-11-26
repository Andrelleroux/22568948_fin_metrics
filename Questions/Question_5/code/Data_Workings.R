library(tidyverse)

Data_Workings <- function(data = ""){

    cncy <- read_rds("data/currencies.rds")
    cncy_Carry <- read_rds("data/cncy_Carry.rds")
    cncy_value <- read_rds("data/cncy_value.rds")
    cncyIV <- read_rds("data/cncyIV.rds")
    bbdxy <- read_rds("data/bbdxy.rds")

    Currencies_df <- cncy %>% group_by(Name) %>%
        mutate(ROC = log(Price) - lag(log(Price))) %>%
        filter(!is.na(ROC)) %>%
        mutate(Name = gsub("\\_Cncy", "", Name)) %>%
        mutate(Name = gsub("\\_Inv", "", Name))

}