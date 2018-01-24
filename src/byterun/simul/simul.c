#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

#include "sf-regs.h"
#include "shared.h"

static int is_parent = 0;
static pid_t parent_pid;
static pid_t main_pid;
static pid_t *child_pids;
static pid_t cmnd_pid;
static int nb_proc;
static int *outs;
static int sem_outs;

void send_all_proc(const char *str, int size);

void destroy(){
  V(sem_outs);
  signal(SIGPIPE, SIG_IGN);
  send_all_proc("STOP\n", 5);
  destroy_regs();
  destroy_sem(sem_outs);
}

void terminate(){
  pid_t mypid = getpid();
  if(mypid != main_pid)
    kill(main_pid, SIGINT);
  if(is_parent)
    destroy();
  exit(0);
}

void error(const char *msg){
  fprintf(stderr, "Error: %s\n", msg);
  terminate();
}

void signal_handler(int signum){
  if (signum == SIGSEGV) {
    fprintf(stderr, "%s!\n", strsignal(signum));
  }
  terminate();
}

void signals(){
  signal(SIGINT,  signal_handler);
  signal(SIGPIPE, signal_handler);
  signal(SIGSEGV, signal_handler);
}

int is_stop(char *instr, int size){
  return
    size == 4 &&
    (instr[0] == 'S' || instr[0] == 's') &&
    (instr[1] == 'T' || instr[1] == 't') &&
    (instr[2] == 'O' || instr[2] == 'o') &&
    (instr[3] == 'P' || instr[3] == 'p');
}

void instr_loop(int input){
  int i = 0, n;
  char buf[100];
  while((n = read(input, buf + i, sizeof(buf) - i - 1))){
    int occ = i + n;
    while(i < occ && buf[i] != '\n') i ++;
    if(i == sizeof(buf) - 1){
      buf[i] = '\0';
      fprintf(stderr, "Invalid instruction: %s\n", buf);
      i = 0;
    }else if(i != occ){
      int size;
      buf[i] = '\0';
      size = strlen(buf);
      if(is_stop(buf, size)) return;
      exec_instr(buf, size);
      i ++;
      while(1){
        int j = i;
        while(i < occ && buf[i] != '\n') i ++;
        if(i != occ){
          buf[i] = '\0';
          size = strlen(buf + j);
          if(is_stop(buf + j, size)) return;
          if(size != 0) exec_instr(buf + j, size);
          i ++;
        }else{
          i = 0;
          while(j < occ) buf[i ++] = buf[j ++];
          break;
        }
      }
    }
  }
}

void run_cmnd(const char *cmnd){
  pid_t pid;
  int pipe2[2];
  if(pipe(pipe2) == -1)
    error("pipe()");
  pid = fork();
  if(pid < 0) error("fork()");
  if(pid == 0){
    const char* args[4];
    if(close(pipe2[0]) == -1)
      error("close()");
    if(dup2(pipe2[1], STDOUT_FILENO) == -1)
      error("dup2()");
    fprintf(stderr, "start '%s' (pid = %d)\n", cmnd, getpid());
    args[0] = "/bin/bash";
    args[1] = "-c";
    args[2] = cmnd;
    args[3] = NULL;
    execv("/bin/bash", (char * const *) args);
  }else{
    cmnd_pid = pid;
    signals();
    if(close(pipe2[1]) == -1)
      error("close()");
    instr_loop(pipe2[0]);
    kill(parent_pid, SIGPIPE);
  }
}

void send_all_proc(const char *instr, int size){
  int i;
  P(sem_outs);
  for(i = 0 ; i < nb_proc ; i ++){
    int n = size;
    const char *s = instr;
    while(n > 0){
      int d = write(outs[i], s, n);
      if(d < 1) break;
      n -= d;
      s += d;
    }
  }
  V(sem_outs);
}

#ifdef __OCAML__
#include <caml/mlvalues.h>
value caml_sys_get_argv(value unit);
#else
static const char *global_argv_tbl[] = { "<unknown>", NULL };
const char **global_argv = global_argv_tbl;
#endif

void init_simulator(void){
  int i, j;
  int argc;
  const char **argv;
  int *ins;
  int is_slow = 0;
  static int test_reinit = 0;
  if(test_reinit) return;
  test_reinit = 1;

#ifdef __OCAML__
  argv = ((const char ***) caml_sys_get_argv(Val_unit))[1];
  argc = Wosize_val((value) argv);
#else
  argv = global_argv;
  argc = 0;
  while (argv[argc] != NULL) argc ++;
#endif

  nb_proc = argc - 1;

  for(i = nb_proc ; i > 0 ; i --){
    const char *arg = argv[i];
    int len = strlen(arg);
    if(len > 3 && arg[len-4]=='.' && arg[len-3]=='h' && arg[len-2]=='e'
       && arg[len-1]=='x'){
      nb_proc --;
      argv[i] = "";
    }
    if(!strcmp(arg, "-slow")){
      is_slow = 1;
      nb_proc --;
      argv[i] = "";
    }
    if(!strcmp(arg, "-trace")){
      nb_proc --;
      argv[i] = "";
    }
  }

  init_regs(nb_proc, is_slow);
  child_pids = (pid_t *) alloc_shm(nb_proc * sizeof(pid_t));
  outs = (int *) malloc(nb_proc * sizeof(int));
  ins = (int *) malloc(nb_proc * sizeof(int));
  sem_outs = create_sem(1);

  for(i = 0 ; i < nb_proc ; i ++){
    int pipe1[2];
    if(pipe(pipe1) == -1) error("pipe()");
    ins[i] = pipe1[0];
    outs[i] = pipe1[1];
  }

  {
    pid_t pid = fork();
    if(pid < 0) error("fork()");
    if(pid) {
      is_parent = 1;
      parent_pid = pid;
      signals();
      wait(NULL);
      if (nb_proc > 0) {
        usleep(100000);
        fprintf(stderr, "Program terminated, press enter to exit...\n");
        fgetc(stdin);
      } else {
        fprintf(stderr, "Program terminated.\n");
      }
      destroy();
      exit(0);
    }
  }

  signals();
  main_pid = getpid();

  if(nb_proc == 0){

    return;
  }

  P(sem_outs);

  for(i = 1, j = 0 ; i < argc ; i ++){
    pid_t pid;
    const char *arg = argv[i];
    if(arg[0] != '\0'){
      pid = fork();
      if(pid < 0) error("fork()");
      if(pid == 0){
        if(dup2(ins[j], STDIN_FILENO) == -1) error("dup2()");
        run_cmnd(arg);
        exit(0);
      }else{
        if(close(ins[j]) == -1) error("close()");
        child_pids[j] = pid;
      }
      j ++;
    }
  }

  V(sem_outs);
}
