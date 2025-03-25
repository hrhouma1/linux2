
Je vais inclure :  
- **Sécurité réseau (iptables, firewalld)**  
- **Monitoring réseau (ss, netstat, iftop)**  
- **Détection des connexions lentes ou instables**  
- **Analyse avancée des paquets avec tcpdump**  

Je commence maintenant. Ça arrive.

### Guide Complet de Dépannage Réseau pour Ubuntu Server

#### Introduction
Ce guide couvre toutes les commandes nécessaires pour diagnostiquer, dépanner, configurer et sécuriser les interfaces réseau sur Ubuntu Server. Les commandes sont organisées par catégories pour un dépannage rapide et efficace.

---

## 1. Vérification des Interfaces Réseau

| Action                                   | Commande                        | Description                                                  |
|-----------------------------------------|---------------------------------|--------------------------------------------------------------|
| Lister toutes les interfaces réseau     | `ip a`                          | Affiche toutes les interfaces réseau et leurs IP actuelles.  |
| Afficher les interfaces configurées     | `ifconfig -a`                   | Liste toutes les interfaces réseau, même désactivées.       |
| Lister les interfaces réseau physiques  | `ls /sys/class/net/`            | Affiche les interfaces disponibles sur le système.          |
| Voir les interfaces manquantes          | `dmesg | grep -i eth`           | Recherche les messages concernant les cartes réseau.        |
| Vérifier l’état d’une interface         | `ip link show enp0s8`           | Montre les détails d’une interface spécifique.              |
| Voir les logs réseau                    | `journalctl -u networking`      | Affiche les journaux du service réseau.                     |
| Vérifier les modules réseau chargés     | `lsmod | grep e1000`            | Vérifie si le module de l'interface réseau est chargé.       |
| Scanner les matériels PCI               | `lspci | grep -i ethernet`      | Affiche les cartes réseau détectées sur le bus PCI.         |
| Vérifier les erreurs dans les logs      | `dmesg | grep enp0s8`           | Recherche les erreurs spécifiques liées à une interface.    |
| Analyser les erreurs du noyau           | `journalctl -k`                 | Affiche tous les messages du noyau, y compris ceux du réseau.|
| Diagnostiquer les interruptions réseau  | `ethtool -S enp0s8`             | Affiche les statistiques détaillées d'une interface.        |
| Vérifier la connectivité DNS            | `dig google.com`                | Vérifie si le serveur DNS répond correctement.              |
| Résoudre un nom DNS                     | `nslookup google.com`           | Permet de vérifier la résolution DNS d'un nom de domaine.   |

---

## 2. Activation et Configuration des Interfaces

| Action                                    | Commande                                         | Description                                                 |
|------------------------------------------|--------------------------------------------------|-------------------------------------------------------------|
| Activer une interface réseau             | `sudo ip link set enp0s8 up`                    | Active une interface réseau spécifique.                     |
| Désactiver une interface réseau          | `sudo ip link set enp0s8 down`                  | Désactive une interface réseau.                             |
| Attribuer une IP statique                | `sudo ip addr add 192.168.56.100/24 dev enp0s8` | Assigne une adresse IP statique à une interface.            |
| Supprimer une IP d’une interface         | `sudo ip addr del 192.168.56.100/24 dev enp0s8` | Supprime une adresse IP d’une interface.                   |
| Ajouter une route par défaut            | `sudo ip route add default via 192.168.56.1`    | Définit la passerelle par défaut.                          |
| Supprimer une route par défaut          | `sudo ip route del default`                     | Supprime la route par défaut.                              |
| Recharger la configuration réseau       | `sudo netplan apply`                            | Applique les modifications de configuration Netplan.       |
| Vérifier l’application de Netplan       | `sudo netplan try`                              | Teste la configuration Netplan avant de l'appliquer.       |
| Activer IPv4 sur une interface           | `echo 0 | sudo tee /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4` | Active IPv4 si désactivé.      |
| Activer IPv6 sur une interface           | `echo 0 | sudo tee /proc/sys/net/ipv6/conf/enp0s8/disable_ipv6` | Active IPv6 si désactivé.      |
| Configurer une interface avec DHCP      | `sudo dhclient enp0s8`                          | Force l'interface à obtenir une IP via DHCP.               |
| Voir les configurations Netplan         | `cat /etc/netplan/*.yaml`                      | Affiche toutes les configurations réseau actuelles.       |
| Afficher les tables de routage avancées | `ip route show table all`                      | Affiche toutes les tables de routage configurées.         |

---

## 3. Commandes DHCP

| Action                                | Commande                                      | Description                                                   |
|-------------------------------------|----------------------------------------------|---------------------------------------------------------------|
| Lister les interfaces DHCP actives   | `sudo dhclient -v`                           | Affiche les requêtes DHCP en cours.                           |
| Demander une nouvelle IP via DHCP    | `sudo dhclient enp0s8`                       | Force une requête DHCP pour une interface.                   |
| Relâcher l’adresse IP DHCP           | `sudo dhclient -r enp0s8`                    | Relâche l'adresse IP actuelle attribuée par DHCP.            |
| Recharger le fichier resolv.conf     | `sudo systemctl restart systemd-resolved`    | Recharge les configurations DNS.                            |
| Vérifier les conflits d’IP           | `arping -I enp0s8 192.168.56.100`            | Vérifie si une adresse IP est déjà utilisée sur le réseau.  |

---

## 4. Commandes de Sécurité et Analyse

| Action                               | Commande                                      | Description                                                   |
|-------------------------------------|----------------------------------------------|---------------------------------------------------------------|
| Voir les règles IPtables             | `sudo iptables -L -v`                        | Affiche toutes les règles de filtrage réseau.                 |
| Supprimer une règle IPtables         | `sudo iptables -D INPUT 1`                   | Supprime une règle spécifique par son numéro.                |
| Vérifier l’état de Firewalld         | `sudo systemctl status firewalld`            | Affiche l'état du firewall.                                   |
| Désactiver temporairement Firewalld  | `sudo systemctl stop firewalld`              | Arrête le firewall.                                           |
| Ajouter une règle Firewalld          | `sudo firewall-cmd --add-service=http --permanent` | Ajoute une règle permanente pour le service HTTP.        |
| Appliquer les modifications Firewalld| `sudo firewall-cmd --reload`                 | Recharge la configuration du firewall.                       |
| Scanner les ports ouverts            | `sudo nmap -sT -p- 192.168.56.1`            | Liste tous les ports ouverts sur une machine.                |
| Analyser les paquets réseau          | `sudo tcpdump -i enp0s8`                    | Capture tous les paquets passant par une interface.          |
| Monitorer la bande passante          | `sudo iftop -i enp0s8`                      | Affiche l'utilisation de la bande passante en temps réel.    |
| Voir les connexions actives          | `sudo ss -tulnp`                            | Liste toutes les connexions TCP/UDP ouvertes.                |




### Guide Complet de Dépannage Réseau pour Ubuntu Server

#### Introduction
Ce guide couvre toutes les commandes nécessaires pour diagnostiquer, dépanner, configurer et sécuriser les interfaces réseau sur Ubuntu Server. Les commandes sont organisées par catégories pour un dépannage rapide et efficace.

---

## 1. Vérification des Interfaces Réseau

| Action                                   | Commande                        | Description                                                  |
|-----------------------------------------|---------------------------------|--------------------------------------------------------------|
| Lister toutes les interfaces réseau     | `ip a`                          | Affiche toutes les interfaces réseau et leurs IP actuelles.  |
| Afficher les interfaces configurées     | `ifconfig -a`                   | Liste toutes les interfaces réseau, même désactivées.       |
| Lister les interfaces réseau physiques  | `ls /sys/class/net/`            | Affiche les interfaces disponibles sur le système.          |
| Voir les interfaces manquantes          | `dmesg | grep -i eth`           | Recherche les messages concernant les cartes réseau.        |
| Vérifier l’état d’une interface         | `ip link show enp0s8`           | Montre les détails d’une interface spécifique.              |
| Voir les logs réseau                    | `journalctl -u networking`      | Affiche les journaux du service réseau.                     |
| Vérifier les modules réseau chargés     | `lsmod | grep e1000`            | Vérifie si le module de l'interface réseau est chargé.       |
| Scanner les matériels PCI               | `lspci | grep -i ethernet`      | Affiche les cartes réseau détectées sur le bus PCI.         |
| Vérifier les erreurs dans les logs      | `dmesg | grep enp0s8`           | Recherche les erreurs spécifiques liées à une interface.    |
| Analyser les erreurs du noyau           | `journalctl -k`                 | Affiche tous les messages du noyau, y compris ceux du réseau.|
| Diagnostiquer les interruptions réseau  | `ethtool -S enp0s8`             | Affiche les statistiques détaillées d'une interface.        |
| Vérifier la connectivité DNS            | `dig google.com`                | Vérifie si le serveur DNS répond correctement.              |
| Résoudre un nom DNS                     | `nslookup google.com`           | Permet de vérifier la résolution DNS d'un nom de domaine.   |
| Vérifier le MTU d'une interface         | `ip link show enp0s8`           | Identifie si la taille MTU est incorrecte.                  |
| Tester la latence réseau                | `ping -c 10 8.8.8.8`            | Mesure la latence vers un serveur distant.                  |
| Visualiser l’état du routage            | `ip route show`                 | Affiche les routes réseau configurées.                     |

---

## 2. Activation et Configuration des Interfaces

| Action                                    | Commande                                         | Description                                                 |
|------------------------------------------|--------------------------------------------------|-------------------------------------------------------------|
| Activer une interface réseau             | `sudo ip link set enp0s8 up`                    | Active une interface réseau spécifique.                     |
| Désactiver une interface réseau          | `sudo ip link set enp0s8 down`                  | Désactive une interface réseau.                             |
| Attribuer une IP statique                | `sudo ip addr add 192.168.56.100/24 dev enp0s8` | Assigne une adresse IP statique à une interface.            |
| Supprimer une IP d’une interface         | `sudo ip addr del 192.168.56.100/24 dev enp0s8` | Supprime une adresse IP d’une interface.                   |
| Ajouter une route par défaut             | `sudo ip route add default via 192.168.56.1`    | Définit la passerelle par défaut.                          |
| Supprimer une route par défaut           | `sudo ip route del default`                     | Supprime la route par défaut.                              |
| Recharger la configuration réseau        | `sudo netplan apply`                            | Applique les modifications de configuration Netplan.       |
| Vérifier l’application de Netplan        | `sudo netplan try`                              | Teste la configuration Netplan avant de l'appliquer.       |
| Activer IPv4 sur une interface           | `echo 0 | sudo tee /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4` | Active IPv4 si désactivé.      |
| Activer IPv6 sur une interface           | `echo 0 | sudo tee /proc/sys/net/ipv6/conf/enp0s8/disable_ipv6` | Active IPv6 si désactivé.      |
| Configurer une interface avec DHCP       | `sudo dhclient enp0s8`                          | Force l'interface à obtenir une IP via DHCP.               |
| Voir les configurations Netplan          | `cat /etc/netplan/*.yaml`                      | Affiche toutes les configurations réseau actuelles.       |
| Afficher les tables de routage avancées  | `ip route show table all`                      | Affiche toutes les tables de routage configurées.         |
| Diagnostiquer les conflits de routes     | `ip rule list`                                  | Vérifie les priorités des routes actives.                 |

---

## 3. Commandes d’Analyse Réseau Avancée

| Action                                | Commande                                      | Description                                                   |
|-------------------------------------|----------------------------------------------|---------------------------------------------------------------|
| Scanner les ports ouverts            | `sudo nmap -sT -p- 192.168.56.1`            | Liste tous les ports ouverts sur une machine.                |
| Analyser les paquets réseau          | `sudo tcpdump -i enp0s8`                    | Capture tous les paquets passant par une interface.          |
| Monitorer la bande passante          | `sudo iftop -i enp0s8`                      | Affiche l'utilisation de la bande passante en temps réel.    |
| Voir les connexions actives          | `sudo ss -tulnp`                            | Liste toutes les connexions TCP/UDP ouvertes.                |
| Diagnostiquer les connexions lentes  | `mtr 8.8.8.8`                               | Trace route et affiche la perte de paquets.                  |
| Filtrer les paquets spécifiques      | `sudo tcpdump -i enp0s8 port 80`            | Capture les paquets HTTP uniquement.                        |
| Sauvegarder une capture réseau       | `sudo tcpdump -i enp0s8 -w capture.pcap`    | Sauvegarde le trafic réseau dans un fichier.                 |
| Lire une capture réseau              | `tcpdump -r capture.pcap`                   | Lit un fichier de capture réseau.                           |





# Guide Complet de Dépannage Réseau pour Ubuntu Server

## Introduction
Ce guide couvre toutes les commandes nécessaires pour diagnostiquer, dépanner, configurer et sécuriser les interfaces réseau sur Ubuntu Server. Les commandes sont organisées par catégories pour un dépannage rapide et efficace.

---

## 1. Vérification des Interfaces Réseau

| Action                                   | Commande                        | Description                                                  |
|-----------------------------------------|---------------------------------|--------------------------------------------------------------|
| Lister toutes les interfaces réseau     | `ip a`                          | Affiche toutes les interfaces réseau et leurs IP actuelles.  |
| Afficher les interfaces configurées     | `ifconfig -a`                   | Liste toutes les interfaces réseau, même désactivées.        |
| Lister les interfaces réseau physiques  | `ls /sys/class/net/`            | Affiche les interfaces disponibles sur le système.           |
| Voir les interfaces manquantes          | `dmesg | grep -i eth`           | Recherche les messages concernant les cartes réseau.         |
| Vérifier l’état d’une interface         | `ip link show enp0s8`           | Montre les détails d’une interface spécifique.               |
| Voir les logs réseau                    | `journalctl -u networking`      | Affiche les journaux du service réseau.                      |
| Vérifier les modules réseau chargés     | `lsmod | grep e1000`            | Vérifie si le module de l'interface réseau est chargé.        |
| Scanner les matériels PCI               | `lspci | grep -i ethernet`      | Affiche les cartes réseau détectées sur le bus PCI.          |
| Vérifier les erreurs dans les logs      | `dmesg | grep enp0s8`           | Recherche les erreurs spécifiques liées à une interface.     |
| Analyser les erreurs du noyau           | `journalctl -k`                 | Affiche tous les messages du noyau, y compris ceux du réseau. |
| Diagnostiquer les interruptions réseau  | `ethtool -S enp0s8`             | Affiche les statistiques détaillées d'une interface.         |
| Vérifier la connectivité DNS            | `dig google.com`                | Vérifie si le serveur DNS répond correctement.               |
| Résoudre un nom DNS                     | `nslookup google.com`           | Permet de vérifier la résolution DNS d'un nom de domaine.    |
| Vérifier le MTU d'une interface         | `ip link show enp0s8`           | Identifie si la taille MTU est incorrecte.                   |
| Tester la latence réseau                | `ping -c 10 8.8.8.8`            | Mesure la latence vers un serveur distant.                   |
| Visualiser l’état du routage            | `ip route show`                 | Affiche les routes réseau configurées.                      |

---

## 2. Activation et Configuration des Interfaces

| Action                                    | Commande                                         | Description                                                 |
|------------------------------------------|--------------------------------------------------|-------------------------------------------------------------|
| Activer une interface réseau             | `sudo ip link set enp0s8 up`                    | Active une interface réseau spécifique.                     |
| Désactiver une interface réseau          | `sudo ip link set enp0s8 down`                  | Désactive une interface réseau.                             |
| Attribuer une IP statique                | `sudo ip addr add 192.168.56.100/24 dev enp0s8` | Assigne une adresse IP statique à une interface.            |
| Supprimer une IP d’une interface         | `sudo ip addr del 192.168.56.100/24 dev enp0s8` | Supprime une adresse IP d’une interface.                   |
| Ajouter une route par défaut             | `sudo ip route add default via 192.168.56.1`    | Définit la passerelle par défaut.                          |
| Supprimer une route par défaut           | `sudo ip route del default`                     | Supprime la route par défaut.                              |
| Recharger la configuration réseau        | `sudo netplan apply`                            | Applique les modifications de configuration Netplan.       |
| Vérifier l’application de Netplan        | `sudo netplan try`                              | Teste la configuration Netplan avant de l'appliquer.       |
| Activer IPv4 sur une interface           | `echo 0 | sudo tee /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4` | Active IPv4 si désactivé.      |
| Activer IPv6 sur une interface           | `echo 0 | sudo tee /proc/sys/net/ipv6/conf/enp0s8/disable_ipv6` | Active IPv6 si désactivé.      |
| Configurer une interface avec DHCP       | `sudo dhclient enp0s8`                          | Force l'interface à obtenir une IP via DHCP.               |
| Voir les configurations Netplan          | `cat /etc/netplan/*.yaml`                      | Affiche toutes les configurations réseau actuelles.       |
| Afficher les tables de routage avancées  | `ip route show table all`                      | Affiche toutes les tables de routage configurées.         |
| Diagnostiquer les conflits de routes     | `ip rule list`                                  | Vérifie les priorités des routes actives.                 |

---

## 3. Commandes d’Analyse Réseau Avancée

| Action                                | Commande                                      | Description                                                   |
|-------------------------------------|----------------------------------------------|---------------------------------------------------------------|
| Scanner les ports ouverts            | `sudo nmap -sT -p- 192.168.56.1`            | Liste tous les ports ouverts sur une machine.                |
| Analyser les paquets réseau          | `sudo tcpdump -i enp0s8`                    | Capture tous les paquets passant par une interface.          |
| Monitorer la bande passante          | `sudo iftop -i enp0s8`                      | Affiche l'utilisation de la bande passante en temps réel.    |
| Voir les connexions actives          | `sudo ss -tulnp`                            | Liste toutes les connexions TCP/UDP ouvertes.                |
| Diagnostiquer les connexions lentes  | `mtr 8.8.8.8`                               | Trace route et affiche la perte de paquets.                  |
| Filtrer les paquets spécifiques      | `sudo tcpdump -i enp0s8 port 80`            | Capture les paquets HTTP uniquement.                        |
| Sauvegarder une capture réseau       | `sudo tcpdump -i enp0s8 -w capture.pcap`    | Sauvegarde le trafic réseau dans un fichier.                 |
| Lire une capture réseau              | `tcpdump -r capture.pcap`                   | Lit un fichier de capture réseau.                           |
| Analyser les paquets DNS             | `sudo tcpdump -i enp0s8 port 53`           | Affiche uniquement le trafic DNS.                           |
| Diagnostiquer un conflit IP          | `arping -I enp0s8 192.168.56.100`           | Vérifie si une adresse IP est déjà utilisée.               |





### 4. Commandes de Sécurité Réseau (Iptables, Firewalld, etc.)

| Action                                   | Commande                                            | Description                                                      |
|-----------------------------------------|-----------------------------------------------------|------------------------------------------------------------------|
| Voir les règles Iptables                 | `sudo iptables -L -v`                               | Affiche toutes les règles de filtrage réseau actuelles.         |
| Ajouter une règle d'autorisation         | `sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT`| Permet l'accès SSH sur le port 22.                               |
| Supprimer une règle Iptables             | `sudo iptables -D INPUT 1`                          | Supprime une règle par son numéro.                              |
| Sauvegarder les règles Iptables          | `sudo iptables-save > /etc/iptables/rules.v4`       | Sauvegarde les règles actuelles.                                 |
| Charger des règles Iptables              | `sudo iptables-restore < /etc/iptables/rules.v4`    | Charge des règles sauvegardées.                                  |
| Vérifier l’état de Firewalld             | `sudo systemctl status firewalld`                   | Affiche l'état du firewall.                                      |
| Lister les services autorisés Firewalld | `sudo firewall-cmd --list-all`                      | Liste les services autorisés par Firewalld.                     |
| Ajouter une règle Firewalld              | `sudo firewall-cmd --add-service=http --permanent`  | Autorise le trafic HTTP (port 80) de manière permanente.        |
| Appliquer les modifications Firewalld    | `sudo firewall-cmd --reload`                        | Recharge la configuration du firewall.                          |
| Désactiver temporairement Firewalld      | `sudo systemctl stop firewalld`                     | Arrête le firewall.                                              |
| Redémarrer Firewalld                     | `sudo systemctl restart firewalld`                  | Relance le firewall.                                             |

---

### 5. Commandes pour Diagnostiquer la Connectivité Intermittente

| Action                                  | Commande                                       | Description                                                      |
|----------------------------------------|------------------------------------------------|------------------------------------------------------------------|
| Surveiller les paquets perdus           | `ping -i 0.2 -c 100 8.8.8.8`                  | Teste la connectivité en envoyant un grand nombre de paquets.    |
| Tracer le chemin réseau (Traceroute)    | `traceroute 8.8.8.8`                          | Affiche chaque routeur traversé jusqu'à la destination.          |
| Détection de paquets abandonnés         | `sudo tcpdump -i enp0s8 icmp`                 | Capture les messages ICMP pour détecter les erreurs réseau.      |
| Visualiser les paquets réseau perdus    | `sudo mtr -r 8.8.8.8`                         | Affiche le taux de perte de paquets par hôte traversé.           |
| Identifier les goulots d'étranglement   | `sudo iftop -i enp0s8`                       | Surveille l'utilisation de la bande passante en temps réel.      |
| Diagnostiquer les connexions TCP        | `sudo ss -t -a`                                | Liste toutes les connexions TCP, même en état d'écoute.          |

---

### 6. Commandes pour Optimiser les Performances Réseau

| Action                                    | Commande                                            | Description                                                  |
|------------------------------------------|-----------------------------------------------------|--------------------------------------------------------------|
| Modifier la taille du MTU                 | `sudo ip link set enp0s8 mtu 1400`                  | Change la taille maximale des paquets sur une interface.     |
| Vérifier les files d'attente réseau       | `tc qdisc show dev enp0s8`                          | Affiche la configuration actuelle de contrôle du trafic.     |
| Activer le TSO (TCP Segmentation Offload) | `sudo ethtool -K enp0s8 tso on`                     | Améliore les performances en activant l'offload TCP.         |
| Activer le GSO (Generic Segmentation Offload)| `sudo ethtool -K enp0s8 gso on`                    | Améliore la performance en activant l'agrégation de paquets.  |
| Activer la compression de paquets         | `sudo ethtool -K enp0s8 tx on`                      | Réduit la bande passante utilisée en activant la compression. |
| Monitorer les performances réseau         | `sudo bmon`                                          | Affiche un graphique en temps réel de l'utilisation réseau.   |
| Optimiser les buffers réseau              | `sudo sysctl -w net.core.rmem_max=16777216`         | Augmente la taille maximale des buffers de réception.        |
| Activer le jumbo frames (si compatible)   | `sudo ip link set enp0s8 mtu 9000`                  | Améliore la bande passante en augmentant la taille du MTU.    |

---

### 7. Commandes Spéciales pour la Surveillance Réseau

| Action                            | Commande                                              | Description                                                 |
|----------------------------------|-------------------------------------------------------|-------------------------------------------------------------|
| Liste des connexions réseau       | `sudo ss -tulwn`                                       | Affiche toutes les connexions réseau actives.              |
| Visualisation en temps réel       | `sudo nload`                                           | Affiche la bande passante en cours d'utilisation.           |
| Suivre une IP spécifique          | `sudo tcpdump -i enp0s8 host 192.168.56.1`            | Capture le trafic provenant ou destiné à une IP spécifique. |
| Détection de scans réseau         | `sudo tcpdump -i enp0s8 port 22`                      | Détecte les connexions SSH suspectes.                      |
| Surveillance avec IPTraf          | `sudo iptraf-ng`                                       | Affiche les statistiques réseau par protocole.              |
| Monitorer les paquets DNS         | `sudo tcpdump -i enp0s8 port 53`                      | Capture uniquement le trafic DNS.                          |
| Détecter des attaques DDoS        | `sudo iptables -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT` | Limite les connexions TCP pour prévenir les attaques.  |

---


- Des **exemples concrets d'utilisation pour chaque catégorie** ?  
- Des **méthodes de résolution spécifiques pour les problèmes courants (DNS, DHCP, IP, Routage)** ?  
- Des **commandes supplémentaires pour analyser la performance réseau en profondeur** ?  





### 8. Exemples Concrets de Dépannage Réseau

---

#### **A. Problèmes de Connexion Réseau Intermittente (Paquets Perdus / Lenteur)**

1. **Détecter les paquets perdus :**
   ```bash
   ping -i 0.2 -c 100 8.8.8.8
   ```
   - Envoie 100 paquets avec un intervalle de 0,2 seconde pour mesurer la perte de paquets.

2. **Suivi en temps réel des routes et des pertes :**
   ```bash
   mtr -r 8.8.8.8
   ```
   - Affiche un rapport détaillé sur chaque routeur traversé.

3. **Capture des paquets suspects :**
   ```bash
   sudo tcpdump -i enp0s8 -w capture.pcap
   ```
   - Sauvegarde tout le trafic réseau pour une analyse ultérieure.

---

#### **B. Problèmes DNS (Résolution de Noms Défaillante)**

1. **Vérifier la configuration DNS actuelle :**
   ```bash
   cat /etc/resolv.conf
   ```
   - Montre les serveurs DNS configurés.

2. **Tester la résolution DNS :**
   ```bash
   dig google.com
   ```
   ou 
   ```bash
   nslookup google.com
   ```

3. **Vérifier si les paquets DNS sont bloqués :**
   ```bash
   sudo tcpdump -i enp0s8 port 53
   ```
   - Capture tout le trafic DNS en cours.

4. **Forcer un serveur DNS spécifique :**
   ```bash
   dig @8.8.8.8 google.com
   ```
   - Interroge directement un serveur DNS public (Google DNS).

---

#### **C. Problèmes DHCP (Aucune IP attribuée)**

1. **Forcer la demande d'une nouvelle IP :**
   ```bash
   sudo dhclient -v enp0s8
   ```
   - Tente de renouveler l'adresse IP en utilisant DHCP.

2. **Relâcher l’adresse IP actuelle :**
   ```bash
   sudo dhclient -r enp0s8
   ```

3. **Analyser le trafic DHCP :**
   ```bash
   sudo tcpdump -i enp0s8 port 67 or port 68
   ```
   - Capture les requêtes et réponses DHCP pour voir si le serveur répond correctement.

---

#### **D. Problèmes de Routage (Accès Internet Impossible)**

1. **Vérifier les routes actives :**
   ```bash
   ip route show
   ```

2. **Ajouter une route par défaut manuellement :**
   ```bash
   sudo ip route add default via 192.168.56.1
   ```

3. **Supprimer une route incorrecte :**
   ```bash
   sudo ip route del default
   ```

4. **Vérifier les tables de routage :**
   ```bash
   ip route show table all
   ```
   - Affiche toutes les tables de routage actives.

---

#### **E. Optimisation des Performances Réseau**

1. **Changer le MTU pour améliorer la vitesse :**
   ```bash
   sudo ip link set enp0s8 mtu 1400
   ```
   - Réduit la taille maximale des paquets si des problèmes de fragmentation sont détectés.

2. **Activer les fonctionnalités avancées :**
   ```bash
   sudo ethtool -K enp0s8 tso on
   sudo ethtool -K enp0s8 gso on
   ```

3. **Surveiller l'utilisation de la bande passante :**
   ```bash
   sudo iftop -i enp0s8
   ```
   - Affiche en temps réel l'utilisation réseau par adresse IP.

---

#### **F. Analyse des Attaques ou Activités Suspectes**

1. **Détecter un scan de port :**
   ```bash
   sudo tcpdump -i enp0s8 port 22
   ```
   - Identifie les connexions SSH entrantes non autorisées.

2. **Bloquer une IP suspecte avec Iptables :**
   ```bash
   sudo iptables -A INPUT -s 192.168.1.100 -j DROP
   ```
   - Bloque définitivement une adresse IP spécifique.

3. **Configurer un taux limite pour éviter les attaques DDoS :**
   ```bash
   sudo iptables -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT
   ```

---

Des **méthodes spécifiques pour chaque type de problème** ?  
-  **commandes pour tester chaque couche du réseau (Ethernet, TCP/UDP, DNS, etc.)** ?




### 9. Test de Connexions par Couches Réseau (Ethernet, IP, TCP/UDP, DNS)

---

#### **A. Couche 1 : Physique / Ethernet (Détection matérielle, câblage, etc.)**

1. **Vérifier si l’interface est activée :**
```bash
ip link show enp0s8
```
- Statut `UP` indique que l’interface est activée.  
- Si `DOWN`, activez-la avec :  
```bash
sudo ip link set enp0s8 up
```

2. **Vérifier les statistiques Ethernet :**
```bash
ethtool -S enp0s8
```
- Affiche les erreurs physiques comme les collisions, les paquets perdus, etc.

3. **Diagnostiquer le câble réseau (si applicable) :**
```bash
sudo mii-tool enp0s8
```
- Vérifie si le câble est connecté et affiche la vitesse de connexion.

---

#### **B. Couche 2 : Liaison de Données (ARP, VLAN)**

1. **Afficher la table ARP :**
```bash
ip neigh show
```
- Affiche toutes les adresses MAC connues sur le réseau.

2. **Vérifier un conflit IP potentiel :**
```bash
arping -I enp0s8 192.168.56.100
```
- Si vous recevez une réponse, cela signifie que l’adresse IP est déjà utilisée sur le réseau.

3. **Analyser les requêtes ARP :**
```bash
sudo tcpdump -i enp0s8 arp
```
- Capture toutes les requêtes ARP (utilisé pour détecter les conflits IP).

---

#### **C. Couche 3 : Réseau (IP, Routage)**

1. **Vérifier les routes configurées :**
```bash
ip route show
```
- Affiche les routes actuelles du système.

2. **Afficher la passerelle par défaut :**
```bash
ip route | grep default
```
- Vérifie si une passerelle est correctement configurée.

3. **Tester la connectivité IP :**
```bash
ping -c 4 192.168.56.1
```
- Si aucune réponse, vérifier les règles de pare-feu ou la configuration IP.

---

#### **D. Couche 4 : Transport (TCP/UDP)**

1. **Lister toutes les connexions TCP actives :**
```bash
sudo ss -tuln
```
- Affiche toutes les connexions TCP en écoute.

2. **Tester une connexion TCP spécifique :**
```bash
telnet 192.168.56.1 22
```
- Permet de tester si un port particulier est ouvert.

3. **Scanner un port UDP spécifique :**
```bash
sudo nmap -sU -p 53 192.168.56.1
```
- Vérifie si le port DNS (53) est ouvert et accessible.

---

#### **E. Couche 5 à 7 : Application (DNS, HTTP, etc.)**

1. **Vérifier la résolution DNS :**
```bash
dig google.com
```
ou 
```bash
nslookup google.com
```
- Vérifie si le serveur DNS est fonctionnel.

2. **Analyser le trafic DNS :**
```bash
sudo tcpdump -i enp0s8 port 53
```
- Capture toutes les requêtes DNS pour vérifier leur bon fonctionnement.

3. **Tester une connexion HTTP :**
```bash
curl -I http://google.com
```
- Affiche les en-têtes HTTP renvoyés par le serveur.  

---

### 10. Dépannage DNS Défaillant (DNS, DHCP, IP)

---

#### **A. Vérification des Paramètres DNS :**
1. Afficher les DNS utilisés :  
```bash
cat /etc/resolv.conf
```
2. Forcer l'utilisation d'un DNS spécifique :  
```bash
dig @8.8.8.8 google.com
```
3. Vérifier si un DNS particulier répond :  
```bash
ping 8.8.8.8
```
4. Tester la résolution DNS via une requête brute :  
```bash
host google.com
```

---

#### **B. Problèmes DHCP (Pas d’IP attribuée)**

1. Demander une nouvelle IP :  
```bash
sudo dhclient enp0s8
```
2. Relâcher l'adresse IP actuelle :  
```bash
sudo dhclient -r enp0s8
```
3. Afficher les requêtes DHCP en cours :  
```bash
sudo dhclient -v enp0s8
```
4. Capturer le trafic DHCP pour analyse :  
```bash
sudo tcpdump -i enp0s8 port 67 or port 68
```

---

#### **C. Détection des Conflits d’Adresses IP :**

1. Analyser les requêtes ARP :  
```bash
sudo tcpdump -i enp0s8 arp
```
2. Vérifier si une adresse IP est déjà utilisée :  
```bash
arping -I enp0s8 192.168.56.100
```
3. Lister les adresses IP conflictuelles :  
```bash
ip neigh show
```

---

### 11. Optimisation Réseau Avancée (Performance)

---

#### **A. Modification de la Taille du MTU :**
```bash
sudo ip link set enp0s8 mtu 1400
```
- Réduit le risque de fragmentation des paquets.

#### **B. Activer les Offloads TCP/UDP :**
```bash
sudo ethtool -K enp0s8 tso on
sudo ethtool -K enp0s8 gso on
```
- Améliore l'efficacité du traitement réseau en déchargeant certaines tâches sur la carte réseau.

#### **C. Surveillance en Temps Réel :**
```bash
sudo iftop -i enp0s8
```
- Affiche les adresses IP qui consomment le plus de bande passante.

---

 
- Des **scénarios de dépannage spécifiques (exemples complets avec explications)** ?  
- Des **techniques avancées de sécurité réseau (pare-feu, iptables, etc.)** ?  
- Des **outils supplémentaires pour le monitoring réseau (vnstat, iperf, etc.)** ?  


