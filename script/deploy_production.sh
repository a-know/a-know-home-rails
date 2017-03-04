#!/bin/sh

set -ex

cat << EOF >> ~/.ssh/config
Host blue01
  HostName 13.113.86.55
  User a-know

Host green01
  HostName 13.112.11.174
  User a-know
EOF

bundle exec cap production deploy
