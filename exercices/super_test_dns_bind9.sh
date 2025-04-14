#!/bin/bash

echo "==================================================================="
echo " 🧪 SCRIPT DE DIAGNOSTIC AVANCÉ - DNS BIND9 & RÉSEAU (SUPER COMPLET)"
echo "==================================================================="
echo ""

# Vérification du service
echo "🔧 [1] État du service BIND9"
echo "-------------------------------------------------------------------"
systemctl status bind9 | grep -E 'Loaded:|Active:'
echo ""

# Logs récents du service
echo "🗒️  [2] Derniers journaux système de BIND9"
echo "-------------------------------------------------------------------"
journalctl -u bind9 --no-pager -n 20
echo ""

# Fichiers de configuration
echo "📂 [3] Fichiers de configuration : named.conf & zone ns.local"
echo "-------------------------------------------------------------------"
named-checkconf /etc/bind/named.conf
named-checkzone ns.local /etc/bind/db.ns.local
echo ""

# Ports écoutés (ss)
echo "📡 [4] Ports écoutés (ss -tulnp)"
echo "-------------------------------------------------------------------"
ss -tulnp | grep :53
echo ""

# Ports écoutés (netstat)
echo "📡 [5] Ports écoutés (netstat -tulnp)"
echo "-------------------------------------------------------------------"
netstat -tulnp | grep :53
echo ""

# Processus utilisant le port 53
echo "🔍 [6] Processus utilisant le port 53 (lsof)"
echo "-------------------------------------------------------------------"
lsof -i :53
echo ""

# Scan de ports locaux (nmap)
echo "🛰️  [7] Scan de ports sur localhost avec Nmap"
echo "-------------------------------------------------------------------"
nmap -p 53 127.0.0.1
echo ""

# Résolution DNS avec dig
echo "🔎 [8] Tests DNS avec dig"
echo "-------------------------------------------------------------------"
hostnames=("ns.local" "dns.ns.local" "pop3.ns.local" "imap.ns.local" "mail.ns.local" "smtp.ns.local")
for name in "${hostnames[@]}"
do
  echo ""
  echo ">>> dig $name"
  dig $name
done

# Résolution DNS courte
echo ""
echo "📌 Résumé court des réponses DNS (dig +short)"
echo "-------------------------------------------------------------------"
for name in "${hostnames[@]}"
do
  echo "$name:"
  dig $name +short
done

# Trace DNS
echo ""
echo "📍 Trace DNS vers ns.local"
echo "-------------------------------------------------------------------"
dig +trace ns.local

# Reverse DNS
echo ""
echo "↩️  Reverse DNS sur 192.168.2.10"
echo "-------------------------------------------------------------------"
dig -x 192.168.2.10 +short

# Fichier resolv.conf
echo ""
echo "📝 [9] Contenu de /etc/resolv.conf"
echo "-------------------------------------------------------------------"
cat /etc/resolv.conf

# Interfaces réseau
echo ""
echo "🌐 [10] Interfaces réseau et IP"
echo "-------------------------------------------------------------------"
ip a | grep inet

echo ""
echo "✅ Script terminé avec succès. Tous les diagnostics ont été effectués."
