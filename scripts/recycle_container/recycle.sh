#!/bin/bash

if [ $# != 1 ] || [ $1 == 105 -o $1 == 106 ]
then
    echo "Usage: recycle container_id"
    exit 1
fi

if [ $1 == 101 -o $1 == 102 -o $1 == 103 -o $1 == 104 ]
then
	echo "Do not recycle HonSSH Containers"
	exit 1
fi

# Snapshot does not exist
if [ ! -f /vz/dump/*-$1-*.tgz ]
then
    echo "Snapshot does not exist"
    exit 2
fi

sudo vzctl stop $1
sudo vzctl destroy $1
sudo vzrestore /vz/dump/*-$1-*.tgz $1
sudo vzctl start $1

# Increment recycle counter
count=$(cat /shared/counter/$1.count)
count=$((count + 1))
rm /shared/counter/$1.count
echo $count > /shared/counter/$1.count
