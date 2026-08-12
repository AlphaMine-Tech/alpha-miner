# Alpha Miner 1.9.3

GPU miner for the **Pearl (PRL)** network through AlphaPool Stratum. NVIDIA CUDA, **0% dev fee**.

> **Required post-fork release:** Pearl certificate V3 activated at mainnet height `99000`. Use one of the exact 1.9.3 Linux archives below.
>
> Binary distribution by permission of the author. Source remains private.

## Supported 1.9.3 Linux lanes

| Archive | GPUs |
|---|---|
| `AlphaMiner-Linux-1.9.3-cuda12.4-sm86-sm89.tar.gz` | RTX 30, RTX 40, NVIDIA L4 |
| `AlphaMiner-Linux-1.9.3-cuda12.8-sm90.tar.gz` | NVIDIA H100/H200 |
| `AlphaMiner-Linux-1.9.3-cuda12.8-sm120.tar.gz` | RTX 50 |

Every archive contains a hash-pinned launcher that detects the requested CUDA logical device and refuses unsupported compute capabilities.

This release does **not** publish or claim a native Windows, Docker, or generic HiveOS 1.9.3 package. Older separately versioned packages are not 1.9.3.

## Download and verify

Choose exactly one archive for your GPU:

```bash
# RTX 30 / RTX 40 / L4
ASSET=AlphaMiner-Linux-1.9.3-cuda12.4-sm86-sm89.tar.gz

# H100/H200 compute capability 9.0
# ASSET=AlphaMiner-Linux-1.9.3-cuda12.8-sm90.tar.gz

# RTX 50 compute capability 12.0
# ASSET=AlphaMiner-Linux-1.9.3-cuda12.8-sm120.tar.gz

curl -fLO "https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.9.3/$ASSET"
curl -fLO https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.9.3/SHA256SUMS
curl -fLO https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.9.3/QUALIFICATION-MANIFEST.txt
sha256sum -c SHA256SUMS --ignore-missing
tar -xzf "$ASSET"
cd AlphaMiner-Linux-1.9.3-*
sha256sum -c SHA256SUMS
```

Expected release identities:

```text
f95dfbbaea1e66579d59975b7a66f9254b2e77b5e4737b5034eef0e381cfbffa  AlphaMiner-Linux-1.9.3-cuda12.4-sm86-sm89.tar.gz
e3e45e9b731d3ed9d0be8abbe449f9e6bd4fd85cb366ad29d49ce57c6b8d1cca  AlphaMiner-Linux-1.9.3-cuda12.8-sm90.tar.gz
2fb7f1f49f7dbd4cc1e5ccda4af4fd2bb439da7d9ad34012c7b4e392e163f56e  AlphaMiner-Linux-1.9.3-cuda12.8-sm120.tar.gz
```

## Pool endpoints

- PPLNS: port `5566`
- Dedicated SOLO: port `5573`

Regional hosts: `us1.alphapool.tech`, `us2.alphapool.tech`, `eu1.alphapool.tech`, `eu2.alphapool.tech`, `ru1.alphapool.tech`, `in1.alphapool.tech`, `sg1.alphapool.tech`.

Do not use `pearl.alphapool.tech` as a Stratum host; it is the HTTPS dashboard/API endpoint.

## Run

The worker argument is the complete `PRL_ADDRESS.WORKER` identity:

```bash
./alpha-miner \
  --host us2.alphapool.tech \
  --port 5566 \
  --worker prl1pYOUR_ADDRESS.rig01 \
  --password 'x;d=131072' \
  --gpu 0
```

Run one process per GPU, using a unique worker suffix and matching `--gpu` index for each process.

Supported CLI flags are shown by `./alpha-miner --help`. Legacy flags such as `--pool`, `--address`, `--devices`, `--force-backend`, `--rank`, and `--gemm` are not accepted by 1.9.3.

## Troubleshooting

| Symptom | Action |
|---|---|
| `unsupported or unqualified compute capability` | Download the archive matching the requested GPU; unsupported architectures fail closed |
| `payload-hash-mismatch` | Re-download the complete archive and verify both checksum files |
| `libcuda.so.1` missing | Install or repair the NVIDIA driver |

Pool stats: <https://pearl.alphapool.tech> · Binary issues: open a GitHub issue.
