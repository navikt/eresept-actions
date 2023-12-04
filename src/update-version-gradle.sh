#!/usr/bin/bash
if [ $# -ne 4 ]; then
  echo "invalid number of arguments"
  echo "usage: update-version-gradle.sh current-version next-version file actor"
  exit 1
fi

CURV=$1
NEXTV=$2
FILE=$3
ACTOR=$4
if [ "$CURV" != "$NEXTV" ]; then
  sed -ie "s/^version.*=.*$CURV.*/version = \"$NEXTV\"/" $FILE
  echo $NEXTV | grep -q '-SNAPSHOT'
  if [ $? -eq 0 ]; then
    TXT="dev-version"
  else
    TXT="version"
  fi
  git commit -m "Updated to new $TXT $NEXTV after release by $ACTOR [ci skip]" $FILE
fi