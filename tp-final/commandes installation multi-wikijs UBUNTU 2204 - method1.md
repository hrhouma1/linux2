# Tutoriel complet – Méthode 1 : Wiki.js multi-instance sur ports différents dans Azure

## Objectif

Déployer plusieurs instances de Wiki.js (ex. `site1`, `site2`, `site3`) sur **une même VM Ubuntu 22.04 hébergée dans Azure**, avec accès public via des ports différents sur le domaine gratuit fourni par Azure, de type :

```
http://<nom-vm>.<region>.cloudapp.azure.com:<port>
```

Exemples :

* [http://wikivm.eastus.cloudapp.azure.com:3001](http://wikivm.eastus.cloudapp.azure.com:3001)
* [http://wikivm.eastus.cloudapp.azure.com:3002](http://wikivm.eastus.cloudapp.azure.com:3002)
* [http://wikivm.eastus.cloudapp.azure.com:3003](http://wikivm.eastus.cloudapp.azure.com:3003)

<br/>

## Étape 1 – Création de la VM Ubuntu dans Azure

1. Connecte-toi au portail Azure : [https://portal.azure.com](https://portal.azure.com)
2. Crée une nouvelle machine virtuelle avec l’image suivante :

   * **Image** : Ubuntu Server 22.04 LTS
   * **Taille** : B1s (gratuite avec crédit)
   * **Nom DNS** : active le DNS public (ex. `wikivm.eastus.cloudapp.azure.com`)
   * **Port ouvert** : ajoute les ports **22, 3001, 3002, 3003**
3. Crée un groupe de sécurité réseau avec ces règles :

   * TCP, port 22 (SSH)
   * TCP, port 3001
   * TCP, port 3002
   * TCP, port 3003

---

## Étape 2 – Connexion SSH à la VM

```bash
ssh azureuser@wikivm.eastus.cloudapp.azure.com
```

<br/>

## Étape 3 – Mise à jour et installation des dépendances

```bash
sudo apt update && sudo apt upgrade -y
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y git nodejs mariadb-server
```

Vérification :

```bash
node -v
npm -v
git --version
```

<br/>

## Étape 4 – Sécurisation de MariaDB

```bash
sudo mysql_secure_installation
```

Répondre aux questions selon ton niveau de sécurité souhaité (mot de passe root, suppression des utilisateurs anonymes, etc.)

<br/>

## Étape 5 – Création des bases de données

Lancer le client MySQL :

```bash
sudo mysql -u root -p
```

Créer les bases et utilisateurs pour chaque site :

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

<br/>

## Étape 6 – Installation de Wiki.js pour site1

Créer l’utilisateur système :

```bash
sudo adduser --system --group site1
sudo mkdir -p /var/www/site1
sudo chown -R site1:site1 /var/www/site1
sudo usermod -s /bin/bash site1
```

Passer à l’utilisateur :

```bash
sudo su - site1
```

Installer Wiki.js :

```bash
cd /var/www/site1
wget https://github.com/Requarks/wiki/releases/latest/download/wiki-js.tar.gz
tar xzf wiki-js.tar.gz
rm wiki-js.tar.gz
cp config.sample.yml config.yml
nano config.yml
```

Configurer le fichier `config.yml` (site1) :

```yaml
db:
  type: mariadb
  host: localhost
  port: 3306
  user: wikidb_user1
  pass: MotDePasseFort1
  db: wikidb1
  ssl: false

bindIP: 0.0.0.0
port: 3001
```

Quitter :

```bash
exit
```

<br/>

## Étape 7 – Création du service systemd pour site1

```bash
sudo nano /etc/systemd/system/site1.service
```

Contenu :

```ini
[Unit]
Description=Wiki.js instance for site1
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

<br/>

## Étapes 8 et 9 – Répéter pour site2 et site3

Répéter les **étapes 6 et 7** pour :

* `site2` avec port `3002`, base `wikidb2`, utilisateur `wikidb_user2`
* `site3` avec port `3003`, base `wikidb3`, utilisateur `wikidb_user3`

Adapte bien :

* les noms d’utilisateur Linux : site2, site3
* les fichiers `config.yml` (port et base)
* les services systemd : `site2.service`, `site3.service`

<br/>

# Étape 10 – Vérification des services

Pour chaque service :

```bash
sudo systemctl status site1
sudo systemctl status site2
sudo systemctl status site3
```

---

## Étape 11 – Accès via navigateur

Ouvre dans ton navigateur :

* [http://wikivm.eastus.cloudapp.azure.com:3001](http://wikivm.eastus.cloudapp.azure.com:3001)
* [http://wikivm.eastus.cloudapp.azure.com:3002](http://wikivm.eastus.cloudapp.azure.com:3002)
* [http://wikivm.eastus.cloudapp.azure.com:3003](http://wikivm.eastus.cloudapp.azure.com:3003)


