# Partie 1

# 1.1. Code 

```bash
mydomain = ns.local
home_mailbox = Maildir/
message_size_limit = 52428800

smtp_sasl_auth_enable = yes
smtp_use_tls = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = 
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

smtps_sasl_auth_enable = yes

smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no
```

# 1.2. Commentaires


```bash
# Définir le nom de domaine utilisé par Postfix
mydomain = ns.local

# Spécifie où sont stockés les courriels des utilisateurs (au format Maildir)
home_mailbox = Maildir/

# Limite de taille maximale des messages en octets (ici 50 Mo)
message_size_limit = 52428800

# Active l’authentification SASL (Simple Authentication and Security Layer) pour l’envoi SMTP
smtp_sasl_auth_enable = yes

# Oblige l’utilisation de TLS pour sécuriser les communications SMTP
smtp_use_tls = yes

# Fichier de correspondance des identifiants SMTP (login/mot de passe)
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd

# Options de sécurité pour SASL (vide ici, mais peut contenir 'noanonymous', etc.)
smtp_sasl_security_options = 

# Fichier contenant les certificats des autorités de certification pour valider TLS
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

# Active SASL aussi pour le SMTPS (port 465 sécurisé)
smtps_sasl_auth_enable = yes

# Message de bienvenue SMTP visible lors de la connexion au serveur
smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)

# Désactive les notifications de nouveaux mails locales (héritage de BSD)
biff = no

# Ne pas ajouter automatiquement ".mydomain" à l’adresse e-mail
append_dot_mydomain = no

# Permet de générer des avertissements si un e-mail est retardé (décommenter pour activer)
#delay_warning_time = 4h

# Désactive l’utilisation du répertoire README pour la documentation intégrée
readme_directory = no
```



# 1.3. **Informations principales de configuration Postfix**

| Clé                             | Valeur                                                        | Description |
|----------------------------------|----------------------------------------------------------------|-------------|
| `mydomain`                       | `ns.local`                                                    | Nom de domaine utilisé par le serveur |
| `home_mailbox`                  | `Maildir/`                                                    | Emplacement du répertoire Maildir pour les utilisateurs |
| `message_size_limit`           | `52428800` (soit 50 Mo)                                       | Taille maximale autorisée pour un message |
| `smtp_sasl_auth_enable`        | `yes`                                                         | Active l’authentification SASL pour l’envoi SMTP |
| `smtp_use_tls`                 | `yes`                                                         | Utilise TLS pour sécuriser les connexions SMTP |
| `smtp_sasl_password_maps`      | `hash:/etc/postfix/sasl_passwd`                               | Fichier contenant les identifiants d’authentification SMTP |
| `smtp_sasl_security_options`   | non spécifié (ligne présente mais sans valeur ou défaut)      | Options de sécurité SASL (souvent `noanonymous`) |
| `smtp_tls_CAfile`              | `/etc/ssl/certs/ca-certificates.crt`                          | Fichier contenant les certificats CA pour valider TLS |
| `smtps_sasl_auth_enable`       | `yes`                                                         | Active SASL pour SMTPS (port 465) |



# 1.4. **Autres paramètres**

| Clé                             | Valeur                             | Description |
|----------------------------------|-------------------------------------|-------------|
| `smtpd_banner`                   | `$myhostname ESMTP $mail_name (Ubuntu)` | Message de bienvenue SMTP |
| `biff`                           | `no`                                | Désactive les notifications de nouveaux mails |
| `append_dot_mydomain`           | `no`                                | Ne pas ajouter automatiquement `.mydomain` |
| `readme_directory`              | `no`                                | Pas de répertoire README défini |


# Partie 2


```bash
smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# See http://www.postfix.org/COMPATIBILITY_README.html -- default to 2 on
# fresh installs.
compatibility_level = 2
```


# Partie 3

```bash
cat /etc/postfix/main.cf
```


```bash
# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_tls_security_level=may

smtp_tls_CApath=/etc/ssl/certs
smtp_tls_security_level=may
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = ubuntu.ns.local
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = $myhostname, ubuntu, localhost.localdomain, ns.local, mail.ns.local, localhost
relayhost = [smtp.gmail.com]:587
virtual_alias_maps = hash:/etc/postfix/virtual
mynetworks = 127.0.0.0/8, 192.168.2.0/24
mailbox_size_limit = 0
recipient_delimiter = +
```



#  Annexe


```
 # See /usr/share/postfix/main.cf.dist for a commented, more complete version


# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
#myorigin = /etc/mailname

mydomain = ns.local
home_mailbox = Maildir/
message_size_limit = 52428800

smtp_sasl_auth_enable = yes
smtp_use_tls = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options =
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

smtps_sasl_auth_enable = yes


smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# See http://www.postfix.org/COMPATIBILITY_README.html -- default to 3.6 on
# fresh installs.
compatibility_level = 2



# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_tls_security_level=may

smtp_tls_CApath=/etc/ssl/certs
smtp_tls_security_level=may
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache


smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = ubuntu.ns.local
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = $myhostname, ubuntu, eleve, localhost.localdomain, ns.local, mail.ns.local, localhost
relayhost = [smtp.gmail.com]:587
virtual_alias_maps = hash:/etc/postfix/virtual
mynetworks = 127.0.0.0/8, 192.168.2.0/24
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = all
```
