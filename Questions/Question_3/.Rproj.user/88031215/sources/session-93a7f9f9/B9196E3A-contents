library(tidyverse)
library(RcppRoll)

Comparison_plot <- function(data = Currencies_df){

    bbdxy <- read_rds("data/bbdxy.rds") %>%
    #Use bbdxy as proxy for Dollar Strength
        mutate(ROC = log(Price)-log(lag(Price))) %>%
        filter(!is.na(ROC)) %>%
        mutate(Name = "US_prox") %>%
        select(date, Name, ROC)


    Plot_data <- Currencies_df %>%
        filter(Name == "SouthAfrica") %>%
        select(date, Name, ROC) %>%
        filter(date > ymd(20050101)) %>%
        rbind(bbdxy) %>%
        mutate(Year_Month = format(date, "%Y%B")) %>%
    #Get last day of each month
        arrange(date) %>%
        group_by(Name, Year_Month) %>%
        filter(date == last(date)) %>%
        ungroup() %>%
    #Calculate Rolling Rate of Change
        mutate(Roll_ROC = roll_prod(1 + ROC, 24, fill = NA, align = "right")^(12/24) - 1) %>%
        filter(!is.na(Roll_ROC)) %>%
        select(date, Name, Roll_ROC)

    mean_ROC_US <- Plot_data %>% filter(Name == "US_prox") %>%
        summarise(Mean = mean(Roll_ROC)) %>% pull(Mean)

    mean_ROC_ZAR <- Plot_data %>% filter(Name == "SouthAfrica") %>%
        summarise(Mean = mean(Roll_ROC)) %>% pull(Mean)

    Above_avg_periods <- Plot_data %>% filter(Name == "US_prox") %>%
        mutate(Above_Avg = if_else(Roll_ROC >= mean_ROC_US, 1, 0)) %>%
        mutate(Group = cumsum(Above_Avg != lag(Above_Avg, default = 0))) %>%
        filter(Above_Avg == 1) %>%
        group_by(Group) %>%
        summarise(Start = min(date), End = max(date)) %>%
        ungroup()

    Plot_Comp <- ggplot() +
        geom_line(data = Plot_data, aes(x = date, y = Roll_ROC, colour = Name)) +
        geom_hline(yintercept = mean_ROC_US, linetype = "dashed", colour = "orange") +
        geom_rect(data = Above_avg_periods, inherit.aes = F,
                  aes(xmin = Start, xmax = End,
                      ymin = -Inf, ymax = Inf),
                  alpha = 0.2, fill = "green") +
        fmxdat::theme_fmx() +
        labs(
            title = "2 Year Rolling Rate of Change",
            y = "Rolling Rate of Change",
            x = ""
        )

    Plot_Comp

}