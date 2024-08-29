#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc,char *argv[])
{
    if(argc < 2) 
    {
        printf("sleep need one argument\n");
        exit(1);
    }
    uint ticks = atoi(argv[1]);
    printf("(start sleep)\n");
    sleep(ticks);
    exit(0);
}
