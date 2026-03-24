library(tidyverse)
source("city_name_mapping.R")

# create joined mbm/lw table
combined_df <- national_living_wages %>% 
  left_join(lookup_table, by = c("lw_region" = "lw_region")) %>%
  left_join(mbm_thresholds, by = "mbm_region") %>%
  left_join(median_incomes, by = "median_income_region") %>%
  select(lw_region, Prov, mbm_region, median_income_region, annual_LW, mbm_value, median_income) %>%
  drop_na() 

