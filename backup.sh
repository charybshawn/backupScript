#!/bin/bash

#Bash Script Directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
GREEN='0;32'
NC='\033[0m' # No Color

# Folders to backup
backup_dir=/home/thor/.config/
# Destination Directories
dest_dir=/data/backups
# Temporary Directory
temp_dir=$dest_dir/tmp

#Remove all prexisting tmp directories
rm -R $dest_dir/tmp/*

#Create destination directory if it does not exist.
mkdir -p $dest_dir/$HOSTNAME

# Create archive filename.
timestamp=$(date +"%Y%m%d")
archive_file=mediaServer"_"$timestamp.tgz

# Print start status message.
echo "Backing up the contents of: $backup_dir and archiving to $dest_dir/$archive_file"
echo

printf "Shutting down all docker containers.."
# Close all docker containers while we complete the backup
docker kill $(docker ps -q)
printf " ${GREEN}DONE${NC}"

# Create TMP dir
mkdir -p $temp_dir

# Backup the files using tar.
echo "Pulling in all the files and prepping archive.."
rsync --info=progress2 -ra --no-o --no-g --no-perms --exclude-from="$SCRIPT_DIR/excludes.txt" $backup_dir $temp_dir
echo

echo "Compressing and moving files.."
#tar -czf --totals=SIGUSR1 --verbose  $dest_dir/tmp_$timestamp
tar czf - $temp_dir | pv -s $(du -sb $dest_dir/$archive_file | awk '{print $1}') | gzip > $archive_file


echo "Restarting all docker containers.."
# Restart all docker containers
docker start $(docker ps -a -q)

# Cleanup and remove old tmp directory
rm -R $temp_dir/*

# Print end status message.
echo
echo "Backup completed."
