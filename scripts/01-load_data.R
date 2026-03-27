# load packages
library(tidyverse)
library(cansim)
library(rvest)
library(pdftools)
library(jsonlite)

# load and save StatCan data
mbm_thresholds <- get_cansim("11-10-0066-01")
saveRDS(mbm_thresholds, "data_raw/raw_mbm_thresholds.rds")

median_income <- get_cansim("11-10-0008-01")
saveRDS(median_income, "data_raw/raw_median_income.rds")

# filter and save MBM threshold data
mbm_thresholds_filtered <- raw_mbm_thresholds %>%
  filter(REF_DATE == 2023 & Component == "Total threshold" & `Base year`=="2023 base") %>%
  select(REF_DATE, GEO, `Dollar concept`, Component, VALUE) %>%
  filter(`Dollar concept` == "Current dollars")%>%
  rename(`mbm_region` = `GEO`) %>%
  rename(`mbm_value` = VALUE)

saveRDS(mbm_thresholds_filtered, "data_preprocessed/mbm_thresholds.rds")

# filter and save median income data
median_income_filtered <- raw_median_income %>%
  filter(REF_DATE == 2023 & `Persons with income` == "Median total income" 
         & `Sex` == "Both sexes" & `Age group` == "All age groups") %>%
  select(REF_DATE, GEO, VALUE) %>%
  rename(`median_income` = VALUE) %>%
  rename(`median_income_region` = `GEO`)

saveRDS(median_income_filtered, "data_preprocessed/median_incomes.rds")

# scrape and save national living wage table

hidden_data_url <- "https://datawrapper.dwcdn.net/FXpvY/31/dataset.csv" 
living_wages <- read_csv(hidden_data_url)

saveRDS(living_wages, "data_raw/raw_living_wages.rds")

# scrape and save Yukon living wage

pdf_url <- "https://yapc.ca/assets/documents/Living_Wage_in_Whitehorse_2023_-_Infographic.pdf"
raw_text <- pdftools::pdf_text(pdf_url)
living_wage_match <- str_extract(raw_text, "\\$\\d+\\.\\d{2}/hr")

saveRDS(living_wage_match, file = "data_raw/whitehorse_living_wage_2023.rds")

# clean and save Quebec viable wages (imported csv data manually)

quebec_living_wages = read_csv("data_raw/data-FGcxc.csv") %>%
  select(`lw_region`= 1, Raw_Value = `Revenu viable`) %>%
  mutate(
    Clean_Value = str_remove_all(Raw_Value, "[^0-9]"),
    `annual_LW` = as.numeric(Clean_Value),
    Prov = "QC"
  ) %>%
  select(`lw_region`, Prov, `annual_LW`)

saveRDS(quebec_living_wages, "data_preprocessed/quebec_living_wages.rds")
