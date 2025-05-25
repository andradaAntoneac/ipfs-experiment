#!/bin/bash

echo "oprire daemon IPFS..."
pkill ipfs || true

echo "curatare fisiere..."
rm -f ipfs_daemon.log
rm -rf results/gotfile.txt