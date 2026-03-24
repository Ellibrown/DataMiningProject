# visualize mbm/lw gap across regions

# grouped bar plot

# covert to long format
long_plot_data <- combined_df_specifics %>%
  select(region_name, annual_LW, mbm_value) %>%
  pivot_longer(cols = c(annual_LW, mbm_value), 
               names_to = "metric", 
               values_to = "value")

# calculate lw-mbm ratio

combined_df_specifics <- combined_df_specifics %>%
  mutate(lw_mbm_ratio = annual_LW / mbm_value) %>%
  mutate(lw_mbm_gap = annual_LW - mbm_value)

# create plot
ggplot(long_plot_data, aes(x = reorder(region_name, value), y = value, fill = metric)) +
  # "dodge" places bars side-by-side instead of stacking them
  geom_col(position = "dodge") + 
  # Flip coordinates if you have many regions (makes labels readable)
  coord_flip() + 
  # Clean up the look
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") + # Distinct colors for the 3 categories
  labs(
    title = "Comparison of Income Benchmarks by Region",
    subtitle = "Comparing Individual Median Income vs. Family Poverty Line (MBM) and Living Wage",
    x = "",
    y = "",
    fill = "Metric Type"
  )

# dumbbell plot
ggplot(combined_df_specifics, aes(y = reorder(region_name, annual_LW))) +
  # 1. Create the connector line (the "bar")
  geom_segment(aes(x = mbm_value, xend = annual_LW, 
                   yend = region_name), color = "#b2b2b2", size = 1.5) +
  # 2. Add the Poverty Line points
  geom_point(aes(x = mbm_value), color = "#e41a1c", size = 4) +
  # 3. Add the Living Wage points
  geom_point(aes(x = annual_LW), color = "#377eb8", size = 4) +
  # Styling
  theme_minimal() +
  labs(title = "Living Wage vs. Poverty Line by Region",
       x = "Annual Threshold ($)",
       y = "Region") +
  scale_x_continuous(expand = expansion(mult = c(0, 0.05)), 
                     limits = c(0, NA))





# scatter plot: lw/mbm ratio vs median income
ggplot(combined_df_specifics, aes(x = median_income, y = lw_mbm_ratio)) +
  geom_point(color = "#377eb8", size = 4) +
  theme_minimal() +
  labs(title = "Living Wage to MBM Ratio vs. Median Income",
       x = "Median Income ($)",
       y = "Living Wage / MBM Ratio") +
  geom_smooth(method = "lm", color = "red", se = FALSE)

# test correlation
# Detailed statistical output
correlation_results <- cor.test(
  combined_df_specifics$median_income, combined_df_specifics$lw_mbm_ratio)

print(correlation_results)



combined_df <- combined_df %>%
  mutate(lw_mbm_ratio = annual_LW / mbm_value)


# scatter plot: l, aes(x = median_income, y = lw_mbm_ratio)) +
ggplot(combined_df, aes(x = median_income, y = lw_mbm_ratio)) +
  geom_point(color = "#377eb8", size = 4) +
  theme_minimal() +
  labs(title = "Living Wage to MBM Ratio vs. Median Income",
       x = "Median Income ($)",
       y = "Living Wage / MBM Ratio") +
  geom_smooth(method = "lm", color = "red", se = FALSE)

# test correlation
# Detailed statistical output
correlation_results <- cor.test(
  combined_df$median_income, combined_df$lw_mbm_ratio)

print(correlation_results)
