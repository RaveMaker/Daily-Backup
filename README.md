Backup Script - Daily and Weekly backups with File based DeDup
==============================================================

Create Daily and Weekly backups with File based DeDup using rsync.

### Installation

1. Clone this script from github or copy the files manually to your prefered directory.

2. Edit backup.sh and change the SOURCEPATH and SNAPSHOT_RW paths.

3. Edit crontab and add the scripts:

        0 1 * * 0-5 /backup/daily.sh
    
        0 1 * * 6 /backup/weekly.sh

by [RaveMaker][RaveMaker].
[RaveMaker]: http://ravemaker.net
