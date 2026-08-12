FROM eclipse-temurin:25-jdk AS toolchain
COPY .mvn/ .mvn/
COPY mvnw mvnw

FROM toolchain AS configure
COPY pom.xml ./
RUN --mount=type=cache,target=/root/.m2 \
    ./mvnw org.apache.maven.plugins:maven-dependency-plugin:3.11.0:go-offline

FROM configure AS build
COPY src src/
RUN --mount=type=cache,target=/root/.m2 \
    ./mvnw package -Dquarkus.package.jar.type=uber-jar

FROM scratch AS output
COPY --from=build target/*.jar /java-demo.jar

FROM eclipse-temurin:21-jre AS runtime
COPY --from=build target/*.jar /java-demo.jar
EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "/java-demo.jar" ]
