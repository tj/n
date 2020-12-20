#!/usr/bin/env bats

load shared-functions


# auto

function setup() {
  unset_n_env
  tmpdir="${TMPDIR:-/tmp}"
  export MY_DIR="${tmpdir}/n/test/version-resolve-auto-priority"
  mkdir -p "${MY_DIR}"
  # Bit fragile, but reuse directory and clean up between tests.
  rm -f "${MY_DIR}/package.json"
  rm -f "${MY_DIR}/.n-node-version"
  rm -f "${MY_DIR}/.node-version"
  rm -f "${MY_DIR}/.nvmrc"

  # Need a version of node available for reading package.json
  export N_PREFIX="${MY_DIR}"
  export PATH="${MY_DIR}/bin:${PATH}"
  if [[ "${BATS_TEST_NUMBER}" -eq 1 ]] ; then
    # beforeAll
    n install lts
  fi
}

function teardown() {
  # afterAll
  if [[ "${#BATS_TEST_NAMES[@]}" -eq "${BATS_TEST_NUMBER}" ]] ; then
    rm -rf "${MY_DIR}"
  fi
}

@test ".n-node-version first" {
  cd "${MY_DIR}"
  echo "401.0.1" > .n-node-version
  echo "401.0.2" > .node-version
  echo "401.0.3" > .nvmrc
  echo '{ "engines" : { "node" : "v401.0.4" } }' > package.json

  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "401.0.1" ]
}

@test ".node-version second" {
  cd "${MY_DIR}"
  echo "401.0.2" > .node-version
  echo "401.0.3" > .nvmrc
  echo '{ "engines" : { "node" : "v401.0.4" } }' > package.json

  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "401.0.2" ]
}

@test ".nvmrc third" {
  cd "${MY_DIR}"
  echo "401.0.3" > .nvmrc
  echo '{ "engines" : { "node" : "v401.0.4" } }' > package.json

  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "401.0.3" ]
}

@test ".package.json last" {
  cd "${MY_DIR}"
  echo '{ "engines" : { "node" : "v401.0.4" } }' > package.json

  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "401.0.4" ]
}

@test ".package.json last, after parent scanning" {
  cd "${MY_DIR}"
  echo "401.0.2" > .node-version
  mkdir package
  cd package
  echo '{ "engines" : { "node" : "v401.0.4" } }' > package.json

  output="$(n N_TEST_DISPLAY_LATEST_RESOLVED_VERSION auto)"
  [ "${output}" = "401.0.2" ]

  rm package.json
  cd ..
  rmdir package
}
