#!/bin/bash

echo "=================================================="
echo "     🔍 SCRIPT DE TEST EXHAUSTIF - DNS BIND9"
echo "=================================================="

# Vérification du service BIND9
echo ""
echo "🔄 État du service BIND9 :"
systemctl status bind9 | grep -E 'Active:|Loaded:'

# Vérification des ports utilisés (53)
echo ""
echo "🔌 Ports écoutés par BIND9 (port 53) :"
ss -tulnp | grep :53

# Test de configuration syntaxique
echo ""
echo "🔍 Vérification syntaxique du fichier /etc/bind/named.conf :"
named-checkconf /etc/bind/named.conf
echo "🔍 Vérification syntaxique de la zone ns.local :"
named-checkzone ns.local /etc/bind/db.ns.local

# Liste des noms DNS à tester
hostnames=("ns.local" "dns.ns.local" "pop.ns.local" "pop3.ns.local" "mail.ns.local" "imap.ns.local" "smtp.ns.local")

# Résolution avec ping
echo ""
echo "=================================================="
echo "           📡 TESTS DE PING (CONNECTIVITÉ)"
echo "=================================================="
for name in "${hostnames[@]}"
do
  echo ""
  echo ">>> ping -c 3 $name"
  ping -c 3 $name
done

# Résolution DNS avec dig (classique +short +trace)
echo ""
echo "=================================================="
echo "        🧠 TESTS DE RESOLUTION DNS (dig)"
echo "=================================================="
for name in "${hostnames[@]}"
do
  echo ""
  echo ">>> dig $name"
  dig $name
done

echo ""
echo ">>> Résumé court (dig +short)"
for name in "${hostnames[@]}"
do
  echo "$name:"
  dig $name +short
done

echo ""
echo ">>> Tracé DNS (dig +trace)"
dig ns.local +trace

# Contenu de /etc/resolv.conf
echo ""
echo "=================================================="
echo "        📝 CONTENU DE /etc/resolv.conf"
echo "=================================================="
cat /etc/resolv.conf

# Liste des interfaces actives
echo ""
echo "=================================================="
echo "      🌐 INTERFACES RÉSEAU (IP + CONNECTIVITÉ)"
echo "=================================================="
ip a | grep inet

# Test de port DNS sur localhost avec dig
echo ""
echo "=================================================="
echo "    📦 TEST DE DNS EN LOCALHOST (127.0.0.1#53)"
echo "=================================================="
dig @127.0.0.1 ns.local

echo ""
echo "✅ Tous les tests sont terminés."
