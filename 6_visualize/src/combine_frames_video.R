combine_frames_video <- function(out_file, animation_cfg, timesteps) {
  #build video from pngs with ffmpeg
  #have to rename files since can't use globbing with ffmpeg on Windows :(
  
  # Get list of frames that should be in this current build
  png_frames_exist <- list.files('6_visualize/tmp', full.names = TRUE)
  png_frames_fresh <- sprintf(
    "6_visualize/tmp/frame_%s.png",
    strftime(timesteps, format = '%Y%m%d_%H', tz = 'UTC')
  )
  stopifnot(all(png_frames_fresh %in% png_frames_exist))
  png_frames <- png_frames_fresh
  
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
