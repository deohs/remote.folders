#' Format the rclone remote path string
#'
#' Return a character string of the rclone remote folder path formatted for
#'     use as an argument to rclone, as executed with, e.g., `base::system2()`.
#' @param remote_name (character) The rclone remote name. (Default: none)
#' @param remote_path (character) The rclone remote path. (Default: none)
#' @return (character) The rclone remote path will be returned as a character
#'     string.
#' @keywords rclone
#' @section Details:
#' The rclone remote path string is intended to be used with rclone sync.
#' @examples
#' rclone_remote_path <- fmt_rclone_remote_path('og_mygroup', 'Documents')
#' @export
fmt_rclone_remote_path <- function(remote_name, remote_path) {
  file.path(shQuote(remote_name), shQuote(remote_path), fsep = ':')
}
