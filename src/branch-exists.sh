#!/usr/bin/bash

inloc=$(git branch --list badges)
inrem=$(git ls-remote --heads origin badges)
if [ -z "$inloc" -a -z "$inrem" ]; then echo false; else echo true; fi

