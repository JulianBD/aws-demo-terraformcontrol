#!/usr/local/bin/bash

help() {
  echo "Usage: terraformw.sh RESOURCE ENVIRONMENT REGION [TF_COMMAND]" 
}

if [ ! "$#" -ge 4 ]
then
  echo "Invalid number of arguments."
  help; exit 1
elif [ ! -d "$1" ]
then
  echo "Resource directory does not exist."
  help; exit 1
elif [ ! -d "$1/$2-$3" ]
then
  echo "Environmentally-specific directory for $1 does not exist."
  help; exit 1
else
  pushd "$1" &> /dev/null
fi

if [ ! -f "$2-$3/terraform.env" ] || [ ! -s "$2-$3/terraform.env" ]
then
  echo "No terraform.env file specified or file has no content for $2-$3"
  exit 1
else
  export AWS_REGION="$3"
  source "$2-$3/terraform.env"
fi

if [ -f "$2-$3/.terraform.env" ] && [ -s "$2-$3/.terraform.env" ]
then
  source "$2-$3/.terraform.env"
fi
env | grep 'TF_VAR'
if [ -z "$S3_REMOTE_STATE_BUCKET" ] || [ -z "$S3_REMOTE_STATE_KEY" ]
then 
  echo "S3_REMOTE_STATE_BUCKET and/or S3_REMOTE_STATE_KEY environment variable(s) not set in terraform.env for $2-$3"
  exit 1
else
  terraform init -input="false" \
                 -backend-config="bucket=$S3_REMOTE_STATE_BUCKET" \
                 -backend-config="key=$S3_REMOTE_STATE_KEY" \
                 -backend-config="region=$AWS_REGION"
fi

[ ! -f "$2-$3/terraform.tfvars" ] && echo "No terraform.tfvars file specified for $2-$3" && exit 1

terraform fmt -recursive && case "$4" in
  "init")         exit 0;;
  "plan")         terraform plan -var-file="$2-$3/terraform.tfvars";;
  "apply")        terraform apply -var-file="$2-$3/terraform.tfvars";;
  "plan-destroy") terraform plan -destroy -var-file="$2-$3/terraform.tfvars";; 
  "destroy")      terraform apply -destroy -var-file="$2-$3/terraform.tfvars";; 
  *)              terraform "${@:4}";; 
esac
