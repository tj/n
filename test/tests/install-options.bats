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


@test "n --download 18.16.1" {
  # deprecated use of --download, replaced by download command
  n --download 18.16.1
  [ -d "${N_PREFIX}/n/versions/node/18.16.1" ]
  [ ! -f "${N_PREFIX}/bin/node" ]
  [ ! -f "${N_PREFIX}/bin/npm" ]
  [ ! -d "${N_PREFIX}/include" ]
  [ ! -d "${N_PREFIX}/lib" ]
  [ ! -d "${N_PREFIX}/shared" ]
}


@test "n download 18.16.1" {
  # not an option, but keep with --download so stays in sync
  n download 18.16.1
  [ -d "${N_PREFIX}/n/versions/node/18.16.1" ]
  [ ! -f "${N_PREFIX}/bin/node" ]
  [ ! -f "${N_PREFIX}/bin/npm" ]
  [ ! -d "${N_PREFIX}/include" ]
  [ ! -d "${N_PREFIX}/lib" ]
  [ ! -d "${N_PREFIX}/shared" ]
}


@test "n --quiet 18.16.1" {
  # just checking option is allowed, not testing functionality
  n --quiet 18.16.1
  output="$(node --version)"
  assert_equal "${output}" "v18.16.1"
}


@test "n --cleanup 18.16.1" {
  n install --cleanup 18.16.1
  output="$(node --version)"
  assert_equal "${output}" "v18.16.1"
  [ ! -d "${N_PREFIX}/n/versions/node/18.16.1" ]
}


# mostly --preserve, but also variations with i/install and lts/numeric
@test "--preserve variations # (4 installs)" {
  local IRON_VERSION="v20.20.2"
  local IRON_NPM_VERSION="10.8.2"
  local LTS_VERSION
  LTS_VERSION="$(display_remote_version lts)"

  n ${IRON_VERSION}
  output="$("${N_PREFIX}/bin/node" --version)"
  assert_equal "$output" "${IRON_VERSION}"
  output="$("${N_PREFIX}/bin/npm" --version)"
  assert_equal "$output" "${IRON_NPM_VERSION}"

  n --preserve "${LTS_VERSION}"
  output="$("${N_PREFIX}/bin/node" --version)"
  assert_equal "$output" "v${LTS_VERSION}"
  output="$("${N_PREFIX}/bin/npm" --version)"
  assert_equal "$output" "${IRON_NPM_VERSION}"

  N_PRESERVE_NPM=1 n "${LTS_VERSION}"
  output="$("${N_PREFIX}/bin/npm" --version)"
  assert_equal "$output" "${IRON_NPM_VERSION}"

  N_PRESERVE_NPM=1 n --no-preserve "${LTS_VERSION}"
  output="$("${N_PREFIX}/bin/npm" --version)"
  assert [ "$output" != "${IRON_NPM_VERSION}" ]
}



# ToDo: --arch
