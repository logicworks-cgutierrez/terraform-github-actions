# terraform-gha

A GitHub Actions Terraform CI/CD solution.

## Overview

This code sets up a CICD pipeline leveraging GitHub Actions allowing you to deploy to multiple accounts/environments and layers.

- In the .github/workflows directory you will see the terraform.yaml workflow file. This is how the GitHub Action works.

- In the bin directory you will see two scripts. This is the logic that works alongside the terraform.yaml workflow file that enables a terraform plan on feature branches and a terraform apply when merging into the main branch. 

`check_changes.sh`

This is a bash script that performs the following actions:
1. It sets the exit code of the script to be non-zero if any command returns a non-zero value using the command set -e.
2. It takes two command-line arguments, $1 and $2, and assigns them to the variables ENV and LAYER respectively.
3. It checks the value of the BRANCH_NAME environment variable. If it is equal to "main", then it performs a git diff between the previous SHA and the current SHA using git diff --name-only --diff-filter=d "$PREV_SHA" "$SHA", and assigns the output to the variable DIFF.
4. If the BRANCH_NAME is not equal to "main", then it performs a git diff between the current branch and the origin/main branch using git diff --name-only --diff-filter=d origin/main HEAD, and assigns the output to the variable DIFF.
5. The script prints the output of the DIFF variable to the console.
6. The script uses egrep to check if the DIFF output contains the string "^live/${ENV}/${LAYER}". If it does not, then the script exports the environment variable CHANGED as false.
7. If the DIFF output does contain the string "^live/${ENV}/${LAYER}", then the script exports the environment variable CHANGED as true.

`deploy.sh`

This is a bash script that performs the following actions:
1. It sets the exit code of the script to be non-zero if any command returns a non-zero value using the command set -e.
2. It takes two command-line arguments, $1 and $2, and assigns them to the variables ENV and LAYER respectively.
3. The script uses the cd command to change the current working directory to live/${ENV}/${LAYER}.
4. The script runs the terraform init command to initialize Terraform in the current directory.
5. The script checks the value of the BRANCH_NAME environment variable. If it is equal to "main", then it runs the terraform apply command with the -auto-approve flag, which will apply the changes automatically without prompting for confirmation.
6. If the BRANCH_NAME is not equal to "main", then the script runs the terraform plan command, which generates and shows an execution plan without making any changes to the infrastructure.
