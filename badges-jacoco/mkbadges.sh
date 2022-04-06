#!/usr/bin/bash

F=$1
DIR=$2
SCRIPT=$3/runcurl.sh
LOGO="$($3../src/getlogo.sh code)"

awk -f $DIR/coverage.awk -v logo="$LOGO" $F > $SCRIPT
awk -f $DIR/lines-and-methods.awk -v logo="$LOGO" $F >> $SCRIPT
sh $SCRIPT
rm $SCRIPT
