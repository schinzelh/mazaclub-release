for i in $(grep -ir DASH *|awk -F\: '{print $1}'|sort -u);  do 
    sed -e 's/Electrum-DASH/Electrum-GRS/g' \
     -e 's/electrum-dash/electrum-grs/g' \
     -e 's/electrumdash/electrum-grs/g' \
     -e 's/electrum_dash/electrum_grs/g' \
     ${i} > ${i}.new ; mv ${i}.new ${i} 
done
