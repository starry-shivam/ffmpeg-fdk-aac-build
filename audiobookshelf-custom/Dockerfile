ARG AUDIOBOOKSHELF_TAG=latest
ARG FFMPEG_RELEASE_REPO=starry-shivam/ffmpeg-fdk-aac-build

FROM ghcr.io/advplyr/audiobookshelf:${AUDIOBOOKSHELF_TAG}

ARG FFMPEG_RELEASE_REPO=starry-shivam/ffmpeg-fdk-aac-build
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