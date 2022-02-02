#!/bin/bash
# Local:
# https://stackoverflow.com/questions/21151178/shell-script-to-check-if-specified-git-branch-exists
# test if the branch is in the local repository.
function is_in_local() {
    local branch=${1}
    local exist=$(git branch --list ${branch})

    if [[ -z ${exist} ]]; then
        echo false
    else
        echo true
    fi
}

# Remote:
# Ref: https://stackoverflow.com/questions/8223906/how-to-check-if-remote-branch-exists-on-a-given-remote-repository
# test if the branch is in the remote repository.
function is_in_remote() {
    local branch=${1}
    local exist=$(git ls-remote --heads origin ${branch})

    if [[ -z ${exist} ]]; then
        echo false
    else
        echo true
    fi
}

inl=$(is_in_local "badges")
inr=$(is_in_remote "badges")

if [[ "$inr" == 'true' ]] || [[ "$inl" == 'true' ]]; then
  echo true
else
  echo false
fi




