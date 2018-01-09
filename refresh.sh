#!/usr/bin/env bash
set -x

nix-build
# unalias
\cp result/change-structures.pdf change-structures.pdf
# so we can overwrite it later
chmod +w change-structures.pdf
