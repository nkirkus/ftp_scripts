#!/bin/bash
##
# Launch FTP scripts
##

file=$(basename "$1")
username=`stat -c %U "$1"`
datestamp=`date +"%Y-%m-%d"`
archivepath="/archive/ftparchive/$username/$datestamp"
filecount=`ls "$archivepath/"$file""* | wc -l`
newfile=`echo $file | sed s/$file/$file.00$filecount/`
path="/ftphome/$username/pub"

if [ -f "$archivepath"/"$file" ];
then
        mv "$archivepath"/$file "$archivepath"/$newfile
fi

cd /scripts/ftp_data_movement
./Archive_FTP.sh "$1"
./Logging_FTP.sh "$1"
./GPGDecrypt_FTP.sh "$1"
./EmailAlert_FTP.sh "$1"
#./v3Upload_FTP.sh #called by GPGDecrypt_FTP.sh
