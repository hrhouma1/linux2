# Chapitre 7 – Sécurisation et bonnes pratiques

## 7.1 Objectif

Un serveur DNS est un composant critique d'une infrastructure réseau. Il peut être la cible d'attaques comme :
- L’exploitation de récursivité ouverte
- Le cache poisoning (empoisonnement du cache DNS)
- Le déni de service (DoS)
- L’accès non autorisé aux données de zones internes

Ce chapitre présente les bonnes pratiques pour **sécuriser un serveur BIND9**, et limiter les risques liés à une mauvaise configuration.



## 7.2 Limitation des requêtes aux clients autorisés

Par défaut, un serveur DNS peut être accessible à tous. Pour restreindre les requêtes DNS uniquement à un réseau interne, modifier le fichier `/etc/bind/named.conf.options`.

Exemple :

```bash
options {
    directory "/var/cache/bind";

    allow-query { 127.0.0.1; 192.168.1.0/24; };

    recursion yes;
    allow-recursion { 127.0.0.1; 192.168.1.0/24; };

    listen-on { 127.0.0.1; 192.168.1.10; };
};
```

Explication :
- `allow-query` : contrôle les clients pouvant interroger ce serveur DNS
- `allow-recursion` : limite la récursivité aux clients internes
- `listen-on` : borne les interfaces réseau utilisées par BIND



## 7.3 Désactivation de la récursivité si inutile

Si le serveur DNS est **strictement autoritaire** (et ne fait pas de résolutions récursives), désactivez cette fonctionnalité :

```bash
options {
    recursion no;
};
```



## 7.4 Cloisonnement des informations de zone

Évitez de divulguer des données internes à des utilisateurs extérieurs. Pour cela, définissez des vues conditionnelles (`views`) ou utilisez des ACLs.

Exemple : masquer une zone à tout utilisateur externe

```bash
acl reseau_local { 192.168.1.0/24; 127.0.0.1; };

options {
    allow-query { reseau_local; };
};
```



## 7.5 Protection contre le transfert de zone non autorisé

Un transfert de zone DNS permet à un serveur secondaire de récupérer la totalité des enregistrements d’un domaine.  
Par défaut, BIND autorise les transferts depuis n'importe quel hôte, ce qui représente un **risque de fuite de données**.

Restreindre les transferts de zone à des serveurs précis :

```bash
zone "inskillboost.local" {
    type master;
    file "/etc/bind/zones/db.inskillboost.local";
    allow-transfer { 192.168.1.11; };  // IP du serveur esclave autorisé
};
```



## 7.6 DNSSEC (DNS Security Extensions)

DNSSEC permet de signer cryptographiquement les zones DNS pour garantir leur authenticité.

Activation dans les options :

```bash
dnssec-validation auto;
```

La mise en place complète de DNSSEC nécessite :
- La génération de clés
- La signature des zones
- La distribution de la clé publique
(Ce sujet est avancé et traité dans un module spécifique.)



## 7.7 Droits et permissions des fichiers

Les fichiers de zone doivent être lisibles uniquement par l’utilisateur `bind`.

Assurez-vous que :

```bash
sudo chown -R bind:bind /etc/bind/zones
sudo chmod -R 640 /etc/bind/zones
```

Évitez que d'autres utilisateurs puissent écrire ou lire ces fichiers.



## 7.8 Surveillance et journalisation

Le suivi des événements DNS est crucial. Par défaut, BIND utilise `syslog`. Pour une journalisation personnalisée, vous pouvez ajouter une section `logging` dans `/etc/bind/named.conf`.

Exemple de base :

```bash
logging {
    channel default_log {
        file "/var/log/bind9.log";
        severity info;
        print-time yes;
    };

    category default { default_log; };
};
```

Créer le fichier de log et ajuster les permissions :

```bash
sudo touch /var/log/bind9.log
sudo chown bind:bind /var/log/bind9.log
```

Redémarrer BIND9 :

```bash
sudo systemctl restart bind9
```



## 7.9 Autres bonnes pratiques

- **Sauvegarder régulièrement les fichiers de zone**
- **Utiliser des numéros de série dynamiques** (`YYYYMMDDnn`)
- **Redémarrer le service après chaque modification**
- **Utiliser `named-checkzone` systématiquement avant rechargement**
- **Restreindre l’accès SSH à la machine DNS**
- **Utiliser un pare-feu (UFW, iptables)** pour limiter les ports ouverts


## 7.10 Résumé

| Action                              | But                                      |
|-------------------------------------|------------------------------------------|
| Restriction des requêtes            | Éviter les abus extérieurs               |
| Désactivation de la récursivité     | Réduction de la surface d’attaque        |
| Protection des transferts de zone   | Confidentialité des données DNS         |
| Journalisation                      | Suivi et analyse des comportements       |
| Droits sur les fichiers             | Sécurité des données critiques           |
| DNSSEC                              | Authentification des enregistrements DNS |

