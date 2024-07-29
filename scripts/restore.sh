#!/bin/bash

# This script restores the data from an archive
# Launch it in the docker compose folder
# Usage: ./restore.sh <backup_file_path>

# TODO: add S3 download


# Usage function
usage() {
    echo "Usage: $0 <backup_file_path> [pg-version]"
    echo "Restore R2Devops. You must run this CLI from the root of your R2Devops local git repository"
    echo
    echo "Options:"
    echo "  backup_file_path  Path to the backup file to restore"
    echo "  pg-version        Version of PostgreSQL you are using (default is 15)"
    echo "  -h, --help        Display this help message"
}


# Define some consts
PROJECT_NAME=r2devops

# Check if --help or -h is provided as the first argument
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    usage
    exit 0
fi

# Ensure a backup file path is specified and present
BACKUP_FILE=$(realpath $1)
if [ -z $BACKUP_FILE ]; then
  printf "Error: backup file path is missing\n"
  usage
  exit 1
fi

# Get pg version from args
PG_VERSION=${2:-15}

if [ -f $BACKUP_FILE ]; then
    echo "🛳️ Start restoring data..."

    BACKUP_DIR=$(echo $BACKUP_FILE | cut -f 1 -d '.')
    tar xf $BACKUP_FILE -C $(dirname $BACKUP_FILE)

    echo "Restoring the .env file... (1/3)"
    if cp $BACKUP_DIR/.env ./.env; then
        echo "✅ The .env file has been restored"
        source .env
    else
        echo "❌ Error while restoring the .env file"
        exit 1
    fi

    echo "Restoring the config.json file... (2/3)"
    if cp $BACKUP_DIR/config.json ./config.json; then
        echo "✅ The config.json file has been restored"
    else
        echo "❌ Error while restoring the config.json file"
        exit 1
    fi

    echo "Restoring the database... (3/3)"
    if docker run --rm --network=${PROJECT_NAME}_intranet -v $BACKUP_DIR:/backup -e PGPASSWORD=$JOBS_DB_PASSWORD -it postgres:$PG_VERSION /bin/bash -c "pg_restore -U $JOBS_DB_USER -h $JOBS_DB_HOST -Ft -d $JOBS_DB_NAME -c /backup/db_backup.tar"; then
        echo "✅ Database has been restored"
    else
        echo "❌ Error while restoring database"
        exit 1
    fi

    rm -rf $BACKUP_DIR
    echo "✨ Restore completed!"
  else
      echo "❌ Backup file $BACKUP_FILE not found."
      exit 1
fi
