#!/bin/bash

# Make Weekly backups from daily backup copies.
#
# by RaveMaker - http://ravemaker.net

# Settings
SNAPSHOT_RW=/backup;
MAXSNAP=5
CURRENTDIR=`pwd`

# Move to backup location
echo "Starting Weekly Backup Please Wait..."
cd $SNAPSHOT_RW

# step 1: delete the oldest snapshot, if it exists:
if [ -d weekly.$MAXSNAP/ ] ;
then
	rm -rf weekly.$MAXSNAP/ ;
fi;

# step 2: shift the middle snapshots(s) back by one, if they exist
let "MAXSNAP -= 1"
while [  $MAXSNAP -ge "0" ]; do
    if [ -d weekly.$MAXSNAP/ ]
    then
	NEWSNAP=$(($MAXSNAP + 1))
	echo "weekly.$MAXSNAP/ moved to weekly.$NEWSNAP/"
	mv weekly.$MAXSNAP/ weekly.$NEWSNAP/
	let "MAXSNAP -= 1"
    else
	echo "weekly.$MAXSNAP not found"
	let "MAXSNAP -= 1"
    fi;
done

# step 3: make a hard-link-only (except for dirs) copy of
# daily.5, assuming that exists, into weekly.0
if [ -d daily.5/ ] ;
then
    cp -al daily.5/ weekly.0/ ;
fi;

# note: do *not* update the mtime of weekly.0; it will reflect
# when daily.5 was made, which should be correct.

echo "All Done!"
