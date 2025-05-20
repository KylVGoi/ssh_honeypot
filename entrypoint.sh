#!/bin/bash

echo "[*] Démarrage du SSH ..."

# Fixer les permissions
chown support:support /home/support/.bash_history /home/support/.command_log 2>/dev/null || true

# Lancer SSHD avec logs vers stderr
exec /usr/sbin/sshd -D -e
