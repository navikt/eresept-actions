#!/usr/bin/bash

# does the commit
function doOneCommit() {
  git config user.name "GitHub Actions Bot ($1)"
  git config user.email "actions@github.com"
  git pull
  git add *.svg
  git commit -m "Generated badges" *.svg
  git push

}}

function commit() {
  local cnt=5
  while [ $cnt -gt 0 ];
  do
    doOneCommit $1
    if [ $? -eq 0 ];
    then
      cnt=0
    else
      # if commit fails we sleep and try again
      sleep 5
      cnt=$((cnt - 1))
    fi
  done
}

commit $1
