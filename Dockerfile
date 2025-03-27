# Base image
FROM --platform=linux/arm64 debian:12

# replaced epiphany-browser with firefox-esr
# ffmpeg ffmpeg=7:5.1.4-0+deb12u1 not found -- installing ffmpeg!
RUN apt update && apt install -y \
    codeblocks=20.03+svn13046-0.1+b2 \
    audacity=3.2.4+dfsg-1 \
    g++=4:12.2.0-3 \
    g++-12=12.2.0-14 \
    gcc=4:12.2.0-3 \
    gcc-12=12.2.0-14 \
    gcc-12-base=12.2.0-14 \
    gcc-12-base=12.2.0-14 \
    gdb=13.1-3 \
    geany=1.38-1+b1 \
    xfce4=4.18 \
    x11-utils \
    xorg=1:7.7+23 \
    thunar=4.18.4-1 \
    vim-tiny \
    xfce4-terminal \
    wget \
    unzip \
    thunar-archive-plugin \
    sudo \
    pkg-config=1.8.1-1 \
    firefox-esr \
    evince=43.1-2+b1 \
    ffmpeg \
    gpicview \
    iputils-ping \
    less \
    make=4.3-4.1 \
    nano \
    os-prober \
    pciutils \
    whiptail \
    wine=8.0~repack-4 \
    xfce4-screenshooter \
    zerofree \
    zip \
    dbus-x11 \ 
    xserver-xephyr


# Benutzer "stud" erstellen mit passwort "stud"
RUN useradd -m -s /bin/bash stud && \
    echo "stud:stud" | chpasswd && \
    usermod -aG sudo stud

VOLUME ["/shared"]

USER stud
WORKDIR /home/stud

ENV DISPLAY=host.docker.internal:0