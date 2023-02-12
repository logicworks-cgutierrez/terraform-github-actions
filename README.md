# terraform-github-actions

## Overview

The repository contains a Github Actions workflow file, located in the .github/workflows directory. This workflow is triggered on push events to the main branch and on pull request events. The workflow uses the two scripts mentioned below, check_changes.sh and deploy.sh, to check if changes were made to the live environment and layer and deploy the changes if necessary.

The workflow sets the environment variables ENV and LAYER based on the contents of the pull request or push event. If changes were made, the workflow runs the deploy.sh script to deploy the changes. If the current branch is not "main", the workflow will only run a Terraform plan and will not apply the changes.

## Scripts

`check_changes.sh`

This script checks if changes were made to the specified environment and layer in the live directory. It takes two arguments, the environment name and the layer name. The script outputs a list of changes and sets the CHANGED environment variable to either true or false.

```
./check_changes.sh <ENV> <LAYER>
```

This bash script performs the following actions:
1. It sets the exit code of the script to be non-zero if any command returns a non-zero value using the command set -e.
2. It takes two command-line arguments, $1 and $2, and assigns them to the variables ENV and LAYER respectively.
3. It checks the value of the BRANCH_NAME environment variable. If it is equal to "main", then it performs a git diff between the previous SHA and the current SHA using git diff --name-only --diff-filter=d "$PREV_SHA" "$SHA", and assigns the output to the variable DIFF.
4. If the BRANCH_NAME is not equal to "main", then it performs a git diff between the current branch and the origin/main branch using git diff --name-only --diff-filter=d origin/main HEAD, and assigns the output to the variable DIFF.
5. The script prints the output of the DIFF variable to the console.
6. The script uses egrep to check if the DIFF output contains the string "^live/${ENV}/${LAYER}". If it does not, then the script exports the environment variable CHANGED as false.
7. If the DIFF output does contain the string "^live/${ENV}/${LAYER}", then the script exports the environment variable CHANGED as true.

`deploy.sh`

This script deploys the Terraform code to the specified environment and layer. It takes two arguments, the environment name and the layer name. If the current branch is "main", the script will automatically apply the changes. Otherwise, it will only run a Terraform plan.

```
./deploy.sh <ENV> <LAYER>
```

This bash script performs the following actions:
1. It sets the exit code of the script to be non-zero if any command returns a non-zero value using the command set -e.
2. It takes two command-line arguments, $1 and $2, and assigns them to the variables ENV and LAYER respectively.
3. The script uses the cd command to change the current working directory to live/${ENV}/${LAYER}.
4. The script runs the terraform init command to initialize Terraform in the current directory.
5. The script checks the value of the BRANCH_NAME environment variable. If it is equal to "main", then it runs the terraform apply command with the -auto-approve flag, which will apply the changes automatically without prompting for confirmation.
6. If the BRANCH_NAME is not equal to "main", then the script runs the terraform plan command, which generates and shows an execution plan without making any changes to the infrastructure.
