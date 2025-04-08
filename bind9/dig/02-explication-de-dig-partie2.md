# **Cours partie 2 : La commande `dig` (Domain Information Groper)**

---

## **1. Introduction à `dig`**

### 1.1 Définition
`dig` (Domain Information Groper) est un outil en ligne de commande utilisé pour **interroger les serveurs DNS** et **diagnostiquer les problèmes de résolution de noms**. Il est largement utilisé par les administrateurs système et les professionnels réseau.

### 1.2 Pourquoi utiliser `dig` ?
- Obtenir des détails sur les enregistrements DNS (A, AAAA, MX, NS, CNAME, etc.)
- Tester la résolution DNS directe et inverse
- Interroger un serveur DNS spécifique
- Diagnostiquer des erreurs DNS
- Suivre les chemins de résolution (requêtes récursives ou itératives)

---

## **2. Syntaxe générale**

```bash
dig [@serveur_DNS] nom_de_domaine [type] [options]
```

- `@serveur_DNS` (facultatif) : interroge un serveur DNS spécifique (ex: `@8.8.8.8`)
- `nom_de_domaine` : le nom à résoudre (ex: `google.com`)
- `type` : le type d’enregistrement à interroger (ex: `A`, `MX`, `NS`, etc.)
- `options` : des options supplémentaires (ex: `+short`, `+trace`, etc.)

---

## **3. Types d’enregistrements les plus utilisés**

| Type      | Description                                      |
|-----------|--------------------------------------------------|
| `A`       | Adresse IPv4 d’un domaine                        |
| `AAAA`    | Adresse IPv6 d’un domaine                        |
| `MX`      | Serveur de messagerie                            |
| `NS`      | Serveurs de noms (DNS) d’un domaine              |
| `CNAME`   | Alias (Canonical Name)                           |
| `TXT`     | Texte libre (utilisé pour SPF, DKIM, etc.)       |
| `PTR`     | Enregistrement de zone inverse (IP vers nom)     |
| `ANY`     | Tous les enregistrements disponibles             |

---

## **4. Utilisation de base**

### 4.1 Interroger un domaine
```bash
dig example.com
```

Par défaut, `dig` effectue une requête de type `A`.

---

### 4.2 Interroger un type spécifique d’enregistrement
```bash
dig example.com MX
dig example.com AAAA
dig example.com NS
```

---

### 4.3 Interroger un serveur DNS spécifique
```bash
dig @8.8.8.8 example.com
```

---

### 4.4 Affichage simplifié avec `+short`
```bash
dig example.com A +short
```

Sortie :
```
93.184.216.34
```

---

## **5. Résolution inverse (IP → nom)**

### 5.1 Commande classique
```bash
dig -x 192.0.2.1
```

### 5.2 Avec affichage court
```bash
dig -x 192.0.2.1 +short
```

---

## **6. Options avancées**

| Option        | Fonction                                               |
|---------------|--------------------------------------------------------|
| `+short`      | Affichage minimaliste (résultat brut)                  |
| `+trace`      | Affiche chaque étape de la résolution DNS              |
| `+stats`      | Affiche des statistiques de la requête                 |
| `+tcp`        | Force l’utilisation de TCP (au lieu d’UDP)             |
| `+time=N`     | Définit le délai maximal d’attente (en secondes)       |
| `+nocomments` | Supprime les commentaires de sortie                    |
| `+noquestion` | N’affiche pas la section question                      |
| `+noauthority`| N’affiche pas la section autorité                      |
| `+nocmd`      | Supprime la ligne de commande initiale dans la sortie  |

---

## **7. Résultats de `dig` : décryptage**

Une sortie complète de `dig` contient plusieurs sections :

### Exemple :
```bash
dig example.com
```

### Sortie :
```text
; <<>> DiG 9.16.1-Ubuntu <<>> example.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12345
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; QUESTION SECTION:
;example.com.                  IN      A

;; ANSWER SECTION:
example.com.           3600    IN      A       93.184.216.34

;; Query time: 20 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Mon Apr 08 13:45:00 UTC 2025
;; MSG SIZE  rcvd: 65
```

### Analyse :
- **QUESTION SECTION** : la requête envoyée
- **ANSWER SECTION** : la réponse DNS (type A ici)
- **Query time** : temps de réponse en millisecondes
- **SERVER** : serveur DNS utilisé
- **MSG SIZE** : taille de la réponse

---

## **8. Cas pratiques**

### 8.1 Obtenir tous les enregistrements
```bash
dig example.com ANY
```

### 8.2 Résolution DNS via un serveur local
```bash
dig @127.0.0.1 www.monreseau.local
```

### 8.3 Vérifier la chaîne complète de résolution DNS
```bash
dig +trace www.example.com
```

---

## **9. Cas d’usage pour les étudiants / TP**

### TP1 : Afficher l’adresse IP de `www.ubuntu.com`
```bash
dig www.ubuntu.com +short
```

### TP2 : Tester les serveurs de messagerie d’un domaine
```bash
dig gmail.com MX +short
```

### TP3 : Obtenir les serveurs DNS autoritaires d’un domaine
```bash
dig mozilla.org NS
```

### TP4 : Tracer la résolution DNS depuis la racine
```bash
dig +trace www.linux.org
```

### TP5 : Résolution inverse avec `dig -x`
```bash
dig -x 8.8.8.8
```

---

## **10. Résumé des bonnes pratiques**

| Bonnes pratiques | Explication |
|------------------|-------------|
| Toujours utiliser `+short` pour des scripts automatiques | Réduction de la sortie |
| Utiliser `@8.8.8.8` pour éviter les caches locaux         | Résolution propre |
| Utiliser `+trace` pour comprendre la chaîne de résolution | Diagnostic avancé |
| Coupler `dig` avec `grep` pour filtrer                    | Par exemple `dig example.com | grep ANSWER` |

