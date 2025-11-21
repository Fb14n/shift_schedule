#!/bin/bash
$env:PGPASSWORD="mypassword"; psql -U myuser -d mydatabase -f ./assets/db/seed.sql
