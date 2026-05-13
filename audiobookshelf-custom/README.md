# Audiobookshelf Custom Image (Prebuilt FFmpeg)

This setup builds an Audiobookshelf image that **downloads prebuilt ffmpeg/ffprobe** from:

- https://github.com/starry-shivam/ffmpeg-fdk-aac-build

It avoids compiling ffmpeg inside your Docker build, so builds are faster and lighter than the old Ubuntu builder-stage approach.

## Main reason

Default ffmpeg bundled in Audiobookshelf images may only provide basic xHE-AAC (USAC) support.
This custom image replaces ffmpeg/ffprobe with prebuilt binaries intended for better USAC/xHE-AAC handling.

## Files in this folder

- `Dockerfile`: runtime-only replacement of ffmpeg/ffprobe
- `docker-compose.yml`: compose example based on your reference (media file-volume lines removed)

## Dockerfile (full)

```dockerfile
ARG AUDIOBOOKSHELF_TAG=latest
ARG FFMPEG_RELEASE_REPO=starry-shivam/ffmpeg-fdk-aac-build

FROM ghcr.io/advplyr/audiobookshelf:${AUDIOBOOKSHELF_TAG}

ARG FFMPEG_RELEASE_REPO
ARG TARGETARCH

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl jq tar; \
    arch="linux-${TARGETARCH}"; \
    api_url="https://api.github.com/repos/${FFMPEG_RELEASE_REPO}/releases/latest"; \
    asset_url="$(curl -fsSL "${api_url}" | jq -r --arg arch "${arch}" '.assets[] | select(.name | test("^ffmpeg-.*-" + $arch + "\\.tar\\.gz$")) | .browser_download_url' | head -n1)"; \
    test -n "${asset_url}"; \
    curl -fL "${asset_url}" -o /tmp/ffmpeg.tar.gz; \
    tar -xzf /tmp/ffmpeg.tar.gz -C /usr/local/bin; \
    install -m 0755 /usr/local/bin/ffmpeg /usr/bin/ffmpeg; \
    install -m 0755 /usr/local/bin/ffprobe /usr/bin/ffprobe; \
    rm -f /tmp/ffmpeg.tar.gz /usr/local/bin/ffmpeg /usr/local/bin/ffprobe; \
    rm -rf /var/lib/apt/lists/*
```

## Docker Compose (full)

```yaml
services:
  audiobookshelf:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        AUDIOBOOKSHELF_TAG: latest
        FFMPEG_RELEASE_REPO: starry-shivam/ffmpeg-fdk-aac-build
    image: audiobookshelf-custom:latest
    container_name: audiobookshelf
    ports:
      - "13378:80"
    volumes:
      - ./data/metadata:/metadata
      - ./data/config:/config
    environment:
      - AUDIOBOOKSHELF_UID=1000
      - AUDIOBOOKSHELF_GID=1000
      - TZ=Asia/Kolkata
    restart: unless-stopped
```

## Usage

1. Change into this folder.
2. Run `docker compose up -d --build`.
3. Open Audiobookshelf on `http://localhost:13378`.

## Optional: add your media mounts

The compose file intentionally removes your media file-volume lines, as requested.
Add your own mounts under `volumes:` when ready, for example:

```yaml
      - /path/to/audiobooks:/audiobooks:ro
```

This configuration always pulls from the latest release and auto-selects the matching `linux-amd64` or `linux-arm64` archive.
