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
mean_departure_delay <- function(sdf, group_vars = carrier) {

  qt <- enquo(group_vars)

  sdf %>%
    group_by(UQ(qt)) %>%
    summarise(mean_dep_delay = mean(dep_delay, na.rm = TRUE))

}

# invoke example?
