---
layout: post
title: "Debezium Study"
comments: true
date: "2021-03-13 14:01:11.251000+00:00"
---


https://debezium.io/documentation/reference/1.4/tutorial.html

```bash
# zookeeper
docker run -dit --name zookeeper \
        -p 2181:2181 \
        -p 2888:2888 \
        -p 3888:3888 \
        debezium/zookeeper:1.4

# kafka
docker run -dit --name kafka \
        -p 9092:9092 \
        --link zookeeper:zookeeper \
         debezium/kafka:1.4

# mysql db
docker run -dit --name mysql \
        -p 3306:3306 \
        -e MYSQL_ROOT_PASSWORD=debezium \
        -e MYSQL_USER=mysqluser \
        -e MYSQL_PASSWORD=mysqlpw \
        debezium/example-mysql:1.4


# kafka connect
docker run -dit --name connect \
        -p 8083:8083 \
        -e GROUP_ID=1 \
        -e CONFIG_STORAGE_TOPIC=my_connect_configs \
        -e OFFSET_STORAGE_TOPIC=my_connect_offsets \
        -e STATUS_STORAGE_TOPIC=my_connect_statuses \
        --link zookeeper:zookeeper \
        --link kafka:kafka \
        --link mysql:mysql \
        debezium/connect:1.4
```


```bash
# mysql command line
docker run -it --rm --name mysqlterm \
        --link mysql \
        --rm mysql:5.7 sh -c '\
        exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" 
        -P"$MYSQL_PORT_3306_TCP_PORT" 
        -uroot 
        -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
```
```
mysql> select * from customers;
+------+------------+-----------+-----------------------+
| id   | first_name | last_name | email                 |
+------+------------+-----------+-----------------------+
| 1001 | Sally      | Thomas    | sally.thomas@acme.com |
| 1002 | George     | Bailey    | gbailey@foobar.com    |
| 1003 | Edward     | Walker    | ed@walker.com         |
| 1004 | Anne Marie | Kretchmar | annek@noanswer.org    |
+------+------------+-----------+-----------------------+
4 rows in set (0.00 sec)

mysql> show tables;
+---------------------+
| Tables_in_inventory |
+---------------------+
| addresses           |
| customers           |
| geom                |
| orders              |
| products            |
| products_on_hand    |
+---------------------+
6 rows in set (0.04 sec)
```

Register a connector to monitor the inventory database
```bash
curl -i -X POST \
    -H "Accept:application/json" \
    -H "Content-Type:application/json" \
    localhost:8083/connectors/ -d '{ 
    "name": "inventory-connector", 
    "config": { 
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "tasks.max": "1", 
        "database.hostname": "mysql", 
        "database.port": "3306", 
        "database.user": "debezium", 
        "database.password": "dbz", 
        "database.server.id": "184054", 
        "database.server.name": "dbserver1", 
        "database.include.list": "inventory", 
        "database.history.kafka.bootstrap.servers": "kafka:9092", 
        "database.history.kafka.topic": "dbhistory.inventory" 
        } 
    }'
```

```bash
curl -H "Accept:application/json" localhost:8083/connectors/ 
["inventory-connector"]
```

viewing a create event
```bash
docker run -it --rm --name watcher \
        --link zookeeper:zookeeper \
        --link kafka:kafka \
        debezium/kafka:1.4 \
        watch-topic -a -k dbserver1.inventory.customers
```

#### Utils

##### show topics
`docker exec -it kafka /kafka/bin/kafka-topics.sh --zookeeper zookeeper:2181 --list`

##### show databases
`docker exec -it postgres bash -c 'psql -U postgres inventory -c "\l;"'`

##### show tables
`docker exec -it postgres bash -c 'psql -U postgres inventory -c "\dt;"'`

### Complement

ingest to postgres

https://debezium.io/blog/2017/09/25/streaming-to-another-database/

```bash
docker run -d --name postgres \
    -e POSTGRES_PASSWORD=password \
    -p 5432:5432 \
    postgres
```

```bash
# kafka connect 2
docker run -dit --name connect2 \
        -p 8084:8083 \
        -e GROUP_ID=2 \
        -e CONFIG_STORAGE_TOPIC=my_connect_configs2 \
        -e OFFSET_STORAGE_TOPIC=my_connect_offsets2 \
        -e STATUS_STORAGE_TOPIC=my_connect_statuses2 \
        --link zookeeper:zookeeper \
        --link kafka:kafka \
        --link mysql:mysql \
        --link postgres:postgres \
        debezium/connect-jdbc-postgres
```

```bash
# docker exec -it kafka /kafka/bin/kafka-topics.sh --zookeeper zookeeper:2181 --list

__consumer_offsets
dbhistory.inventory
dbserver1
dbserver1.inventory.addresses
dbserver1.inventory.customers
dbserver1.inventory.geom
dbserver1.inventory.orders
dbserver1.inventory.products
dbserver1.inventory.products_on_hand
my_connect_configs
my_connect_configs2
my_connect_offsets
my_connect_offsets2
my_connect_statuses
my_connect_statuses2
```

```bash
curl -i -X POST \
    -H "Accept:application/json" \
    -H  "Content-Type:application/json" \
http://localhost:8084/connectors/ -d '{
    "name": "jdbc-sink2",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "tasks.max": "1",
        "topics": "dbserver1.inventory.customers",
        "connection.url": "jdbc:postgresql://postgres:5432/inventory?user=postgres&password=password",
        "transforms": "unwrap",
        "transforms.unwrap.type": "io.debezium.transforms.UnwrapFromEnvelope",
        "auto.create": "true",
        "insert.mode": "upsert",
        "pk.fields": "id",
        "pk.mode": "record_value"
    }
}'
```

```
HTTP/1.1 201 Created
Date: Thu, 18 Mar 2021 19:21:14 GMT
Location: http://localhost:8084/connectors/jdbc-sink
Content-Type: application/json
Content-Length: 446
Server: Jetty(9.4.20.v20190813)


{
  "name": "jdbc-sink",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": "1",
    "topics": "dbserver1",
    "connection.url": "jdbc:postgresql://postgres:5432/inventory?user=postgres&password=password",
    "transforms": "unwrap",
    "transforms.unwrap.type": "io.debezium.transforms.UnwrapFromEnvelope",
    "auto.create": "true",
    "insert.mode": "upsert",
    "pk.fields": "id",
    "pk.mode": "record_value",
    "name": "jdbc-sink"
  },
  "tasks": [],
  "type": "sink"
}
```

```bash
# mysql db
docker run -dit --name server1 \
        -p 3307:3306 \
        -e MYSQL_ROOT_PASSWORD=debezium \
        -e MYSQL_USER=mysqluser \
        -e MYSQL_PASSWORD=mysqlpw \
        debezium/example-mysql:1.4


# kafka connect
docker run -dit --name connect3 \
        -p 8085:8083 \
        -e GROUP_ID=1 \
        -e CONFIG_STORAGE_TOPIC=my_connect_configs3 \
        -e OFFSET_STORAGE_TOPIC=my_connect_offsets3 \
        -e STATUS_STORAGE_TOPIC=my_connect_statuses3 \
        --link zookeeper:zookeeper \
        --link kafka:kafka \
        --link server1:server1 \
        debezium/connect:1.4

curl -i -X POST \
    -H "Accept:application/json" \
    -H  "Content-Type:application/json" \
http://localhost:8085/connectors/ -d '{
    "name": "inventory-connector",
    "config": {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "tasks.max": "1",
        "database.hostname": "server1",
        "database.port": "3306",
        "database.user": "mysqluser",
        "database.password": "mysqlpw",
        "database.server.id": "184054",
        "database.server.name": "dbserver1",
        "database.include": "inventory",
        "database.history.kafka.bootstrap.servers": "kafka:9092",
        "database.history.kafka.topic": "schema-changes.inventory",
        "transforms": "route",
        "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.route.regex": "([^.]+)\\.([^.]+)\\.([^.]+)",
        "transforms.route.replacement": "$3"
    }
}'
```


# Debezium UI

dummy db
https://www.postgresqltutorial.com/postgresql-sample-database/

```sql
docker rm -f pg
docker run -dit \
	--name pg \
	-e POSTGRES_PASSWORD=admin \
	-p 5432:5432 \
	-v /root/data:/data \
	postgres:10.16 postgres -c wal_level=logical
	
docker exec -it pg bash -c "psql -U postgres -c 'create database dvdrental'"
	

cmd="pg_restore -U postgres -d dvdrental /data/dvdrental.tar"
docker exec -it pg bash -c "$cmd"
```

![](/assets/img/AIkqFmIcL_21f3bc9f4d510e1c9ab86df26d5592fd.png)

![](/assets/img/AIkqFmIcL_1050f874ce0eb7354cc100a2734b7f84.png)

![](/assets/img/AIkqFmIcL_e2b3239546c1fbf881cd4bce54cf4c8d.png)

![](/assets/img/AIkqFmIcL_3b1bf043c1e547cab91bbce8b23159a5.png)








