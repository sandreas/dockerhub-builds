FROM alpine:3.14 as builder
ARG FDK_AAC_VERSION=2.0.1
ARG FDK_AAC_URL="https://github.com/mstorsjo/fdk-aac/archive/v$FDK_AAC_VERSION.tar.gz"
ARG FDK_AAC_SHA256="a4142815d8d52d0e798212a5adea54ecf42bcd4eec8092b37a8cb615ace91dc6"

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
&& echo "---- PREPARE FDKAAC-DEPENDENCIES ----" \
 && cd /tmp/ \
 && wget -O fdk-aac.tar.gz "$FDK_AAC_URL" \
 && tar xfz fdk-aac.tar.gz \
 && cd fdk-aac-* && ./autogen.sh && ./configure --enable-static --disable-shared && make -j$(nproc) install \
&& echo "---- COMPILE FDKAAC ENCODER (executable binary for usage of --audio-profile) ----" \
   && cd /tmp/ \
   && wget https://github.com/nu774/fdkaac/archive/1.0.0.tar.gz \
   && tar xzf 1.0.0.tar.gz \
   && cd fdkaac-1.0.0 \
   && autoreconf -i && ./configure --enable-static --disable-shared && make -j$(nproc) && make install && rm -rf /tmp/* \
&& echo "---- REMOVE BUILD DEPENDENCIES (to keep image small) ----" \
   && apk del --purge build-dependencies && rm -rf /tmp/*

FROM alpine:3.14

RUN echo "---- INSTALL RUNTIME PACKAGES ----" && \
  apk add --no-cache --update --upgrade \
  libstdc++

COPY --from=builder /usr/local/bin/fdkaac /usr/local/bin/

CMD ["-h"]
ENTRYPOINT ["fdkaac"]
