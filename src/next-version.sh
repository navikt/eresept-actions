#!/usr/bin/bash
dt=$(date '+%Y%m%d-%H%M%S')
branch=$(git rev-parse --abbrev-ref HEAD)
stag=$dt
if [ "$branch" != "main" ]
then
  stag=$dt-$branch
fi
echo $stag
