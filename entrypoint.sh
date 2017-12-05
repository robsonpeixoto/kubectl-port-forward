#!/bin/sh

set -e

python create-configs-file.py $@
exec supervisord -n -c /etc/supervisord.conf -j /scripts/pids/supervisord.pid
