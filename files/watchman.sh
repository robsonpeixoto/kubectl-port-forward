#!/bin/sh

echo 'WATCHMAN: waiting 60s before start'
sleep 60s

while true; do
    POD="$(cat /scripts/pids/POD)"
    if [ ! -z "$POD" ]; then
        kubectl get pod "$POD" > /dev/null
        STATUS="$?"
        if [ "$STATUS" -ne "0" ]; then
            echo 'WATCHMAN: Restarting the process'
            python /app/create-configs-file.py
            supervisorctl status | awk '$1 !~ /watchman/ {print $1}' | xargs supervisorctl restart
        fi
    fi
    echo 'WATCHMAN: repeat the process in 60s'
    sleep 60
done
