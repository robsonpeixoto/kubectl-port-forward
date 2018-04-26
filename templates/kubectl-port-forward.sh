#!/bin/sh

set -e

POD="$(kubectl get pod -l {{ filters }} -o jsonpath='{.items[0].metadata.name}')"
echo "$POD" > /scripts/pids/POD
exec kubectl port-forward "$POD" {% for port in ports %} {{port.free}}:{{port.pod}} {% endfor %}

