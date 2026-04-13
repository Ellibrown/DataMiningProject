library(ggrepel)
library(ggtext)
library(scales)
library(tidyverse)

# load dataframe

combined_df <- readRDS("data_preprocessed/combined_df.rds")

# define title for dumbell plot

lw_mbm_title <- "<span style='color:#E05A5A;'>Market Basket Measure</span> vs. 
             <span style='color:#3A7FC1;'>Living Wage</span> by Canadian Region, 2023"

# dumbbell plot - lw vs mbm
ggplot(combined_df, aes(y = reorder(region_name, lw_mbm_gap))) +
  geom_segment(aes(x = mbm_value, xend = annual_LW, 
                   yend = region_name), color = "#b2b2b2", size = 1) +
  geom_point(aes(x = mbm_value), color = "#E05A5A", size = 2) +
  geom_point(aes(x = annual_LW), color = "#3A7FC1", size = 2) +
  theme_minimal() +
  labs(title = lw_mbm_title,
       subtitle = "Ordered by size of gap between metrics",
       x = "Annual Amount ($)",
       y = "") +
  theme(plot.title = element_markdown(lineheight = 1.1))

# save dumbbell plot

ggsave("assets/lw_mbm_dumbbell_plot.png", 
       plot = last_plot(),
       width = 10,
       height = 9, 
       units = "in", 
       dpi = 300,  
       bg = "white")
