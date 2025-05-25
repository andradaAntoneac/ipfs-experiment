#!/bin/bash

IFACE="eth0" # sau wlan0 daca e pe wireless

echo "activare instabilitate retea..."
sudo tc qdisc add dev $IFACE root netem delay 600ms loss 20%
sleep 20
echo "Dezactivare..."
sudo tc qdisc del dev $IFACE root netem