#!/bin/sh

# usage: some unix | pipeline | sh multilineoutput.sh YOURVAR
# the output of the cmd pipeline that was piped into this script can be found in env.YOURVAR
# echo ${{ env.YOURVAR }}

VAR=$1

# multiline output
echo "$VAR<<EOF" >> $GITHUB_ENV
cat /dev/stdin >> $GITHUB_ENV
echo "EOF" >> $GITHUB_ENV
