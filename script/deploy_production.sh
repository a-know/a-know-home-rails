#!/bin/sh

set -ex

cat << EOF >> ~/.ssh/config
Host home.a-know.me
  HostName 153.127.197.186
  User a-know
EOF

bundle exec cap production deploy
