library(dplyr)
library(sparklyr)
library(dbplyr)

# load Spark configuration and initiate spark connection
conf <- spark_config("~/sc.yml")

sc <- spark_connect(master = "yarn",
                    spark_home = "/usr/lib/spark",
                    config = conf)

# get some data! (I copied this to AWS S3 beforehand)
# https://packages.revolutionanalytics.com/datasets/AirOnTime87to12/

# create a Spark DataFrame. this is a 300GB dataset, so it will take a while to ingest!
flights <-
  spark_read_csv(sc,
                 "flights",
                 "s3a://wl-applied-math-dev/rdoake/tcrug/*.csv.gz")

# while this runs, check out the Spark UI! on AWS EMR, this is at:
# http://ec2-*.compute-*.amazonaws.com:18080/?showIncomplete=true

# inspect our new DataFrame
class(flights)
str(flights)
sdf_schema(flights) %>% str

# 148619655 ROWS!!!
sdf_nrow(flights)

# perform some operations
flights %>%
  group_by(MONTH) %>%
  summarise(MEAN_DEP_DELAY = mean(DEP_DELAY, na.rm = TRUE))

# try a package function
mean_departure_delay(flights, MONTH)

# what about other grouping variables? let's talk about partitioning.
mean_departure_delay(flights, UNIQUE_CARRIER)

# when we read data into Spark, it's partitioned and distributed among the nodes
# in the cluster. for the flights data, which is split into compressed CSVs by
# year and month, Spark just uses this as the partitioning unless we specify
# some other variable to partition by. we can use partitioning to compute
# groupwise operations very efficiently! but if we have to change our
# partitioning, that triggers the dreaded SHUFFLE (i.e. sending data between
# nodes of our cluster), which is an expensive operation.

# try specialized R functions
flights %>%
  group_by(MONTH) %>%
  mutate(MONTHLY_CARRIERS = paste(unique(UNIQUE_CARRIER)))

# Error: org.apache.spark.sql.AnalysisException: Undefined function: 'UNIQUE'. This
# function is neither a registered temporary function nor a permanent function
# registered in the database 'default'

# by default, the ONLY functions we can use inside dplyr verbs are the ones
# explicitly exposed in the Spark SQL API:
#
# https://spark.apache.org/docs/latest/api/sql/index.html

# that's still a LOT of power & flexibility! but if you need more... spark_apply!

# when you know the result is small enough to fit in memory, you can collect it:
states_by_month <- flights %>%
  group_by(MONTH) %>%
  spark_apply(state_pairs) %>%
  collect

# current limitations: your function has to receive and emit exactly one R data.frame.

#
