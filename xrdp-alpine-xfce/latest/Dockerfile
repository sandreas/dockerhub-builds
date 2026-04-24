# Use Alpine Linux as the base image
FROM alpine:latest

# Set environment variables for non-interactive installation
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV XRDP_USER=username
ENV XRDP_PASSWORD=password

# Install necessary dependencies for Xfce, JDownloader, Firefox, Tor Browser, and XRDP
RUN apk update && apk upgrade && \
    apk add --no-cache \
    bash \
    dbus \
    ttf-dejavu \
    x11vnc \
    xf86-video-dummy \
    xorg-server \
    xrdp \
    xfce4 \
    xfce4-session \
    xfce4-settings \
    xfce4-terminal \
    openbox \
    sudo \
    pulseaudio \
    alsa-utils \
    fontconfig \
    curl \
    ca-certificates \
    libnotify \
    openrc \
    && rm -rf /var/cache/apk/*

# Install Java (required for JDownloader)
RUN apk add --no-cache openjdk11

# Install JDownloader
RUN curl -fsSL https://installer.jdownloader.org/JDownloader2_setup_stable.sh | bash

# Install Firefox (latest version from official repositories)
RUN apk add --no-cache firefox

# Install Tor Browser (using Tor package from Alpine repositories)
RUN apk add --no-cache tor

# Configure the xrdp session to start Xfce
RUN echo "xfce4-session" > /etc/skel/.xsession

# Set up supervisor to handle xrdp and other services
RUN apk add --no-cache supervisor

# Create a supervisor configuration file for xrdp
RUN echo "[supervisord]" > /etc/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisord.conf && \
    echo "[program:xrdp]" >> /etc/supervisord.conf && \
    echo "command=/usr/sbin/xrdp" >> /etc/supervisord.conf && \
    echo "[program:xrdp-sesman]" >> /etc/supervisord.conf && \
    echo "command=/usr/sbin/xrdp-sesman" >> /etc/supervisord.conf

# Expose the XRDP port
EXPOSE 3389

# Create a user with password
# Install xrdp Xorg backend
RUN apk add --no-cache xorgxrdp

# Create user
RUN adduser -D -s /bin/bash $XRDP_USER && \
    echo "$XRDP_USER:$XRDP_PASSWORD" | chpasswd && \
    addgroup $XRDP_USER audio && \
    addgroup $XRDP_USER video

# Xfce session
RUN echo "startxfce4" > /home/$XRDP_USER/.xsession && \
    chown $XRDP_USER:$XRDP_USER /home/$XRDP_USER/.xsession

# Runtime fix
RUN mkdir -p /run/dbus && chmod 755 /run/dbus

# Clean up unnecessary packages to reduce size
RUN apk del --no-cache sudo && \
    rm -rf /var/cache/apk/*

# Final command to start supervisor and run all services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]