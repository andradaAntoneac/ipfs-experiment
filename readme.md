
# Experiment IPFS în Rețea Instabilă (2 VM-uri)

## Descriere

Acest experiment simulează un mediu IPFS distribuit folosind **două noduri IPFS instalate pe două mașini virtuale (VM-uri)** pe aceeași mașină locală. Scopul este să observăm comportamentul IPFS în condiții de rețea instabilă, folosind instrumentul `netem` pentru a introduce întârzieri și pierderi de pachete.

---

## Structura proiectului

```
ipfs-experiment/
├── setup_ipfs_node.sh        # Instalează și configurează IPFS pe fiecare nod
├── run_experiment.sh         # Adaugă fișier în IPFS și salvează CID
├── measure.sh                # Măsoară timpul de descărcare a fișierului
├── netem_simulate.sh         # Simulează condiții de rețea instabilă (delay și loss)
├── cleanup.sh                # Oprește daemon-ul IPFS și curăță fișiere temporare
└── results/                  # Folder pentru loguri și fișiere generate
    ├── cid.txt              # CID-ul fișierului adăugat
    ├── ipfs_info.txt        # Informații nod IPFS (PeerID, IP)
    └── download_time.txt    # Timp descărcare fișier
```

---

## Pași pentru rulare

### 1. Setup IPFS pe fiecare VM

Pe **fiecare VM**:

```bash
chmod +x setup_ipfs_node.sh
./setup_ipfs_node.sh
```

Acest script va instala IPFS (dacă nu e deja instalat), va inițializa nodul și va porni daemonul IPFS în background. Informațiile nodului (PeerID și IP) vor fi salvate în `results/ipfs_info.txt`.

---

### 2. Conectarea nodurilor

- Din VM1, obține IP-ul și PeerID din `results/ipfs_info.txt`.
- În VM2, execută:

```bash
ipfs swarm connect /ip4/<IP_VM1>/tcp/4001/p2p/<PeerID_VM1>
```

- Din VM2, obține IP-ul și PeerID la fel.
- În VM1, execută:

```bash
ipfs swarm connect /ip4/<IP_VM2>/tcp/4001/p2p/<PeerID_VM2>
```

Astfel nodurile se vor conecta în rețea.

---

### 3. Adaugă fișierul pe VM1

În VM1:

```bash
chmod +x run_experiment.sh
./run_experiment.sh
```

Acest script adaugă un fișier test în IPFS și salvează CID-ul în `results/cid.txt`.

---

### 4. Testează propagarea pe VM2

În VM2:

```bash
chmod +x measure.sh
./measure.sh
```

Acest script va descărca fișierul folosind CID-ul generat de VM1 și va măsura timpul de descărcare.

---

### 5. Simulează rețea instabilă

Pe VM1 sau VM2 (în funcție de care vrei să testezi instabilitatea):

```bash
chmod +x netem_simulate.sh
sudo ./netem_simulate.sh
```

Acest script va introduce delay și pierderi de pachete pe interfața de rețea (implicit `eth0`). Poți modifica interfața în script dacă folosești altceva (ex: `wlan0`).

---

### 6. Curățare

După experiment:

```bash
chmod +x cleanup.sh
./cleanup.sh
```

Oprește daemonul IPFS și curăță fișierele temporare.

---

## Observații importante

- Asigură-te că VM-urile pot comunica pe portul TCP `4001`.
- Dacă VM-urile sunt pe rețele NAT diferite, configurează port forwarding sau folosește rețele bridged.
- Folosește `ip addr` și `ip route` pentru a verifica adresele și interfețele de rețea.
- Pentru măsurători corecte, sincronizează ceasurile VM-urilor (ex: cu `ntp`).

---

## Resurse utile

- [Documentație oficială IPFS](https://docs.ipfs.tech/)
- [netem Linux traffic control](https://man7.org/linux/man-pages/man8/tc-netem.8.html)
