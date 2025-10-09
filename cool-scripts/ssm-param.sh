#!/usr/bin/env bash

uuid_value=$(uuidgen)

echo "$uuid_value"

aws ssm put-parameter \
    --region "$1"         \
    --name "/ISG/IDP/ACCESS" \
    --type "String" \
    --value "$uuid_value" \

aws ssm label-parameter-version \
        --region "$1"           \
        --name "/ISG/IDP/ACCESS" \
        --parameter-version "1" \
        --labels "current" "alternate"
