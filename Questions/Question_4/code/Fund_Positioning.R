library(tidyverse)
library(zoo)
library(RcppRoll)

Relative_Performance <- function(){

    setwd("~/Masters_2024_stuff/Financial_Econometrics/Fin_Metrics_Exam/22568948_fin_metrics/Questions/Question_4")

    Port_Rets <- read_rds("data/Fund_Rets.rds")
    BM_Rets <- read_rds("data/BM_Rets.rds")

    # Merge the two data frames by date
    df <- Port_Rets %>%
        left_join(., BM_Rets, by = "date") %>%
    #Excess Returns
        mutate(Excess_Returns = Returns - BM)

    # Calculate rolling mean and standard deviation of excess returns
    rolling_window <- 12
    df <- df %>%
        mutate(
            Rolling_Mean = rollmean(Excess_Returns, rolling_window, fill = NA, align = "right"),
            Rolling_SD = rollapply(Excess_Returns, rolling_window, sd, fill = NA, align = "right"),
            Information_Ratio = Rolling_Mean / Rolling_SD  # Calculate IR
        ) %>% filter(!is.na(Rolling_Mean))

    # Plot the rolling Information Ratio
    Plot_Info <- ggplot(df, aes(x = date, y = Information_Ratio)) +
            geom_line(color = "darkgreen", size = 1) +
            labs(
                title = "1 Year Rolling Information Ratio",
                x = "",
                y = "Information Ratio"
            ) +
            fmxdat::theme_fmx()

    return(Plot_Info)

}