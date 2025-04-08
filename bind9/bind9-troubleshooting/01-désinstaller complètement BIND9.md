# Objectif: 

- **désinstaller complètement BIND9**, supprimer **toutes les traces** (y compris les fichiers de configuration), puis **réinstaller proprement** un environnement vierge.



# ÉTAPE 1 : Arrêter le service BIND9
```bash
sudo systemctl stop bind9
sudo systemctl disable bind9
```



# ÉTAPE 2 : Désinstaller complètement BIND9 et les paquets associés
```bash
sudo apt-get purge --auto-remove bind9* -y
sudo apt-get autoremove --purge -y
```



# ÉTAPE 3 : Supprimer tous les fichiers de configuration résiduels

Voici les dossiers et fichiers qui peuvent contenir des configurations résiduelles de BIND9 :
```bash
sudo rm -rf /etc/bind
sudo rm -rf /var/cache/bind
sudo rm -rf /var/lib/bind
sudo rm -rf /var/log/named
sudo rm -rf /var/log/bind9
sudo rm -rf /run/named
sudo rm -rf /run/bind
```

Pour être encore plus propre :
```bash
sudo find / -type f -name "*named.conf*" -exec rm -f {} \;
sudo find / -type f -name "*.zone" -exec rm -f {} \;
```



# ÉTAPE 4 : Vérification

Vérifie que BIND n’est plus là :
```bash
which named
```

Il ne doit rien retourner. Si ça retourne `/usr/sbin/named` ou autre, il reste un fichier binaire quelque part. Tu peux aussi chercher :
```bash
sudo ps aux | grep named
```



# ÉTAPE 5 : Réinstallation propre de BIND9

```bash
sudo apt update
sudo apt install bind9 bind9utils bind9-doc -y
```


# ÉTAPE 6 : Vérifier l'installation

```bash
named -v
```

Tu dois voir une version, par exemple : `BIND 9.18.1 (Stable Release)`.



# Fichiers de configuration par défaut après réinstallation

Après réinstallation, tu auras :
- `/etc/bind/named.conf`
- `/etc/bind/named.conf.options`
- `/etc/bind/named.conf.local`
- `/etc/bind/named.conf.default-zones`



# Démarrer BIND

```bash
sudo systemctl start bind9
sudo systemctl enable bind9
```

Et pour vérifier que le service tourne :
```bash
sudo systemctl status bind9
```

