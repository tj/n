# Tests

Automated tests for `n`.

## Running Tests

Run all the tests across a range of containers and on the host system:

    npm run test

Run all the tests on a single system:

    cd test
    npx bats tests
    docker compose run ubuntu-curl bats /mnt/test/tests

Run single test on a single system::

    cd test
    npx bats tests/install-contents.bats
    docker compose run ubuntu-curl bats /mnt/test/tests/install-contents.bats

## Docker Tips

Using `docker compose` in addition to `docker` for convenient mounting of `n` script and the tests into the container. Changes to the tests or to `n` itself are reflected immediately without needing to rebuild the containers.

`bats` is being mounted directly out of `node_modules` into the container as a manual install based on its own install script. This is a bit of a hack, but avoids needing to install `git` or `npm` for a full remote install of `bats`, and means everything on the same version of `bats`.

Container test coverage, see [run-all-tests](./bin/run-all-tests)
- `fedora-curl` has curl installed, and does not have jq installed
- `ubuntu-wget` has wget and jq installed, and does not have curl installed
- macOS host (if running on macOS!) has curl and jq installed by default

Using `docker compose` to run the container adds:

* specified `n` script mounted to `/usr/local/bin/n`
* `test/tests` mounted to `/mnt/test/tests`
* `node_modules/bats` provides `/usr/local/bin/bats` et al
* `.curlrc` with `--insecure` to allow use of proxy

So for example:

    cd test
    docker compose run ubuntu-curl
      # in container
      n --version
      bats /mnt/test/tests
