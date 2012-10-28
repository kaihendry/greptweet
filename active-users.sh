#!/bin/bash
echo -n "$(date --iso-8601) "
for i in 1 10 20 30
do
	echo -n "$i day(s): $(find /srv/www/greptweet.com/u -maxdepth 1 -mindepth 1 -type d -mtime -$i | wc -l), "
done

echo Total: $(find /srv/www/greptweet.com/u -maxdepth 1 -mindepth 1 -type d | wc -l)
