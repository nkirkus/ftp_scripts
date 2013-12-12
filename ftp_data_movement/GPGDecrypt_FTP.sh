#!/bin/bash

echo -e "\nGPGDECRYPT\n"

fullfilename="$1"
filename=$(basename "$1")
datestampfull=`date`
decryptpath="/scriptdata/ftpdecrypt"
decryptedpath="/scriptdata/ftpdecrypt/decrypted"
outputfile=`echo "$filename" | sed s/.gpg// | sed s/.pgp// | sed s/.PGP// | sed s/.GPG//`
#outputfilenospaces=`echo "$outputfile" | sed s/\ /_/g`
username=`stat -c %U "$decryptpath"/"$filename"`
altusername=`./subIdentifyClient.sh "$1"`
ftplog="scriptlogs/ftp_movement"
size=`du -h "$fullfilename" | awk '{ print $1 }'`

export altusername

#	Is the file encrypted via pgp/gpg? If so - decrypt and upload. Else process as a normal.

if [ `echo "$filename" | grep -i -e "\.gpg" -e "\.pgp" | wc -l` == 1 ];
	then {

echo -e "\n $datestampfull\n$1\n" >> /$ftplog/GPGDecrypt_FTP.log

gpg --no-tty --homedir "/root/.gnupg/" --output "$decryptedpath"/"$outputfile" --passphrase-file "$decryptpath"/pp.txt --decrypt "$decryptpath/$filename" 2>> /$ftplog/GPGDecrypt_FTP.log

	if [ -e "$decryptedpath"/"$outputfile" ];
		then
		datestampfull=`date`
		echo -n "|| "$datestampfull" Successfully Decrypted "$filename" by "$username" " >> /$ftplog/logfile.csv
		rm -f "$decryptpath"/"$filename"
	else
		datestampfull=`date`
		echo -n "|| "$datestampfull" UNSUCCESSFULLY DECRYPTED "$filename" by "$username" " >> /$ftplog/logfile.csv
		echo -n "|| "$datestampfull" UNSUCCESSFULLY UPLOADED "$filename" by "$username" " >> /$ftplog/logfile.csv
		echo "ERROR Decrypting "$decryptpath"/"$filename" with GPG"
		echo -e "\n\nERROR Decrypting "$decryptpath"/"$filename" with GPG\n\n" | su -c 'mail -s "ERROR: Failed to decrypt files on FTP2" amazon@pharmmd.com' ftp2
		exit 1
	fi

#       Is the file a zip file? If so - unzip and upload. Else upload normally.

#	if [ `echo "$outputfile" | grep ".zip" | wc -l` == 1 -o `echo "$outputfile" | grep ".ZIP" | wc -l` == 1 ];
        if [ `echo "$outputfile" | grep -i -e SXCPCTSTD -e MPD230420131106_NCPDPCHF51_RX32058C2.zip | wc -l` == 1 ];
        then
                echo "HS Zip file skipped due to size."
                ./v3Upload_FTP.sh "$decryptedpath" "$outputfile" "$altusername" > /$ftplog/Upload_FTP_"$outputfile".tmp
	elif [ `echo "$outputfile" | grep -i -e ".zip" -e ".ZIP" | wc -l` == 1 ];
	then
		mkdir -p .tmp/
		if [ `echo "$outputfile" | grep -i INGRAM_CENSUS | wc -l` == 1 ];
			then
				unzip -j -P I4n6g4r7 -j "$decryptedpath"/"$outputfile" -d .tmp/
		else
				unzip -j "$decryptedpath"/"$outputfile" -d .tmp/
		fi

		SAVEIFS=$IFS
		IFS=$(echo -en "\n\b")
		x=0; for y in `ls .tmp/`; do x=$( expr $x + 1 ); done
		echo -e "\nTotal Files within Zip: $x -- File size: $size\n" >> /$ftplog/msgUnzipped.tmp
		for file in `ls .tmp/`
		do
			filesize=`du -h ".tmp/"$file"" | awk '{ print $1 }'`
			linecount=`cat ".tmp/"$file"" | wc -l`
			if [ `echo "$filename" | grep -e SCAN_CC_Reviews -e SCAN_Case_Reviews -e SCAN_Clinical_Variables -e SCAN_Member_Notes | wc -l` == 1 ]
			then
				echo "Scanhealth file. Skip."
			elif [ $linecount == 0 ]
                        then
				if [ `echo "$filename" | grep -e SCAN_CC_Reviews -e SCAN_Case_Reviews -e SCAN_Clinical_Variables -e SCAN_Member_Notes | wc -l` == 1 ]; then break; fi
					echo -e "\nIt appears the the file "$file" is 0 lines.\n" | su -c 'mail -s "ALERT: $altusername has a 0 line file." noah.kirkus@pharmmd.com' ftp2
			fi
			echo -e "$file -- File size: $filesize -- Line count: $linecount" >> /$ftplog/msgUnzipped.tmp
			./v3Upload_FTP.sh .tmp/ "$file" "$altusername" >> /$ftplog/zip"$outputfile".tmp
			rm -rf .tmp/"$file"
		done
		IFS=$SAVEIFS
	else
			filesizeorig=`du -h "$1" | awk '{ print $1 }'`
			linecountorig=`cat "$1" | wc -l`
            filesize=`du -h ""$decryptedpath"/"$outputfile"" | awk '{ print $1 }'`
            linecount=`cat ""$decryptedpath"/"$outputfile"" | wc -l`
			echo -e "$file -- File size: $filesizeorig -- Line count: $linecountorig\n" >> /$ftplog/msgUnzipped.tmp
			echo -e "$outputfile -- File size: $filesize -- Line count: $linecount" >> /$ftplog/msgUnzipped.tmp
			./v3Upload_FTP.sh "$decryptedpath" "$outputfile" "$altusername" > /$ftplog/Upload_FTP_"$outputfile".tmp
	fi

	if [ /$ftplog/zip"$outputfile".tmp ]
	then
		UploadZipCheck=`cat /$ftplog/zip"$outputfile".tmp | grep "Transfer OK" | wc -l`
	fi

	if [ -e /$ftplog/Upload_FTP_"$outputfile".tmp ]
	then
		UploadCheck=`cat /$ftplog/Upload_FTP_"$outputfile".tmp | grep "Transfer OK" | wc -l`
	fi
	echo "COUNT $x"
#       Check upload logs for success. Error out on failure.

	if [ $UploadCheck == 1 ]
		then
		datestampfull=`date`
		echo -n "|| "$datestampfull" Successfully Uploaded "$outputfile" by "$username" " >> /$ftplog/logfile.csv
		rm -f "$decryptedpath"/"$outputfile"
		rm -f /$ftplog/tmp"$outputfile".tmp
		rm -f zip"$outputfile".tmp
#		rm -f "$1"
	elif [ $UploadZipCheck == $x ]
		then
                datestampfull=`date`
                echo -n "|| "$datestampfull" Successfully Uploaded "$outputfile" by "$username" " >> /$ftplog/logfile.csv
                rm -f "$decryptedpath"/"$outputfile"
                rm -f /$ftplog/tmp"$outputfile".tmp
                rm -f zip"$outputfile".tmp
#		rm -f "$1"
	else
		datestampfull=`date`
		echo -n "|| "$datestampfull" UNSUCCESSFULLY UPLOADED "$outputfile" by "$username" " >> /$ftplog/logfile.csv
		exit 1
	fi
}
else {

	datestampfull=`date`
	echo -n "|| "$datestampfull" SKIPPED DECRYPTION "$filename" by "$username" " >> /$ftplog/logfile.csv

#	Is the file a zip file? If so - unzip and upload. Else upload normally.

#	if [ `echo "$filename" | grep ".zip" | wc -l` == 1 -o `echo "$filename" | grep ".ZIP" | wc -l` == 1 ];
        if [ `echo "$outputfile" | grep -i -e SXCPCTSTD -e MPD230420131106_NCPDPCHF51_RX32058C2.zip | wc -l` == 1 ];
        then
                echo "HS Zip file skipped due to size."
		./v3Upload_FTP.sh "$decryptpath" "$filename" "$altusername" > /$ftplog/Upload_FTP_"$filename".tmp
	elif [ `echo "$outputfile" | grep -i -e ".zip" -e ".ZIP" | wc -l` == 1 ];
        then
				mkdir -p .tmp/ 2> /dev/null
            	if [ `echo "$outputfile" | grep -i INGRAM_CENSUS | wc -l` == 1 ];
            		then
						 unzip -P I4n6g4r7 -j "$decryptpath"/"$filename" -d .tmp/
					else
						unzip -j "$decryptpath"/"$filename" -d .tmp/
				fi

		SAVEIFS=$IFS
                IFS=$(echo -en "\n\b")
                x=0; for y in `ls .tmp/`; do x=$( expr $x + 1 ); done
		echo -e "\nTotal Files within Zip: $x -- File size: $size\n" >> /$ftplog/msgUnzipped.tmp
                for file in `ls .tmp/`
                do
                        filesize=`du -h ".tmp/$file" | awk '{ print $1 }'`
                        linecount=`cat ".tmp/$file" | wc -l`
			if [ `echo "$filename" | grep -e SCAN_CC_Reviews -e SCAN_Case_Reviews -e SCAN_Clinical_Variables -e SCAN_Member_Notes | wc -l` == 1 ]
			then
				echo "Scanhealth file. Skip."
			elif [ $linecount == 0 ]
			then
				if [ `echo "$filename" | grep -e SCAN_CC_Reviews -e SCAN_Case_Reviews -e SCAN_Clinical_Variables -e SCAN_Member_Notes | wc -l` == 1 ]; then break; fi
					echo -e "\nIt appears the the file "$file" is 0 lines.\n" | su -c 'mail -s "ALERT: $altusername has a 0 line file." noah.kirkus@@pharmmd.com' ftp2
			fi
			echo -e "$file -- File size: $filesize -- Line count: $linecount" >> /$ftplog/msgUnzipped.tmp
                        ./v3Upload_FTP.sh .tmp/ "$file" "$altusername" >> /$ftplog/zip"$filename".tmp
                        rm -rf .tmp/"$file"
                done
		IFS=$SAVEIFS
        else
		./v3Upload_FTP.sh "$decryptpath" "$filename" "$altusername" > /$ftplog/Upload_FTP_"$filename".tmp
	fi

	if [ -e /$ftplog/zip"$filename".tmp ]
	then
		UploadZipCheck=`cat /$ftplog/zip"$filename".tmp | grep "Transfer OK" | wc -l`
	else
		UploadZipCheck=0
	fi

	if [ -e /$ftplog/Upload_FTP_"$filename".tmp ]
	then
		UploadCheck=`cat /$ftplog/Upload_FTP_"$filename".tmp | grep "Transfer OK" | wc -l`
	else
		UploadCheck=0
	fi

	echo "COUNT $x"

#	Check upload logs for success. Error out on failure.

	if [ $UploadCheck == 1 ];
		then
		datestampfull=`date`
		echo -n "|| "$datestampfull" Successfully Uploaded "$filename" by "$username" " >> /$ftplog/logfile.csv
		rm -f "$decryptpath"/"$filename"
		rm -f /$ftplog/Upload_FTP_"$filename".tmp
		rm -f /$ftplog/zip"$filename".tmp
#		rm -f "$1"
	elif [ $UploadZipCheck == $x ] 2>/dev/null
		then
		datestampfull=`date`
                echo -n "|| "$datestampfull" Successfully Uploaded "$filename" by "$username" " >> /$ftplog/logfile.csv
                rm -f "$decryptpath"/"$filename"
                rm -f /$ftplog/Upload_FTP_"$filename".tmp
                rm -f /$ftplog/zip"$filename".tmp
#		rm -f "$1"
	else
		datestampfull=`date`
		echo -n "|| "$datestampfull" UNSUCCESSFULLY UPLOADED "$filename" by "$username" " >> /$ftplog/logfile.csv
#		echo -e "\n\nERROR Verifying that "$decryptpath"/"$filename" was uploaded via ftp. FTP log = /$ftplog/Upload_FTP_"$filename".tmp\n\n" | su -c 'mail -s "ERROR: Failed to upload files to SQLETL from FTP2" amazon@pharmmd.com' ftp2
		exit 1
	fi
}
fi
