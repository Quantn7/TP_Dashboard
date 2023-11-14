# Set working directory
setwd('/Users/Quankun/RstudioProject/TP_Dashboard')

library(tidyverse)


# Prepare data for dashboard
master_store <- read_csv('Master_store.csv', col_types = cols(.default = col_guess(), Store_code = col_character())) # Master Store

df1 <- read_csv('/Users/Quankun/RstudioProject/xlsOutboundtoMerge20231/aggregated_data_1.csv') # Outbound data by orders

# Join aggregated data with master store and remove NA values
join_data <- left_join(df1, master_store, by = (c('STORE' = 'Store_code')))

summary_data <- join_data %>% 
  mutate(trip = str_c(TRUCKNO, WDATE, str_sub(TSMIN, 0, 2))) %>% 
  group_by(Province) %>%
  summarise(No_of_trip = n_distinct(trip), Delivery_point = n_distinct(STORE)) %>% filter(!is.na(Province)) -> summary_data

# Edit province name
summary_data %>% mutate(Province = case_when(Province == 'Dong nai' ~ 'Dong Nai', TRUE ~ Province )) -> summary_data
