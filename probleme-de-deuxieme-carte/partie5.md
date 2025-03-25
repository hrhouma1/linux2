### Tableau des commandes utiles pour le dépannage réseau sous Ubuntu Server

| Action                                   | Commande                                                      | Description                                                       |
|------------------------------------------|---------------------------------------------------------------|-------------------------------------------------------------------|
| Redémarrer le service réseau             | `sudo systemctl restart networking`                           | Redémarre le service réseau pour appliquer les changements        |
| Lister les interfaces réseau             | `ip a`                                                        | Affiche toutes les interfaces réseau avec leurs adresses IP       |
| Afficher les connexions réseau actives   | `nmcli connection show`                                       | Liste les connexions configurées par NetworkManager               |
| Activer une interface réseau             | `sudo ip link set enp0s8 up`                                  | Active une interface réseau spécifique                            |
| Vérifier l'état d’IPv4 sur une interface | `cat /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4`              | Affiche `0` si IPv4 activé, sinon `1`                             |
| Activer IPv4 sur une interface           | `echo 0 | sudo tee /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4`| Active IPv4 si précédemment désactivé                             |
| Vérifier l’adresse IP actuelle           | `ip a show enp0s8`                                            | Affiche les informations d’une interface spécifique               |
| Attribuer une adresse IP statique        | `sudo ip addr add 192.168.56.100/24 dev enp0s8`               | Assigne une adresse IP statique à une interface                   |
| Ajouter une route par défaut             | `sudo ip route add default via 192.168.56.1 dev enp0s8`       | Définit la passerelle par défaut                                  |
| Vérifier l’adresse IP après modification | `ip a show enp0s8`                                            | Confirme l'adresse IP après modification                          |
| Tester la connectivité réseau            | `ping -c 4 192.168.56.1`                                      | Teste la connectivité en envoyant 4 paquets vers la passerelle    |



### **Explication de la commande : Activer IPv4 sur une interface**  

Lorsque vous utilisez cette commande :  
```bash
echo 0 | sudo tee /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4
```

#### **Décomposition de la commande :**  
1. **`echo 0`**  
   - Génère la valeur `0` qui signifie **"IPv4 activé"**.  
   - La valeur `1` signifierait **"IPv4 désactivé"**.

2. **`|` (pipe)**  
   - Envoie (`pipe`) la valeur `0` comme entrée à la commande suivante.

3. **`sudo tee /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4`**  
   - **`sudo` :** Nécessaire car l'opération requiert des privilèges administrateur.  
   - **`tee` :** Écrit le `0` dans le fichier `/proc/sys/net/ipv4/conf/enp0s8/disable_ipv4`.  
   - **`/proc/sys/net/ipv4/conf/enp0s8/disable_ipv4` :**  
     - Fichier spécial qui contrôle si IPv4 est activé ou non pour l'interface `enp0s8`.  
     - Si la valeur est `0`, IPv4 est activé.  
     - Si la valeur est `1`, IPv4 est désactivé.  

#### **Pourquoi cette commande est utile ?**  
- Parfois, l’interface réseau est configurée pour ne pas utiliser IPv4.  
- Cela arrive si la configuration réseau est incorrecte ou si une interface nouvellement ajoutée n’est pas configurée automatiquement.  
- En activant IPv4, on permet à l’interface de communiquer via le protocole IPv4 (essentiel pour obtenir une adresse IP via DHCP par exemple).  

---

#### **Comment vérifier si IPv4 est activé ?**  
```bash
cat /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4
```
- **Retourne `0` :** IPv4 est activé.  
- **Retourne `1` :** IPv4 est désactivé.  




# Annexe 2
### **Tableau des commandes utiles pour le dépannage réseau sous Ubuntu Server**

| Action                                      | Commande                                                                 | Description                                                                                  |
|--------------------------------------------|--------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| Redémarrer le service réseau               | `sudo systemctl restart networking`                                      | Redémarre le service réseau pour appliquer les modifications                                |
| Lister toutes les interfaces réseau        | `ip a`                                                                   | Affiche toutes les interfaces réseau avec leurs adresses IP actuelles                      |
| Afficher les connexions réseau actives     | `nmcli connection show`                                                  | Liste les connexions configurées par NetworkManager                                         |
| Activer une interface réseau               | `sudo ip link set enp0s8 up`                                             | Active une interface réseau spécifique                                                      |
| Désactiver une interface réseau            | `sudo ip link set enp0s8 down`                                           | Désactive une interface réseau spécifique                                                   |
| Afficher l’état d’IPv4                     | `cat /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4`                        | Affiche `0` si IPv4 est activé, sinon `1`                                                   |
| Activer IPv4 sur une interface             | `echo 0 | sudo tee /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4`          | Active IPv4 pour l’interface spécifiée                                                      |
| Vérifier l’adresse IP actuelle             | `ip a show enp0s8`                                                       | Affiche les informations d’une interface spécifique                                         |
| Attribuer une adresse IP statique          | `sudo ip addr add 192.168.56.100/24 dev enp0s8`                          | Assigne une adresse IP statique à une interface                                             |
| Ajouter une route par défaut               | `sudo ip route add default via 192.168.56.1 dev enp0s8`                  | Définit la passerelle par défaut                                                            |
| Supprimer une adresse IP                   | `sudo ip addr del 192.168.56.100/24 dev enp0s8`                          | Supprime une adresse IP d'une interface                                                     |
| Supprimer une route par défaut             | `sudo ip route del default`                                              | Supprime la route par défaut                                                                |
| Tester la connectivité réseau              | `ping -c 4 192.168.56.1`                                                 | Envoie 4 paquets ping pour tester la connectivité                                           |
| Recharger la configuration Netplan         | `sudo netplan apply`                                                     | Applique les modifications apportées au fichier de configuration Netplan                   |
| Lister les connexions DHCP actives         | `sudo dhclient -v`                                                       | Affiche les requêtes DHCP en cours d’exécution                                              |
| Demander une nouvelle IP via DHCP          | `sudo dhclient enp0s8`                                                   | Demande une nouvelle adresse IP via DHCP pour l’interface spécifiée                         |
| Relâcher l’adresse IP actuelle             | `sudo dhclient -r enp0s8`                                                | Relâche l’adresse IP actuelle obtenue via DHCP                                              |
| Vérifier les fichiers de configuration     | `cat /etc/netplan/*.yaml`                                                | Affiche les fichiers de configuration Netplan                                               |
| Lister les routes actives                  | `ip route show`                                                          | Affiche toutes les routes actives                                                          |
| Voir les tables de routage actuelles       | `route -n`                                                               | Liste les tables de routage IPv4 actuelles                                                  |
| Recharger le fichier `/etc/resolv.conf`    | `sudo systemctl restart systemd-resolved`                                | Redémarre le service de résolution DNS                                                     |
| Vérifier le fichier de résolution DNS      | `cat /etc/resolv.conf`                                                   | Affiche les serveurs DNS utilisés par le système                                            |
| Ajouter un serveur DNS temporaire          | `sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf`                     | Ajoute un serveur DNS manuellement (non persistant après redémarrage)                      |
| Supprimer un serveur DNS                   | `sudo sed -i '/nameserver 8.8.8.8/d' /etc/resolv.conf`                   | Supprime un serveur DNS spécifique de la configuration                                      |
| Redémarrer le service NetworkManager       | `sudo systemctl restart NetworkManager`                                 | Redémarre NetworkManager (si installé)                                                      |
| Réinitialiser tous les paramètres réseau   | `sudo systemctl restart systemd-networkd`                               | Redémarre tous les services réseau gérés par systemd                                        |
| Afficher les interfaces DHCP configurées   | `nmcli device status`                                                    | Liste toutes les interfaces réseau et leurs statuts (connecté, déconnecté, etc.)           |
| Afficher les interfaces disponibles        | `ifconfig -a`                                                            | Liste toutes les interfaces disponibles, même celles qui sont désactivées                  |
| Créer une connexion réseau manuelle        | `nmcli con add type ethernet ifname enp0s8 con-name MyConnection`        | Crée une nouvelle connexion réseau                                                         |
| Activer une connexion spécifique           | `nmcli con up MyConnection`                                              | Active une connexion réseau définie par NetworkManager                                     |
| Supprimer une connexion spécifique         | `nmcli con delete MyConnection`                                          | Supprime une connexion réseau définie                                                      |

---

### **Comment utiliser ce tableau ?**
1. Commencez par vérifier la détection de votre interface réseau (`ip a`).  
2. Activez-la si nécessaire (`sudo ip link set enp0s8 up`).  
3. Vérifiez si IPv4 est activé (`cat /proc/sys/net/ipv4/conf/enp0s8/disable_ipv4`).  
4. Si besoin, relancez la configuration DHCP (`sudo dhclient enp0s8`) ou attribuez une IP manuellement.  
5. Testez la connectivité avec `ping`.  
6. Si le problème persiste, utilisez `nmcli` ou `netplan` pour diagnostiquer davantage.  

