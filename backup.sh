#!/bin/bash

# Folders to backup
backup_dir="/home/thor/.config"

# Destination Directories
dest_dir="/mnt/storage/backups"

# Create archive filename.
timestamp=$(date +"%Y%m%d")
hostname=$(hostname -s)
archive_file="mediaServer-$hostname-$timestamp.tgz"

# Print start status message.
echo "Backing up $backup_dir to $dest_dir/$archive_file"
echo

# Backup the files using tar.
rsync -av --exclude={'exclude.txt'} $backup_dir "$dest_dir/tmp"
#tar -czf  $dest_dir/$archive_file $dest_dir/tmp

# Print end status message.
echo
echo "Backup complete."
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest_dir