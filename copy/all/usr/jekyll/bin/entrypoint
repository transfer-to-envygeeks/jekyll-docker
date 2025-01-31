#!/bin/bash
[ "$DEBUG" = "true" ] && set -x
set -e

#
# Running rootless means that we force Jekyll to run
# entirely as 'root'. This is substituted by the container
# to the uid of the actual user.
#
if [ "$JEKYLL_ROOTLESS" ]; then
  JEKYLL_UID=0
  JEKYLL_GID=0
fi

: ${JEKYLL_UID:=$(id -u jekyll)}
: ${JEKYLL_GID:=$(id -g jekyll)}
export JEKYLL_UID
export JEKYLL_GID

#
# Users can customize our UID's to fit their own so that
#   we don't have to chown constantly.  Well it's not like
#   we do so much of it (anymore) it's slow, but we do
#   change permissions which can result in some bad
#   behavior on OS X.
#
if [ "$JEKYLL_UID" != "0" ] && [ "$JEKYLL_UID" != "$(id -u jekyll)" ]; then
  usermod  -o -u "$JEKYLL_UID" jekyll
  groupmod -o -g "$JEKYLL_GID" jekyll
  chown_args=""

  [ "$FULL_CHOWN" ] && chown_args="-R"
  for d in "$JEKYLL_DATA_DIR" "$JEKYLL_VAR_DIR"; do
    chown $chown_args jekyll:jekyll "$d"
  done
fi

#
# Make sure JEKYLL matches the UID/GID
# This will most likely end up as 1
#
if [ "$JEKYLL_ROOTLESS" ]; then
  usermod  -o -u $JEKYLL_UID jekyll
  groupmod -o -g $JEKYLL_GID jekyll
fi

exec "$@"
