# sysadmin_scripts
Just various sysadmin scripts

## check_drives.sh
Checks the status of the Linux and ZFS software "RAID" on a system.  Only reports if there is something wrong.  Good for a crontab entry

## create_public_graphs.sh
Creates the aggregate traffic graphs for the SFMIX web site using the LibreNMS API. See: https://www.sfmix.org/services/statistics

## culdir.pl
Deletes older files in a directory based on partition usage.

## dfalarm.pl
Alerts if a partition if filling up.

## drivetemp.sh
Reports on drive temperature using smartd

## report_debsumz.sh
Reports on file changes using debsums.  Good to run daily to see if things like "ssh" and "sshd" have been changed and you have been rooted.

## genrevptr.sh
Generates a reverse zone file with PTR records for a /24.
