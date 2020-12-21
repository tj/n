#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'


function setup() {
  unset_n_env
  setup_tmp_prefix
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
  output="$(node --version)"
  assert_equal "${output}" "v4.9.1"
}


# mostly --preserve, but also variations with i/install and lts/numeric
@test "--preserve variations # (4 installs)" {
  local ARGON_VERSION="v4.9.1"
  local ARGON_NPM_VERSION="2.15.11"
  local LTS_VERSION="$(display_remote_version lts)"

  n ${ARGON_VERSION}
  output="$("${N_PREFIX}/bin/node" --version)"
  assert_equal "$output" "${ARGON_VERSION}"
  output="$("${N_PREFIX}/bin/npm" --version)"
  assert_equal "$output" "${ARGON_NPM_VERSION}"

  n --preserve "${LTS_VERSION}"
  output="$("${N_PREFIX}/bin/node" --version)"
  assert_equal "$output" "v${LTS_VERSION}"
  output="$("${N_PREFIX}/bin/npm" --version)"
  assert_equal "$output" "${ARGON_NPM_VERSION}"

  N_PRESERVE_NPM=1 n "${LTS_VERSION}"
  output="$("${N_PREFIX}/bin/npm" --version)"
  assert_equal "$output" "${ARGON_NPM_VERSION}"

  N_PRESERVE_NPM=1 n --no-preserve "${LTS_VERSION}"
  output="$("${N_PREFIX}/bin/npm" --version)"
  assert [ "$output" != "${ARGON_NPM_VERSION}" ]
}



# ToDo: --arch
