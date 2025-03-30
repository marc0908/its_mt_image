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
    xserver-xephyr \
    openssh-server \
    tightvncserver

RUN mkdir /var/run/sshd

# Benutzer "stud" erstellen mit passwort "stud"
RUN useradd -m -s /bin/bash stud && \
    echo "stud:stud" | chpasswd && \
    usermod -aG sudo stud

RUN ssh-keygen -A

RUN echo 'stud ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/stud && \
    chmod 0440 /etc/sudoers.d/stud

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

VOLUME ["/shared"]

EXPOSE 22
EXPOSE 5901

USER root

RUN mkdir -p /home/stud/.vnc && \
    echo "studvnc" | vncpasswd -f > /home/stud/.vnc/passwd && \
    chmod 600 /home/stud/.vnc/passwd && \
    chown -R stud:stud /home/stud/.vnc

RUN echo 'export PULSE_SERVER=host.docker.internal' >> /home/stud/.bashrc

CMD rm -f /tmp/.X11-unix/X1 /home/stud/.Xauthority /tmp/.X1-lock && \
    /usr/sbin/sshd -D & \
    su - stud -c "export DISPLAY=:1 && vncserver :1 -geometry 1920x1080 -depth 24" && \
    tail -f /dev/null
