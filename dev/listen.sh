#!/bin/bash

source ../.env
cd ../data/database

echo "started listening to changes"
chokidar ./full-schema.sql 2>&1 | while read event
do
  trigger=$(echo $event | cut -d ":" -f 1)
  if [[ $trigger != "change" ]]; then
    continue
  fi
  echo "CHANGE DETECTED: updating the db..."

  output=$(PGPASSWORD=$PGPASSWORD psql -d "postgres" -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'hackathon'");

  output=$(PGPASSWORD=$PGPASSWORD psql -d "postgres" -c "DROP DATABASE IF EXISTS hackathon;" 2>&1)
  if [[ $? -ne 0 ]]; then
    echo "output: $output"
    continue
  fi

  output=$(PGPASSWORD=$PGPASSWORD psql -d "postgres" -c "CREATE DATABASE hackathon;" 2>&1)
  if [[ $? -ne 0 ]]; then
    echo "output: $output"
    continue
  fi

  output=$(PGPASSWORD=$PGPASSWORD psql -f ./full-schema.sql)
  if [[ $? -ne 0 ]]; then
    echo "output: $output"
    continue
  fi

  echo "CHECK: changes applied, continuing to listen to changes..."
done
