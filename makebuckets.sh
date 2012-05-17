#!/bin/sh
BASE_URL=http://archive.org/details/
for bfile in `cat bucketlist.txt`
do
    BASE_HEADER=fosm-20120401130001-${bfile} #something that should be unique

    ./s3cmd mb s3://$BASE_HEADER
   
    
    while true
    do 
	
	./s3cmd ls $BASE_HEADER | grep $BASE_HEADER 2>&1 >/tmp/txt.txtx
	
	if [ $? -eq 0 ] 
	then
	    break
	fi
	

	sleep 10;
	
    done

done

echo $BASE_URL$BASE_HEADER
