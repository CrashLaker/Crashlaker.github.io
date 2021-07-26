---
layout: post
title: "RDS Postgres 11.10 Try 1"
comments: true
date: "2021-07-26 06:15:01.865000+00:00"
---


Documenting attempt 1 on trying to CDC RDS PostgreSQL 11.10

## Aux
```bash
function cleanup(){
    start_zookeeper
    start_kafka
    start_kafka_connect
    start_postgres
    start_kafka_sink
}
function start_zookeeper(){
    # zookeeper
    docker rm -f zookeeper
    docker run -dit --name zookeeper \
            -p 2181:2181 \
            -p 2888:2888 \
            -p 3888:3888 \
            debezium/zookeeper:1.4
}

function start_kafka(){
    # kafka
    docker rm -f kafka
    docker run -dit --name kafka \
            -p 9092:9092 \
            -e ADVERTISED_HOST_NAME=localhost \
            --link zookeeper:zookeeper \
             debezium/kafka:1.4
}

function start_kafka_connect(){
    # kafka connect
    docker rm -f connect
    docker run -dit --name connect \
            -p 8083:8083 \
            -e GROUP_ID=1 \
            -e CONFIG_STORAGE_TOPIC=my_connect_configs \
            -e OFFSET_STORAGE_TOPIC=my_connect_offsets \
            -e STATUS_STORAGE_TOPIC=my_connect_statuses \
            --link zookeeper:zookeeper \
            --link kafka:kafka \
            debezium/connect:1.4
}

function start_postgres(){
    docker rm -f postgres
    [ -d /root/pgdata ] && rm -rf /root/pgdata
    mkdir /root/pgdata
    docker run -d --name postgres \
        -e POSTGRES_PASSWORD=admin \
        -e POSTGRES_DB=dvdrental \
        -v /root/pgdata:/var/lib/postgresql/data \
        -p 5432:5432 \
        postgres:11.10
}
    
function start_kafka_sink(){
    docker rm -f sink
    docker run -dit --name sink \
            -p 8084:8083 \
            -e GROUP_ID=2 \
            -e CONFIG_STORAGE_TOPIC=my_connect_configs2 \
            -e OFFSET_STORAGE_TOPIC=my_connect_offsets2 \
            -e STATUS_STORAGE_TOPIC=my_connect_statuses2 \
            --link zookeeper:zookeeper \
            --link kafka:kafka \
            --link postgres:postgres \
            debezium/connect-jdbc-postgres
}    
```

*Kafka list topics*
```bash
docker exec -it kafka bash -c "./bin/kafka-topics.sh --zookeeper zookeeper:2181 --list"
```

*Topic describe*
```bash
docker exec -it kafka bash -c "
    ./bin/kafka-topics.sh \
        --zookeeper zookeeper:2181 \
        --describe \
        --topic dbserver1.public.film"
```

*Consume topic*
```bash
docker exec -it kafka bash -c "
    ./bin/kafka-topics.sh \
        --zookeeper zookeeper:2181 \
        --topic dbserver1.public.film \
        --describe"
```

### Register a connector
````{tab} Kafka Connector
```bash
curl -i -X POST \
    -H "Accept:application/json" \
    -H "Content-Type:application/json" \
    localhost:8083/connectors/ -d '{ 
    "name": "inventory-connector", 
    "config": { 
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector", 
        "tasks.max": "1", 
        "database.hostname": "dbhostname", 
        "database.port": "5432", 
        "database.user": "postgres", 
        "database.password": "admin", 
        "database.dbname": "dvdrental", 
        "database.server.name": "dbserver1", 
        "database.include.list": "inventory", 
        "publication.name": "dbz_pupblication",
        "database.history.kafka.bootstrap.servers": "kafka:9092", 
        "database.history.kafka.topic": "pgrds.inventory",
        "plugin.name": "wal2json",
        "snapshot.mode": "initial",
        "slot.name": "dvdrental_pgrds",
        "database.history.kafka.topic": "schema-changes.inventory",
        "transforms": "route",
        "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.route.regex": "([^.]+)\\.([^.]+)\\.([^.]+)",
        "transforms.route.replacement": "$3" 
        } 
    }'
```
````
````{tab} Kafka Sink
```bash
curl -i -X POST \
    -H "Accept:application/json" \
    -H  "Content-Type:application/json" \
http://localhost:8084/connectors/ -d '{
    "name": "jdbc-sink",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "tasks.max": "1",
        "topics": "customer",
        "connection.url": "jdbc:postgresql://postgres:5432/dvdrental?user=postgres&password=admin",
        "transforms": "unwrap",
        "transforms.unwrap.type": "io.debezium.transforms.UnwrapFromEnvelope",
        "auto.create": "true",
        "insert.mode": "upsert",
        "pk.fields": "customer_id",
        "pk.mode": "record_value"
    }
}'
```
````

Kafka Sink Automation

```python
import psycopg2
import psycopg2.extras
import requests

conn = psycopg2.connect(
    dbname="dvdrental",
    user="postgres",
    password="admin",
    host="db_host",
    port=5432,
)

cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

#cur.execute("""
#SELECT *
#FROM pg_catalog.pg_tables
#WHERE schemaname != 'pg_catalog' AND 
#    schemaname != 'information_schema';
#""")
cur.execute("""
select tab.table_schema,
       tab.table_name,
       tco.constraint_name,
       string_agg(kcu.column_name, ', ') as key_columns
from information_schema.tables tab
left join information_schema.table_constraints tco
          on tco.table_schema = tab.table_schema
          and tco.table_name = tab.table_name
          and tco.constraint_type = 'PRIMARY KEY'
left join information_schema.key_column_usage kcu 
          on kcu.constraint_name = tco.constraint_name
          and kcu.constraint_schema = tco.constraint_schema
          and kcu.constraint_name = tco.constraint_name
where tab.table_schema not in ('pg_catalog', 'information_schema')
      and tab.table_type = 'BASE TABLE'
group by tab.table_schema,
         tab.table_name,
         tco.constraint_name
order by tab.table_schema,
         tab.table_name
""")

row = cur.fetchall()

row = [dict(r) for r in row]
"""
{'table_schema': 'public', 
 'table_name': 'customer', 
 'constraint_name': 'customer_pkey', 
 'key_columns': 'customer_id'}
"""

for r in row:
    table = r['table_name']
    key_columns = r['key_columns'].replace(', ', ',')
    if table == "customer": continue
    payload = {
        "name": "jdbc-sink-"+table+'-localhost2',
        "config": {
            "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
            "tasks.max": "1",
            "topics": table,
            "connection.url": "jdbc:postgresql://postgres:5432/dvdrental?user=postgres&password=admin",
            #"connection.url": "jdbc:postgresql://10.194.48.204:5432/dvdrental?user=postgres&password=admin",
            "transforms": "unwrap",
            "transforms.unwrap.type": "io.debezium.transforms.UnwrapFromEnvelope",
            "auto.create": "true",
            "insert.mode": "upsert",
            #"pk.fields": "customer_id",
            "pk.fields": key_columns,
            "pk.mode": "record_value"
        }
    }
    rs = requests.post("http://localhost:8084/connectors/", json=payload)
    #rs = requests.post("http://localhost:8086/connectors/", json=payload)
    data = rs.json()
    print(data)
```

