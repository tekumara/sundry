#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 namespace1 [namespace2 ...]"
    echo "Example: $0 my-app my-other-app"
    exit 1
fi

CONFIG_FILE="${CONFIG_FILE:-$HOME/.kube/config}"

for ns in "$@"; do
    if ! kubectl config get-contexts -o name | grep "$ns$" > /dev/null; then
        echo "Adding context for $ns to $CONFIG_FILE"
        # add namespaced contexts for each existing context that doesn't already have a namespace specified
        NS=$ns yq -i '.contexts += [.contexts[] | select(.context.namespace == null) | {"context": (.context + {"namespace": strenv(NS)}), "name": .name + "/" + strenv(NS)}]' "$CONFIG_FILE"
    fi
done
