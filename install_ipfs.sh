#!/bin/bash

set -e

echo "Detectare mediu..."
IS_WSL=false
if grep -qi microsoft /proc/version; then
    IS_WSL=true
    echo "sistem detectat: WSL"
else
    echo "sistem detectat: Linux nativ"
fi

echo "verificare IPFS..."
if ! command -v ipfs &> /dev/null; then
    echo "	instalare IPFS..."
    wget https://dist.ipfs.tech/go-ipfs/v0.18.1/go-ipfs_v0.18.1_linux-amd64.tar.gz -O ipfs.tar.gz
    tar -xvzf ipfs.tar.gz
    cd go-ipfs
    sudo bash install.sh
    cd ..
fi

echo "initializare IPFS..."
ipfs init || echo "	IPFS deja initializat"

echo "	pornire daemon in background..."
nohup ipfs daemon > ipfs_daemon.log 2>&1 &

sleep 5

PEER_ID=$(ipfs id -f="<id>")
IP_ADDR=$(hostname -I | awk '{print $1}')

mkdir -p results

cat <<EOF > results/ipfs_info.txt
PeerID: $PEER_ID
IP: $IP_ADDR
Connect with:
ipfs swarm connect /ip4/$IP_ADDR/tcp/4001/p2p/$PEER_ID
EOF

echo "nod IPFS activ. Informatii salvate in results/ipfs_info.txt"