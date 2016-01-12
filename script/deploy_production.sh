#!/bin/sh

set -ex

cat << EOF >> ~/.ssh/config
Host home.a-know.me
  HostName 104.155.208.57
  User a-know
EOF

bundle exec cap production deploy
