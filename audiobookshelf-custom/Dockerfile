ARG AUDIOBOOKSHELF_TAG=latest

FROM ghcr.io/advplyr/audiobookshelf:${AUDIOBOOKSHELF_TAG}

ARG FFMPEG_RELEASE_REPO=starry-shivam/ffmpeg-fdk-aac-build
ARG TARGETARCH

RUN set -eux; \
        if command -v apk >/dev/null 2>&1; then \
            apk add --no-cache ca-certificates curl jq tar; \
        elif command -v apt-get >/dev/null 2>&1; then \
            apt-get update; \
            apt-get install -y --no-install-recommends ca-certificates curl jq tar; \
            rm -rf /var/lib/apt/lists/*; \
        else \
            echo "Unsupported base image: no apk or apt-get found" >&2; \
            exit 1; \
        fi; \
        arch="linux-${TARGETARCH:-amd64}"; \
    api_url="https://api.github.com/repos/${FFMPEG_RELEASE_REPO}/releases/latest"; \
    asset_url="$(curl -fsSL "${api_url}" | jq -r --arg arch "${arch}" '.assets[] | select(.name | test("^ffmpeg-.*-" + $arch + "\\.tar\\.gz$")) | .browser_download_url' | head -n1)"; \
    test -n "${asset_url}"; \
    curl -fL "${asset_url}" -o /tmp/ffmpeg.tar.gz; \
    mkdir -p /tmp/ffmpeg-extract; \
    tar -xzf /tmp/ffmpeg.tar.gz -C /tmp/ffmpeg-extract; \
    install -m 0755 /tmp/ffmpeg-extract/ffmpeg /usr/bin/ffmpeg; \
    install -m 0755 /tmp/ffmpeg-extract/ffprobe /usr/bin/ffprobe; \
    rm -rf /tmp/ffmpeg.tar.gz /tmp/ffmpeg-extract