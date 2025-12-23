#!/usr/bin/bash
d=$(find . -name Dockerfile -maxdepth 2 | sort | head -1)
if [ -z "$d" ]
then
  df=.
else
  df=$d
fi
dd=$(dirname $df)
echo $dd
