#!/usr/bin/bash
set -x
dt=$(date '+%Y-%m-%d')
sha=$(git --no-pager log -1 --pretty=%h | cut -c1-7)
branch=$(git rev-parse --abbrev-ref HEAD)
stag=$dt-$sha
if [ "$branch" != "main" ]
then
  stag=$dt-$sha-$branch
fi
tag=$stag
ln=0
while [ $(git tag -l "$tag") ]
do
  ln=$(echo $ln | awk '{printf("%02d\n", $0+1)}')
  tag=$stag-$ln
done
echo $tag
