#!/bin/sh
echo "<ul id=\"users\">"
for i in `ls -cd u/*`
do
	user=$(basename $i | cut -d'.' -f1)
	test "$user" == 'www' && continue
	echo "<li><a title=\"$(stat -c%z $i | awk '{print $1}')\" href=\"u/$user\">@${user}</a></li>"
done
echo "</ul>"
