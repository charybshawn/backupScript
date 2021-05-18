#!/bin/bash

#Bash Script Directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Folders to backup
backup_dir=/home/thor/.config/
# Destination Directories
dest_dir=/data/backups/$HOSTNAME

#Create destination directory if it does not exist.
mkdir -p $backup_dir/$HOSTNAME

# Create archive filename.
timestamp=$(date +"%Y%m%d")
archive_file=mediaServer"_"$timestamp.tgz

# Print start status message.
echo "Backing up the contents of: $backup_dir and archiving to $dest_dir/$archive_file"

# Close all docker containers while we complete the backup
docker kill $(docker ps -q)

# Create TMP dir
mkdir -p $dest_dir/tmp_$timestamp

# Backup the files using tar.
echo "Pulling in all the files and prepping for compression.."
rsync --info=progress2 -ra --no-o --no-g --no-perms --exclude-from="$SCRIPT_DIR/excludes.txt" $backup_dir "$dest_dir/tmp_$timestamp"
echo
echo "Compressing and moving files.."
tar -czf --totals=SIGUSR1 --verbose $dest_dir/$archive_file $dest_dir/tmp_$timestamp

# Restart all docker containers
docker start $(docker ps -a -q)

# Cleanup and remove old tmp directory
rm -R $dest_dir/tmp_$timestamp

# Print end status message.
echo
echo "Backup completed."
