# Production Docker for Houzel

This project simplifies the deployment of Houzel in a production configuration with Docker.

## Installation using Docker Compose

You can use docker compose to deploy Houzel in a production configuration.

### Requirements

* docker (version 1.12+)
* docker-compose (version 1.10.0+)

### Configuration files

Customize the files config/houzel.yml and config/database.yml, and change the docker-compose.yml file so that the database uses the same password.

### Building/Starting

#### Run
```bash
docker-compose up -d
```

That's all.

## Update Houzel to latest version

First, shutdown your containers.
```bash
docker-compose down

```
Then run the following commands.
```bash
git pull
docker-compose build
docker-compose up -d
```

Your Docker image should now be on the latest version.

## More information

If you want to know how to use docker-compose, see [the overview
page](https://docs.docker.com/compose).
