#!/bin/bash -x
COIN_SYM="$1"
if [ -z ${COIN_SYM} ] ; then 
 echo "Usage: ./convert_to_coin.sh <COIN>"
 echo "Please enter coin symbol in upper case"
 exit 1
fi
coin_sym=$(echo ${COIN_SYM}| tr [:upper:] [:lower:])
if [ "${COIN_SYM}" = "${coin_sym}" ] ;
 then echo "Please enter coin symbol in upper case"
 exit 2
fi

for i in $(grep -ir electrum-grs *|awk -F\: '{print $1}'|egrep -v 'build[A-Z]'|sort -u) ; do 
  test -h ${i} \
   || sed -e 's/Electrum-GRS/Electrum-'${COIN_SYM}'/g' \
          -e 's/electrum-grs/electrum-'${coin_sym}'/g' ${i} > ${i}.new \
   && mv ${i}.new ${i}
done
