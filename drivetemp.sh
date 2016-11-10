#!/bin/sh
# Look at certain drives and report the current tempature
uptime
# find /dev/disk/by-id/ -type l | grep scsi-35000 | sort | grep -v \\-part | xargs /usr/sbin/hddtemp 
find /dev/disk/by-id/ -type l | grep scsi-35000 | sort | grep -v \\-part | xargs -I % sh -c "echo -n '% ' ; /usr/sbin/smartctl -A % | grep ' Temp' | awk '{print \$2,\$10}; echo'"
