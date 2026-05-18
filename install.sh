#!/usr/bin/env bash
# alpha-miner installer
# usage: curl -sSL https://raw.githubusercontent.com/AlphaMine-Tech/alpha-miner/main/install.sh | bash
set -euo pipefail

REPO="AlphaMine-Tech/alpha-miner"
INSTALL_DIR="${INSTALL_DIR:-$HOME/alpha-miner}"

echo "==> downloading latest alpha-miner from ${REPO}"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

curl -fL -o alpha-miner \
  "https://github.com/${REPO}/releases/latest/download/alpha-miner"
curl -fL -o SHA256SUMS \
  "https://github.com/${REPO}/releases/latest/download/SHA256SUMS"

echo "==> verifying checksum"
sha256sum -c SHA256SUMS --ignore-missing

chmod +x alpha-miner

echo
echo "==> installed at ${INSTALL_DIR}/alpha-miner"
echo
echo "next step: run it (use a regional stratum endpoint — us2 / eu1 / sg1):"
echo
echo "  cd ${INSTALL_DIR}"
echo "  ./alpha-miner --pool stratum+tcp://us2.alphapool.tech:5566 --address prl1pYOURPEARLADDRESS --worker \$(hostname)"
echo
echo "regional alternatives:"
echo "  stratum+tcp://us2.alphapool.tech:5566   # US West"
echo "  stratum+tcp://eu1.alphapool.tech:5566   # Europe"
echo "  stratum+tcp://sg1.alphapool.tech:5566   # Asia"
echo
echo "do NOT use pearl.alphapool.tech for the stratum URL — that hostname is HTTPS/Cloudflare only."
echo
echo "see README at https://github.com/${REPO}"
