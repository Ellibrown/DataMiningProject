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

# change from monthly to annual figures

national_living_wages <- national_living_wages %>%
  mutate(
    `annual_LW` = `2023` * 35 * 52 * 2, 
      `2023` = NULL
    )

# add Quebec living wages to national table

national_living_wages <- national_living_wages %>%
  bind_rows(`national_living_wages`, readRDS("data_preprocessed/quebec_living_wages.rds"))

# save national living wage table
saveRDS(national_living_wages, "data_preprocessed/national_living_wages.rds")
