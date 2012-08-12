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

if test "${parm[2]}" == "o" # unused
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
END

if test -d u/$id
then
	echo "<h1 class='alert alert-info'>Attempting to update $id</h1>"
else

	if curl -sI http://api.twitter.com/1/users/lookup.xml?screen_name=${id} |
	grep -q "Status: 404 Not Found"
	then
		echo "<h1 class='alert alert-info'>$id does not exist on twitter.com :(</h1>"
		exit
	fi

	mkdir -p u/$id

fi

cd u/$id

ln -sf ../../index.html || true
ln -sf ../../grep.php || true

if echo $id | grep -q -v '_' # Underscores in domain names is a no no
then
	mkdir /srv/www/$id.greptweet.com 2> /dev/null || true
	echo Redirect / http://greptweet.com/u/$id > /srv/www/$id.greptweet.com/.htaccess
cat <<END
<a href="http://$id.greptweet.com"><h1 class="alert alert-success">Goto http://$id.greptweet.com to grep!</h1></a>
END
else
cat <<END
<a href="http://$HTTP_HOST/u/$id"><h1 class="alert alert-success">Goto http://$HTTP_HOST/u/$id to grep!</h1></a>
END
fi

ln -sf $id.txt tweets.txt
test -h greptweet.appcache && rm -f greptweet.appcache
sed -e "s,TIMESTAMP,$(date)," ../../greptweet.appcache > greptweet.appcache

echo "<pre>"

../../fetch-tweets.sh $id & disown
