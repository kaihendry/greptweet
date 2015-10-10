#!/bin/bash

test -d $1 || exit

cd $1

cat <<EOF
<!DOCTYPE html>
<html><head>
<meta charset="utf-8" />
<title>$(tar -tf tweets.tar  | wc -l) twitter accounts</title>
<style>
html { background-image: url("http://greptweet.com/icons/greptweet_birdie.svg"); }
body { background-color: white; opacity: 0.8; font-size: 2em; }
</style>
</head>
<body>
<h1>Greptweet.com $(date --rfc-3339=date -r tweets.tar) backup</h1>
<p>
<a href=tweets.tar>$(du -sh tweets.tar)</a>
</p>
</body>
</html>
EOF
