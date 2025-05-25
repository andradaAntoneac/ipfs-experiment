#!/bin/bash

CID=$(cat results/cid.txt)
if [ -z "$CID" ]; then
    echo "CID nu a fost gasit. Ruleaza mai intai run_experiment.sh"
    exit 1
fi

START=$(date +%s)
ipfs get "$CID" -o results/gotfile.txt
END=$(date +%s)
DIFF=$((END - START))

echo "timp descarcare: $DIFF secunde"
echo "$DIFF" > results/download_time.txt