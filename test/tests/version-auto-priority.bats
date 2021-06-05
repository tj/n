#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'


# auto

function setup_file() {
  unset_n_env
  tmpdir="${TMPDIR:-/tmp}"
  export MY_DIR="${tmpdir}/n/test/version-resolve-auto-priority"
  mkdir -p "${MY_DIR}"

  # Need a version of node available for reading package.json
  export N_PREFIX="${MY_DIR}"
  export PATH="${MY_DIR}/bin:${PATH}"
  n install lts
}

function teardown_file() {
  rm -rf "${MY_DIR}"
}

function setup() {
  # Bit fragile, but reuse directory and clean up between tests.
  rm -f "${MY_DIR}/package.json"
  rm -f "${MY_DIR}/.n-node-version"
  rm -f "${MY_DIR}/.node-version"
  rm -f "${MY_DIR}/.nvmrc"
}

@test ".n-node-version first" {
  cd "${MY_DIR}"
  echo "8.1.4" > .n-node-version
  echo "8.2.0" > .node-version
  echo "8.3.0" > .nvmrc
  echo '{ "engines" : { "node" : "v8.4.0" } }' > package.json

  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.1.4"
}

@test ".node-version second" {
  cd "${MY_DIR}"
  echo "8.2.0" > .node-version
  echo "8.3.0" > .nvmrc
  echo '{ "engines" : { "node" : "v8.4.0" } }' > package.json

  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.2.0"
}

@test ".nvmrc third" {
  cd "${MY_DIR}"
  echo "8.3.0" > .nvmrc
  echo '{ "engines" : { "node" : "v8.4.0" } }' > package.json

  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.3.0"
}

@test ".package.json last" {
  cd "${MY_DIR}"
  echo '{ "engines" : { "node" : "v8.4.0" } }' > package.json

  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.4.0"
}

@test ".package.json last, after parent scanning" {
  cd "${MY_DIR}"
  echo "8.2.0" > .node-version
  mkdir package
  cd package
  echo '{ "engines" : { "node" : "v8.4.0" } }' > package.json

  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  assert_equal "${output}" "8.2.0"

  rm package.json
  cd ..
  rmdir package
}
