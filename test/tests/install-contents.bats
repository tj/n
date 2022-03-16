#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'


function setup() {
  unset_n_env
}


# Test that files get installed to expected locations
# https://github.com/tj/n/issues/246

@test "install: contents" {
  readonly TARGET_VERSION="4.9.1"
  setup_tmp_prefix

  [ ! -d "${N_PREFIX}/n/versions" ]
  [ ! -d "${N_PREFIX}/bin" ]
  [ ! -d "${N_PREFIX}/include" ]
  [ ! -d "${N_PREFIX}/lib" ]
  [ ! -d "${N_PREFIX}/shared" ]

  n ${TARGET_VERSION}

  # Cached version
  [ -d "${N_PREFIX}/n/versions/node/${TARGET_VERSION}" ]
  # node and npm
  [ -f "${N_PREFIX}/bin/node" ]
  [ -f "${N_PREFIX}/bin/npm" ]
  # Installed something into each of other key folders
  [ -d "${N_PREFIX}/include/node" ]
  [ -d "${N_PREFIX}/lib/node_modules" ]
  [ -d "${N_PREFIX}/share/doc/node" ]
  # Did not install files from top level of tarball
  [ ! -f "${N_PREFIX}/README.md" ]

  output="$(node --version)"
  assert_equal "${output}" "v${TARGET_VERSION}"

  rm -rf "${TMP_PREFIX_DIR}"
}

@test "install: cache prefix" {
  readonly N_CACHE_PREFIX="$(mktemp -d)"
  readonly TARGET_VERSION="4.9.1"
  setup_tmp_prefix
  export N_CACHE_PREFIX

  [ ! -d "${N_CACHE_PREFIX}/n/versions/node/${TARGET_VERSION}" ]
  [ ! -d "${N_PREFIX}/n/versions/node/${TARGET_VERSION}" ]

  n ${TARGET_VERSION}

  # Cached version
  [ -d "${N_CACHE_PREFIX}/n/versions/node/${TARGET_VERSION}" ]
  [ ! -d "${N_PREFIX}/n/versions/node/${TARGET_VERSION}" ]

  rm -rf "${TMP_PREFIX_DIR}" "${N_CACHE_PREFIX}"
}
