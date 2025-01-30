#!/bin/sh
[ "$DEBUG" = "true" ] && set -x
set -e

trap 'kill -SIGTERM ${!}' TERM

args=$(default-args "$@")

#
# The assumption here is that if we aren't ID 0 then
#   something we wrapped, recalled us, so we need to ship
#   them to the right spot.  This can happen in one
#   scenario (when you do `jekyll new`.)
#
if [ "$(id -u)" != "0" ]; then
  exec "$BUNDLE_BIN/jekyll" "$@"
fi

[ -d ".cache" ] && chown -R jekyll:jekyll .cache
[ -d ".jekyll-cache" ] && chown -R jekyll:jekyll .jekyll-cache
[ -d ".sass-cache" ] && chown -R jekyll:jekyll .sass-cache
[ -d "_site" ] && chown -R jekyll:jekyll _site

#
# Install if the user has a Gemfile.
# Install if we are also connecteds.
#
if [ -f "Gemfile" ] && connected; then
  bundle install
fi

ruby --version

sup_args=""
exe=$BUNDLE_BIN/jekyll
[ "$JEKYLL_DOCKER_TAG" = "pages" ] && sup_args="-r github-pages"
[ -x "$exe" ] && exec su-exec jekyll bundle exec ruby $sup_args $exe $args
su-exec jekyll ruby $sup_args "$GEM_BIN/jekyll" $args & wait ${!}
