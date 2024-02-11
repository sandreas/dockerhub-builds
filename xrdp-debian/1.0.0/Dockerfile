# Copyright (c) 2019 FEROX YT EIRL, www.ferox.yt <devops@ferox.yt>
# Copyright (c) 2019 Jérémy WALTHER <jeremy.walther@golflima.net>
# See <https://github.com/frxyt/docker-xrdp> for details.

FROM debian:bookworm-slim

LABEL maintainer="Jérémy WALTHER <jeremy@ferox.yt>"

# Install required packages to run
RUN     DEBIAN_FRONTEND=noninteractive apt-get update \
    &&  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --fix-missing --no-install-recommends \
            ca-certificates \
            curl \
            dbus-x11 \
            gnupg \
            openssh-server \
            sudo \
            supervisor \
            tigervnc-standalone-server \
            vim \
            xrdp \
            wget \
    &&  apt-get clean -y && apt-get clean -y && apt-get autoclean -y && rm -r /var/lib/apt/lists/*

# Set default environment variables
ENV FRX_APTGET_DISTUPGRADE=""
ENV FRX_APTGET_INSTALL=""
ENV FRX_CMD_INIT=""
ENV FRX_CMD_START=""
ENV FRX_LOG_PREFIX_MAXLEN=6
ENV FRX_XRDP_CERT_SUBJ='/C=FX/ST=None/L=None/O=None/OU=None/CN=localhost'
ENV FRX_XRDP_USER_NAME=debian
ENV FRX_XRDP_USER_PASSWORD=ChangeMe
ENV FRX_XRDP_USER_SUDO=1
ENV FRX_XRDP_USER_GID=1000
ENV FRX_XRDP_USER_UID=1000
ENV FRX_XRDP_USER_COPY_SA=0
ENV TZ=Etc/UTC
# Copy assets
COPY /github/workspace/xrdp-debian/1.0.0/files/log /usr/local/bin/frx-log
COPY /github/workspace/xrdp-debian/1.0.0/files/start /usr/local/sbin/frx-start
COPY /github/workspace/xrdp-debian/1.0.0/files/supervisord.conf /etc/supervisor/supervisord.conf
COPY /github/workspace/xrdp-debian/1.0.0/files/xrdp.ini /etc/xrdp/xrdp.ini

# Configure installed packages
RUN     echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ALL \
    &&  sed -e 's/^#\?\(PermitRootLogin\)\s*.*$/\1 no/' \
            -e 's/^#\?\(PasswordAuthentication\)\s*.*$/\1 yes/' \
            -e 's/^#\?\(PermitEmptyPasswords\)\s*.*$/\1 no/' \
            -e 's/^#\?\(PubkeyAuthentication\)\s*.*$/\1 yes/' \
            -i /etc/ssh/sshd_config \
    &&  mkdir -p /run/sshd \
    &&  mkdir -p /var/run/dbus \
    &&  mkdir -p /frx/entrypoint.d \
    &&  rm -f /etc/xrdp/cert.pem /etc/xrdp/key.pem /etc/xrdp/rsakeys.ini \
    &&  rm -f /etc/ssh/ssh_host_*

# Prepare default desktop if needed & version information
ARG DOCKER_TAG
ARG SOURCE_BRANCH
ARG SOURCE_COMMIT
COPY files/desktop /usr/local/sbin/frx-desktop
RUN     echo "[frxyt/xrdp:${DOCKER_TAG}] <https://github.com/frxyt/docker-xrdp>" > /frx/version \
    &&  echo "[version: ${SOURCE_BRANCH}@${SOURCE_COMMIT}]" >> /frx/version \
    &&  /usr/local/sbin/frx-desktop ${DOCKER_TAG}

# Copy source files
COPY Dockerfile /frx/


RUN install -d -m 0755 /etc/apt/keyrings
RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

# RUN echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
# RUN echo $' \n\
# Package: * \n\
# Pin: origin packages.mozilla.org \n\
# Pin-Priority: 1000 \n\
# ' | tee /etc/apt/preferences.d/mozilla


COPY /github/workspace/xrdp-debian/1.0.0/files/mozilla.list /etc/apt/sources.list.d/mozilla.list
COPY /github/workspace/xrdp-debian/1.0.0/files/mozilla /etc/apt/preferences.d/mozilla
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --fix-missing --no-install-recommends \
    firefox \
    default-jre \
    kitty

#EXPOSE 22
#EXPOSE 3389

VOLUME [ "/home" ]
WORKDIR /home

CMD [ "/usr/local/sbin/frx-start" ]
