library(tidyverse)
library(RcppRoll)

Rolling_Vol_plot <- function(dataset = Combined_df){

    Plot_3 <- Combined_df %>%
        group_by(Fund) %>%
        mutate(Roll_Vol = roll_sd(1 + Returns, 36, fill = NA, align = "right")^(12/36) - 1) %>%
        group_by(date) %>%
        filter(any(!is.na(Roll_Vol))) %>% ggplot() +
        geom_line(aes(date, Roll_Vol, color = Fund, size = Fund), alpha = 0.8) +
        scale_size_manual(values = c("Best" = 0.3, "Worst" = 0.3,
                                     "Q1" = 0.3, "Q3" = 0.3,
                                     "AI" = 1.2, "BM" = 1.2,
                                     "Median" = 1.2))+
        labs(title = " Rolling 3 Year Annualized Standard Deviation",
             subtitle = "", x = "", y = "Rolling 3 year Standard Deviation"
        ) + fmxdat::theme_fmx()

    return(Plot_3)

}