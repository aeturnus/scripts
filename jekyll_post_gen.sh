#!/bin/bash
# jekyll_post_gen.sh [--html] <file name> 

if [ $# -lt 1 ];
then
    echo "jekyll_post_gen.sh [--html] <file name>"
    exit 1
fi

ext="md"
if [ $# -ge 2 ]; then
    if [ "$1" == "--html" ]; then
        ext="html"
        title=$2
    elif [ "$2" == "--html" ]; then
        ext="html"
        title=$1
    else
        title=$1
    fi
else
    title=$1
fi

date=$(date +"%Y-%m-%d")
unix_title=$title;
file="$date-$unix_title.$ext"
touch $file

# populate the file
echo "---" >> $file
echo "title: $title" >> $file
echo "layout: post" >> $file
echo "author: $USER" >> $file
echo "categories: []" >> $file
echo "tags: []" >> $file
echo "excerpt_separator: <!--more-->" >> $file
echo "---" >> $file
