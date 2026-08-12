FROM eclipse-temurin:21-jdk AS build
COPY . .
RUN ./mvnw package -Dquarkus.package.jar.type=uber-jar

FROM eclipse-temurin:21-jre AS runtime
COPY --from=build target/*-runner.jar /opt/app.jar
ENTRYPOINT [ "java", "-jar", "/opt/app.jar" ]
