#!/bin/sh
[ "$DEBUG" = "true" ] && set -x
set -e

connected=$JEKYLL_VAR_DIR/connected
disconnected=$JEKYLL_VAR_DIR/disconnected
[ -f "$disconnected" ] && [ -f "$connected" ] &&  rm -f "$disconnected" "$connected"
{ [ "$CONNECTED" = "false" ] || [ -f "$disconnected" ]; } && exit 1
{ [ "$CONNECTED" =  "true" ] || [ -f "$connected" ]; } && exit 0

#
# If we aren't connected, or forced as connected, or not
# connected then we should check with WGet (because of Proxies)
# whether we are connected to the internet.
#

url=https://detectportal.firefox.com
if wget -q --spider "$url" -O /dev/null 2>/dev/null; then
  su-exec jekyll touch "$connected"
  exit 0
else
  su-exec jekyll touch $disconnected
  exit 1
fi
