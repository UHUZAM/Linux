#!/bin/bash

MAXfilenumber=`ls *.dat | wc -l`
TAPEid=`pwd | awk -F "/" '{print $NF}'`
echo "$MAXfilenumber" #&& read
echo "$TAPEid" #&& read
   
mv -v $TAPEid.file0001.dat $TAPEid.file0001.TAPE_ID

for (( count=2; count<=$MAXfilenumber; count++ )); do
   formatted_count=`printf "%04d" $count`    
   echo "test of file $TAPEid.file$formatted_count.dat" #&& read
   extension=`strings $TAPEid.file$formatted_count.dat | grep "Product_Name" | awk -F "." '{print $NF}'`
   echo "extension is: $extension" #&& read
   mv -v $TAPEid.file$formatted_count.dat $TAPEid.file$formatted_count.TAPE_INFO
   count=$((count+1))
   echo "count is increased by one: $count" #&& read
   formatted_count=`printf "%04d" $count`    
   echo "test of next file $TAPEid.file$formatted_count.dat" #&& read
   if [ "$extension" == "ZIP" ]; then
	integrity=`zip --test $TAPEid.file$formatted_count.dat | grep "test of" | awk -F " " '{print $NF}'`
	echo "$integrity" >> $TAPEid.file$formatted_count.ZIP.integrity
	if [ "$integrity" == "OK" ]; then


	   zipinfo $TAPEid.file$formatted_count.dat > $TAPEid.file$formatted_count.ZIP.contents
	   mv -v $TAPEid.file$formatted_count.dat $TAPEid.file$formatted_count.ZIP
        else
           echo "Problem on zipfile: $TAPEid.file$formatted_count.dat"	
        fi 
	   

   elif [ $extension == "SQL" ]; then
	mv -v $TAPEid.file$formatted_count.dat $TAPEid.file$formatted_count.SQL
   elif [ $extension == "tar" ]; then
	tar -tvf $TAPEid.file$formatted_count.dat > $TAPEid.file$formatted_count.tar.contents
	mv -v $TAPEid.file$formatted_count.dat $TAPEid.file$formatted_count.tar
   else
	echo "$TAPEid.file$formatted_count.$extension"
   fi
   echo "-----------------------------------------------------------"
done
