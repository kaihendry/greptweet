#!/bin/bash -e
# vim: set ts=4 sw=4
exec 2>&1
cat <<END
Cache-Control: no-cache
Content-Type: text/html

END
badinput() {
	echo "<h1>Bad input, parameter id $@</h1>"
	exit
}

oldpwd=$PWD

saveIFS=$IFS
IFS='=&'
parm=($QUERY_STRING)
IFS=$saveIFS

if test ${parm[0]} == "id"
then
	id=$(echo ${parm[1]} | tr -dc '[:alnum:]_' | tr '[:upper:]' '[:lower:]')
	test ${#id} -gt 0  || badinput is empty
	test ${#id} -lt 20  || badinput is too large
else
	exit
fi

if test "${parm[2]}" == "o"
then
	test "${parm[3]}" && old=1
fi

cat <<END
<!DOCTYPE html>
<html>
 <head>
  <meta charset="utf-8" />
  <title>Fetching tweets of $id</title>
  <link rel="stylesheet" type="text/css" href="/style.css">
  <link rel="stylesheet" href="http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css">
</head>
<body>

<h1>Greptweet is running a operation to fetch upto 3200 tweets from $id</h1>

<p>Please be patient. Closing this page prematurely you can limit the tweets <a href="https://github.com/kaihendry/Greptweet/blob/master/fetch-tweets.sh">fetch-tweets.sh</a> gets and trigger a locking bug.</p>

<pre>
END

hash figlet 2>/dev/null && figlet $id

if test -d u/$id
then

	echo Directory $id already exists
	echo Attempting an update

	cd u/$id

	ln -sf ../../index.html || true
	ln -sf ../../grep.php || true

	if ! test -f lock
	then
		touch lock # Bug here if tab is closed before it's finished
		../../fetch-tweets.sh $id $old
		rm lock # We need to also clear to lock if fetch-tweets was killed by Apache
	else
		echo Fetching already!
	fi

else

	if curl -sI http://api.twitter.com/1/users/lookup.xml?screen_name=${id} | grep -q "Status: 404 Not Found"
	then
		echo "$id does not exist on twitter.com :("
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

# Clean up in case it went wrong (e.g. trying to retrieve from an account with protected tweets)
test -s $oldpwd/u/$id/$id.txt || rm -rf $oldpwd/u/$id

cd $oldpwd; ./users.sh > users.shtml

cat <<END
</pre>
<h1>Visit <a href="http://$HTTP_HOST/u/$id">http://$HTTP_HOST/u/$id</a></h1>
</body>
</html>
END

