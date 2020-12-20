#!/usr/bin/env bats

load shared-functions


function setup() {
  unset_n_env
}


# labels

@test "n lsr lts" {
  output="$(n lsr lts)"
  [ "${output}" = "$(display_remote_version lts)" ]
}

@test "n lsr stable" {
  output="$(n lsr lts)"
  [ "${output}" = "$(display_remote_version lts)" ]
}

@test "n ls-remote latest" {
  output="$(n ls-remote latest)"
  [ "${output}" = "$(display_remote_version latest)" ]
}

@test "n list-remote current" {
  output="$(n list-remote current)"
  [ "${output}" = "$(display_remote_version latest)" ]
}


# codenames

@test "n=1 n lsr argon" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr argon)"
  [ "${output}" = "4.9.1" ]
}

@test "n=1 n lsr Argon # case" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr Argon)"
  [ "${output}" = "4.9.1" ]
}


# numeric versions

@test "n=1 n lsr 4" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr 4)"
  [ "${output}" = "4.9.1" ]
}

@test "n=1 n lsr v4" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr v4)"
  [ "${output}" = "4.9.1" ]
}

@test "n=1 n lsr 4.9" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr 4.9)"
  [ "${output}" = "4.9.1" ]
}

@test "n=1 n lsr 4.9.1" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr 4.9.1)"
  [ "${output}" = "4.9.1" ]
}

@test "n=1 n lsr v4.9.1" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr v4.9.1)"
  [ "${output}" = "4.9.1" ]
}

@test "n lsr 6.2 # multiple matches with header" {
  run n lsr 6.2
  [ "${status}" -eq "0" ]
  [ "${lines[0]}" = "Listing remote... Displaying 20 matches (use --all to see all)." ]
  [ "${lines[1]}" = "6.2.2" ]
  [ "${lines[2]}" = "6.2.1" ]
  [ "${lines[3]}" = "6.2.0" ]
  [ "${lines[4]}" = "" ]
}

@test "n=1 n lsr --all 6.2 # --all, multiple matches with no header" {
  N_MAX_REMOTE_MATCHES=1 run n --all lsr 6.2
  [ "${status}" -eq "0" ]
  [ "${lines[0]}" = "6.2.2" ]
  [ "${lines[1]}" = "6.2.1" ]
  [ "${lines[2]}" = "6.2.0" ]
  [ "${lines[3]}" = "" ]
}

# Checking does not match 8.11
@test "n=1 n lsr v8.1 # numeric match" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr v8.1)"
  [ "${output}" = "8.1.4" ]
}


# Nightly

@test "n=1 n lsr nightly" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly)"
  [ "${output}" = "$(display_remote_version nightly)" ]
}

@test "n=1 n lsr nightly/" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/)"
  [ "${output}" = "$(display_remote_version nightly)" ]
}

@test "n=1 n lsr nightly/latest" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/latest)"
  [ "${output}" = "$(display_remote_version nightly)" ]
}

@test "n=1 n lsr nightly/v10.8.1-nightly201808 # partial match" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/v10.8.1-nightly201808)"
  [ "${output}" = "10.8.1-nightly2018081382830a809b" ]
}

# Numeric match should not find v7.10.1-nightly2017050369a8053e8a
@test "n=1 n lsr nightly/7.1 # numeric match" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/7.1)"
  [ "${output}" = "7.1.1-nightly201611093daf11635d" ]
}

# Numeric match should not find v7.10.1-nightly2017050369a8053e8a
@test "n=1 n lsr nightly/v7.1 # numeric match" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/v7.1)"
  [ "${output}" = "7.1.1-nightly201611093daf11635d" ]
}

@test "n lsr nightly/v6.10.3-nightly2017040479546c0b5a # exact" {
  output="$(N_MAX_REMOTE_MATCHES=1 n lsr nightly/v6.10.3-nightly2017040479546c0b5a)"
  [ "${output}" = "6.10.3-nightly2017040479546c0b5a" ]
}
