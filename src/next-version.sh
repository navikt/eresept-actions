#!/usr/bin/bash
appver=$1
dt=$(date '+%Y%m%d-%H%M%S')
branch=$(git rev-parse --abbrev-ref HEAD)
stag=$dt
if [ "$branch" != "main" ]
then
  stag=$dt-$branch
fi
if [ -n "$appver" ]
then
  stag=$appver
fi
echo $stag
