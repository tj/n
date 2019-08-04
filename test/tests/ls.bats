#!/usr/bin/env bats

load shared-functions

function setup() {
  unset_n_env
  setup_tmp_prefix
}

function teardown() {
  rm -rf "${TMP_PREFIX_DIR}"
}


@test "n ls # just plain node" {
  # KISS and just make folders rather than do actual installs
  mkdir -p "${N_PREFIX}/n/versions/node/4.9.1"
  mkdir -p "${N_PREFIX}/n/versions/node/10.15.0"

  run n ls
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "node/4.9.1" ]
  [ "${lines[1]}" = "node/10.15.0" ]
  [ "${lines[2]}" = "" ]
}


@test "n list # mixed node and nightly" {
  local NIGHTLY_VERSION="12.0.0-nightly201812104aabd7ed64"
  # KISS and just make folders rather than do actual installs
  mkdir -p "${N_PREFIX}/n/versions/nightly/${NIGHTLY_VERSION}"
  mkdir -p "${N_PREFIX}/n/versions/node/10.15.0"

  run n list
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "nightly/${NIGHTLY_VERSION}" ]
  [ "${lines[1]}" = "node/10.15.0" ]
  [ "${lines[2]}" = "" ]
}

