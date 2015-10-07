#!/bin/bash

if [ $# != 2 ]; then
    echo "Tags file and tag name expected"
    exit 1
fi

echo "$2" >> $1
