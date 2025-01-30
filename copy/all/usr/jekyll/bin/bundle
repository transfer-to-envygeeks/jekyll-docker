#!/bin/bash
[ "$DEBUG" = "true" ] && set -x
exe=/usr/local/bin/bundle
default-gem-permissions
set -e

#
# Skip out if we aren't UID=0 because it's Jekyll
# Don't prevent the user from doing normal bundle stuff
#   this is really rare but can happen during debugs
#
if [[ ! -f "Gemfile" ]] || [ "$(id -u)" != "0" ]; then
   exec $exe "$@"
fi

if [ "$1" = "install" ] || [ "$1" = "update" ]; then
  # There is no need to report that we are using check.
  if [ "$1" = "update" ] || ! su-exec jekyll $exe check 1>/dev/null 2>&1; then
    if [ ! -f "/updated" ] && connected && [ -f ".apk" ]; then
      apk add --no-cache --no-progress \
        $(cat .apk)
    fi

    su-exec jekyll $exe config jobs 2
    su-exec jekyll $exe config ignore_messages true
    su-exec jekyll $exe config build.nokogiri --use-system-libraries
    su-exec jekyll $exe config disable_version_check true
    unset DEBUG; su-exec jekyll $exe "$@"
    su-exec jekyll $exe clean \
      2>/dev/null || true
  fi
else
  su-exec jekyll $exe "$@"
fi
