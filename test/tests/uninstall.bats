#!/usr/bin/env bats

load shared-functions

function setup() {
  unset_n_env
  setup_tmp_prefix
}

function teardown() {
  rm -rf "${TMP_PREFIX_DIR}"
}


@test "n uninstall (of lts)" {
  n lts
  [ -f "${N_PREFIX}/bin/node" ]
  [ -f "${N_PREFIX}/bin/npm" ]
  [ -f "${N_PREFIX}/lib/node_modules/npm/package.json" ]

  # Check we get all the files if we uninstall and rm cache.
  echo y | n uninstall
  n rm lts
  run find "${N_PREFIX}" -not -type d
  [ "${status}" -eq "0" ]
  [ "$output" = "" ]
}


@test "n uninstall (of nightly/latest)" {
  n nightly/latest
  [ -f "${N_PREFIX}/bin/node" ]
  [ -f "${N_PREFIX}/bin/npm" ]
  [ -f "${N_PREFIX}/lib/node_modules/npm/package.json" ]

  # Check we get all the files if we uninstall and rm cache.
  echo y | n uninstall
  n rm nightly/latest
  run find "${N_PREFIX}" -not -type d
  [ "${status}" -eq "0" ]
  [ "$output" = "" ]
}
