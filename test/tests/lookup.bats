#!/usr/bin/env bats

load shared-functions


function setup() {
  unset_n_env
}


@test "n --lts" {
  run n --lts
  [ "${status}" -eq 0 ]
  local expected_version
  expected_version="$(display_remote_version lts)"
  expected_version="${expected_version#v}"
  [ "${output}" = "${expected_version}" ]
}


@test "n --latest" {
  run n --latest
  [ "${status}" -eq 0 ]
  local expected_version
  expected_version="$(display_remote_version latest)"
  expected_version="${expected_version#v}"
  [ "${output}" = "${expected_version}" ]
}
