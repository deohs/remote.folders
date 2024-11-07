# remote.folders

This is an R package for using remote folders with rclone. 
See also: the {[folders](https://github.com/deohs/folders/)} package. You will 
also want to [download and install rclone](https://rclone.org/install/). Then 
you will want to [configure rclone](https://rclone.org/docs/) for the remotes 
you intend to use.

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
{[folders](https://github.com/deohs/folders/)} as follows:

### Package setup

```
# Attach packages, installing as needed
if(!requireNamespace('pacman', quietly = TRUE)) install.packages('pacman')
pacman::p_load(folders)
pacman::p_load_gh("deohs/remote.folders")
```

### Example: initial rclone setup for an R project

Configure your rclone paths and store them in a configuration file:

```
# Define remote path variables
remote_org <- 'myorg'
remote_name <- 'mygroup'
remote_path <- file.path('Documents')

# Create paths for OneDrive and SharePoint folders
m365_folders <- get_m365_folders(remote_org)

# Create folders if missing
res <- create_folders(m365_folders)

# List the folders in the top-level of the OneDrive and SharePoint folders
list.dirs(m365_folders$onedrive, recursive = FALSE, full.names = FALSE)
list.dirs(m365_folders$sharepoint, recursive = FALSE, full.names = FALSE)

# Define local path variable
local_path <- file.path(m365_folders$sharepoint, remote_name, remote_path)

# Define remote and local paths for rclone
rclone_remote_path <- fmt_rclone_remote_path(remote_name, remote_path)
rclone_local_path <- fmt_rclone_local_path(local_path)

# Sync files from remote
rclone_sync(remote_name, rclone_remote_path, rclone_local_path)

# Setup folders
conf <- here::here('conf', 'folders.yml')
folders <- get_folders(conf)

# Create a default list of folders
folders_list <- list(default = folders)

# Define an alternate data path
data_path <- normalizePath(file.path(local_path, 'data'), mustWork = FALSE)

# Create a list of rclone configuration parameters
rclone_list <- list(remote_name = remote_name, 
                    remote_path = remote_path, 
                    local_path = local_path)

# Add the alternate data path and the rclone parameters to the folders list
sysname <- Sys.info()[['sysname']]
folders_list[[sysname]]$data <- data_path
folders_list[[sysname]]$rclone <- rclone_list

# Save the modified folder configuration to a new configuration file
conf <- here::here('conf', 'folders_sp.yml')
yaml::write_yaml(folders_list, file = conf)
```

### Example: using rclone after configuration

Now that there is a configuration file containing your rclone settings, you 
can use code like this in your R scripts:

```
# Attach packages, installing as needed
if(!requireNamespace('pacman', quietly = TRUE)) install.packages('pacman')
pacman::p_load(folders)
pacman::p_load_gh("deohs/remote.folders")

# Read edited configuration file
sysname <- Sys.info()[['sysname']]
conf <- here::here('conf', 'folders_sp.yml')
folders <- get_folders(conf, conf_name = sysname)
data_folder <- normalizePath(folders$data, mustWork = FALSE)

# Create data folder if missing
res <- if (!dir.exists(data_folder)) create_folders(data_folder)

# Save a file to the data folder
write.csv(iris, file = file.path(data_folder, 'iris.csv'), row.names = FALSE)

# Show contents of data folder
normalizePath(list.files(data_folder, recursive = TRUE, full.names = TRUE))

# Define remote, remote path and local path for rclone sync
remote_name <- folders$rclone$remote_name
rclone_remote_path <- fmt_rclone_remote_path(remote_name, 
                                             folders$rclone$remote_path)
rclone_local_path <- fmt_rclone_local_path(folders$rclone$local_path)

# Sync files to remote
rclone_sync(remote_name, rclone_local_path, rclone_remote_path)
```
