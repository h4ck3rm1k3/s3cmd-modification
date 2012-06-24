#!/bin/sh
BASE_URL=http://archive.org/details/
for bfile in `ls data/`
do
    BASE_HEADER=fosm-20120401130001-${bfile} #something that should be unique
    echo processing $bfile    
    for file in `cat data/$bfile | grep -v _i.tbz`
    do 

	/home/h4ck3rm1k3/experiments/zip30/zip -0 /tmp/$bfile.zip /pine02/index/$file > /tmp/ziplog.txt 2&>1
	if [ $? -ne 0 ] 
	then
	    echo problem zipping $?
	    exit $?
	fi
    done

    # now extract the index files
    for file in `cat data/$bfile | grep _i.tbz`
    do 
	/home/h4ck3rm1k3/experiments/zip30/zip -0 /tmp/${bfile}_index.zip /pine02/index/$file > /tmp/ziplog.txt 2&>1
	if [ $? -ne 0 ] 
	then
	    echo problem zipping $?
	    exit $?
	fi
    done

    #######
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
    
    #######
    cmd="./s3cmd --add-header=x-archive-queue-derive:0 put /tmp/${bfile}_index.zip s3://$BASE_HEADER/${bfile}_index.zip"
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

    # now put the list of files as well
    cmd="./s3cmd --add-header=x-archive-queue-derive:0 put  data/$bfile s3://$BASE_HEADER/$bfile.txt"
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
    rm /tmp/${bfile}_index.zip

    # move the index away
    mv data/$bfile done/

done

echo $BASE_URL$BASE_HEADER
