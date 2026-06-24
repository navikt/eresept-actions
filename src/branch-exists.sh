#!/usr/bin/bash
git config user.email "$ACTOR@users.noreply.github.com" && git config user.name "Github Actions Bot ($ACTOR)"
git ls-remote --exit-code --heads origin badges
echo -n $?

