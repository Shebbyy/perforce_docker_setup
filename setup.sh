#!/bin/bash
# First create directories for volumes in a parent dir
# Find out user-id of perforce user in container (docker run --rm perforce-perforce id p4)
# Then sudo chown -R ID:ID PATH_TO_VOLUME_DIR_PARENT to change all volume directories to be owned by P4
# If you use SSL change ports so ssl:1666 / include a dir to be mounted for SSL with permission 700; 
# For SSL also set P4SSLDIR Env-Var in docker-compose to /perforce/ssl (mnt it to there with volume)

set -euo pipefail

echo "Starting Perforce container..."

docker compose up -d

echo "Waiting for Perforce..."

for i in {1..60}; do
    if docker compose exec -T perforce \
        p4 -p localhost:1666 info >/dev/null 2>&1; then
        echo "Perforce is ready."
        break
    fi

    if [ "$i" -eq 60 ]; then
        echo "ERROR: Perforce did not become ready."
        docker compose logs perforce
        exit 1
    fi

    sleep 1
done

echo "Creating admin user..."

docker compose exec -it perforce \
    p4 -p localhost:1666 \
    -u admin \
    passwd

echo "Admin user created."

echo
echo "Perforce initialization complete."
echo
echo "Test with:"
echo "  docker compose exec perforce p4 -p localhost:1666 -u admin login"

