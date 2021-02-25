# Tests

Automated tests for `n`.

## Setup

Optional proxy using mitmproxy:

    # using homebrew (Mac) to install mitmproxy
    brew install mitmproxy


## Running Tests

Run all the tests across a range of containers and on the host system:

    npm run test

Run all the tests on a single system:

    cd test
    npx bats tests
    docker-compose run ubuntu-curl bats /mnt/test/tests

Run single test on a single system::

    cd test
    npx bats tests/install-contents.bats
    docker-compose run ubuntu-curl bats /mnt/test/tests/install-contents.bats

## Proxy

To speed up running tests multiple times, you can optionally run a caching proxy for the node downloads. The curl settings are modified
to allow an insecure connection through the mitm proxy.

    cd test
    bin/proxy-build
    bin/proxy-run
    # follow the instructions for configuring environment variables for using proxy, then run tests

`node` versions added to proxy cache (and used in tests):

* v4.9.1
* lts
* latest

## Docker Tips

Using `docker-compose` in addition to `docker` for convenient mounting of `n` script and the tests into the container. Changes to the tests or to `n` itself are reflected immediately without needing to rebuild the containers.

`bats` is being mounted directly out of `node_modules` into the container as a manual install based on its own install script. This is a bit of a hack, but avoids needing to install `git` or `npm` for a full remote install of `bats`, and means everything on the same version of `bats`.

The containers each have:

* either curl or wget (or both) installed

Using `docker-compose` to run the container adds:

* specified `n` script mounted to `/usr/local/bin/n`
* `test/tests` mounted to `/mnt/test/tests`
* `node_modules/bats` provides `/usr/local/bin/bats` et al
* `.curlrc` with `--insecure` to allow use of proxy

So for example:

    cd test
    docker-compose run ubuntu-curl
      # in container
      n --version
      bats /mnt/test/tests
