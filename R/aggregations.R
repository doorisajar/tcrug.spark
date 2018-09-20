#' Compute mean departure delay by a grouping variable
#'
#'
#' @param sdf a Spark DataFrame
#' @param group_vars unquoted grouping column name(s)
#'
#' @importFrom dplyr group_by summarise enquo
#' @importFrom magrittr %>%
#' @importFrom rlang UQ
#'
#' @export
#'
mean_departure_delay <- function(sdf, group_vars = UNIQUE_CARRIER) {

  qt <- enquo(group_vars)

  sdf %>%
    group_by(UQ(qt)) %>%
    summarise(MEAN_DEP_DELAY = mean(DEP_DELAY, na.rm = TRUE))

}
