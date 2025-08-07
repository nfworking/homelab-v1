#!/bin/sh

# =============================
# Alpine Setup Script for Homelab
# Docker, SSH, Tools, cgroup2, and fstab
# =============================

# === Settings ===
PUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQlgso+mZGZAda9TLrWwZWgguh0m8AbnLWrJ8ZaYEg/G+vWBQlY3OmvC76YonboG3TWGZNLseWjerQAN9N8OQaU/wGWwfaBjSWf6s07pHwltEjyAWjw77Zcbm0B6Xww/oEdBne33FUSes+Ls//SGqycT64IeorMhfq2U8/JaKX+c0gYnlKMRlhkKkC9txRYJe7Ua6CrccvxkgUZ29qw9gEVsZtCzD0OVg5sPx73r+bFGW0NwDE38zbDtuiJDqg/xVROq46oQS6T0gyS98QzsXDaJYtCkwRz1xcjvEKOXlaUsFMKgVoTIGUPxBpeNLW1o76PgnvhNEAPrdWY9oZbZUdBirQkaCms95YyNKtpyiasaZa58yliNm+q5GTBplk7yg0UuXfdP7rrLZgZnqpBPTuxZxmw5MXD25Z1iREIXItNz3XwffaaubztwrtUL373rjp9Gw6iaDP2Ixvob3efKLctBR3fFy8TLH+KgLgD/rUOA3nf203Ya2FWt9k7hjQxC2VER5K+bQ66ChX/gcaTXG8y9xdTY97FfTMqvlZ3yYuqI1j0Npv3IYPHedx5iPhn21LKvLnmouC0ciEqQx/iNqXjDPxR0c8pq8kXBxPPFNJupflomRT6f5o/0AOjlTyNtHXAxJwgLlJBSxpioajPduBTdfXjQQU18/hNkKKh68t0Q== tidalfarmer1432@outlook.com"

# === Enable Community Repo ===
echo "[+] Enabling community repository..."
REPOFILE="/etc/apk/repositories"
sed -i 's/^#//' $REPOFILE
if ! grep -q "community" "$REPOFILE"; then
    echo "http://dl-cdn.alpinelinux.org/alpine/v$(cut -d. -f1,2 /etc/alpine-release)/community" >> $REPOFILE
fi

# === Update APK ===
echo "[+] Updating packages..."
apk update

# === Install Packages ===
echo "[+] Installing Docker, Nano, Git, Btop, OpenSSH..."
apk add docker nano git btop openssh

# === Enable Docker ===
echo "[+] Enabling Docker on boot..."
rc-update add docker boot
service docker start

# === Enable SSH ===
echo "[+] Enabling SSH on boot..."
rc-update add sshd boot
service sshd start

# === Setup SSH Key ===
echo "[+] Configuring SSH key for root login..."
mkdir -p /root/.ssh
echo "$PUBKEY" > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh

# === Optional: Disable password auth (hardened SSH) ===
echo "[+] Hardening SSH config..."
sed -i 's/#PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
service sshd restart

# === Mount cgroup2 Now ===
echo "[+] Mounting cgroup2 now..."
mkdir -p /sys/fs/cgroup/unified
mount -t cgroup2 none /sys/fs/cgroup/unified

# === Add to fstab ===
echo "[+] Ensuring cgroup2 mount in fstab..."
if ! grep -q "cgroup2" /etc/fstab; then
    echo "none /sys/fs/cgroup/unified cgroup2 defaults 0 0" >> /etc/fstab
fi

# === Add current user to Docker group ===
CURRENT_USER=$(whoami)
if [ "$CURRENT_USER" != "root" ]; then
    echo "[+] Adding user '$CURRENT_USER' to docker group..."
    addgroup "$CURRENT_USER" docker
    echo "[!] You may need to log out and back in for group permissions to apply."
fi
# === Install Docker Compose Plugin ===
echo "[+] Installing Docker Compose plugin..."
apk add docker-compose-plugin


echo "[✅] Setup complete. Docker and SSH are ready."
