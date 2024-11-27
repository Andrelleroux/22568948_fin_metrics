library(tidyverse)
library(ggExtra)

Recreate_Plot <- function(data = Joined_df){

    Quadrant_Totals <- Joined_df %>%
        mutate(Quadrant = case_when(
            ROC >= 0 & Returns >= 0 ~ "Pos_Pos",
            ROC >= 0 & Returns < 0 ~ "Pos_Neg",
            ROC < 0 & Returns >= 0 ~ "Neg_Pos",
            ROC < 0 & Returns < 0 ~ "Neg_Neg"
        )) %>% count(Quadrant) %>%
        mutate(Percentage = 100*round(n/nrow(Joined_df),4)) %>%
        pull(Percentage)


    Plot_1 <- Joined_df %>% ggplot(aes(x = ROC, y = Returns)) +
        geom_point(color = "blue", alpha = 0.6) +  # Add points for scatterplot
        geom_smooth(method = "lm", color = "grey", se = FALSE) +
        ylim(-0.2, 0.2)+
        xlim(-0.2, 0.2)+

        geom_vline(xintercept = 0, linetype = "solid") +  # Add y-axis
        geom_hline(yintercept = 0, linetype = "solid") +  # Add x-axis
        geom_vline(xintercept = -0.025, linetype = "longdash", size = 1, alpha = 0.5) + #Add fees line

        annotate("rect", xmin = -Inf, xmax = 0, ymin = 0, ymax = Inf, fill = "yellow", alpha = 0.2) + # Top-left quadrant
        annotate("rect", xmin = 0, xmax = Inf, ymin = 0, ymax = Inf, fill = "darkgreen", alpha = 0.2) +   # Top-right quadrant
        annotate("rect", xmin = -Inf, xmax = 0, ymin = -Inf, ymax = 0, fill = "red", alpha = 0.2) + # Bottom-left quadrant
        annotate("rect", xmin = 0, xmax = Inf, ymin = -Inf, ymax = 0, fill = "lightgreen", alpha = 0.2) + # Bottom-right quadrant

        labs(title = "ZAR/USD Returns vs. Portfolio Returns",
             x = "USD/ZAR Returns",
             y = "Portfolio Returns") +
        fmxdat::theme_fmx() +

        geom_label(data = data.frame(
            x = c(-0.19, -0.19, 0.16, 0.16),
            y = c(-0.18, 0.19, -0.18, 0.19),
            label = Quadrant_Totals
        ),
        aes(x = x, y = y, label = label),
        hjust = 0, vjust = 1, size = 4, color = "black", fill = "white") +

        geom_label(data = data.frame(
            x = c(-0.1, 0.1, -0.1, 0.1),
            y = c(0.1, 0.1, -0.1, -0.1),
            label = c("Hedge works but \n amplifies volatility",
                      "Hedge throws away returns",
                      "Best case for Hedge",
                      "Hedge removes currency \n cushion")
        ),
        aes(x = x, y = y, label = label),
                   hjust = 0.5, vjust = 0.5, size = 3, color = "black", fill = "white") +

        theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

    Plot_Marg <- ggMarginal(Plot_1, type = "density", fill = "lightgreen", color = "black")


    Plot_Marg
}