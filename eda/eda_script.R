# :::::::::::::::::::::::::::::::::::::::::::::::::::::::
# INTRO =================================================
metadatar <- list(script_starttime = Sys.time(), 
                  script_det = list(version_dt = as.Date("1999-01-01"), 
                                    author = "", 
                                    proj_name = "", 
                                    script_type = "eda", 
                                    notepad = paste0("")), 
                  seed_set = 6)
metadatar

# start the clock timer, used for monitoring runtimes
clockin <- function() {
  aa <- Sys.time()
  clock_timer_start <<- aa
  return(aa)}

# end the clock timer, used in conjunction with the clockin fun
clockout <- function(x) {
  aa <- clock_timer_start
  bb <- Sys.time()
  cc <- bb - aa
  return(cc)}

# source the script that will load the data and prep it for analysis
sourcerpath <- paste0(getwd(), '/eda/remodel/remodel_script.R')
clockin()
source(file = sourcerpath)
clockout()

# source another script with analysis functions to run
sourcerpath <- paste0(getwd(), '/eda/engine/engine_script.R')
clockin()
source(file = sourcerpath)
clockout()

# cleanup
ls()
trash()
mem_used()

# ^ ====================================
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::

# viz prep ---------------------------------------------------

plt_states <- c('KY', 'TN', 'MS', 'VA', 'AL', 
                'GA', 'SC', 'NC', 'WV')

pltname <- 'NOAA Tornado Data; ' %ps% 
  reduce(plt_states, .f = paste, sep = '; ') %ps% '; ' %ps% 
  '2007-2020; '
(pltname)

dfplt <- dfa %>% 
  filter(st %in% plt_states) %>% 
  filter(valid_fmag == TRUE) %>% 
  filter(torn_dttime >= as.Date('2007-01-01'), 
         torn_dttime <= as.Date('2020-12-31'))

dfsf_plt_state <- df_state %>% 
  filter(NAME %in% c('Kentucky', 
                     'Tennessee', 
                     'Mississippi', 
                     'Virginia', 
                     'Alabama', 
                     'Georgia', 
                     'South Carolina', 
                     'North Carolina', 
                     'West Virginia')) %>% 
  filter(GEOID > 0)

# ^ -----

# run plots and visuals ------------------------------------

fun_map_torn1()


# ^ -----
