#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
#
# author        : JV-conseil
# credits       : JV-conseil
# copyright     : Copyright (c) 2019-2023 JV-conseil
#                 All rights reserved
#====================================================
set -Eeou pipefail
shopt -s failglob

_jvcl_::gem_update() {
  local _gem _gems=("bundler")
  # gem update --system
  for _gem in "${_gems[@]}"; do
    echo "Checking if ${_gem} is installed..."
    gem info "${_gem}" || gem install "${_gem}"
    gem update "${_gem}"
  done
}

_jvcl_::bundle_update() {
  local _opt
  rm -vrf "./Gemfile.lock" || :
  for _opt in "check" "doctor" "install" "update" "lock"; do
    bundle "${_opt}" --verbose || :
  done
}

# Bash equivalent of Python if __name__ == "__main__":
# <https://stackoverflow.com/a/70662116/2477854>
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  _jvcl_::gem_update
  _jvcl_::bundle_update
fi
