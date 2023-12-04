#!/usr/bin/bash
find . '(' -name '*.kts' -o -name '*.properties' ')' -exec grep -l '^version\s*=' {} \; | grep -v build/ | head -1
