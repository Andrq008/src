#!/usr/bin/env bash

IFS=$'\n'
DIR=$(find /mnt/c/Users/seligenenko/test_prog/ -maxdepth 1 -type d | grep 'test best')
if [ -z $DIR ]; then
    echo not dir
    exit 0
fi
for i in $DIR; do
    rm -rf $i
done