#
# Build
#
FROM maven:3.6.3-jdk-11 AS build

WORKDIR /opt/shipping

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src /opt/shipping/src/
RUN mvn package -DskipTests

#
# Run
#
FROM openjdk:11-jre-slim

EXPOSE 8080

WORKDIR /opt/shipping

ENV CART_ENDPOINT=cart:8080
ENV DB_HOST=mysql

COPY --from=build /opt/shipping/target/shipping-1.0.jar shipping.jar

CMD ["java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar"]
