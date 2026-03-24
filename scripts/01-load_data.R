# install and load packages
library(tidyverse)
library(cansim)
library(rvest)
library(pdftools)

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

# scrape national living wage table

library(jsonlite)
library(tidyverse)

hidden_data_url <- "https://datawrapper.dwcdn.net/FXpvY/31/dataset.csv" 

living_wages <- read_csv(hidden_data_url)

# save national living wage table
saveRDS(living_wages, "data_raw/raw_living_wages.rds")

# scrape and save Yukon living wage

# 1. Define the URL
pdf_url <- "https://yapc.ca/assets/documents/Living_Wage_in_Whitehorse_2023_-_Infographic.pdf"

# 2. Extract text from the PDF
raw_text <- pdftools::pdf_text(pdf_url)

# 3. Use Regex to find the pattern "$x.xx/hr" 
living_wage_match <- str_extract(raw_text, "\\$\\d+\\.\\d{2}/hr")

# 4. save the value
saveRDS(living_wage_match, file = "data_raw/whitehorse_living_wage_2023.rds")

