---
layout: post
title: "C LD_PRELOAD"
comments: true
date: "2021-07-13 22:35:13.792000+00:00"
---


https://stackoverflow.com/questions/25812181/is-it-possible-to-override-main-method-using-ld-preload


```c
#include <stdio.h>

int main (void)
{
  puts("Hello, world!");
  return 0;
}
```

```c
#include <stdio.h>

int puts (const char *s)
{
  return printf("Hijacked puts: %s\n", s);
}
```

```bash
gcc -o puts.so -shared -fPIC puts.c
gcc main.c -o main
LD_PRELOAD=./puts.so ./main
#Hijacked puts: Hello, world!
```