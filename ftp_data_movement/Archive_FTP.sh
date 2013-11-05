#!/bin/bash

filename=$(basename "$1")
username=`stat -c %U "$1"`
datestamp=`date +"%Y-%m-%d"`
archivepath="/archive/ftparchive/$username/$datestamp"
decryptpath="/scriptdata/ftpdecrypt"
mkdir -p "$archivepath" 2> /dev/null
cp -f -p "$1" "$archivepath"/"$filename"
cp -f -p "$1" "$decryptpath"/"$filename"
