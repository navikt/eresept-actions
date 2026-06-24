#!/usr/bin/bash

git ls-remote --exit-code --heads origin badges
echo -n $?

