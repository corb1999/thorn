
# add functions to execute analysis with ::::::::::::::::::

fun_map_torn1 <- function(arg_df = dfplt, arg_pltnm = pltname, 
                          arg_dfgeo = dfsf_plt_state) {
  plt1 <- arg_df %>% 
    ggplot() + 
    geom_sf(data = arg_dfgeo, 
            fill = NA) + 
    geom_segment(aes(x = slon, y = slat, 
                     xend = elon, yend = elat, 
                     color = as.factor(mag)), 
                 size = 1) + 
    scale_color_brewer(palette = 'YlOrRd') +  
    theme_minimal() + 
    theme(legend.position = 'top') + 
    labs(subtitle = arg_pltnm, color = 'Tornado F Magnitude', 
         x = '', y = '')
  return(plt1)}
# fun_map_torn1()
