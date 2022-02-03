#!/usr/bin/bash

F=$1
DIR=$2
SCRIPT=$3/runcurl.sh

awk -f $DIR/coverage.awk $F > $SCRIPT
awk -f $DIR/lines-and-methods.awk $F >> $SCRIPT
sh $SCRIPT
rm $SCRIPT
