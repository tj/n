#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'

function setup_file() {
  unset_n_env
  setup_tmp_prefix
  # Note, NOT latest version of 16.
  n download 16.19.0
  export N_NODE_MIRROR="https://no.internet.available"
}

function teardown_file() {
  rm -rf "${TMP_PREFIX_DIR}"
}

function setup() {
  hash -r
}

@test "n --offline 16" {
  n --offline 16
  hash -r
  output="$(node --version)"
  assert_equal "${output}" "v16.19.0"
  rm "${TMP_PREFIX_DIR}/bin/node"
}

@test "n --offline latest" {
  n --offline latest
  hash -r
  output="$(node --version)"
  assert_equal "${output}" "v16.19.0"
  rm "${TMP_PREFIX_DIR}/bin/node"
}

@test "n --offline run 16..." {
  output="$(n --offline run 16 --version)"
  assert_equal "${output}" "v16.19.0"
}

@test "n --offline exec 16..." {
  output="$(n --offline exec 16 node --version)"
  assert_equal "${output}" "v16.19.0"
}

@test "n --offline which 16..." {
  output="$(n --offline which 16)"
  assert_equal "${output}" "${TMP_PREFIX_DIR}/n/versions/node/16.19.0/bin/node"
}
