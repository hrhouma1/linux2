# Chapitre 8 – Travaux Pratiques (TP)

### Objectif général

Mettre en œuvre les connaissances théoriques sur un environnement réel ou virtualisé, en suivant des scénarios pratiques. Ces TPs permettent de :
- Configurer un serveur DNS complet avec BIND9
- Créer et tester des zones directe et inverse
- Diagnostiquer des erreurs courantes
- Appliquer les bonnes pratiques de sécurisation



# TP1 : Installer et démarrer un serveur DNS BIND9

**But** : Mettre en place un serveur BIND9 fonctionnel sur une machine Debian/Ubuntu.

**Étapes** :
1. Créer une machine virtuelle (ou utiliser un conteneur) sous Ubuntu Server
2. Installer BIND9 avec :
   ```bash
   sudo apt update
   sudo apt install bind9 bind9utils bind9-doc dnsutils -y
   ```
3. Vérifier que le service est actif :
   ```bash
   sudo systemctl status bind9
   ```



# TP2 : Création d’une zone DNS directe

**But** : Ajouter une zone DNS gérée localement et effectuer la résolution d’un nom en IP.

**Contexte** :
- Domaine : `monreseau.local`
- Serveur de nom : `ns1.monreseau.local` → `192.168.50.10`
- Site web : `www.monreseau.local` → `192.168.50.20`

**Étapes** :
1. Déclarer la zone dans `/etc/bind/named.conf.local` :
   ```bash
   zone "monreseau.local" {
       type master;
       file "/etc/bind/zones/db.monreseau.local";
   };
   ```
2. Créer le fichier `/etc/bind/zones/db.monreseau.local`
3. Ajouter les enregistrements A et NS
4. Vérifier avec `named-checkzone`
5. Redémarrer BIND et tester avec `dig` et `host`



# TP3 : Création d’une zone inverse

**But** : Configurer une zone inverse pour `192.168.50.0/24`

**Étapes** :
1. Déclarer la zone dans `named.conf.local` :
   ```bash
   zone "50.168.192.in-addr.arpa" {
       type master;
       file "/etc/bind/zones/db.192";
   };
   ```
2. Créer `/etc/bind/zones/db.192`
3. Ajouter les enregistrements PTR pour :
   - `192.168.50.10 → ns1.monreseau.local`
   - `192.168.50.20 → www.monreseau.local`
4. Vérifier et redémarrer BIND
5. Tester avec `dig -x` et `nslookup`


# TP4 : Ajouter des enregistrements DNS supplémentaires

**But** : Ajouter des enregistrements spécifiques pour simuler une infrastructure réelle.

**Nouveaux enregistrements à ajouter** :
- `mail.monreseau.local` → `192.168.50.30` (A)
- `@ MX 10 mail.monreseau.local.` (MX)
- `ftp.monreseau.local` → alias de `www.monreseau.local` (CNAME)

**Étapes** :
1. Modifier le fichier de zone directe
2. Incrémenter le numéro de série (SOA)
3. Vérifier, redémarrer BIND
4. Tester chaque enregistrement



# TP5 : Sécuriser le serveur DNS

**But** : Appliquer des règles de sécurité de base

**Tâches** :
1. Limiter les requêtes aux clients internes :
   ```bash
   allow-query { 127.0.0.1; 192.168.50.0/24; };
   allow-recursion { 127.0.0.1; 192.168.50.0/24; };
   ```
2. Restreindre le transfert de zone :
   ```bash
   allow-transfer { 192.168.50.11; };
   ```
3. Créer un fichier de log dédié et configurer une section `logging`
4. Vérifier les droits d’accès sur `/etc/bind/zones`



# TP6 : Déboguer une erreur DNS

**But** : Comprendre et corriger des erreurs courantes

**Situation simulée** :
- Le fichier de zone contient un `;` manquant ou un champ oublié
- Le numéro de série n’a pas été incrémenté
- Le nom de fichier est incorrect

**Tâches** :
1. Identifier le problème avec :
   ```bash
   sudo named-checkzone
   sudo systemctl status bind9
   sudo journalctl -xe
   ```
2. Corriger les erreurs
3. Relancer le service et tester à nouveau



# TP7 : Mise en œuvre d’un DNS secondaire (bonus)

**But** : Configurer un serveur DNS esclave qui récupère les données du serveur maître

**Pré-requis** : Deux machines (ou deux conteneurs)

**Tâches** :
1. Sur le maître, autoriser le transfert vers l’IP du serveur secondaire
2. Sur le secondaire, déclarer la zone comme `type slave`, avec le bon `masters`
3. Redémarrer les deux services
4. Vérifier que les fichiers sont bien transférés



# Résumé des compétences exercées

| TP | Compétence principale |
|----|------------------------|
| 1  | Installation de BIND9 |
| 2  | Zone directe |
| 3  | Zone inverse |
| 4  | Enregistrements DNS |
| 5  | Sécurisation |
| 6  | Débogage |
| 7  | Maître/Esclave |


