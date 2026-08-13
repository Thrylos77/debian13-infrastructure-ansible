# 🚀 Ansible - Déploiement Automatisé Debian 13

> Infrastructure as Code pour le déploiement automatisé d'une stack complète sur Debian 13 : Nginx, OpenLDAP, MariaDB, phpLDAPadmin, avec sécurité renforcée.

## 📋 Description

Ce projet fournit une solution complète d'**Infrastructure as Code (IaC)** basée sur Ansible pour industrialiser le déploiement de serveurs Debian 13. Il permet de provisionner automatiquement une stack web avec annuaire LDAP et base de données, tout en appliquant les bonnes pratiques de sécurité (firewall nftables, durcissement SSH, fail2ban).

### 🎯 Cas d'usage

* **Formation** : Apprentissage d'Ansible, IaC et administration système
* **Lab personnel** : Environnement de test reproductible pour développement
* **Prototype** : Base pour déploiements d'applications web
* **Démonstration** : Présentation de pratiques DevOps professionnelles

---

## 🏗️ Architecture

### Services déployés

| Service | Rôle | Port(s) | Description |
| --- | --- | --- | --- |
| **Nginx** | `nginx_server` | 80 | Serveur web avec page d'accueil moderne et endpoint de santé |
| **OpenLDAP** | `openldap_server` | 389, 636 | Annuaire LDAP pour l'authentification centralisée |
| **phpLDAPadmin** | `phpldapadmin` | 8090 | Interface web d'administration LDAP |
| **MariaDB** | `mariadb_server` | 3306 | Base de données relationnelle |
| **nftables** | `nftables` | - | Firewall stateful configurable |
| **fail2ban** | `security` | - | Protection contre les attaques par force brute |
| **OpenSSH** | `security` | 22 | Accès SSH durci |

### Stack technique

* **OS cible** : Debian 13 (Trixie)
* **Gestionnaire de configuration** : Ansible
* **Langage** : YAML, Jinja2, PHP
* **Versioning** : Git
* **Secrets** : Ansible Vault

---

## 📦 Prérequis

### Contrôleur Ansible

* Debian 13 (ou tout Linux avec Python 3.8+)
* Ansible 2.10+ installé
* Accès SSH vers les serveurs cibles
* Git pour le versioning

```bash
sudo apt update
sudo apt install -y ansible git python3-pip

```

### Serveurs cibles

* Debian 13 fraîchement installée
* Accès SSH avec utilisateur disposant de sudo
* Python 3 installé (généralement présent par défaut)
* Connexion réseau fonctionnelle

---

## 🚀 Installation rapide

### 1. Cloner le dépôt

```bash
git clone <url-du-depot>
cd ansible-deploiement

```

### 2. Installer les collections Ansible

```bash
ansible-galaxy collection install -r requirements.yml -p collections

```

### 3. Configurer l'inventaire

Éditer `inventories/dev/hosts.yml` avec les IPs de vos serveurs :

```yaml
---
all:
  children:
    linux:
      children:
        ldap_servers:
          hosts:
            node01:
              ansible_host: 192.168.1.100
        db_servers:
          hosts:
            node01:
        web_servers:
          hosts:
            node01:

```

> **Note** : Pour un environnement de test sur une seule machine, utilisez un seul hôte (`node01`) présent dans tous les groupes.

### 4. Configurer les secrets

Créer et chiffrer le fichier Vault :

```bash
cd inventories/dev/group_vars/all
cp vault.yml.example vault.yml
ansible-vault encrypt vault.yml
ansible-vault edit vault.yml

```

Définir les mots de passe :

```yaml
---
vault_openldap_admin_password: MotDePasseLDAPFort
vault_mariadb_app_password: MotDePasseMariaDBFort

```

### 5. Vérifier la connectivité

```bash
ansible all -m ping

```

### 6. Tester à blanc (dry-run)

```bash
ansible-playbook playbooks/site.yml --check --diff --ask-become-pass

```

### 7. Déployer

```bash
ansible-playbook playbooks/site.yml --diff --ask-become-pass

```

---

## 🔧 Utilisation

### Commandes principales

```bash
# Déploiement complet
ansible-playbook playbooks/site.yml --ask-become-pass

# Déploiement par service
ansible-playbook playbooks/ldap.yml --ask-become-pass
ansible-playbook playbooks/database.yml --ask-become-pass
ansible-playbook playbooks/web.yml --ask-become-pass
ansible-playbook playbooks/phpldapadmin.yml --ask-become-pass

# Sauvegarde de la base de données
ansible-playbook playbooks/backup-db.yml --ask-become-pass

# Vérification de syntaxe
ansible-playbook playbooks/site.yml --syntax-check

# Mode vérification (dry-run)
ansible-playbook playbooks/site.yml --check --diff

```

### Utilisation avec Makefile

```bash
make install       # Installer les collections
make syntax        # Vérifier la syntaxe
make check         # Test à blanc
make deploy        # Déploiement complet
make backup-db     # Sauvegarde MariaDB

```

---

## ✅ Vérification post-déploiement

### 1. Page d'accueil Nginx

Ouvrir dans le navigateur :

```text
http://IP_DU_SERVEUR

```

La page affiche :

* Statut des services
* Informations de connexion LDAP
* Liens vers phpLDAPadmin
* Endpoint de santé `/healthz`

### 2. phpLDAPadmin

Ouvrir dans le navigateur :

```text
http://IP_DU_SERVEUR:8090

```

Connexion avec :

* **Login DN** : `cn=admin,dc=example,dc=lan`
* **Password** : mot de passe défini dans Vault

### 3. Services système

Vérifier l'état des services :

```bash
sudo systemctl status nginx
sudo systemctl status slapd
sudo systemctl status mariadb
sudo systemctl status nftables
sudo systemctl status fail2ban

```

### 4. Firewall

Lister les règles actives :

```bash
sudo nft list table inet ansible_filter

```

### 5. Base de données

Tester la connexion MariaDB :

```bash
mysql -u appuser -p appdb -e "SELECT 1;"

```

### 6. Annuaire LDAP

Interroger LDAP en ligne de commande :

```bash
ldapsearch -x -H ldap://localhost -b dc=example,dc=lan

```

---

## 📁 Structure du projet

```text
ansible-deploiement/
├── ansible.cfg                    # Configuration Ansible
├── requirements.yml               # Collections Ansible requises
├── Makefile                       # Commandes automatisées
├── .gitignore                     # Fichiers ignorés par Git
├── .vault_pass                    # Mot de passe Vault (NON versionné)
├── README.md                      # Documentation principale
│
├── docs/
│   ├── DEPLOIEMENT.md             # Guide de déploiement détaillé
│   └── ROLLBACK.md                # Procédures de rollback
│
├── inventories/
│   └── dev/
│       ├── hosts.yml              # Inventaire des serveurs
│       ├── host_vars/             # Variables spécifiques aux hôtes
│       └── group_vars/
│           └── all/
│               ├── vars.yml       # Variables globales
│               ├── vault.yml      # Secrets chiffrés
│               └── vault.yml.example
│
├── playbooks/
│   ├── site.yml                   # Playbook principal
│   ├── common.yml                 # Socle commun
│   ├── ldap.yml                   # Déploiement OpenLDAP
│   ├── database.yml               # Déploiement MariaDB
│   ├── web.yml                    # Déploiement Nginx
│   ├── phpldapadmin.yml           # Déploiement phpLDAPadmin
│   └── backup-db.yml              # Sauvegarde MariaDB
│
├── roles/
│   ├── common/                    # Socle commun (paquets, timezone)
│   ├── nftables/                  # Firewall nftables
│   ├── security/                  # SSH durci + fail2ban
│   ├── openldap_server/           # Serveur OpenLDAP
│   ├── mariadb_server/            # Serveur MariaDB
│   ├── nginx_server/              # Serveur Nginx
│   └── phpldapadmin/              # Interface phpLDAPadmin
│
└── scripts/
    └── restore-mysql.sh           # Script de restauration MariaDB

```

---

## 🔐 Sécurité

### Bonnes pratiques appliquées

* ✅ **Secrets chiffrés** avec Ansible Vault
* ✅ **Firewall stateful** avec nftables
* ✅ **SSH durci** (PermitRootLogin désactivé, MaxAuthTries limité)
* ✅ **fail2ban** pour protection contre les attaques par force brute
* ✅ **Utilisateurs anonymes MariaDB** supprimés
* ✅ **Base de test MariaDB** supprimée
* ✅ **Permissions restrictives** sur les fichiers sensibles

### Recommandations pour la production

1. **SSH par clé** : Désactiver l'authentification par mot de passe après déploiement initial
2. **sudo NOPASSWD** : Configurer sudo sans mot de passe pour l'utilisateur Ansible
3. **HTTPS** : Configurer TLS pour Nginx et phpLDAPadmin
4. **LDAPS** : Activer TLS pour OpenLDAP (port 636)
5. **MariaDB** : Restreindre l'accès au port 3306 uniquement depuis le serveur web
6. **Monitoring** : Ajouter Prometheus/Grafana pour l'observabilité
7. **Logs centralisés** : Configurer rsyslog vers un serveur central
8. **Sauvegardes** : Automatiser les sauvegardes avec rétention

---

## 🔄 Workflow de déploiement

```text
┌─────────────────┐
│    Git Clone    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Install         │
│ Collections     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Configure       │
│ Inventory       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Setup Vault     │
│ (Secrets)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Dry Run         │
│ (--check)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Deploy          │
│ (site.yml)      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Verify          │
│ Services        │
└─────────────────┘

```

---

## 🐛 Dépannage

### Erreur "Access denied" MariaDB

Vérifier que l'utilisateur Ansible peut exécuter sudo :

```bash
ansible node01 -b -m shell -a 'id' --ask-become-pass

```

Doit afficher `uid=0(root)`.

### Port déjà utilisé

Vérifier les ports en écoute :

```bash
sudo ss -tlnp

```

### Firewall bloque l'accès

Lister les règles :

```bash
sudo nft list table inet ansible_filter

```

### phpLDAPadmin - Erreur de configuration

Vérifier la syntaxe PHP :

```bash
sudo php -l /etc/phpldapadmin/config.php

```

---

## 📚 Documentation complémentaire

* [Guide de déploiement détaillé](https://www.google.com/search?q=docs/DEPLOIEMENT.md)
* [Procédures de rollback](https://www.google.com/search?q=docs/ROLLBACK.md)
* [Documentation Ansible](https://docs.ansible.com/)
* [Collections utilisées](https://www.google.com/search?q=requirements.yml)

---

## 🤝 Contribution

Ce projet est fourni à des fins pédagogiques et de démonstration. Pour l'adapter à votre environnement :

1. Forker le dépôt
2. Modifier l'inventaire et les variables
3. Tester en environnement isolé
4. Documenter vos modifications

---

## 📄 Licence

Ce projet est destiné à un usage éducatif et professionnel. Les composants utilisés (Ansible, Nginx, OpenLDAP, MariaDB, phpLDAPadmin) sont sous leurs licences respectives.

---

## 👤 Auteur

Projet développé dans le cadre d'un projet académique d'Infrastructure as Code.

---

> **⚠️ Important** : Ce projet est fourni tel quel. Testez toujours en environnement de développement avant toute mise en production.
