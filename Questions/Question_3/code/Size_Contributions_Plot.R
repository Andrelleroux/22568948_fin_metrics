library(tidyverse)
library(RcppRoll)
library(RColorBrewer)

Size_Contributions_Plot <- function(data = Joined_df){

    agg_data <- data %>%
        filter(!is.na(Index_Name)) %>%
        mutate(Year_Month = format(date, "%Y%B")) %>%
        arrange(date) %>%
        group_by(Index_Name, Fund, Year_Month) %>%
        filter(date == max(date)) %>%
        ungroup() %>%
        group_by(date, Index_Name, Fund) %>%
        summarise(Total_Contribution = sum(Contribution, na.rm = TRUE)) %>%
        arrange(date) %>% group_by(Index_Name, Fund) %>%
        mutate(Roll_Contributions = roll_prod(1 + Total_Contribution, 24, fill = NA, align = "right")^(12/24) - 1) %>%
        ungroup() %>%
        filter(!is.na(Roll_Contributions))

    Size_Plot <- ggplot(agg_data, aes(x = date, y = Roll_Contributions, colour = Index_Name)) +
        geom_line(alpha = 1) +
        facet_wrap(~ Fund) +
        scale_fill_brewer(palette = "Dark2") +
        labs(
            title = "24 Month Rolling Contributions of Different Cap Sizes to Portfolio Returns",
            x = "",
            y = "Contribution to Portfolio Returns",
            fill = "Market Cap Size"
        ) +
        theme_minimal() +
        theme(
            legend.position = "bottom",
            strip.text = element_text(size = 12, face = "bold")
        )

    return(Size_Plot)

}