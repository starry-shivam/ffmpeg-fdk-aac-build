# FFmpeg + fdk-aac Prebuilt Releases

This repository builds static `ffmpeg` and `ffprobe` binaries with `libfdk-aac` enabled and publishes them to GitHub Releases.

Attribution: initial Docker build approach inspired by https://gist.github.com/dymk/7a6c9e4237335dcb73a0833522668bbf by dymk.

fdk-aac source is fixed to: https://github.com/starry-shivam/fdk-aac

## Main Use Case

The primary use case of this repository is Audiobookshelf custom Docker builds.

Default ffmpeg binaries shipped in Audiobookshelf images usually provide only very basic xHE-AAC (USAC) support, which causes transcoding and playback issues with USAC/xHE-AAC files.

These prebuilt binaries are intended to replace the default ffmpeg/ffprobe in Audiobookshelf images so xHE-AAC (USAC) files are handled reliably.
