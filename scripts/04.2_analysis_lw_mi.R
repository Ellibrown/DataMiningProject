library(patchwork)
library(tidyverse)

# load dataframe

combined_df <- readRDS("data_preprocessed/combined_df.rds")

# scatter plot with quadrant analysis - lw vs median income

mx <- mean(combined_df$median_income)
my <- mean(combined_df$annual_LW)

ggplot(combined_df, aes(x = median_income, y = annual_LW)) +
  geom_point(color = "#377eb8", size = 2) +
  geom_vline(xintercept = mx, 
             linetype = "dashed", color = "red") +
  geom_hline(yintercept = my, 
             linetype = "dashed", color = "red") +
  theme_minimal() +
  labs(title = "Relative Affordability Quadrants, 2023",
       subtitle = 
         "Comparing median incomes to living wages across Canadian regions
       (dashed lines represent averages)",
       x = "Median Income ($)",
       y = "Living Wage ($)") +
  geom_text_repel(
    data = subset(combined_df, !duplicated(region_name)), 
    aes(label = region_name), 
    size = 3) +
  annotate("text", 
           x = c(mx*0.8, mx*1.2, mx*0.8, mx*1.2), 
           y = c(my*1.2, my*1.2, my*0.8, my*0.8), 
           label = c("Low incomes/High costs", 
                     "High incomes/High costs", 
                     "Low incomes/Low costs", 
                     "High incomes/Low costs"),
           color = "darkblue", fontface = "italic", size = 3)

# save plot
ggsave("assets/lw_mi_scatter_plot.png", 
       plot = last_plot(),
       width = 10,
       height = 9, 
       units = "in", 
       dpi = 300,  
       bg = "white")
  
# calculate lw / mi correlation
spearman_test_lw_mi <- cor.test(combined_df$median_income, 
                                  combined_df$annual_LW, 
                                  method = "spearman")
print(spearman_test_lw_mi)

# histogram - single income family

ratio_df_1 <- combined_df %>%
  mutate(lw_mi_ratio = median_income / annual_LW) %>%
  mutate(lw_mi_ratio_double = (median_income * 2) / annual_LW)

ggplot(ratio_df_1, aes(x = lw_mi_ratio)) + 
  geom_histogram(fill = "steelblue", color = "white") +
  labs(title = "Affordability Across Regions, 2023",
       subtitle = "Single median income vs. family of four living wage",
       y = "Number of Regions",
       x = "Affordability Ratio (Median Income / Living Wage)") +
  geom_vline(xintercept = 1, linetype = "dashed", color = "red", size = 1) +
  annotate("text", x = 1.05, y = 5, label = "Breakeven (Income = Cost)", 
           color = "red", angle = 90, vjust = -0.5)
  

ggsave("assets/lw_mi_histogram.png", 
       plot = last_plot(),
       width = 7,
       height = 5, 
       units = "in", 
       dpi = 300,  
       bg = "white")

# calculate figures for living wage affordability

summary_lw_mi <- ratio_df_1 %>%
  summarise(
    # Single Income Stats
    Single_Avg = mean(lw_mi_ratio, na.rm = TRUE),
    Single_Median = median(lw_mi_ratio, na.rm = TRUE),
    Single_Pct_Below_1 = mean(lw_mi_ratio < 1, na.rm = TRUE) * 100,
    
    # Double Income Stats
    Double_Avg = mean(lw_mi_ratio_double, na.rm = TRUE),
    Double_Median = median(lw_mi_ratio_double, na.rm = TRUE),
    Double_Pct_Below_1 = mean(lw_mi_ratio_double < 1, na.rm = TRUE) * 100
  )

print(summary_lw_mi)
