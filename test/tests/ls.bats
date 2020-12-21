#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'

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

  output="$(n ls)"
  assert_equal "${output}" "node/4.9.1
node/10.15.0"
}


@test "n list # mixed node and nightly" {
  local NIGHTLY_VERSION="12.0.0-nightly201812104aabd7ed64"
  # KISS and just make folders rather than do actual installs
  mkdir -p "${N_PREFIX}/n/versions/nightly/${NIGHTLY_VERSION}"
  mkdir -p "${N_PREFIX}/n/versions/node/10.15.0"

  output="$(n list)"
  assert_equal "${output}" "nightly/${NIGHTLY_VERSION}
node/10.15.0"
}

