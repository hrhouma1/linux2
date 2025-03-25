

### Objectif :
- **Carte 1 : NAT** (Accès à Internet)
- **Carte 2 : Host-Only Adapter** (Pour la communication directe entre l’hôte et la VM)
- **Carte 3 : NAT Network** (Pour une communication isolée entre plusieurs VM si besoin)

---

### Étape 1 : Configuration des cartes réseau dans VirtualBox  
1. Arrêtez votre machine virtuelle.  
2. Allez dans les paramètres de la VM (Configuration > Réseau).  
3. Configurez les adaptateurs réseau comme suit :  

| Adaptateur | Type                | Nom de l'interface | Objectif                   |
|------------|---------------------|--------------------|---------------------------|
| Adaptateur 1 | NAT                | par défaut         | Pour accéder à Internet.  |
| Adaptateur 2 | Host-Only Adapter   | `vboxnet0` (ou autre) | Pour la connexion avec votre hôte. |
| Adaptateur 3 | NAT Network         | `NatNetwork`       | Pour communication inter-VM. |

---

### Étape 2 : Configuration Netplan sur Ubuntu Server  
Ouvrez votre fichier `/etc/netplan/00-installer-config.yaml` et configurez-le ainsi :  

```yaml
network:
  version: 2
  ethernets:
    enp0s3:   # Adaptateur 1 : NAT
      dhcp4: yes

    enp0s8:   # Adaptateur 2 : Host-Only Adapter
      addresses: [192.168.56.10/24]
      dhcp4: no
      nameservers:
        addresses: [8.8.8.8]

    enp0s9:   # Adaptateur 3 : NAT Network
      addresses: [192.168.2.10/24]
      gateway4: 192.168.2.1
      dhcp4: no
      nameservers:
        addresses: [8.8.8.8]
```

---

### Étape 3 : Appliquer la configuration Netplan  
1. Sauvegardez le fichier de configuration.  
2. Appliquez les modifications en exécutant la commande suivante :  
```bash
sudo netplan apply
```

---

### Étape 4 : Vérification de la configuration réseau  
1. Vérifier les interfaces configurées :  
```bash
ip addr
```
Vous devez voir les trois interfaces :  
- `enp0s3` avec une IP fournie par DHCP (NAT)  
- `enp0s8` avec `192.168.56.10` (Host-Only)  
- `enp0s9` avec `192.168.2.10` (NAT Network)  

2. Vérifier la connexion Internet :  
```bash
ping -c 4 8.8.8.8
```

3. Vérifier la communication entre VM (si nécessaire) :  
- Depuis une autre VM sur le même réseau `NAT Network`, essayez :  
```bash
ping 192.168.2.10
```

# Annexe: 


### **Étape 1 : Vérification de la connexion Internet (NAT - enp0s3)**
Cette interface doit fournir une IP automatiquement par DHCP.

1. Tapez la commande suivante pour vérifier l'adresse IP assignée :
```bash
ip addr show enp0s3
```
Vérifiez que vous avez une adresse IP valide (généralement quelque chose comme `10.0.x.x` ou `192.168.x.x`).

2. Testez la connexion Internet :
```bash
ping -c 4 8.8.8.8
```
Si cela fonctionne, c'est que l'accès Internet est opérationnel via votre NAT.

---

### **Étape 2 : Vérification de la connexion Host-Only (enp0s8)**
Cette interface doit avoir une IP statique (`192.168.56.10`).

1. Vérifiez l'adresse IP attribuée :
```bash
ip addr show enp0s8
```
Vous devez voir l'adresse `192.168.56.10/24`.

2. Depuis votre machine hôte (votre ordinateur), essayez de pinguer l'adresse IP de votre VM :
```bash
ping 192.168.56.10
```
Si cela fonctionne, la connexion Host-Only est bien configurée.

---

### **Étape 3 : Vérification de la connexion NAT Network (enp0s9)**
Cette interface doit avoir une IP statique (`192.168.2.10`).

1. Vérifiez l'adresse IP attribuée :
```bash
ip addr show enp0s9
```
Vous devez voir l'adresse `192.168.2.10/24`.

2. Vérifiez la route par défaut :
```bash
ip route
```
Vous devez voir une ligne comme :
```
default via 192.168.2.1 dev enp0s9
```

3. Depuis une autre machine virtuelle connectée au même NAT Network (`NatNetwork`), essayez de pinguer cette IP :
```bash
ping 192.168.2.10
```
Si cela fonctionne, c'est que la communication inter-VM via le NAT Network est bien configurée.

---

### **Étape 4 : Vérification de la résolution DNS (optionnel)**
Si vous voulez vous assurer que le DNS est bien configuré, tapez :
```bash
systemd-resolve --status
```
Vérifiez que `8.8.8.8` apparaît comme serveur DNS configuré pour au moins une interface.

