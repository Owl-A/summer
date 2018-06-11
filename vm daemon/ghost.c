#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>

int main(int argc, char* argv[]){
  FILE* file = NULL;
  file = fopen("/docker/log","w+");
  fprintf(file, "============================================\n");
  fflush(file);
  fprintf(file, "Starting the ghost daemon.\n");
  fflush(file);
  pid_t process_id = 0;
  pid_t sid = 0;
  process_id = fork();
  if(process_id < 0){
    fprintf(file, "fork failed, GHOST daemon\n");
    fflush(file);
    fclose(file);
    exit(1);
  }
  if(process_id > 0){
    fclose(file);
    exit(0);
  }
  sid = setsid();
  if(sid < 0) {
    fprintf(file, "closing session because of failure in changing sessions\n");
    fflush(file);
    fclose(file);
    exit(1);
  }
  close(STDIN_FILENO);
  close(STDOUT_FILENO);
  close(STDERR_FILENO);
  fprintf(file, "daemon started successfully.\n");
  fflush(file);
  int done = 0; 
  while(!done){
    sleep(1);
    int ret = system("/etc/init.d/lab.sh"); 
    if( ret == 0 ){
      done = 1;
    }else{
      fprintf(file, "exit status of this try is %d", ret);
    }
    if(done == 1){
      // may choose to write another program that handles this notif but for time being let's direct it to the logs
      fprintf(file, "Daemon finished task successfully\n");
      fflush(file);
    }else{
      fprintf(file, "Retrying in 3 seconds\n");
      fflush(file);
      system("/destroy.sh");
      sleep(3);
    }    
  }
  fclose(file);
  return 0;
}

