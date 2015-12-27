# n

[![Join the chat at https://gitter.im/tj/n](https://img.shields.io/gitter/room/tj/n.svg?style=flat-square)](https://gitter.im/tj/n)
[![npm](https://img.shields.io/npm/dt/n.svg?style=flat-square)](https://www.npmjs.com/package/n)
[![npm](https://img.shields.io/npm/dm/n.svg?style=flat-square)](https://www.npmjs.com/package/n)
[![npm](https://img.shields.io/npm/v/n.svg?style=flat-square)](https://www.npmjs.com/package/n)
[![npm](https://img.shields.io/npm/l/n.svg?style=flat-square)](https://www.npmjs.com/package/n)

Simple flavour of node/iojs binary management, no subshells, no profile setup, no convoluted api, just _simple_.

*Note: Does not work on Windows at the moment. Pull Requests are appreciated.*
*If you are searching for the latest version below 2.x.x, check out the branch "1.x.x"*

 ![](https://i.cloudup.com/59cA8VEDae.gif)

## Installation

With node/iojs already installed:

    $ npm install -g n

or, by cloning this repo and running:

    $ make install

to install `n` to subdirectory `bin/n` of the directory specified in environment variable `PREFIX`, which defaults to `/usr/local` (note that you will likely need `sudo` to install there).  
To change the default to, say, `$HOME`, i.e., to install `n` to `$HOME/bin/n`, run `PREFIX=$HOME make install`.  

Once installed, `n` downloads node/iojs versions to subdirectory `n/versions` of the directory specified in environment variable `N_PREFIX`, which defaults to `/usr/local`; the _active_ node/iojs version is installed directly in `N_PREFIX`.  
To change the default to, say, `$HOME`, prefix later calls to `n` with `N_PREFIX=$HOME ` or add `export N_PREFIX=$HOME` to your shell initialization file.

Alternatively, consider third-party installer [n-install](https://github.com/mklement0/n-install), which allows installation directly from GitHub; for instance,

    curl -L http://git.io/n-install | bash

sets both `PREFIX` and `N_PREFIX` to `$HOME/n`, installs `n` to `$HOME/n/bin`, modifies the initialization files of supported shells to export `N_PREFIX` and add `$HOME/n/bin` to the `PATH`, and installs the latest stable node version.  
As a result, both `n` itself and all node/iojs versions it manages are hosted inside a single, optionally configurable directory, which you can later remove with the included `n-uninstall` script; script `n-update` updates `n` itself to the latest version - see the [n-install repo](https://github.com/mklement0/n-install) for details.

### Installing Binaries

Install a few nodes:

    $ n 0.8.14
    $ n 0.8.17
    $ n 0.9.6

Type `n` to prompt selection of an installed node. Use the up /
down arrow to navigate, and press enter or the right arrow to
select, or ^C to cancel:

    $ n

      0.8.14
    ο 0.8.17
      0.9.6

Use or install the latest official release:

    $ n latest

Use or install the stable official release:

    $ n stable

Use or install the latest LTS official release:

    $ n lts

### Removing Binaries

Remove some versions:

    $ n rm 0.9.4 v0.10.0

Instead of using `rm` we can simply use `-`:

    $ n - 0.9.4

### Binary Usage

When running multiple versions of node, we can target
them directly by asking `n` for the binary path:

    $ n bin 0.9.4
    /usr/local/n/versions/0.9.4/bin/node

Or by using a specific version through `n`'s `use` sub-command:

    $ n use 0.9.4 some.js

with flags:

    $ n as 0.9.4 --debug some.js

## Usage

 Output from `n --help`:

    Usage: n [options/env] [COMMAND] [args]

    Environments:
     n [COMMAND] [args]            Uses default env (node)
     n io [COMMAND]                Sets env as io

    Commands:

      n                              Output versions installed
      n latest                       Install or activate the latest node release
      n -a x86 latest                As above but force 32 bit architecture
      n stable                       Install or activate the latest stable node release
      n lts                          Install or activate the latest LTS node release
      n <version>                    Install node <version>
      n use <version> [args ...]     Execute node <version> with [args ...]
      n bin <version>                Output bin path for <version>
      n rm <version ...>             Remove the given version(s)
      n --latest                     Output the latest node version available
      n --stable                     Output the latest stable node version available
      n --lts                        Output the latest LTS node version available
      n ls                           Output the versions of node available

    (iojs):

      n io latest                    Install or activate the latest iojs release
      n io -a x86 latest             As above but force 32 bit architecture
      n io <version>                 Install iojs <version>
      n io use <version> [args ...]  Execute iojs <version> with [args ...]
      n io bin <version>             Output bin path for <version>
      n io rm <version ...>          Remove the given version(s)
      n io --latest                  Output the latest iojs version available
      n io ls                        Output the versions of iojs available

    Options:

      -V, --version   Output current version of n
      -h, --help      Display help information
      -q, --quiet     Disable curl output (if available)
      -d, --download  Download only
      -a, --arch      Override system architecture

    Aliases:

      which   bin
      use     as
      list    ls
      -       rm

## Custom source

If you would like to use a project other than the official Node.js or io.js projects, you can use the special `n project [command]` which allows you to control the behavior of `n` using environment variables.

Example:

To grab the latest io.js version but name it "foo" instead,

      PROJECT_NAME="foo" PROJECT_URL="https://iojs.org/dist/" n project latest

Required Variables:

* `PROJECT_NAME`: The name the project will be stored under
* `PROJECT_URL`: The location to download the project from. Note, this must follow the same format as the io.js/Node.js repos

Optional Variables:

* `HTTP_USER`: The username if the `PROJECT_URL` is protected by basic authentication
* `HTTP_PASSWORD`: The password if the `PROJECT_URL` is protected by basic authentication
* `PROJECT_VERSION_CHECK`: Many custom projects keep the same version number as the Node.js release they are based on, and maintain their own separate version in process. This allows you to define a JavaScript variable that will be used to check for the version of the process, for example: `process.versions.node`

## Custom architecture

By default `n` picks the binaries matching your system architecture, e.g. `n` will download 64 bit binaries for a 64 bit system. You can override this by using the `-a` or `--arch` option.

Download and use latest 32 bit version of node:

    $ n --arch x86 latest

Download and use latest 32 bit version of iojs:

    $ n io --arch x86 latest


## Details

 `n` by default installs node to _/usr/local/n/versions_, from
 which it can see what you have currently installed, and activate previously installed versions of node when `n <version>` is invoked again.

 Activated nodes are then installed to the prefix _/usr/local_, which of course may be altered via the __N_PREFIX__ environment variable.

 To alter where `n` operates simply export __N_PREFIX__ to whatever you prefer.

## License

(The MIT License)

Copyright (c) 2014 TJ Holowaychuk &lt;tj@vision-media.ca&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
