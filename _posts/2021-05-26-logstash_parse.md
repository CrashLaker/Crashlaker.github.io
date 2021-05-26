---
layout: post
title: "Logstash parse"
comments: true
date: "2021-05-26 03:39:08.402000+00:00"
---


## ElasticSearch Test

https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html

https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-docker.html

```shell
sysctl -w vm.max_map_count=262144
```

```yaml
version: '2.2'
services:
  es01:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.12.1
    container_name: es01
    environment:
      - node.name=es01
      - cluster.name=es-docker-cluster
      #- discovery.seed_hosts=es02,es03
      - cluster.initial_master_nodes=es01
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms8g -Xmx8g"
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
       soft: 65536
       hard: 65536
    volumes:
      - data01:/usr/share/elasticsearch/data
    ports:
      - 9200:9200
    networks:
      - elastic

  kib01:
    image: docker.elastic.co/kibana/kibana:7.12.1
    container_name: kib01
    ports:
      - 5601:5601
    environment:
      ELASTICSEARCH_URL: http://es01:9200
      ELASTICSEARCH_HOSTS: '["http://es01:9200"]'
    networks:
      - elastic

volumes:
  data01:
    driver: local

networks:
  elastic:
    driver: bridge
```

#### Filebeat

```
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.12.1-x86_64.rpm
sudo rpm -vi filebeat-7.12.1-x86_64.rpm
```
#### Logstash

install
```shell
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat <<EOF > /etc/yum.repos.d/logstash.repo
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
yum -y install logstash
echo "export PATH=\"/usr/share/logstash/bin/:$PATH\"" >> /root/.bashrc
export PATH="/usr/share/logstash/bin/:$PATH"
```

```
input {
    file {
        path => "/root/wkdir/summary2/*.summary"
        start_position => "beginning"
        codec => multiline {
            pattern => '.*128=.*'
            negate => false
            what => previous
        }
        sincedb_path => "/dev/null"
    }
}


# https://stackoverflow.com/questions/27443392/how-can-i-have-logstash-drop-all-events-that-do-not-match-a-group-of-regular-exp
filter {
    grok {
        add_tag => [ "valid" ]
        match => {
            "message" => [
                ".*? IN (?<time>[^.]+\.\d\d\d).*?49=(?<client>[A-Z0-9]+).*?128=(?<session>[A-Z0-9]+).*"
            ]
        }
    }
    # https://discuss.elastic.co/t/what-is-the-date-format-to-be-used-with-logstash-to-match-9-digits-millisecond/107032
    # https://discuss.elastic.co/t/how-to-replace-timestamp-with-logtime/118949/2
    # 20210521-23:47:00.333333333
    date {
        match => ["time", "yyyyMMdd-HH:mm:ss.SSS"]
        target => "@timestamp"
        remove_field => ["time"]
    }

    if "_grokparsefailure" in [tags] {
        drop {}
    }

    if "valid" not in [tags] {
        drop { }
    }

    if "128=" not in [message] {
        drop { }
    }

    mutate {
        remove_tag => [ "valid" ]
        remove_field => [ "message" ]
    }
}

output {
    elasticsearch {
        hosts => ["localhost:9200"]
        index => "fix"
    }
    #stdout {
    #    codec => json_lines
    #}
}
```
