#!/bin/bash
[ "$DEBUG" = "true" ] && set -x
set -e

if [ "$(id -u)" = "0" ]; then
  chown -R jekyll:jekyll "$BUNDLE_HOME"
  chown -R jekyll:jekyll /usr/gem
fi
