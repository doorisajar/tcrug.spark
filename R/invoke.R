#' Count the lines in a text file
#'
#'
#' @param sc a Spark connection
#' @param file a path to a file (local, S3, HDFS)
#'
#' @importFrom sparklyr spark_context invoke
#'
#' @export
#'
count_lines <- function(sc, file) {

  spark_context(sc) %>%
    invoke("textFile", file, 1L) %>%
    invoke("count")

}
