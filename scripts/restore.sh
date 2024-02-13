#!/bin/bash

# This script restores the data from an archive
# Launch it in the docker compose folder
# Usage: ./restore.sh <backup_file_path>

BACKUP_FILE=$1

PROJECT_NAME=r2devops

ALPINE_VERSION=3.16
PG_VERSION=13

if [ -z $BACKUP_FILE ]; then
  printf "Error: backup file path is missing\nUsage: ./restore.sh <backup_file_path>\n"
  exit 1
fi

BACKUP_FILE=$(realpath $BACKUP_FILE)

if [ -f $BACKUP_FILE ]; then
    echo "🛳️ Start restoring data..."

    BACKUP_DIR=$(echo $BACKUP_FILE | cut -f 1 -d '.')
    tar xf $BACKUP_FILE -C $(dirname $BACKUP_FILE)

    echo "Restoring the .env file... (1/5)"
    if cp $BACKUP_DIR/.env ./.env; then
        echo "✅ The .env file has been restored"
    	source .env
    else
        echo "❌ Error while restoring the .env file"
	exit 1
    fi

    echo "Restoring the config.json file... (2/5)"
    if cp $BACKUP_DIR/config.json ./config.json; then
        echo "✅ The config.json file has been restored"
    else
        echo "❌ Error while restoring the config.json file"
	exit 1
    fi

    echo "Stopping all services..."
    if docker compose stop; then
        echo "✅ All services have been stopped"
    else
        echo "❌ Error while stopping services"
	exit 1
    fi

    echo "Restoring the jobs database... (3/5)"
    if docker compose start postgres && sleep 2; then
        echo "Postgres service has been started"
    else
        echo "❌ Error while starting postgres service"
	exit 1
    fi
    if docker run --rm --network=${PROJECT_NAME}_intranet -v $BACKUP_DIR:/backup -e PGPASSWORD=$JOBS_DB_PASSWORD -it postgres:$PG_VERSION /bin/bash -c "pg_restore -U jobs -h postgres -Ft -d jobs -c /backup/jobs_db_backup.tar"; then
      	echo "✅ Jobs database has been restored"
    else
        echo "❌ Error while restoring jobs database"
	exit 1
    fi

    echo "Restoring the Minio bucket... (4/5)"
    if docker run --rm --network=${PROJECT_NAME}_intranet --volumes-from ${PROJECT_NAME}-minio-1 -v $BACKUP_DIR:/backup -it alpine:$ALPINE_VERSION /bin/sh -c "rm -rf /export/$S3_BUCKET/*; cd /export/$S3_BUCKET/; tar xf /backup/minio_backup.tar"; then
        echo "✅ Minio bucket has been restored"
    else
        echo "❌ Error while restoring Minio bucket"
    fi

    echo "Restoring the certificate... (5/5)"
    if docker run --rm --network=${PROJECT_NAME}_intranet --volumes-from ${PROJECT_NAME}-traefik-1 -v $BACKUP_DIR:/backup -it alpine:$ALPINE_VERSION /bin/sh -c "cp /backup/acme.json acme"; then
        echo "✅ The certificate has been restored"
    else
        echo "❌ Error while restoring the certificate"
	exit 1
    fi

    echo "Starting all services..."
    if docker compose up -d; then
        echo "✅ All services have been started"
    else
        echo "❌ Error while starting services"
	exit 1
    fi

    rm -rf $BACKUP_DIR
    echo "✨ Restore completed!"
  else
      echo "❌ Backup file $BACKUP_FILE not found."
      exit 1
fi
