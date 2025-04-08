# **Chapitre 1 : Introduction au DNS et à BIND9**

1. **Qu’est-ce que le DNS ?**  
   a) Un protocole de sécurité  
   b) Un protocole de messagerie  
   c) Un système de traduction de noms en adresses IP  
   d) Un service de partage de fichiers  

2. **Quelle est la différence entre une résolution directe et une résolution inverse ?**  
   (Réponse courte)

3. Le fichier de zone inverse utilise des enregistrements de type :  
   a) A  
   b) PTR  
   c) MX  
   d) CNAME

4. Vrai ou Faux : Le DNS fonctionne uniquement avec les adresses IPv4.

5. Quel est le rôle principal de BIND9 dans une infrastructure réseau ?  
   (Réponse courte)



# **Chapitre 2 : Installation de BIND9**

6. Quelle commande installe BIND9 sur Ubuntu/Debian ?  
   (Complétez)  
   ```bash
   sudo apt install __________
   ```

7. Quelle commande permet de vérifier que le service bind9 est actif ?  
   a) `bind9 status`  
   b) `systemctl status bind9`  
   c) `named-status`  
   d) `dns-status`

8. Dans quel répertoire se trouvent les fichiers de configuration de BIND9 ?  
   a) `/etc/dns/`  
   b) `/var/named/`  
   c) `/etc/bind/`  
   d) `/usr/local/bind/`

9. Quel utilitaire installe les outils comme `dig` et `host` ?  
   a) `bind9-utils`  
   b) `dnsutils`  
   c) `bind9-doc`  
   d) `named-tools`

10. Vrai ou Faux : Le redémarrage du service BIND9 est nécessaire après toute modification de fichier de zone.



# **Chapitre 3 : Structure de configuration**

11. Quel fichier contient les inclusions des autres fichiers de configuration ?  
   a) `named.conf.local`  
   b) `named.conf.options`  
   c) `named.conf`  
   d) `named.root`

12. Que contient généralement le fichier `named.conf.local` ?  
   a) Les options globales  
   b) Les fichiers de log  
   c) Les zones locales personnalisées  
   d) Les zones par défaut

13. À quoi sert `named.conf.options` ?  
   (Réponse courte)

14. Complétez la directive d’inclusion suivante :  
   ```bash
   include "__________";
   ```

15. Vrai ou Faux : `named.conf.default-zones` doit être supprimé avant configuration d’un DNS local.



# **Chapitre 4 : Zone directe**

16. Dans une zone directe, quel type d’enregistrement est utilisé pour lier un nom à une adresse IP ?  
   a) PTR  
   b) MX  
   c) A  
   d) NS

17. Complétez l’entrée suivante dans un fichier de zone :  
   ```bash
   www     IN   A   ______________
   ```

18. Quel champ dans l’enregistrement SOA doit être incrémenté après chaque modification ?  
   a) Retry  
   b) Serial  
   c) Expire  
   d) TTL

19. Quelle commande permet de vérifier la syntaxe d’un fichier de zone ?  
   a) `bind-check`  
   b) `named-checkconf`  
   c) `named-checkzone`  
   d) `zone-check`

20. Vrai ou Faux : Le fichier de zone directe se termine obligatoirement par `.com`.



# **Chapitre 5 : Zone inverse (PTR)**

21. Que signifie `in-addr.arpa` dans une zone inverse ?  
   a) C’est un nom de domaine  
   b) C’est une commande système  
   c) C’est une notation inversée d’adresse IP  
   d) C’est une option du DNSSEC

22. Donnez un exemple d’entrée PTR pour l’adresse 192.168.1.50.  
   (Réponse courte)

23. Complétez :  
   ```bash
   zone "1.168.192.in-addr.arpa" {
       type ______;
       file "____";
   };
   ```

24. Quelle commande permet de tester une résolution inverse ?  
   a) `host`  
   b) `dig -x`  
   c) `nslookup`  
   d) Toutes les réponses ci-dessus

25. Vrai ou Faux : Un enregistrement PTR pointe vers une adresse IP.



# **Chapitre 6 : Vérification et tests**

26. Quelle commande permet de vérifier la validité globale de la configuration BIND ?  
   a) `named-checkconf`  
   b) `bind-verify`  
   c) `named-checkzone`  
   d) `dnsconfig-check`

27. Complétez :  
   ```bash
   dig @127.0.0.1 __________
   ```

28. Quelle commande affiche les messages du service BIND9 ?  
   a) `journalctl -u bind9`  
   b) `logctl bind`  
   c) `bind9-logs`  
   d) `systemctl logs bind9`



# **Chapitre 7 : Sécurisation et bonnes pratiques**

29. Pourquoi est-il recommandé de restreindre les transferts de zone ?  
   a) Pour augmenter la vitesse de résolution  
   b) Pour économiser la bande passante  
   c) Pour éviter la divulgation de données DNS  
   d) Pour réduire les redémarrages de BIND

30. Quel paramètre dans le fichier de zone définit les IP autorisées à faire des requêtes DNS ?  
   a) `recursion`  
   b) `forwarders`  
   c) `allow-query`  
   d) `dnssec-validation`
