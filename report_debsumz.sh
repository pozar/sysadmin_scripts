#!/bin/bash
MAILTO='your@address.com'
TMPFILE=$(mktemp /tmp/output.XXXXXXXXXX) || { echo "Failed to create temp file"; exit 1; }
debsums  | grep -v OK | grep -v REPLACED > $TMPFILE
if [ -s "$TMPFILE" ]
then
  cat $TMPFILE | mail -s "debsum output from $HOSTNAME" $MAILTO
fi
