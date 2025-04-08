## Chapitre 4 – Création d’une zone DNS directe

## 4.1 Objectif

La **zone DNS directe** permet de faire correspondre des **noms de machines** à leurs **adresses IP** (résolution directe).  
Dans ce chapitre, nous allons :

- Déclarer une nouvelle zone DNS dans `named.conf.local`
- Créer un fichier de zone associé avec des enregistrements de type A
- Redémarrer BIND9
- Vérifier que la résolution fonctionne avec les commandes `dig` et `host`



## 4.2 Exemple de domaine local

Nous allons utiliser le domaine fictif suivant :  
**`inskillboost.local`**

Les objectifs :
- Associer `www.inskillboost.local` à `192.168.1.20`
- Associer `ns1.inskillboost.local` à `192.168.1.10`



## 4.3 Étape 1 : Déclaration de la zone dans named.conf.local

Ouvrir le fichier `/etc/bind/named.conf.local` avec les droits administrateur :

```bash
sudo nano /etc/bind/named.conf.local
```

Ajouter à la fin :

```bash
zone "inskillboost.local" {
    type master;
    file "/etc/bind/zones/db.inskillboost.local";
};
```

> Le fichier `/etc/bind/zones/db.inskillboost.local` n'existe pas encore. Il sera créé à l'étape suivante.


## 4.4 Étape 2 : Création du fichier de zone

Créer le répertoire `zones` s’il n’existe pas :

```bash
sudo mkdir -p /etc/bind/zones
```

Créer le fichier de zone :

```bash
sudo nano /etc/bind/zones/db.inskillboost.local
```

Contenu complet du fichier :

```
$TTL 604800
@   IN  SOA ns1.inskillboost.local. admin.inskillboost.local. (
            1         ; Serial
       604800         ; Refresh
        86400         ; Retry
      2419200         ; Expire
       604800 )       ; Negative Cache TTL

; Enregistrements principaux
@       IN  NS      ns1.inskillboost.local.

ns1     IN  A       192.168.1.10
www     IN  A       192.168.1.20
```

Explication des champs :
- `$TTL` : durée de vie par défaut des enregistrements
- `SOA` : Start of Authority, informations sur la zone et le serveur maître
- `NS` : serveur de noms (ici `ns1`)
- `A` : association entre un nom et une adresse IPv4

Le champ **Serial** (numéro de série) doit être **incrémenté à chaque modification** du fichier.



## 4.5 Étape 3 : Vérification de la syntaxe

Avant de redémarrer BIND, il est essentiel de vérifier la validité de la configuration.

#### Vérification de la configuration générale :

```bash
sudo named-checkconf
```

Aucune sortie signifie qu’il n’y a pas d’erreur.

#### Vérification du fichier de zone :

```bash
sudo named-checkzone inskillboost.local /etc/bind/zones/db.inskillboost.local
```

Sortie attendue :

```
zone inskillboost.local/IN: loaded serial 1
OK
```



## 4.6 Étape 4 : Redémarrage du service BIND9

```bash
sudo systemctl restart bind9
```

Ensuite, vérifier que le service est actif :

```bash
sudo systemctl status bind9
```



## 4.7 Étape 5 : Test de la résolution DNS

Depuis un client configuré pour utiliser ce serveur DNS (ou directement sur le serveur lui-même) :

#### a. Avec `dig` :

```bash
dig @127.0.0.1 www.inskillboost.local
```

#### b. Avec `host` :

```bash
host www.inskillboost.local 127.0.0.1
```

#### c. Avec `nslookup` :

```bash
nslookup www.inskillboost.local 127.0.0.1
```

> Dans tous les cas, la réponse doit contenir l’adresse IP `192.168.1.20`



## 4.8 Résumé des fichiers créés/modifiés

| Fichier | Rôle |
|--------|------|
| `/etc/bind/named.conf.local` | Déclaration de la zone DNS |
| `/etc/bind/zones/db.inskillboost.local` | Fichier de zone contenant les enregistrements A |
| Configuration vérifiée avec `named-checkconf` et `named-checkzone` |

