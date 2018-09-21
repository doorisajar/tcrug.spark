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
    mutate(STATE_PAIRS = paste(ORIGIN_STATE_ABR, DEST_STATE_ABR)) %>%
    select(STATE_PAIRS) %>%
    table

  as.data.frame(x[1:5, ])

}
