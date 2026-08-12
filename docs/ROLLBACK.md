# Procédure de rollback

Le rollback se fait à deux niveaux :

1. Rollback de configuration avec Git
2. Rollback des données avec sauvegardes

## Rollback de configuration

Avant chaque déploiement important, créer un tag Git :

    git tag -a v1.0.0 -m "Version stable"
    git push origin v1.0.0

En cas de problème, revenir à une version précédente :

    git checkout v1.0.0
    ansible-galaxy collection install -r requirements.yml -p collections
    ansible-playbook playbooks/site.yml --diff

Ou annuler le dernier commit :

    git revert HEAD
    ansible-playbook playbooks/site.yml --diff

## Rollback MariaDB

Lister les sauvegardes :

    ls -lh /var/backups/mysql

Restaurer :

    ./scripts/restore-mysql.sh /var/backups/mysql/all-databases-XXXX.sql.gz

## Rollback OpenLDAP

Avant modification majeure, sauvegarder :

    sudo mkdir -p /var/backups/ldap
    sudo slapcat -n 0 -l /var/backups/ldap/config.ldif
    sudo slapcat -n 1 -l /var/backups/ldap/data.ldif

En production, il est fortement recommandé de :
- versionner les LDIF,
- tester la restauration sur serveur isolé,
- mettre en place LDAPS/TLS.
