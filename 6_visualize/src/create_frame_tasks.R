create_frame_tasks <- function(timesteps, folders){
  
  # prepare a data.frame with one row per task
  tasks <- data_frame(timestep=timesteps) %>%
    mutate(task_name = strftime(timestep, format = '%Y%m%d_%H', tz = 'UTC'))
  
  # ---- timestep-specific png plotting layers ---- #
  
  observed_line <- scipiper::create_task_step(
    step_name = 'observed_line',
    target_name = function(task_name, step_name, ...){
      cur_task <- dplyr::filter(rename(tasks, tn=task_name), tn==task_name)
      sprintf('observed_line_fun_%s', task_name)
    },
    command = function(task_name, ...){
      cur_task <- dplyr::filter(rename(tasks, tn=task_name), tn==task_name)
      psprintf(
        "prep_observed_line_fun(",
        "nwis_data_ind = '1_fetch/out/nwis_data.rds.ind',",
        sprintf("task_dateTime = I('%s'))", format(cur_task$timestep, "%Y-%m-%d %H:%M:%S")))
    }
  )
  
  modeled_lines <- scipiper::create_task_step(
    step_name = 'modeled_lines',
    target_name = function(task_name, step_name, ...){
      cur_task <- dplyr::filter(rename(tasks, tn=task_name), tn==task_name)
      sprintf('modeled_lines_fun_%s', task_name)
    },
    command = function(task_name, ...){
      cur_task <- dplyr::filter(rename(tasks, tn=task_name), tn==task_name)
      psprintf(
        "prep_modeled_lines_fun(",
        sprintf("mesonet_data_ind = '1_fetch/out/mesonet_data_%s.rds.ind',", task_name),
        sprintf("task_dateTime = I('%s'))", format(cur_task$timestep, "%Y-%m-%d %H:%M:%S")))
    }
  )
  
  # ---- main target for each task: the
  
  complete_png <- scipiper::create_task_step(
    step_name = 'complete_png',
    target_name = function(task_name, step_name, ...){
      file.path(folders$tmp, sprintf('frame_%s.png', task_name))
    },
    command = function(task_name, ...){
      cur_task <- dplyr::filter(rename(tasks, tn=task_name), tn==task_name)
      psprintf(
        "create_frame(",
        "png_file=target_name,",
        "base_plot_fun,",
        #"watermark_fun,",
        "observed_line_fun_%s,"=cur_task$tn,
        "modeled_lines_fun_%s)"=cur_task$tn
      )
    }
  )
  
  # ---- combine into a task plan ---- #
  
  gif_task_plan <- scipiper::create_task_plan(
    task_names=tasks$task_name,
    task_steps=list(
      observed_line,
      modeled_lines,
      complete_png),
    add_complete=FALSE,
    final_steps='complete_png',
    ind_dir=folders$log)
}
