#!/bin/bash

if [ "$#" -eq 1 ]; then
	cat "$1" >  /etc/X11/xorg.conf
	exit 0
fi

files="$(ls ./*.conf)"

select filename in ${files};
do
	cat "$filename" > /etc/X11/xorg.conf;
	break;
done