---
layout: post
title: "LFTP Centos 8"
comments: true
date: "2021-07-16 16:38:17.193000+00:00"
---


https://lftp.yar.ru/get.html

```bash
wget http://lftp.yar.ru/ftp/lftp-4.9.2.tar.gz
tar xzvf lftp-4.9.2.tar.gz
cd lftp-4.9.2
yum -y install gcc gcc-c++ ncurses-devel readline-devel gnutls-devel zlib-devel
./configure
make
make install
```





