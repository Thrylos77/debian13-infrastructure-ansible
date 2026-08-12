# Procédure de déploiement

## 1. Préparation du contrôleur Ansible

Installer les prérequis :

    sudo apt update
    sudo apt install -y ansible git python3-pip

Récupérer le dépôt :

    git clone <url-du-depot>
    cd ansible-deploiement

Installer les collections :

    ansible-galaxy collection install -r requirements.yml -p collections

## 2. Configuration de l'inventaire

Modifier :

    inventories/dev/hosts.yml

Renseigner :
- les noms des serveurs,
- les adresses IP,
- l'utilisateur SSH.

## 3. Configuration des secrets

Créer le fichier Vault :

    cd inventories/dev/group_vars/all
    cp vault.yml.example vault.yml
    ansible-vault encrypt vault.yml
    ansible-vault edit vault.yml

Définir :
- vault_openldap_admin_password
- vault_mariadb_app_password

## 4. Test de connectivité

    ansible all -m ping

## 5. Déploiement à blanc

    ansible-playbook playbooks/site.yml --check --diff

## 6. Déploiement réel

    ansible-playbook playbooks/site.yml --diff

## 7. Déploiement par couche

LDAP :

    ansible-playbook playbooks/ldap.yml --diff

MariaDB :

    ansible-playbook playbooks/database.yml --diff

Nginx :

    ansible-playbook playbooks/web.yml --diff

## 8. Sauvegarde de base de données

    ansible-playbook playbooks/backup-db.yml --diff
