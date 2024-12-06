library(tidyverse)

Data_Workings <- function(data = ""){

    setwd("~/Masters_2024_stuff/Financial_Econometrics/Fin_Metrics_Exam/22568948_fin_metrics/Questions/Question_5")

    cncy <- read_rds("data/currencies.rds")
    cncy_value <- read_rds("data/cncy_value.rds")
    cncyIV <- read_rds("data/cncyIV.rds")


    Currencies_df <- cncy %>% group_by(Name) %>%
        mutate(ROC = log(Price) - lag(log(Price))) %>%
        filter(!is.na(ROC)) %>%
        mutate(Name = gsub("\\_Cncy", "", Name)) %>%
        mutate(Name = gsub("\\_Inv", "", Name))

    return(Currencies_df)
}