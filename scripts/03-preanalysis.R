# load packages and source city lookup table
library(tidyverse)
source("scripts/city_name_mapping.R")

# create joined mbm/lw table

mbm_data <- readRDS("data_preprocessed/mbm_thresholds.rds")
median_income_data <- readRDS("data_preprocessed/median_incomes.rds")
national_living_wages <- readRDS("data_preprocessed/national_living_wages.rds")

combined_df <- national_living_wages %>% 
  left_join(lookup_table, by = c("lw_region" = "lw_region")) %>%
  left_join(mbm_data, by = "mbm_region") %>%
  left_join(median_income_data, by = "median_income_region") %>%
  select(lw_region, Prov, mbm_region, median_income_region, annual_LW, mbm_value, median_income) %>%
  drop_na() %>%
  unite("region_name", lw_region, Prov, sep = ", ", remove = FALSE)

# refine selected region name spellings
combined_df <- combined_df %>% 
  mutate(region_name = recode(region_name,
   "Grand Prairie, AB" = "Grande Prairie, AB",
    "Metro Vancouver, BC" = "Vancouver, BC",
    "GTA, ON" = "Toronto, ON",
    "Dufferin Guelph Wellington Waterloo, ON" = "Dufferin/Waterloo, ON",
    "London Elgin Oxford, ON" = "London/Elgin, ON"
  ))

# add lw - mbm gap calculation
combined_df <- combined_df %>% 
  mutate(lw_mbm_gap = annual_LW - mbm_value)

# save combined table
saveRDS(combined_df, "data_preprocessed/combined_df.rds")


