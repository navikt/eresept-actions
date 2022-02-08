#!/usr/bin/bash

OWNER=$1
REPO=$2
ACTION=$3
TOKEN=$4
REF=$5
INPUTS=$6

echo curl -X POST "https://api.github.com/repos/$OWNER/$REPO/actions/workflows/$ACTION/dispatches" \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer XXX" \
    --data "{\"ref\":\"${REF}\",\"inputs\":${INPUT}}"

curl -X POST "https://api.github.com/repos/$OWNER/$REPO/actions/workflows/$ACTION/dispatches" \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    --data "{\"ref\":\"${REF}\",\"inputs\":${INPUT}}"
