#!/bin/sh
set -eu
STAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p backups
docker compose exec -T postgres pg_dump -U postgres -d crm_system -Fc > "backups/crm_${STAMP}.dump"
find backups -type f -name "crm_*.dump" -mtime +14 -delete
echo "Backup created: backups/crm_${STAMP}.dump"
