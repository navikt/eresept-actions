#!/usr/bin/bash
echo $1 | awk '{split($0,a,"."); b=a[3]+1;print a[1]"."a[2]"."b}'