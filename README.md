# IdleWatt

**Idle compute, put to work.** IdleWatt is an on-chain registry and live dashboard, written in Gno, for idle compute nodes: home GPU boxes, CPU-only machines, and someday parked vehicles like a Tesla Cybertruck. These are machines that could rent spare capacity on decentralized compute networks such as [Akash](https://akash.network).

> [!WARNING]
> **Everything in IdleWatt is simulated or self-reported.** Nodes, heartbeats and jobs are entered by their operators, and the dollar figures are simulated, not payments. IdleWatt has **no Tesla integration, no Akash integration and no hardware attestation** today, and it doesn't claim to. The demo nodes (including "Tonawanda Cybertruck (simulated)") are seeded by the project author.

- **Realm:** `gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/idlewatt`
- **Live dashboard (Onyx testnet, `onyx-1`):** https://onyx.testnets.gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/idlewatt
- Built for the [Gnome Tavern Hackathon](https://dorahacks.io/hackathon/gnome-tavern/detail). IdleWatt is an independent community project and is not affiliated with or endorsed by Gno.land, NewTendermint, Akash, Overclock Labs or Tesla.

## Why

A gaming PC, a rooftop of solar, or a truck parked in the driveway all have compute and energy that sit idle most of the day. Rooftop solar already sends spare electricity back to the grid. IdleWatt asks what the same idea looks like for **compute**: thousands of small, part-time nodes close to where the energy is, rather than a few giant datacenters.

Today's compute marketplaces are built for always-on datacenter racks. Small nodes come and go: a car drives off, a family wants the gaming PC back. They need a way to **announce themselves, prove they're alive, say when they're available, and keep an honest track record**. That's the coordination layer IdleWatt prototypes on Gno.land. Gno fits because the logic is deterministic, the full source is published on-chain, and the UI is rendered by the contract itself.

## What it does

| Feature | How |
|---|---|
| **Node registry** | `RegisterNode` stores a name, type (`home-gpu` / `vehicle` / `cpu`), hardware summary, region, power source (`grid` / `solar` / `powershare-backup`) and an hourly rate in US cents. Nodes are kept in an `avl.Tree`, with secondary indexes by operator and by leaderboard rank. |
| **Signed heartbeats** | `Heartbeat` is a transaction signed by the operator's key. A node is *online* for a configurable window after its last heartbeat (30 minutes by default), and the realm tracks unbroken uptime sessions. Heartbeats are rate-limited to one every 10 seconds. |
| **Availability** | `SetAvailability`: `available` ("parked & plugged in"), `driving` (vehicles only) or `paused`. |
| **Jobs and earnings** | `RecordJob` logs a simulated job. The realm **computes** the earnings from the node's rate and the job length, so an operator can't type in an amount. A node must be online and available to take a job. |
| **Small-node fairness pool** | 14% of every job goes into a pool. Anyone can call `DistributeBonus`, at most once an hour, and it splits the pool **equally** across every node that's online and available, whatever its size. The idea comes from AtomOne's Nakamoto Bonus. |
| **Leaderboard** | Ranked by job earnings plus bonus, kept as a sorted AVL index (no sorting at render time). |
| **gnoweb dashboard** | `Render()` draws network stats, node cards, per-node pages, the leaderboard, job history, a fairness-pool panel and a registration form. It uses gnoweb's alerts, columns, bordered frames, icons, buttons and `<gno-form>`. Action buttons open prefilled transaction forms via `p/moul/txlink`. |
| **Events** | Every state change emits a `chain.Emit` event: `NodeRegistered`, `NodeUpdated`, `Heartbeat`, `AvailabilityChanged`, `JobRecorded`, `BonusDistributed`, `NodeRemoved`, `PausedChanged`, `OnlineWindowChanged`, `AdminChanged`. |
| **Moderation** | The deployer is admin and can pause registrations, remove spam nodes, tune the online window and hand the role over. |

### Dashboard pages

| Path | Page |
|---|---|
| `…/idlewatt` | Home: network summary, node cards, top 5, recent jobs, fairness pool, register form |
| `…/idlewatt:nodes?page=N` | All nodes, paginated |
| `…/idlewatt:node/<id>` | One node: status, specs, earnings, operator action buttons, job history |
| `…/idlewatt:operator/<g1addr>` | One operator's nodes |
| `…/idlewatt:leaderboard` | Top 50 |
| `…/idlewatt:jobs?page=N` | Job history |
| `…/idlewatt:about` | How it works, plus the simulated-data disclaimer |

## Use it

You can do everything from the gnoweb page. Each button and form builds the `gnokey` command for you. From a terminal it looks like this (Onyx testnet; get test GNOT at https://faucet.gno.land):

```sh
export REMOTE=https://rpc.onyx.testnets.gno.land:443 CHAINID=onyx-1
export PKG=gno.land/r/g1pzn6rn8q0pfmq4xje4j8086ncnldavyz8skgp3/idlewatt

# Register a node (returns its ID)
gnokey maketx call -pkgpath $PKG -func RegisterNode \
  -args "Garage RTX 4090" -args home-gpu -args "RTX 4090 24GB, Ryzen 9" \
  -args "US-NY Buffalo" -args solar -args 45 \
  -gas-fee 1000000ugnot -gas-wanted 30000000 -chainid $CHAINID -remote $REMOTE mykey

# Prove it's alive, then open it for work
gnokey maketx call -pkgpath $PKG -func Heartbeat -args 5 -args "GPU 40C" \
  -gas-fee 1000000ugnot -gas-wanted 30000000 -chainid $CHAINID -remote $REMOTE mykey
gnokey maketx call -pkgpath $PKG -func SetAvailability -args 5 -args available \
  -gas-fee 1000000ugnot -gas-wanted 30000000 -chainid $CHAINID -remote $REMOTE mykey

# Log a simulated 2-hour inference job
gnokey maketx call -pkgpath $PKG -func RecordJob -args 5 -args "llama-3.3-70b inference" -args 120 \
  -gas-fee 1000000ugnot -gas-wanted 30000000 -chainid $CHAINID -remote $REMOTE mykey

# Anyone: split the fairness pool (once an hour)
gnokey maketx call -pkgpath $PKG -func DistributeBonus \
  -gas-fee 1000000ugnot -gas-wanted 30000000 -chainid $CHAINID -remote $REMOTE mykey

# Read-only
gnokey query vm/qrender --data "$PKG:node/5" -remote $REMOTE
gnokey query vm/qeval --data "$PKG.Stats()" -remote $REMOTE
```

Full API: `RegisterNode`, `UpdateNode`, `SetRate`, `SetAvailability`, `Heartbeat`, `RecordJob`, `RemoveNode`, `DistributeBonus`; admin only: `SetPaused`, `SetOnlineWindowMinutes`, `AdminRemoveNode`, `TransferAdmin`; read-only: `Admin`, `NodeCount`, `Stats`, `NodeSummary`, `Render`.

### Scripts

`scripts/` has small wrappers around `gnokey` (`env.sh` holds the chain, RPC, key and package defaults):

- `deploy.sh` publishes `realm/` with `gnokey maketx addpkg`.
- `seed-demo.sh` registers the four simulated demo nodes, sends heartbeats, records jobs, splits the pool and sends the truck "driving".
- `heartbeat-loop.sh 2 3 4` keeps chosen demo nodes online, for example while recording the demo video.

## Develop

```sh
# toolchain: gno, gnokey and gnodev from github.com/gnolang/gno at v1.8.0 (what Onyx runs)
cd realm
gno fmt -w . && gno lint . && gno test . -v    # 17 tests
gnodev local                                  # local chain + gnoweb at http://127.0.0.1:8888
CHAINID=dev REMOTE=127.0.0.1:26657 ../scripts/seed-demo.sh   # demo data, locally
```

## Architecture

```
operator key ──signed tx──▶  r/<addr>/idlewatt (Gno realm)
                              ├─ nodes        avl: id -> *Node
                              ├─ byOperator   avl: addr/id -> id     (per-operator listing, 10-node cap)
                              ├─ leaderboard  avl: inverted-total/id -> id  (pre-sorted ranking)
                              ├─ jobs         avl: id -> *Job        (kept even if a node is removed)
                              ├─ nodeJobs     avl: nodeId/jobId -> jobId
                              ├─ fairness pool + bonus rounds
                              └─ chain.Emit events ─▶ indexers / bots
gnoweb ◀── Render(path) ──  markdown dashboard with txlink buttons and <gno-form>
```

- **Access control:** every crossing function checks `cur.IsCurrent()` and identifies the caller with `cur.Previous()`, as the Gno security guide recommends. Only a node's operator can change it, and admin functions check the stored admin address.
- **Input safety:** free-text fields go through a strict character whitelist and length limits. Rates, minutes and the online window are bounded. That keeps operator text from injecting markdown, gnoweb tags or table pipes into the page. Path segments echoed back (like operator addresses) are validated first.
- **No arbitrary money:** earnings are derived from rate × minutes, and the pool is split in whole cents with the remainder carried over. The realm holds and moves no coins at all.
- **Bounded work:** pages are paginated, and the leaderboard is an index, not a sort.

## Limitations (honest list)

- **Simulated data.** Heartbeats prove an operator's key signed a transaction, not that a GPU or a vehicle exists. Jobs are self-reported.
- **No Tesla integration.** A Cybertruck's computers run locked Tesla firmware, and Tesla offers no way to run third-party workloads on them. The vehicle node type is a placeholder for the day that changes.
- **No Akash integration.** Akash providers today are Kubernetes clusters, with GPU support centered on NVIDIA. Nothing here talks to Akash.
- **No payments.** "Earnings" are simulated USD figures. No GNOT or other token moves.
- Testnet only, and the admin is a single key.

## Roadmap

1. **Provider attestation:** link a node to a real Akash provider address and have an oracle or validator attest uptime and hardware, replacing self-reported heartbeats.
2. **Real job receipts:** record Akash lease IDs and settlement data instead of simulated jobs.
3. **Solar and Powershare telemetry:** feed energy-source data so nodes can advertise "running on sunshine" and schedule around it.
4. **Payouts over the Gno.land ↔ Solana bridge:** route compute earnings and the fairness pool as bridged assets once Akash's marketplace is on Solana.
5. **Agentic nodes:** let each node run an agent that negotiates rates and schedules work around driving and household use.
6. **Vehicle support:** if Tesla ever allows third-party compute workloads, vehicles become first-class nodes.

## Repository layout

```
realm/              the Gno realm (gnomod.toml, *.gno, *_test.gno)
scripts/            deploy / seed / heartbeat helpers (gnokey wrappers)
docs/               DoraHacks description, demo-video script, screenshots
```
