#!/usr/bin/env bash
# vim: set ts=4 sw=4

test -s "$1" || exit
test "${1##*.}" = 'txt' || exit

temp=$(mktemp "$1.XXXX")
trap "rm -f $temp" INT

IFS='|'
while read -r id date text
do
	url=$(echo $text | grep --only-matching --perl-regexp "http(s?):\/\/[^ \"\(\)\<\>]*")
	expandedURL=$(curl "$url" -m5 -s -L -I -o /dev/null -w '%{url_effective}')
	t=${text/$url/$expandedURL}
	echo "$id|$date|$t"
done < $1 > $temp

mv $temp $1
