library(dplyr)
library(sparklyr)
library(nycflights13)

conf <- spark_config("~/sc.yml")

sc <- spark_connect(master = "yarn",
                    spark_home = "/usr/lib/spark",
                    config = conf)

flights_sdf <- copy_to(sc, flights, "flights")

sdf_describe(flights_sdf)

