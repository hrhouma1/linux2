# Introduction à Dovecot

# 1. Définition

**Dovecot** est un **MDA** (Mail Delivery Agent) et **IMAP/POP3 server**.

Il ne s’occupe **ni de l’envoi** des courriels (rôle de Postfix), **ni de leur acheminement**, mais plutôt de leur **stockage** et de leur **consultation** par les utilisateurs via des clients de messagerie (Thunderbird, Outlook, etc.).

Il est :
- Open-source
- Léger, sécurisé et hautement compatible
- Compatible avec les formats de stockage Maildir et mbox

<br/>

# 2. Rôle et utilité

Dovecot est responsable des actions suivantes :

- **Stocker les mails** reçus via Postfix
- **Permettre aux utilisateurs de lire leurs mails** via IMAP ou POP3
- **Gérer les boîtes aux lettres**, les authentifications, les droits d’accès
- **Chiffrer les connexions**, appliquer TLS/SSL
- **Gérer les quotas utilisateurs** et filtrer les courriels localement

<br/>

# 3. Protocole IMAP vs POP3

| Protocole | IMAP | POP3 |
|-----------|------|------|
| Mode | Consultation en ligne | Téléchargement local |
| Synchronisation | Oui (boîte à jour sur tous les clients) | Non (copie locale uniquement) |
| Multi-appareils | Adapté | Peu adapté |
| Usage typique | Utilisateurs modernes (mobile, PC, webmail) | Archivage local, accès limité |

Dovecot peut gérer les deux, mais **IMAP est le choix recommandé** dans 95 % des cas.

<br/>

# 4. Pourquoi utiliser Dovecot ?

### Avantages :

- **Très sécurisé**, régulièrement audité
- **Haute performance**, même sur de gros volumes de mails
- **Compatible avec Postfix**
- **Supporte LDAP, SQL, PAM, etc. pour l’authentification**
- **Extensible** : support des quotas, des scripts Sieve (filtres), du chiffrement TLS/SSL
- **Documentation complète**

### Inconvénients :

- **Nécessite une bonne configuration initiale** (fichiers de conf, droits sur les boîtes, formats, permissions)
- **Pas de webmail intégré** (il faut l’associer à Roundcube, Rainloop, etc.)

<br/>

# 5. Alternatives à Dovecot

| Outil | Rôle similaire | Observations |
|-------|----------------|--------------|
| Courier | Serveur IMAP/POP3 | Ancien, moins performant que Dovecot |
| Cyrus IMAP | Serveur IMAP avancé | Très robuste mais plus complexe à administrer |
| IMAP intégré (Zimbra, Mailcow) | Plateformes complètes | Incluent leur propre serveur IMAP intégré |

Dovecot est considéré comme la **solution la plus simple, légère et robuste** à mettre en œuvre avec Postfix.

<br/>

# 6. Cas d’usage typiques

- Serveur de messagerie **Postfix + Dovecot** pour les utilisateurs d’un intranet ou d’une PME
- Hébergement de courriels pour un nom de domaine personnel
- Plateforme pédagogique pour apprendre l’administration d’un serveur de messagerie complet
- Configuration de **serveur mail sécurisé avec authentification TLS/SSL**

<br/>

# 7. Architecture typique Postfix + Dovecot

```
[Utilisateur distant] --> [Postfix - SMTP] --> [Boîte mail stockée localement]
                                             |
                                [Dovecot - IMAP/POP3]
                                             |
                        [Client mail : Thunderbird / Outlook]
```

- Postfix reçoit les mails et les dépose dans `/home/user/Maildir/`
- Dovecot permet à l’utilisateur de consulter ces mails via IMAP ou POP3
- TLS/SSL peut chiffrer les connexions entrantes

<br/>

# 8. Composants de Dovecot

- **dovecot.conf** : fichier de configuration principal
- **auth.conf** : mécanismes d’authentification (PAM, LDAP, SQL...)
- **10-mail.conf** : format de boîte (Maildir, mbox)
- **10-ssl.conf** : paramètres de chiffrement TLS
- **10-master.conf** : configuration des services IMAP, POP3, LMTP
- **Quota, Sieve, Logging, Plugin** : modules optionnels activables

<br/>

# 9. Conclusion

Dovecot est une **brique essentielle** dans toute architecture de messagerie moderne auto-hébergée. Il :

- Permet l’accès aux mails par IMAP/POP3
- Gère les connexions sécurisées, l’authentification, les quotas et les droits
- S’intègre parfaitement avec Postfix
- Est reconnu pour sa **fiabilité, sa sécurité et sa simplicité**

