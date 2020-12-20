#!/usr/bin/env bats

load shared-functions


function setup() {
  unset_n_env
}


@test "n --lts" {
  output="$(n --lts)"
  local expected_version
  expected_version="$(display_remote_version lts)"
  expected_version="${expected_version#v}"
  [ "${output}" = "${expected_version}" ]
}


@test "n --stable" {
  output="$(n --stable)"
  local expected_version
  expected_version="$(display_remote_version lts)"
  expected_version="${expected_version#v}"
  [ "${output}" = "${expected_version}" ]
}


@test "n --latest" {
  output="$(n --latest)"
  local expected_version
  expected_version="$(display_remote_version latest)"
  expected_version="${expected_version#v}"
  [ "${output}" = "${expected_version}" ]
}
