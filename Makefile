.PHONY: install syntax check deploy backup-db

install:
	ansible-galaxy collection install -r requirements.yml -p collections

syntax:
	ansible-playbook playbooks/site.yml --syntax-check

check:
	ansible-playbook playbooks/site.yml --check --diff

deploy:
	ansible-playbook playbooks/site.yml --diff

backup-db:
	ansible-playbook playbooks/backup-db.yml --diff
