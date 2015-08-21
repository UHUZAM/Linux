#!/bin/bash

#####-----This program requires 7zip full package and scipy, numpy packages of pyhton.


7z e '*.kmz' *.kml -r #extracting kml files from kmz files

total_total_distance=0

for kml_file in *.kml; do
total_distance=0
   txt_file="$kml_file".txt
   sed -n '
     1{s/^//;}; # initialise loop
     /<Icon>/,/<\/LatLonBox>/ {
       p; /<\/LatLonBox>/{
         s/.//;/./!q;# remove a token and quit if hold space empty
       }
     }' $kml_file > $txt_file      #extracting segment names and coordinate informations (LatLonBox)
   echo "Process finished"
   Maxlinenumber=`wc -l < $txt_file`
   echo $kml_file
   echo $Maxlinenumber
   for ((count = 2 ; count <= $Maxlinenumber ; count += 9)); do
     segment=`sed -n "$count"p $txt_file | awk -F ">" '{print $2}' | awk -F "." '{print $1}'`
     segment=${segment/images\\/} 
     # ` | awk -F "\\" '{print $NF}'` #| awk -F "." '{print $1}'`
    
     north=`sed -n "$((count+3))p" $txt_file | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'`
     east=`sed -n "$((count+5))p" $txt_file | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'`  
     south=`sed -n "$((count+4))p" $txt_file | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'`     
     # sed -n "$((count+3))","$((count+5))"p $txt_file 
     distance=`/usr/bin/python koordinat.py ${north/,/.} ${east/,/.} ${south/,/.} ${east/,/.}`
    
     echo "$segment : $distance" >> temp.txt
     
     total_distance=`echo $distance + $total_distance | bc` 
  done
echo "Total distance of $kml_file : $total_distance"
total_total_distance=`echo $total_distance + $total_total_distance | bc`
  
done
echo "Total distance is $total_total_distance" > totaldistance.txt
sort -t "_" -k3 temp.txt > segmentdistance.txt 
rm temp.txt

