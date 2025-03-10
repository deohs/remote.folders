# remote.folders

This is an R package for using remote folders with rclone and other storage sync tools such as OneDrive app. 

Rclone users will 
also need to [download and install rclone](https://rclone.org/install/). Then 
you will want to [configure rclone](https://rclone.org/docs/) for the remotes 
you intend to use.

See also: the [folders](https://github.com/deohs/folders/) package. 

## Installation

You can install the development version from GitHub with:

```
# install.packages("devtools")
devtools::install_github("deohs/remote.folders")
```
Or, if you prefer using pacman:

```
if (!requireNamespace("pacman", quietly = TRUE)) install.packages('pacman')
pacman::p_install_gh("deohs/remote.folders")
```

## Usage

This package is intended to be used with its sister package 
[folders](https://github.com/deohs/folders/) as follows:

### Example: initial remote folders setup 

Configure your folder paths and store them in a configuration file:

```
# Attach packages, installing as needed
if(!requireNamespace('pacman', quietly = TRUE)) install.packages('pacman')
pacman::p_load(folders, tibble)
pacman::p_load_gh("deohs/remote.folders")

# Define remote path variables
remote_org <- 'myorg'
remote_name <- 'mygroup'
remote_path <- file.path('Documents')

# Create paths for OneDrive and SharePoint folders
m365_folders <- get_m365_folders(remote_org)

# Create folders if missing
res <- create_folders(m365_folders)

# Define local path variable
local_path <- file.path(m365_folders$sharepoint, remote_name, remote_path)

# Define an alternate data path
data_path <- normalizePath(file.path(local_path, 'data'), mustWork = FALSE)

# Create a default list of folders
folders <- list(default = get_folders(here::here('conf', 'folders.yml')))

# Add the alternate data path to the folders list
folders[[Sys.info()[['sysname']]]]$data <- data_path

# +++++++++++++
# rclone setup
# +++++++++++++
#
# Setup for rclone is optional if you intend to use the OneDrive app instead
#
# Format remote and local paths for rclone
remote_path <- fmt_rclone_remote_path(remote_name, remote_path)
local_path <- fmt_rclone_local_path(local_path)
#
# Create a list of rclone configuration parameters
rclone <- tibble::lst(remote_org, remote_name, remote_path, local_path)
#
# Sync files from remote to confirm the settings are correct (optional)
with(rclone, rclone_sync(remote_name, remote_path, local_path))
#
# Add the rclone parameters to the folders list
folders[[Sys.info()[['sysname']]]]$rclone <- rclone
#
# ++++++++++++++++++++
# End of rclone setup
# ++++++++++++++++++++

# Save the modified folder configuration to a new configuration file
yaml::write_yaml(folders, file = here::here('conf', 'folders_sp.yml'))
```

### Example: using remote folders after configuration

Now that there is a configuration file containing your settings, you 
can use code like this in your R scripts:

```
# Attach packages, installing as needed
if(!requireNamespace('pacman', quietly = TRUE)) install.packages('pacman')
pacman::p_load(folders)
pacman::p_load_gh("deohs/remote.folders")

# Read edited configuration file
conf <- here::here('conf', 'folders_sp.yml')
folders <- get_folders(conf, conf_name = Sys.info()[['sysname']])

# Sync files from remote
if ('rclone' %in% names(folders)) {
  with(folders$rclone, rclone_sync(remote_name, remote_path, local_path))
}

# Create data folder if missing
res <- create_folders(folders$data)

# Save a file to the data folder
write.csv(iris, file = file.path(folders$data, 'iris.csv'), row.names = FALSE)

# Show contents of data folder
fs::dir_ls(folders$data)

# Sync files to remote
if ('rclone' %in% names(folders)) {
  with(folders$rclone, rclone_sync(remote_name, local_path, remote_path))
}
```
