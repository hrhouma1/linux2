# Chapitre 1 – Introduction au DNS et à BIND9

### 1.1 Qu’est-ce que le DNS ?

Le **DNS** (Domain Name System) est un service fondamental d’Internet et des réseaux privés. Il assure la **traduction des noms de domaines lisibles par les humains** (comme `google.com`) en **adresses IP** (comme `142.250.72.14`) que les machines peuvent interpréter et utiliser pour communiquer entre elles.

Il fonctionne comme **l’annuaire téléphonique d’Internet** : lorsqu’un utilisateur saisit une adresse dans un navigateur, le DNS permet de retrouver l’adresse IP du serveur web correspondant.

#### Rôle du DNS :
- Fournir la correspondance entre les **noms** et les **adresses IP** (résolution directe)
- Effectuer l’opération inverse : **retrouver le nom associé à une adresse IP** (résolution inverse)
- Faciliter la maintenance réseau : les noms sont plus faciles à retenir et à modifier que les adresses IP
- Participer à l’équilibrage de charge, à la redondance, à la géolocalisation, via des mécanismes DNS avancés

### 1.2 Résolution directe et résolution inverse

#### a. Résolution directe

La **résolution directe** consiste à convertir un **nom de domaine en adresse IP**.

Exemple :
```
Nom de domaine : www.exemple.local
Adresse IP     : 192.168.1.10
```
Ce type de résolution utilise des enregistrements **de type A (IPv4)** ou **AAAA (IPv6)** dans les fichiers de zone DNS.

#### b. Résolution inverse

La **résolution inverse** est l’opération inverse : elle permet d’associer une **adresse IP à un nom de domaine**.

Exemple :
```
Adresse IP     : 192.168.1.10
Nom de domaine : ns1.exemple.local
```
Ce type de résolution repose sur des enregistrements **de type PTR** (Pointer Record), définis dans une **zone inverse**, par exemple :  
`10.1.168.192.in-addr.arpa.`

#### Comparaison :
| Type de résolution    | Direction                  | Enregistrement utilisé |
|------------------------|-----------------------------|-------------------------|
| Résolution directe     | Nom → Adresse IP            | A ou AAAA               |
| Résolution inverse     | Adresse IP → Nom            | PTR                     |

### 1.3 Rôle de BIND9 dans l’infrastructure réseau

**BIND9 (Berkeley Internet Name Domain, version 9)** est l’un des serveurs DNS les plus utilisés au monde, développé par l’ISC (Internet Systems Consortium).

Il joue un rôle central dans de nombreuses infrastructures réseau, aussi bien dans des environnements privés (intranets) que publics (Internet). Son fonctionnement repose sur un ensemble de fichiers de configuration, de zones, et de services réseau tournant en arrière-plan.

#### Les fonctions principales de BIND9 :
- Serveur **maître** (authoritative) : il gère les fichiers de zone pour un domaine donné.
- Serveur **esclave** (secondaire) : il récupère et réplique les données DNS d’un serveur maître.
- Serveur **cache/forwarder** : il met en cache les réponses DNS ou les transfère à un serveur tiers.
- Support des requêtes **directes et inverses**.
- Compatibilité avec IPv4, IPv6, DNSSEC, ACLs, journalisation avancée, etc.

#### Exemples d’usages de BIND9 :
- Fournir le service DNS dans un réseau d’entreprise
- Servir de cache DNS pour améliorer la rapidité des requêtes
- Simuler un environnement DNS local pour des tests
- Mettre en place une infrastructure DNS sécurisée et redondante

