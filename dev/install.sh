#!/bin/bash

source ../.env
output=$(PGPASSWORD=$PGPASSWORD psql -c "SELECT 1;" 2>&1)

if [[ $? -ne 0 ]]; then
   output=$(docker run -d --name hackathon -p 5432:5432 -e POSTGRES_PASSWORD=$PGPASSWORD -e POSTGRES_USER=$PGUSER -e POSTGRES_DB=$PGDATABASE postgres:15-alpine)
   if [[ $? -ne 0 ]]; then
     echo "code: $?"
     echo "output: $output"
     echo "something went wrong with the docker container"
   fi

   ready_result=1
   while [ $ready_result -ne 0 ]
   do
     sleep 0.3 #300 milliseconds
     pg_isready -h $PGHOST -p $PGPORT &> /dev/null
     ready_result=$?
   done

   output=$(PGPASSWORD=$PGPASSWORD psql -c "SELECT 1;" 2>&1)
   echo "code: $?"
   echo "output: $output"
fi
