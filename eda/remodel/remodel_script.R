# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# INTRO ============================================================

# LOAD LIBRARIES ***********************************************
R.version.string
Sys.info()
getwd()
library(lobstr)
library(rlang)
library(tidyverse)
library(tidylog)
library(lubridate)
library(scales)
# library(gt)
library(sf)
library(tidycensus)
set.seed(metadatar$seed_set[1])
options(digits = 4, max.print = 99, warnPartialMatchDollar = TRUE, 
        tibble.print_max = 30, scipen = 999, nwarnings = 5, 
        stringsAsFactors = FALSE)
mem_used()

# basic helper functions ************************************

# function to print object size
sizer <- function(x) {
  aaa <- format(object.size(x), "MB")
  return(aaa)}

# function to quickly run garbage collection
trash <- function(x) {
  gc(verbose = TRUE)}

# function to quickly view a sample of a dataframe
viewer <- function(x) {
  if (is.data.frame(x) == FALSE) {
    print("Error, insert a dataframe")
  } else {
    if(nrow(x) < 95) {
      View(x[sample(1:nrow(x), floor(nrow(x) * 0.5)), ])
    } else {
      View(x[sample(1:nrow(x), 100), ])
    }}}

# a function to make a quick data dictionary of a data frame
data_dictionary <- function(aa) {
  dd <- data.frame(column_order = seq(1, ncol(aa)), 
                   column_name_text = colnames(aa), 
                   column_class = sapply(aa, class, simplify = TRUE), 
                   column_nacount = sapply(lapply(aa, is.na), 
                                           sum, simplify = TRUE), 
                   column_uniques = sapply(lapply(aa, unique), 
                                           length, simplify = TRUE), 
                   row_01 = sapply(aa[1, ], as.character, simplify = TRUE), 
                   row_02 = sapply(aa[2, ], as.character, simplify = TRUE),
                   row_03 = sapply(aa[3, ], as.character, simplify = TRUE),
                   row_04 = sapply(aa[4, ], as.character, simplify = TRUE),
                   row_05 = sapply(aa[5, ], as.character, simplify = TRUE),
                   row.names = NULL)
  return(dd)}

# helps turn a character dollar variable into numeric
#   requires stringr, uncomment last line to turn NA to zero
cash_money <- function(x) {
  aa <- str_remove_all(x, pattern = "\\$")
  bb <- str_remove_all(aa, pattern = ",")
  cc <- as.numeric(bb)
  # cc <- ifelse(is.na(cc), 0, cc)
  return(cc)}

# POST SCRIPT; alt to using paste0() all the time (i saw this on twitter)
'%ps%' <- function(lhs, rhs) {
  return_me <- paste0(lhs, rhs)
  return(return_me)}

# ^ ====================================
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# load data and prepare data for analysis -------------------

# load a rds file
loader_path1 <- paste0(getwd(), "/etl/ingot/dataframe.rds")
clockin()
raw_df <- readRDS(loader_path1)
clockout()
dim(raw_df)

# any last minute cleaning
dfa <- raw_df

# cleanup !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
rm(raw_df)
ls()
trash()
mem_used()

# census key and other setup ------------------------------------------

options(tigris_use_cache = TRUE)

# set api key if needed !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# census_api_key("111", install = TRUE)

# set up the parameters for what to query from the acs5 !!!!!!!!!!!!!!!!!!
census_params <- list(state = unique(dfa$st),  
                      year = 2019, 
                      variables = data.frame(var_codes = c("B01003_001"), 
                                             var_detail = c("population estimate")))


# ^ -----

# query the census api to get data with geometries attached --------------

# pull data at a state level
df_state <- get_acs(state = census_params$state, 
                    geography = "state", 
                    year = census_params$year, 
                    variables = census_params$variables$var_codes, 
                    geometry = TRUE, 
                    cache_table = TRUE)
df_state

# clean up the dataframes ::::::::::::::::::::::::::::::::::::::::::::

df_state <- df_state %>% 
  rename(var_codes = variable) 
df_state <- left_join(df_state, census_params$variables, 
                      by = 'var_codes')

# test ??????????????????????????
# ggplot(data = df_state) + 
#   geom_sf()
