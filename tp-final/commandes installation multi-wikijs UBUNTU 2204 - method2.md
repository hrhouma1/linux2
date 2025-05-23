# Tutoriel complet – Méthode 2 : Wiki.js multi-instance via chemins Nginx sur Azure

## Objectif

Déployer trois instances de Wiki.js dans une VM Azure Ubuntu 22.04, chacune isolée, et les rendre accessibles depuis un même nom de domaine Azure grâce à un reverse proxy Nginx configuré avec :

* [http://wikivm.eastus.cloudapp.azure.com/site1](http://wikivm.eastus.cloudapp.azure.com/site1)
* [http://wikivm.eastus.cloudapp.azure.com/site2](http://wikivm.eastus.cloudapp.azure.com/site2)
* [http://wikivm.eastus.cloudapp.azure.com/site3](http://wikivm.eastus.cloudapp.azure.com/site3)

<br/>

## Étape 1 – Préparer la VM dans Azure

1. Crée une machine virtuelle Ubuntu Server 22.04 LTS.
2. Active un **nom DNS public** (ex. `wikivm.eastus.cloudapp.azure.com`).
3. Ouvre les ports suivants dans le groupe de sécurité réseau :

   * TCP port 22 (SSH)
   * TCP port 80 (HTTP)
   * TCP port 443 (HTTPS, si HTTPS envisagé)
   * TCP ports internes : 3001, 3002, 3003 (accessibles uniquement localement)

---

## Étape 2 – Connexion SSH et mise à jour de la VM

```bash
ssh azureuser@wikivm.eastus.cloudapp.azure.com
```

Mise à jour système :

```bash
sudo apt update && sudo apt upgrade -y
```

<br/>

## Étape 3 – Installer les dépendances

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y git nodejs mariadb-server nginx
```

Vérification :

```bash
node -v
npm -v
git --version
```

---

## Étape 4 – Sécuriser MariaDB et créer les bases

```bash
sudo mysql_secure_installation
sudo mysql -u root -p
```

Dans MariaDB :

```sql
CREATE DATABASE wikidb1;
CREATE USER 'wikidb_user1'@'localhost' IDENTIFIED BY 'MotDePasseFort1';
GRANT ALL PRIVILEGES ON wikidb1.* TO 'wikidb_user1'@'localhost';

CREATE DATABASE wikidb2;
CREATE USER 'wikidb_user2'@'localhost' IDENTIFIED BY 'MotDePasseFort2';
GRANT ALL PRIVILEGES ON wikidb2.* TO 'wikidb_user2'@'localhost';

CREATE DATABASE wikidb3;
CREATE USER 'wikidb_user3'@'localhost' IDENTIFIED BY 'MotDePasseFort3';
GRANT ALL PRIVILEGES ON wikidb3.* TO 'wikidb_user3'@'localhost';

FLUSH PRIVILEGES;
EXIT;
```

---

## Étape 5 – Créer les utilisateurs système et dossiers

Pour chaque instance (site1, site2, site3) :

```bash
sudo adduser --system --group site1
sudo mkdir -p /var/www/site1
sudo chown -R site1:site1 /var/www/site1
sudo usermod -s /bin/bash site1
```

<br/>

## Étape 6 – Installer Wiki.js (exemple pour site1)

```bash
sudo su - site1
cd /var/www/site1
wget https://github.com/Requarks/wiki/releases/latest/download/wiki-js.tar.gz
tar xzf wiki-js.tar.gz
rm wiki-js.tar.gz
cp config.sample.yml config.yml
nano config.yml
```

Configuration `config.yml` de `site1` :

```yaml
db:
  type: mariadb
  host: localhost
  port: 3306
  user: wikidb_user1
  pass: MotDePasseFort1
  db: wikidb1
  ssl: false

bindIP: 127.0.0.1
port: 3001
```

Sortir :

```bash
exit
```

Faire de même pour `site2` (port 3002) et `site3` (port 3003)

<br/>

## Étape 7 – Créer les services systemd

Exemple pour `site1` :

```bash
sudo nano /etc/systemd/system/site1.service
```

Contenu :

```ini
[Unit]
Description=Wiki.js instance site1
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/node server
Restart=always
User=site1
Environment=NODE_ENV=production
WorkingDirectory=/var/www/site1

[Install]
WantedBy=multi-user.target
```

Activer et démarrer :

```bash
sudo systemctl daemon-reload
sudo systemctl enable site1
sudo systemctl start site1
```

Faire pareil pour `site2.service` (port 3002) et `site3.service` (port 3003)

<br/>

## Étape 8 – Configurer Nginx

Créer un fichier de configuration :

```bash
sudo nano /etc/nginx/sites-available/wikijs
```

Contenu :

```nginx
server {
    listen 80;
    server_name wikivm.eastus.cloudapp.azure.com;

    location /site1/ {
        proxy_pass http://127.0.0.1:3001/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /site2/ {
        proxy_pass http://127.0.0.1:3002/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /site3/ {
        proxy_pass http://127.0.0.1:3003/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Activer le site :

```bash
sudo ln -s /etc/nginx/sites-available/wikijs /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

<br/>

## Étape 9 – Accès aux sites

Depuis un navigateur, accéder aux URL suivantes :

* [http://wikivm.eastus.cloudapp.azure.com/site1/](http://wikivm.eastus.cloudapp.azure.com/site1/)
* [http://wikivm.eastus.cloudapp.azure.com/site2/](http://wikivm.eastus.cloudapp.azure.com/site2/)
* [http://wikivm.eastus.cloudapp.azure.com/site3/](http://wikivm.eastus.cloudapp.azure.com/site3/)

Tu devrais voir l’assistant de configuration de Wiki.js pour chaque instance.

<br/>

## Étape 10 – Ajout du HTTPS (facultatif)

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d wikivm.eastus.cloudapp.azure.com
```

