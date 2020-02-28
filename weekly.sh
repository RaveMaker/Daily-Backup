#!/bin/bash

# Make Weekly backups from daily backup copies.
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
echo "Starting Weekly Backup Please Wait..."
cd "$SNAPSHOT_RW" || {
  echo "$SNAPSHOT_RW directory not found"
  exit
}

# step 1: delete the oldest snapshot, if it exists:
if [ -d "weekly.$MAX_WEEKLY_SNAPS/" ]; then
  if [ "$DEBUG_MODE" == "false" ]; then
    rm -rf "weekly.$MAX_WEEKLY_SNAPS/"
  fi
fi

# step 2: shift the middle snapshots(s) back by one, if they exist
((MAX_WEEKLY_SNAPS -= 1))
while [ $MAX_WEEKLY_SNAPS -ge "0" ]; do
  if [ -d "weekly.$MAX_WEEKLY_SNAPS/" ]; then
    NEWSNAP=$((MAX_WEEKLY_SNAPS + 1))
    echo "weekly.$MAX_WEEKLY_SNAPS/ moved to weekly.$NEWSNAP/"
    if [ "$DEBUG_MODE" == "false" ]; then
      mv "weekly.$MAX_WEEKLY_SNAPS/" "weekly.$NEWSNAP/"
    fi
  else
    echo "weekly.$MAX_WEEKLY_SNAPS not found"
  fi
  ((MAX_WEEKLY_SNAPS -= 1))
done

# step 3: make a hard-link-only (except for dirs) copy of
# daily.5, assuming that exists, into weekly.0
if [ -d "daily.$((MAX_DAILY_SNAPS - 1))/" ]; then
  if [ "$DEBUG_MODE" == "false" ]; then
    cp -al "daily.$((MAX_DAILY_SNAPS - 1))/" weekly.0/
  fi
fi

# note: do *not* update the mtime of weekly.0; it will reflect
# when daily.5 was made, which should be correct.

echo "All Done!"
