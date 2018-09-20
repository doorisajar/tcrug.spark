library(dplyr)
library(sparklyr)
library(dbplyr)
library(nycflights13)

# load Spark configuration and initiate spark connection
conf <- spark_config("~/sc.yml")

sc <- spark_connect(master = "yarn",
                    spark_home = "/usr/lib/spark",
                    config = conf)

# create a Spark DataFrame
flights_sdf <- copy_to(sc, select(flights, -time_hour), "flights_sdf", overwrite = TRUE)

# inspect our new DataFrame
class(flights_sdf)
str(flights_sdf)

sdf_nrow(flights_sdf)
sdf_describe(flights_sdf)

# perform some operations
flights_sdf %>%
  group_by(carrier) %>%
  summarise(mean_dep_delay = mean(dep_delay, na.rm = TRUE))

# try a package function
mean_departure_delay(flights_sdf)

mean_departure_delay(flights_sdf, month)

# try specialized R functions
flights_sdf %>%
  mutate(run_length_encoding = rle(carrier))

# Error: org.apache.spark.sql.AnalysisException: Undefined function: 'RLE'. This
# function is neither a registered temporary function nor a permanent function
# registered in the database 'default'


