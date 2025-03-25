 **Explication Simple : Configurer une Nouvelle Carte Réseau avec Ubuntu Server**  

---

##  **Objectif :**  
Si vous ajoutez une nouvelle carte réseau sur votre Ubuntu Server et qu'elle n'obtient pas d'adresse IP automatiquement, suivez ces étapes simples.

---

###  **Méthode 1 : Configuration Netplan (Méthode la plus facile)**  
Cette méthode vous permet de configurer votre serveur pour qu'il détecte toutes les cartes réseau automatiquement.

####  **Étape 1 : Modifier le fichier Netplan**
1. Ouvrez votre fichier de configuration réseau.
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```
2. Remplacez le contenu par ceci :
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
**Astuce :** Si vous voulez que toutes vos cartes réseau utilisent DHCP sans avoir à les ajouter manuellement, utilisez :
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp*:
      dhcp4: true
```
Cela permet de détecter automatiquement toutes les cartes réseau `enp0s3`, `enp0s8`, etc.

---

####  **Étape 2 : Appliquer la configuration**
Appliquez vos modifications :
```bash
sudo netplan apply
```

---

####  **Étape 3 : Vérifier l’adresse IP**
Pour vérifier si l’interface a reçu une adresse IP :
```bash
ip a
```
Ou
```bash
ifconfig
```
---

###  **Méthode 2 : Renouveler une Adresse IP Manuellement (si vous ne voulez pas modifier Netplan)**  
Si vous venez d'ajouter une nouvelle carte réseau (`enp0s8`) et que vous voulez qu'elle reçoive une adresse IP :

```bash
sudo dhclient enp0s8
```
Cela forcera votre carte réseau à obtenir une adresse IP via DHCP.

---

###  **Méthode 3 : Automatiser la Configuration avec un Script (Pour tous vos étudiants)**  
Si vous voulez que ce processus soit automatique à chaque démarrage :  

####  **Créer un script pour renouveler les adresses IP de toutes les cartes réseau**  
1. Créez un fichier :
```bash
sudo nano /usr/local/bin/dhcp-refresh.sh
```
2. Copiez ceci dedans :
```bash
#!/bin/bash
interfaces=$(ls /sys/class/net | grep -E 'enp|eth')

for interface in $interfaces; do
    sudo dhclient -v $interface
done
```
3. Rendez ce fichier exécutable :
```bash
sudo chmod +x /usr/local/bin/dhcp-refresh.sh
```
4. Pour exécuter le script manuellement :
```bash
sudo /usr/local/bin/dhcp-refresh.sh
```

---

###  **Méthode 4 : Si Vous Voulez Automatiser Le Script Au Démarrage**  
1. Créez un fichier de service :
```bash
sudo nano /etc/systemd/system/dhcp-refresh.service
```
2. Ajoutez ceci dedans :
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
3. Activez et démarrez le service :
```bash
sudo systemctl enable dhcp-refresh.service
sudo systemctl start dhcp-refresh.service
```

---

## **Résultat attendu :**  
- Si vous utilisez **Méthode 1**, toutes les cartes réseau (`enp0s3`, `enp0s8`, etc.) recevront une adresse IP automatiquement.  
- Si vous utilisez **Méthode 2**, vous devez juste taper `sudo dhclient enp0s8` pour recevoir une adresse IP.  
- Si vous utilisez **Méthode 3 ou 4**, toutes vos cartes seront configurées automatiquement à chaque démarrage.

