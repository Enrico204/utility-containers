FROM docker.io/debian:bookworm-backports

RUN cat > /etc/apt/preferences.d/99debian-backports <<EOF
Package: *
Pin: release n=bookworm-backports
Pin-Priority: 900
EOF

RUN apt-get update -yq \
    && apt-get dist-upgrade -yq \
    && apt-get install -yq iputils-ping iproute2 tcpdump tshark termshark \
        mtr-tiny traceroute curl wget nmap netcat-openbsd socat \
        openssl stunnel4 caddy bind9-dnsutils golang \
        \
        arp-scan arping atftpd bind9-dnsutils binwalk \
        cifs-utils dns2tcp dnsenum dnsrecon dos2unix \
        ethtool expect fping git hping3 hydra ike-scan \
        masscan miredo mitmproxy netdiscover netmask \
        netsed netsniff-ng nfs-common ngrep nmap openvpn \
        proxytunnel ptunnel python-is-python3 python3-impacket \
        python3-pip python3-scapy python3-virtualenv \
        samba sendemail smbmap snmp socat sqlmap ssldump \
        sslh sslscan sslsplit stunnel4 tcpick tcpreplay telnet \
        tftp-hpa thc-ipv6 traceroute udptunnel vim-nox vlan \
        vpnc whois xxd \
    && apt-get clean
