# Alpha Miner 1.9.3

GPU miner for the **Pearl (PRL)** network through AlphaPool Stratum. NVIDIA CUDA, **0% dev fee**.

## Unified Linux download

One Linux archive supports NVIDIA compute capabilities **8.6, 8.9, 9.0, and 12.0**. The launcher detects the selected CUDA logical device and refuses unsupported GPUs.

Requirements: Linux x86_64, GLIBC 2.34+, and GLIBCXX 3.4.30+.

```bash
curl -fLO https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.9.3/AlphaMiner-Linux-1.9.3.tar.gz
echo '95768fa6e4ecd6a106039e4f04314b1feb45f569ebc3b09cd6b03f681a6deefd  AlphaMiner-Linux-1.9.3.tar.gz' | sha256sum -c
tar -xzf AlphaMiner-Linux-1.9.3.tar.gz
cd AlphaMiner-Linux-1.9.3
sha256sum -c SHA256SUMS
```

## Run

```bash
./alpha-miner \
  --host us2.alphapool.tech \
  --port 5566 \
  --worker prl1pYOUR_ADDRESS.rig01 \
  --password 'x;d=131072' \
  --gpu 0
```

PPLNS uses port `5566`. Dedicated SOLO uses port `5573`. Run one process per GPU with a unique worker suffix and matching `--gpu` index.

The archive includes `ALPHAMINE-PUBLIC-TEST-LICENSE.txt`, `THIRD_PARTY_NOTICES.txt`, and its internal `SHA256SUMS`.

This release is Linux-only. It does not publish or claim a native Windows, Docker, or generic HiveOS 1.9.3 artifact. Older separately versioned packages are not part of this unified Linux release.

Pool stats: <https://pearl.alphapool.tech> · Binary issues: open a GitHub issue.
