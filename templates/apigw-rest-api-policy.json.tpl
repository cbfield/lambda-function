{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "arn:aws:execute-api:${region}:${caller_id}:${api_id}/*",
      "Condition": {
        "StringNotEquals": {
          "aws:sourceVpce": ${length(vpce_ids) > 1 ? jsonencode(vpce_ids) : jsonencode(vpce_ids[0])}
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "arn:aws:execute-api:${region}:${caller_id}:${api_id}/*"
    }
  ]
}
