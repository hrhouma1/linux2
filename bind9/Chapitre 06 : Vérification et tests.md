# Chapitre 6 – Vérification et tests DNS

## 6.1 Objectif

Après avoir configuré les zones directe et inverse dans BIND9, il est indispensable de **vérifier la validité syntaxique** des fichiers et de **tester la résolution DNS** pour s'assurer du bon fonctionnement du serveur.

Ce chapitre présente :
- Les outils de validation fournis avec BIND
- Les tests fonctionnels à l’aide des commandes `dig`, `host`, `nslookup`
- La lecture des fichiers de journalisation pour le débogage



## 6.2 Vérification de la configuration de BIND9

#### a. Vérification générale de la configuration (`named-checkconf`)

Cette commande vérifie la syntaxe de l’ensemble des fichiers de configuration de BIND :

```bash
sudo named-checkconf
```

> Aucun message = aucune erreur détectée.  
> S'il y a une erreur, le chemin exact du fichier fautif est affiché.

#### b. Vérification d’un fichier de zone (`named-checkzone`)

Permet de vérifier la validité syntaxique d’un fichier de zone (directe ou inverse).

Exemple pour la zone directe :

```bash
sudo named-checkzone inskillboost.local /etc/bind/zones/db.inskillboost.local
```

Exemple pour la zone inverse :

```bash
sudo named-checkzone 1.168.192.in-addr.arpa /etc/bind/zones/db.192
```

Sortie attendue :

```
zone inskillboost.local/IN: loaded serial 1
OK
```



## 6.3 Redémarrage de BIND9

Après toute modification valide :

```bash
sudo systemctl restart bind9
```

Vérifier que le service est actif :

```bash
sudo systemctl status bind9
```



## 6.4 Test de résolution DNS

#### a. Commande `dig`

`dig` est un outil puissant pour interroger les serveurs DNS.

**Test de résolution directe :**

```bash
dig @127.0.0.1 www.inskillboost.local
```

Résultat attendu dans la section ANSWER :

```
;; ANSWER SECTION:
www.inskillboost.local. 604800 IN A 192.168.1.20
```

**Test de résolution inverse :**

```bash
dig -x 192.168.1.10 @127.0.0.1
```

Résultat :

```
;; ANSWER SECTION:
10.1.168.192.in-addr.arpa. 604800 IN PTR ns1.inskillboost.local.
```



#### b. Commande `host`

Plus simple et plus lisible que `dig`, mais moins complet.

**Résolution directe :**

```bash
host www.inskillboost.local 127.0.0.1
```

**Résolution inverse :**

```bash
host 192.168.1.10 127.0.0.1
```



#### c. Commande `nslookup`

Outil interactif et également utilisable en ligne de commande :

```bash
nslookup www.inskillboost.local 127.0.0.1
```

```bash
nslookup 192.168.1.20 127.0.0.1
```

## 6.5 Lecture des logs DNS

Par défaut, BIND envoie ses messages vers le journal système `syslog`.

Afficher les dernières lignes liées à BIND9 :

```bash
sudo journalctl -u bind9
```

Ou filtrer avec `grep` :

```bash
sudo grep named /var/log/syslog
```

Cela permet d’analyser les erreurs éventuelles :  
- Fichier manquant  
- Mauvais format  
- Incohérence dans les zones  



## 6.6 Résumé des commandes essentielles

| Commande | Description |
|----------|-------------|
| `named-checkconf` | Vérifie les fichiers de configuration globaux |
| `named-checkzone` | Vérifie la validité d’un fichier de zone |
| `systemctl restart bind9` | Redémarre le service DNS |
| `dig`, `host`, `nslookup` | Testent la résolution DNS |
| `journalctl -u bind9` | Affiche les journaux de BIND9 |
| `grep named /var/log/syslog` | Recherche les messages DNS |


