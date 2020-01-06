create_fetch_mesonet_makefile <- function(makefile, task_plan, remake_file) {
  scipiper::create_task_makefile(
    makefile=makefile, task_plan=task_plan,
    include=remake_file,
    packages=c('dplyr', 'scipiper'),
    sources=c(
      '1_fetch/src/download_mesonet_data.R'),
    file_extensions=c('ind')
  )
}
