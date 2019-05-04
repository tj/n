#!/usr/bin/env bats

load shared-functions


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

  install_dummy_node
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

  run node --version
  [ "${output}" = "v${TARGET_VERSION}" ]

  rm -rf "${TMP_PREFIX_DIR}"
}
