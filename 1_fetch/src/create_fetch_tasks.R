create_fetch_mesonet_tasks <- function(timesteps, nws_site, log_folder, tmp_folder){
  
  # prepare a data.frame with one row per task
  tasks <- tibble(timestep=timesteps) %>%
    mutate(task_name = strftime(timestep, format = '%Y%m%d_%H', tz = 'UTC'))
  
  # ---- main target for each task
  
  download_mesonet_data <- scipiper::create_task_step(
    step_name = 'download_mesonet_data',
    target_name = function(task_name, step_name, ...){
      file.path(tmp_folder, sprintf('mesonet_data_%s.rds.ind', task_name))
    },
    command = function(task_name, ...){
      cur_task <- dplyr::filter(rename(tasks, tn=task_name), tn==task_name)
      psprintf(
        "download_mesonet_data(",
        "ind_file=target_name,",
        sprintf("nws_site=I('%s'),", nws_site),
        sprintf("dateTime_str=I('%s'))", task_name)
      )
    }
  )
  
  
  # ---- combine into a task plan ---- #
  
  gif_task_plan <- scipiper::create_task_plan(
    task_names=tasks$task_name,
    task_steps=list(
      download_mesonet_data),
    add_complete=FALSE,
    final_steps='download_mesonet_data',
    ind_dir=log_folder)
}

# helper function to sprintf a bunch of key-value (string-variableVector) pairs,
# then paste them together with a good separator for constructing remake recipes
psprintf <- function(..., sep='\n      ') {
  args <- list(...)
  non_null_args <- which(!sapply(args, is.null))
  args <- args[non_null_args]
  argnames <- sapply(seq_along(args), function(i) {
    nm <- names(args[i])
    if(!is.null(nm) && nm!='') return(nm)
    val_nm <- names(args[[i]])
    if(!is.null(val_nm) && val_nm!='') return(val_nm)
    return('')
  })
  names(args) <- argnames
  strs <- mapply(function(template, variables) {
    spargs <- if(template == '') list(variables) else c(list(template), as.list(variables))
    do.call(sprintf, spargs)
  }, template=names(args), variables=args)
  paste(strs, collapse=sep)
}
