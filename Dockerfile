FROM sonarqube

ENV SONARQUBE_JDBC_USERNAME admin

ENV SONARQUBE_JDBC_PASSWORD zaq12wsx

ENV SONARQUBE_JDBC_URL jdbc:postgresql://devops-sonarqubedb:5432/sonar

ENV SONARQUBE_HOME=/opt/sonarqube

COPY run.sh $SONARQUBE_HOME/bin/

ENTRYPOINT ["./bin/run.sh"]
