# Projet Ansible — Déploiement automatisé de serveurs Debian 13

Ce dépôt permet de déployer automatiquement :
- un serveur OpenLDAP,
- un serveur MariaDB,
- un serveur web Nginx.

## Environnements
- Debian 13 (contrôleur Ansible)
- Debian 13 (serveurs cibles)

## Prérequis
- SSH fonctionnel vers les serveurs
- Utilisateur avec sudo ou accès root
- Python3 installé sur les cibles
- Collections Ansible installées

## Installation des collections
ansible-galaxy collection install -r requirements.yml -p collections

## Déploiement complet
ansible-playbook playbooks/site.yml --diff

## Vérification
- LDAP : ldapsearch -x -H ldap://ldap01 -b dc=example,dc=lan
- MariaDB : mysql -u appuser -p -h db01 appdb -e "SELECT 1;"
- Web : curl http://web01/healthz
