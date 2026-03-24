library(tidyverse)

# clean national living wage table

national_living_wages <- readRDS("data_raw/raw_living_wages.rds") %>%
  select(`City/Region`, Prov, `2023`) %>%
  filter(!is.na(`2023`)) %>%
  rename(`lw_region` = `City/Region`)

# add Whitehorse living wage to national table

whitehorse_living_wage <- readRDS("data_raw/whitehorse_living_wage_2023.rds") %>%
  str_remove("/hr") %>%
  str_remove("\\$") %>%
  as.numeric()

national_living_wages <- national_living_wages %>%
  add_row(`lw_region` = "Whitehorse", Prov = "YT", `2023` = whitehorse_living_wage)

# rename column 



# change from monthly to annual figures and filter to current dollars only

national_living_wages <- national_living_wages %>%
  mutate(`annual_LW` = `2023` * 35 * 52 * 2)

# save national living wage table
saveRDS(national_living_wages, "data_preprocessed/national_living_wages.rds")

# clean Quebec viable wages

quebec_viable_wages = read_csv("data_raw/data-FGcxc.csv") %>%
  select(`City/Region`= 1, Raw_Value = `Revenu viable`) %>%
  mutate(
    Clean_Value = str_remove_all(Raw_Value, "[^0-9]"),
    `2023_annual_viable_wage` = as.numeric(Clean_Value),
    Prov = "QC"
  ) %>%
  select(`City/Region`, Prov, `2023_annual_viable_wage`)

# save Quebec viable wages

saveRDS(quebec_viable_wages, "data_preprocessed/clean_quebec_viable_wages.rds")

# 


