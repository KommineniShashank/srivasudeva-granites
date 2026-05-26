FROM tomcat:9.0

COPY target/GraniteBillingSystem.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8082

CMD ["catalina.sh", "run"]