#!/bin/bash

##
# Backup to MergerFS pool
##

# Folders to backup
base_dir = "$PWD/.config/"
backup_dirs="sonarr/Backups radarr/Backups /nzbget"
excludes="$base_dir/sonarr/MediaCover $base_dir/radarr/MediaCover"

# Destination Directories
dest_dir="/mnt/storage/backups"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-mediaServer-$day.tgz"

# Print start status message.
echo "Backing up $backup_dirs to $dest_dir/$archive_file"
date
echo

# Backup the files using tar.
rsync -avzh --exclude-from='excludes.txt' backup_dirs/ dest_dir/

# Print end status message.
echo
echo "Backup complete."
date