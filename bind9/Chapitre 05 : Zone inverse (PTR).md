# Chapitre 5 – Zone inverse (PTR)

## 5.1 Objectif

Une **zone inverse** permet de résoudre une **adresse IP vers un nom de domaine**. Contrairement à la zone directe qui associe un nom à une adresse IP (enregistrement A), la zone inverse utilise un **enregistrement PTR** (Pointer Record) pour faire l’opération inverse.

Cette fonctionnalité est particulièrement utile pour :
- Diagnostiquer des problèmes réseau
- Vérifier la configuration des serveurs (ex: mail)
- Améliorer la crédibilité d’un domaine (reverse DNS)



## 5.2 Exemple de cas pratique

Considérons le sous-réseau suivant : `192.168.1.0/24`

Nous avons défini précédemment :
- `ns1.inskillboost.local` avec l'adresse IP `192.168.1.10`
- `www.inskillboost.local` avec l'adresse IP `192.168.1.20`

Nous allons maintenant créer une **zone inverse** pour cette plage d'adresses afin d’associer les adresses IP à leurs noms.



## 5.3 Étape 1 : Déclaration de la zone inverse

Ouvrir le fichier `/etc/bind/named.conf.local` :

```bash
sudo nano /etc/bind/named.conf.local
```

Ajouter à la fin du fichier :

```bash
zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192";
};
```

> La notation `1.168.192.in-addr.arpa` est la représentation inversée du réseau `192.168.1.0`



## 5.4 Étape 2 : Création du fichier de zone inverse

Créer le fichier `/etc/bind/zones/db.192` :

```bash
sudo nano /etc/bind/zones/db.192
```

Contenu du fichier :

```
$TTL 604800
@   IN  SOA ns1.inskillboost.local. admin.inskillboost.local. (
            1         ; Serial
       604800         ; Refresh
        86400         ; Retry
      2419200         ; Expire
       604800 )       ; Negative Cache TTL

@       IN  NS      ns1.inskillboost.local.

10      IN  PTR     ns1.inskillboost.local.
20      IN  PTR     www.inskillboost.local.
```

Explication :
- L’adresse `192.168.1.10` est représentée par `10 IN PTR ns1.inskillboost.local.`
- L’adresse `192.168.1.20` est représentée par `20 IN PTR www.inskillboost.local.`



## 5.5 Étape 3 : Vérification de la syntaxe

Vérifier la validité du fichier de zone inverse :

```bash
sudo named-checkzone 1.168.192.in-addr.arpa /etc/bind/zones/db.192
```

Sortie attendue :

```
zone 1.168.192.in-addr.arpa/IN: loaded serial 1
OK
```



## 5.6 Étape 4 : Redémarrage du service

Appliquer la configuration en redémarrant BIND9 :

```bash
sudo systemctl restart bind9
```



## 5.7 Étape 5 : Test de la résolution inverse

Utiliser les commandes suivantes pour tester la zone inverse :

#### a. `dig` :

```bash
dig -x 192.168.1.10 @127.0.0.1
```

Résultat attendu :

```
;; ANSWER SECTION:
10.1.168.192.in-addr.arpa. 604800 IN PTR ns1.inskillboost.local.
```

#### b. `host` :

```bash
host 192.168.1.20 127.0.0.1
```

Résultat attendu :

```
20.1.168.192.in-addr.arpa domain name pointer www.inskillboost.local.
```

#### c. `nslookup` :

```bash
nslookup 192.168.1.10 127.0.0.1
```



## 5.8 Résumé

| Élément                  | Fonction                          |
|--------------------------|-----------------------------------|
| Zone inverse             | Adresse IP → Nom de domaine       |
| Fichier `/db.192`        | Contient les enregistrements PTR  |
| Fichier `named.conf.local` | Déclare la zone `in-addr.arpa` |
| Commandes de test        | `dig -x`, `host`, `nslookup`      |

