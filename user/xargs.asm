
user/_xargs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[]) 
{
   0:	7145                	addi	sp,sp,-464
   2:	e786                	sd	ra,456(sp)
   4:	e3a2                	sd	s0,448(sp)
   6:	ff26                	sd	s1,440(sp)
   8:	fb4a                	sd	s2,432(sp)
   a:	f74e                	sd	s3,424(sp)
   c:	f352                	sd	s4,416(sp)
   e:	ef56                	sd	s5,408(sp)
  10:	0b80                	addi	s0,sp,464
    char *new_argv[MAXARG];
    int cur_argv = 1;
    for( cur_argv = 1 ;cur_argv <= argc - 1 ; cur_argv++)
  12:	4785                	li	a5,1
  14:	04a7d463          	bge	a5,a0,5c <main+0x5c>
  18:	00858713          	addi	a4,a1,8
  1c:	ec040793          	addi	a5,s0,-320
  20:	ffe5061b          	addiw	a2,a0,-2
  24:	1602                	slli	a2,a2,0x20
  26:	9201                	srli	a2,a2,0x20
  28:	060e                	slli	a2,a2,0x3
  2a:	ec840693          	addi	a3,s0,-312
  2e:	9636                	add	a2,a2,a3
    {
        new_argv[cur_argv - 1] = argv[cur_argv];
  30:	6314                	ld	a3,0(a4)
  32:	e394                	sd	a3,0(a5)
    for( cur_argv = 1 ;cur_argv <= argc - 1 ; cur_argv++)
  34:	0721                	addi	a4,a4,8
  36:	07a1                	addi	a5,a5,8
  38:	fec79ce3          	bne	a5,a2,30 <main+0x30>
  3c:	892a                	mv	s2,a0
    }
    
    char ch;
    char buf[128];
    char *cur_buf = buf;
    new_argv[cur_argv-1] = buf;
  3e:	fff9079b          	addiw	a5,s2,-1
  42:	078e                	slli	a5,a5,0x3
  44:	fc040713          	addi	a4,s0,-64
  48:	97ba                	add	a5,a5,a4
  4a:	e3840493          	addi	s1,s0,-456
  4e:	f097b023          	sd	s1,-256(a5)
   
    while(read(0,&ch,sizeof(char)))
    {
        if( ch == ' ')
  52:	02000993          	li	s3,32
        {
            *cur_buf = '\0';
            cur_buf++;
            new_argv[cur_argv ] = cur_buf;
            cur_argv++;
        }else if( ch == '\n' )
  56:	4a29                	li	s4,10
                exit(0);
            }else
            {
                wait((int*)0);
                cur_buf = buf;
                cur_argv = argc;
  58:	8aaa                	mv	s5,a0
    while(read(0,&ch,sizeof(char)))
  5a:	a831                	j	76 <main+0x76>
    for( cur_argv = 1 ;cur_argv <= argc - 1 ; cur_argv++)
  5c:	4905                	li	s2,1
  5e:	b7c5                	j	3e <main+0x3e>
            *cur_buf = '\0';
  60:	00048023          	sb	zero,0(s1)
            cur_buf++;
  64:	0485                	addi	s1,s1,1
            new_argv[cur_argv ] = cur_buf;
  66:	00391793          	slli	a5,s2,0x3
  6a:	fc040713          	addi	a4,s0,-64
  6e:	97ba                	add	a5,a5,a4
  70:	f097b023          	sd	s1,-256(a5)
            cur_argv++;
  74:	2905                	addiw	s2,s2,1
    while(read(0,&ch,sizeof(char)))
  76:	4605                	li	a2,1
  78:	ebf40593          	addi	a1,s0,-321
  7c:	4501                	li	a0,0
  7e:	00000097          	auipc	ra,0x0
  82:	2fa080e7          	jalr	762(ra) # 378 <read>
  86:	cd31                	beqz	a0,e2 <main+0xe2>
        if( ch == ' ')
  88:	ebf44783          	lbu	a5,-321(s0)
  8c:	fd378ae3          	beq	a5,s3,60 <main+0x60>
        }else if( ch == '\n' )
  90:	01478663          	beq	a5,s4,9c <main+0x9c>
            }
        }else
        {
            *cur_buf = ch;
  94:	00f48023          	sb	a5,0(s1)
            cur_buf++;
  98:	0485                	addi	s1,s1,1
  9a:	bff1                	j	76 <main+0x76>
            *cur_buf = '\0';
  9c:	00048023          	sb	zero,0(s1)
            new_argv[cur_argv] = 0;
  a0:	090e                	slli	s2,s2,0x3
  a2:	fc040793          	addi	a5,s0,-64
  a6:	993e                	add	s2,s2,a5
  a8:	f0093023          	sd	zero,-256(s2)
            int pid = fork();
  ac:	00000097          	auipc	ra,0x0
  b0:	2ac080e7          	jalr	684(ra) # 358 <fork>
            if( pid == 0)
  b4:	c911                	beqz	a0,c8 <main+0xc8>
                wait((int*)0);
  b6:	4501                	li	a0,0
  b8:	00000097          	auipc	ra,0x0
  bc:	2b0080e7          	jalr	688(ra) # 368 <wait>
                cur_argv = argc;
  c0:	8956                	mv	s2,s5
                cur_buf = buf;
  c2:	e3840493          	addi	s1,s0,-456
  c6:	bf45                	j	76 <main+0x76>
                exec(new_argv[0] , new_argv);
  c8:	ec040593          	addi	a1,s0,-320
  cc:	ec043503          	ld	a0,-320(s0)
  d0:	00000097          	auipc	ra,0x0
  d4:	2c8080e7          	jalr	712(ra) # 398 <exec>
                exit(0);
  d8:	4501                	li	a0,0
  da:	00000097          	auipc	ra,0x0
  de:	286080e7          	jalr	646(ra) # 360 <exit>
        }
    }
   
    exit(0);
  e2:	00000097          	auipc	ra,0x0
  e6:	27e080e7          	jalr	638(ra) # 360 <exit>

00000000000000ea <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f0:	87aa                	mv	a5,a0
  f2:	0585                	addi	a1,a1,1
  f4:	0785                	addi	a5,a5,1
  f6:	fff5c703          	lbu	a4,-1(a1)
  fa:	fee78fa3          	sb	a4,-1(a5)
  fe:	fb75                	bnez	a4,f2 <strcpy+0x8>
    ;
  return os;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x1e>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x1e>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strlen>:

uint
strlen(const char *s)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf91                	beqz	a5,158 <strlen+0x26>
 13e:	0505                	addi	a0,a0,1
 140:	87aa                	mv	a5,a0
 142:	4685                	li	a3,1
 144:	9e89                	subw	a3,a3,a0
 146:	00f6853b          	addw	a0,a3,a5
 14a:	0785                	addi	a5,a5,1
 14c:	fff7c703          	lbu	a4,-1(a5)
 150:	fb7d                	bnez	a4,146 <strlen+0x14>
    ;
  return n;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret
  for(n = 0; s[n]; n++)
 158:	4501                	li	a0,0
 15a:	bfe5                	j	152 <strlen+0x20>

000000000000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 162:	ce09                	beqz	a2,17c <memset+0x20>
 164:	87aa                	mv	a5,a0
 166:	fff6071b          	addiw	a4,a2,-1
 16a:	1702                	slli	a4,a4,0x20
 16c:	9301                	srli	a4,a4,0x20
 16e:	0705                	addi	a4,a4,1
 170:	972a                	add	a4,a4,a0
    cdst[i] = c;
 172:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 176:	0785                	addi	a5,a5,1
 178:	fee79de3          	bne	a5,a4,172 <memset+0x16>
  }
  return dst;
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret

0000000000000182 <strchr>:

char*
strchr(const char *s, char c)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  for(; *s; s++)
 188:	00054783          	lbu	a5,0(a0)
 18c:	cb99                	beqz	a5,1a2 <strchr+0x20>
    if(*s == c)
 18e:	00f58763          	beq	a1,a5,19c <strchr+0x1a>
  for(; *s; s++)
 192:	0505                	addi	a0,a0,1
 194:	00054783          	lbu	a5,0(a0)
 198:	fbfd                	bnez	a5,18e <strchr+0xc>
      return (char*)s;
  return 0;
 19a:	4501                	li	a0,0
}
 19c:	6422                	ld	s0,8(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret
  return 0;
 1a2:	4501                	li	a0,0
 1a4:	bfe5                	j	19c <strchr+0x1a>

00000000000001a6 <gets>:

char*
gets(char *buf, int max)
{
 1a6:	711d                	addi	sp,sp,-96
 1a8:	ec86                	sd	ra,88(sp)
 1aa:	e8a2                	sd	s0,80(sp)
 1ac:	e4a6                	sd	s1,72(sp)
 1ae:	e0ca                	sd	s2,64(sp)
 1b0:	fc4e                	sd	s3,56(sp)
 1b2:	f852                	sd	s4,48(sp)
 1b4:	f456                	sd	s5,40(sp)
 1b6:	f05a                	sd	s6,32(sp)
 1b8:	ec5e                	sd	s7,24(sp)
 1ba:	1080                	addi	s0,sp,96
 1bc:	8baa                	mv	s7,a0
 1be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	892a                	mv	s2,a0
 1c2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c4:	4aa9                	li	s5,10
 1c6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1c8:	89a6                	mv	s3,s1
 1ca:	2485                	addiw	s1,s1,1
 1cc:	0344d863          	bge	s1,s4,1fc <gets+0x56>
    cc = read(0, &c, 1);
 1d0:	4605                	li	a2,1
 1d2:	faf40593          	addi	a1,s0,-81
 1d6:	4501                	li	a0,0
 1d8:	00000097          	auipc	ra,0x0
 1dc:	1a0080e7          	jalr	416(ra) # 378 <read>
    if(cc < 1)
 1e0:	00a05e63          	blez	a0,1fc <gets+0x56>
    buf[i++] = c;
 1e4:	faf44783          	lbu	a5,-81(s0)
 1e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ec:	01578763          	beq	a5,s5,1fa <gets+0x54>
 1f0:	0905                	addi	s2,s2,1
 1f2:	fd679be3          	bne	a5,s6,1c8 <gets+0x22>
  for(i=0; i+1 < max; ){
 1f6:	89a6                	mv	s3,s1
 1f8:	a011                	j	1fc <gets+0x56>
 1fa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1fc:	99de                	add	s3,s3,s7
 1fe:	00098023          	sb	zero,0(s3)
  return buf;
}
 202:	855e                	mv	a0,s7
 204:	60e6                	ld	ra,88(sp)
 206:	6446                	ld	s0,80(sp)
 208:	64a6                	ld	s1,72(sp)
 20a:	6906                	ld	s2,64(sp)
 20c:	79e2                	ld	s3,56(sp)
 20e:	7a42                	ld	s4,48(sp)
 210:	7aa2                	ld	s5,40(sp)
 212:	7b02                	ld	s6,32(sp)
 214:	6be2                	ld	s7,24(sp)
 216:	6125                	addi	sp,sp,96
 218:	8082                	ret

000000000000021a <stat>:

int
stat(const char *n, struct stat *st)
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	e426                	sd	s1,8(sp)
 222:	e04a                	sd	s2,0(sp)
 224:	1000                	addi	s0,sp,32
 226:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 228:	4581                	li	a1,0
 22a:	00000097          	auipc	ra,0x0
 22e:	176080e7          	jalr	374(ra) # 3a0 <open>
  if(fd < 0)
 232:	02054563          	bltz	a0,25c <stat+0x42>
 236:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 238:	85ca                	mv	a1,s2
 23a:	00000097          	auipc	ra,0x0
 23e:	17e080e7          	jalr	382(ra) # 3b8 <fstat>
 242:	892a                	mv	s2,a0
  close(fd);
 244:	8526                	mv	a0,s1
 246:	00000097          	auipc	ra,0x0
 24a:	142080e7          	jalr	322(ra) # 388 <close>
  return r;
}
 24e:	854a                	mv	a0,s2
 250:	60e2                	ld	ra,24(sp)
 252:	6442                	ld	s0,16(sp)
 254:	64a2                	ld	s1,8(sp)
 256:	6902                	ld	s2,0(sp)
 258:	6105                	addi	sp,sp,32
 25a:	8082                	ret
    return -1;
 25c:	597d                	li	s2,-1
 25e:	bfc5                	j	24e <stat+0x34>

0000000000000260 <atoi>:

int
atoi(const char *s)
{
 260:	1141                	addi	sp,sp,-16
 262:	e422                	sd	s0,8(sp)
 264:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 266:	00054603          	lbu	a2,0(a0)
 26a:	fd06079b          	addiw	a5,a2,-48
 26e:	0ff7f793          	andi	a5,a5,255
 272:	4725                	li	a4,9
 274:	02f76963          	bltu	a4,a5,2a6 <atoi+0x46>
 278:	86aa                	mv	a3,a0
  n = 0;
 27a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 27c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 27e:	0685                	addi	a3,a3,1
 280:	0025179b          	slliw	a5,a0,0x2
 284:	9fa9                	addw	a5,a5,a0
 286:	0017979b          	slliw	a5,a5,0x1
 28a:	9fb1                	addw	a5,a5,a2
 28c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 290:	0006c603          	lbu	a2,0(a3)
 294:	fd06071b          	addiw	a4,a2,-48
 298:	0ff77713          	andi	a4,a4,255
 29c:	fee5f1e3          	bgeu	a1,a4,27e <atoi+0x1e>
  return n;
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
  n = 0;
 2a6:	4501                	li	a0,0
 2a8:	bfe5                	j	2a0 <atoi+0x40>

00000000000002aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b0:	02b57663          	bgeu	a0,a1,2dc <memmove+0x32>
    while(n-- > 0)
 2b4:	02c05163          	blez	a2,2d6 <memmove+0x2c>
 2b8:	fff6079b          	addiw	a5,a2,-1
 2bc:	1782                	slli	a5,a5,0x20
 2be:	9381                	srli	a5,a5,0x20
 2c0:	0785                	addi	a5,a5,1
 2c2:	97aa                	add	a5,a5,a0
  dst = vdst;
 2c4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c6:	0585                	addi	a1,a1,1
 2c8:	0705                	addi	a4,a4,1
 2ca:	fff5c683          	lbu	a3,-1(a1)
 2ce:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d2:	fee79ae3          	bne	a5,a4,2c6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
    dst += n;
 2dc:	00c50733          	add	a4,a0,a2
    src += n;
 2e0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e2:	fec05ae3          	blez	a2,2d6 <memmove+0x2c>
 2e6:	fff6079b          	addiw	a5,a2,-1
 2ea:	1782                	slli	a5,a5,0x20
 2ec:	9381                	srli	a5,a5,0x20
 2ee:	fff7c793          	not	a5,a5
 2f2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f4:	15fd                	addi	a1,a1,-1
 2f6:	177d                	addi	a4,a4,-1
 2f8:	0005c683          	lbu	a3,0(a1)
 2fc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 300:	fee79ae3          	bne	a5,a4,2f4 <memmove+0x4a>
 304:	bfc9                	j	2d6 <memmove+0x2c>

0000000000000306 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 30c:	ca05                	beqz	a2,33c <memcmp+0x36>
 30e:	fff6069b          	addiw	a3,a2,-1
 312:	1682                	slli	a3,a3,0x20
 314:	9281                	srli	a3,a3,0x20
 316:	0685                	addi	a3,a3,1
 318:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31a:	00054783          	lbu	a5,0(a0)
 31e:	0005c703          	lbu	a4,0(a1)
 322:	00e79863          	bne	a5,a4,332 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 326:	0505                	addi	a0,a0,1
    p2++;
 328:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32a:	fed518e3          	bne	a0,a3,31a <memcmp+0x14>
  }
  return 0;
 32e:	4501                	li	a0,0
 330:	a019                	j	336 <memcmp+0x30>
      return *p1 - *p2;
 332:	40e7853b          	subw	a0,a5,a4
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
  return 0;
 33c:	4501                	li	a0,0
 33e:	bfe5                	j	336 <memcmp+0x30>

0000000000000340 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 348:	00000097          	auipc	ra,0x0
 34c:	f62080e7          	jalr	-158(ra) # 2aa <memmove>
}
 350:	60a2                	ld	ra,8(sp)
 352:	6402                	ld	s0,0(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret

0000000000000358 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 358:	4885                	li	a7,1
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <exit>:
.global exit
exit:
 li a7, SYS_exit
 360:	4889                	li	a7,2
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <wait>:
.global wait
wait:
 li a7, SYS_wait
 368:	488d                	li	a7,3
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 370:	4891                	li	a7,4
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <read>:
.global read
read:
 li a7, SYS_read
 378:	4895                	li	a7,5
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <write>:
.global write
write:
 li a7, SYS_write
 380:	48c1                	li	a7,16
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <close>:
.global close
close:
 li a7, SYS_close
 388:	48d5                	li	a7,21
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <kill>:
.global kill
kill:
 li a7, SYS_kill
 390:	4899                	li	a7,6
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <exec>:
.global exec
exec:
 li a7, SYS_exec
 398:	489d                	li	a7,7
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <open>:
.global open
open:
 li a7, SYS_open
 3a0:	48bd                	li	a7,15
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a8:	48c5                	li	a7,17
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b0:	48c9                	li	a7,18
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b8:	48a1                	li	a7,8
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <link>:
.global link
link:
 li a7, SYS_link
 3c0:	48cd                	li	a7,19
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c8:	48d1                	li	a7,20
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d0:	48a5                	li	a7,9
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d8:	48a9                	li	a7,10
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e0:	48ad                	li	a7,11
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e8:	48b1                	li	a7,12
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f0:	48b5                	li	a7,13
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f8:	48b9                	li	a7,14
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 400:	1101                	addi	sp,sp,-32
 402:	ec06                	sd	ra,24(sp)
 404:	e822                	sd	s0,16(sp)
 406:	1000                	addi	s0,sp,32
 408:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40c:	4605                	li	a2,1
 40e:	fef40593          	addi	a1,s0,-17
 412:	00000097          	auipc	ra,0x0
 416:	f6e080e7          	jalr	-146(ra) # 380 <write>
}
 41a:	60e2                	ld	ra,24(sp)
 41c:	6442                	ld	s0,16(sp)
 41e:	6105                	addi	sp,sp,32
 420:	8082                	ret

0000000000000422 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 422:	7139                	addi	sp,sp,-64
 424:	fc06                	sd	ra,56(sp)
 426:	f822                	sd	s0,48(sp)
 428:	f426                	sd	s1,40(sp)
 42a:	f04a                	sd	s2,32(sp)
 42c:	ec4e                	sd	s3,24(sp)
 42e:	0080                	addi	s0,sp,64
 430:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 432:	c299                	beqz	a3,438 <printint+0x16>
 434:	0805c863          	bltz	a1,4c4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 438:	2581                	sext.w	a1,a1
  neg = 0;
 43a:	4881                	li	a7,0
 43c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 440:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 442:	2601                	sext.w	a2,a2
 444:	00000517          	auipc	a0,0x0
 448:	44450513          	addi	a0,a0,1092 # 888 <digits>
 44c:	883a                	mv	a6,a4
 44e:	2705                	addiw	a4,a4,1
 450:	02c5f7bb          	remuw	a5,a1,a2
 454:	1782                	slli	a5,a5,0x20
 456:	9381                	srli	a5,a5,0x20
 458:	97aa                	add	a5,a5,a0
 45a:	0007c783          	lbu	a5,0(a5)
 45e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 462:	0005879b          	sext.w	a5,a1
 466:	02c5d5bb          	divuw	a1,a1,a2
 46a:	0685                	addi	a3,a3,1
 46c:	fec7f0e3          	bgeu	a5,a2,44c <printint+0x2a>
  if(neg)
 470:	00088b63          	beqz	a7,486 <printint+0x64>
    buf[i++] = '-';
 474:	fd040793          	addi	a5,s0,-48
 478:	973e                	add	a4,a4,a5
 47a:	02d00793          	li	a5,45
 47e:	fef70823          	sb	a5,-16(a4)
 482:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 486:	02e05863          	blez	a4,4b6 <printint+0x94>
 48a:	fc040793          	addi	a5,s0,-64
 48e:	00e78933          	add	s2,a5,a4
 492:	fff78993          	addi	s3,a5,-1
 496:	99ba                	add	s3,s3,a4
 498:	377d                	addiw	a4,a4,-1
 49a:	1702                	slli	a4,a4,0x20
 49c:	9301                	srli	a4,a4,0x20
 49e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a2:	fff94583          	lbu	a1,-1(s2)
 4a6:	8526                	mv	a0,s1
 4a8:	00000097          	auipc	ra,0x0
 4ac:	f58080e7          	jalr	-168(ra) # 400 <putc>
  while(--i >= 0)
 4b0:	197d                	addi	s2,s2,-1
 4b2:	ff3918e3          	bne	s2,s3,4a2 <printint+0x80>
}
 4b6:	70e2                	ld	ra,56(sp)
 4b8:	7442                	ld	s0,48(sp)
 4ba:	74a2                	ld	s1,40(sp)
 4bc:	7902                	ld	s2,32(sp)
 4be:	69e2                	ld	s3,24(sp)
 4c0:	6121                	addi	sp,sp,64
 4c2:	8082                	ret
    x = -xx;
 4c4:	40b005bb          	negw	a1,a1
    neg = 1;
 4c8:	4885                	li	a7,1
    x = -xx;
 4ca:	bf8d                	j	43c <printint+0x1a>

00000000000004cc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4cc:	7119                	addi	sp,sp,-128
 4ce:	fc86                	sd	ra,120(sp)
 4d0:	f8a2                	sd	s0,112(sp)
 4d2:	f4a6                	sd	s1,104(sp)
 4d4:	f0ca                	sd	s2,96(sp)
 4d6:	ecce                	sd	s3,88(sp)
 4d8:	e8d2                	sd	s4,80(sp)
 4da:	e4d6                	sd	s5,72(sp)
 4dc:	e0da                	sd	s6,64(sp)
 4de:	fc5e                	sd	s7,56(sp)
 4e0:	f862                	sd	s8,48(sp)
 4e2:	f466                	sd	s9,40(sp)
 4e4:	f06a                	sd	s10,32(sp)
 4e6:	ec6e                	sd	s11,24(sp)
 4e8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ea:	0005c903          	lbu	s2,0(a1)
 4ee:	18090f63          	beqz	s2,68c <vprintf+0x1c0>
 4f2:	8aaa                	mv	s5,a0
 4f4:	8b32                	mv	s6,a2
 4f6:	00158493          	addi	s1,a1,1
  state = 0;
 4fa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fc:	02500a13          	li	s4,37
      if(c == 'd'){
 500:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 504:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 508:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 50c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 510:	00000b97          	auipc	s7,0x0
 514:	378b8b93          	addi	s7,s7,888 # 888 <digits>
 518:	a839                	j	536 <vprintf+0x6a>
        putc(fd, c);
 51a:	85ca                	mv	a1,s2
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	ee2080e7          	jalr	-286(ra) # 400 <putc>
 526:	a019                	j	52c <vprintf+0x60>
    } else if(state == '%'){
 528:	01498f63          	beq	s3,s4,546 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 52c:	0485                	addi	s1,s1,1
 52e:	fff4c903          	lbu	s2,-1(s1)
 532:	14090d63          	beqz	s2,68c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 536:	0009079b          	sext.w	a5,s2
    if(state == 0){
 53a:	fe0997e3          	bnez	s3,528 <vprintf+0x5c>
      if(c == '%'){
 53e:	fd479ee3          	bne	a5,s4,51a <vprintf+0x4e>
        state = '%';
 542:	89be                	mv	s3,a5
 544:	b7e5                	j	52c <vprintf+0x60>
      if(c == 'd'){
 546:	05878063          	beq	a5,s8,586 <vprintf+0xba>
      } else if(c == 'l') {
 54a:	05978c63          	beq	a5,s9,5a2 <vprintf+0xd6>
      } else if(c == 'x') {
 54e:	07a78863          	beq	a5,s10,5be <vprintf+0xf2>
      } else if(c == 'p') {
 552:	09b78463          	beq	a5,s11,5da <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 556:	07300713          	li	a4,115
 55a:	0ce78663          	beq	a5,a4,626 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 55e:	06300713          	li	a4,99
 562:	0ee78e63          	beq	a5,a4,65e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 566:	11478863          	beq	a5,s4,676 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 56a:	85d2                	mv	a1,s4
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	e92080e7          	jalr	-366(ra) # 400 <putc>
        putc(fd, c);
 576:	85ca                	mv	a1,s2
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e86080e7          	jalr	-378(ra) # 400 <putc>
      }
      state = 0;
 582:	4981                	li	s3,0
 584:	b765                	j	52c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 586:	008b0913          	addi	s2,s6,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000b2583          	lw	a1,0(s6)
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	e8e080e7          	jalr	-370(ra) # 422 <printint>
 59c:	8b4a                	mv	s6,s2
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b771                	j	52c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a2:	008b0913          	addi	s2,s6,8
 5a6:	4681                	li	a3,0
 5a8:	4629                	li	a2,10
 5aa:	000b2583          	lw	a1,0(s6)
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e72080e7          	jalr	-398(ra) # 422 <printint>
 5b8:	8b4a                	mv	s6,s2
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bf85                	j	52c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5be:	008b0913          	addi	s2,s6,8
 5c2:	4681                	li	a3,0
 5c4:	4641                	li	a2,16
 5c6:	000b2583          	lw	a1,0(s6)
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e56080e7          	jalr	-426(ra) # 422 <printint>
 5d4:	8b4a                	mv	s6,s2
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bf91                	j	52c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5da:	008b0793          	addi	a5,s6,8
 5de:	f8f43423          	sd	a5,-120(s0)
 5e2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5e6:	03000593          	li	a1,48
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e14080e7          	jalr	-492(ra) # 400 <putc>
  putc(fd, 'x');
 5f4:	85ea                	mv	a1,s10
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e08080e7          	jalr	-504(ra) # 400 <putc>
 600:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 602:	03c9d793          	srli	a5,s3,0x3c
 606:	97de                	add	a5,a5,s7
 608:	0007c583          	lbu	a1,0(a5)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	df2080e7          	jalr	-526(ra) # 400 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 616:	0992                	slli	s3,s3,0x4
 618:	397d                	addiw	s2,s2,-1
 61a:	fe0914e3          	bnez	s2,602 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 61e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 622:	4981                	li	s3,0
 624:	b721                	j	52c <vprintf+0x60>
        s = va_arg(ap, char*);
 626:	008b0993          	addi	s3,s6,8
 62a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 62e:	02090163          	beqz	s2,650 <vprintf+0x184>
        while(*s != 0){
 632:	00094583          	lbu	a1,0(s2)
 636:	c9a1                	beqz	a1,686 <vprintf+0x1ba>
          putc(fd, *s);
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	dc6080e7          	jalr	-570(ra) # 400 <putc>
          s++;
 642:	0905                	addi	s2,s2,1
        while(*s != 0){
 644:	00094583          	lbu	a1,0(s2)
 648:	f9e5                	bnez	a1,638 <vprintf+0x16c>
        s = va_arg(ap, char*);
 64a:	8b4e                	mv	s6,s3
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bdf9                	j	52c <vprintf+0x60>
          s = "(null)";
 650:	00000917          	auipc	s2,0x0
 654:	23090913          	addi	s2,s2,560 # 880 <malloc+0xea>
        while(*s != 0){
 658:	02800593          	li	a1,40
 65c:	bff1                	j	638 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 65e:	008b0913          	addi	s2,s6,8
 662:	000b4583          	lbu	a1,0(s6)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	d98080e7          	jalr	-616(ra) # 400 <putc>
 670:	8b4a                	mv	s6,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	bd65                	j	52c <vprintf+0x60>
        putc(fd, c);
 676:	85d2                	mv	a1,s4
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	d86080e7          	jalr	-634(ra) # 400 <putc>
      state = 0;
 682:	4981                	li	s3,0
 684:	b565                	j	52c <vprintf+0x60>
        s = va_arg(ap, char*);
 686:	8b4e                	mv	s6,s3
      state = 0;
 688:	4981                	li	s3,0
 68a:	b54d                	j	52c <vprintf+0x60>
    }
  }
}
 68c:	70e6                	ld	ra,120(sp)
 68e:	7446                	ld	s0,112(sp)
 690:	74a6                	ld	s1,104(sp)
 692:	7906                	ld	s2,96(sp)
 694:	69e6                	ld	s3,88(sp)
 696:	6a46                	ld	s4,80(sp)
 698:	6aa6                	ld	s5,72(sp)
 69a:	6b06                	ld	s6,64(sp)
 69c:	7be2                	ld	s7,56(sp)
 69e:	7c42                	ld	s8,48(sp)
 6a0:	7ca2                	ld	s9,40(sp)
 6a2:	7d02                	ld	s10,32(sp)
 6a4:	6de2                	ld	s11,24(sp)
 6a6:	6109                	addi	sp,sp,128
 6a8:	8082                	ret

00000000000006aa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6aa:	715d                	addi	sp,sp,-80
 6ac:	ec06                	sd	ra,24(sp)
 6ae:	e822                	sd	s0,16(sp)
 6b0:	1000                	addi	s0,sp,32
 6b2:	e010                	sd	a2,0(s0)
 6b4:	e414                	sd	a3,8(s0)
 6b6:	e818                	sd	a4,16(s0)
 6b8:	ec1c                	sd	a5,24(s0)
 6ba:	03043023          	sd	a6,32(s0)
 6be:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c6:	8622                	mv	a2,s0
 6c8:	00000097          	auipc	ra,0x0
 6cc:	e04080e7          	jalr	-508(ra) # 4cc <vprintf>
}
 6d0:	60e2                	ld	ra,24(sp)
 6d2:	6442                	ld	s0,16(sp)
 6d4:	6161                	addi	sp,sp,80
 6d6:	8082                	ret

00000000000006d8 <printf>:

void
printf(const char *fmt, ...)
{
 6d8:	711d                	addi	sp,sp,-96
 6da:	ec06                	sd	ra,24(sp)
 6dc:	e822                	sd	s0,16(sp)
 6de:	1000                	addi	s0,sp,32
 6e0:	e40c                	sd	a1,8(s0)
 6e2:	e810                	sd	a2,16(s0)
 6e4:	ec14                	sd	a3,24(s0)
 6e6:	f018                	sd	a4,32(s0)
 6e8:	f41c                	sd	a5,40(s0)
 6ea:	03043823          	sd	a6,48(s0)
 6ee:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f2:	00840613          	addi	a2,s0,8
 6f6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fa:	85aa                	mv	a1,a0
 6fc:	4505                	li	a0,1
 6fe:	00000097          	auipc	ra,0x0
 702:	dce080e7          	jalr	-562(ra) # 4cc <vprintf>
}
 706:	60e2                	ld	ra,24(sp)
 708:	6442                	ld	s0,16(sp)
 70a:	6125                	addi	sp,sp,96
 70c:	8082                	ret

000000000000070e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70e:	1141                	addi	sp,sp,-16
 710:	e422                	sd	s0,8(sp)
 712:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 714:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 718:	00000797          	auipc	a5,0x0
 71c:	1887b783          	ld	a5,392(a5) # 8a0 <freep>
 720:	a805                	j	750 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 722:	4618                	lw	a4,8(a2)
 724:	9db9                	addw	a1,a1,a4
 726:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 72a:	6398                	ld	a4,0(a5)
 72c:	6318                	ld	a4,0(a4)
 72e:	fee53823          	sd	a4,-16(a0)
 732:	a091                	j	776 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 734:	ff852703          	lw	a4,-8(a0)
 738:	9e39                	addw	a2,a2,a4
 73a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 73c:	ff053703          	ld	a4,-16(a0)
 740:	e398                	sd	a4,0(a5)
 742:	a099                	j	788 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	6398                	ld	a4,0(a5)
 746:	00e7e463          	bltu	a5,a4,74e <free+0x40>
 74a:	00e6ea63          	bltu	a3,a4,75e <free+0x50>
{
 74e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 750:	fed7fae3          	bgeu	a5,a3,744 <free+0x36>
 754:	6398                	ld	a4,0(a5)
 756:	00e6e463          	bltu	a3,a4,75e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75a:	fee7eae3          	bltu	a5,a4,74e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 75e:	ff852583          	lw	a1,-8(a0)
 762:	6390                	ld	a2,0(a5)
 764:	02059713          	slli	a4,a1,0x20
 768:	9301                	srli	a4,a4,0x20
 76a:	0712                	slli	a4,a4,0x4
 76c:	9736                	add	a4,a4,a3
 76e:	fae60ae3          	beq	a2,a4,722 <free+0x14>
    bp->s.ptr = p->s.ptr;
 772:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 776:	4790                	lw	a2,8(a5)
 778:	02061713          	slli	a4,a2,0x20
 77c:	9301                	srli	a4,a4,0x20
 77e:	0712                	slli	a4,a4,0x4
 780:	973e                	add	a4,a4,a5
 782:	fae689e3          	beq	a3,a4,734 <free+0x26>
  } else
    p->s.ptr = bp;
 786:	e394                	sd	a3,0(a5)
  freep = p;
 788:	00000717          	auipc	a4,0x0
 78c:	10f73c23          	sd	a5,280(a4) # 8a0 <freep>
}
 790:	6422                	ld	s0,8(sp)
 792:	0141                	addi	sp,sp,16
 794:	8082                	ret

0000000000000796 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 796:	7139                	addi	sp,sp,-64
 798:	fc06                	sd	ra,56(sp)
 79a:	f822                	sd	s0,48(sp)
 79c:	f426                	sd	s1,40(sp)
 79e:	f04a                	sd	s2,32(sp)
 7a0:	ec4e                	sd	s3,24(sp)
 7a2:	e852                	sd	s4,16(sp)
 7a4:	e456                	sd	s5,8(sp)
 7a6:	e05a                	sd	s6,0(sp)
 7a8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7aa:	02051493          	slli	s1,a0,0x20
 7ae:	9081                	srli	s1,s1,0x20
 7b0:	04bd                	addi	s1,s1,15
 7b2:	8091                	srli	s1,s1,0x4
 7b4:	0014899b          	addiw	s3,s1,1
 7b8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ba:	00000517          	auipc	a0,0x0
 7be:	0e653503          	ld	a0,230(a0) # 8a0 <freep>
 7c2:	c515                	beqz	a0,7ee <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c6:	4798                	lw	a4,8(a5)
 7c8:	02977f63          	bgeu	a4,s1,806 <malloc+0x70>
 7cc:	8a4e                	mv	s4,s3
 7ce:	0009871b          	sext.w	a4,s3
 7d2:	6685                	lui	a3,0x1
 7d4:	00d77363          	bgeu	a4,a3,7da <malloc+0x44>
 7d8:	6a05                	lui	s4,0x1
 7da:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7de:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e2:	00000917          	auipc	s2,0x0
 7e6:	0be90913          	addi	s2,s2,190 # 8a0 <freep>
  if(p == (char*)-1)
 7ea:	5afd                	li	s5,-1
 7ec:	a88d                	j	85e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7ee:	00000797          	auipc	a5,0x0
 7f2:	0ba78793          	addi	a5,a5,186 # 8a8 <base>
 7f6:	00000717          	auipc	a4,0x0
 7fa:	0af73523          	sd	a5,170(a4) # 8a0 <freep>
 7fe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 800:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 804:	b7e1                	j	7cc <malloc+0x36>
      if(p->s.size == nunits)
 806:	02e48b63          	beq	s1,a4,83c <malloc+0xa6>
        p->s.size -= nunits;
 80a:	4137073b          	subw	a4,a4,s3
 80e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 810:	1702                	slli	a4,a4,0x20
 812:	9301                	srli	a4,a4,0x20
 814:	0712                	slli	a4,a4,0x4
 816:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 818:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 81c:	00000717          	auipc	a4,0x0
 820:	08a73223          	sd	a0,132(a4) # 8a0 <freep>
      return (void*)(p + 1);
 824:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 828:	70e2                	ld	ra,56(sp)
 82a:	7442                	ld	s0,48(sp)
 82c:	74a2                	ld	s1,40(sp)
 82e:	7902                	ld	s2,32(sp)
 830:	69e2                	ld	s3,24(sp)
 832:	6a42                	ld	s4,16(sp)
 834:	6aa2                	ld	s5,8(sp)
 836:	6b02                	ld	s6,0(sp)
 838:	6121                	addi	sp,sp,64
 83a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 83c:	6398                	ld	a4,0(a5)
 83e:	e118                	sd	a4,0(a0)
 840:	bff1                	j	81c <malloc+0x86>
  hp->s.size = nu;
 842:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 846:	0541                	addi	a0,a0,16
 848:	00000097          	auipc	ra,0x0
 84c:	ec6080e7          	jalr	-314(ra) # 70e <free>
  return freep;
 850:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 854:	d971                	beqz	a0,828 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 856:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 858:	4798                	lw	a4,8(a5)
 85a:	fa9776e3          	bgeu	a4,s1,806 <malloc+0x70>
    if(p == freep)
 85e:	00093703          	ld	a4,0(s2)
 862:	853e                	mv	a0,a5
 864:	fef719e3          	bne	a4,a5,856 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 868:	8552                	mv	a0,s4
 86a:	00000097          	auipc	ra,0x0
 86e:	b7e080e7          	jalr	-1154(ra) # 3e8 <sbrk>
  if(p == (char*)-1)
 872:	fd5518e3          	bne	a0,s5,842 <malloc+0xac>
        return 0;
 876:	4501                	li	a0,0
 878:	bf45                	j	828 <malloc+0x92>
