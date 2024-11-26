library(tidyverse)
library(RcppRoll)
library(RColorBrewer)

Sector_Contributions_Plot <- function(data = Joined_df){

    agg_data <- data %>%
        mutate(Year_Month = format(date, "%Y%B")) %>%
        arrange(date) %>%
        group_by(Sector, Fund, Year_Month) %>%
        filter(date == max(date)) %>%
        ungroup() %>%
        group_by(date, Sector, Fund) %>%
        summarise(Total_Contribution = sum(Contribution, na.rm = TRUE)) %>%
        arrange(date) %>% group_by(Sector, Fund) %>%
        mutate(Roll_Contributions = roll_prod(1 + Total_Contribution, 24, fill = NA, align = "right")^(12/24) - 1) %>%
        ungroup() %>%
        filter(!is.na(Roll_Contributions))

    Sector_Plot <- ggplot(agg_data, aes(x = date, y = Roll_Contributions, colour = Sector)) +
        geom_line(alpha = 1) +
        facet_wrap(~ Fund) +
        scale_fill_brewer(palette = "Dark2") +
        labs(
            title = "24 Month Rolling Contribution of Each Sector to Portfolio Returns",
            x = "",
            y = "Contribution to Portfolio Returns",
            fill = "Sector"
        ) +
        theme_minimal() +
        theme(
            legend.position = "bottom",
            strip.text = element_text(size = 12, face = "bold")
        )

    return(Sector_Plot)

}