#!/usr/bin/env bash

aws eks update-kubeconfig  --region "$1"   --name "$2"   --alias "$3"  --user-alias "$3"

