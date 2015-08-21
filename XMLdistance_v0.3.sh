#!/bin/bash
#This script reads xml files and calculates the exact values of distance
rm xml.txt
rm segmentdistance.txt
rm temp.txt
total_total_distance=0
txt_file=xml.txt
total_distance=0

for xml_file in *.XML; do #create "for" loop to take *.xml files 

   echo "$xml_file" >> $txt_file
   sed -n '
     1{s/^//;}; # initialise loop
     /<Album_Footprint>/,/<\/Album_Footprint>/ {
       p; /<\/Album_Footprint>/{
         s/.//;/./!q;# remove a token and quit if hold space empty
       }
     }' $xml_file | head -n 7 >> $txt_file      #extracting segment names and coordinate informations (Real Lat-Long values) with sed. write to txt_file
   sed -n '
     1{s/^//;}; # initialise loop
     /<Album_Footprint>/,/<ROW>1<\/ROW>/ {
       p; /<\/Album_Footprint>/{
         s/.//;/./!q;# remove a token and quit if hold space empty
       }
     }' $xml_file | tail -n 4 >> $txt_file
   
   

done
echo "---------------------Process finished---------------------------"
  Maxlinenumber=`wc -l < $txt_file`  #find maximum line number
  echo $Maxlinenumber
  for ((count = 1 ; count <= $Maxlinenumber ; count += 12)); do
    segment=`sed -n "$count"p $txt_file | awk -F "." '{print $1}' ` 
    #segment=${segment/images\\/} 
     #` | awk -F "\\" '{print $NF}'` #| awk -F "." '{print $1}'`
    
     lon2=`sed -n "$((count+3))p" $txt_file | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'`
     lat2=`sed -n "$((count+4))p" $txt_file | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'`  
     lon1=`sed -n "$((count+8))p" $txt_file | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'` 
     lat1=`sed -n "$((count+9))p" $txt_file | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'`    
     # sed -n "$((count+3))","$((count+5))"p $txt_file 
     distance=`/usr/bin/python koordinat.py ${lat1/,/.} ${lon1/,/.} ${lat2/,/.} ${lon2/,/.}`
   
     echo "$segment : $distance" >> temp.txt
     
     total_distance=`echo $distance + $total_distance | bc` 
  done
echo "Now calculating the total distance" 
echo "Total distance is : $total_distance" 

      frame_number=`echo $total_distance / "20000.0" | bc -l`
echo "Number of frames : $frame_number"
#total_total_distance=`echo $total_distance + $total_total_distance | bc`
  
#echo "Total distance is $total_total_distance" > totaldistance.txt
sort -t "_" -k3 temp.txt > segmentdistance.txt 
echo "Total distance is : $total_distance" >> temp.txt
#rm temp.txt
