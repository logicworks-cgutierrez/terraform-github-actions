#!/bin/bash
set -e

ENV=$1
LAYER=$2

cd live/${ENV}/${LAYER}

terraform init

if [[ "$BRANCH_NAME" == "main" ]] ; then
  terraform apply -auto-approve
else
  terraform plan
fi

# This is a bash script that performs the following actions:
# 1. It sets the exit code of the script to be non-zero if any command returns a non-zero value using the command set -e.
# 2. It takes two command-line arguments, $1 and $2, and assigns them to the variables ENV and LAYER respectively.
# 3. The script uses the cd command to change the current working directory to live/${ENV}/${LAYER}.
# 4. The script runs the terraform init command to initialize Terraform in the current directory.
# 5. The script checks the value of the BRANCH_NAME environment variable. If it is equal to "main", then it runs the terraform apply command with the -auto-approve flag, which will apply the changes automatically without prompting for confirmation.
# 6. If the BRANCH_NAME is not equal to "main", then the script runs the terraform plan command, which generates and shows an execution plan without making any changes to the infrastructure.
