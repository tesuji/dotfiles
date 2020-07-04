#!/usr/bin/env bash

set -eu -o pipefail

PREFIX=$HOME/.local

mkdir -p build/stow && cd $_

curl -LO https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz
tar xf stow-latest.tar.gz

cd stow-2*/

./configure --prefix="$PREFIX"
make -j
make install
