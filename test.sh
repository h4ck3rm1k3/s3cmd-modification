#!/bin/bash

while     true
do
    ls blah
    if [ $? -eq 0 ]
    then
	break
    fi
done
