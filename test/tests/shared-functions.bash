#!/usr/bin/env bash


# unset the n environment variables so tests running from known state.
# Globals:
#   lots

function unset_n_env(){
  unset N_PREFIX
  unset NODE_MIRROR
  unset N_NODE_MIRROR
  unset N_NODE_DOWNLOAD_MIRROR
  unset N_MAX_REMOTE_MATCHES
  unset N_PRESERVE_NPM
  unset HTTP_USER
  unset HTTP_PASSWORD
  unset GREP_OPTIONS
}


# Create temporary dir and configure n to use it.
# Globals:
#   TMP_PREFIX_DIR
#   N_PREFIX
#   PATH

function setup_tmp_prefix() {
  TMP_PREFIX_DIR="$(mktemp -d)"
  [ -d "${TMP_PREFIX_DIR}" ] || exit 2
  # return a safer variable to `rm -rf` later than N_PREFIX
  export TMP_PREFIX_DIR

  export N_PREFIX="${TMP_PREFIX_DIR}"
  export PATH="${N_PREFIX}/bin:${PATH}"
}


# Display relevant file name (third field of index.tab) for current platform.
# Based on code from nvm rather than n for independent approach. Simplified for just common platforms initially.
# See list on https://github.com/nodejs/nodejs-dist-indexer

function display_compatible_file_field() {
  local os="unexpected"
  case "$(uname -a)" in
    Linux\ *) os="linux" ;;
    Darwin\ *) os="osx" ;;
  esac

  local arch="unexpected"
  local uname_m
  uname_m="$(uname -m)"
  case "${uname_m}" in
    x86_64 | amd64) arch="x64" ;;
    i*86) arch="x86" ;;
    aarch64) arch="arm64" ;;
    *) arch="${uname_m}" ;;
  esac

  echo "${os}-${arch}"
}


# display_remote_version <version>
# Limited support for using index.tab to resolve version into a number.
# Return version number, without leading v.
#
# The simper (and independent) code here can cause transient false positive failures, like if the latest nightly version
# has not been build for all architectures yet.

function display_remote_version() {
  # ToDo: support NODE_MIRROR

  local fetch
  if command -v curl &> /dev/null; then
    fetch="curl --silent --location --fail --compressed"
  else
    # insecure to match current n implementation
    fetch="wget -q -O- --no-check-certificate"
  fi

  local TAB_CHAR=$'\t'
  local match='xxx'
  local mirror="${N_NODE_MIRROR:-https://nodejs.org/dist}"
  if [[ "$1" = "lts" || "$1" = "stable" ]]; then
    match="^([^${TAB_CHAR}]+${TAB_CHAR}){9}[^-]"
  elif [[ "$1" = "latest" ]]; then
    match='.'
  elif [[ "$1" = "nightly" ]]; then
    match='.'
    mirror="${N_NODE_DOWNLOAD_MIRROR:-https://nodejs.org/download}/nightly"
  fi

  # Using awk rather than head so do not close pipe early on curl
  ${fetch} "${mirror}/index.tab" \
    | tail -n +2 \
    | grep "$(display_compatible_file_field)" \
    | grep -E "${match}" \
    | cut -f -1 \
    | awk "NR==1" \
    | grep -E -o '[^v].*'
}
