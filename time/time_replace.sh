#! /bin/bash

# replace tags $1 old tags,$2 new tags

if [[ -z $1 || -z $2 ]]
then
    echo "Useage: $0 oldTag newTag"
    exit 0
fi
