# Java GitHub Actions Demo

A minimal Quarkus + Kotlin app used to demonstrate Docker multi-stage builds and GitHub Actions CI/CD workflows.

## What's demonstrated

- **Multi-stage Dockerfile** with BuildKit cache mounts for Maven dependencies
- **GitHub Actions workflows** for building Docker images and publishing to GitHub Packages

## Running locally

```shell
./mvnw quarkus:dev
```

## Building with Docker

```shell
docker build --target runtime -t java-demo:latest .
```

## Running a DB with Docker Compose

```shell
# start
docker compose up -d

# stop
docker compose down

# stop and clear data
docker compose down -v
```
