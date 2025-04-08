# Chapitre 3 – Structure de configuration de BIND9

## 3.1 Présentation générale

La configuration de BIND9 repose sur une structure modulaire composée de plusieurs fichiers texte situés principalement dans le répertoire suivant :

```
/etc/bind/
```

Le fichier principal est `named.conf`, qui **inclut** d'autres fichiers secondaires, chacun ayant un rôle spécifique. Cette approche permet de mieux organiser les paramètres du serveur DNS.



## 3.2 Arborescence des fichiers de configuration

Voici la structure typique des fichiers dans `/etc/bind/` :

```
/etc/bind/
├── named.conf
├── named.conf.options
├── named.conf.local
├── named.conf.default-zones
├── db.root
└── autres fichiers de zones personnalisées...
```

#### a. `named.conf`

C’est le **fichier maître** de configuration. Il **ne contient pas directement les définitions**, mais inclut d’autres fichiers via des directives `include` :

```bash
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
include "/etc/bind/named.conf.default-zones";
```

Ce fichier **doit toujours être valide** : une erreur ici empêchera BIND9 de démarrer.


## 3.3 Les fichiers inclus

#### a. `named.conf.options`

Ce fichier contient les **paramètres globaux** de fonctionnement du serveur DNS, comme :
- l’activation de la récursivité
- les serveurs DNS utilisés en tant que forwarders
- les ACLs (access control lists)
- le chemin des fichiers de journalisation

Exemple :

```bash
options {
    directory "/var/cache/bind";

    recursion yes;
    allow-query { any; };

    forwarders {
        8.8.8.8;
        1.1.1.1;
    };

    dnssec-validation auto;

    auth-nxdomain no;
    listen-on { any; };
};
```

Explication :
- `recursion yes` : autorise la résolution récursive
- `forwarders` : liste des DNS tiers vers lesquels rediriger les requêtes
- `listen-on` : interfaces réseau surveillées
- `allow-query` : contrôle d’accès (IP autorisées à faire des requêtes DNS)


#### b. `named.conf.local`

Ce fichier est utilisé pour **déclarer les zones personnalisées**, c’est-à-dire les domaines que vous gérez localement (ex: `inskillboost.local`).

Exemple de déclaration d’une zone :

```bash
zone "inskillboost.local" {
    type master;
    file "/etc/bind/zones/db.inskillboost.local";
};
```

Il est également utilisé pour la configuration des zones inverses :

```bash
zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192";
};
```



#### c. `named.conf.default-zones`

Ce fichier contient les **zones système par défaut**, nécessaires au bon fonctionnement du DNS local (ex. localhost, 127.0.0.1, etc.).

Exemple :

```bash
zone "localhost" {
    type master;
    file "/etc/bind/db.local";
};

zone "127.in-addr.arpa" {
    type master;
    file "/etc/bind/db.127";
};
```

Il est généralement **laissé inchangé** sauf cas particuliers.



## 3.4 Répertoires associés

- **`/var/cache/bind/`** : Répertoire utilisé par le service `named` pour stocker ses fichiers temporaires, zones dynamiques ou journaux
- **`/etc/bind/zones/`** : Ce répertoire est souvent créé manuellement pour y placer les fichiers de zones définies dans `named.conf.local`



## 3.5 Bonnes pratiques

- Utiliser `named-checkconf` pour vérifier la validité des fichiers de configuration
- Utiliser `named-checkzone` pour tester les fichiers de zones
- Toujours incrémenter le numéro de série dans la zone SOA après modification
- Sauvegarder les fichiers de configuration avant modification
- Ne jamais modifier directement les zones par défaut si ce n’est pas nécessaire
