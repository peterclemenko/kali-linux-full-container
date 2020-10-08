FROM kalilinux/kali-rolling

LABEL maintainer="Peter Clemenko"

RUN apt-get -y update && apt-get -y upgrade && \
   DEBIAN_FRONTEND=noninteractive apt-get install -y \
   kali-linux-large \
   pciutils \
   iputils \
   network-manager network-manager-gnome network-manager-openvpn-gnome network-manager-openvpn \
   bash-completion && \
   apt-get autoremove -y && \
   apt-get clean


# Some system tools
RUN apt-get install -y git colordiff colortail unzip vim tmux xterm zsh curl telnet strace ltrace tmate less build-essential wget python3-setuptools python3-pip tor proxychains proxychains4 zstd net-tools bash-completion iputils-tracepath 
# code-server
RUN mkdir -p /opt/code-server && \
    curl -Ls https://api.github.com/repos/codercom/code-server/releases/latest | grep "browser_download_url.*linux" | cut -d ":" -f 2,3 | tr -d \"  | xargs curl -Ls | tar xz -C /opt/code-server --strip 1 && \
    echo 'export PATH=/opt/code-server:$PATH' >> /etc/profile

# Update DB and clean'up!

RUN updatedb && \
    apt-get autoremove -y && \
    apt-get clean 

RUN wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install apt-transport-https
RUN apt-get update
RUN apt-get install dotnet-sdk-2.2

RUN git clone --recurse-submodules https://github.com/cobbr/Covenant /pentest/covenant
WORKDIR /pentest/covenant/Covenant

RUN dotnet build

CMD ["/bin/bash", "--init-file", "/etc/profile"]
