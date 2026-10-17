#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'

# We have a fixture to test lookups of the (future) alpha versions of node.
# curl builds can support the file URL whiich is convenient for lookup testing
# without needing to spin up a web server, but not supported in the docker container.

function setup() {
  if ! command -v curl >/dev/null 2>&1; then
    skip 'curl is not available'
  fi
  if ! curl --version | grep -E '^Protocols:.*\bfile\b' >/dev/null 2>&1; then
    skip 'curl does not support the file protocol'
  fi

  unset_n_env
  export N_NODE_MIRROR="file://${BATS_TEST_DIRNAME}/fixtures/alpha"
}

function teardown() {
  unset_n_env
}


@test "n lsr latest # includes alpha (fixture)" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr latest)"
  assert_equal "${output}" "27.0.0-alpha.0.11.0"
}

@test "n lsr current # excludes alpha (fixture)" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr current)"
  assert_equal "${output}" "26.12.0"
}

@test "n lsr 27 # partial number in main version (fixture)" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr 27)"
  assert_equal "${output}" "27.0.0-alpha.0.11.0"
}

@test "n lsr 27.0.0-alpha.0.1 # partial number in alpha version (fixture)" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr 27.0.0-alpha.0.1)"
  assert_equal "${output}" "27.0.0-alpha.0.1.1"
}
