#' Bootstrapped iRAM (including replications of iRAM and corresponding time profiles) for the bivariate time-series (simts2node)
#'
#'@details Data bootstrapped from the estimated three-node network structure with 200 replications.
#'
#' @docType data
#'
#' @usage bootstrap_iRAM_2node
#'
#'
#' @examples
#' \dontshow{
#' bootstrap_iRAM_2node$mean # mean of bootstrapped iRAM
#' bootstrap_iRAM_2node$upper # Upper bound of confidence interval of bootstrapped iRAM
#' bootstrap_iRAM_2node$lower # lower bound of confidence interval of bootstrapped iRAM
#' bootstrap_iRAM_2node$time.profile.data # time profiles generated from the bootstrapped beta matrices
#' bootstrap_iRAM_2node$recovery.time.reps # iRAMs generated from the bootstrapped beta matrices
#'}
#' \donttest{
#' bootstrap_iRAM_2node$mean # mean of bootstrapped iRAM
#' bootstrap_iRAM_2node$upper # Upper bound of confidence interval of bootstrapped iRAM
#' bootstrap_iRAM_2node$lower # lower bound of confidence interval of bootstrapped iRAM
#' bootstrap_iRAM_2node$time.profile.data # time profiles generated from the bootstrapped beta matrices
#' bootstrap_iRAM_2node$recovery.time.reps # iRAMs generated from the bootstrapped beta matrices
#'}

"bootstrap_iRAM_2node"
