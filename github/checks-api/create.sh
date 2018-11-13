#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

template_json=$1

# Find on: https://github.com/organizations/SonarSourceIT/settings/apps/sonarclouddecoratorwithcheckstest
app_id=20134
pem_path=$PWD/sonarclouddecoratorwithcheckstest.2018-11-02.private-key.pem

# Find on: https://github.com/SonarSourceIT/pr-decoration-with-checks/settings/installations
installation_id=431382

sha1=cc57184af5ad01849853df5890f63e040e96e0a2
sha1=4dfe07bcc0ce7a5e387b206f195a16e243280983
sha1=e5094712ed233053b4f9fd57bfd8a7c2d141681c
sha1=264c0d5c2f962af6c237cceaef840b20beef99c1

app_token=$(./gen-jwt.rb "$app_id" "$pem_path")
access_token=$(curl -X POST "https://api.github.com/installations/$installation_id/access_tokens" -H "Authorization: Bearer $app_token" -H "Accept: application/vnd.github.machine-man-preview+json" | jq -r .token)

cleanup() {
    rm -fr "$workdir"
}

trap cleanup EXIT

workdir=$(mktemp -d)
payload_json=$workdir/payload.json

sed -e "s/HEAD_SHA/$sha1/" "$template_json" > "$payload_json"

curl https://api.github.com/repos/SonarSourceIT/pr-decoration-with-checks/check-runs -H "Authorization: Bearer $access_token" -H "Accept: application/vnd.github.antiope-preview+json" -X POST -d@"$payload_json"
