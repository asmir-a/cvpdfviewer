#!/bin/bash

DB_STRING_LOCAL="postgresql://postgres:qwerty@localhost:5432"

update_db() {
    psql "postgresql://postgres:qwerty@localhost:5432" -c "DROP DATABASE IF EXISTS database" \
    && psql "postgresql://postgres:qwerty@localhost:5432" -c "CREATE DATABASE database" \
    && psql "postgresql://postgres:qwerty@localhost:5432" -f ./full-schema.sql
}

cd ../data/database
fswatch ./full-schema.sql | while read event
do
    echo "full-schema has been modified"
    echo "setting database schema"

    output=$(update_db 2>&1)

    if [ $? -eq 0 ]
    then
        echo "database was successfully updated"
        echo "output: $output"
        echo "waiting for further changes..."
    else
        echo "error in updating the database"
        echo "error: $output"
        echo "waiting for further changes..."
    fi
done