#!/usr/bin/bash
grep -v '^#' $1 | grep '^version\s*=\s*' | cut -d '=' -f2 | sed 's/[^0-9.]*//g'
