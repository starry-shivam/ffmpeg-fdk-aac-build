## Audiobookshelf Custom Image (Including Prebuilt FFmpeg with `libfdk-aac`)

This setup builds an Audiobookshelf image that downloads prebuilt `ffmpeg`/`ffprobe` with `fdk-aac` codec from:

- https://github.com/starry-shivam/ffmpeg-fdk-aac-build

It avoids compiling FFmpeg inside your Docker build, so builds are faster (from 10+ minutes to less than a minute) and lighter (using the stock Audiobookshelf image as the base image instead of Ubuntu) than the old Ubuntu builder-stage approach.

### Files in this folder

- `Dockerfile`: Pulls the Audiobookshelf Docker image and replaces `ffmpeg` with a custom prebuilt binary that has the `fdk-aac` codec enabled.
- `docker-compose.yml`: A sample Docker Compose file for building and running this image.

This configuration always pulls from the latest release and auto-selects the matching `linux-amd64` or `linux-arm64` archive.
