#!/bin/bash

echo -e "\nSUBEMAIL\n"

#file="$1"
#filename=$(basename "$1")

source /scripts/includes/Functions.sh

scriptdata="scriptdata/ftpdecrypt/message"
scriptlog="scriptlogs/ftp_movement"
datestampfull=`date`


if [ "$(ls -A /$scriptdata)" ]
then {

	for message in `ls /$scriptdata/`
	do

		if [ `find /$scriptdata/$message -cmin 5 | wc -l` == 1 ]
		then
		GetSubject() {
		#for i in `<NAMES`
		#do
        	#	if [ `cat /$scriptdata/$message | grep appears | grep -m 1 $i | wc -l` == 1 ]
        	#	then echo -n "$i "
        	#	fi
		#done
		tempvar=`./subIdentifyClient.sh "/$scriptdata/$message"`
		echo -n "$tempvar "
		echo "(`grep appears /$scriptdata/$message | wc -l`)"

		}

		username=`stat -c %U "/$scriptdata/$message"`

		clientname=`./subIdentifyClient.sh "/$scriptdata/$message"`
		dl=`./subIdentifyClient.sh "/$scriptdata/$message" getDL`
		export dl

#		subject=`./subIdentifyClient.sh "/$scriptdata/$message"`
#		count="(`grep appears /$scriptdata/$message | wc -l`)"
		subject=`GetSubject`
		if [ "$subject" == "" ]
		then
			subject="UnknownUser"
		fi
		export subject
#		export count

		echo -e "\n\n\n" >> /$scriptdata/$message
		chmod 777 /$scriptdata/$message
		chown ftp2.ftp2 /$scriptdata/$message
		if [ $dl ]
		then
		
		SendMail "pharmmd.data.management@pharmmd.com, $dl" "FTP3 Peak10 <ftp3@pharmmd.com>" "$subject" "`cat /$scriptdata/$message`"
#			cat /$scriptdata/$message | su -c 'mail -s "$subject files received on FTP2" "pharmmd.data.management@pharmmd.com, $dl"' ftp2
		else
		SendMail "pharmmd.data.management@pharmmd.com" "FTP3 Peak10 <ftp3@pharmmd.com>" "$subject" "`cat /$scriptdata/$message`"
#			cat /$scriptdata/$message | su -c 'mail -s "$subject files received on FTP2" "pharmmd.data.management@pharmmd.com"' ftp2
		fi
		rm -f /$scriptdata/$message 2>> /$scriptlog/subEmailAgent_FTP.log
		echo -e "/$scriptdata/$message successfully emailed... $datestampfull" >> /$scriptlog/subEmailAgent_FTP.log
		sleep 5
	else
		echo -e "/"$scriptdata"/$message is not 5 minutes old... $datestampfull" >> /$scriptlog/subEmailAgent_FTP.log
		sleep 5
	fi

	done

} else {
	exit
}
fi
