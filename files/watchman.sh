#!/bin/sh

while true; do
    POD=`cat /scripts/pids/POD`
    if [ ! -z "$POD" ]; then
        kubectl get pod "$POD" > /dev/null
        STATUS="$?"
        if [ "$STATUS" -ne "0" ]; then
            echo 'Restarting the process'
            python /app/create-configs-file.py
            supervisorctl  status | awk '$1 !~ /watchman/ {print $1}'  | xargs supervisorctl restart
        fi
    fi
    echo 'Waiting for 60 seconds'
    sleep 60
done
