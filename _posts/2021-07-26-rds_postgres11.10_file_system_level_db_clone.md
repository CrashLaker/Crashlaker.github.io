---
layout: post
title: "RDS Postgres11.10 File System Level DB Clone"
comments: true
date: "2021-07-26 06:13:55.985000+00:00"
---


```{admonition} Summary
In this tutorial we'll be cloning a database `dvdrental` to `dvdrental4`
```

#### Steps

* Create new database
* Apply old database schema to new database
* Copy `<postgres_data>/base/<oid>` from old to new
* Fix `pg_class` column `relfilenode` to match original in `base/<oid>` directory
* Force reindex


##### Create new database

```bash
docker exec -it postgres psql -U postgres -c 'create database dvdrental4'
```

##### Apply database schema

```bash
docker exec -i postgres pg_dump -U postgres -s dvdrental | docker exec -i postgres psql -U postgres -d dvdrental4
```

##### Copy folder

```bash
docker exec -i postgres psql -U postgres -c 'select oid, datname from pg_database;'
```
```
  oid  |  datname   
-------+------------
 13067 | postgres
 16384 | dvdrental
     1 | template1
 13066 | template0
 16482 | dvdrental2
 16539 | dvdrental3
 16728 | dvdrental4
(7 rows)
```

folder list

```bash
# pwd
/root/pgdata/base
# ls
13066  13067  16384  16482  16539  16728
```

dvdrental (`16384`) -> dvdrental4(`16728`)
```bash
/usr/bin/cp -fa 16384/. 16728/
```

##### Fix `pg_class` + force `REINDEX`

```python
import psycopg2
import psycopg2.extras
import requests
import pandas as pd




conn = psycopg2.connect(
    dbname="dvdrental",
    user="postgres",
    password="admin",
    host="localhost",
    port=5432,
)
conn2 = psycopg2.connect(
    dbname="dvdrental4",
    user="postgres",
    password="admin",
    host="localhost",
    port=5432,
)

cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
cur2 = conn2.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

cur.execute("""
SELECT *
FROM pg_catalog.pg_tables
WHERE schemaname != 'pg_catalog' AND 
    schemaname != 'information_schema';
""")

df = pd.DataFrame(cur.fetchall())

tables = list(set(df['tablename'].values))

print(tables)

dforig = []

for table in tables:
    cur.execute(f"""
    select oid,relname,relkind,relfilenode from pg_class where relname = '{table}';
    """)
    df = pd.DataFrame(cur.fetchall())
    dforig.append(df)
    #oid   relname relkind  relfilenode
    print(df)
    print("indexes")
    relfilenode = str(df.iloc[0].relfilenode)
    cur.execute(f"""
    select oid,relname,relkind,relfilenode from pg_class where relname like 'pg_toast_{relfilenode}%'
    """)
    df = pd.DataFrame(cur.fetchall())
    dforig.append(df)
    print(df)
    print("===============")

dforig = pd.concat(dforig)
pd.set_option('display.max_rows', None)
#  oid  relname relkind  relfilenode
print(dforig)
dictorig = {
    doc['relname']:doc['relfilenode']
    for doc in dforig.to_dict('r')
}

#cur2.execute("select distinct relname from pg_class")
#relnames = set(pd.DataFrame(cur2.fetchall())['relname'].values)

for table,filenode in dictorig.items():
    if 'pg_toast_' in table: continue
    #if table != 'staff': continue
    print(table, filenode)
    cmd = f"""
    select oid,relname,relkind,relfilenode from pg_class where relname = '{table}';
    """
    print(cmd)
    cur2.execute(cmd)
    df = pd.DataFrame(cur2.fetchall())
    print(df)
    relfilenode = str(df.iloc[0].relfilenode)
    cmd = f"""
    update pg_class set relfilenode = {filenode} where relname = '{table}'
    """
    print(cmd)
    cur2.execute(cmd)
    toasts = [
        lambda x: f"pg_toast_{x}",
        lambda x: f"pg_toast_{x}_index",
    ]
    for t in toasts:
        if t(filenode) in dictorig:
            #if not t(relfilenode) in relnames: continue
            old_toast = t(filenode)
            toast_filenode = dictorig[t(filenode)]
            cmd = f"""
            update pg_class set relfilenode = {toast_filenode} where relname = '{t(relfilenode)}'
            """
            print(cmd)
            cur2.execute(cmd)
    cmd = f"""
    reindex table {table}
    """
    print(cmd)
    cur2.execute(cmd)
conn2.commit()
```

```bash
# docker exec -i postgres psql -U postgres -d dvdrental4 -c 'select * from actor;'
```

```
   last_update    |  last_name   | actor_id | first_name  
------------------+--------------+----------+-------------
 1369579677620000 | Guiness      |        1 | Penelope
 1369579677620000 | Wahlberg     |        2 | Nick
 1369579677620000 | Chase        |        3 | Ed
 1369579677620000 | Davis        |        4 | Jennifer
 1369579677620000 | Lollobrigida |        5 | Johnny
 1369579677620000 | Nicholson    |        6 | Bette
 1369579677620000 | Mostel       |        7 | Grace
 1369579677620000 | Johansson    |        8 | Matthew
 1369579677620000 | Swank        |        9 | Joe
 1369579677620000 | Gable        |       10 | Christian
 1369579677620000 | Cage         |       11 | Zero
 1369579677620000 | Berry        |       12 | Karl
```
