#!/bin/bash

check_dependencies() {
    if ! which psql &> /dev/null; then
        echo "psql is not installed or is not in PATH"
        return 1
    fi
    if ! which docker &> /dev/null; then
        echo "docker is not installed or is not in PATH"
        return 1
    fi

    psql_result=$(PGPASSWORD=$PGPASSWORD psql -c "SELECT 1;" 2>&1)
    if [[ $? -ne 0 ]]; then
        echo "trying to start the db now: $psql_result"
        docker_result=$(docker run -d --name hackathon -e POSTGRES_PASSWORD=$PGPASSWORD -e POSTGRES_USER=$PGUSER -e POSTGRES_DB=$PGDATABASE -p $PGPORT:5432 postgres:15-alpine)
        if [[ $? -ne 0 ]]; then
            echo "Error could not start: $docker_result"
            return 1
        else
            psql_result=$(PGPASSWORD=$PGPASSWORD psql -c "SELECT 1;" 2>&1)
            if [[ $? -ne 0 ]]; then
                echo "Error: the db is not running or is inaccessible: $psql_result"
                return 1
            fi
            echo "CHECK: checked db and it is fine: $psql_result"
        fi
    fi
    echo "CHECK: db connection is fine: $psql_result"

    echo "CHECK: dependencies are fine"
    return 0
}

update_db() {
    # assumes to be in the database directory
    psql -c "SELECT pg_terminate_backend(pid) from pg_stat_activity WHERE datname='hackathon';" && echo "disconnected" &&
    psql --dbname postgres -c "DROP DATABASE IF EXISTS hackathon;" && echo "droped" &&
    psql --dbname postgres -c "CREATE DATABASE hackathon;" && echo "created" &&
    psql --dbname database -f ./full-schema.sql
}

start_monitor() {
    # assumes to be in the database directory
    echo "CHECK: listening for update to schema"
    local delay=1
    local last_event_time=0
    fswatch ./full-schema.sql | while read event
    do
        local current_time=$(date +%s)
        local duration_between_changes=$(( $current_time - $last_event_time ))
        if (( $duration_between_changes < $delay )); then
            continue
        fi
        last_event_time=$current_time

        echo "setting database schema"
        update_db 2>&1
        if [ $? -eq 0 ]
        then
            echo "database was successfully updated"
            echo "waiting for further changes..."
        else
            echo "error in updating the database"
            echo "waiting for further changes..."
        fi
    done
}


source ../.env
check_dependencies #todo: check the return value