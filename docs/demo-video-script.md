# IdleWatt demo video: script and shot list (about 75 seconds)

Before recording, run `scripts/heartbeat-loop.sh 2 3 4` (or send one heartbeat per node) so the demo nodes show as online, and have a terminal ready with a funded testnet key.

| # | Time | Shot (screen) | Voice-over |
|---|---|---|---|
| 1 | 0:00–0:08 | Driveway photo or b-roll of a parked Cybertruck, then a desktop GPU box | "My truck sits in the driveway most of the day. So does the gaming PC. That's a lot of idle compute, and idle energy." |
| 2 | 0:08–0:18 | IdleWatt home page on gnoweb (Onyx): title, yellow "Simulated data" alert, Network cards | "IdleWatt is a Gno realm on gno.land: a public registry and dashboard for idle compute nodes. Everything you'll see is simulated, with no Tesla or Akash integration yet. It's the coordination layer, built first." |
| 3 | 0:18–0:28 | Scroll the node cards: Kenmore RTX 4090, Buffalo 3090, Amherst solar CPU box, Tonawanda Cybertruck showing "Driving" | "Home GPUs, a solar-powered CPU box, and a simulated Cybertruck. Each node lists its hardware, region, power source (grid, solar or Powershare backup) and an hourly rate." |
| 4 | 0:28–0:40 | Scroll down to the Register form, fill it in, show the generated gnokey command, run it in a terminal; the new node card appears | "Anyone can register a node right from the page. The form builds the transaction, I sign it, and the node is on-chain." |
| 5 | 0:40–0:50 | Open the node page, click "Send heartbeat", then "Parked and plugged in"; refresh: status is Online / available | "Nodes prove they're alive with signed heartbeats and switch between parked-and-plugged-in and driving. Only the operator's key can do that." |
| 6 | 0:50–1:00 | Click "Record a simulated job" (Llama 3.3 70B, 60 minutes), sign, refresh: job history and earnings update | "Jobs are logged with a length. The realm computes the earnings from the rate, so nobody can just type in a number." |
| 7 | 1:00–1:10 | Fairness pool section, then the leaderboard | "Fourteen percent of every job goes into a fairness pool, inspired by AtomOne's Nakamoto Bonus. It's split equally across every online node, so the little CPU box gets the same share as the 4090." |
| 8 | 1:10–1:18 | GitHub README roadmap section, then end card: "IdleWatt: idle compute, put to work" plus the realm URL | "Next up: Akash provider attestation and payouts over the Gno-Solana bridge. Code and realm links are below. Thanks!" |

**Recording tips**
- 1080p, browser zoom at 110–125% so tables are readable. Hide bookmarks and the key's terminal history.
- Never show the mnemonic or the key password on screen.
- Keep it under 90 seconds and add captions; judges often watch muted.
