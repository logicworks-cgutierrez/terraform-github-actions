#!/bin/bash
set -e

ENV=$1
LAYER=$2

if [[ "$BRANCH_NAME" == "main" ]] ; then
  DIFF=$(git diff --name-only --diff-filter=d "$PREV_SHA" "$SHA")
else
  DIFF=$(git diff --name-only --diff-filter=d origin/main HEAD)
fi

echo -e "Git diff :\n${DIFF}"
if ! echo "${DIFF}" | egrep -q "^live/${ENV}/${LAYER}"; then
  export CHANGED=false
else
  export CHANGED=true
fi
