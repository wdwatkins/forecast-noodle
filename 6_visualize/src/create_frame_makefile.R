create_frame_makefile <- function(makefile, task_plan, remake_file) {
  scipiper::create_task_makefile(
    makefile=makefile, task_plan=task_plan,
    include=remake_file,
    packages=c('dplyr', 'scipiper'),
    sources=c(
      '6_visualize/src/create_frame.R',
      '6_visualize/src/prep_observed_line_fun.R',
      '6_visualize/src/prep_modeled_lines_fun.R'),
    file_extensions=c('feather','ind')
  )
}
