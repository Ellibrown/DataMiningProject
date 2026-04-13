library(tidyverse)
library(ggtext)

# load dataframe

combined_df <- readRDS("data_preprocessed/combined_df.rds")

# calculate lw-mbm ratio and mi-lw gap

combined_df <- combined_df %>%
  mutate(lw_mbm_ratio = annual_LW / mbm_value) %>%
  mutate(mi_lw_gap = annual_LW - median_income)

# scatter plot: lw/mbm ratio vs median income
ggplot(combined_df, aes(x = median_income, y = lw_mbm_ratio)) +
  geom_point(color = "#377eb8", linewidth = 2) +
  theme_minimal() +
  labs(title = "Living Wage to MBM Ratio vs. Median Income",
       x = "Median Income ($)",
       y = "Living Wage / MBM Ratio") +
  geom_smooth(method = "lm", color = "red", se = FALSE)

ggsave("assets/multivariate_scatter_plot.png", 
       plot = last_plot(),
       width = 6,
       height = 6, 
       units = "in", 
       dpi = 300,  
       bg = "white")

# test correlation of lw/mbm ratio vs median income
multivariate_correlation <- cor.test(combined_df$median_income, 
                                 combined_df$lw_mbm_ratio, 
                                 method = "spearman", exact = FALSE)
print(multivariate_correlation)

# dumbbell plot 

multivariate_title <- "<span style='color:#2E8B57;'>Median Income</span>,
                      <span style='color:#E05A5A;'>Market Basket Measure</span>, and
                      <span style='color:#3A7FC1;'>Living Wage</span>
                      <br>by Canadian Region, 2023"

ggplot(combined_df, aes(y = reorder(region_name, mi_lw_gap))) +
  geom_segment(aes(x = median_income, 
                   xend = annual_LW, 
                   yend = region_name), 
                   color = "#b2b2b2", linewidth = 1.5) +
  geom_point(aes(x = mbm_value), color = "#E05A5A", linewidth = 2) +
  geom_point(aes(x = annual_LW), color = "#3A7FC1", linewidth = 2) +
  geom_point(aes(x = median_income), color = "#2E8B57", linewidth = 2) +
  theme_minimal() +
  labs(title = multivariate_title,
       subtitle = "Comparing individual median income vs. family of four living wage vs. family of
four MBM; ordered by size of gap between median income and living wage",
       x = "Annual Amount ($)",
       y = "") +
  theme(plot.title = element_markdown(lineheight = 1.1))

# save dumbbell plot

ggsave("assets/multivariate_dumbbell_plot.png", 
       plot = last_plot(),
       width = 10,
       height = 9, 
       units = "in", 
       dpi = 300,  
       bg = "white")
