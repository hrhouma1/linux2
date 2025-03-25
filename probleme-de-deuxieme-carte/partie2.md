*Objectif : Automatiser la configuration réseau pour que toutes les cartes ajoutées après l'installation d'Ubuntu Server soient détectées et configurées correctement via DHCP.*

###  **Solution :** Automatiser l’attribution d’adresse IP par DHCP pour toutes les nouvelles interfaces ajoutées.

---

##  **Méthode 1 : Modification de la configuration Netplan (Méthode recommandée)**
Netplan est l’outil par défaut pour la gestion réseau sur Ubuntu Server récent.

###  **Étape 1 : Modification du fichier de configuration Netplan**
1. Ouvrez le fichier de configuration Netplan (généralement dans `/etc/netplan/`).
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```
2. Remplacez le contenu par celui-ci pour que **toutes les interfaces Ethernet utilisent DHCP automatiquement** :
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      dhcp4: true
```
👉 **Astuce :** Si vous voulez que **toutes les interfaces soient configurées par DHCP automatiquement**, vous pouvez faire quelque chose comme :
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp*:
      dhcp4: true
```
Cela signifie que **toutes les interfaces réseau commençant par `enp` seront configurées avec DHCP**.

# **Étape 2 : Appliquer les modifications**
```bash
sudo netplan apply
```

---

##  **Méthode 2 : Automatiser avec un Script (Alternative)**
Si tu veux t’assurer que chaque fois qu’une nouvelle carte est ajoutée, elle reçoit une IP, crée un script qui s’exécute automatiquement.

###  **Étape 1 : Créer le script d’attribution IP automatique**
Créez un fichier de script par exemple `/usr/local/bin/dhcp-refresh.sh`
```bash
sudo nano /usr/local/bin/dhcp-refresh.sh
```
Contenu du script :
```bash
#!/bin/bash

# Liste toutes les interfaces disponibles
interfaces=$(ls /sys/class/net | grep -E 'enp|eth')

# Applique DHCP à toutes les interfaces
for interface in $interfaces; do
    sudo dhclient -v $interface
done
```

###  **Étape 2 : Rendre le script exécutable**
```bash
sudo chmod +x /usr/local/bin/dhcp-refresh.sh
```

---

##  **Méthode 3 : Ajouter un Service Système (Pour automatiser au démarrage)**
Si tu veux que ce script s’exécute à chaque redémarrage :

###  **Créer un fichier de service systemd**
```bash
sudo nano /etc/systemd/system/dhcp-refresh.service
```
Contenu du fichier :
```ini
[Unit]
Description=DHCP Refresh Service
After=network-online.target

[Service]
ExecStart=/usr/local/bin/dhcp-refresh.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

###  **Activer et démarrer le service**
```bash
sudo systemctl enable dhcp-refresh.service
sudo systemctl start dhcp-refresh.service
```

---

##  **Vérification :**
1. Pour vérifier que l'adresse IP est bien attribuée :
```bash
ip a
```
2. Pour vérifier l'état du service (Méthode 3) :
```bash
sudo systemctl status dhcp-refresh.service
```

---

##  **Avantage :**
- Méthode 1 (Netplan) est plus propre, idéale pour un environnement standardisé.  
- Méthode 2 & 3 sont utiles si tu veux automatiser sans toucher aux fichiers Netplan, par exemple si tu veux laisser tes étudiants libres d'ajouter des interfaces comme ils veulent.  

