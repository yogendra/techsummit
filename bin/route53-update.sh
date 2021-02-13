#!/usr/bin/env bash
SCRIPT_ROOT=$( cd `dirname $0`; pwd)
FQDN=${1?"Missing FQDN"}; shift
HOSTED_ZONE_ID=${1?"Missing Zone ID"}; shift
TARGET=${1?"Missing Target DNS"}; shift
TYPE=${1:-CNAME}; shift
ACTION=${1:-UPSERT}; shift

cat <<EOF >temp.json
{
  "Comment": "$ACTION on $FQDN ($TYPE) -> $TARGET",
  "Changes": [
    {
      "Action": "$ACTION",
      "ResourceRecordSet": {
        "Name": "*.$FQDN",
          "Type": "$TYPE",
          "TTL" : 300,
          "ResourceRecords": [{ "Value": "$TARGET"}]
        }
      },
      {
        "Action": "$ACTION",
        "ResourceRecordSet": {
          "Name": "$FQDN",
          "Type": "$TYPE",
          "TTL" : 300,
          "ResourceRecords": [{ "Value": "$TARGET"}]
        }
      }
    ]
  }
EOF

aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://temp.json
rm temp.json

