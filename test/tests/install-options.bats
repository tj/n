#!/usr/bin/env bats

load shared-functions


function setup() {
  unset_n_env
  setup_tmp_prefix
  install_dummy_node
}


function teardown() {
  rm -rf "${TMP_PREFIX_DIR}"
}


@test "n --download 4.9.1" {
  n --download 4.9.1
  [ -d "${N_PREFIX}/n/versions/node/4.9.1" ]
  # Remember, we installed a dumy node so do have a bin/node
  [ ! -f "${N_PREFIX}/bin/npm" ]
  [ ! -d "${N_PREFIX}/include" ]
  [ ! -d "${N_PREFIX}/lib" ]
  [ ! -d "${N_PREFIX}/shared" ]
}


@test "n --quiet 4.9.1" {
  # just checking option is allowed, not testing functionality
  n --quiet 4.9.1
  run node --version
  [ "${output}" = "v4.9.1" ]
}


# ToDo: --arch
