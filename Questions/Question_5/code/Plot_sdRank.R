library(tidyverse)

Plot_sdRank <- function(data = Currencies_df){

    Plot_1_sdRank <- Currencies_df %>%
        filter(date >= (last(date)-years(5))) %>%
        group_by(Name) %>%
        summarise(Vol_est = sd(ROC, na.rm = TRUE)) %>%
        arrange(desc(Vol_est)) %>%
        ggplot(aes(x = reorder(Name, -Vol_est), y = Vol_est, fill = Name == "SouthAfrica")) +
        geom_bar(stat = "identity", show.legend = F) +
        fmxdat::theme_fmx() +
        labs(title = "Currency Volatility Over the Past 5 Years",
             x = "Currency",
             y = "Volatility (Standard Deviation of the Rate of Change)") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))


    return(Plot_1_sdRank)

}