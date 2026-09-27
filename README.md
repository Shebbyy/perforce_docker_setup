# Perforce Server Docker Setup

This repository serves as an easy to start docker setup for perforce server. It is configured without SSL for local usage, but can be extended with SSL support by following the description in ```setup.sh```

The scripts are written in Bash for Linux servers but may be converted to Power-Shell if required. All the configuration, etc. happens inside the docker container, based on Ubuntu 24.04

## How to run
1. Replace `INSERT_PATH_OF_YOUR_CHOICE` in `docker-compose.yml` with the path for your perforce files or a virtual volume
2. Run `docker compose build` to build the container
3. Find out the perforce user id by running `docker run --rm perforce-perforce id p4`, then chown the volume directories to the printed user id; If you wish to use SSL also create a directory for that and add it in the volumes, beware though it needs to have Permission Set `700` for security reasons
2. Run `setup.sh`. It will create a p4 user `admin` for you and ask you for a Password. This will be your initial user
3. Docker container should then be set up and running and accessible via Port `1666`