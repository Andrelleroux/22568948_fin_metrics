library(tidyverse)

Roll_Vol <- function(data = Joined_Ind_df){

    Plot_Rol_Vol <- data %>%
        mutate(Roll_SD_Hedge = roll_sd(1 + Hedged_Fund, 60, fill = NA, align = "right")*sqrt(12)) %>%
        mutate(Roll_SD_UnHedge = roll_sd(1 + Unhedged_Fund, 60, fill = NA, align = "right")*sqrt(12)) %>%
        filter(!is.na(Roll_SD_Hedge)) %>%
        select(date, Roll_SD_UnHedge, Roll_SD_Hedge) %>%
        pivot_longer(-date,
                     names_to = 'portfolio',
                     values_to = 'Roll_SD') %>%
            ggplot() +
            geom_line(aes(date, Roll_SD, color = portfolio), alpha = 0.7, size = 1.25) +

            labs(title = "Rolling 5 Year Annualized Standard Deviation",
                 subtitle = "Shows a long term rolling average of volatility",
                 x = "", y = "Rolling 5 year SD (Ann.)",
                 caption = "") + fmxdat::theme_fmx()

        return(Plot_Rol_Vol)

}