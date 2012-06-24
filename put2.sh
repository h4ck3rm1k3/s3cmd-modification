#!/bin/sh
BASE_URL=http://archive.org/details/
for bfile in `ls x*`
do
    BASE_HEADER=fosm-20120401130001-${bfile} #something that should be unique
    ./s3cmd mb s3://$BASE_HEADER
    echo Sleeping...#sometimes it takes a moment to be processed on their end
    while [ ! ./s3cmd ls | grep $BASE_HEADER ]
    do
	sleep 1
    done
    
    for file in `cat $bfile`
    do 
	echo put $file
	cmd="./s3cmd put /pine02/index/$file s3://$BASE_HEADER/$file"
	echo going to $cmd

	while true
	do 

	    echo start;
	    $cmd;
	    
	    if [ $? -eq 0 ] 
	    then
		break
	    fi
	    
	    echo failed $cmd;
	    sleep 1;

	done
    done

done

echo $BASE_URL$BASE_HEADER
