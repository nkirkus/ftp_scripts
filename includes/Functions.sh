#!/bin/bash


# SendMail $1=TO $2=FROM $3=SUBJECT $4=BODY
# example: SendMail "email@address.com" "DisplayName <email@address.com>" "Example Subject" "`cat message.tmp`"

SendMail()
{
        [ -z $1 ] && echo "Error: SendMail - No arguments supplied." && exit 1;

        echo -e "To: "$1"" > message.tmp
        echo -e "From: "$2"" >> message.tmp
        echo -e "Subject: "$3"" >> message.tmp

        echo "$4" >> message.tmp

        cat message.tmp | /usr/sbin/sendmail "$1"
}
