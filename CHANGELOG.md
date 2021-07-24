# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- markdownlint-disable MD024 -->

## [7.3.1] (2021-07-25)

### Changed

- Improved README for new users missing expected folders in `/usr/local` ([#679])

## [7.3.0] (2021-06-06)

### Added

- ls-remote supports `engine` and `auto` labels ([#675])
- reduce `engine` and `auto` logging with `--quiet` ([#675])
- add WSL support to README ([#676])
- support for Emacs up and down keys (`ctrl-p` and `ctrl-n`) ([#669])

### Changed

- diagnostic logging during processing of engine and auto written to stderr rather than stdout ([#675])

## [7.2.2] (2021-04-25)

### Fixed

- arrow key navigation of version menu when terminal in application mode (e.g. PowerShell on Mac) ([#668])

## [7.2.1] (2021-04-19)

### Added

- install native arm64 Node.js on Macs with Apple silicon for Node.js 16 and higher ([#664])

## [7.2.0] (2021-04-19) [YANKED]

Released off wrong branch, essentially same as 7.1.0.

## [7.1.0] (2021-03-12)

### Added

- support installs where /usr/local/share/man is a symlink (such as archlinux)
- remove requirement for rsync for --preserve
- avoid install pollution if user installs global packages when using n exec

## [7.0.2] (2021-02-27)

### Fixed

- consistently log to STDOUT ([#654])

## [7.0.1] (2021-01-30)

### Changed

- update bats, and use bats-assert for better unit test failure messages

### Fixed

- fail to display error in some cases for missing both `curl` and `wget` ([#649])

## [7.0.0] (2020-12-20)

### Changed

- `auto` label now scans for `package.json` only if it can not find a version control file ([#644])

### Added

- `engine` label to look for `engines.node` in `package.json` (as used by`auto`) ([#644])
- 
### Fixed

- avoid colorized grep output via `GREP_OPTIONS` breaking version lookup ([#643])

## [6.8.0] (2020-12-12)

### Fixed

- suppress unwanted warning during `auto` when using npx with npm 7
- temporary fix for installing on Mac with Apple M1 chip, look for x64 versions of node as arm64 not available yet

## [6.7.1] (2020-11-25)

### Fixed

- detect and handle a failed download of full archive ([#635])

## [6.7.0] (2020-07-25)

### Added

- `auto` support for:
    - `.node-version`
    - `.nvmrc`
    - `engines` field of `package.json`

## [6.6.0] (2020-07-04)

### Added

- labels for node support aliases, such as `lts_latest`

### Fixed

- Enable `xz` support by default for macOS 11+ ([#624])

## [6.5.1] (2020-04-11)

### Added

- specify `auto` to read the target version from a `.n-node-version` file (i.e. change filename)

## [6.5.0] (2020-04-11) [YANKED]

### Added

- specify `auto` to read the target version from a `.node-version` file ([#616])

## [6.4.0] (2020-03-10)

### Added

- treat `armv8l` as `arm64` ([#614])

## [6.3.1] (2020-02-25)

### Fixed

- remove old version of node before copy to avoid firewall issues on macOS ([#394])

## [6.3.0] (2020-02-24)

### Added

- `--preserve` to preserve npm and npx during install of node ([#587])

## [6.2.0] (2020-01-29)

### Added

- Downloads now default to using tarballs compressed by `xz` over `gzip`, if `xz` support detected. ([#606] [#607])

## [6.1.3] (2019-11-23)

### Added

- added How It Works to README

### Changed

- simplified layout for `n doctor` output

## [6.1.2] (2019-11-16)

### Added

- advice to reset command hash when node location changes ([#170] [#381] [#451] [#588])
- in README describe raw download of `n` to bootstrap install of node and npm

## [6.1.1] (2019-11-10)

### Fixed

- Specify `--no-same-owner` for tarball extraction so cache files not owned by unexpected user (when run with sudo) ([#593])

## [6.1.0] (2019-10-25)

### Added

- deletion of cached versions from menu using 'd' ([#590])

## [6.0.1] (2019-08-20)

### Fixed

- allow options to come after commands, especially `n lsr --all`

## [6.0.0] (2019-08-16)

### Added

- version specified using release stream codenames, like `argon` ([#423])
- version specified using nightly et al ([#376])
- `n exec` for running arbitrary command with node and npm in `PATH` ([#185])
- `n run` with legacy aliases of `as` and `use`
- `n lsr` for listing matching remote versions, limited to 20 by default ([#383])
- `n doctor` for displaying diagnostic information
- `n install` for people used to other products with this command ([#524])
- `--insecure` to disable curl/wget certificate checks
- added npm version to installed message ([#210] [#484] [#574])
  
### Changed

- **Breaking** wget now checks certificates (secure by default, same as curl setup). (#475 #509)
- failure messages go to stderr instead of stdout
- prefixed `N_NODE_MIRROR` to eventually replace `NODE_MIRROR`
- **Breaking** `n ls` now lists local download versions (rather than remote versions)
- lookup available versions using `index.tab` rather than screen-scraping (#560)

### Fixed

- download errors display informative message, instead of just `Invalid version` ([#482] [#492] et al)
- improve reliability of downloads from custom node mirrors, including removing broken `is_oss_ok` ([#560])
- restrict downloads to versions with architecture available ([#463])

### Removed

- **Breaking** support for `PROJECT_NAME` and `PROJECT_URL` for custom downloads ([#342])

## [5.0.2] (2019-08-02)

### Added

- instructions to bottom of menu version selection

## [5.0.1] (2019-07-20)

### Changed

- removed reference to prerelease version of v5.0.0 from README

## [5.0.0] (2019-07-20)

### Added

- log message after install from cache (previously silent)
- extra logging after install if the active and installed node locations are different
- support for [NO_COLOR](https://no-color.org) and [CLICOLOR=0](https://bixense.com/clicolors)
- suppress progress and colour if not interactive tty
- define `N_USE_XZ` to download `.xz` compressed archives instead of `.gz` archives
  
### Changed

- reinstalling active node version always does reinstall (previously silently did nothing)
- log message for installing using menu now same format as `npm install` message
- updates to GitHub templates and guidelines for contributing et al

## [4.1.0] (2019-05-10)

### Added

- 'n uninstall` to remove node and npm
- describe `NODE_MIRROR` in `README`

### Removed

- `PROJECT_NAME` and `PROJECT_URL` from `README`. First step to deprecating `n project`. Open an issue if you still need this!

## [4.0.0] (2019-05-05)

Only minor functional changes, but technically could break scripts relying on specific behaviour.

### Fixed

- remove trailing space from `bin` output [#456]

### Added

- development tests [#545]

### Changed

- internal: improve shell script based on ShellCheck suggestions, quoting variables use etc [#187] [#465]
- put single quote marks around parameters to clarify error messages [#485]
- update terminology to be more careful with current/latest [#522]

## [3.0.2] (2019-04-07)

### Added

- instructions to avoid need for `sudo` when installing to `/usr/local`  [#416] [#562]

### Fixed

- permission denied errors when running read-only commands without sudo [#416]

## [3.0.1] (2019-04-05)

### Added

- install instruction using Homebrew (macOS) [#534]
- Table of Contents to README [#466]

### Fixed

- lts lookup on node mirrors which don't purge old versions (e.g. taobao) [#512]
- hide cursor while selecting version from menu [#528]

### Removed

- gitter badge from README, as gitter chatroom inactive
- inactive Core Team from README
- instructions for scripted install of npm from README, which should no longer be needed and not working on Mac [#536]

## [3.0.0] (2019-03-29)

### Added

- detect arm64 architecture [#448][] [#521][]

### Changed

- allow `n rm` of active version of node [#541][] [#169][] [#327][] [#441][]
- show more version examples in README, including partial version number [#548][]
- updated description of interactive version selection [#518][]
- make (old) stable an alias for lts [#467][] [#335][]
- replace use of `which` with more standard `command -v` [#532][]

### Fixed

- error messages when selecting from version menu if active node version not listed [#541][] [#292][] [#367][] [#391][] [#400][]
- removed inappropriate `shift` from prune function [#531][] [#529][]

### Removed

- Remove old io project support [#516][] [#331][]

<!-- reference links for issues and pull requests -->

[#169]: https://github.com/tj/n/issues/169
[#170]: https://github.com/tj/n/issues/170
[#185]: https://github.com/tj/n/issues/185
[#187]: https://github.com/tj/n/issues/187
[#210]: https://github.com/tj/n/issues/210
[#292]: https://github.com/tj/n/issues/292
[#327]: https://github.com/tj/n/issues/327
[#331]: https://github.com/tj/n/issues/331
[#335]: https://github.com/tj/n/issues/335
[#342]: https://github.com/tj/n/issues/342
[#367]: https://github.com/tj/n/issues/367
[#376]: https://github.com/tj/n/issues/376
[#381]: https://github.com/tj/n/issues/381
[#383]: https://github.com/tj/n/issues/383
[#391]: https://github.com/tj/n/issues/391
[#394]: https://github.com/tj/n/issues/394
[#400]: https://github.com/tj/n/issues/400
[#416]: https://github.com/tj/n/issues/416
[#423]: https://github.com/tj/n/issues/423
[#441]: https://github.com/tj/n/issues/441
[#448]: https://github.com/tj/n/issues/448
[#451]: https://github.com/tj/n/issues/451
[#456]: https://github.com/tj/n/issues/456
[#463]: https://github.com/tj/n/issues/463
[#465]: https://github.com/tj/n/issues/465
[#466]: https://github.com/tj/n/issues/466
[#467]: https://github.com/tj/n/issues/467
[#482]: https://github.com/tj/n/issues/482
[#484]: https://github.com/tj/n/issues/484
[#485]: https://github.com/tj/n/issues/485
[#492]: https://github.com/tj/n/issues/492
[#512]: https://github.com/tj/n/issues/512
[#516]: https://github.com/tj/n/issues/516
[#518]: https://github.com/tj/n/issues/518
[#521]: https://github.com/tj/n/issues/521
[#522]: https://github.com/tj/n/issues/522
[#524]: https://github.com/tj/n/issues/524
[#528]: https://github.com/tj/n/issues/528
[#529]: https://github.com/tj/n/issues/529
[#531]: https://github.com/tj/n/issues/531
[#532]: https://github.com/tj/n/issues/532
[#534]: https://github.com/tj/n/issues/534
[#536]: https://github.com/tj/n/issues/536
[#541]: https://github.com/tj/n/issues/541
[#545]: https://github.com/tj/n/issues/545
[#548]: https://github.com/tj/n/issues/548
[#560]: https://github.com/tj/n/issues/560
[#562]: https://github.com/tj/n/issues/562
[#574]: https://github.com/tj/n/issues/574
[#587]: https://github.com/tj/n/issues/587
[#588]: https://github.com/tj/n/issues/588
[#590]: https://github.com/tj/n/issues/590
[#593]: https://github.com/tj/n/issues/593
[#606]: https://github.com/tj/n/issues/606
[#607]: https://github.com/tj/n/issues/607
[#614]: https://github.com/tj/n/issues/614
[#616]: https://github.com/tj/n/issues/616
[#624]: https://github.com/tj/n/issues/624
[#635]: https://github.com/tj/n/pull/635
[#643]: https://github.com/tj/n/pull/643
[#644]: https://github.com/tj/n/pull/644
[#649]: https://github.com/tj/n/issues/649
[#654]: https://github.com/tj/n/issues/654
[#664]: https://github.com/tj/n/pull/664
[#668]: https://github.com/tj/n/pull/668
[#669]: https://github.com/tj/n/pull/669
[#675]: https://github.com/tj/n/pull/675
[#676]: https://github.com/tj/n/pull/676
[#679]: https://github.com/tj/n/issues/679

<!-- reference links for releases -->

[Unreleased]: https://github.com/tj/n/compare/master...develop
[7.3.1]: https://github.com/tj/n/compare/v7.3.0...v7.3.1
[7.3.0]: https://github.com/tj/n/compare/v7.2.2...v7.3.0
[7.2.2]: https://github.com/tj/n/compare/v7.2.1...v7.2.2
[7.2.1]: https://github.com/tj/n/compare/v7.1.0...v7.2.1
[7.2.0]: https://github.com/tj/n/compare/v7.1.0...v7.2.0
[7.1.0]: https://github.com/tj/n/compare/v7.0.2...v7.1.0
[7.0.2]: https://github.com/tj/n/compare/v7.0.1...v7.0.2
[7.0.1]: https://github.com/tj/n/compare/v7.0.0...v7.0.1
[7.0.0]: https://github.com/tj/n/compare/v6.8.0...v7.0.0
[6.8.0]: https://github.com/tj/n/compare/v6.7.1...v6.8.0
[6.7.1]: https://github.com/tj/n/compare/v6.7.0...v6.7.1
[6.7.0]: https://github.com/tj/n/compare/v6.6.0...v6.7.0
[6.6.0]: https://github.com/tj/n/compare/v6.5.1...v6.6.0
[6.5.1]: https://github.com/tj/n/compare/v6.5.0...v6.5.1
[6.5.0]: https://github.com/tj/n/compare/v6.4.0...v6.5.0
[6.4.0]: https://github.com/tj/n/compare/v6.3.1...v6.4.0
[6.3.1]: https://github.com/tj/n/compare/v6.3.0...v6.3.1
[6.3.0]: https://github.com/tj/n/compare/v6.2.0...v6.3.0
[6.2.0]: https://github.com/tj/n/compare/v6.1.3...v6.2.0
[6.1.3]: https://github.com/tj/n/compare/v6.0.2...v6.1.3
[6.1.2]: https://github.com/tj/n/compare/v6.0.1...v6.1.2
[6.1.1]: https://github.com/tj/n/compare/v6.0.0...v6.1.1
[6.1.0]: https://github.com/tj/n/compare/v6.0.1...v6.1.0
[6.0.1]: https://github.com/tj/n/compare/v6.0.0...v6.0.1
[6.0.0]: https://github.com/tj/n/compare/v5.0.2...v6.0.0
[5.0.2]: https://github.com/tj/n/compare/v5.0.1...v5.0.2
[5.0.1]: https://github.com/tj/n/compare/v5.0.0...v5.0.1
[5.0.0]: https://github.com/tj/n/compare/v4.1.0...v5.0.0
[4.1.0]: https://github.com/tj/n/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/tj/n/compare/v3.0.2...v4.0.0
[3.0.2]: https://github.com/tj/n/compare/v3.0.1...v3.0.2
[3.0.1]: https://github.com/tj/n/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/tj/n/compare/v2.1.12...v3.0.0
