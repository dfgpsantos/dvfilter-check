#!/bin/bash

SERVIDORNOME=`hostname`

rm -f dfwconfig-$SERVIDORNOME.txt

summarize-dvfilter | grep "port 6" | grep -v vmk  | cut -f4 -d" " > dvfilter-vm.txt

summarize-dvfilter | grep "vmware-sfw\." | cut -f5 -d" " > dvfilter-filter.txt


for DVFILTERLINE in `cat dvfilter-vm.txt`

do

VMNAMEPORT=`echo $DVFILTERLINE | cut -f1 -d","`
VMNAMEPORTFILTER=`tail -n 1 dvfilter-filter.txt | cut -f1 -d","`

echo "" >> dfwconfig-$SERVIDORNOME.txt
echo "getting dvFilter config for $VMNAMEPORT" >> dfwconfig-$SERVIDORNOME.txt
echo "" >> dfwconfig-$SERVIDORNOME.txt
vsipioctl getaddrsets -f $VMNAMEPORTFILTER >> dfwconfig-$SERVIDORNOME.txt
vsipioctl getrules -f $VMNAMEPORTFILTER >> dfwconfig-$SERVIDORNOME.txt

sed -i -e '1d' dvfilter-filter.txt

done

rm -f  dvfilter-filter.txt
rm -f dvfilter-vm.txt
