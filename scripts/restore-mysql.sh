#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /var/backups/mysql/all-databases-YYYYMMDD.sql.gz"
  exit 1
fi

BACKUP_FILE="$1"

if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "Le fichier de sauvegarde $BACKUP_FILE n'existe pas."
  exit 1
fi

echo "Restauration de $BACKUP_FILE en cours..."
zcat "$BACKUP_FILE" | sudo mysql

echo "Restauration terminée."
