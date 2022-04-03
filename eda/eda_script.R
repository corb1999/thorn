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

pltname <- 'hello' %ps% 'world'

dfplt <- dfa

# ^ -----

# run plots and visuals ------------------------------------




# ^ -----
