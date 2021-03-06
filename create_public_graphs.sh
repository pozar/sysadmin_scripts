#!/bin/bash
#
# Creates the aggregate traffic graphs for the web site. See: 
# https://www.sfmix.org/services/statistics
# 
# Meant to be run on the web site and call out to the LibreNMS API.
# One thing that was handy here was leveraging Libre's concept of 
# groups here to use this to identify ports we wanted to aggregate up. 
# These are identified as "peering" in this script.
#
# The script should be added to cron with something like:
# */5 * * * * /usr/local/sbin/create_public_graphs.sh > /dev/null 2>&1 

export TZ="UTC"
caldate=`date +'%Y/%m/%d %H:%M'`
now=`date +%s`
daysecs=86400
weeksecs=604800
dayago=$((now - daysecs))
weekago=$((now - weeksecs))
outdir='/var/www/website/static/img/'
token='LIBRENMSTOKENHERE'
TEXT="Aggregate Traffic - Created at $caldate $TZ"

# For the website the image should be 853×225 pixels.
# If you ask for 853×225, you will get 934x264 as there is a
# fixed pad for height and width.  You need to ask for 772x186.

width=772
height=186

# I haven't seen how to add a title via the API so I cam using
# Imagemagick's "convert" to overlay the image I got from LibreNMS.
# `apt-get install imagemagick` will be needed for Ubuntu.

curl -H "X-Auth-Token: $token" http://librenms.domain.com/api/v0/portgroups/peering\?legend=no\&type=multiport_bits\&from=$dayago\&to=$now\&width=$width\&height=$height > daily_tmp.png
convert -fill black -pointsize 12 -draw "text 300,12 '$TEXT'" daily_tmp.png daily.png
rm daily_tmp.png
mv daily.png $outdir

curl -H "X-Auth-Token: $token" http://librenms.domain.com/api/v0/portgroups/peering\?legend=no\&type=multiport_bits\&from=$weekago\&to=$now\&width=$width\&height=$height > week_tmp.png
convert -fill black -pointsize 12 -draw "text 300,12 '$TEXT'" week_tmp.png week.png
rm week_tmp.png
mv week.png $outdir
