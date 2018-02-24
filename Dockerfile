FROM maven:3.5-jdk-8-alpine
LABEL Author="chenchuxin <idesireccx@gmail.com>"

ARG version=0.9.1
ARG package_name=apollo-${version}.tar.gz
ENV version=${version}

COPY src/${package_name} /src/
COPY src/settings.xml /usr/share/maven/conf/
COPY build.sh /scripts/
 
WORKDIR /src
RUN tar zxf ${package_name} --strip-components=1 \
    && rm ${package_name} \
    && /scripts/build.sh \
    && mkdir /app

WORKDIR /app
RUN cp apollo-configservice/target/apollo-configservice-${version}.jar /app/configservice.jar \
    && cp apollo-adminservice/target/apollo-adminservice-${version}.jar /app/adminservice.jar \
    && cp apollo-portal/target/apollo-portal-${version}.jar /app/portal.jar \
    && rm -rf /src

ENTRYPOINT [ "java", "-jar" ]
CMD [ "configservice.jar" ]