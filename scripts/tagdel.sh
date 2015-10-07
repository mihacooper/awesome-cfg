#!/bin/bash

if [ $# != 2 ]; then
    echo "Tag name expected"
    exit 1
fi

TAGS_FILE="$1"
DATA=$(cat $TAGS_FILE)
echo -n > $TAGS_FILE

for i in $DATA;
do
    if [ "$i" != "$2" ]; then
        echo $i >> $TAGS_FILE
    fi
done