#!/usr/bin/env bash
# vim: set ts=4 sw=4
exec 2>&1

if test -d lock
then
	echo "Already running"
	exit 1 # trap goes below in order not to remove the lock
else
	mkdir lock
fi

temp=$(mktemp)
temp2=$(mktemp)

trap 'rm -vrf "${temp}" "${temp2}" lock' EXIT

umask 002

if ! test "$1"
then
	printf "Please specify twitter username\ne.g. %s kaihendry\n" "$0"
	exit 1
fi

page=1
saved=0

test -s "$1.txt.gz" && gunzip "$1.txt.gz"

if test -s "$1.txt"
then
	saved=$(wc -l < "$1.txt")
	since='&since_id='$(head -n1 "$1.txt" | cut -d'|' -f1)
	test "$2" && since='&max_id='$(tail -n1 "$1.txt" | cut -d'|' -f1) # use max_id to get older tweets
fi

while urlargs="screen_name=${1}&count=200&page=${page}${since}&include_rts=1&trim_user=0"; echo "$urlargs"; /srv/http/oauth.php "$urlargs" |
/srv/http/json-to-text.php > "$temp2"; test "$(wc -l < "$temp2")" -gt 0;
do

#cat temp2

if test -f "$1.txt"
then
	mv "$1.txt" "$temp"
	before=$(wc -l < "$temp")
else
	before=0
	> "$temp"
fi

sort -r -n -u "$temp" "$temp2" > "$1.txt"
rm -f "$temp" "$temp2"

after=$(wc -l < "$1.txt")

echo Before: "$before" After: "$after"

page=$(($page + 1))
saved=$(wc -l < "$1.txt")

done

echo "$1" saved "$saved" tweets

test -L "$1.txt.gz" && rm "$1.txt.gz"
gzip -v "$1.txt"
ln -sfv "$1.txt.gz" tweets.txt
