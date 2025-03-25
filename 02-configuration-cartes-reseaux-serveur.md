### Objectif :  
- **Carte 1 : NAT Network** (`enp0s3`) - IP statique : `192.168.2.10/24` pour communication entre plusieurs VM.  
- **Carte 2 : Accès par Pont (Bridged Adapter)** (`enp0s8`) - IP obtenue via DHCP pour avoir accès direct au réseau physique.  

---

### Étape 1 : Configuration des cartes réseau dans VirtualBox  
1. Arrêtez votre machine virtuelle.  
2. Allez dans les paramètres de la VM (Configuration > Réseau).  
3. Configurez les adaptateurs réseau comme suit :  

| Adaptateur | Type                | Nom de l'interface | Objectif                              |
|------------|---------------------|--------------------|-------------------------------------|
| Adaptateur 1 | NAT Network         | `NatNetwork`       | Communication inter-VM (IP statique). |
| Adaptateur 2 | Bridged Adapter     | Nom de votre carte réseau physique | Accès au réseau physique par DHCP. |

---

### Étape 2 : Configuration Netplan sur Ubuntu Server  
Ouvrez votre fichier `/etc/netplan/00-installer-config.yaml` et configurez-le ainsi :  

```yaml
network:
  version: 2
  ethernets:
    enp0s3:   # Adaptateur 1 : NAT Network
      addresses: [192.168.2.10/24]
      gateway4: 192.168.2.1
      dhcp4: no
      nameservers:
        addresses: [8.8.8.8]
        
    enp0s8:   # Adaptateur 2 : Bridged Adapter
      dhcp4: yes
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
1. **Vérifier les interfaces configurées :**  
```bash
ip addr
```
Vous devez voir :  
- `enp0s3` avec l’IP statique `192.168.2.10/24`  
- `enp0s8` avec une IP attribuée par DHCP (souvent votre réseau local, par exemple `192.168.x.x` ou `10.x.x.x`).  

2. **Vérifier la connexion Internet via l'adaptateur ponté :**  
```bash
ping -c 4 8.8.8.8
```

3. **Vérifier la connexion NAT Network :**  
Depuis une autre VM connectée au même réseau `NatNetwork`, essayez :  
```bash
ping 192.168.2.10
```



# Annexe: 



### **Étape 1 : Vérification de l'adaptateur NAT Network (`enp0s3`)**  
Cet adaptateur est censé avoir une adresse IP statique (`192.168.2.10/24`) pour la communication inter-VM.

1. **Vérifiez l’adresse IP de `enp0s3` :**  
```bash
ip addr show enp0s3
```
Vous devez voir quelque chose comme :
```
inet 192.168.2.10/24
```

2. **Vérifiez la route par défaut :**  
```bash
ip route
```
Vous devez voir quelque chose comme : 
```
default via 192.168.2.1 dev enp0s3
```

3. **Testez la connexion entre VM sur le même réseau NAT Network :**  
Depuis une autre VM configurée sur le même `NatNetwork`, tapez :  
```bash
ping 192.168.2.10
```
Si cela répond, l’adaptateur NAT Network est bien configuré.

---

### **Étape 2 : Vérification de l'adaptateur Bridged (`enp0s8`)**  
Cet adaptateur doit obtenir une adresse IP automatiquement via DHCP pour accéder à Internet.

1. **Vérifiez l’adresse IP de `enp0s8` :**  
```bash
ip addr show enp0s8
```
Vous devez voir une adresse IP attribuée par votre routeur local (par exemple `192.168.x.x` ou `10.x.x.x`).

2. **Vérifiez l'accès Internet :**  
```bash
ping -c 4 8.8.8.8
```
Si vous obtenez une réponse, l'accès Internet fonctionne.

3. **Vérifiez la résolution DNS :**  
```bash
ping -c 4 google.com
```
Si cela fonctionne, la résolution DNS fonctionne bien.

---

### **Étape 3 : Vérification des deux connexions ensemble**  
Maintenant, vous voulez vérifier que **les deux cartes sont bien fonctionnelles en même temps**.

1. **Vérifiez la table de routage :**  
```bash
ip route
```
Vous devez voir deux lignes principales :  
- `192.168.2.0/24 dev enp0s3 proto static ...` (NAT Network)  
- `default via ... dev enp0s8 ...` (Ponté - Internet)  

2. **Vérifiez que vous pouvez atteindre Internet via `enp0s8` :**  
```bash
curl ifconfig.me
```
Cela devrait vous retourner l’IP publique fournie par votre réseau physique (pas `192.168.2.10`).

