FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV USERS_TO_ADD="andreas password yes"

RUN apt-get -y update 
RUN apt-get -y upgrade

RUN apt-get install -y \
    xfce4 \
    xfce4-clipman-plugin \
    xfce4-cpugraph-plugin \
    xfce4-netload-plugin \
    xfce4-screenshooter \
    xfce4-taskmanager \
    xfce4-terminal \
    xfce4-xkb-plugin 

RUN apt-get install -y \
    dbus-x11 

RUN apt update && apt-get install -y \
    sudo \
    wget \
    xorgxrdp \
    xrdp \
    openjdk-17-jre \
    unrar && \
    apt remove -y light-locker xscreensaver && \
    apt autoremove -y && \
    rm -rf /var/cache/apt /var/lib/apt/lists

COPY ./files/ubuntu-run.sh /usr/bin/
RUN mv /usr/bin/ubuntu-run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh


# Docker config
EXPOSE 3389
ENTRYPOINT ["/usr/bin/run.sh"]