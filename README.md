# `n` – Interactively Manage Your Node.js Versions

[![npm](https://img.shields.io/npm/dt/n.svg?style=flat-square)](https://www.npmjs.com/package/n)
[![npm](https://img.shields.io/npm/dm/n.svg?style=flat-square)](https://www.npmjs.com/package/n)
[![npm](https://img.shields.io/npm/v/n.svg?style=flat-square)](https://www.npmjs.com/package/n)
[![npm](https://img.shields.io/npm/l/n.svg?style=flat-square)](https://www.npmjs.com/package/n)

Node.js version management: no subshells, no profile setup, no convoluted API, just **simple**.

![usage animation](http://nimit.io/images/n/n.gif)

(Note: `n` is not supported natively on Windows.)

- [`n` – Interactively Manage Your Node.js Versions](#n-%e2%80%93-interactively-manage-your-nodejs-versions)
    - [Installation](#installation)
        - [Third Party Installers](#third-party-installers)
    - [Installing Node Versions](#installing-node-versions)
    - [Specifying Node Versions](#specifying-node-versions)
    - [Removing Versions](#removing-versions)
    - [Using Downloaded Node Versions Without Reinstalling](#using-downloaded-node-versions-without-reinstalling)
    - [Preserving npm](#preserving-npm)
    - [Miscellaneous](#miscellaneous)
    - [Custom Source](#custom-source)
    - [Custom Architecture](#custom-architecture)
    - [Optional Environment Variables](#optional-environment-variables)
    - [How It Works](#how-it-works)

## Installation

Since you probably already have `node`, the easiest way to install `n` is through `npm`:

    npm install -g n

Once installed, `n` caches `node` versions in subdirectory `n/versions` of the directory specified in environment variable `N_PREFIX`, which defaults to `/usr/local`; and the _active_ `node` version is installed directly in `N_PREFIX`.

To avoid requiring `sudo` for `n` and `npm` global installs, it is suggested you either install to your home directory using `N_PREFIX`, or take ownership of the system directories:

    # make cache folder (if missing) and take ownership
    sudo mkdir -p /usr/local/n
    sudo chown -R $(whoami) /usr/local/n
    # take ownership of node install destination folders
    sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share

-----

If `npm` is not yet available, one way to bootstrap an install:

    curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
    bash n lts
    # Now node and npm are available

Alternatively, you can clone this repo and

    make install

to install `n` to `bin/n` of the directory specified in the environment variable `$PREFIX`, which defaults to `/usr/local` (note that you will likely need to use `sudo`). To install `n` in a custom location (such as `$CUSTOM_LOCATION/bin/n`), run `PREFIX=$CUSTOM_LOCATION make install`.

### Third Party Installers

On macOS with [Homebrew](https://brew.sh/) you can install the [n formula](https://github.com/Homebrew/homebrew-core/blob/master/Formula/n.rb).

    brew install n

On Linux and macOS, [n-install](https://github.com/mklement0/n-install) allows installation directly from GitHub; for instance:

    curl -L https://git.io/n-install | bash

n-install sets both `PREFIX` and `N_PREFIX` to `$HOME/n`, installs `n` to `$HOME/n/bin`, modifies the initialization files of supported shells to export `N_PREFIX` and add `$HOME/n/bin` to the `PATH`, and installs the latest LTS `node` version.

As a result, both `n` itself and all `node` versions it manages are hosted inside a single, optionally configurable directory, which you can later remove with the included `n-uninstall` script. `n-update` updates `n` itself to the latest version. See the [n-install repo](https://github.com/mklement0/n-install) for more details.

## Installing Node Versions

Simply execute `n <version>` to download and install a version of `node`. If `<version>` has already been downloaded, `n` will install from its cache.

    n 10.16.0
    n lts

Execute `n` on its own to view your downloaded versions, and install the selected version.

    $ n

      node/4.9.1
    ο node/8.11.3
      node/10.15.0

    Use up/down arrow keys to select a version, return key to install, d to delete, q to quit

(You can also use `j` and `k` to navigate up or down without using arrows.)

If the active node version does not change after install, try opening a new shell in case seeing a stale version.

## Specifying Node Versions

There are a variety of ways of specifying the target node version for `n` commands. Most commands use the latest matching version, and  `n ls-remote` lists multiple matching versions.

Numeric version numbers can be complete or incomplete, with an optional leading `v`.

- `4.9.1`
- `8`: 8.x.y versions
- `v6.1`: 6.1.x versions

There are labels for two especially useful versions:

- `lts`: newest Long Term Support official release
- `latest`, `current`: newest official release

There is support for release streams:

- `argon`, `boron`, `carbon`: codenames for LTS release streams

The last form is for specifying [other releases](https://nodejs.org/download) available using the name of the remote download folder optionally followed by the complete or incomplete version.

- `chakracore-release/latest`
- `nightly`
- `test/v11.0.0-test20180528`
- `rc/10`

## Removing Versions

Remove some cached versions:

    n rm 0.9.4 v0.10.0

Removing all cached versions except the current version:

    n prune

Remove the installed node and npm (does not affect the cached version). This can be useful
to revert to the system version of node (if in a different location), or if you no longer
wish to use node and npm, or are switching to a different way of managing them.

    n uninstall

## Using Downloaded Node Versions Without Reinstalling

There are three commands for working directly with your downloaded versions of `node`, without reinstalling.

You can show the path to the downloaded version:

    $ n which 6.14.3
    /usr/local/n/versions/6.14.3/bin/node

Or run a downloaded `node` version with the `n run` command:

    n run 8.11.3 --debug some.js

Or execute a command with `PATH` modified so `node` and `npm` will be from the downloaded `node` version.
(NB: this `npm` will be working with a different and empty global node_modules directory, and you should not install global
modules this way.)

    n exec 10 my-script --fast test

## Preserving npm

A `node` install normally includes `npm` as well, but you may wish to preserve an updated `npm` and `npx` leaving them out of the install using `--preserve` (requires rsync):

    $ npm install -g npm@latest
    ...
    $ npm --version
    6.13.7
    $ n -p 8
       installed : v8.17.0
    $ npm --version
    6.13.7

You can make this the default by setting `N_PRESERVE_NPM` to a non-empty string.

    export N_PRESERVE_NPM=1

You can be explicit to get the desired behaviour whatever the environment variable:

    n --preserve nightly
    n --no-preserve latest

## Miscellaneous

Command line help can be obtained from `n --help`.

List matching remote versions available for download:

    n ls-remote lts
    n ls-remote latest
    n lsr 10
    n --all lsr

List downloaded versions in cache:

    n ls

Display diagnostics to help resolve problems:

    n doctor

## Custom Source

If you would like to use a different node mirror which has the same layout as the default <https://nodejs.org/dist/>, you can define `N_NODE_MIRROR`.
The most common example is users in China can define:

    export N_NODE_MIRROR=https://npm.taobao.org/mirrors/node

There is also `N_NODE_DOWNLOAD_MIRROR` for a different mirror with same layout as the default <https://nodejs.org/download>

## Custom Architecture

By default `n` picks the binaries matching your system architecture, e.g. `n` will download 64 bit binaries for a 64 bit system. You can override this by using the `-a` or `--arch` option.

Download and use latest 32 bit version of `node`:

    n --arch x86 latest

## Optional Environment Variables

The `n` command downloads and installs to `/usr/local` by default, but you may override this location by defining `N_PREFIX`.
To change the location to say `$HOME/.n`, add lines like the following to your shell initialization file:

    export N_PREFIX=$HOME/.n
    export PATH=$N_PREFIX/bin:$PATH

`n` defaults to using xz compressed node tarballs for the download if it is likely tar on the system supports xz decompression.
You can override the automatic choice by setting an environment variable to zero or non-zero:

    export N_USE_XZ=0 # to disable
    export N_USE_XZ=1 # to enable

You can be explicit to get the desired behaviour whatever the environment variable:

    n install --use-xz nightly
    n install --no-use-xz latest

In brief:

- `N_NODE_MIRROR`: See [Custom source](#custom-source)
- `N_NODE_DOWNLOAD_MIRROR`: See [Custom source](#custom-source)
- support for [NO_COLOR](http://no-color.org) and [CLICOLOR=0](https://bixense.com/clicolors) for controlling use of ANSI color codes
- `N_MAX_REMOTE_MATCHES` to change the default `ls-remote` maximum of 20 matching versions
- `N_PRESERVE_NPM`: See [Preserving npm](#preserving-npm)

## How It Works

`n` downloads a prebuilt `node` package and installs to a single prefix (e.g. `/usr/local`). This overwrites the previous version. The `bin` folder in this location should be in your `PATH` (e.g. `/usr/local/bin`).

The downloads are kept in a cache folder to be used for reinstalls. The downloads are also available for limited use using `n which` and `n run` and `n exec`.

The global `npm` packages are not changed by the install, with the
exception of `npm` itself which is part of the `node` install.
