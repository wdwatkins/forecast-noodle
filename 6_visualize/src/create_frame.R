create_frame <- function(png_file, ...) {
  
  if(!is.na(png_file)) {
    plot_type <- switch(Sys.info()[['sysname']],
                        Windows= "cairo",
                        Linux  = "Xlib",
                        Darwin = "quartz")
    # open the plotting device
    png(filename=png_file, width=800, height=600, units='px', type = plot_type)
  }
  
  # begin using google fonts
  par(family = 'abel') # may need to install from Google Fonts with sysfonts::font_add_google('Abel','abel')
  showtext_begin()
  
  # plot the pieces in order, passing through data files or R objects from the
  # scipiper pipeline
  plot_funs <- c(...)
  
  for (plot_fun in plot_funs){
    plot_fun()
  }
  
  # close off google fonts
  showtext_end()
  
  # close off the plotting device
  if(!is.na(png_file)) dev.off()
}
