library(tidyverse)

Sector_Pie <- function(){

    setwd("~/Masters_2024_stuff/Financial_Econometrics/Fin_Metrics_Exam/22568948_fin_metrics/Questions/Question_4")

    Port_Holds <- read_rds("data/Fund_Holds.rds")
    BM_Holds <- read_rds("data/BM_Holds.rds") %>% select(Tickers, Sector) %>%
        unique()

    Plot_1 <- left_join(Port_Holds, BM_Holds, by = "Tickers", relationship = "many-to-many") %>%
        group_by(Sector, date) %>%
        summarise(TotalWeight = sum(Weight), .groups = "drop") %>%
        group_by(date) %>%
        mutate(PercentWeight = TotalWeight / sum(TotalWeight)) %>%
        ggplot(aes(date, PercentWeight, fill = Sector)) +
        geom_area(alpha = 0.7) +
        scale_y_continuous(labels = scales::percent) +
        labs(
            title = "Sector Breakdown Over Time",
            x = "Date",
            y = "Portfolio Share (%)",
            fill = "Sector"
        ) +
        fmxdat::theme_fmx()

    return(Plot_1)




}