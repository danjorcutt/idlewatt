# Shared settings for the IdleWatt scripts. Override any of these in your shell.
# Defaults target the Gno.land Onyx testnet (chain ID onyx-1).
: "${CHAINID:=onyx-1}"
: "${REMOTE:=https://rpc.onyx.testnets.gno.land:443}"
: "${KEY:=idlewatt-testnet}"                   # gnokey key name
: "${PKGPATH:=gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/idlewatt}"
: "${GAS_FEE:=1000000ugnot}"
: "${GAS_WANTED:=30000000}"
# Optional: file holding the keybase password, for unattended runs.
: "${PASSWORD_FILE:=}"

call() { # call <Func> [args...]
  local fn="$1"; shift
  local argv=()
  for a in "$@"; do argv+=(-args "$a"); done
  if [ -n "$PASSWORD_FILE" ]; then
    gnokey maketx call -pkgpath "$PKGPATH" -func "$fn" "${argv[@]}" \
      -gas-fee "$GAS_FEE" -gas-wanted "$GAS_WANTED" \
      -chainid "$CHAINID" -remote "$REMOTE" -insecure-password-stdin "$KEY" < "$PASSWORD_FILE"
  else
    gnokey maketx call -pkgpath "$PKGPATH" -func "$fn" "${argv[@]}" \
      -gas-fee "$GAS_FEE" -gas-wanted "$GAS_WANTED" \
      -chainid "$CHAINID" -remote "$REMOTE" "$KEY"
  fi
}
