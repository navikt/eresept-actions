#!/usr/bin/bash
git config --global url."https://x-access-token:${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"
git ls-remote --exit-code --heads origin badges > /dev/null 2>&1
echo -n "$?"

