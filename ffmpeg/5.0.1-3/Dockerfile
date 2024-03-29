# instructions
# because of the 6h limitation in gh actions there is some workarounds that have to be used for building
# 1.) execute manual-build with name=ffmpeg, version=5.0.1-3-builder, arch=linux/arm/v6, tag=linux-armv6-5.0.1-3
# 2.) execute manual-build with name=ffmpeg, version=5.0.1-3-builder, arch=linux/arm/v7, tag=linux-armv7-5.0.1-3
# 3.) execute manual-build with name=ffmpeg, version=5.0.1-3-builder, arch=linux/arm64, tag=linux-arm64-5.0.1-3
# 4.) execute manual-build with name=ffmpeg, version=5.0.1-3-builder, arch=linux/amd64, tag=linux-amd64-5.0.1-3
# 5.) after all have successfully finished: execute manual-build with name=ffmpeg, version=5.0.1-3, arch=linux/arm/v6,linux/arm/v7,linux/arm64,linux/amd64, tag=

FROM sandreas/ffmpeg:linux-armv6-5.0.1-3 as ffmpeg-armv6
FROM sandreas/ffmpeg:linux-armv7-5.0.1-3 as ffmpeg-armv7
FROM sandreas/ffmpeg:linux-arm64-5.0.1-3 as ffmpeg-arm64
FROM sandreas/ffmpeg:linux-amd64-5.0.1-3 as ffmpeg-x64


FROM alpine:3.16.0

RUN mkdir -p /tmp/ffmpeg_{armv6,armv7,arm64,amd64}

COPY --from=ffmpeg-armv6 /usr/local/bin/ffmpeg /usr/local/bin/ffprobe /tmp/ffmpeg_armv6/
COPY --from=ffmpeg-armv7 /usr/local/bin/ffmpeg /usr/local/bin/ffprobe /tmp/ffmpeg_armv7/
COPY --from=ffmpeg-arm64 /usr/local/bin/ffmpeg /usr/local/bin/ffprobe /tmp/ffmpeg_arm64/
COPY --from=ffmpeg-x64 /usr/local/bin/ffmpeg /usr/local/bin/ffprobe /tmp/ffmpeg_amd64/

RUN echo "---- INSTALL RUNTIME PACKAGES ----" && \
  APK_ARCH=$(apk --print-arch) && \
  if [ "$APK_ARCH" = "x86_64" ]; then \
    COPY_SUFFIX="amd64"; \
  elif [ "$APK_ARCH" = "aarch64" ]; then \
    COPY_SUFFIX="arm64"; \
  elif [ "$APK_ARCH" = "armv7" ]; then \
    COPY_SUFFIX="armv7"; \
  else \
    COPY_SUFFIX="armv6"; \
  fi && \
    cp /tmp/ffmpeg_$COPY_SUFFIX/ff* /usr/local/bin/ && \
    rm -rf /tmp/ffmpeg_*

ENTRYPOINT ["/usr/local/bin/ffmpeg"]
