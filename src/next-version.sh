#!/usr/bin/bash

ln=0
dt=$(date '+%Y-%m-%d')
sha=$(git --no-pager log -1 --pretty=%h)
tag=$dt-$sha
exists=1
while [ $(git tag -l "$tag") ]
do
  ln=$(echo $ln | awk '{printf("%02d\n", $0+1)}')
  tag=$dt-$sha-$ln
done
echo $tag
