#!/bin/sh
# This script defaults `ld` to `lld-${RELEASE_BRANCH}` and `clang` to `clang-${RELEASE_BRANCH}`

set -ex

RELEASE_BRANCH=7

sudo update-alternatives --install "/usr/bin/ld64.lld" "ld64.lld" "/usr/bin/ld64.lld-${RELEASE_BRANCH}" 10
sudo update-alternatives --install "/usr/bin/ld.lld" "ld.lld" "/usr/bin/ld.lld-${RELEASE_BRANCH}" 10
sudo update-alternatives --install "/usr/bin/lld" "lld" "/usr/bin/lld-${RELEASE_BRANCH}" 10
sudo update-alternatives --install "/usr/bin/lld-link" "lld-link" "/usr/bin/lld-link-${RELEASE_BRANCH}" 10
sudo update-alternatives --install "/usr/bin/wasm-ld" "wasm-ld" "/usr/bin/wasm-ld-${RELEASE_BRANCH}" 10

sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.lld" 30
sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.gold" 20
sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.bfd" 10

ld --version

sudo update-alternatives --install "/usr/bin/clang" "clang" "/usr/bin/clang-${RELEASE_BRANCH}" 10
sudo update-alternatives --install "/usr/bin/clang++" "clang++" "/usr/bin/clang++-${RELEASE_BRANCH}" 10
sudo update-alternatives --install "/usr/bin/clang-cpp" "clang-cpp" "/usr/bin/clang-cpp-${RELEASE_BRANCH}" 10
sudo update-alternatives --install "/usr/bin/clang-format" "clang-format" "/usr/bin/clang-format-${RELEASE_BRANCH}" 10
sudo update-alternatives --install "/usr/bin/clang-format-diff" "clang-format-diff" "/usr/bin/clang-format-diff-${RELEASE_BRANCH}" 10
sudo update-alternatives --install "/usr/bin/git-clang-format" "git-clang-format" "/usr/bin/git-clang-format-${RELEASE_BRANCH}" 10

clang --version
