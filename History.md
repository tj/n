
1.2.0 / 2014-01-30
==================

 * fix: #! to use bash
 * fix: handle `Permission denied` for `mkdir`

1.1.0 / 2013-07-10
==================

 * add: resolve version with one dot (`n 0.8` etc)
 * fix: interactive listing sort
 * fix: abort gracefully if no installed version
 * fix: `n prev`

1.0.0 / 2013-06-26
==================

 * Use -R when activating. Fixes #118
 * Use command -v instead of `which`
 * Add RPI support, fix visionmedia/n#108

0.9.3 / 2013-03-12
==================

  * use [0-9] instead of \d in regex for better compatibility (see #105) [atuttle]

0.9.2 / 2013-03-12
==================

  * fix version number in `n`

0.9.1 / 2013-01-21
==================

  * filter out versions that lack binaries (see #95) [mattrobenolt]
  * quote `uname -s` to solve issue on Ubuntu 12.04 [nw]

0.9.0 / 2013-01-19
==================

  * add up/down arrows for navigating installed version selection

0.8.2 / 2013-01-18
==================

  * add back support for "v" prefix on install
  * add `n prev` to revert to previously selected version

0.8.1 / 2013-01-18
==================

  * add activation when already installed

0.8.0 / 2013-01-18
==================

  * rewrite

0.7.3 / 2012-07-13
==================

  * use cp -fR to preserve npm symlink

0.7.2 / 2012-06-14
==================

  * removed trailing dot on cp command. fixes #48 [sreuter]
  * add 'homepage' and 'bugs' sections to package.json [TooTallNate]

0.7.1 / 2012-03-14
==================

  * Changed: copy all bins. Closes #47

0.7.0 / 2012-02-21
==================

  * Adding `--stable` only option [tomgallacher]

0.6.1 / 2012-01-26
==================

  * Fixed control character sequence for Linux compatibility [darrenderidder]

0.6.0 / 2012-01-26
==================

  * Added support for installing node with a tarball [dshaw]
  * Fixed: swap echo for printf. closes #44
  * Fixed log colors

0.5.4 / 2011-11-05
==================

  * Fixed install >= 0.5.x [guybrush]

0.5.3 / 2011-11-04
==================

  * Fixed issue when prefix/lib/node dir is not present. Closes #37

0.5.2 / 2011-10-14
==================

  * Fixed check_current_version() when node is not present

0.5.1 / 2011-10-11
==================

  * Fixed newer 0.5.x versions
  * Fixed node-waf [guybrush]

0.4.2 / 2011-06-28
==================

  * Fixed stdio redirect for lame bash

0.4.1 / 2011-03-13
==================

  * Fixed bad substitution errors on ubuntu [Alexander Simmerl]

0.4.0 / 2011-02-14
==================

  * Added `n ls|list` to show versions available
  * Added markers to installed and current versions for `n ls` [davglass]
  * Added `--no-check-certificate` for Github Downloads [davglass]
  * Fixed; moved abort and log up, so they are defined before calling [davglass]
  * Improved error message when tar fails (usually due to invalid version number) [davglass]

0.3.0 / 2011-01-21
==================

  * Added `n latest` to install (or activate) latest node version released
  * Added `n --latest` to output latest node version released
  * Fixed wafadmin issue, installing lib/node/*. Closes #7

0.2.2 / 2011-01-21
==================

  * Fixed escape

0.2.1 / 2011-01-21
==================

  * Installing `node-waf`. Closes #5

0.2.0 / 2011-01-20
==================

  * Added; display config options when using `n`.
    For example if you install via `n 0.3.5 --debug`,
    then `n` will display `0.3.5 --debug`.

  * Changed; `n <version>` ignores non-n installations

0.1.2 / 2011-01-20
==================

  * Added `help` alias of `--help`
  * Fixed bash specific substitutions. Closes #1

0.1.1 / 2011-01-13
==================

  * Fixed `use` with invalid version, added "is not installed"

0.1.0 / 2011-01-05
==================

  * Added `n as <version> [args ...]`

0.0.4 / 2011-01-05
==================

  * Added `which` alias of `bin`

0.0.3 / 2011-01-05
==================

  * Added `n bin <version>` command

0.0.2 / 2011-01-05
==================

  * Added `-` alias of `rm`

0.0.1 / 2011-01-05
==================

  * Initial release
