
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include "shared.h"

int create_sem(int init){
  int sem = semget(IPC_PRIVATE, 1, IPC_CREAT | 0600);
  if(sem == -1){
    fprintf(stderr, "Error: semget()\n");
    exit(1);
  }
  if(semctl(sem, 0, SETVAL, init) == -1){
    fprintf(stderr, "Error: semctl()\n");
    exit(1);
  }
  return sem;
}

void destroy_sem(int sem){
  if(semctl(sem, 0, IPC_RMID, 0) == -1){
    fprintf(stderr, "Error: semctl()\n");
    exit(1);
  }
}

void *alloc_shm(size_t size){
  if(size == 0){
    return NULL;
  }else{
    int id = shmget(IPC_PRIVATE, size, IPC_CREAT | 0600);
    void *res;
    if(id == -1){
      fprintf(stderr, "Error: shmget()\n");
      exit(1);
    }
    res = shmat(id, NULL, 0);
    if(res == NULL){
      fprintf(stderr, "Error: shmat()\n");
      exit(1);
    }
    if(shmctl(id, IPC_RMID, NULL) == -1) fprintf(stderr, "Error: shmctl()\n");
    return res;
  }
}

void P(int sem){
  struct sembuf sops;
  sops.sem_num = 0;
  sops.sem_op = -1;
  sops.sem_flg = 0;
  if(semop(sem, &sops, 1) == -1){
    fprintf(stderr, "Error: semop()\n");
    exit(1);
  }
}

void V(int sem){
  struct sembuf sops;
  sops.sem_num = 0;
  sops.sem_op = 1;
  sops.sem_flg = 0;
  if(semop(sem, &sops, 1) == -1){
    fprintf(stderr, "Error: semop()\n");
    exit(1);
  }
}
