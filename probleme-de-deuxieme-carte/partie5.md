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

