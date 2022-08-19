#!/usr/local/bin/bash

if [ "$#" -ne 4 ]
then
  echo "Invalid number of arguments specified."
  exit 1
elif [ -z "$1" ] || [ -z "$2" ] || [ ! -d "$1/$2-$3" ]
then
  echo "Environment directory does not exist."
else
  RESOURCE="$1"
  ENVIRONMENT="$2"
  REGION_DIR="$3"
fi

pushd "$RESOURCE"

if ![ -f "$ENVIRONMENT-$REGION_DIR/terraform.env" ]
then
  echo "No environment file specified"
else
  source "$ENVIRONMENT-$REGION_DIR/terraform.env"
fi

terraform init -input="false" \
               -backend-config="bucket=$S3_REMOTE_STATE_BUCKET" \
               -backend-config="key=$S3_REMOTE_STATE_KEY" \
               -backend-config="region=$AWS_REGION"
