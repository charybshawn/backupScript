#!/bin/bash

# Folders to backup
backup_dir=/home/thor/.config/

# Destination Directories
dest_dir=/mnt/storage/backups

# Create archive filename.
timestamp=$(date +"%Y%m%d")
hostname=$(hostname -s)
archive_file=mediaServer"_"$hostname"_"$timestamp.tgz

# Print start status message.
echo "Backing up $backup_dir to $dest_dir/$archive_file"
echo

# Create TMP dir
mkdir $dest_dir/tmp_$timestamp

# Backup the files using tar.
rsync -ra --exclude-from="excludes.txt" $backup_dir "$dest_dir/tmp_$timestamp"
tar -cf  $dest_dir/$archive_file $dest_dir/tmp_$timestamp

# Cleanup and remove old tmp directory
rm -R $dest_dir/tmp_$timestamp

# Print end status message.
echo
echo "Backup complete. Removed tmp directory."