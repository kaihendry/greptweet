#!/bin/bash -ex
cd "${BASH_SOURCE%/*}" || exit 1
bundleDir=$PWD
wwwdir=/srv/www/backup.greptweet.com
cd /mnt/2tb/greptweet || exit 1
rsync -trvi --exclude 'tweets.txt.gz' --include '*/' --include '*.txt.gz' --exclude '*' --prune-empty-dirs core:/srv/www/greptweet.com/ . &> $wwwdir/rsync.log
find -name '*.gz' -type f -print0 | tar cf $wwwdir/tweets.tar --null -T -
$bundleDir/index.sh $wwwdir > $wwwdir/index.html
