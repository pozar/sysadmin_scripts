#!/usr/bin/python3

####################################################################
# trown.py
# This script will translate the "unprivileged container" uids
# and gids to regular numbers expected in /etc/passwd and /etc/group
# You will need to tweak on the directory it will work on as well as 
# any offset in the ID numbers. For instance, the container may use
# an offset of 1,000,000 so that the container's /etc/passwd may use
# 1001 for a UID or GID but the files and directories will use 
# "1001001".
# 
# This script uses os.chown to set uid/gid. Alas, os.chown resets
# the file permissions. The script looks at the orginal permissions
# and re-applies the permissions.
####################################################################

import os
import stat
import glob
import argparse
import pathlib

# root_dir needs a trailing slash (i.e. /foo/dir/)
root_dir = '/tmp/foo/'
idoffset = 1000000

parser = argparse.ArgumentParser("simple_example")
parser.add_argument("--directory", help="The root directory with a trailing slash start with. Be very careful with this!", required=True)
parser.add_argument("--offset", help="An integer offset to use for uid and gid. If the original file UID is 1001001 and you use 1000000, then the result UID will be 1001", type=int, required=True)
args = parser.parse_args()

idoffset = args.offset
root_dir = args.directory

print(f'Using {idoffset} as the ID offset and {root_dir} as the root directory.')

for fileref in pathlib.Path(root_dir).glob('**/*.*'):
    filename = str(fileref)
    # Define uid and gid to "nobody"
    nuid = 65534
    ngid = 65534
    try:
        status = os.lstat(filename)
        permissions = stat.S_IMODE(status.st_mode)
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
        # Only update files that uid and/or guid needs updating
        if uid != nuid or gid != ngid:
            hbits = permissions & 0o7000
            lbits = permissions & 0o0777
            print(f'{filename} octal permissions are {oct(permissions)} or {oct(hbits)} and {oct(lbits)}.')
            print(f'{filename} is changeing uid from {uid} to {nuid} and gid from {gid} to {ngid}.')
            print('')
            # Update UID and GID...
            os.chown(filename, nuid, ngid, follow_symlinks = False)
            ####################################################################
            # This is here to fix upper bits if needed. This may not work if you
            # run it as a python script. You may need to run it as a compiled
            # binary. For an example:
            # https://stackoverflow.com/questions/39913847/is-there-a-way-to-compile-a-python-application-into-static-binary
            # https://stackoverflow.com/questions/5105482/compile-main-python-program-using-cython/22040484#22040484
            if oct(hbits) == '0o2000':
                os.chmod(filename, lbits | stat.S_ISGID)
            elif oct(hbits) == '0o4000':
                os.chmod(filename, lbits | stat.S_ISUID)
            elif oct(hbits) == '0o6000':
                os.chmod(filename, lbits | stat.S_ISUID | stat.S_ISGID)
            elif oct(hbits) == '0o1000':
                os.chmod(filename, lbits | stat.S_ISVTX)
            else:
                os.chmod(filename, lbits)
            ####################################################################
        ## This section is here to debug to see if the permissions are correct.
        # status = os.lstat(filename)
        # permissions = stat.S_IMODE(status.st_mode)
        # uid = status.st_uid
        # gid = status.st_gid
        # hbits = permissions & 0o7000
        # lbits = permissions & 0o0777
        # print(f'{filename} update octal permissions are {oct(current)} or {oct(hbits)} and {oct(lbits)}.')
        # print(f'{filename} update is changeing uid from {uid} to {nuid} and gid from {gid} to {ngid}.')

    except FileNotFoundError:
        print(f'Could not find {filename}.')
    except OSError:
        print(f'Too many symlinks for {filename}.')
