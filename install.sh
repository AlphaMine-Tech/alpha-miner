#!/usr/bin/env bash
# Alpha Miner 1.9.3 Linux installer
# Usage examples:
#   LANE=sm86-sm89 curl -fsSL https://raw.githubusercontent.com/AlphaMine-Tech/alpha-miner/main/install.sh | bash
#   LANE=sm90      curl -fsSL https://raw.githubusercontent.com/AlphaMine-Tech/alpha-miner/main/install.sh | bash
#   LANE=sm120     curl -fsSL https://raw.githubusercontent.com/AlphaMine-Tech/alpha-miner/main/install.sh | bash
set -euo pipefail

REPO="AlphaMine-Tech/alpha-miner"
VERSION="v1.9.3"
INSTALL_DIR="${INSTALL_DIR:-$HOME/alpha-miner-1.9.3}"
LANE="${LANE:-}"

case "$LANE" in
  sm86-sm89) ASSET="AlphaMiner-Linux-1.9.3-cuda12.4-sm86-sm89.tar.gz" ;;
  sm90) ASSET="AlphaMiner-Linux-1.9.3-cuda12.8-sm90.tar.gz" ;;
  sm120) ASSET="AlphaMiner-Linux-1.9.3-cuda12.8-sm120.tar.gz" ;;
  *)
    echo "Set LANE=sm86-sm89 for RTX 30/40/L4, LANE=sm90 for H100/H200 CC 9.0, or LANE=sm120 for RTX 50." >&2
    exit 2
    ;;
esac

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
curl -fLO "https://github.com/${REPO}/releases/download/${VERSION}/${ASSET}"
curl -fLO "https://github.com/${REPO}/releases/download/${VERSION}/SHA256SUMS"
sha256sum -c SHA256SUMS --ignore-missing
rm -rf package.new
mkdir package.new
tar -xzf "$ASSET" -C package.new
PACKAGE_DIR="$(find package.new -mindepth 1 -maxdepth 1 -type d -print -quit)"
test -n "$PACKAGE_DIR"
cd "$PACKAGE_DIR"
sha256sum -c SHA256SUMS

printf '\nInstalled Alpha Miner 1.9.3 lane %s at:\n  %s\n\n' "$LANE" "$PWD"
printf 'Run:\n  ./alpha-miner --host us2.alphapool.tech --port 5566 --worker prl1pYOUR_ADDRESS.rig01 --password '\''x;d=131072'\'' --gpu 0\n'
