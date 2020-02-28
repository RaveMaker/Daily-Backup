Backup Script - Daily and Weekly backups with File based DeDup
==============================================================

Create Daily and Weekly backups with File based DeDup using rsync.

### Installation

1. Clone this script from github or copy the files manually to your preferred directory.

2. Create settings.cfg from settings.cfg.example and change:
```
# Where to save the backups
SNAPSHOT_RW="/backup"

# folder to backup
SOURCE_PATH="/home"

# Exclude files/folders list
EXCLUDE="$PWD/exclude.txt"

# Amount of daily snapshots to keep
MAX_DAILY_SNAPS=5

# Amount of weekly snapshots to keep
MAX_WEEKLY_SNAPS=5

# Debug mode. set to "false" to enable backups.
DEBUG_MODE="true"
```

3. Edit crontab using 'crontab -e' command and add the scripts:
```
0 1 * * 0-5 root /backup/daily.sh
0 1 * * 6 root /backup/weekly.sh
```

Author: [RaveMaker][RaveMaker].

[RaveMaker]: http://ravemaker.net
