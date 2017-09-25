#! /bin/bash
set -e

DB="$1"

mc config host add mongodb "$MINIO_SERVER" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY" "$MINIO_API_VERSION" > /dev/null

ARCHIVE="${MINIO_BUCKET}/${DB}-$(date $DATE_FORMAT).archive"

echo "Dumping $DB to $ARCHIVE"
echo "> mongodump ${@:2} -d $DB"

mongodump "${@:2}" -d "$DB" --archive | mc pipe "mongodb/$ARCHIVE" || mc rm "mongodb/$ARCHIVE"

echo "Backup complete"