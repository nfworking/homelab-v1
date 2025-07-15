# 🏡 Homelab Infrastructure Documentation

Welcome to the documentation for my homelab setup. This system is designed for learning, experimentation, service hosting, and development. The infrastructure currently spans four physical machines with a combination of Proxmox, Windows Server, Alpine Linux (for Docker), and macOS/Windows dual-boot environments.

---

## 🌐 Network Overview

- **Subnet:** `192.168.1.0/24`
- **Default Gateway:** `192.168.1.36` (Windows Server)
- **DNS Domain (optional):** `lab.local`
- **Reserved IP Ranges:**
  - Machine 1: `192.168.1.20 - 192.168.1.28`
  - Machine 2: `192.168.1.29 - 192.168.1.35`
  - Machine 3: `192.168.1.36`
  - Machine 4: `192.168.1.37`

---

## 🖥️ Machines

### Machine 1 – Proxmox Host 01

- **OS:** Proxmox VE
- **Specs:** 16GB RAM, 4 cores (4 threads), 220GB storage, No GPU
- **IP Range:** `192.168.1.20 - 192.168.1.28`

#### 🔹 Virtual Machine: Docker Server 01

- **OS:** Alpine Linux
- **Specs:** 4.6GB RAM, 2 cores, 64GB storage, No GPU
- **IP:** `192.168.1.21`
- **Purpose:** Central container server for services
- **Hosted Services:**
  - **Grafana:** Monitoring and dashboards
  - **Loki:** Centralized log aggregation
  - **GitLab:** Git repository and CI/CD
  - **Traefik:** Reverse proxy with ACME integration
  - **Homepage:** Homelab dashboard
  - **Prometheus:** Time-series data and metrics

---

### Machine 2 – Proxmox Host 02

- **OS:** Proxmox VE
- **Specs:** 16GB RAM, 4 cores (4 threads), 220GB storage, No GPU
- **IP Range:** `192.168.1.29 - 192.168.1.35`
- **Status:** Reserved for future VM deployments and services

---

### Machine 3 – Windows Server

- **OS:** Windows Server (full GUI)
- **Specs:** 16GB RAM, 4 cores (4 threads), AMD R5 340X GPU, 220GB storage
- **IP:** `192.168.1.36`
- **Services:**
  - **Routing and Remote Access:** VPN and internal routing
  - **Default Gateway:** Network gateway for all homelab machines
  - **.NET Builder Environment:** Development and build tools for .NET apps

---

### Machine 4 – Mac/Windows Multipurpose

- **OS:** Dual boot macOS + Windows 10/11
- **Specs:** 16GB RAM, 4 cores (4 threads), AMD R5 340X GPU, 220GB storage
- **IP:** `192.168.1.37`
- **Purpose:** General-purpose use, development, gaming

#### macOS Services

- Xcode Development
- macOS-native apps

#### Windows Services

- Gaming and media
- Hyper-V sandbox environments
- Utility tools

---

## 🔧 Recommendations

| Area         | Recommendation |
|--------------|----------------|
| Monitoring   | Deploy Netdata or Node Exporter on all machines |
| Backup       | Use Proxmox Backup Server or Restic for automated VM backup |
| Security     | Set up Tailscale or WireGuard for encrypted remote access |
| DNS          | Add Pi-hole or CoreDNS for local DNS and ad-blocking |
| Storage      | Consider adding external or NAS storage for VM growth |

---

## 🗂️ Future Expansion Plans

- Deploy isolated dev/test networks on **Machine 2**
- Add **Pi-hole**, **Vaultwarden**, or **Nextcloud** as personal services
- Add snapshot automation and alerting to Prometheus + Grafana stack
- Set up GitLab runners for .NET and Python build pipelines

---

## 📌 Notes

- All systems run within a private home environment and are not exposed publicly.
- Docker deployments are managed via `docker-compose` or Portainer (future).
- Firewall rules are configured manually on each host OS or router.

---

## 📎 Related Files

- 📄 [`homelab.json`](./homelab.json) – Full machine and service specification in JSON format
- 🖼️ [`network_diagram.png`](./network_diagram.png) – Visual network diagram
- 🔐 `.env` files and secrets are stored securely on each machine

