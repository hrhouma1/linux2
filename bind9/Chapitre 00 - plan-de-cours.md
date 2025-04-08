# Cours Bind9 : Introduction et Administration de BIND9 (DNS Server)

###  Objectifs pédagogiques
- Comprendre le rôle d’un serveur DNS
- Installer et configurer un serveur BIND9
- Créer une zone DNS (directe et inverse)
- Gérer les fichiers de zone
- Tester et dépanner la résolution DNS



# Plan du cours

# Chapitre 1 : Introduction au DNS et à BIND9
- Qu’est-ce que le DNS ?
- Résolution directe et inverse
- Rôle de BIND9 dans l’infrastructure réseau



# Chapitre 2 : Installation de BIND9 (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install bind9 bind9utils bind9-doc dnsutils -y
```

- Vérification du service
```bash
systemctl status bind9
```
- Emplacement des fichiers :
  - `/etc/bind/`
  - `/var/cache/bind/`



#  Chapitre 3 : Structure de configuration de BIND9

- **`/etc/bind/named.conf`**
  - Fichier maître qui inclut les autres configs
- **`named.conf.options`** : options globales (forwarders, recursion)
- **`named.conf.local`** : déclaration des zones
- **`named.conf.default-zones`** : zones par défaut (localhost, 127.0.0.1, etc.)



# Chapitre 4 : Création d'une zone DNS directe

Exemple : domaine fictif `inskillboost.local`

```bash
zone "inskillboost.local" {
  type master;
  file "/etc/bind/zones/db.inskillboost.local";
};
```

**Contenu du fichier de zone : `/etc/bind/zones/db.inskillboost.local`**

```dns
$TTL 604800
@   IN  SOA ns1.inskillboost.local. admin.inskillboost.local. (
          2         ; Serial
     604800         ; Refresh
      86400         ; Retry
    2419200         ; Expire
     604800 )       ; Negative Cache TTL
;
@       IN  NS      ns1.inskillboost.local.
ns1     IN  A       192.168.1.10
www     IN  A       192.168.1.20
```



# Chapitre 5 : Zone inverse (PTR)

Zone `1.168.192.in-addr.arpa`

```bash
zone "1.168.192.in-addr.arpa" {
  type master;
  file "/etc/bind/zones/db.192";
};
```

**Fichier PTR : `/etc/bind/zones/db.192`**

```dns
$TTL 604800
@   IN  SOA ns1.inskillboost.local. admin.inskillboost.local. (
          1         ; Serial
     604800         ; Refresh
      86400         ; Retry
    2419200         ; Expire
     604800 )       ; Negative Cache TTL
;
@       IN  NS      ns1.inskillboost.local.
10      IN  PTR     ns1.inskillboost.local.
20      IN  PTR     www.inskillboost.local.
```



# Chapitre 6 : Vérification et tests

- **Vérification syntaxe config** :
```bash
named-checkconf
named-checkzone inskillboost.local /etc/bind/zones/db.inskillboost.local
```

- **Redémarrage BIND** :
```bash
sudo systemctl restart bind9
```

- **Test DNS** :
```bash
dig @192.168.1.10 www.inskillboost.local
host www.inskillboost.local 192.168.1.10
nslookup www.inskillboost.local 192.168.1.10
```



# Chapitre 7 : Sécurisation & bonnes pratiques

- Restreindre les requêtes :
```bash
allow-query { 192.168.1.0/24; };
```

- Journalisation DNS : syslog
- Configuration en cache DNS



# Chapitre 8 : Travaux Pratiques

1. TP1 : Créer un serveur DNS BIND9 dans une VM Ubuntu
2. TP2 : Configurer une zone directe avec un domaine personnalisé
3. TP3 : Créer une zone inverse pour PTR
4. TP4 : Ajouter un enregistrement MX, CNAME et tester
5. TP5 : Simuler une panne DNS et corriger l’erreur via `dig` et `log`
