#!/usr/bin/env bash
set -euo pipefail
REPO="${REPO:-AlphaMine-Tech/alpha-miner}"
VERSION="${VERSION:-v1.9.3}"
ASSET="AlphaMiner-Linux-1.9.3.tar.gz"
EXPECTED="95768fa6e4ecd6a106039e4f04314b1feb45f569ebc3b09cd6b03f681a6deefd"
BASE_URL="${BASE_URL:-https://github.com/${REPO}/releases/download/${VERSION}}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/alpha-miner-1.9.3}"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
tmp="${ASSET}.tmp.$$"
trap 'rm -f "$tmp"' EXIT
curl -fL "${BASE_URL}/${ASSET}" -o "$tmp"
echo "$EXPECTED  $tmp" | sha256sum -c -
rm -rf package.new
mkdir package.new
tar -xzf "$tmp" -C package.new
cd package.new/AlphaMiner-Linux-1.9.3
sha256sum -c SHA256SUMS
printf '\nInstalled Alpha Miner 1.9.3 at:\n  %s\n\n' "$PWD"
printf 'Run one process per GPU, for example:\n  ./alpha-miner --host us2.alphapool.tech --port 5566 --worker prl1pYOUR_ADDRESS.rig01 --password '\''x;d=131072'\'' --gpu 0\n'
