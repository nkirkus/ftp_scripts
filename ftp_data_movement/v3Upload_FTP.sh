#!/bin/bash

filepath="$1"
filename="$2"
username="$3"

ftp_hostname="10.5.4.113"
ftp_user="pmduser"
ftp_passwd="\$upP0rT"

ftp -n -v "$ftp_hostname"<< EOF
user "$ftp_user" "$ftp_passwd"
cd "$username"
lcd "$filepath"
put "$filename"
quit
EOF