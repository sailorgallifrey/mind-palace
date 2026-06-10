#!/bin/bash
kubectl set image deployment/mrr-poc-baseline mrr-poc-baseline=823847231624.dkr.ecr.us-east-1.amazonaws.com/mrr-poc-baseline:c7d12813e703138c3a62f498ea51b5ebc19287ad -n isg-mrr-poc-baseline
