#!/bin/bash

rm reqs.txt deplinx.txt
 while read line ; do 
    x=$(echo ${line}| awk -F\( '{print $1}') ; 
    if [ "${x}" = "setup" ] ; then 
       echo "in setup" ; 
       y=1; 
    fi; 
    if [ "${y}" = "1" ] ; then 
       echo ${line} >> reqs.txt ; 
    fi; 
    if [ "${line}" = "]," ] ; then 
        echo "out of setup" ;
	y=0 ; 
    fi ;
 done < ../../setup.py 
 while read line ; do 
    x=$(echo ${line}| sed 's/[ 	][ 	]*//g'|awk -F\= '{print $1}') ; 
    if [ "${x}" = "dependency_links" ] ; then 
       echo "in setup" ; 
       y=1; 
    fi; 
    if [ ${y} = 1 ] ; then 
       echo ${line} >> deplinx.txt 
    fi; 
    if [ "${line}" = "]," ] ; then 
       echo "out of setup" ;
       y=0 ; 
    fi ;
 done < ../../setup.py 
 cat reqs.txt |egrep -v 'trezor|version|setup|name|install_|dependency_' |egrep -v '\[|\]'|sed -e 's/\,//g' -e 's/'\''//g' > helpers/requirements.txt
 cat deplinx.txt |egrep -v '\[|\]'|sed -e 's/'\"'//g'  -e  's/'\''//g' -e 's/\,//g'  >> helpers/requirements.txt
rm reqs.txt deplinx.txt

