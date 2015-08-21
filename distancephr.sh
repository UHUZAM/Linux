#!/bin/bash

#cat PHRfiltre.txt > uniq_segmentdistance.txt
total_distance=0
distance=0
uniq -c segmentdistance.txt | awk -F " " '{print $(NF-2) " : " $NF}' >> temp_segmentdistance.txt
while read line; do
   distance=`grep $line temp_segmentdistance.txt | awk -F " " '{print $NF}'`
   echo $line 
   echo $distance >> distance.txt
   total_distance=`echo $distance + $total_distance | bc`
   echo "$line : $distance" >> PHR_TR_distance.txt
done < PHRfiltre.txt
echo $total_distance

rm temp_segmentdistance.txt
#count=1;while read line; do check=`grep -c "$line" segmentdistance.txt`; if [ "$check" != "1" ]; then echo "[`printf "%3d" $count`] $line ($check)"; fi; count=$((count+1));done<PHR_IAP_list_filtered_20140518-20150701.txt 
