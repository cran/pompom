#' @import lavaan
#'
#' @import reshape2
#'
#' @import ggplot2
#'
#' @import qgraph
#'
#' @import utils
#'
#' @importFrom stats rnorm
#'
#'


globalVariables(c("value",
                  "variable",
                  "repnum",
                  "steps",
                  "simts_3node",
                  "true_beta_3node",
                  "bootstrap_iRAM_3node",
                  "usemmodelfit",
                  "simts_2node",
                  "true_beta_2node",
                  "bootstrap_iRAM_2node"),
                "pompom", add = TRUE)

