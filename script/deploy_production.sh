#!/bin/sh

set -ex

cat << EOF >> ~/.ssh/config
Host blue02
  HostName 52.198.139.4
  User a-know

Host green02
  HostName 52.199.32.19
  User a-know
EOF

bundle exec cap production deploy
