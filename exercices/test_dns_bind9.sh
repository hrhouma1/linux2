#!/bin/bash

echo "=== TEST DE RESOLUTION DNS - BIND9 ==="

# Tester les résolutions de noms
declare -a hostnames=("ns.local" "dns.ns.local" "pop3.ns.local" "mail.ns.local" "smtp.ns.local")

echo ""
echo "===> Test de ping :"
for name in "${hostnames[@]}"
do
    echo ""
    echo ">>> ping $name"
    ping -c 3 $name
done

echo ""
echo "===> Test de dig :"
for name in "${hostnames[@]}"
do
    echo ""
    echo ">>> dig $name"
    dig $name +short
done

echo ""
echo "===> Contenu de /etc/resolv.conf :"
cat /etc/resolv.conf

echo ""
echo "===> Adresse IP de l'interface (pour vérifier l'accès au réseau) :"
ip a | grep inet
