#!/usr/bin/env bats

load shared-functions


function setup() {
  unset_n_env
  setup_tmp_prefix
}


function teardown() {
  rm -rf "${TMP_PREFIX_DIR}"
}


# Testing version permutations in lsr tests

@test "n 4.9.1" {
  n 4.9.1
  output="$(node --version)"
  [ "${output}" = "v4.9.1" ]
}


@test "n lts" {
  n lts
  output="$(node --version)"
  [ "${output}" = "v$(display_remote_version lts)" ]
}


@test "n latest" {
  n latest
  output="$(node --version)"
  [ "${output}" = "v$(display_remote_version latest)" ]
}
