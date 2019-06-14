#!/usr/bin/env bash

set -e

source $SNAP/actions/common/utils.sh
KUBECTL="$SNAP/kubectl --kubeconfig=$SNAP/client.config"

echo "Disabling Ingress"

ARCH=$(arch)
TAG="0.22.0"
EXTRA_ARGS="- --publish-status-address=127.0.0.1"
if [ "${ARCH}" = arm64 ]
then
  TAG="0.11.0"
  EXTRA_ARGS=""
fi

declare -A map
map[\$TAG]="$TAG"
map[\$EXTRA_ARGS]="$EXTRA_ARGS"
use_manifest ingress delete "$(declare -p map)"

pods_sys="$($KUBECTL get po 2>&1)"
if echo "$pods_sys" | grep "default-http-backend" &> /dev/null
then
  use_manifest default-http-backend delete "$(declare -p map)"
fi
echo "Ingress is disabled"
