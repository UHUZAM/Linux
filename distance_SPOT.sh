#!/bin/bash
#rm temp_uniq.txt
cat segmentdistance.txt | awk -F "_" '{print $1"_"$2"_"$3}' | sort -t "_" -k3 | uniq -c > uniq_segmentdistance.txt

while read line; do
   searchpattern=`echo $line | awk -F " " '{print $NF}'`
   #echo $searchpattern >> pattern.txt
   count=`echo $line | awk -F " " '{print $(NF-1)}'`
  #echo $count >> count.txt
   #echo "$line [$count -- $searchpattern]"
   if [ "$count" == "1" ]; then
      
      grep "$searchpattern" segmentdistance.txt | grep "_TR1_" >> temp_uniq.txt
   else 
    
      grep "$searchpattern" segmentdistance.txt | grep "_TR1_" >> temp_uniq.txt 
     # distance_pattern=`grep $searchpattern segmentdistance.txt | grep "_TR1_" | awk -F " " '{print $1"_"$2"_"$3}'`
     # distance=`grep $searchpattern temp_uniq.txt | awk -F " " '{print $NF}'`
     # echo $distance >> distance.txt
     # total_distance=`echo $distance + $total_distance | bc` 
   fi
#cat segmentdistance.txt | awk -F "_" '{print $1"_"$2"_"$3}' | sort -t "_" -k3 | uniq -c | grep "1 D*" | awk -F " " '{print $2}'
#| sed 's/^[[:blank:]]//g'
  
   # echo "$total_distance"
 # echo "=============================="
done < uniq_segmentdistance.txt



total_distance=0
#distance=0

while read line2; do
   distance=`echo  $line2 | awk -F " " '{print $NF}'`
   
   echo $distance >> distance.txt
   total_distance=`echo $distance + $total_distance | bc` 
   
done < temp_uniq.txt
 echo $total_distance
 
