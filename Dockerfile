FROM maven:3.8.5-openjdk-8 AS build

WORKDIR /app

COPY . .

RUN mvn clean package

FROM tomcat:9.0

COPY --from=build /app/target/GraniteBillingSystem.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8082

CMD ["catalina.sh", "run"]