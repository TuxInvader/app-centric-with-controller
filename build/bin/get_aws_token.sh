#!/bin/bash
set -x

account=$(grep aws_account_id secrets/aws_config.yaml | awk '{ print $2 }')
role=$(grep aws_user_role secrets/aws_config.yaml | awk '{ print $2 }')
token=$(grep accessToken ~/.aws/sso/cache/* | sed -e 's/.*accessToken": "\([^"]*\).*/\1/')

output=$( aws sso get-role-credentials --account-id "$account" --role-name "$role" --access-token "$token" )
rcode=$?

if [ "$rcode" != "0" ]
then
  echo >&2 ""
  echo >&2 "*************************************************"
  echo >&2 "Failed to get credentials. Refreshing your login."
  echo >&2 "*************************************************"
  echo >&2 ""
  aws sso login
  sleep 2
  token=$(grep accessToken ~/.aws/sso/cache/* | sed -e 's/.*accessToken": "\([^"]*\).*/\1/')
  output=$( aws sso get-role-credentials --account-id "$account" --role-name "$role" --access-token "$token" )
  rcode=$?
fi

if [ "$rcode" != "0" ]
then
  echo >&2 ""
  echo >&2 "*************************************************"
  echo >&2 "Failed Again. Giving Up. Sorry it didn't work out."
  echo >&2 "*************************************************"
  echo >&2 ""
  exit $rcode
fi

access_key=$( echo "$output" | sed -ne 's/.*accessKeyId: \([^ ]*\).*/\1/p' )
secret_key=$( echo "$output" | sed -ne 's/.*secretAccessKey: \([^ ]*\).*/\1/p' )
session_key=$( echo "$output" | sed -ne 's/.*sessionToken: \([^ ]*\).*/\1/p' )

echo "Access_key: $access_key"
echo "Secret_key: $secret_key"
echo "Session:    $session_key"

# Update tokens
sed -i -e "s#aws_access_key: .*#aws_access_key: $access_key#" secrets/aws_config.yaml
sed -i -e "s#aws_secret_key: .*#aws_secret_key: $secret_key#" secrets/aws_config.yaml
sed -i -e "s#aws_sts_token: .*#aws_sts_token: $session_key#" secrets/aws_config.yaml

