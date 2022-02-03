#!/usr/bin/bash

F=$1
SCRIPT=$2/runcurl.sh
awk -f coverage.awk $F > $SCRIPT
awk -f lines-and-methods.awk $F >> $SCRIPT
sh $SCRIPT
rm $SCRIPT
