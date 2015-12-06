#!/bin/bash

from_scratch(){
rm reqs.txt deplinx.txt
 while read line ; do 
    x=$(echo ${line}| awk -F\( '{print $1}') ; 
    if [ "${x}" = "setup" ] ; then 
       y=1; 
    fi; 
    if [ "${y}" = "1" ] ; then 
       echo ${line} >> reqs.txt ; 
    fi; 
    if [ "${line}" = "]," ] ; then 
	y=0 ; 
    fi ;
 done < ../../setup.py 
 while read line ; do 
    x=$(echo ${line}| sed 's/[ 	][ 	]*//g'|awk -F\= '{print $1}') ; 
    if [ "${x}" = "dependency_links" ] ; then 
       y=1; 
    fi; 
    if [ ${y} = 1 ] ; then 
       echo ${line} >> deplinx.txt 
    fi; 
    if [ "${line}" = "]," ] ; then 
       y=0 ; 
    fi ;
 done < ../../setup.py 
 cat reqs.txt |egrep -v 'trezor|version|setup|name|install_|dependency_' |egrep -v '\[|\]'|sed -e 's/\,//g' -e 's/'\''//g' > helpers/requirements.txt
 cat deplinx.txt |egrep -v '\[|\]'|sed -e 's/'\"'//g'  -e  's/'\''//g' -e 's/\,//g'  >> helpers/requirements.txt
rm reqs.txt deplinx.txt
cp helpers/requirements.txt helpers/requirements.tmp
while read dep ; do
   ver=$(echo ${dep} | sed 's/[\<\>]*//g' | awk -F\= '{print $2}')
   req_dep=$(echo ${dep} | sed 's/[\<\>]*//g' | awk -F\= '{print $1}' |sed 's/\=//g')
   echo $ver
   echo ${req_dep}
   if [ "${ver}X" = "X" ] ; then
      echo "null version"
      std_ver=$(grep ${req_dep} helpers/pip_requirements.ver | awk '{print $2}')
      echo $std_ver
      sed -i -e 's/'${dep}'/'${req_dep}'\=\='${std_ver}'/g' helpers/requirements.txt
   fi
   mv helpers/requirements.txt helpers/req.tmp
   sort -u helpers/req.tmp > helpers/requirements.txt
done < helpers/requirements.tmp
rm helpers/requirements.tmp
rm helpers/req.tmp

# special for dash x11_hash

sed '/x11_hash\=\=/d'  helpers/requirements.txt > helpers/req.txt 
mv helpers/req.txt helpers/requirements.txt
}
rm helpers/reqs.txt
   rm helpers/requirements.txt
   rm helpers/requirements.tmp

if [ -f repo/requirements.txt ] ; then
   # specify versions
   cat ../../requirements.txt| grep -v "git+http" |  awk -F'[><=]' '{print $1}' > helpers/reqs.txt
   rm helpers/requirements.txt
   rm helpers/requirements.tmp
   while read reqdep ; do
      echo "${reqdep}==$(grep ${reqdep} helpers/pip_requirements.ver | awk '{print $2}')" >> helpers/requirements.tmp
   done < helpers/reqs.txt
   cat ../../requirements.txt | grep "git+http" >> helpers/requirements.tmp
   sed '/trezor\=\=/d' helpers/requirements.tmp > helpers/requirements.txt
#   mv helpers/requirements.tmp helpers/requirements.txt
else from_scratch
fi


