#!/bin/bash

# This script creates a backup of your data inside an archive.
# Launch it in the docker compose folder
# Usage: ./backup.sh [pg-version]

# TODO: add S3 upload

# Usage function
usage() {
    echo "Usage: $0 [pg-version]"
    echo "Backup R2Devops. You must run this CLI from the root of your R2Devops local git repository"
    echo
    echo "Options:"
    echo "  pg-version  Version of PostgreSQL you are using (default is 15)"
    echo "  -h, --help    Display this help message"
}


# Source R2Devops configuration
source .env

# Define some consts
BACKUPS_DIR=backups
BACKUP_NAME=backup_r2-$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_PATH=$BACKUPS_DIR/$BACKUP_NAME
PROJECT_NAME=r2devops

# Check if --help or -h is provided as the first argument
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    usage
    exit 0
fi

# Get pg version from args
PG_VERSION=${1:-15}

# Create the backup directory
mkdir -p $BACKUP_PATH
echo "📦 Start backuping data..."

# Backup the database
echo "Saving the database... (1/3)"
if docker run --rm --network=${PROJECT_NAME}_intranet -v $PWD/$BACKUP_PATH:/backup -e PGPASSWORD=$JOBS_DB_PASSWORD -it postgres:$PG_VERSION /bin/bash -c "pg_dump -U $JOBS_DB_USER -h $JOBS_DB_HOST -Ft -f /db_backup.tar && mv db_backup.tar /backup"; then
    echo "✅ Database has been saved"
else
    echo "❌ Error while saving database"
fi

# Backup the `.env` file:
echo "Saving the .env file... (2/3)"
if cp .env $BACKUP_PATH; then
    echo "✅ The .env file has been saved"
else
    echo "❌ Error while saving the .env file"
fi

# Backup the `config.json` file:
echo "Saving the config.json file... (3/3)"
if cp .docker/r2devops/config.json $BACKUP_PATH; then
    echo "✅ The config.json file has been saved"
else
    echo "❌ Error while saving the config.json file"
fi

# Generate an archive of all file with the date of the day
cd $BACKUPS_DIR
tar cf $BACKUP_NAME.tar $BACKUP_NAME
cd ..
rm -rf $BACKUP_PATH
echo "✨ Backup completed, archive: $BACKUP_PATH.tar"
