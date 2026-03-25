library(tidyverse)
source("city_name_mapping.R")


# create lw/mbm table

lw_mbm_df <- national_living_wages %>% 
  left_join(lookup_table, by = c("lw_region" = "lw_region")) %>%
  left_join(mbm_thresholds, by = "mbm_region") %>%
  select(lw_region, Prov, mbm_region, annual_LW, mbm_value) %>%
  drop_na() %>%
  unite("region_name", lw_region, Prov, sep = ", ", remove = FALSE) %>%
  mutate(lw_mbm_gap = annual_LW - mbm_value) %>%
  mutate(simple_gap = paste0("$", round(lw_mbm_gap / 1000), "k gap")) %>%
  # correct misspelled region names
  mutate(region_name = replace(
    region_name, region_name == "Grand Prairie, AB", "Grande Prairie, AB"))%>%
  mutate(region_name = replace(
    region_name, region_name == "Metro Vancouver, BC", "Vancouver, BC"))%>%
  mutate(region_name = replace(
    region_name, region_name == "GTA, ON", "Toronto, ON"))%>%
  mutate(region_name = replace(
    region_name, region_name == "Dufferin Guelph Wellington Waterloo, ON", "Dufferin/Waterloo, ON"))%>%
  mutate(region_name = replace(
    region_name, region_name == "London Elgin Oxford, ON", "London/Elgin, ON")) %>%
  mutate(region_name = replace(
    region_name, region_name == "Brant Haldimand Norfolk Niagara, ON", "Norfolk/Niagara, ON"))%>%
  mutate(region_name = replace(
    region_name, region_name == "Grey Bruce Perth Huron Simcoe, ON", "Huron/Simcoe, ON"))%>%
  mutate(region_name = replace(
    region_name, region_name == "Southern, NS", "Southern NS")) %>%
  mutate(region_name = replace(
    region_name, region_name == "Northern, NS", "Northern NS")) %>%
  mutate(region_name = replace(
    region_name, region_name == "East, ON", "Eastern ON")) %>%
  mutate(region_name = replace(
    region_name, region_name == "North, ON", "Northern ON")) %>%
  mutate(region_name = replace(
    region_name, region_name == "Southwest, ON", "Southwestern ON")) %>%


# covert to long format
lw_mbm_long_plot <- lw_mbm_df %>%
  mutate(region_name = fct_reorder(region_name, lw_mbm_gap)) %>%
  select(region_name, annual_LW, mbm_value) %>%
  pivot_longer(cols = c(annual_LW, mbm_value), 
               names_to = "metric", 
               values_to = "value")

# create plot - probably remove this one
ggplot(lw_mbm_long_plot, aes(x = region_name, y = value, fill = metric)) +
  geom_col(position = "dodge") + 
  coord_flip() + 
  theme_minimal() +
  scale_fill_brewer(palette = "Set1") +
  labs(
    title = "Comparison of Income Benchmarks by Region",
    subtitle = "Living Wage vs. Market Basket Measure Across Canadian Regions",
    x = "",
    y = "",
    fill = ""
  )

library(ggtext)
library(scales)
my_title <- "<span style='color:#E05A5A;'>Market Basket Measure</span> vs. 
             <span style='color:#3A7FC1;'>Living Wage</span> by Region, 2023"


# dumbbell plot
ggplot(lw_mbm_df, aes(y = reorder(region_name, lw_mbm_gap))) +
  geom_segment(aes(x = mbm_value, xend = annual_LW, 
                   yend = region_name), color = "#b2b2b2", size = 1) +
  geom_point(aes(x = mbm_value), color = "#E05A5A", size = 3.2) +
  geom_point(aes(x = annual_LW), color = "#3A7FC1", size = 3.2) +
  theme_minimal(base_size = 10) +
  labs(title = my_title,
       x = "Annual Threshold ($)",
       y = "") +
  scale_x_continuous(expand = expansion(mult = c(0, 0.05)), 
                     limits = c(45000, NA)) +
  theme(
    plot.background = element_rect(fill = "#F7F8FA", color = NA),
    panel.background = element_rect(fill = "#F7F8FA", color = NA),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#E2E5EA", linewidth = 0.4),
    axis.text.y        = element_text(color = "#6B7280", size = 7.5, hjust = 1),
    axis.text.x        = element_text(color = "#6B7280", size = 8),
    axis.title.x       = element_text(color = "#6B7280", size = 8.5, 
                                margin = margin(t = 8)),
    plot.title         = element_markdown(color = "#1C2333", size = 13, face = "bold", hjust = 0, margin = margin(b = 4)),
    plot.caption       = element_text(color = clr_subtext, size = 7, hjust = 0, margin = margin(t = 12)),
    plot.margin        = margin(20, 24, 16, 16),
    legend.position    = "none"
  ) +
  geom_label(
    aes(
      x = (mbm_value + annual_LW) / 2, 
      y = region_name, 
      label = simple_gap,
    ),
    fill = "white",          
    label.size = NA,        
    label.padding = unit(0.1, "lines"), 
    size = 3,               
    color = "grey30",      
    fontface = "italic"    
  ) +
  scale_x_continuous(labels = label_currency(accuracy = 1))



# to do:
# add asterix notes for vague geographies
# use the title as a legend with colours
# refine gridlines
# refine y axis text
# add $ labels to x axis
# add overall notes explaining some methods stuff
  # for example how lw was converted to annual
# add sources
  
  
  
  
