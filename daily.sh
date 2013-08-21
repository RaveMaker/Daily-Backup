#!/bin/sh
echo "Starting Daily Backup"
echo "Please Wait..."

SNAPSHOT_RW=/backup;
SOURCEPATH=/home;

# step 1: delete the oldest snapshot, if it exists:
if [ -d $SNAPSHOT_RW/daily.5 ] ;
then
	rm -rf $SNAPSHOT_RW/daily.5 ;
fi ;
	
# step 2: shift the middle snapshots(s) back by one, if they exist
if [ -d $SNAPSHOT_RW/daily.4 ] ;
then
	mv $SNAPSHOT_RW/daily.4 $SNAPSHOT_RW/daily.5 ;
fi;
if [ -d $SNAPSHOT_RW/daily.3 ] ;
then
	mv $SNAPSHOT_RW/daily.3 $SNAPSHOT_RW/daily.4 ;
fi;
if [ -d $SNAPSHOT_RW/daily.2 ] ;
then
	mv $SNAPSHOT_RW/daily.2 $SNAPSHOT_RW/daily.3 ;
fi;
if [ -d $SNAPSHOT_RW/daily.1 ] ;
then
	mv $SNAPSHOT_RW/daily.1 $SNAPSHOT_RW/daily.2 ;
fi;

# step 3: make a hard-link-only (except for dirs) copy of the latest snapshot, if that exists
if [ -d $SNAPSHOT_RW/daily.0 ] ; 
then
	cp -al $SNAPSHOT_RW/daily.0 $SNAPSHOT_RW/daily.1 ;
fi;
	
# step 4: rsync from the system into the latest snapshot (notice that
# rsync behaves like cp --remove-destination by default, so the destination
# is unlinked first.  If it were not so, this would copy over the other
# snapshot(s) too!
rsync -va --delete --delete-excluded --exclude-from '$SNAPSHOT_RW/exclude.txt' $SOURCEPATH $SNAPSHOT_RW/daily.0 ;
		    
# step 5: update the mtime of daily.0 to reflect the snapshot time
touch $SNAPSHOT_RW/daily.0 ;

echo "All Done!"
