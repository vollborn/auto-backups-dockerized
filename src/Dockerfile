FROM ubuntu:20.04

LABEL maintainer="vollborn <oliver.vollborn@gmail.com>"
LABEL version="1.0"
LABEL description="a simple container to backup files in a specific interval."

ENV SLEEP_DELAY="30m"
ENV ZIP_BACKUPS="true"
ENV MAX_BACKUP_COUNT="20"

WORKDIR /app

RUN apt-get update && apt-get install zip -y

COPY backup.sh /app/backup.sh
COPY rollback.sh /app/rollback.sh

RUN chmod +x /app/backup.sh && chmod +x /app/rollback.sh

ENTRYPOINT bash backup.sh $SLEEP_DELAY $ZIP_BACKUPS $MAX_BACKUP_COUNT

