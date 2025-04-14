
# **Différence entre SMTP et IMAP**

# 1. Nature des deux protocoles

| Protocole | Nom complet | Rôle principal |
|-----------|-------------|----------------|
| **SMTP** | Simple Mail Transfer Protocol | Sert à **envoyer** des courriels |
| **IMAP** | Internet Message Access Protocol | Sert à **consulter** les courriels sur un serveur |

<br/>

# 2. Rôle détaillé de chaque protocole

### a) **SMTP – Protocole d'envoi**

- Utilisé pour **transmettre un email** d’un client à un serveur, ou d’un serveur à un autre.
- Utilisé par les **serveurs comme Postfix**.
- **Ne sauvegarde pas les mails** : il les **achemine** (comme un facteur).
- Ports utilisés :
  - **25** : serveur à serveur
  - **587** : envoi authentifié depuis un client
  - **465** : SMTP sécurisé (ancien, SSL)

**SMTP est un protocole de transmission, pas de stockage.**

<br/>

### b) **IMAP – Protocole de lecture et de synchronisation**

- Utilisé par un **client de messagerie** (comme Thunderbird ou Outlook) pour **accéder aux courriels stockés sur un serveur**.
- Le mail **reste stocké sur le serveur** (contrairement à POP3).
- Permet :
  - Accès à plusieurs dossiers (boîte de réception, brouillons, envoyés, etc.)
  - Synchronisation sur plusieurs appareils (PC, téléphone, webmail)
  - Marquer les mails comme lus, supprimés, etc.

- Port utilisé :
  - **143** : IMAP sans chiffrement
  - **993** : IMAP sécurisé (IMAPS)

**IMAP est un protocole de consultation avec conservation sur le serveur.**

<br/>

# 3. Et POP3 dans tout ça ?

| Protocole | Fonction |
|-----------|----------|
| POP3 | Télécharge les mails puis les **supprime du serveur** (sauf configuration contraire) |
| IMAP | Laisse les mails **sur le serveur** et les synchronise entre appareils |

<br/>

# 4. Analogie simple

Imaginez que le serveur de messagerie est une **boîte aux lettres centrale**, et l’utilisateur possède un **client de messagerie** (comme Outlook).

| Action | Protocole | Ce que ça fait |
|--------|-----------|----------------|
| Vous **envoyez** une lettre à quelqu’un | SMTP | La lettre est transmise par la poste |
| Vous **ouvrez** votre boîte aux lettres pour **lire** vos lettres sans les emporter | IMAP | Lecture à distance, les lettres restent dans la boîte |
| Vous **retirez** physiquement les lettres de la boîte | POP3 | Téléchargement puis suppression du serveur |

<br/>

# 5. Sauvegarde des courriels : qui fait quoi ?

| Protocole | Les mails sont-ils **stockés** ? | Où ? |
|-----------|--------------------------|-------|
| SMTP | Non | Transit temporaire uniquement |
| IMAP | Oui | Sur le serveur mail (ex: Dovecot + Maildir) |
| POP3 | Non (par défaut) | Les mails sont **téléchargés localement**, puis supprimés du serveur |

Donc :

- Un serveur utilisant **IMAP** permet aux utilisateurs de **garder leurs mails** sur le serveur, et d’y accéder de partout.
- Un système basé sur **POP3** **ne conserve pas** les mails sur le serveur une fois qu’ils ont été lus.
- **SMTP n’a rien à voir avec le stockage**, il ne fait qu’**envoyer** les messages.

<br/>

# 6. Synthèse des différences

| Protocole | Type | Utilisation | Stockage des mails |
|-----------|------|-------------|--------------------|
| SMTP | Envoi | De l’expéditeur au serveur ou entre serveurs | Non |
| IMAP | Réception/Lecture | Du serveur vers le client (accès distant) | Oui |
| POP3 | Réception locale | Téléchargement unique depuis le serveur | Non (par défaut) |

