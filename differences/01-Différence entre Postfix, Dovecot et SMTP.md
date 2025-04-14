# Différence entre Postfix, Dovecot et SMTP

| Élément | Type | Rôle principal |
|---------|------|----------------|
| **Postfix** | MTA (Mail Transfer Agent) | Envoi et transfert de mails via SMTP |
| **Dovecot** | MDA (Mail Delivery Agent) + Serveur IMAP/POP3 | Stockage et consultation des mails |
| **SMTP** | Protocole (Simple Mail Transfer Protocol) | Protocole de communication utilisé pour envoyer/transférer des mails |

<br/>

# 1. **Postfix : le serveur d’envoi**

- **Logiciel installé sur le serveur**
- Utilise le **protocole SMTP**
- Il **reçoit** les mails venant de l’extérieur (Internet), ou de vos applications internes
- Il **transfère** les mails vers le bon destinataire (soit localement, soit vers d'autres serveurs)
- Il **remet les mails localement** dans une boîte aux lettres si le destinataire est un utilisateur du serveur

**Postfix = l’équivalent d’un facteur qui reçoit et expédie des lettres.**


<br/>

# 2. **Dovecot : le serveur de consultation**

- **Logiciel installé sur le même serveur ou un serveur dédié**
- Ne participe pas à l’envoi des mails
- Son rôle est de **permettre aux utilisateurs de lire leurs mails**
- Il lit les mails **stockés localement** (souvent dans `/home/user/Maildir/`)
- Il utilise les **protocoles IMAP ou POP3** pour exposer la boîte mail à distance
- Il **gère les connexions** des utilisateurs (authentification, chiffrement)

**Dovecot = le facteur qui vous donne votre courrier quand vous ouvrez la boîte.**


<br/>


# 3. **SMTP : le protocole d’envoi**

- Ce n’est pas un logiciel, mais un **protocole standard**
- Utilisé pour **transporter les courriels entre serveurs** ou depuis un client vers un serveur
- Port standard : **25** (serveur à serveur), **587** (envoi authentifié)
- **Postfix utilise SMTP** pour envoyer les mails

**SMTP = la route utilisée par les lettres entre les bureaux de poste.**



<br/>


# 4. **Vue globale du processus d’envoi/réception d’un email**

### a) Lorsqu’un utilisateur envoie un mail :

1. Son **client mail (ex: Outlook)** se connecte au **serveur SMTP** (port 587)
2. Le client envoie le message via SMTP à **Postfix**
3. **Postfix** décide où envoyer le mail (externe ou interne)
   - Si le destinataire est local : il livre dans la boîte (Maildir)
   - Sinon : il le transmet à un autre serveur SMTP (externe)

### b) Lorsqu’un utilisateur lit ses mails :

1. Le mail a été **stocké localement** par Postfix (dans Maildir)
2. Le **client mail (Outlook, Thunderbird)** se connecte à **Dovecot** en **IMAP** ou **POP3**
3. **Dovecot** lit les mails dans le système de fichiers et les affiche


<br/>



# 5. **Synthèse**

| Fonction | Logiciel ou Protocole | Rôle |
|----------|------------------------|------|
| Envoi de mails | Postfix + SMTP | Le message part de l'utilisateur et est envoyé au serveur destinataire |
| Réception des mails | Postfix | Reçoit le message et le stocke sur le serveur |
| Lecture des mails | Dovecot + IMAP/POP3 | Permet à l'utilisateur d'accéder à ses mails stockés |



<br/>


# 6. Schéma simplifié

```
Utilisateur (Outlook) 
    |
    | SMTP (port 587)
    V
[POSTFIX (envoi)]
    |
    V
Internet / Serveurs mails distants
    |
    V
[POSTFIX (réception)]
    |
    | écrit le mail dans /home/user/Maildir/
    V
[DOVECOT (IMAP/POP3)]
    |
    | IMAP (port 993)
    V
Utilisateur (consultation)
```
