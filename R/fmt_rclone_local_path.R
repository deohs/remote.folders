#' Format the rclone local path string
#'
#' Return a character string of the rclone local folder path formatted for
#'     use as an argument to rclone, as executed with, e.g., `base::system2()`.
#' @param local_path (character) The rclone local path. (Default: none)
#' @return (character) The rclone local path will be returned as a character
#'     string.
#' @keywords rclone
#' @section Details:
#' The rclone local path string is intended to be used with rclone sync.
#' @examples
#' rclone_local_path <- fmt_rclone_local_path('/path/to/og_mygroup/Documents')
#' @export
fmt_rclone_local_path <- function(local_path) {
  shQuote(normalizePath(local_path, mustWork = FALSE))
}
