#!/usr/bin/env bash
# The following is for Linux' mdadm process...
# Check the RAID1 volumes 
# result=`cat /proc/mdstat`
# if [[ "$result" =~ .*_U.* || "$result" =~ .*U_.* ]]
# then
        # echo "The MDADM RAID drive on $HOSTNAME may have problems";
        # cat /proc/mdstat;
# fi 

# The following is for FreeBSD's geom's process...
result=`geom mirror status | grep mirror`
if [[ $result != *"COMPLETE"* ]] ; then
        echo "The geom RAID drive on $HOSTNAME may have problems";
        geom mirror status;
fi 

# Check the ZFS pool...
result=`/sbin/zpool status -x`
if [[ $result != "all pools are healthy" ]] ; then
	echo "The ZFS pool on $HOSTNAME may have problems"
	/sbin/zpool status -v
fi
