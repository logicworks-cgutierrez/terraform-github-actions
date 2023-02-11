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
