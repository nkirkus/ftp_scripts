#!/bin/bash

username=`stat -c %U "$1"`
#filename=$(basename "$1")
datestampfull=`date`

#touch /ftplog/logfile.csv
echo -n "|| "$datestampfull" "$1" Created by "$username" " >> /scriptlogs/ftp_movement/logfile.csv
