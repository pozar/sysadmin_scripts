#!/usr/bin/python3
###########################################################
# trown.py
# This script will change the "unprivileged container" uid
# and gids to regular numbers expected in /etc/passwd and /etc/group
# You will need to tweak on the directory it will work on as well as 
# any offset in ID numbers.  In my case the offset was 1,000,000.
###########################################################

import os
import glob
# root_dir needs a trailing slash (i.e. /foo/dir/)
root_dir = '/mnt/netbox/'
idoffset = 1000000
for filename in glob.iglob(root_dir + '**/**', recursive=True):
    # Define uid and gid to "nobody"
    nuid = 65534
    ngid = 65534
    try:
        status = os.lstat(filename)
        uid = status.st_uid
        gid = status.st_gid
        if status.st_uid >= idoffset:
            nuid = uid - idoffset
        else:
            nuid = uid
        if status.st_gid >= idoffset:
            ngid = gid - idoffset
        else:
            ngid = gid
        if uid != nuid or gid != ngid:
            print(f'{filename} is changeing uid from {uid} to {nuid} and gid from {gid} to {ngid}.')
            os.chown(filename, nuid, ngid, follow_symlinks = False)
    except FileNotFoundError:
        print(f'Could not find {filename}.')
    except OSError:
        print(f'Too many symlinks for {filename}.')
