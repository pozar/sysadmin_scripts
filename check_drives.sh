#!/bin/bash

# Check the RAID1 volumes 
result=`cat /proc/mdstat`
if [[ "$result" =~ .*_U.* || "$result" =~ .*U_.* ]]
then
        echo "The MDADM RAID drive on $HOSTNAME may have problems";
        cat /proc/mdstat;
fi 

# Check the ZFS pool...
result=`/sbin/zpool status -x`
if [[ $result != "all pools are healthy" ]] ; then
	echo "The ZFS pool on $HOSTNAME may have problems"
	/sbin/zpool status -v
fi
