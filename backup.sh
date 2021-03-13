#!/bin/bash

##
# Backup to MergerFS pool
##

# Folders to backup
backup_dir = "$PWD/.config/"

# Destination Directories
dest_dir="/mnt/storage/backups"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-mediaServer-$day.tgz"

# Print start status message.
echo "Backing up $backup_dir to $dest_dir/$archive_file"
date
echo

# Backup the files using tar.
rsync -avzh --exclude-from="excludes.txt" backup_dirs/ dest_dir/

# Print end status message.
echo
echo "Backup complete."
date