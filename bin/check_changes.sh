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

# This is a bash script that performs the following actions:
# 1. It sets the exit code of the script to be non-zero if any command returns a non-zero value using the command set -e.
# 2. It takes two command-line arguments, $1 and $2, and assigns them to the variables ENV and LAYER respectively.
# 3. It checks the value of the BRANCH_NAME environment variable. If it is equal to "main", then it performs a git diff between the previous SHA and the current SHA using git diff --name-only --diff-filter=d "$PREV_SHA" "$SHA", and assigns the output to the variable DIFF.
# 4. If the BRANCH_NAME is not equal to "main", then it performs a git diff between the current branch and the origin/main branch using git diff --name-only --diff-filter=d origin/main HEAD, and assigns the output to the variable DIFF.
# 5. The script prints the output of the DIFF variable to the console.
# 6. The script uses egrep to check if the DIFF output contains the string "^live/${ENV}/${LAYER}". If it does not, then the script exports the environment variable CHANGED as false.
# 7. If the DIFF output does contain the string "^live/${ENV}/${LAYER}", then the script exports the environment variable CHANGED as true.
