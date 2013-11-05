#!/bin/bash

echo -e "\nEMAILALERT\n"

file="$1"
clientname=`./subIdentifyClient.sh "$file"`
username=`stat -c %U "$file"`
filename=$(basename "$file")
filesize=`du -h "$file" | awk '{ print $1 }'`
timestamp=`date +"%H:%M"`
datestamp=`date +"%Y-%m-%d"`
datestampfull=`date`
scriptdata="scriptdata/ftpdecrypt/message"
outputfile=`echo $filename | sed s/.pgp// | sed s/.gpg//`
ftplog="scriptlogs/ftp_movement"

emailfile="/$scriptdata/EmailAlert_"$clientname"_"$username"_FTP.tmp"

source /scripts/includes/Functions.sh

export clientname

if [ -a $emailfile ]
then
	if [ `grep ERROR $emailfile | wc -l` == 1 ]
	then
		mv $emailfile $emailfile_error
		exit 1
	fi
fi

header="\nPharmMD File Alert\n\nOfficial Notification: The following file(s) have been received via FTP and will be queued for processing:\n"

message=""$filename" - "$datestampfull" appears to be for "$clientname" (Login: "$username")"

spacer="___________________________________________________________________________________________________"

if [ -e "$emailfile" ]
then
	if [ -a /$ftplog/msgUnzipped.tmp ]
	then
		echo -e -n "\n$spacer\n$message" >> $emailfile
		cat /$ftplog/msgUnzipped.tmp >> $emailfile
	else
		echo -e "\n$spacer\n$message" >> $emailfile
		linecount=`cat "$file" | wc -l`
		if [ `echo "$filename" | grep -e SCAN_Case_Reviews -e SCAN_Clinical_Variables -e SCAN_Member_Notes | wc -l` == 1 ]
			then
				echo "Scanhealth file. Skip."
		elif [ $linecount == 0 ]
                        then
		SendMail "pharmmd.data.management@pharmmd.com" "FTP3 <ftp3@pharmmd.com>" "ALERT: $clientname has a 0 line file." "`echo -e "\nIt appears the the file "$file" is 0 lines.\n"`"
#                               echo -e "\nIt appears the the file "$file" is 0 lines.\n" | su -c 'mail -s "ALERT: $clientname has a 0 line file." pharmmd.data.management@pharmmd.com' ftp2
                        fi

		echo "File size: $filesize -- Line count: $linecount" >> $emailfile
	fi
	echo ""
else
	if [ -a /$ftplog/msgUnzipped.tmp ]
        then
	        echo -e "$header" > $emailfile
			echo -e "$spacer" >> $emailfile
	        echo -e -n "$message" >> $emailfile
                cat /$ftplog/msgUnzipped.tmp >> $emailfile
        else
        	echo -e "$header" > $emailfile
			echo -e "$spacer" >> $emailfile
        	echo -e "$message" >> $emailfile
                linecount=`cat "$file" | wc -l`
		if [ `echo "$filename" | grep -e SCAN_Case_Reviews -e SCAN_Clinical_Variables -e SCAN_Member_Notes | wc -l` == 1 ]
			then
				echo "Scanhealth file. Skip."
		elif [ $linecount == 0 ]
                        then
		SendMail "pharmmd.data.management@pharmmd.com" "FTP3 <ftp3@pharmmd.com>" "ALERT: $clientname has a 0 line file." "`echo -e "\nIt appears the the file "$file" is 0 lines.\n"`"
#                                echo -e "\nIt appears the the file "$file" is 0 lines.\n" | su -c 'mail -s "ALERT: $clientname has a 0 line file." pharmmd.data.management@pharmmd.com' ftp2
                        fi
		echo "File size: $filesize -- Line count: $linecount" >> $emailfile
	fi
	echo ""
fi

chown $username.sftponly $emailfile

if [ -a /$ftplog/msgUnzipped.tmp ]
then
	rm -rf /$ftplog/msgUnzipped.tmp
fi

rm -rf "$1"
