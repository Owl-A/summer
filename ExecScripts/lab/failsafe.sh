#!/bin/sh -e
T=0
while [ $T -eq 0 ]
do 
  docker pull $1 && T=1 || T=0
done
