#!/usr/bin/bash
d=$(find . -name Dockerfile -maxdepth 2)
df=$(if [ -z "$d" ]; then echo . else echo $d; fi)
echo dirname $df
