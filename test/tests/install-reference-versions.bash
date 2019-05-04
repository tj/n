#!/usr/bin/env bash

# These are the versions installed and hence cached by proxy-build.

# Run commands we want to cache downloads for

# Get index into cache for lookups of expected versions.
curl --location --fail https://nodejs.org/dist/index.tab &> /dev/null

# Using 4.9.1 as a well known old version (which is no longer getting updated so does not change)
n --download 4
n --download lts
n --download latest
