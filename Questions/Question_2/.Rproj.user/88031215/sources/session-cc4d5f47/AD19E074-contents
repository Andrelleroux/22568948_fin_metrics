Return_Distributions <- function(dataset = Combined_df){

    #Add function from prac for converting from annual to monthly fees
    feeconverter <- function(x, Ann_Level) (1+x)^(1/Ann_Level)-1

    Plot_2 <- Combined_df %>%
        mutate(Net_Return = if_else(Fund %in% c("Q3","Median", "Best", "Worst", "Q1"),
                                    Returns - feeconverter(150*1e-4, 12), Returns)) %>%
        group_by(Fund) %>%
        mutate(Roll_Return = roll_prod(1 + Returns, 36, fill = NA, align = "right")^(12/36) - 1) %>%
        group_by(date) %>%
        filter(any(!is.na(Roll_Return))) %>%
        filter(Fund != "Best" & Fund != "Worst" & Fund != "Q1" & Fund != "Q3") %>%
        ggplot(aes(x = Roll_Return)) +
        geom_density(aes(fill = Fund), alpha =0.6)+
        labs(title = " Rolling 3 year densities of the different funds",
             subtitle = "", x = "", y = "Rolling 3 year Returns "
        ) + fmxdat::theme_fmx()

        Plot_2
}