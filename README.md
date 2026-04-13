# Data Mining Project

This repository contains the code for a small data mining project developed as part of the course:

**Data Access and Data Mining for Social Sciences**

University of Lucerne

Student Name: Elli Brown
Course: Data Mining for the Social Sciences using R
Term: Spring 2026

## Project Goal

The goal of this project is to collect and analyze data from an online source (API or 
web scraping) in order to answer a research question relevant to political or social science.

The project should demonstrate:

- Identification of a suitable data source
- Automated data collection (API or scraping)
- Data cleaning and preparation
- Reproducible analysis


## Research Question

*How do cost of living metrics vary across Canadian regions, and how does this variation relate to differences in median incomes?*

## Data Source

I used four data sources. 

Median income and Market Basket Measure:
- API: https://www.statcan.gc.ca/en/microdata/api
- Access method: cansim R package

National living wages:
- Webpage: https://www.livingwage.ca/rates
- Access method: scraped datawrapper csv

Yukon living wage:
- Online PDF: https://yapc.ca/assets/documents/Living_Wage_in_Whitehorse_2023_-_Infographic.pdf
- Access method: manually extracted data from online PDF

Quebec living wage:
- https://iris-recherche.qc.ca/publications/revenu-viable-2023/
- Access method: manually uploaded csv to project (website blocked scraping)


## Repository Structure

/scripts     scripts used to collect/process data
/assets      saved data visualizations
/data_raw    raw data files
/data_preprocessed  cleaned and prepared data files
Report.qmd   R Markdown report with analysis and visualizations
Report.pdf   rendered PDF report
README.md   project description


## Reproducibility

To reproduce this project:

1. Clone the repository
2. Install required R packages
3. Run the scripts in the `/scripts` folder

All data should be generated automatically by the scripts.

