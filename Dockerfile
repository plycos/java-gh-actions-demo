# Multi-stage Dockerfile for building and running a Java application.
# Uses BuildKit features for caching and artifact extraction.

# ── Toolchain Stage ──────────────────────────────────────────────────────────
# Provides the JDK and Maven wrapper for building.
# Pinned to a specific JDK version for reproducible builds.
FROM eclipse-temurin:21-jdk AS toolchain
COPY .mvn/ .mvn/
COPY mvnw mvnw

# ── Configure Stage ──────────────────────────────────────────────────────────
# Resolves all Maven dependencies upfront and caches them.
# Separating this from the build stage means dependency resolution is skipped
# on subsequent builds unless pom.xml changes (Docker layer caching).
FROM toolchain AS configure
COPY pom.xml ./
RUN --mount=type=cache,target=/root/.m2,id=m2-cache \
    ./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.11.0:go-offline

# ── Build Stage ──────────────────────────────────────────────────────────────
# Compiles and packages the application into a Quarkus uber-jar.
# Reuses the Maven cache from the configure stage to avoid re-downloading deps.
FROM configure AS build
COPY src src/
RUN --mount=type=cache,target=/root/.m2,id=m2-cache \
    ./mvnw package -Dquarkus.package.jar.type=uber-jar

# ── Output Stage ─────────────────────────────────────────────────────────────
# Extracts just the built JAR using `FROM scratch`.
# This stage is used with `docker buildx --output` to export the JAR
# to a local directory, bypassing the need to copy it out of a container.
FROM scratch AS output
COPY --from=build target/*.jar /java-demo.jar

# ── Runtime Stage ────────────────────────────────────────────────────────────
# Minimal JRE image for running the application.
# Only contains the uber-jar and the JRE; no build tools or source code.
FROM eclipse-temurin:21-jre AS runtime
COPY --from=build target/*.jar /java-demo.jar
EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "/java-demo.jar" ]
