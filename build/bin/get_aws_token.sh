#!/bin/bash

account=$(grep aws_account_id secrets/aws_config.yaml | awk '{ print $2 }')
role=$(grep aws_user_role secrets/aws_config.yaml | awk '{ print $2 }')
token=$(grep accessToken ~/.aws/sso/cache/* | sed -e 's/.*accessToken": "\([^"]*\).*/\1/')

read -p "Execute login first? (y|n)? " login
if [ "$login" == "y" ]
then
  aws sso login
fi

aws sso get-role-credentials --account-id "$account" --role-name "$role" --access-token "$token"

