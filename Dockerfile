#
# Script Name : Dockerfile
# Description : ...
# Created     : January 30, 2025
# Author      : JV-conseil
# Contact     : contact@jv-conseil.dev
# Website     : https://www.jv-conseil.dev
# Copyright   : (c) 2025 JV-conseil
#               All rights reserved
# ========================================================

FROM ruby:3-alpine
LABEL maintainer="JV conseil <contact@jv-conseil.net>"
COPY / /

#
# EnvVars
# Ruby
#

ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV BUNDLE_DISABLE_PLATFORM_WARNINGS=true
ENV BUNDLE_HOME=/usr/local/bundle
ENV GEM_BIN=/usr/gem/bin
ENV GEM_HOME=/usr/gem
ENV RUBYOPT=-W0

#
# EnvVars
# Image
#

ENV JEKYLL_BIN=/usr/jekyll/bin
ENV JEKYLL_DATA_DIR=/srv/jekyll
ENV JEKYLL_DOCKER_COMMIT="$(/usr/bin/git rev-parse --verify HEAD)"
ENV JEKYLL_DOCKER_NAME=jekyll-docker
ENV JEKYLL_ENV=production
ENV JEKYLL_VAR_DIR=/var/jekyll
ENV JEKYLL_VERSION=4.4.1
ENV JEKYLL_DOCKER_TAG=$JEKYLL_VERSION

#
# EnvVars
# System
#

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TZ=Europe/Paris
ENV PATH="$JEKYLL_BIN:$PATH"
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US

#
# EnvVars
# Main
#

ENV VERBOSE=false
ENV FORCE_POLLING=false
ENV DRAFTS=false


#
# Packages
# Dev
#

RUN apk --no-cache add \
  build-base \
  cmake \
  imagemagick-dev \
  libffi-dev \
  libxml2-dev \
  libxslt-dev \
  readline-dev \
  ruby-dev \
  sqlite-dev \
  vips-dev \
  vips-tools \
  yaml-dev \
  zlib-dev

#
# Packages
# Main
#

RUN apk --no-cache add \
  bash \
  git \
  less \
  lftp \
  libffi \
  libressl \
  libxml2 \
  libxslt \
  linux-headers \
  nodejs \
  npm \
  openjdk8-jre \
  openssh-client \
  readline \
  rsync \
  shadow \
  su-exec \
  tzdata \
  yarn \
  zlib

#
# Gems
# Update
#

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN unset GEM_HOME && unset GEM_BIN && \
  yes | gem update --system

#
# Gems
# Main
#

RUN unset GEM_HOME && unset GEM_BIN && yes | gem install --force bundler
RUN gem install --backtrace jekyll -v $JEKYLL_VERSION

#
# Gems
# Extension
#

RUN gem install --backtrace -V \
  html-proofer \
  jekyll-avatar \
  jekyll-coffeescript \
  jekyll-compose \
  jekyll-default-layout \
  jekyll-docs \
  jekyll-feed \
  jekyll-include-cache \
  jekyll-last-modified-at \
  jekyll-mentions \
  jekyll-optional-front-matter \
  jekyll-paginate \
  jekyll-readme-index \
  jekyll-redirect-from \
  jekyll-relative-links \
  jekyll-sass-converter \
  jekyll-seo-tag \
  jekyll-sitemap \
  jekyll-titles-from-headings \
  jemoji \
  kramdown \
  minima \
  RedCloth \
  s3_website


RUN addgroup -Sg 1000 jekyll
RUN adduser  -Su 1000 -G \
  jekyll jekyll

#
# Remove development packages on minimal.
# And on pages.  Gems are unsupported.
#

RUN apk --no-cache del \
  build-base \
  cmake \
  imagemagick-dev\
  libffi-dev \
  libxml2-dev \
  libxslt-dev \
  linux-headers \
  openjdk8-jre \
  readline-dev \
  ruby-dev \
  vips-dev \
  vips-tools \
  yaml-dev \
  zlib-dev

RUN mkdir -p $JEKYLL_VAR_DIR
RUN mkdir -p $JEKYLL_DATA_DIR
RUN chown -R jekyll:jekyll $JEKYLL_DATA_DIR
RUN chown -R jekyll:jekyll $JEKYLL_VAR_DIR
RUN chown -R jekyll:jekyll $BUNDLE_HOME
RUN rm -rf /home/jekyll/.gem
RUN rm -rf $BUNDLE_HOME/cache
RUN rm -rf $GEM_HOME/cache
RUN rm -rf /root/.gem

# Work around rubygems/rubygems#3572
RUN mkdir -p /usr/gem/cache/bundle
RUN chown -R jekyll:jekyll \
  /usr/gem/cache/bundle

CMD ["jekyll", "--help"]
ENTRYPOINT ["/usr/jekyll/bin/entrypoint"]
WORKDIR /srv/jekyll
VOLUME  /srv/jekyll
EXPOSE 35729
EXPOSE 4000
