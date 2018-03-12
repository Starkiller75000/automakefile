#!/bin/bash
if [ $# != 1 ]
then
    printf $0': %s\n' "invalid argument."
else
    awk '{print $3, "\t", $9}' | grep \ $1
fi
