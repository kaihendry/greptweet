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
  <link rel="stylesheet" href="/bootstrap/docs/assets/css/bootstrap.css">
  <link rel="stylesheet" type="text/css" href="/style.css">
</head>
<body>
<div class="container">
<div class="content">

<h1 class="alert alert-info">Fetching upto 3200 tweets from $id</h1>

<p class="help-inline">Please be patient. Closing this page prematurely you can limit the tweets <a href="https://github.com/kaihendry/Greptweet/blob/master/fetch-tweets.sh">fetch-tweets.sh</a> gets and trigger a locking bug.</p>

<pre>
END

if test -d u/$id
then
	echo Attempting an update
else

	if curl -sI http://api.twitter.com/1/users/lookup.xml?screen_name=${id} | 
	grep -q "Status: 404 Not Found"
	then
		echo "$id does not exist on twitter.com :("
		exit
	fi

	echo Need to create u/$id
	mkdir u/$id

fi


cd u/$id

ln -sf ../../index.html || true
ln -sf ../../grep.php || true

if ! test -f lock
then
	touch lock
	../../fetch-tweets.sh $id
	rm lock
else
	echo Fetching already! Locks are cleared daily
fi

echo "</pre>"

# Clean up in case it went wrong (e.g. trying to retrieve from an account with protected tweets)
if test -s "$oldpwd/u/$id/$id.txt"
then

cd $oldpwd; ./users.sh > users.shtml

cat <<END
<a href="http://$HTTP_HOST/u/$id"><h1 class="alert alert-success">Goto http://$HTTP_HOST/u/$id to grep!</h1></a>
END

else
	rm -rf $oldpwd/u/$id
	echo '<h1 class="alert alert-error">Sorry the Twitter API is failing. Try again later.</h1>'
fi

cat <<END
</div>
</div>
</body>
</html>
END
