#!/usr/bin/bash

git ls-remote --exit-code --heads origin badges
if [ $? -eq 0 ]; then echo true; else echo false; fi

