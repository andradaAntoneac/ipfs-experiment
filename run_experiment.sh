#!/bin/bash

mkdir -p results

echo "creare fisier test"
echo "Acesta este un test IPFS $(date)" > results/testfile.txt

CID=$(ipfs add -q results/testfile.txt)
echo "CID generat: $CID"
echo "$CID" > results/cid.txt
