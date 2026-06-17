# alpha-miner

GPU miner for the **Pearl (PRL)** network, via AlphaPool stratum. NVIDIA only, CUDA driver **545+**, **0% dev fee**.

> Binary distribution by permission of the author. Source remains private.

## Hardware

Architecture is auto-detected (override with `--force-backend volta|ampere|ada|hopper|blackwell|blackwell-native`):

| Arch | Cards |
|---|---|
| Volta (sm_70) | V100, CMP 100-210 |
| Ampere (sm_86) | RTX 30-series, A-series, CMP HX |
| Ada (sm_89) | RTX 40-series (incl. 4060 Ti, 4080 SUPER) |
| Hopper (sm_90) | H100, H200 |
| Blackwell (sm_120) | RTX 50-series, B100/B200 |

## Pool endpoints

Pick the closest region. **PPLNS = port `5566`, SOLO = port `5567`.**
**Never use `pearl.alphapool.tech` as the stratum host** — it's HTTPS/Cloudflare (dashboard, downloads, API), not stratum TCP.

| Region | Host |
|---|---|
| US East | `us1.alphapool.tech` |
| US West | `us2.alphapool.tech` |
| Europe | `eu1.alphapool.tech` |
| Europe 2 | `eu2.alphapool.tech` |
| Russia / Eurasia | `ru1.alphapool.tech` |
| India | `in1.alphapool.tech` |
| Asia (Singapore) | `sg1.alphapool.tech` |

## Quick start (Linux)

```bash
curl -L -o alpha-miner https://github.com/AlphaMine-Tech/alpha-miner/releases/latest/download/alpha-miner
chmod +x alpha-miner
curl -L https://github.com/AlphaMine-Tech/alpha-miner/releases/latest/download/SHA256SUMS | sha256sum -c   # optional
./alpha-miner --pool stratum+tcp://us2.alphapool.tech:5566 --address prl1pYOURADDRESS --worker myrig
```

Keep the run command on **one line** — `\` continuations can mangle in some terminals and abort the miner with `unknown argument: " "`.

## Options

| Flag | Purpose |
|---|---|
| `--pool HOST:PORT` | Pool endpoint (or `stratum+tcp://HOST:PORT`) |
| `--address prl1p...` | Pearl payout address (required) |
| `--worker NAME` | Worker label (reported as `ADDRESS.WORKER`) |
| `--password 'x;d=N'` | Static difficulty (see below) |
| `--devices 0,1,2` | Mine on specific CUDA devices |
| `--list-devices` | List GPUs and exit |
| `--force-backend ...` | Override arch auto-detect |
| `--version` / `help` | Print version / full flag list |

## Static difficulty

Vardiff works out of the box. For multi-GPU rigs or reconnecting wrappers (HiveOS, vast.ai), pin difficulty in the password field:

```bash
./alpha-miner --pool stratum+tcp://us2.alphapool.tech:5566 --address prl1p... --worker myrig --password 'x;d=65536'
```

| GPU class | `d=` |
|---|---|
| 3060 Ti / 3070 | 16384 |
| 3080 / 3090 / 4070 | 32768 |
| 4080 / 4090 / 5080 | 65536 |
| 5090 / H100 / multi-GPU | 131072+ |

## Multi-GPU

One process drives all GPUs. Pin specific cards with `--devices 0,1,2`. For per-GPU worker names on the pool, run one process per GPU, each with a unique `--worker`.

## HiveOS

Flight sheet → **Add Custom Miner**:

| Field | Value |
|---|---|
| Installation URL | `https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.7.9/alpha-V1.7.9.20260617.tar.gz` |
| Miner Name | `alpha` |
| Pool URL | `stratum+tcp://us2.alphapool.tech:5566` (comma-separate hosts for failover) |
| Wallet template | your `prl1p…` PRL address |

The wrapper handles multi-pool failover and per-GPU dashboard stats out of the box.

## Docker

```bash
docker run --gpus all -e PEARL_ADDRESS=prl1pYOUR_ADDR -e PEARL_POOL_HOST=us2.alphapool.tech alphaminetech/pearl-miner:latest
```

Env: `PEARL_ADDRESS` (required), `PEARL_WORKER` (default `docker-rig`), `PEARL_POOL_PORT` (`5566`, or `5567` for SOLO), `PEARL_DIFFICULTY`, `PEARL_DEVICES`.

`:latest` is **not** auto-updating — run `docker pull alphaminetech/pearl-miner:latest` to refresh, or pin an explicit tag (e.g. `:1.7.9`). Cloud marketplaces (Salad, Vast.ai) cache the image at deploy — **redeploy the group** to pick up a new version. Check what's running: `docker exec <container> alpha-miner --version`.

## systemd (Linux)

```ini
# /etc/systemd/system/alpha-miner.service
[Unit]
After=network-online.target
[Service]
ExecStart=/usr/local/bin/alpha-miner --pool stratum+tcp://us2.alphapool.tech:5566 --address prl1p... --worker mybox --password 'x;d=32768'
Restart=on-failure
RestartSec=10
[Install]
WantedBy=multi-user.target
```

```bash
sudo install -m 755 alpha-miner /usr/local/bin/ && sudo systemctl enable --now alpha-miner
sudo journalctl -u alpha-miner -f
```

## Troubleshooting

| Symptom | Fix |
|---|---|
| `libcuda.so.1: cannot open shared object` | NVIDIA driver missing/old — install driver 545+ |
| `no kernel image is available` | Unsupported arch build — try `--force-backend volta` (V100/CMP) |
| `unknown argument: " "` | Multi-line paste stripped newlines — use the single-line command |
| Vardiff stuck low | Pin `--password 'x;d=32768'` (or higher) |
| `stale: chain advanced` rejects | Normal (pool moved to a new block); <1% is healthy |
| HiveOS shows `0 H/s` per-GPU | Old wrapper — reinstall the latest HiveOS release |

## Support

Pool stats: <https://pearl.alphapool.tech> · Discord: link in pool footer · Binary issues: open a GitHub issue.

## License

Binary redistribution permitted via this repository. Source is not public. All rights reserved by the author.
