#!/bin/bash

echo "========================================================================="
echo " 🔍 SUPER SCRIPT DE DIAGNOSTIC DNS BIND9 - VERSION PÉDAGOGIQUE & EXHAUSTIVE"
echo "========================================================================="
echo ""

# 1. État du service
echo "🔧 [1] ÉTAT DU SERVICE BIND9"
echo "-------------------------------------------------------------------------"
systemctl status bind9
echo ""

# 2. Journal du service
echo "🗒️  [2] JOURNAL DU SERVICE (journalctl)"
echo "-------------------------------------------------------------------------"
journalctl -u bind9 -n 50
echo ""

# 3. Validation de configuration
echo "✅ [3] VALIDATION DES FICHIERS DE CONFIGURATION"
echo "-------------------------------------------------------------------------"
named-checkconf /etc/bind/named.conf
named-checkzone ns.local /etc/bind/db.ns.local
echo ""

# 4. Fichier /etc/resolv.conf
echo "📄 [4] CONTENU DU FICHIER /etc/resolv.conf"
echo "-------------------------------------------------------------------------"
cat /etc/resolv.conf
echo ""

# 5. Processus & Ports (ss, lsof, netstat)
echo "🧩 [5] PROCESSUS & PORTS UTILISÉS"
echo "-------------------------------------------------------------------------"
echo "👉 ss -tulnp | grep :53"
ss -tulnp | grep :53
echo ""
echo "👉 lsof -i :53"
lsof -i :53
echo ""
echo "👉 netstat -tulnp | grep :53"
netstat -tulnp | grep :53
echo ""

# 6. Interfaces réseau
echo "🌐 [6] INTERFACES RÉSEAU ET IP"
echo "-------------------------------------------------------------------------"
ip a
echo ""

# 7. Nmap : scan de ports DNS
echo "🛰️  [7] SCAN DE PORTS DNS (nmap)"
echo "-------------------------------------------------------------------------"
nmap -p 53 127.0.0.1
echo ""

# 8. Résolutions DNS classiques avec dig
echo "🔎 [8] TESTS DIG STANDARD"
echo "-------------------------------------------------------------------------"
domains=("ns.local" "dns.ns.local" "pop.ns.local" "pop3.ns.local" "imap.ns.local" "mail.ns.local" "smtp.ns.local")

for domain in "${domains[@]}"
do
  echo ""
  echo ">>> dig $domain"
  dig $domain
  echo ">>> dig $domain +short"
  dig $domain +short
  echo ">>> dig $domain ANY"
  dig $domain ANY
done

# 9. Tests avec dig avancé
echo ""
echo "📌 [9] TESTS DIG AVANCÉS"
echo "-------------------------------------------------------------------------"
echo ">>> dig @127.0.0.1 ns.local"
dig @127.0.0.1 ns.local
echo ""

echo ">>> dig @localhost ns.local +short"
dig @localhost ns.local +short
echo ""

echo ">>> dig mail.ns.local MX"
dig mail.ns.local MX
echo ""

echo ">>> dig mail.ns.local A +noall +answer +stats"
dig mail.ns.local A +noall +answer +stats
echo ""

echo ">>> dig mail.ns.local +trace"
dig mail.ns.local +trace
echo ""

# 10. Résolution inversée
echo ""
echo "↩️  [10] RÉSOLUTIONS INVERSÉES (REVERSE DNS)"
echo "-------------------------------------------------------------------------"
dig -x 192.168.2.10
dig -x 127.0.0.1
echo ""

# 11. Analyse complète des sockets (lsof)
echo "🔬 [11] LSOF - SOCKETS DNS"
echo "-------------------------------------------------------------------------"
lsof -nP -iUDP:53
lsof -nP -iTCP:53
echo ""

# 12. Autres outils pédagogiques
echo "📚 [12] AUTRES COMMANDES UTILES POUR APPRENDRE"
echo "-------------------------------------------------------------------------"
echo "👉 systemctl list-unit-files | grep bind"
systemctl list-unit-files | grep bind
echo ""
echo "👉 ps aux | grep named"
ps aux | grep named
echo ""
echo "👉 resolvectl status"
resolvectl status
echo ""

echo "✅ FIN DU DIAGNOSTIC - SCRIPT EXÉCUTÉ AVEC SUCCÈS"
