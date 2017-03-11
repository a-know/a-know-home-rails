#!/bin/sh

set -ex

ruby script/edit_ssh_config.rb

bundle exec cap production deploy
