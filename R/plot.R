
W2E <-function(x)   {
  cbind(which(x!=0,arr.ind=TRUE),x[x!=0])
}



#' Plot time profiles given a time-series generated by impulse response analysis
#'
#'
#' @param time.series.data data of impulse response in long format
#' @param var.number number of variables in the time-series
#' @param threshold threshold of asymptote of equilibrium
#' @param xupper upper limit of x-axis
#'
#' @return NULL
#'
#' @examples
#' \dontshow{
#'plot_time_profile(time.series.data = bootstrap_iRAM_2node$time.profile.data,
#'                  var.number = 2,
#'                  threshold= .01,
#'                  xupper = 20)
#' }
#'
#' \donttest{
#'plot_time_profile(time.series.data = bootstrap_iRAM_2node$time.profile.data,
#'                  var.number = 2,
#'                  threshold= .01,
#'                  xupper = 20)
#'}
#'
#' @export
#'

plot_time_profile <- function(time.series.data,
                              var.number,
                              threshold = .01,
                              xupper = 20)
{
  time.series.data <- data.frame(time.series.data)
  data.names <- names(time.series.data)


  if (ncol(time.series.data) > var.number * var.number + 1){ # bootstrap version
    var.number <- sqrt(ncol(time.series.data)-2)
    time.series.data <- melt(time.series.data, id = c("repnum", "steps"))
    print(
      ggplot(data = time.series.data,
             aes(x = steps, y = value, group = repnum, color = variable))+
        geom_line(alpha = 0.5)+
        geom_hline(yintercept = threshold, alpha = 0.5) +
        geom_hline(yintercept = -threshold, alpha = 0.5)+
        xlim(0,xupper) +
        facet_wrap(~variable, ncol = var.number) +
        theme(
          panel.background = element_blank(),
          plot.background = element_blank(),
          strip.background = element_blank(),
          axis.text.y=element_text(color="black",size=12),
          axis.text.x=element_text(color="black",size=12),
          axis.title.y=element_text(color="black",size=12),
          axis.title.x=element_text(color="black",size=12),
          panel.grid = element_blank(),
          legend.position = "none",
          axis.line = element_line(color = 'black')
        ))

  } else  { # point estimate version
    # print("inside")
    var.number <- sqrt(ncol(time.series.data)-1)
    time.series.data <- melt(time.series.data, id = "steps")
    print(
      ggplot(data = time.series.data,
             aes(x = steps, y = value, color = variable))+
        geom_line(size = .5)+
        geom_hline(yintercept = threshold, alpha = 0.5) +
        geom_hline(yintercept = -threshold, alpha = 0.5)+
        xlim(0,xupper) +
        facet_wrap(~variable, ncol = var.number) +
        theme(
          panel.background = element_blank(),
          plot.background = element_blank(),
          strip.background = element_blank(),
          axis.text.y=element_text(color="black",size=12),
          axis.text.x=element_text(color="black",size=12),
          axis.title.y=element_text(color="black",size=12),
          axis.title.x=element_text(color="black",size=12),
          panel.grid = element_blank(),
          legend.position = "none",
          axis.line = element_line(color = 'black')
        ))
  }
  # return (p)
  return(NULL)
}


#' Plot distribution of recovery time based on bootstrapped version of iRAM
#' @param recovery.time.reps bootstrapped version of recovery time
#'
#' @return NULL
#'
#' @examples
#' \dontshow{
#' plot_iRAM_dist(bootstrap_iRAM_3node$recovery.time.reps)
#' }
#' \donttest{
#' plot_iRAM_dist(bootstrap_iRAM_3node$recovery.time.reps)
#' }
#'
#' @export
#'

plot_iRAM_dist <- function(recovery.time.reps){

  recovery.time.reps.plot <- data.frame(recovery.time.reps)
  var.number <- sqrt(ncol(recovery.time.reps))

  column.names <- NULL
  for (from in 1:var.number)
  {
    for (to in 1:var.number)
    {
      column.names <- cbind(column.names,paste("from.", from, ".to.", to, sep = ""))
    }
  }
  # print(column.names)
  names(recovery.time.reps.plot) <- column.names

  recovery.time.reps.plot$index <- 1:nrow(recovery.time.reps)
  recovery.time.reps.plot <- melt(recovery.time.reps.plot, id = "index")

  print(ggplot(data = recovery.time.reps.plot, aes(x = value))+
    geom_histogram()+
    facet_wrap(~variable, ncol = var.number)+
    theme(
      panel.background = element_blank(),
      plot.background = element_blank(),
      strip.background = element_blank(),
      axis.text.y=element_text(color="black",size=12),
      axis.text.x=element_text(color="black",size=12),
      axis.title.y=element_text(color="black",size=12),
      axis.title.x=element_text(color="black",size=12),
      panel.grid = element_blank(),
      legend.position = "none",
      axis.line = element_line(color = 'black')
    ))

  # return(p)
  return(NULL)
}




#' Plot the network graph
#'
#' @param beta matrix of temporal relations, cotaining both lag-1 and contemporaneous
#' @param var.number number of variables in the time series
#'
#' @return NULL
#'
#' @examples
#' \dontshow{
#' plot_network_graph(beta = true_beta_3node,
#'                   var.number = 3)
#' }
#'
#' \donttest{
#' plot_network_graph(beta = true_beta_3node,
#'                   var.number = 3)
#' }
#'
#' @export
#'

plot_network_graph <- function(beta, var.number)
{
  p <- var.number
  contemporaneous.relations <- matrix(beta[(p+1):(2*p),(p+1):(2*p)], nrow = p, ncol = p, byrow = F)
  lag.1.relations <- matrix(beta[(p+1):(2*p),1:p], nrow = p, ncol = p, byrow = F)

  econtemporaneous <- W2E(t(contemporaneous.relations))
  elag1 <- W2E(t(lag.1.relations))
  plot.names <- 1:var.number

  # somehow if the the dimension of edge matrix is the same with var.number
  # the edge list was recognized as edge matrix, so I am omitting the graph in this

  if (nrow(rbind(elag1, econtemporaneous)) > var.number){
    isLagged               <- c(rep(TRUE, nrow(elag1)), rep(FALSE, nrow(econtemporaneous)))
    curve                  <- rep(1, length(isLagged))

    qgraph(rbind(elag1, econtemporaneous),
           layout              = "circle",
           lty                 = ifelse(isLagged,2, 1),
           edge.labels         = F,
           curve               = curve,
           fade                = FALSE,
           posCol              = "green",
           negCol              = "red",
           labels              = plot.names,
           label.cex           = 1,
           label.norm          = "O",
           label.scale         = FALSE,
           edge.label.cex      = 5,
           edge.label.position = .3,
           edge.width = 2)
  }
  return(NULL)
}





#' Plot the time profiles in the integrated form
#'
#' @param beta.matrix matrix of temporal relations, cotaining both lag-1 and contemporaneous
#' @param var.number number of variables in the time series
#' @param lag.order lag order of the model to be fit
#'
#' @return NULL
#'
#' @examples
#' \dontshow{
#' plot_integrated_time_profile(beta.matrix = true_beta_3node,
#'                   var.number = 3,
#'                   lag.order = 1)
#' }
#'
#' \donttest{
#' plot_integrated_time_profile(beta.matrix = true_beta_3node,
#'                   var.number = 3,
#'                   lag.order = 1)
#' }
#'
#' @export
#'
#'
plot_integrated_time_profile <- function(beta.matrix ,
                                         var.number ,
                                         lag.order = 1)
{
  # this generates the time series data of difference score (output in "iRAM_ts$time.series.data")
  iRAM_ts <- iRAM(model.fit = NULL,
                  beta = beta.matrix,
                  var.number = var.number,
                  lag.order = lag.order,
                  threshold = 0.01,
                  boot = FALSE,
                  replication = 200,
                  steps = 100)

  # integrate the time series data of difference score
  iRAM_ts_integrated <- iRAM_ts$time.series.data
  iRAM_ts_integrated[1,2:ncol(iRAM_ts_integrated)] <- rep(0,ncol(iRAM_ts_integrated) - 1) # make integrated value = 0 at t = 1

  # integration starting from t = 2, to remove the given impulse value
  for (index in 3:nrow(iRAM_ts_integrated))
  {
    iRAM_ts_integrated[index,2:ncol(iRAM_ts_integrated)] <-
      iRAM_ts_integrated[index-1,2:ncol(iRAM_ts_integrated)] +
      iRAM_ts_integrated[index,2:ncol(iRAM_ts_integrated)]
  }

  plot_time_profile(iRAM_ts_integrated,
                    var.number = var.number,
                    threshold = 0,
                    xupper = 50)
  return (NULL)
}
