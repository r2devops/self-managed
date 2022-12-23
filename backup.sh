#!/bin/bash

# This script creates a backup of your data inside an archive.
# Launch it in the docker compose folder
# Usage: ./backup.sh

source .env

BACKUPS_DIR=backups
BACKUP_NAME=backup_r2-$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_PATH=$BACKUPS_DIR/$BACKUP_NAME

PROJECT_NAME=r2devops

ALPINE_VERSION=3.16
PG_VERSION=13

# Create the backup directory
mkdir -p $BACKUP_PATH
echo "📦 Start backuping data..."

# Backup the Jobs Database
echo "Saving the jobs database... (1/6)"
if docker run --rm --network=${PROJECT_NAME}_intranet -v $PWD/$BACKUP_PATH:/backup -e PGPASSWORD=$JOBS_DB_PASSWORD -it postgres:$PG_VERSION /bin/bash -c "pg_dump -U jobs -h postgres -Ft -f /jobs_db_backup.tar && mv jobs_db_backup.tar /backup"; then
    echo "✅ jobs database has been saved"
else
    echo "❌ Error while saving jobs database"
fi

# Backup the Kratos Database
echo "Saving the kratos database... (2/6)"
if docker run --rm --network=${PROJECT_NAME}_intranet -v $PWD/$BACKUP_PATH:/backup -e PGPASSWORD=$KRATOS_DB_PASSWORD -it postgres:$PG_VERSION /bin/bash -c "pg_dump -U kratos -h postgres_kratos -Ft -f /kratos_db_backup.tar && mv kratos_db_backup.tar /backup"; then
    echo "✅ kratos database has been saved"
else
    echo "❌ Error while saving kratos database"
fi

# Backup the Minio bucket
echo "Saving the Minio bucket... (3/6)"
if docker run --rm --network=${PROJECT_NAME}_intranet --volumes-from ${PROJECT_NAME}-minio-1 -v $PWD/$BACKUP_PATH:/backup -it alpine:$ALPINE_VERSION /bin/sh -c "cd /export/$S3_BUCKET && tar cf /backup/minio_backup.tar *"; then
    echo "✅ Minio bucket has been saved"
else
    echo "❌ Error while saving Minio bucket"
fi

# Backup the certificate file for Traefik
echo "Saving the certificate... (4/6)"
if docker run --rm --network=${PROJECT_NAME}_intranet --volumes-from ${PROJECT_NAME}-traefik-1 -v $PWD/$BACKUP_PATH:/backup -it alpine:$ALPINE_VERSION /bin/sh -c "cp /acme/acme.json /backup"; then
    echo "✅ The certificate has been saved"
else
    echo "❌ Error while saving the certificate"
fi

# Backup the `.env` file:
echo "Saving the .env file... (6/6)"
if cp .env $BACKUP_PATH; then
    echo "✅ the .env file has been saved"
else
    echo "❌ Error while saving the .env file"
fi

#Generate an archive of all file with the date of the day
cd $BACKUPS_DIR
tar cf $BACKUP_NAME.tar $BACKUP_NAME
cd ..
rm -rf $BACKUP_PATH
echo "✨ Backup completed, archive: $BACKUP_PATH.tar"
