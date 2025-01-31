#!/usr/bin/env bash
#
# Script Name : docker.sh
# Description : ...
# Created     : January 30, 2025
# Author      : JV-conseil
# Contact     : contact@jv-conseil.dev
# Website     : https://www.jv-conseil.dev
# Copyright   : (c) 2025 JV-conseil
#               All rights reserved
# ========================================================

set -Eeou pipefail
shopt -s failglob

_jvcl_::dockerfile_reverse_engineer() {
  local _image="${1:-jvconseil/jekyll-docker:latest}" _dump="./DockerfileReverseEngineer.txt"
  docker history --no-trunc --format='table {{.CreatedBy}}' "${_image}" |
    tail -r |
    sed -E 's~/bin/sh -c #\(nop\) +~~g; s~/bin/sh -c~RUN~g;' \
      >"${_dump}"
}

_jvcl_::update_dockerfile() {
  local _comit _jekyll=4.4.1

  _comit=$(git rev-parse --verify HEAD)

  sed -i '' -E "s~^ENV JEKYLL_DOCKER_COMMIT=[a-z0-9]+$~ENV JEKYLL_DOCKER_COMMIT=${_comit}~g" ./Dockerfile &&
    printf "ENV JEKYLL_DOCKER_COMMIT=%s\n" "${_comit}"

  sed -i '' -E "s~^ENV JEKYLL_VERSION=[0-9.]+$~ENV JEKYLL_VERSION=${_jekyll}~g" ./Dockerfile &&
    printf "ENV JEKYLL_VERSION=%s\n" "${_jekyll}"
}

_jvcl_::dockerfile_reverse_engineer "$@"

