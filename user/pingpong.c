#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define READ 0
#define WRITE 1


int main(int argc, char *argv[])
{
    if(argc != 1) printf("dont input arguments\n");

    int pipeParToChr[2]; //parent to child
    int pipeChrToPar[2]; //child to parent
    char buf[8];

    pipe(pipeParToChr);
    pipe(pipeChrToPar);

    int pid = fork();
    if( pid < 0 ){      // 创建失败
        printf("Error: fork() failed.\n"); // 输出错误信息到标准错误输出（stderr）
        exit(1); // 直接退出程序
    }
    else if( pid == 0 ) // 子进程
    {
        close(pipeParToChr[WRITE]);
        read(pipeParToChr[READ] , buf , sizeof(buf));
        close(pipeParToChr[READ]);

        close(pipeChrToPar[READ]);
        write(pipeChrToPar[WRITE],"pong\n",5);
        close(pipeChrToPar[WRITE]);

        printf("%d: received %s",getpid(),buf);
        exit(0);

    }else  // 父进程
    {
        close(pipeParToChr[READ]);
        write(pipeParToChr[WRITE] , "ping\n" , 5);
        close(pipeParToChr[WRITE]);

        close(pipeChrToPar[WRITE]);
        read(pipeChrToPar[READ],buf,sizeof(buf));
        close(pipeChrToPar[READ]);
        wait((int*)0);
        printf("%d: received %s",getpid(),buf);
        exit(0);
    }
}
