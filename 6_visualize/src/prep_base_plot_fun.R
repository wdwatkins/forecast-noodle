prep_base_plot_fun <- function(timesteps, stage_range) {
  
  plot_fun <- function(){
    plot(
      x = c(head(timesteps,1), tail(timesteps,1)), 
      y = c(stage_range[[1]], stage_range[[2]]), 
      xlab = "Time", ylab = "Stage, ft",
      type = 'n')
  }
  return(plot_fun)
}
