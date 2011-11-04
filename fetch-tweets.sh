#!/bin/bash
# Twitter backup script - hendry AT iki.fi - please mail me suggestions to make this suckless
# http://dev.twitter.com/doc/get/statuses/user_timeline
# Known issues:
# API only allows 3200 tweets to be downloaded this way :((
# Won't work on protected accounts (duh!)
# No @mentions or DMs from other accounts

set -e
set -o pipefail
umask 002
api="http://api.twitter.com/1/statuses/user_timeline.xml?"

if ! test "$1"
then
	echo -e "Please specify twitter username\n e.g. $0 kaihendry"
	exit 1
fi

twitter_total=$(curl -s "http://api.twitter.com/1/users/lookup.xml?screen_name=$1" | xmlstarlet sel -t -m "//users/user/statuses_count" -v .)

page=1
saved=0
stalled=0

if test -f $1.txt
then
	saved=$(wc -l $1.txt | tail -n1 | awk '{print $1}')
	since='&since_id='$(head -n1 $1.txt | awk -F"|" '{ print $1 }')
	test "$2" && since='&max_id='$(tail -n1 $1.txt | awk -F"|" '{ print $1 }') # use max_id to get older tweets
fi

while test "$twitter_total" -gt "$saved"
do
	rm -f $temp
	echo $1 tweet total "$twitter_total" is greater than the already saved "$saved"
	echo Trying to get $(($twitter_total - $saved))
	temp=$(mktemp)
	echo curl -s "${api}screen_name=${1}&count=200&page=${page}${since}&include_rts=true&trim_user=1"
	curl -si "${api}screen_name=${1}&count=200&page=${page}${since}&include_rts=true&trim_user=1" > $temp

temp2=$(mktemp)
{
{ while read -r
do
if test "$REPLY" = $'\r'
then
	break
else
	echo "$REPLY" >&2 # print header to stderr
fi
done
cat; } < $temp > $temp2
} 2>&1 | # redirect back to stdout for grep
grep -iE 'rate|status' # show the interesting twitter rate limits
# date --date='@1320361995'

mv $temp2 $temp

	#head $temp # debug

	if test $(xmlstarlet sel -t -v "count(//statuses/status)" $temp) -eq 0
	then

		if test $stalled -gt 5 # stall limit
		then
			echo Stalled $stalled times, come back later !
			rm -f $temp
			exit
		fi
		stalled=$(($stalled + 1 ))
		echo Stalling for the $stalled time
		sleep $(( RANDOM % 5 + 1 ))
		continue

	else

		temp2=$(mktemp)
		xmlstarlet sel -t -m "//statuses/status" -v "id" -o "|" -v "created_at" -o "|" -v "normalize-space(text)" -n $temp |
		perl -MHTML::Entities -pe 'decode_entities($_)' > $temp2
		sed -i '/^$/d' $temp2
		if test -z $temp2
		then
			echo $temp2 is empty
			continue
		fi
		cat $temp2
		if test -f $1.txt
		then
			mv $1.txt $temp
			before=$(wc -l $temp | awk '{print $1}')
		else
			before=0
			> $temp
		fi
		if test -s $temp2
		then
			cat $temp $temp2 | sort -r -n | uniq > $1.txt
			after=$(wc -l $1.txt | awk '{print $1}')
			echo Before: $before After: $after
			if test "$before" -eq "$after"
			then
				echo "Unable to retrieve anything new, a since_id $since problem or 3200 limit?"
				echo Approximately $(( $twitter_total - $after)) missing tweets
				rm -f $temp $temp2
				exit
			fi
		else
			echo Empty $temp2
			echo Twitter is returning empty responses, so we assume we have reached the limit!
			mv $temp $1.txt
			rm -f $temp2
			exit
		fi
		rm $temp2

	fi

	page=$(($page + 1))
	saved=$(wc -l $1.txt | tail -n1 | awk '{print $1}')

done

echo $1 saved $saved tweets of "$twitter_total": You are uptodate!
