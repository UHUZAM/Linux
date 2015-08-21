#!/bin/bash

LTOdevice=/dev/nst1
TAPEid=`pwd | awk -F "/" '{print $NF}'`



# check magnetic tape status
echo "----------------------------------------"
echo "      STATUS CHECK"
echo "----------------------------------------"
mt -f $LTOdevice rewind
mt -f $LTOdevice status
echo "----------------------------------------"

# go to the end of media & detect max number of files
echo "----------------------------------------"
echo "      FAST FORWARDING TO THE END OF MEDIA"
echo "----------------------------------------"
mt -t $LTOdevice eom
MAXfilenumber=`mt -t /dev/nst1 status | grep "file number" | awk -F " " '{print $NF}'`

echo "----------------------------------------"
echo "      REWINDING"
echo "----------------------------------------"
mt -f $LTOdevice rewind


for (( count=1; count<=$MAXfilenumber; count++ )); do    
   echo "data dump of $TAPEid.file$count.dat"
   dd if=$LTOdevice of=$TAPEid.file$count.dat bs=64k
done

# check magnetic tape status
echo "----------------------------------------"
echo "      STATUS CHECK"
echo "----------------------------------------"
mt -f $LTOdevice status


mt -f $LTOdevice rewind
mt -f $LTOdevice offline

echo "PROJECT ENDED"
