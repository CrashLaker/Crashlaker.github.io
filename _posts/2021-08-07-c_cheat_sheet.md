---
layout: post
title: "C Cheat Sheet"
comments: true
date: "2021-08-07 16:06:02.106000+00:00"
---


### Pthread


```c
pthread_t tid_thread;
if (pthread_create(&tid_thread, NULL, listen_svc, NULL)){
    printf('error joining thread\n');
}
if (pthread_join(tid_thread)){
    printf('error thread');
}
void listen_svc(){
    //run
}
```

**with arguments**

```c
pthread_t tid_thread;
int a = 2;
if (pthread_create(&tid_thread, NULL, inout_thread, &a)){
    printf('error joining thread\n');
}
if (pthread_join(tid_thread)){
    printf('error thread');
}
void *inout_thread(void *v){
    //run
    int *tid = (int*) v;
}
```


### Shared Memory

```c
#include <stdio.h>    
#include <sys/types.h>
#include <sys/wait.h> 
#include   <sys/ipc.h>
#include   <sys/shm.h>
#include <semaphore.h>
#include <stdlib.h>   
#include <string.h>   
#include <unistd.h>   



void main(){


    pid_t pid;
    int id_arr = shmget(IPC_PRIVATE, sizeof(int)*100, 0777 | IPC_CREAT);
    int *arr;
    
    int i, status;
    pid = fork();

    if (pid == 0){ // children
        arr = shmat(id_arr, 0, 0);                               
        for (i = 0; i < 100; i++)
            arr[i] = 10;

        arr[11] = 11;
        printf("arr %d\n", arr[10]);
        printf("arr %d\n", arr[11]);
        exit(1);
    }else{
        waitpid(pid,&status,0);
        arr = shmat(id_arr, 0, 0);                               
        printf("arr %d\n", arr[10]);
        printf("arr %d\n", arr[11]);
        shmdt(id_arr);
        shmctl(id_arr, IPC_RMID, NULL); //remove area compartilhada
    }
}
```


### Creaste as Double. Send as MPI_CHAR. Receive as VOID send as CHAR receive as Double

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <mpi.h>

int main(int argc, char** argv) {
    // Initialize the MPI environment
    MPI_Init(NULL, NULL);

    // Get the number of processes
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    // Get the rank of the process
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    // Get the name of the processor
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);

    // Print off a hello world message
    printf("Hello world from processor %s, rank %d out of %d processors\n",
           processor_name, world_rank, world_size);

    int i,a,b,c,d;
    if (world_rank == 0){
        double arr[100];
        for (i = 0; i < 100; i++)
            arr[i] = i;
        MPI_Send(&arr, 100*sizeof(double), MPI_CHAR, 1, 0, MPI_COMM_WORLD);
    }else if (world_rank == 1){
        void * arr = malloc(sizeof(double)*100);
        MPI_Recv(arr, 100, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        MPI_Send(arr, 100*sizeof(double), MPI_CHAR, 2, 0, MPI_COMM_WORLD);
    }else if (world_rank == 2){
        double arr[100];
        MPI_Recv(arr, 100, MPI_DOUBLE, 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        for(i = 0; i < 10; i++){
            printf("%f\n", arr[i]);
        }
    }


    // Finalize the MPI environment.
    MPI_Finalize();
}
```

```bash
mpicc main.c
mpirun -n 3 ./a.out
```

output
```
Hello world from processor controller, rank 0 out of 3 processors
Hello world from processor controller, rank 1 out of 3 processors
Hello world from processor controller, rank 2 out of 3 processors
0.000000
1.000000
2.000000
3.000000
4.000000
5.000000
6.000000
7.000000
8.000000
9.000000
```










