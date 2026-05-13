#!/usr/bin/env bash
set -euo pipefail

# Local helper to build tarballs for both linux/amd64 and linux/arm64.
# Requirements: docker buildx + qemu configured.

FFMPEG_VERSION="${1:-8.1.1}"

platforms=("linux/amd64" "linux/arm64")

mkdir -p artifacts dist

for platform in "${platforms[@]}"; do
  platform_dir="${platform//\//-}"
  echo "Building for ${platform}"

  docker buildx build \
    --file Dockerfile.build \
    --platform "${platform}" \
    --target artifacts \
    --build-arg "FFMPEG_VERSION=${FFMPEG_VERSION}" \
    --output "type=local,dest=artifacts/${platform_dir}" \
    .

  chmod +x "artifacts/${platform_dir}/out/ffmpeg" "artifacts/${platform_dir}/out/ffprobe"
  tar -C "artifacts/${platform_dir}/out" -czf "dist/ffmpeg-${FFMPEG_VERSION}-${platform_dir}.tar.gz" ffmpeg ffprobe

done

( cd dist && sha256sum *.tar.gz > SHA256SUMS )

echo "Build complete. Artifacts are in dist/."
