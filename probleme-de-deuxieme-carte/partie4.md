###  **Guide Simplifié pour la Configuration Réseau Automatique sur Ubuntu Server**  

---

####  **Objectif :**  
Après l'installation d'Ubuntu Server, il arrive que les cartes réseau ajoutées après coup ne soient pas configurées automatiquement. Ce guide vous montre comment corriger cela pour que toutes les cartes soient reconnues sans effort.

---

###  **Étape 1 : Vérifier les Interfaces Réseau**  
Pour voir les interfaces réseau disponibles, utilisez la commande suivante :  
```bash
ip a
```
Si la nouvelle carte n’a pas d’IP, nous devons la configurer.

---

###  **Option 1 : Configuration Permanente avec Netplan (Recommandée)**  
Cette méthode configure automatiquement toutes les cartes réseau pour utiliser DHCP.  

####  **Modifier la configuration Netplan**  
1. Ouvrez le fichier de configuration :  
   ```bash
   sudo nano /etc/netplan/00-installer-config.yaml
   ```
2. Mettez le contenu suivant :  
   ```yaml
   network:
     version: 2
     renderer: networkd
     ethernets:
       enp*:
         dhcp4: true
   ```
   💡 Cela permet de détecter **toutes les cartes réseau automatiquement**.  

#### **Appliquer les changements**  
```bash
sudo netplan apply
```

---

### 🚀 **Option 2 : Renouveler l’Adresse IP Manuellement (En Cas de Besoin)**  
Si vous venez juste d'ajouter une nouvelle carte (`enp0s8`), utilisez :  
```bash
sudo dhclient enp0s8
```
Cette commande demande immédiatement une adresse IP via DHCP.  

---

###  **Option 3 : Automatiser avec un Script (Pour toutes les interfaces)**  
Cette méthode garantit que toutes les interfaces reçoivent une adresse IP automatiquement, même après redémarrage.  

#### 🔧 **Créer un script d'automatisation**  
1. Créez le script :  
   ```bash
   sudo nano /usr/local/bin/dhcp-refresh.sh
   ```
2. Copiez ce contenu :  
   ```bash
   #!/bin/bash
   interfaces=$(ls /sys/class/net | grep -E 'enp|eth')

   for interface in $interfaces; do
       sudo dhclient -v $interface
   done
   ```
3. Rendez-le exécutable :  
   ```bash
   sudo chmod +x /usr/local/bin/dhcp-refresh.sh
   ```

---

###  **Option 4 : Exécuter Automatiquement au Démarrage**  
1. Créez un service systemd :  
   ```bash
   sudo nano /etc/systemd/system/dhcp-refresh.service
   ```
2. Ajoutez ceci :  
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
3. Activez le service :  
   ```bash
   sudo systemctl enable dhcp-refresh.service
   sudo systemctl start dhcp-refresh.service
   ```
---

###  **Vérification :**  
Pour vous assurer que tout fonctionne, vérifiez les interfaces réseau après un redémarrage :  
```bash
ip a
```

---

###  **Résumé :**  
1. Utilisez **Netplan** pour que toutes les interfaces soient configurées automatiquement.  
2. Pour des ajouts ponctuels, utilisez la commande `sudo dhclient <interface>`.  
3. Automatisez avec un script si vous ajoutez souvent des cartes réseau.  
4. Vérifiez avec `ip a` pour vous assurer que tout est correct.  

