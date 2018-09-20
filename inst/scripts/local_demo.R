library(dplyr)
library(sparklyr)
library(nycflights13)

# local version
flights %>%
  group_by(carrier) %>%
  summarize(count_num = n(),
            mean_dep_delay = mean(dep_delay, na.rm = TRUE),
            ratio = mean_dep_delay / count_num) %>%
  arrange(carrier)

# Spark version
sc <- spark_connect(master = "local")

flights_sdf <- copy_to(sc, flights, "flights")

flights_sdf %>%
  group_by(carrier) %>%
  summarize(count_num = n(),
            mean_dep_delay = mean(dep_delay),
            ratio = mean_dep_delay / count_num) %>%
  collect()
