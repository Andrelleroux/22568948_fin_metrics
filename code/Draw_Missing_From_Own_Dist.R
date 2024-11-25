Draw_Missing_From_Own_Dist <- function(return_mat){

N <- nrow(return_mat)
return_mat <-
    # DIY: see what density function does
    left_join(return_mat %>% gather(Stocks, Returns, -date),
              return_mat %>% gather(Stocks, Returns, -date) %>% group_by(Stocks) %>%
                  mutate(Dens = list(density(Returns, na.rm=T))) %>%
                  summarise(set.seed(as.numeric(format( Sys.time(), format = "%s"))/1e3*sample(1:100)[1]),
                            Random_Draws = list(sample(Dens[[1]]$x, N,
                                                       replace = TRUE, prob=.$Dens[[1]]$y))),
              by = "Stocks"
    ) %>%  group_by(Stocks) %>%
    # Random draw from sample:
    mutate(Returns = coalesce(Returns, Random_Draws[[1]][row_number()])) %>%
    select(-Random_Draws) %>% ungroup() %>% spread(Stocks, Returns)
return(return_mat)
}