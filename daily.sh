#!/bin/bash

# Make Daily backups with File based DeDup using rsync.
#
# by RaveMaker - http://ravemaker.net

# Load settings
if [ -f settings.cfg ]; then
  echo "Loading settings..."
  source settings.cfg
else
  echo "ERROR: Create settings.cfg (from settings.cfg.example)"
  exit
fi

# Move to backup location
echo "Starting Daily Backup Please Wait..."
cd "$SNAPSHOT_RW" 2>/dev/null || {
  echo "$SNAPSHOT_RW directory not found"
  exit
}

# step 1: delete the oldest snapshot, if it exists:
if [ -d "daily.$MAX_DAILY_SNAPS/" ]; then
  echo "Removing oldest backup copy"
  if [ "$DEBUG_MODE" == "false" ]; then
    rm -rf "daily.$MAX_DAILY_SNAPS/"
  fi
fi

# step 2: shift the middle snapshots(s) back by one, if they exist
((MAX_DAILY_SNAPS -= 1))
while [ $MAX_DAILY_SNAPS -ne "0" ]; do
  if [ -d daily.$MAX_DAILY_SNAPS/ ]; then
    NEWSNAP=$((MAX_DAILY_SNAPS + 1))
    echo "daily.$MAX_DAILY_SNAPS moved to daily.$NEWSNAP"
    if [ "$DEBUG_MODE" == "false" ]; then
      mv daily.$MAX_DAILY_SNAPS daily.$NEWSNAP
    fi
  else
    echo "daily.$MAX_DAILY_SNAPS not found"
  fi
  ((MAX_DAILY_SNAPS -= 1))
done

# step 3: make a hard-link-only (except for dirs) copy of the latest snapshot, if that exists
if [ -d daily.0/ ]; then
  echo "Make daily.1 a hard-link-only"
  if [ "$DEBUG_MODE" == "false" ]; then
    cp -al daily.0/ daily.1/
  fi
fi

# step 4: rsync from the system into the latest snapshot (notice that
# rsync behaves like cp --remove-destination by default, so the destination
# is unlinked first.  If it were not so, this would copy over the other
# snapshot(s) too!
echo "Make daily.0 backup copy"
if [ "$DEBUG_MODE" == "false" ]; then
  rsync -avP --delete --delete-excluded --exclude-from "$EXCLUDE" "$SOURCE_PATH $SNAPSHOT_RW/daily.0/"
fi

# step 5: update the mtime of daily.0 to reflect the snapshot time
if [ "$DEBUG_MODE" == "false" ]; then
  touch daily.0/
fi

echo "All Done!"
