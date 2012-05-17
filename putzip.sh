#!/bin/sh
BASE_URL=http://archive.org/details/
for bfile in `cat bucketlist.txt`
do
    BASE_HEADER=fosm-20120401130001-${bfile} #something that should be unique
    echo processing $bfile    
    for file in `cat data/$bfile`
    do 

	/home/h4ck3rm1k3/experiments/zip30/zip -0 /tmp/$bfile.zip /pine02/index/$file > /tmp/ziplog.txt 2&>1
	if [ $? -ne 0 ] 
	then
	    echo problem zipping $?
	    exit $?
	fi
    done

    
    cmd="./s3cmd --add-header=x-archive-queue-derive:0 put /tmp/$bfile.zip s3://$BASE_HEADER/$bfile.zip"
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

    echo remove temp file
    rm /tmp/$bfile.zip

done

echo $BASE_URL$BASE_HEADER
