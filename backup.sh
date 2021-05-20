#!/bin/bash

#Bash Script Directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

start=`date +%s`
# Folders to backup
backup_dir=/home
# Destination Directories
dest_dir=/data/backups/$HOSTNAME
# Temporary Directory
temp_dir=$dest_dir/tmp

#Remove all prexisting tmp directories
rm -Rf $dest_dir/tmp/*

#Create destination directory if it does not exist.
mkdir -p $dest_dir
mkdir -p $temp_dir

# Create archive filename.
timestamp=$(date +"%Y%m%d")
archive_file="$timestamp-$HOSTNAME.tgz"

# Print start status message.
echo "Backing up the contents of: $backup_dir and archiving to $dest_dir/$archive_file"
echo

echo "Shutting down all docker containers.."
# Close all docker containers while we complete the backup
docker kill $(docker ps -q) &>/dev/null
echo

# Create TMP dir
mkdir -p $temp_dir

# Backup the files using tar.
echo "Pulling in all the files and prepping archive.."
printf "RSYNC working.."
rsync -aq --no-o --no-g --no-perms --exclude-from="$SCRIPT_DIR/excludes.txt" $backup_dir $temp_dir
printf "done\n"
echo

echo "Compressing and moving files.."
printf "TAR working.."
tar -zcf $dest_dir/$archive_file $temp_dir &>/dev/null
printf "done\n"
echo 

printf "Restarting all docker containers.."
# Restart all docker containers
docker start $(docker ps -a -q) &>/dev/null
printf "done\n"

echo "Cleaning up"
# Cleanup and remove old tmp directory
rm -R $temp_dir

# Print end status message.
echo
echo "Backup was completed in: $((($(date +%s)-$start)/60)) mins."
