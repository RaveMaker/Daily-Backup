#!/bin/bash

# Make Daily backups with File based DeDup using rsync.
#
# by RaveMaker - http://ravemaker.net

# Settings
SNAPSHOT_RW="/backup"
SOURCEPATH="/home"
MAXSNAP=5
CURRENTDIR=`pwd`

# Move to backup location
echo "Starting Daily Backup Please Wait..."
cd $SNAPSHOT_RW

# step 1: delete the oldest snapshot, if it exists:
if [ -d daily.$MAXSNAP/ ]
then
	echo "Removing oldest backup copy"
	rm -rf daily.$MAXSNAP/
fi

# step 2: shift the middle snapshots(s) back by one, if they exist
let "MAXSNAP -= 1"
while [  $MAXSNAP -ne "0" ]; do
    if [ -d daily.$MAXSNAP/ ]
    then
	NEWSNAP=$(($MAXSNAP + 1))
	echo "daily.$MAXSNAP moved to daily.$NEWSNAP"
	mv daily.$MAXSNAP daily.$NEWSNAP
	let "MAXSNAP -= 1"
    else
	echo "daily.$MAXSNAP not found"
	let "MAXSNAP -= 1"
    fi;
done

# step 3: make a hard-link-only (except for dirs) copy of the latest snapshot, if that exists
if [ -d daily.0/ ]
then
	echo "Make daily.1 a hard-link-only"
	cp -al daily.0/ daily.1/
fi;

# step 4: rsync from the system into the latest snapshot (notice that
# rsync behaves like cp --remove-destination by default, so the destination
# is unlinked first.  If it were not so, this would copy over the other
# snapshot(s) too!
echo "Make daily.0 backup copy"
rsync -va --delete --delete-excluded --exclude-from $CURRENTDIR/exclude.txt $SOURCEPATH $SNAPSHOT_RW/daily.0/

# step 5: update the mtime of daily.0 to reflect the snapshot time
touch daily.0/

cd $CURRENTDIR
echo "All Done!"
