#' Sync with remote using rclone
#'
#' Sync from the source (src) to the destination (dest) using rclone sync.
#' @param remote_name (character) The rclone remote name. (Default: none)
#' @param src (character) The rclone path for the sync source. (Default: none)
#' @param dest (character) The rclone path for the sync destination.
#'     (Default: none)
#' @param cmd (character) The rclone executable name or the path to the rclone
#'     executable. (Default: 'rclone')
#' @param cmd_args (character vector) The rclone command arguments.
#'     (Default: c('sync', '--update'))
#' @return (none or error message) An error message will be returned upon
#'     error, otherwise nothing is returned.
#' @keywords rclone
#' @section Details:
#' Rclone will be called with `system2()` three times: (1) to get the path
#'     to the config file, (2) to search the config file for the remote name,
#'     and (3) to sync the source to the destination. The source and
#'     destination character strings can be either local or remote, and should
#'     be constructed with `fmt_rclone_local_path()` and
#'     `fmt_rclone_remote_path()`, respectively .
#' @examples
#' rclone_remote_path <- fmt_rclone_remote_path('og_mygroup', 'Documents')
#' rclone_local_path <- fmt_rclone_local_path('/path/to/og_mygroup/Documents')
#' \dontrun{
#' rclone_sync('og_mygroup', rclone_remote_path, rclone_local_path)
#' }
#' @export
rclone_sync <- function(remote_name, src, dest, cmd = 'rclone',
                        cmd_args = c('sync', '--update')) {
  if (file.exists(Sys.which(cmd))) {
    rclone_conf_file <-
      utils::tail(
        system2(command = cmd, args = c('config', 'file'), stdout = TRUE), 1)
    if(file.exists(rclone_conf_file)) {
      rclone_remotes <- names(jsonlite::fromJSON(
        system2(command = cmd, args = c('config', 'dump'), stdout = TRUE)
      ))
      if(remote_name %in% rclone_remotes) {
        res <- system2(command = cmd, args = c(cmd_args, src, dest),
                       stdout = TRUE, stderr = TRUE)
        if (!length(res) == 0) {
          message(res, appendLF = TRUE)
          stop('Abort: rclone sync failed.')
        }
      } else {
        stop('Abort: Cannot find remote name in configuration file.')
      }
    } else {
      stop('Abort: Cannot find configuration file.')
    }
  } else {
    stop(paste0("Abort: Cannot find ", cmd, "."))
  }
}
