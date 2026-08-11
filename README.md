# Alpha Miner 1.9.2

GPU miner for the **Pearl (PRL)** network through AlphaPool Stratum. NVIDIA CUDA, **0% dev fee**.

> **Mandatory post-fork release:** Pearl certificate V3 activated at mainnet height `99000`. Alpha Miner versions before `1.9.2` do not produce compatible post-fork proofs.
>
> Binary distribution by permission of the author. Source remains private.

## Supported release

Alpha Miner 1.9.2 currently provides one supported artifact:

- Ubuntu 22.04+ / Linux x86_64
- GLIBC 2.34 or newer
- NVIDIA driver 545+
- CUDA compute capabilities `8.6`, `8.9`, and `12.0`

| Compute capability | Cards |
|---|---|
| 8.6 | RTX 30 series |
| 8.9 | RTX 40 series |
| 12.0 | RTX 50 series |

There is currently **no V3-qualified HiveOS, Windows, or Docker package**. Do not use an older HiveOS archive, Windows executable, or Docker image after height `99000`.

## Download and verify

```bash
curl -LO https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.9.2/alpha-miner-1.9.2-linux-amd64.tar.gz
curl -LO https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.9.2/SHA256SUMS
sha256sum -c SHA256SUMS
tar xzf alpha-miner-1.9.2-linux-amd64.tar.gz
cd alpha-miner-1.9.2
sha256sum -c SHA256SUMS
```

Expected package identity:

```text
cbf953382e8dc59cfa6c92b397e23f69b66279c07149dc4d66551bd019f7bba7  alpha-miner-1.9.2-linux-amd64.tar.gz
```

Expected miner core identity:

```text
27035620fbe1468a39ebd4857d3425c42232e107634dc53ae7e7e43756f7f628  alpha-miner
```

## Pool endpoints

- PPLNS: port `5566`
- Dedicated SOLO: port `5573`

Available regional hosts:

| Region | Host |
|---|---|
| US East | `us1.alphapool.tech` |
| US West | `us2.alphapool.tech` |
| Europe | `eu1.alphapool.tech` |
| Europe 2 | `eu2.alphapool.tech` |
| Russia / Eurasia | `ru1.alphapool.tech` |
| India | `in1.alphapool.tech` |
| Asia / Singapore | `sg1.alphapool.tech` |

Do not use `pearl.alphapool.tech` as a Stratum host; it is the HTTPS dashboard/API endpoint.

## Run

The worker argument is the complete `PRL_ADDRESS.WORKER` identity:

```bash
./alpha-miner \
  --host us2.alphapool.tech \
  --port 5566 \
  --worker prl1pYOUR_ADDRESS.rig01 \
  --password 'x;d=50000' \
  --gpu 0
```

### Options

| Flag | Purpose |
|---|---|
| `--host HOST` | Stratum host; default `us2.alphapool.tech` |
| `--port PORT` | Stratum port; default `5566` |
| `--worker ADDRESS.WORKER` | Required complete payout address and worker identity |
| `--password PASS` | Stratum password; use `x` for vardiff or `x;d=N` for static difficulty |
| `--gpu ID` | CUDA device index; default `0` |
| `--version` | Print version and exit |
| `--help` | Print the exact supported CLI |

Rank, geometry, and backend are fixed to the AlphaPool mainnet rank-128 profile. Legacy flags such as `--pool`, `--address`, `--devices`, `--force-backend`, `--rank`, and `--gemm` are not accepted by 1.9.2.

Run one process per GPU, using a unique worker suffix and matching `--gpu` index for each process.

## systemd example

```ini
[Unit]
Description=Alpha Miner 1.9.2
After=network-online.target

[Service]
ExecStart=/usr/local/bin/alpha-miner --host us2.alphapool.tech --port 5566 --worker prl1pYOUR_ADDRESS.rig01 --password x --gpu 0
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
sudo install -m 755 alpha-miner /usr/local/bin/alpha-miner
sudo systemctl enable --now alpha-miner
sudo journalctl -u alpha-miner -f
```

## Troubleshooting

| Symptom | Action |
|---|---|
| `unknown or protected option` | Remove legacy flags and use only the documented 1.9.2 CLI |
| `libcuda.so.1` missing | Install or repair the NVIDIA driver |
| GLIBC version error | Upgrade to Ubuntu 22.04+; this build requires GLIBC 2.34+ |
| No compatible kernel image | This release supports only compute capabilities 8.6, 8.9, and 12.0 |
| Shares rejected after height 99000 | Verify version `1.9.2` and the exact core SHA-256 above |

## Support

Pool stats: <https://pearl.alphapool.tech> · Discord: link in the pool footer · Binary issues: open a GitHub issue.

## License

Binary redistribution is permitted through this repository. Source is not public. All rights reserved by the author.
