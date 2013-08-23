#!/bin/sh

echo "Starting Weekly Backup Please Wait..."

SNAPSHOT_RW=/backup;

# step 1: delete the oldest snapshot, if it exists:
if [ -d $SNAPSHOT_RW/weekly.3 ] ;
then
	rm -rf $SNAPSHOT_RW/weekly.3 ;
fi;

# step 2: shift the middle snapshots(s) back by one, if they exist
if [ -d $SNAPSHOT_RW/weekly.2 ] ;
then
    mv $SNAPSHOT_RW/weekly.2 $SNAPSHOT_RW/weekly.3 ;
fi;
if [ -d $SNAPSHOT_RW/weekly.1 ] ;
then
    mv $SNAPSHOT_RW/weekly.1 $SNAPSHOT_RW/weekly.2 ;
fi;
if [ -d $SNAPSHOT_RW/weekly.0 ] ;
then
    mv $SNAPSHOT_RW/weekly.0 $SNAPSHOT_RW/weekly.1;
fi;

# step 3: make a hard-link-only (except for dirs) copy of
# daily.5, assuming that exists, into weekly.0
if [ -d $SNAPSHOT_RW/daily.5 ] ;
then
    cp -al $SNAPSHOT_RW/daily.5 $SNAPSHOT_RW/weekly.0 ;
fi;

# note: do *not* update the mtime of weekly.0; it will reflect
# when daily.5 was made, which should be correct.

echo "All Done!"
