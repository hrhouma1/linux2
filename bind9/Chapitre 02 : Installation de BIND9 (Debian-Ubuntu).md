# Chapitre 2 – Installation de BIND9

## 2.1 Présentation

Avant de configurer un serveur DNS, il est indispensable d’installer un service DNS complet. **BIND9** (Berkeley Internet Name Domain version 9) est le serveur DNS open-source le plus couramment utilisé dans les environnements Linux. Il est stable, sécurisé et très configurable.

Dans ce chapitre, nous allons :
- Installer BIND9 sur une machine Debian/Ubuntu
- Identifier les principaux fichiers et répertoires utilisés
- Vérifier le fonctionnement initial du service



## 2.2 Installation de BIND9 sur Debian/Ubuntu

#### a. Mise à jour du système

Avant toute installation, il est recommandé de mettre à jour la liste des paquets et les paquets installés :

```bash
sudo apt update
sudo apt upgrade -y
```

#### b. Installation de BIND9 et des utilitaires associés

La commande suivante installe le serveur BIND9 ainsi que les outils de gestion et de diagnostic :

```bash
sudo apt install bind9 bind9utils bind9-doc dnsutils -y
```

Explication des paquets :
- `bind9` : le serveur DNS principal
- `bind9utils` : outils de gestion (ex : `rndc`, `dig`, `named-checkconf`, etc.)
- `bind9-doc` : documentation locale de BIND
- `dnsutils` : outils de diagnostic DNS (comme `dig`, `host`, `nslookup`)



## 2.3 Vérification du service BIND9

Après installation, le service `bind9` est automatiquement démarré. Pour vérifier son état :

```bash
sudo systemctl status bind9
```

Sortie attendue (extrait) :
```
● bind9.service - BIND Domain Name Server
     Loaded: loaded (/lib/systemd/system/bind9.service; enabled)
     Active: active (running) since ...
```

Si le service n’est pas démarré, utilisez :

```bash
sudo systemctl start bind9
```

Pour l’activer au démarrage :
```bash
sudo systemctl enable bind9
```



## 2.4 Emplacement des fichiers de BIND9

Après installation, BIND9 place ses fichiers dans différents répertoires. Il est essentiel de bien comprendre leur rôle.

| Emplacement                        | Description |
|------------------------------------|-------------|
| `/etc/bind/`                       | Répertoire principal de configuration |
| `/etc/bind/named.conf`             | Fichier principal incluant les autres configs |
| `/etc/bind/named.conf.options`     | Options globales du serveur DNS |
| `/etc/bind/named.conf.local`       | Déclaration des zones personnalisées |
| `/etc/bind/named.conf.default-zones` | Zones par défaut (localhost, 127.0.0.1, etc.) |
| `/var/cache/bind/`                 | Zones dynamiques (cache et runtime) |
| `/var/log/syslog`                  | Fichier de journal par défaut pour les logs DNS |



## 2.5 Structure initiale des fichiers de configuration

Les fichiers de configuration sont **modulaires** et organisés de façon hiérarchique. Le fichier principal est :

```text
/etc/bind/named.conf
```

Il contient des instructions comme :

```bash
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
include "/etc/bind/named.conf.default-zones";
```

Cela signifie que la configuration complète est répartie dans plusieurs fichiers pour faciliter l’organisation :
- **`named.conf.options`** : configuration générale (forwarders, récursivité, ACL, etc.)
- **`named.conf.local`** : déclarations des zones locales personnalisées (fichiers de zone)
- **`named.conf.default-zones`** : contient les définitions DNS par défaut (loopback, root, etc.)



## 2.6 Outils de gestion DNS utiles

Quelques commandes essentielles pour interagir avec BIND9 :

| Commande                          | Description |
|-----------------------------------|-------------|
| `dig nom_de_domaine`             | Interroger un domaine (DNS query) |
| `nslookup nom_de_domaine`       | Ancienne commande de résolution |
| `named-checkconf`               | Vérifie la syntaxe des fichiers de configuration |
| `named-checkzone`               | Vérifie la syntaxe d’un fichier de zone |
| `rndc status`                   | État du serveur via le contrôleur BIND |
| `systemctl restart bind9`       | Redémarrage du service |

---

### 2.7 Résumé des étapes

1. Mettre à jour le système
2. Installer les paquets nécessaires
3. Vérifier le statut du service
4. Comprendre l’organisation des fichiers de configuration
5. Tester la configuration avec les outils de diagnostic
