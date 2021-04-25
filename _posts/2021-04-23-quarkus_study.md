---
layout: post
title: "Quarkus Study"
comments: true
date: "2021-04-23 05:49:49.516000+00:00"
---


Courses
* https://www.udemy.com/course/quarkus-starting-with-quarkus/
* https://www.udemy.com/course/quarkus-get-started/
* https://www.udemy.com/course/quarkus-backend-development-java/

# Starting with Quarkus
https://www.udemy.com/course/quarkus-starting-with-quarkus/

https://github.com/agoncal/agoncal-course-quarkus-starting

![](/assets/img/R8iR4L0g0_1b24ab9df6c8d4cd5cf6e06f9959d246.png)

![](/assets/img/R8iR4L0g0_6f04a36bf6c38c253d33fc8d7a33eb50.png)

```bash
# Install native-image
# After graalvm install
gu install native-image
```

![](/assets/img/R8iR4L0g0_245053aa956f40918c347adf8b097ed7.png)



![](/assets/img/R8iR4L0g0_e4c6e289c6f43432281f42be12cb4d93.png)


![](/assets/img/R8iR4L0g0_b97f76a9ed01751306d0bc05e07a36ff.png)

```bash
mvn package -DskipTests
java -jar target/quarkus-app/quarkus-run.jar
```

![](/assets/img/R8iR4L0g0_e32696c8ef420a2e95189f79c59a625b.png)

```bash
yum -y install gcc gcc-c++ zlib zlib-devel
export LD_LIBRARY_PATH="/usr/lib64:$LD_LIBRARY_PATH"
mvn package -Pnative
```

![](/assets/img/R8iR4L0g0_6e0b511901c2b76e104d6dcdf6042808.png)

## Build JAR Container

![](/assets/img/R8iR4L0g0_4e4cce5fe29f92752d98988fa99c253d.png)

![](/assets/img/R8iR4L0g0_788b03d2b0fe6671ba63efeae57129e7.png)

redhat certs
https://bugs.centos.org/view.php?id=14785
```
openssl s_client -showcerts -servername registry.access.redhat.com -connect registry.access.redhat.com:443 </dev/null 2>/dev/null | openssl x509 -text > /etc/rhsm/ca/redhat-uep.pem
```

```bash
[root@quarkus-lab rest-book]# mvn quarkus:add-extension -Dextensions="container-image-docker"
[root@quarkus-lab rest-book]# mvn package -Dquarkus.container-image.build=true -Dquarkus.package.type=jar -Dquarkus.contianer-image.tag=jvm

```



build native docker

```bash
mvn package -Dquarkus.container-image.build=true -Dquarkus.package.type=native  -Dquarkus.native.container-build=true -Dquarkus.container-image.tag=native

docker run -i --rm -p 8080:8080 root/rest-book:native
```

![](/assets/img/R8iR4L0g0_2b1431df0f6b636414f2b951883e056f.png)


![](/assets/img/R8iR4L0g0_eb81a841a53aa338d47615773b31605e.png)



# 2021 Quarkus Fundamentals - Guide to Get Started in 1 Hour

https://github.com/CrashLaker/udemy-quarkus-1hour

```bash
mvn io.quarkus:quarkus-maven-plugin:create \
    -DprojectGroupId=n1.brightboost \
    -DprojectArtifactId=quickstart \
    -DclassName="n1.brightboost.quickstart.HelloWorldResource" \
    -Dpath="/helloworld"
```

```bash
mvn quarkus:dev
mvn package
```

## build reactive

```bash
mvn io.quarkus:quarkus-maven-plugin:create \
    -DprojectGroupId=n1.brightboost \
    -DprojectArtifactId=quickstart-reactive \
    -DclassName="n1.brightboost.reactive.HelloReactiveResource" \
    -Dpath="/helloreactive" \
    -Dextensions="resteasy-reactive"
```

`HelloReactiveResource.java`
```java
package n1.brightboost.reactive;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import org.jboss.resteasy.reactive.RestSseElementType;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/helloreactive")
public class HelloReactiveResource {

    @Inject
    HelloReactiveService helloReactiveService;
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Path("/{name}")
    public Uni<String> hello(String name) {
        return helloReactiveService.hello(name);
    }


    @GET
    @Produces(MediaType.SERVER_SENT_EVENTS)
    @RestSseElementType(MediaType.TEXT_PLAIN)
    @Path("/{name}/{nr}")
    public Multi<String> multiHello(String name, int nr) {
        return helloReactiveService.multiHello(name, nr);
    }
}
```

`HelloReactiveService.java`

```java
package n1.brightboost.reactive;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;

import javax.enterprise.context.ApplicationScoped;
import java.time.Duration;

@ApplicationScoped
public class HelloReactiveService {
    public Uni<String> hello(String name) {
        return Uni.createFrom().item(name).onItem().transform(s -> "hello " + s);
    }

    public Multi<String> multiHello(String name, int nr) {
        return Multi.createFrom().ticks().every(Duration.ofSeconds(3)).onItem().transform(n -> "hello " + name + n).select().first(nr);
    }
}
```

## CRUD

https://code.quarkus.io/

![](/assets/img/R8iR4L0g0_cd82f9e60735b179f37f1a474e8dd7a3.png)



# Quarkus Backend development with Java and GraalVM


```
wget https://releases.conduktor.io/linux-rpm -O conduktor.rpm
yum -y install ./conduktor.rpm
/opt/conduktor/bin/Conduktor
```

![](/assets/img/R8iR4L0g0_77547363b7e8e13cc5fc1cf88ce30cb1.png)


```bash
mvn io.quarkus:quarkus-maven-plugin:1.3.0.Final:create \
  -DprojectGroupId=tech.donau \
  -DprojectArtifactId=kafka \
  -Dextensions="kafka"
```

```
version: '2'
services:
  zookeeper:
    image: strimzi/kafka:0.11.3-kafka-2.1.0
    command: [
      "sh", "-c",
      "bin/zookeeper-server-start.sh config/zookeeper.properties"
    ]
    ports:
      - "2181:2181"
    environment:
      LOG_DIR: /tmp/logs
  kafka:
    image: strimzi/kafka:0.11.3-kafka-2.1.0
    command: [
      "sh", "-c",
      "bin/kafka-server-start.sh config/server.properties --override listeners=$${KAFKA_LISTENERS} --
    override advertised.listeners=$${KAFKA_ADVERTISED_LISTENERS} --override
    zookeeper.connect=$${KAFKA_ZOOKEEPER_CONNECT}"
    ]
    depends_on:
      - zookeeper
    ports:
      - "9092:9092"
    environment:
      LOG_DIR: "/tmp/logs"
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
```

![](/assets/img/R8iR4L0g0_b4ac88f0af4fe8cf1a9a74ccc0faec5e.png)





