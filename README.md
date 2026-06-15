# alpha-miner

GPU miner for the **Pearl (PRL)** network. Mines via AlphaPool's stratum endpoints.

> Binary distribution by permission of the author. Source remains private.

## Hardware support

NVIDIA only. CUDA driver **545+** required.

| Architecture | Generation | Examples |
|---|---|---|
| Volta (sm_70) | data-center | V100, CMP 100-210 |
| Ampere (sm_86) | RTX 30-series, A-series, CMP HX-series | 3060 Ti, 3070, 3080, 3090, A4000, CMP 70HX, 90HX, 170HX, 220HX |
| Ada (sm_89) | RTX 40-series | 4070, 4080, 4080 SUPER, 4090 |
| Hopper (sm_90) | data-center | H100, H200 |
| Blackwell (sm_120) | RTX 50-series, B-series | 5060 Ti, 5070, 5070 Ti, 5080, 5090, B100, B200 |

The miner auto-detects GPU architecture. Override with `--force-backend volta|ampere|ada|hopper|blackwell|blackwell-native` if needed.

## Pool endpoints

Use a regional stratum host close to you. **Do not use `pearl.alphapool.tech` as the stratum URL** — that hostname is HTTPS / Cloudflare-fronted (for the dashboard, downloads, and API) and cannot tunnel stratum TCP.

| Region | Host | Port (PPLNS) | Port (SOLO) |
|---|---|---|---|
| US East | `us1.alphapool.tech` | `5566` | `5567` |
| US West | `us2.alphapool.tech` | `5566` | `5567` |
| Europe | `eu1.alphapool.tech` | `5566` | `5567` |
| Europe 2 | `eu2.alphapool.tech` | `5566` | `5567` |
| Russia / Eurasia | `ru1.alphapool.tech` | `5566` | `5567` |
| Asia | `sg1.alphapool.tech` | `5566` | `5567` |

## Quick start (Linux)

```bash
# 1. download
curl -L -o alpha-miner https://github.com/AlphaMine-Tech/alpha-miner/releases/latest/download/alpha-miner
chmod +x alpha-miner

# 2. verify checksum
curl -L https://github.com/AlphaMine-Tech/alpha-miner/releases/latest/download/SHA256SUMS \
  | sha256sum -c

# 3. mine
./alpha-miner --pool stratum+tcp://us2.alphapool.tech:5566 --address prl1pYOURPEARLADDRESS --worker myrig
```

> Use a **single-line** command. Multi-line commands with `\` continuations can mangle in some terminals (PowerShell, certain web SSH clients) — bash interprets `\<space>` as a literal-space argument and the miner aborts with `error="unknown argument: " "`.

## Common options

| Flag | Purpose |
|---|---|
| `--pool HOST:PORT` | Pool endpoint (or `stratum+tcp://HOST:PORT`) |
| `--address prl1p...` | Your Pearl payout address (required) |
| `--worker NAME` | Worker label, appended to address as `ADDRESS.WORKER` |
| `--password 'x;d=N'` | Static difficulty override; useful for multi-rig setups |
| `--devices 0,1,2` | Mine on specific CUDA devices |
| `--list-devices` | Print available GPUs and exit |
| `--force-backend volta\|ampere\|ada\|hopper\|blackwell\|blackwell-native` | Override auto-detect |
| `--status-interval N` | Print status every N attempts (default off) |
| `--version` | Print miner version and exit |
| `--debug-logs` | Verbose diagnostic output |

Full flag list: `./alpha-miner help`

## Static difficulty (recommended for multi-GPU / non-HiveOS)

The pool's vardiff `min_difficulty` is now `1000` and `starting_difficulty` is `10000`, so most miners reach a usable difficulty within seconds of authorizing. If you're behind a reconnecting wrapper (HiveOS, vast.ai container) or want fully predictable shares, pin difficulty in the password field:

```bash
./alpha-miner --pool stratum+tcp://us2.alphapool.tech:5566 --address prl1p... --worker myrig --password 'x;d=65536'
```

Recommended starting values:

| GPU class | `d=` |
|---|---|
| 3060 Ti / 3070 | 16384 |
| 3080 / 3090 / 4070 | 32768 |
| 4080 / 4090 / 5080 | 65536 |
| 5090 / H100 / multi-GPU rig | 131072+ |

## Performance reference

Single GPU, default PPLNS settings, alpha-miner v1.7.x:

| GPU | TH/s (v1.7.x) |
|---|---|
| RTX 3060 Ti | 60–65 |
| RTX 3070 | 65–70 |
| RTX 3090 | 100–110 |
| RTX 4060 Ti | 65–70 |
| RTX 4080 | 145–150 |
| RTX 4080 SUPER | 155–165 |
| RTX 4090 | 245–255 |
| RTX 5060 Ti | 75–80 |
| RTX 5070 Ti | 145–155 |
| RTX 5080 | 175–185 |
| RTX 5090 | 350–360 |
| H100 SXM 80GB | 610–620 |
| B200 | 750–800 (preliminary) |
| CMP 100-210 (Volta) | ~11 |
| A100 | ~131 |

Live, sortable, per-version table with measured + community-submitted numbers: [pearl.alphapool.tech/#hashrates](https://pearl.alphapool.tech/#hashrates)

## Multi-GPU

One process drives all GPUs by default. To pin to specific cards:

```bash
./alpha-miner --pool stratum+tcp://us2.alphapool.tech:5566 --address prl1p... --worker rig1 --devices 0,1,2,3
```

For per-GPU worker naming on the pool, run one process per GPU and give each a unique `--worker` suffix.

## Systemd service (Linux)

```ini
# /etc/systemd/system/alpha-miner.service
[Unit]
Description=alpha-miner (Pearl PRL GPU miner)
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/alpha-miner --pool stratum+tcp://us2.alphapool.tech:5566 --address prl1p... --worker mybox --password 'x;d=32768'
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
sudo install -m 755 alpha-miner /usr/local/bin/
sudo systemctl daemon-reload
sudo systemctl enable --now alpha-miner
sudo journalctl -u alpha-miner -f
```

## HiveOS

Use the dedicated HiveOS wrapper release — it ships a multi-pool failover supervisor, fixes per-GPU dashboard stats, and uses the HiveOS-standard `alpha/` directory layout.

In HiveOS flight sheet → **Add Custom Miner**:

| Field | Value |
|---|---|
| Installation URL | `https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.7.8/alpha-V1.7.8.20260615.tar.gz` |
| Miner Name | `alpha` |
| Pool URL | `stratum+tcp://us2.alphapool.tech:5566` (comma-separate multiple endpoints for failover) |
| Wallet and worker template | your `prl1p…` PRL address |
| Extra config arguments | *(optional)* — see release notes for tunables |

Full HiveOS install details and the 7 wrapper tunables (`FAILOVER_*`, `REPORT_METRIC`, `HSTATS_RAW_LINES`) are in the [v1.6.0 release notes](https://github.com/AlphaMine-Tech/alpha-miner/releases/tag/v1.6.0).

**Wrapper-version naming:** HiveOS releases use the pattern `<NAME>-V<VERSION>.<YYYYMMDD>.tar.gz`, where `<VERSION>` = `<alpha-miner binary>.<wrapper rev>` (e.g. `1.6.0.03` = alpha-miner 1.6.0 + wrapper revision 03). Latest releases: see <https://github.com/AlphaMine-Tech/alpha-miner/releases>.

## Docker

```bash
docker run --gpus all \
  -e PEARL_ADDRESS=prl1pYOUR_ADDR \
  -e PEARL_POOL_HOST=us2.alphapool.tech \
  -e PEARL_POOL_PORT=5566 \
  alphaminetech/pearl-miner:latest
```

Required env: `PEARL_ADDRESS`. Optional: `PEARL_WORKER` (default `docker-rig`), `PEARL_POOL_PORT` (default `5566`, use `5567` for SOLO), `PEARL_DIFFICULTY` (static-diff override), `PEARL_DEVICES` (GPU pin).

### Keeping your image current

The `:latest` tag is **not auto-updating** — Docker treats it as just another name. `docker run` / `docker compose up` reuses whatever image you have locally tagged `:latest`, which is whatever you pulled last time. If you pulled before v1.5 dropped, you're still on v1.4 even though the registry has v1.5.

**The pool now requires v1.5+. v1.4 and earlier are rejected server-side.** Make sure you're current.

**Force a re-pull on a running deployment:**

```bash
docker pull alphaminetech/pearl-miner:latest
docker stop pearl-miner && docker rm pearl-miner
# (then re-run the docker run command above)
```

**Recommended: pin to an explicit version tag** so you always know what's running and don't get silently upgraded mid-run:

```bash
docker run --gpus all -e PEARL_ADDRESS=... alphaminetech/pearl-miner:1.6.0
```

Bump the tag manually when a new version drops.

### docker-compose

```yaml
services:
  pearl-miner:
    image: alphaminetech/pearl-miner:1.6.0
    pull_policy: always           # re-pull on every `up` (compose v2.4+)
    runtime: nvidia
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    environment:
      PEARL_ADDRESS: prl1pYOUR_ADDR
      PEARL_WORKER: rig01
      PEARL_POOL_HOST: us2.alphapool.tech
      PEARL_POOL_PORT: 5566
    restart: unless-stopped
```

To upgrade:

```bash
docker compose pull pearl-miner && docker compose up -d --force-recreate pearl-miner
```

### Salad / Vast.ai container marketplaces

These platforms cache the image when your container group is **created**, not on each container restart. To pick up a new miner version you must **redeploy the container group** (or click Edit → Save in the Salad dashboard) — restarting individual replicas reuses the cached image.

Pinning to an explicit `:1.6.0` tag is doubly important here: redeploying with `:latest` could land you on whatever version is current at the time, which may or may not be the one you tested.

### Verify which version you're actually running

```bash
docker exec <container_name> alpha-miner --version
```

Or read it from the startup banner in logs:

```bash
docker logs <container_name> 2>&1 | head -20 | grep -i version
```

If it says `alpha-miner 1.4` or earlier → you're stale, pull the new image. `alpha-miner 1.6` → you're good.

## Troubleshooting

**`libcuda.so.1: cannot open shared object file`**
NVIDIA driver not installed or driver version too old. Install/upgrade to driver 545+.

**`no kernel image is available for execution on the device`**
GPU architecture not supported by this binary build. Try `--force-backend volta` if you're on V100/CMP series.

**`error="unknown argument: " "`** *(with a space inside the quotes)*
You pasted a multi-line command and your terminal stripped the newlines, leaving `\<space>` which bash treated as a literal-space argument. Use the single-line command form above.

**Vardiff stuck low**
Set static difficulty: add `--password 'x;d=32768'` (or higher for fast GPUs). See the table above.

**Shares rejected `stale: chain advanced`**
Normal — pool moved to a new block; your in-flight work doesn't count. <1% rejection rate is healthy.

**HiveOS dashboard shows `0 H/s` per-GPU but pool is crediting shares**
You're on an older wrapper. Upgrade to [v1.6.0](https://github.com/AlphaMine-Tech/alpha-miner/releases/tag/v1.6.0) — the `h-stats.sh` in that wrapper emits `hs[]` in kH/s units that HiveOS's `sanitize_clamp` accepts.

## Support

- Pool stats: <https://pearl.alphapool.tech>
- Discord: link in pool footer
- Issues with this binary: open a GitHub issue

## License

Binary redistribution permitted via this repository. Source is not public. All rights reserved by the author.
