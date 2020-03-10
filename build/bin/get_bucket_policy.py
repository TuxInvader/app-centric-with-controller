#!/usr/bin/env python

import sys
import boto3
import json

bucket = sys.argv[1]
s3 = boto3.client('s3')
result = s3.get_bucket_policy(Bucket=bucket)

policy = json.loads(result['Policy'])
filtered = []
for statement in policy['Statement']:
  if statement['Sid'] != sys.argv[2]:
    filtered.append( statement )

policy['Statement'] = filtered

print( json.dumps(policy) )

