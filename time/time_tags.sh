#! /bin/bash

# list all the tags in time record

tmpfile="./.tmp_tags.md"
if [ -e $tmpfile ]
then
    echo "clear temp tags file"
    `echo "" > $tmpfile`
else
    `touch $tmpfile`
fi

files=`find . | grep -P "[\d]{2}.md" | sort`
for i in $files
do
    `cat $i | cut -d "|" -f 4 | sort -u >> $tmpfile` #4 means tag filed
done

tags=`sort -u $tmpfile`
echo "$tags"

`rm $tmpfile`
