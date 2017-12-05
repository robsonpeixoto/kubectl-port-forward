#!/usr/bin/env python

from __future__ import print_function

import os
import socket
import sys
from collections import namedtuple

from jinja2 import Environment, FileSystemLoader

PortInfo = namedtuple('PortInfo', ['socat', 'free', 'pod'])

if len(sys.argv) < 3:
    print('missing filter and ports')
    sys.exit(1)


def get_free_tcp_port():
    tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    tcp.bind(('', 0))
    addr, port = tcp.getsockname()
    tcp.close()
    return port


def normalize_port(port):
    free_port = get_free_tcp_port()
    if ':' not in port:
        port = (port, port)
    else:
        port = tuple(port.split(':'))
    return PortInfo(port[0], free_port, port[1])


filters = sys.argv[1]
ports = map(normalize_port, sys.argv[2:])

env = Environment(loader=FileSystemLoader('/app/templates'))

supervisor_tpl = env.get_template('supervisor.ini')

# KUBECTL PORT FORWARD
with open('/etc/supervisor.d/k8s_pf.ini', 'w') as f:
    f.write(supervisor_tpl.render(app='k8s_pf', cmd='/scripts/k8s_pf.sh'))

script_path = '/scripts/k8s_pf.sh'
k8s_tpl = env.get_template('kubectl-port-forward.sh')
with open(script_path, 'w') as f:
    f.write(k8s_tpl.render(filters=filters, ports=ports))
    os.chmod(script_path, 755)

# SOCAT PORT FORWARD
socat_tpl = env.get_template('socat-port-forward.sh')
for port in ports:
    listen_port = port.socat
    script_path = '/scripts/socat_pf_{}.sh'.format(listen_port)
    supervisor_path = '/etc/supervisor.d/k8s_pf_{}.ini'.format(listen_port)
    with open(script_path, 'w') as f:
        f.write(socat_tpl.render(port=port))
        os.chmod(script_path, 755)
    with open(supervisor_path, 'w') as f:
        app = 'socat_pf_{}'.format(listen_port)
        f.write(supervisor_tpl.render(app=app, cmd=script_path))
