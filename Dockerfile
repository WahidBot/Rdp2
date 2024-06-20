# Gunakan image dasar Ubuntu
FROM ubuntu:latest

# Update dan install dependencies yang dibutuhkan
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    net-tools \
    iputils-ping \
    iproute2 \
    gnupg \
    software-properties-common \
    && apt-get clean

# Download dan install ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip ngrok.zip && \
    mv ngrok /usr/local/bin && \
    rm ngrok.zip

# Setup ngrok authtoken
ENV NGROK_AUTH_TOKEN 2g1IaTMBV47TkAnpwqkbuXU7vzS_63V3zxECN7mZwqmtFd9UL
RUN ngrok authtoken $NGROK_AUTH_TOKEN

# Install dan konfigurasi Remote Desktop (xrdp)
RUN apt-get update && apt-get install -y xrdp && \
    adduser xrdp ssl-cert && \
    sed -i.bak '/fi/a #xrdp ini\nstartxfce4' /etc/xrdp/startwm.sh && \
    echo xfce4-session >~/.xsession && \
    service xrdp start

# Expose port 3389 untuk RDP
EXPOSE 3389

# Buat user dengan password
RUN useradd -ms /bin/bash runneradmin && \
    echo 'runneradmin:P@ssw0rd!' | chpasswd

# Jalankan ngrok untuk membuat tunnel ke port 3389
CMD ngrok tcp 3389
