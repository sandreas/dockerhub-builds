FROM alpine:3.14 as builder
ARG MP4V2_URL="https://github.com/enzo1982/mp4v2/archive/refs/tags/v2.1.1.zip"

RUN echo "---- INSTALL BUILD DEPENDENCIES ----" \
    && apk add --no-cache --update --upgrade --virtual=build-dependencies \
    autoconf \
    libtool \
    automake \
    boost-dev \
    build-base \
    gcc \
    git \
    tar \
    wget \
&& echo "---- COMPILE MP4V2 ----" \
  && cd /tmp/ \
  && wget "${MP4V2_URL}" -O mp4v2.zip \
  && unzip mp4v2.zip \
  && cd mp4v2* \
  && autoreconf -fiv \
  && ./configure && \
  make -j$(nproc) && \
  make install && make distclean \
&& echo "---- REMOVE BUILD DEPENDENCIES (to keep image small) ----" \
    && apk del --purge build-dependencies && rm -rf /tmp/*

FROM alpine:3.14

RUN echo "---- INSTALL RUNTIME PACKAGES ----" && \
  apk add --no-cache --update --upgrade \
  libstdc++

COPY --from=builder /usr/local/bin/mp4* /usr/local/bin/
COPY --from=builder /usr/local/lib/libmp4v2* /usr/local/lib/

CMD ["-help"]
ENTRYPOINT ["mp4tags"]
