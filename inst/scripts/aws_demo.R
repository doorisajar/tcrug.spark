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

# create a Spark DataFrame
flights <- spark_read_csv(sc, "flights", "s3a://wl-applied-math-dev/rdoake/tcrug/*.csv.gz")

# while this runs, check out the Spark UI! on AWS EMR, this is at:
# http://ec2-*.compute-*.amazonaws.com:18080/?showIncomplete=true

# inspect our new DataFrame
class(flights)
str(flights)

sdf_nrow(flights)

# perform some operations
flights %>%
  group_by(UNIQUE_CARRIER) %>%
  summarise(MEAN_DEP_DELAY = mean(DEP_DELAY, na.rm = TRUE))

# try a package function
mean_departure_delay(flights)

mean_departure_delay(flights, MONTH)

# try specialized R functions
flights %>%
  mutate(run_length_encoding = rle(UNIQUE_CARRIER))

# Error: org.apache.spark.sql.AnalysisException: Undefined function: 'RLE'. This
# function is neither a registered temporary function nor a permanent function
# registered in the database 'default'


