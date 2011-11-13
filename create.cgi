#!/bin/bash -e
# vim: set ts=4 sw=4

cat <<END
Cache-Control: no-cache
Content-Type: text/plain

END
exec 2>&1

oldpwd=$PWD

saveIFS=$IFS
IFS='=&'
parm=($QUERY_STRING)
IFS=$saveIFS

if test ${parm[0]} == "id"
then
	id=$(echo ${parm[1]} | tr -dc '[:alnum:]_' | tr '[:upper:]' '[:lower:]')
	test ${#id} -gt 0  || exit
	test ${#id} -lt 20  || exit
else
	exit
fi

if test "${parm[2]}" == "o"
then
	test "${parm[3]}" && old=1
fi

# Trying to workaround:
# http://stackoverflow.com/questions/3547488/showing-a-long-running-shell-process-with-apache
# Maybe needs a bigger buffer ???
figlet $id

if test -d u/$id
then

	echo Directory $id already exists
	echo Visit http://greptweet.com/u/$id
	echo Attempting an update

	cd u/$id

	ln -sf ../../index.html || true
	ln -sf ../../grep.php || true

	if ! test -f lock
	then
		touch lock
		../../fetch-tweets.sh $id $old
		rm lock
	else
		echo Fetching already!
	fi

else

	if curl -I http://api.twitter.com/1/users/lookup.xml?screen_name=${id} | grep -q "Status: 404 Not Found"
	then
		echo $id does not exist on twitter.com
		exit
	fi

	echo Need to create u/$id
	mkdir u/$id
	cd u/$id

	ln -s ../../index.html
	ln -s ../../grep.php

	if ! test -f lock
	then
		touch lock
		../../fetch-tweets.sh $id
		rm lock
	else
		echo Fetching already!
	fi

fi

cd $oldpwd; ./users.sh > users.shtml

# Clean up in case it went wrong (trying to retrieve from an account with protected tweets)
#test -f $oldpwd/u/$id.txt || rm -rf $oldpwd/u/$id
