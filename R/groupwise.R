#' Count pairs of states from flights
#'
#' Origin - Destination pairs.
#'
#' @param x an R data.frame
#'
#' @importFrom dplyr mutate select
#' @importFrom magrittr %<>%
#'
#' @export
#'
state_pairs <- function(x) {

  x %<>%
    mutate(state_pairs = paste(ORIGIN_STATE_ABR, DEST_STATE_ABR)) %>%
    select(state_pairs) %>%
    table

}
