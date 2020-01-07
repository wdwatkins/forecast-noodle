combine_frames_video <- function(out_file, animation_cfg) {
  #build video from pngs with ffmpeg
  #note that this will use all frames in 6_visualize/tmp
  #have to rename files since can't use globbing with ffmpeg on Windows :(
  png_frames <- list.files('6_visualize/tmp', full.names = TRUE)
  file_name_df <- tibble(origName = png_frames,
                         countFormatted = zeroPad(1:length(png_frames), padTo = 3),
                         newName = file.path("6_visualize/tmp", paste0("frame_", countFormatted, ".png")))
  file.rename(from = file_name_df$origName, to = file_name_df$newName)
  
  # added ffmpeg better code for reducing video size
  # see https://unix.stackexchange.com/questions/28803/how-can-i-reduce-a-videos-size-with-ffmpeg
  # and https://slhck.info/video/2017/02/24/crf-guide.html
  
  shell_command <- sprintf(
    "ffmpeg -y -framerate %s -i 6_visualize/tmp/frame_%%03d.png -r %s -pix_fmt yuv420p -vcodec libx264 -crf 27 %s",
    animation_cfg$frame_rate, animation_cfg$output_frame_rate, out_file)
  system(shell_command)
  
  file.rename(from = file_name_df$newName, to = file_name_df$origName)
}
