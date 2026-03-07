# install and load packages
library(tidyverse)
install.packages("cansim")
library(cansim)

# load and save StatCan data
mbm_thresholds <- get_cansim("11-10-0066-01")
saveRDS(mbm_thresholds, "data_raw/raw_mbm_thresholds.rds")

median_income <- get_cansim("11-10-0008-01")
saveRDS(median_income, "data_raw/raw_median_income.rds")

# filter and save MBM threshold data
mbm_thresholds_filtered <- mbm_thresholds %>%
  filter(REF_DATE > 2017 & Component == "Total threshold") %>%
  select(REF_DATE, GEO, `Dollar concept`, Component, VALUE)

saveRDS(mbm_thresholds_filtered, "data_preprocessed/filtered_mbm_thresholds.rds")


  