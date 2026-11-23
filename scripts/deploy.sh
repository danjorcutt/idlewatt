#!/usr/bin/env bash
# Deploys the realm in ../realm to PKGPATH. The package path's namespace must be
# the deploying key's own g1 address (or a namespace that key has registered).
set -euo pipefail
cd "$(dirname "$0")"; . ./env.sh
: "${DEPLOY_GAS_WANTED:=120000000}"
: "${MAX_DEPOSIT:=}"
extra=()
[ -n "$MAX_DEPOSIT" ] && extra+=(-max-deposit "$MAX_DEPOSIT")
pw=()
[ -n "$PASSWORD_FILE" ] && pw=(-insecure-password-stdin)
if [ -n "$PASSWORD_FILE" ]; then exec < "$PASSWORD_FILE"; fi
gnokey maketx addpkg -pkgpath "$PKGPATH" -pkgdir ../realm \
  -gas-fee "$GAS_FEE" -gas-wanted "$DEPLOY_GAS_WANTED" "${extra[@]}" \
  -chainid "$CHAINID" -remote "$REMOTE" "${pw[@]}" "$KEY"
