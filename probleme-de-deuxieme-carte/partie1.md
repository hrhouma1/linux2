

# **Problème :**
- **Installation initiale d’Ubuntu Server :** Si une seule carte réseau est connectée (par exemple `enp0s3`) et configurée, elle reçoit automatiquement une adresse IP via DHCP.
- **Ajout d’une nouvelle carte réseau après installation :** Quand une deuxième carte est ajoutée (`enp0s8` par exemple), elle n’est pas automatiquement configurée par DHCP.

## **Pourquoi ça ne marche pas ?**
- **Ubuntu Server n’a pas de configuration DHCP active pour la nouvelle carte (`enp0s8`).**
- La nouvelle carte (`enp0s8`) est en mode **Host-Only Adapter**, qui ne permet pas de recevoir une adresse IP par DHCP sauf si configuré manuellement.

# **Solution 1 : Renouveler l'adresse IP via DHCP**
Si la carte (`enp0s8`) est configurée en **"Host-Only Adapter"** mais doit obtenir une adresse IP dynamique :
```bash
sudo dhclient enp0s8
```
Cela force la carte à demander une adresse IP au DHCP sur ce réseau.

# **Solution 2 : Changer le type de carte réseau pour accès par point (NAT ou Bridged Adapter)**
1. **Changer le type de carte réseau dans VirtualBox/VMware :**
   - Si vous voulez que l’interface ait accès à Internet, utilisez **NAT** ou **Bridged Adapter** au lieu de **Host-Only Adapter**.
2. **Redémarrer l’interface réseau :**
```bash
sudo ip link set enp0s8 down
sudo ip link set enp0s8 up
sudo dhclient enp0s8
```

#  **Solution 3 : Configuration Manuelle (si nécessaire)**
Si vous souhaitez configurer une adresse IP statique, ajoutez cette configuration dans `/etc/netplan/*.yaml`.

Exemple :
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s8:
      dhcp4: true
```
Puis appliquer la configuration :
```bash
sudo netplan apply
```

#  **Vérification :**
Vérifiez si l'adresse IP est attribuée par :
```bash
ip a
```
ou
```bash
ifconfig
```

