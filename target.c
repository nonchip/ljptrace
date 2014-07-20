#include <unistd.h>
#include <stdio.h>

int x=1234567890;
void main(){
  while(1){
    printf("%d ",x);
    fflush(stdout);
    sleep(1);
  }
}
