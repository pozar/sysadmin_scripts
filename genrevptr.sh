#!/bin/bash
# Creates an IPv4 reverse zone file for a /24.  Nothing fancy.
# Tim Pozar - July 16th 2020

while getopts p:d: flag
do
    case "${flag}" in
        p) prefix=${OPTARG};;
        d) domain=${OPTARG};;
    esac
done

serial=$(date '+%Y%m%d01')

# Print the SOA...
echo "\$TTL 3600"
echo "@       IN      SOA     ns1.$domain.     hostmaster.$domain. ("
echo "                        $serial   ; serial"
echo "                        21600        ; refresh after 6 hours"
echo "                        3600         ; retry after 1 hour"
echo "                        604800       ; expire after 1 week"
echo "                        3600 )       ; minimum TTL of 1 day"

# Set '.' as the delimiter
IFS='.'
read -a strarr <<< "$prefix"

i=0
while [ $i -le 255 ] 
do
    hostname=`echo "$prefix" | tr . -`
    echo "$i.${strarr[2]}.${strarr[1]}.${strarr[0]}.in-addr.arpa. IN PTR $hostname-$i.$domain.";
    i=$((i + 1));
    shift 1;
done
