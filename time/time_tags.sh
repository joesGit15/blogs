#! /bin/bash

# Notes:
# 1. if argument has space char, use 'tag name'
# 2. if function argument has space char, use "$1"

g_file_regexp="[\d]{2}.md"
g_file_regexp_include="*[0-9][0-9].md"

printUsage(){
    echo "This command usage:"
    echo "    -c     :count every tag" #$1=-c
    echo "    -f tag :find tag" #$1=-f tag
    echo "    -l     :list all the tags had used" #$1=-l
    echo "    -r oldtag newtag [inputfile]:replace tag"  #$1=-t $2=oldtag $3=newtag
}

# $1 = tag
findTag(){
    files=`find . | grep -P $g_file_regexp | sort`
    for i in $files
    do
        echo "$i"
        grep -n -i "$1" $i
        echo ""
    done
}

listTags() {
    tmpfile="./.tmp_tags.md"
    if [ -e $tmpfile ]
    then
        echo "clear temp tags file"
        `echo "" > $tmpfile`
    else
        `touch $tmpfile`
    fi

    files=`find . | grep -P $g_file_regexp | sort`
    for i in $files
    do
        `cat $i | cut -d "|" -f 4 | sort -u >> $tmpfile` #4 means tag filed
    done

    tags=`sort -u $tmpfile`
    echo "$tags"

    `rm $tmpfile`
}

countTags() {
    tmpfile="./.tmp_tags.md"
    if [ -e $tmpfile ]
    then
        echo "clear temp tags file"
        `echo "" > $tmpfile`
    else
        `touch $tmpfile`
    fi

    files=`find . | grep -P $g_file_regexp | sort`
    for i in $files
    do
        `cat $i | cut -d "|" -f 4 | sort -u >> $tmpfile` #4 means tag filed
    done

    tags=`sort -u $tmpfile`
    echo "" > $tmpfile
    for i in $tags
    do
        num=`grep $i -rn --include=$g_file_regexp_include . | wc -l`
        echo " $num => $i" >> $tmpfile
    done

    sort -n $tmpfile
    `rm $tmpfile`
}

# you can also to replace any char and string, not just tag string
replaceTags(){

    oldTag="$1"
    newTag="$2"
    file="$3"

    if [[ -z $oldTag || -z $newTag ]] # -z means string's length is 0
    then
        echo "Error:has tag is empty."
        return 0;
    fi


    files=
    if [ -z $file ]
    then
        files=`find . | grep -P $g_file_regexp | sort`
    else
        if [ -e $file ]
        then
            files=$file
        fi
    fi

    for i in $files
    do
        `sed -i "s/$oldTag/$newTag/i" $i`
        if [ $? -eq 0 ]
        then
            echo "$i $oldTag ==> $newTag Ok"
        else
            echo "$i $oldTag ==> $newTag Error"
        fi
    done
}

# begin the bash

if [ -z $1 ]
then
    printUsage
    exit 0
fi

if [ $1 == "-c" ]
then
    countTags
    exit 0
fi

if [ $1 == "-f" ]
then
    findTag "$2"
    exit 0
fi

if [ $1 == "-l" ]
then
    listTags
    exit 0
fi

if [ $1 == "-r" ]
then
    replaceTags "$2" "$3" "$4"
    exit 0
fi

printUsage
