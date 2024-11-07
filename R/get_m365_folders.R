#' Construct Microsoft 365 (m365) folder paths
#'
#' Return a named list of m365 folder paths that can be used for local storage.
#' @param m365_org (character) The m365 organization name. (Default: 'ORG')
#' @param m365_names (character) Names to be assigned to the list of folders.
#'     (Default: c('onedrive', 'sharepoint'))
#' @param m365_prefix (character) Folder name prefixes to used with m365_org.
#'     (Default: c('OneDrive - ', ''))
#' @param parent_folder (character) Folder name under which the m365 folders
#'     will be found. (Default: fs::path_home())
#' @return (list) The named folder paths for a m365 file structure, will be
#'     returned as a list.
#' @keywords m365
#' @section Details:
#' The list of folders can be used to create any which are missing or to
#' refer to a folder path by name to avoid hardcoding paths in scripts.
#'
#' The folder paths will be subfolders relative to the parent folder (usually
#' your home folder) and will be used for syncing a local copy with m365 files.
#' @examples
#' m365_folders <- get_m365_folders(m365_org = 'UW')
#' @export
get_m365_folders <- function(m365_org = 'ORG',
                             m365_names = c('onedrive', 'sharepoint'),
                             m365_prefix = c('OneDrive - ', ''),
                             parent_folder = fs::path_home()) {
  stats::setNames(as.list(normalizePath(
    file.path(parent_folder, paste0(m365_prefix, m365_org)), mustWork = FALSE)),
    m365_names)
}
