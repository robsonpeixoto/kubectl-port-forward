#!/bin/sh

exec socat tcp-listen:{{ port.socat }},reuseaddr,fork tcp:localhost:{{ port.free }}
