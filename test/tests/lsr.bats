#!/usr/bin/env bats

load shared-functions
load '../../node_modules/bats-support/load'
load '../../node_modules/bats-assert/load'


function setup() {
  unset_n_env
}


# labels

@test "n lsr lts" {
  output="$(n lsr lts)"
  assert_equal "${output}" "$(display_remote_version lts)"
}

@test "n lsr stable" {
  output="$(n lsr lts)"
  assert_equal "${output}" "$(display_remote_version lts)"
}

@test "n ls-remote latest" {
  output="$(n ls-remote latest)"
  assert_equal "${output}" "$(display_remote_version latest)"
}

@test "n list-remote current" {
  output="$(n list-remote current)"
  assert_equal "${output}" "$(display_remote_version latest)"
}


# codenames

@test "n=1 n lsr argon" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr argon)"
  assert_equal "${output}" "4.9.1"
}

@test "n=1 n lsr Argon # case" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr Argon)"
  assert_equal "${output}" "4.9.1"
}


# numeric versions

@test "n=1 n lsr 4" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr 4)"
  assert_equal "${output}" "4.9.1"
}

@test "n=1 n lsr v4" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr v4)"
  assert_equal "${output}" "4.9.1"
}

@test "n=1 n lsr 4.9" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr 4.9)"
  assert_equal "${output}" "4.9.1"
}

@test "n=1 n lsr 4.9.1" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr 4.9.1)"
  assert_equal "${output}" "4.9.1"
}

@test "n=1 n lsr v4.9.1" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr v4.9.1)"
  assert_equal "${output}" "4.9.1"
}

@test "n lsr 6.2 # multiple matches with header" {
  output="$(n lsr 6.2)"
  assert_equal "${output}" "Listing remote... Displaying 20 matches (use --all to see all).
6.2.2
6.2.1
6.2.0"
}

@test "n=1 n lsr --all 6.2 # --all, multiple matches with no header" {
  output="$(N_MAX_REMOTE_MATCHES=1 n --all lsr 6.2)"
  assert_equal "${output}" "6.2.2
6.2.1
6.2.0"
}

# Checking does not match 8.11
@test "n=1 n lsr v8.1 # numeric match" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr v8.1)"
  assert_equal "${output}" "8.1.4"
}


# Nightly

@test "n=1 n lsr nightly" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly)"
  assert_equal "${output}" "$(display_remote_version nightly)"
}

@test "n=1 n lsr nightly/" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/)"
  assert_equal "${output}" "$(display_remote_version nightly)"
}

@test "n=1 n lsr nightly/latest" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/latest)"
  assert_equal "${output}" "$(display_remote_version nightly)"
}

@test "n=1 n lsr nightly/v10.8.1-nightly201808 # partial match" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/v10.8.1-nightly201808)"
  assert_equal "${output}" "10.8.1-nightly2018081382830a809b"
}

# Numeric match should not find v7.10.1-nightly2017050369a8053e8a
@test "n=1 n lsr nightly/7.1 # numeric match" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/7.1)"
  assert_equal "${output}" "7.1.1-nightly201611093daf11635d"
}

# Numeric match should not find v7.10.1-nightly2017050369a8053e8a
@test "n=1 n lsr nightly/v7.1 # numeric match" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/v7.1)"
  assert_equal "${output}" "7.1.1-nightly201611093daf11635d"
}

@test "n lsr nightly/v6.10.3-nightly2017040479546c0b5a # exact" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/v6.10.3-nightly2017040479546c0b5a)"
  assert_equal "${output}" "6.10.3-nightly2017040479546c0b5a"
}
