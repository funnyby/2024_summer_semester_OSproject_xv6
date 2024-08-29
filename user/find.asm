
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path , char *target)
{
   0:	d8010113          	addi	sp,sp,-640
   4:	26113c23          	sd	ra,632(sp)
   8:	26813823          	sd	s0,624(sp)
   c:	26913423          	sd	s1,616(sp)
  10:	27213023          	sd	s2,608(sp)
  14:	25313c23          	sd	s3,600(sp)
  18:	25413823          	sd	s4,592(sp)
  1c:	25513423          	sd	s5,584(sp)
  20:	25613023          	sd	s6,576(sp)
  24:	23713c23          	sd	s7,568(sp)
  28:	0500                	addi	s0,sp,640
  2a:	892a                	mv	s2,a0
  2c:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if((fd = open(path, 0)) < 0){
  2e:	4581                	li	a1,0
  30:	00000097          	auipc	ra,0x0
  34:	4d0080e7          	jalr	1232(ra) # 500 <open>
  38:	08054963          	bltz	a0,ca <find+0xca>
  3c:	84aa                	mv	s1,a0
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
  3e:	d8840593          	addi	a1,s0,-632
  42:	00000097          	auipc	ra,0x0
  46:	4d6080e7          	jalr	1238(ra) # 518 <fstat>
  4a:	08054b63          	bltz	a0,e0 <find+0xe0>
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch(st.type)
  4e:	d9041783          	lh	a5,-624(s0)
  52:	0007869b          	sext.w	a3,a5
  56:	4705                	li	a4,1
  58:	0ae68e63          	beq	a3,a4,114 <find+0x114>
  5c:	4709                	li	a4,2
  5e:	02e69c63          	bne	a3,a4,96 <find+0x96>
    {
        case T_FILE:
            if(strcmp( path + strlen(path) - strlen(target) , target ) ==0)
  62:	854a                	mv	a0,s2
  64:	00000097          	auipc	ra,0x0
  68:	22e080e7          	jalr	558(ra) # 292 <strlen>
  6c:	00050a1b          	sext.w	s4,a0
  70:	854e                	mv	a0,s3
  72:	00000097          	auipc	ra,0x0
  76:	220080e7          	jalr	544(ra) # 292 <strlen>
  7a:	1a02                	slli	s4,s4,0x20
  7c:	020a5a13          	srli	s4,s4,0x20
  80:	1502                	slli	a0,a0,0x20
  82:	9101                	srli	a0,a0,0x20
  84:	40aa0533          	sub	a0,s4,a0
  88:	85ce                	mv	a1,s3
  8a:	954a                	add	a0,a0,s2
  8c:	00000097          	auipc	ra,0x0
  90:	1da080e7          	jalr	474(ra) # 266 <strcmp>
  94:	c535                	beqz	a0,100 <find+0x100>
                    find(buf, target);
                }
            }
            break;
  }
  close(fd);
  96:	8526                	mv	a0,s1
  98:	00000097          	auipc	ra,0x0
  9c:	450080e7          	jalr	1104(ra) # 4e8 <close>

}
  a0:	27813083          	ld	ra,632(sp)
  a4:	27013403          	ld	s0,624(sp)
  a8:	26813483          	ld	s1,616(sp)
  ac:	26013903          	ld	s2,608(sp)
  b0:	25813983          	ld	s3,600(sp)
  b4:	25013a03          	ld	s4,592(sp)
  b8:	24813a83          	ld	s5,584(sp)
  bc:	24013b03          	ld	s6,576(sp)
  c0:	23813b83          	ld	s7,568(sp)
  c4:	28010113          	addi	sp,sp,640
  c8:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);
  ca:	864a                	mv	a2,s2
  cc:	00001597          	auipc	a1,0x1
  d0:	91458593          	addi	a1,a1,-1772 # 9e0 <malloc+0xea>
  d4:	4509                	li	a0,2
  d6:	00000097          	auipc	ra,0x0
  da:	734080e7          	jalr	1844(ra) # 80a <fprintf>
        return;
  de:	b7c9                	j	a0 <find+0xa0>
        fprintf(2, "find: cannot stat %s\n", path);
  e0:	864a                	mv	a2,s2
  e2:	00001597          	auipc	a1,0x1
  e6:	91658593          	addi	a1,a1,-1770 # 9f8 <malloc+0x102>
  ea:	4509                	li	a0,2
  ec:	00000097          	auipc	ra,0x0
  f0:	71e080e7          	jalr	1822(ra) # 80a <fprintf>
        close(fd);
  f4:	8526                	mv	a0,s1
  f6:	00000097          	auipc	ra,0x0
  fa:	3f2080e7          	jalr	1010(ra) # 4e8 <close>
        return;
  fe:	b74d                	j	a0 <find+0xa0>
                 printf("%s\n", path);
 100:	85ca                	mv	a1,s2
 102:	00001517          	auipc	a0,0x1
 106:	90e50513          	addi	a0,a0,-1778 # a10 <malloc+0x11a>
 10a:	00000097          	auipc	ra,0x0
 10e:	72e080e7          	jalr	1838(ra) # 838 <printf>
 112:	b751                	j	96 <find+0x96>
            if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 114:	854a                	mv	a0,s2
 116:	00000097          	auipc	ra,0x0
 11a:	17c080e7          	jalr	380(ra) # 292 <strlen>
 11e:	2541                	addiw	a0,a0,16
 120:	20000793          	li	a5,512
 124:	00a7fb63          	bgeu	a5,a0,13a <find+0x13a>
                printf("find: path too long\n");
 128:	00001517          	auipc	a0,0x1
 12c:	8f050513          	addi	a0,a0,-1808 # a18 <malloc+0x122>
 130:	00000097          	auipc	ra,0x0
 134:	708080e7          	jalr	1800(ra) # 838 <printf>
                break;
 138:	bfb9                	j	96 <find+0x96>
            strcpy(buf, path);
 13a:	85ca                	mv	a1,s2
 13c:	db040513          	addi	a0,s0,-592
 140:	00000097          	auipc	ra,0x0
 144:	10a080e7          	jalr	266(ra) # 24a <strcpy>
            p = buf+strlen(buf);
 148:	db040513          	addi	a0,s0,-592
 14c:	00000097          	auipc	ra,0x0
 150:	146080e7          	jalr	326(ra) # 292 <strlen>
 154:	02051913          	slli	s2,a0,0x20
 158:	02095913          	srli	s2,s2,0x20
 15c:	db040793          	addi	a5,s0,-592
 160:	993e                	add	s2,s2,a5
            *p++ = '/';
 162:	00190a13          	addi	s4,s2,1
 166:	02f00793          	li	a5,47
 16a:	00f90023          	sb	a5,0(s2)
                if(strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0)
 16e:	00001a97          	auipc	s5,0x1
 172:	8c2a8a93          	addi	s5,s5,-1854 # a30 <malloc+0x13a>
 176:	00001b97          	auipc	s7,0x1
 17a:	8c2b8b93          	addi	s7,s7,-1854 # a38 <malloc+0x142>
                    printf("find: cannot stat %s\n", buf);
 17e:	00001b17          	auipc	s6,0x1
 182:	87ab0b13          	addi	s6,s6,-1926 # 9f8 <malloc+0x102>
            while(read(fd, &de, sizeof(de)) == sizeof(de))
 186:	4641                	li	a2,16
 188:	da040593          	addi	a1,s0,-608
 18c:	8526                	mv	a0,s1
 18e:	00000097          	auipc	ra,0x0
 192:	34a080e7          	jalr	842(ra) # 4d8 <read>
 196:	47c1                	li	a5,16
 198:	eef51fe3          	bne	a0,a5,96 <find+0x96>
                if(de.inum == 0)
 19c:	da045783          	lhu	a5,-608(s0)
 1a0:	d3fd                	beqz	a5,186 <find+0x186>
                memmove(p, de.name, DIRSIZ);
 1a2:	4639                	li	a2,14
 1a4:	da240593          	addi	a1,s0,-606
 1a8:	8552                	mv	a0,s4
 1aa:	00000097          	auipc	ra,0x0
 1ae:	260080e7          	jalr	608(ra) # 40a <memmove>
                p[DIRSIZ] = 0;
 1b2:	000907a3          	sb	zero,15(s2)
                if(stat(buf, &st) < 0)
 1b6:	d8840593          	addi	a1,s0,-632
 1ba:	db040513          	addi	a0,s0,-592
 1be:	00000097          	auipc	ra,0x0
 1c2:	1bc080e7          	jalr	444(ra) # 37a <stat>
 1c6:	02054a63          	bltz	a0,1fa <find+0x1fa>
                if(strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0)
 1ca:	da240593          	addi	a1,s0,-606
 1ce:	8556                	mv	a0,s5
 1d0:	00000097          	auipc	ra,0x0
 1d4:	096080e7          	jalr	150(ra) # 266 <strcmp>
 1d8:	d55d                	beqz	a0,186 <find+0x186>
 1da:	da240593          	addi	a1,s0,-606
 1de:	855e                	mv	a0,s7
 1e0:	00000097          	auipc	ra,0x0
 1e4:	086080e7          	jalr	134(ra) # 266 <strcmp>
 1e8:	dd59                	beqz	a0,186 <find+0x186>
                    find(buf, target);
 1ea:	85ce                	mv	a1,s3
 1ec:	db040513          	addi	a0,s0,-592
 1f0:	00000097          	auipc	ra,0x0
 1f4:	e10080e7          	jalr	-496(ra) # 0 <find>
 1f8:	b779                	j	186 <find+0x186>
                    printf("find: cannot stat %s\n", buf);
 1fa:	db040593          	addi	a1,s0,-592
 1fe:	855a                	mv	a0,s6
 200:	00000097          	auipc	ra,0x0
 204:	638080e7          	jalr	1592(ra) # 838 <printf>
                    continue;
 208:	bfbd                	j	186 <find+0x186>

000000000000020a <main>:


int main(int argc, char *argv[])
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e406                	sd	ra,8(sp)
 20e:	e022                	sd	s0,0(sp)
 210:	0800                	addi	s0,sp,16
    if(argc != 3)
 212:	470d                	li	a4,3
 214:	00e50f63          	beq	a0,a4,232 <main+0x28>
    {
        printf("input arguments : find <path> <file name>\n");
 218:	00001517          	auipc	a0,0x1
 21c:	82850513          	addi	a0,a0,-2008 # a40 <malloc+0x14a>
 220:	00000097          	auipc	ra,0x0
 224:	618080e7          	jalr	1560(ra) # 838 <printf>
        exit(1);
 228:	4505                	li	a0,1
 22a:	00000097          	auipc	ra,0x0
 22e:	296080e7          	jalr	662(ra) # 4c0 <exit>
 232:	87ae                	mv	a5,a1
    }
   
    find(argv[1], argv[2]);
 234:	698c                	ld	a1,16(a1)
 236:	6788                	ld	a0,8(a5)
 238:	00000097          	auipc	ra,0x0
 23c:	dc8080e7          	jalr	-568(ra) # 0 <find>
    exit(0);
 240:	4501                	li	a0,0
 242:	00000097          	auipc	ra,0x0
 246:	27e080e7          	jalr	638(ra) # 4c0 <exit>

000000000000024a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 250:	87aa                	mv	a5,a0
 252:	0585                	addi	a1,a1,1
 254:	0785                	addi	a5,a5,1
 256:	fff5c703          	lbu	a4,-1(a1)
 25a:	fee78fa3          	sb	a4,-1(a5)
 25e:	fb75                	bnez	a4,252 <strcpy+0x8>
    ;
  return os;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret

0000000000000266 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 26c:	00054783          	lbu	a5,0(a0)
 270:	cb91                	beqz	a5,284 <strcmp+0x1e>
 272:	0005c703          	lbu	a4,0(a1)
 276:	00f71763          	bne	a4,a5,284 <strcmp+0x1e>
    p++, q++;
 27a:	0505                	addi	a0,a0,1
 27c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 27e:	00054783          	lbu	a5,0(a0)
 282:	fbe5                	bnez	a5,272 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 284:	0005c503          	lbu	a0,0(a1)
}
 288:	40a7853b          	subw	a0,a5,a0
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strlen>:

uint
strlen(const char *s)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 298:	00054783          	lbu	a5,0(a0)
 29c:	cf91                	beqz	a5,2b8 <strlen+0x26>
 29e:	0505                	addi	a0,a0,1
 2a0:	87aa                	mv	a5,a0
 2a2:	4685                	li	a3,1
 2a4:	9e89                	subw	a3,a3,a0
 2a6:	00f6853b          	addw	a0,a3,a5
 2aa:	0785                	addi	a5,a5,1
 2ac:	fff7c703          	lbu	a4,-1(a5)
 2b0:	fb7d                	bnez	a4,2a6 <strlen+0x14>
    ;
  return n;
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  for(n = 0; s[n]; n++)
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <strlen+0x20>

00000000000002bc <memset>:

void*
memset(void *dst, int c, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2c2:	ce09                	beqz	a2,2dc <memset+0x20>
 2c4:	87aa                	mv	a5,a0
 2c6:	fff6071b          	addiw	a4,a2,-1
 2ca:	1702                	slli	a4,a4,0x20
 2cc:	9301                	srli	a4,a4,0x20
 2ce:	0705                	addi	a4,a4,1
 2d0:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2d6:	0785                	addi	a5,a5,1
 2d8:	fee79de3          	bne	a5,a4,2d2 <memset+0x16>
  }
  return dst;
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <strchr>:

char*
strchr(const char *s, char c)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2e8:	00054783          	lbu	a5,0(a0)
 2ec:	cb99                	beqz	a5,302 <strchr+0x20>
    if(*s == c)
 2ee:	00f58763          	beq	a1,a5,2fc <strchr+0x1a>
  for(; *s; s++)
 2f2:	0505                	addi	a0,a0,1
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	fbfd                	bnez	a5,2ee <strchr+0xc>
      return (char*)s;
  return 0;
 2fa:	4501                	li	a0,0
}
 2fc:	6422                	ld	s0,8(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
  return 0;
 302:	4501                	li	a0,0
 304:	bfe5                	j	2fc <strchr+0x1a>

0000000000000306 <gets>:

char*
gets(char *buf, int max)
{
 306:	711d                	addi	sp,sp,-96
 308:	ec86                	sd	ra,88(sp)
 30a:	e8a2                	sd	s0,80(sp)
 30c:	e4a6                	sd	s1,72(sp)
 30e:	e0ca                	sd	s2,64(sp)
 310:	fc4e                	sd	s3,56(sp)
 312:	f852                	sd	s4,48(sp)
 314:	f456                	sd	s5,40(sp)
 316:	f05a                	sd	s6,32(sp)
 318:	ec5e                	sd	s7,24(sp)
 31a:	1080                	addi	s0,sp,96
 31c:	8baa                	mv	s7,a0
 31e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 320:	892a                	mv	s2,a0
 322:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 324:	4aa9                	li	s5,10
 326:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 328:	89a6                	mv	s3,s1
 32a:	2485                	addiw	s1,s1,1
 32c:	0344d863          	bge	s1,s4,35c <gets+0x56>
    cc = read(0, &c, 1);
 330:	4605                	li	a2,1
 332:	faf40593          	addi	a1,s0,-81
 336:	4501                	li	a0,0
 338:	00000097          	auipc	ra,0x0
 33c:	1a0080e7          	jalr	416(ra) # 4d8 <read>
    if(cc < 1)
 340:	00a05e63          	blez	a0,35c <gets+0x56>
    buf[i++] = c;
 344:	faf44783          	lbu	a5,-81(s0)
 348:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 34c:	01578763          	beq	a5,s5,35a <gets+0x54>
 350:	0905                	addi	s2,s2,1
 352:	fd679be3          	bne	a5,s6,328 <gets+0x22>
  for(i=0; i+1 < max; ){
 356:	89a6                	mv	s3,s1
 358:	a011                	j	35c <gets+0x56>
 35a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 35c:	99de                	add	s3,s3,s7
 35e:	00098023          	sb	zero,0(s3)
  return buf;
}
 362:	855e                	mv	a0,s7
 364:	60e6                	ld	ra,88(sp)
 366:	6446                	ld	s0,80(sp)
 368:	64a6                	ld	s1,72(sp)
 36a:	6906                	ld	s2,64(sp)
 36c:	79e2                	ld	s3,56(sp)
 36e:	7a42                	ld	s4,48(sp)
 370:	7aa2                	ld	s5,40(sp)
 372:	7b02                	ld	s6,32(sp)
 374:	6be2                	ld	s7,24(sp)
 376:	6125                	addi	sp,sp,96
 378:	8082                	ret

000000000000037a <stat>:

int
stat(const char *n, struct stat *st)
{
 37a:	1101                	addi	sp,sp,-32
 37c:	ec06                	sd	ra,24(sp)
 37e:	e822                	sd	s0,16(sp)
 380:	e426                	sd	s1,8(sp)
 382:	e04a                	sd	s2,0(sp)
 384:	1000                	addi	s0,sp,32
 386:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 388:	4581                	li	a1,0
 38a:	00000097          	auipc	ra,0x0
 38e:	176080e7          	jalr	374(ra) # 500 <open>
  if(fd < 0)
 392:	02054563          	bltz	a0,3bc <stat+0x42>
 396:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 398:	85ca                	mv	a1,s2
 39a:	00000097          	auipc	ra,0x0
 39e:	17e080e7          	jalr	382(ra) # 518 <fstat>
 3a2:	892a                	mv	s2,a0
  close(fd);
 3a4:	8526                	mv	a0,s1
 3a6:	00000097          	auipc	ra,0x0
 3aa:	142080e7          	jalr	322(ra) # 4e8 <close>
  return r;
}
 3ae:	854a                	mv	a0,s2
 3b0:	60e2                	ld	ra,24(sp)
 3b2:	6442                	ld	s0,16(sp)
 3b4:	64a2                	ld	s1,8(sp)
 3b6:	6902                	ld	s2,0(sp)
 3b8:	6105                	addi	sp,sp,32
 3ba:	8082                	ret
    return -1;
 3bc:	597d                	li	s2,-1
 3be:	bfc5                	j	3ae <stat+0x34>

00000000000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e422                	sd	s0,8(sp)
 3c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c6:	00054603          	lbu	a2,0(a0)
 3ca:	fd06079b          	addiw	a5,a2,-48
 3ce:	0ff7f793          	andi	a5,a5,255
 3d2:	4725                	li	a4,9
 3d4:	02f76963          	bltu	a4,a5,406 <atoi+0x46>
 3d8:	86aa                	mv	a3,a0
  n = 0;
 3da:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3dc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3de:	0685                	addi	a3,a3,1
 3e0:	0025179b          	slliw	a5,a0,0x2
 3e4:	9fa9                	addw	a5,a5,a0
 3e6:	0017979b          	slliw	a5,a5,0x1
 3ea:	9fb1                	addw	a5,a5,a2
 3ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3f0:	0006c603          	lbu	a2,0(a3)
 3f4:	fd06071b          	addiw	a4,a2,-48
 3f8:	0ff77713          	andi	a4,a4,255
 3fc:	fee5f1e3          	bgeu	a1,a4,3de <atoi+0x1e>
  return n;
}
 400:	6422                	ld	s0,8(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret
  n = 0;
 406:	4501                	li	a0,0
 408:	bfe5                	j	400 <atoi+0x40>

000000000000040a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 40a:	1141                	addi	sp,sp,-16
 40c:	e422                	sd	s0,8(sp)
 40e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 410:	02b57663          	bgeu	a0,a1,43c <memmove+0x32>
    while(n-- > 0)
 414:	02c05163          	blez	a2,436 <memmove+0x2c>
 418:	fff6079b          	addiw	a5,a2,-1
 41c:	1782                	slli	a5,a5,0x20
 41e:	9381                	srli	a5,a5,0x20
 420:	0785                	addi	a5,a5,1
 422:	97aa                	add	a5,a5,a0
  dst = vdst;
 424:	872a                	mv	a4,a0
      *dst++ = *src++;
 426:	0585                	addi	a1,a1,1
 428:	0705                	addi	a4,a4,1
 42a:	fff5c683          	lbu	a3,-1(a1)
 42e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 432:	fee79ae3          	bne	a5,a4,426 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 436:	6422                	ld	s0,8(sp)
 438:	0141                	addi	sp,sp,16
 43a:	8082                	ret
    dst += n;
 43c:	00c50733          	add	a4,a0,a2
    src += n;
 440:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 442:	fec05ae3          	blez	a2,436 <memmove+0x2c>
 446:	fff6079b          	addiw	a5,a2,-1
 44a:	1782                	slli	a5,a5,0x20
 44c:	9381                	srli	a5,a5,0x20
 44e:	fff7c793          	not	a5,a5
 452:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 454:	15fd                	addi	a1,a1,-1
 456:	177d                	addi	a4,a4,-1
 458:	0005c683          	lbu	a3,0(a1)
 45c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 460:	fee79ae3          	bne	a5,a4,454 <memmove+0x4a>
 464:	bfc9                	j	436 <memmove+0x2c>

0000000000000466 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 466:	1141                	addi	sp,sp,-16
 468:	e422                	sd	s0,8(sp)
 46a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 46c:	ca05                	beqz	a2,49c <memcmp+0x36>
 46e:	fff6069b          	addiw	a3,a2,-1
 472:	1682                	slli	a3,a3,0x20
 474:	9281                	srli	a3,a3,0x20
 476:	0685                	addi	a3,a3,1
 478:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 47a:	00054783          	lbu	a5,0(a0)
 47e:	0005c703          	lbu	a4,0(a1)
 482:	00e79863          	bne	a5,a4,492 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 486:	0505                	addi	a0,a0,1
    p2++;
 488:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 48a:	fed518e3          	bne	a0,a3,47a <memcmp+0x14>
  }
  return 0;
 48e:	4501                	li	a0,0
 490:	a019                	j	496 <memcmp+0x30>
      return *p1 - *p2;
 492:	40e7853b          	subw	a0,a5,a4
}
 496:	6422                	ld	s0,8(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret
  return 0;
 49c:	4501                	li	a0,0
 49e:	bfe5                	j	496 <memcmp+0x30>

00000000000004a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a0:	1141                	addi	sp,sp,-16
 4a2:	e406                	sd	ra,8(sp)
 4a4:	e022                	sd	s0,0(sp)
 4a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a8:	00000097          	auipc	ra,0x0
 4ac:	f62080e7          	jalr	-158(ra) # 40a <memmove>
}
 4b0:	60a2                	ld	ra,8(sp)
 4b2:	6402                	ld	s0,0(sp)
 4b4:	0141                	addi	sp,sp,16
 4b6:	8082                	ret

00000000000004b8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b8:	4885                	li	a7,1
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4c0:	4889                	li	a7,2
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c8:	488d                	li	a7,3
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4d0:	4891                	li	a7,4
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <read>:
.global read
read:
 li a7, SYS_read
 4d8:	4895                	li	a7,5
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <write>:
.global write
write:
 li a7, SYS_write
 4e0:	48c1                	li	a7,16
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <close>:
.global close
close:
 li a7, SYS_close
 4e8:	48d5                	li	a7,21
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4f0:	4899                	li	a7,6
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f8:	489d                	li	a7,7
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <open>:
.global open
open:
 li a7, SYS_open
 500:	48bd                	li	a7,15
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 508:	48c5                	li	a7,17
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 510:	48c9                	li	a7,18
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 518:	48a1                	li	a7,8
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <link>:
.global link
link:
 li a7, SYS_link
 520:	48cd                	li	a7,19
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 528:	48d1                	li	a7,20
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 530:	48a5                	li	a7,9
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <dup>:
.global dup
dup:
 li a7, SYS_dup
 538:	48a9                	li	a7,10
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 540:	48ad                	li	a7,11
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 548:	48b1                	li	a7,12
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 550:	48b5                	li	a7,13
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 558:	48b9                	li	a7,14
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 560:	1101                	addi	sp,sp,-32
 562:	ec06                	sd	ra,24(sp)
 564:	e822                	sd	s0,16(sp)
 566:	1000                	addi	s0,sp,32
 568:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 56c:	4605                	li	a2,1
 56e:	fef40593          	addi	a1,s0,-17
 572:	00000097          	auipc	ra,0x0
 576:	f6e080e7          	jalr	-146(ra) # 4e0 <write>
}
 57a:	60e2                	ld	ra,24(sp)
 57c:	6442                	ld	s0,16(sp)
 57e:	6105                	addi	sp,sp,32
 580:	8082                	ret

0000000000000582 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 582:	7139                	addi	sp,sp,-64
 584:	fc06                	sd	ra,56(sp)
 586:	f822                	sd	s0,48(sp)
 588:	f426                	sd	s1,40(sp)
 58a:	f04a                	sd	s2,32(sp)
 58c:	ec4e                	sd	s3,24(sp)
 58e:	0080                	addi	s0,sp,64
 590:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 592:	c299                	beqz	a3,598 <printint+0x16>
 594:	0805c863          	bltz	a1,624 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 598:	2581                	sext.w	a1,a1
  neg = 0;
 59a:	4881                	li	a7,0
 59c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5a2:	2601                	sext.w	a2,a2
 5a4:	00000517          	auipc	a0,0x0
 5a8:	4d450513          	addi	a0,a0,1236 # a78 <digits>
 5ac:	883a                	mv	a6,a4
 5ae:	2705                	addiw	a4,a4,1
 5b0:	02c5f7bb          	remuw	a5,a1,a2
 5b4:	1782                	slli	a5,a5,0x20
 5b6:	9381                	srli	a5,a5,0x20
 5b8:	97aa                	add	a5,a5,a0
 5ba:	0007c783          	lbu	a5,0(a5)
 5be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c2:	0005879b          	sext.w	a5,a1
 5c6:	02c5d5bb          	divuw	a1,a1,a2
 5ca:	0685                	addi	a3,a3,1
 5cc:	fec7f0e3          	bgeu	a5,a2,5ac <printint+0x2a>
  if(neg)
 5d0:	00088b63          	beqz	a7,5e6 <printint+0x64>
    buf[i++] = '-';
 5d4:	fd040793          	addi	a5,s0,-48
 5d8:	973e                	add	a4,a4,a5
 5da:	02d00793          	li	a5,45
 5de:	fef70823          	sb	a5,-16(a4)
 5e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e6:	02e05863          	blez	a4,616 <printint+0x94>
 5ea:	fc040793          	addi	a5,s0,-64
 5ee:	00e78933          	add	s2,a5,a4
 5f2:	fff78993          	addi	s3,a5,-1
 5f6:	99ba                	add	s3,s3,a4
 5f8:	377d                	addiw	a4,a4,-1
 5fa:	1702                	slli	a4,a4,0x20
 5fc:	9301                	srli	a4,a4,0x20
 5fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 602:	fff94583          	lbu	a1,-1(s2)
 606:	8526                	mv	a0,s1
 608:	00000097          	auipc	ra,0x0
 60c:	f58080e7          	jalr	-168(ra) # 560 <putc>
  while(--i >= 0)
 610:	197d                	addi	s2,s2,-1
 612:	ff3918e3          	bne	s2,s3,602 <printint+0x80>
}
 616:	70e2                	ld	ra,56(sp)
 618:	7442                	ld	s0,48(sp)
 61a:	74a2                	ld	s1,40(sp)
 61c:	7902                	ld	s2,32(sp)
 61e:	69e2                	ld	s3,24(sp)
 620:	6121                	addi	sp,sp,64
 622:	8082                	ret
    x = -xx;
 624:	40b005bb          	negw	a1,a1
    neg = 1;
 628:	4885                	li	a7,1
    x = -xx;
 62a:	bf8d                	j	59c <printint+0x1a>

000000000000062c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 62c:	7119                	addi	sp,sp,-128
 62e:	fc86                	sd	ra,120(sp)
 630:	f8a2                	sd	s0,112(sp)
 632:	f4a6                	sd	s1,104(sp)
 634:	f0ca                	sd	s2,96(sp)
 636:	ecce                	sd	s3,88(sp)
 638:	e8d2                	sd	s4,80(sp)
 63a:	e4d6                	sd	s5,72(sp)
 63c:	e0da                	sd	s6,64(sp)
 63e:	fc5e                	sd	s7,56(sp)
 640:	f862                	sd	s8,48(sp)
 642:	f466                	sd	s9,40(sp)
 644:	f06a                	sd	s10,32(sp)
 646:	ec6e                	sd	s11,24(sp)
 648:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 64a:	0005c903          	lbu	s2,0(a1)
 64e:	18090f63          	beqz	s2,7ec <vprintf+0x1c0>
 652:	8aaa                	mv	s5,a0
 654:	8b32                	mv	s6,a2
 656:	00158493          	addi	s1,a1,1
  state = 0;
 65a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 65c:	02500a13          	li	s4,37
      if(c == 'd'){
 660:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 664:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 668:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 66c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 670:	00000b97          	auipc	s7,0x0
 674:	408b8b93          	addi	s7,s7,1032 # a78 <digits>
 678:	a839                	j	696 <vprintf+0x6a>
        putc(fd, c);
 67a:	85ca                	mv	a1,s2
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	ee2080e7          	jalr	-286(ra) # 560 <putc>
 686:	a019                	j	68c <vprintf+0x60>
    } else if(state == '%'){
 688:	01498f63          	beq	s3,s4,6a6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 68c:	0485                	addi	s1,s1,1
 68e:	fff4c903          	lbu	s2,-1(s1)
 692:	14090d63          	beqz	s2,7ec <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 696:	0009079b          	sext.w	a5,s2
    if(state == 0){
 69a:	fe0997e3          	bnez	s3,688 <vprintf+0x5c>
      if(c == '%'){
 69e:	fd479ee3          	bne	a5,s4,67a <vprintf+0x4e>
        state = '%';
 6a2:	89be                	mv	s3,a5
 6a4:	b7e5                	j	68c <vprintf+0x60>
      if(c == 'd'){
 6a6:	05878063          	beq	a5,s8,6e6 <vprintf+0xba>
      } else if(c == 'l') {
 6aa:	05978c63          	beq	a5,s9,702 <vprintf+0xd6>
      } else if(c == 'x') {
 6ae:	07a78863          	beq	a5,s10,71e <vprintf+0xf2>
      } else if(c == 'p') {
 6b2:	09b78463          	beq	a5,s11,73a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6b6:	07300713          	li	a4,115
 6ba:	0ce78663          	beq	a5,a4,786 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6be:	06300713          	li	a4,99
 6c2:	0ee78e63          	beq	a5,a4,7be <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6c6:	11478863          	beq	a5,s4,7d6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ca:	85d2                	mv	a1,s4
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e92080e7          	jalr	-366(ra) # 560 <putc>
        putc(fd, c);
 6d6:	85ca                	mv	a1,s2
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	e86080e7          	jalr	-378(ra) # 560 <putc>
      }
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b765                	j	68c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6e6:	008b0913          	addi	s2,s6,8
 6ea:	4685                	li	a3,1
 6ec:	4629                	li	a2,10
 6ee:	000b2583          	lw	a1,0(s6)
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e8e080e7          	jalr	-370(ra) # 582 <printint>
 6fc:	8b4a                	mv	s6,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b771                	j	68c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 702:	008b0913          	addi	s2,s6,8
 706:	4681                	li	a3,0
 708:	4629                	li	a2,10
 70a:	000b2583          	lw	a1,0(s6)
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e72080e7          	jalr	-398(ra) # 582 <printint>
 718:	8b4a                	mv	s6,s2
      state = 0;
 71a:	4981                	li	s3,0
 71c:	bf85                	j	68c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 71e:	008b0913          	addi	s2,s6,8
 722:	4681                	li	a3,0
 724:	4641                	li	a2,16
 726:	000b2583          	lw	a1,0(s6)
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	e56080e7          	jalr	-426(ra) # 582 <printint>
 734:	8b4a                	mv	s6,s2
      state = 0;
 736:	4981                	li	s3,0
 738:	bf91                	j	68c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 73a:	008b0793          	addi	a5,s6,8
 73e:	f8f43423          	sd	a5,-120(s0)
 742:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 746:	03000593          	li	a1,48
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	e14080e7          	jalr	-492(ra) # 560 <putc>
  putc(fd, 'x');
 754:	85ea                	mv	a1,s10
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	e08080e7          	jalr	-504(ra) # 560 <putc>
 760:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 762:	03c9d793          	srli	a5,s3,0x3c
 766:	97de                	add	a5,a5,s7
 768:	0007c583          	lbu	a1,0(a5)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	df2080e7          	jalr	-526(ra) # 560 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 776:	0992                	slli	s3,s3,0x4
 778:	397d                	addiw	s2,s2,-1
 77a:	fe0914e3          	bnez	s2,762 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 77e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 782:	4981                	li	s3,0
 784:	b721                	j	68c <vprintf+0x60>
        s = va_arg(ap, char*);
 786:	008b0993          	addi	s3,s6,8
 78a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 78e:	02090163          	beqz	s2,7b0 <vprintf+0x184>
        while(*s != 0){
 792:	00094583          	lbu	a1,0(s2)
 796:	c9a1                	beqz	a1,7e6 <vprintf+0x1ba>
          putc(fd, *s);
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	dc6080e7          	jalr	-570(ra) # 560 <putc>
          s++;
 7a2:	0905                	addi	s2,s2,1
        while(*s != 0){
 7a4:	00094583          	lbu	a1,0(s2)
 7a8:	f9e5                	bnez	a1,798 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7aa:	8b4e                	mv	s6,s3
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bdf9                	j	68c <vprintf+0x60>
          s = "(null)";
 7b0:	00000917          	auipc	s2,0x0
 7b4:	2c090913          	addi	s2,s2,704 # a70 <malloc+0x17a>
        while(*s != 0){
 7b8:	02800593          	li	a1,40
 7bc:	bff1                	j	798 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7be:	008b0913          	addi	s2,s6,8
 7c2:	000b4583          	lbu	a1,0(s6)
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	d98080e7          	jalr	-616(ra) # 560 <putc>
 7d0:	8b4a                	mv	s6,s2
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bd65                	j	68c <vprintf+0x60>
        putc(fd, c);
 7d6:	85d2                	mv	a1,s4
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	d86080e7          	jalr	-634(ra) # 560 <putc>
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b565                	j	68c <vprintf+0x60>
        s = va_arg(ap, char*);
 7e6:	8b4e                	mv	s6,s3
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	b54d                	j	68c <vprintf+0x60>
    }
  }
}
 7ec:	70e6                	ld	ra,120(sp)
 7ee:	7446                	ld	s0,112(sp)
 7f0:	74a6                	ld	s1,104(sp)
 7f2:	7906                	ld	s2,96(sp)
 7f4:	69e6                	ld	s3,88(sp)
 7f6:	6a46                	ld	s4,80(sp)
 7f8:	6aa6                	ld	s5,72(sp)
 7fa:	6b06                	ld	s6,64(sp)
 7fc:	7be2                	ld	s7,56(sp)
 7fe:	7c42                	ld	s8,48(sp)
 800:	7ca2                	ld	s9,40(sp)
 802:	7d02                	ld	s10,32(sp)
 804:	6de2                	ld	s11,24(sp)
 806:	6109                	addi	sp,sp,128
 808:	8082                	ret

000000000000080a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 80a:	715d                	addi	sp,sp,-80
 80c:	ec06                	sd	ra,24(sp)
 80e:	e822                	sd	s0,16(sp)
 810:	1000                	addi	s0,sp,32
 812:	e010                	sd	a2,0(s0)
 814:	e414                	sd	a3,8(s0)
 816:	e818                	sd	a4,16(s0)
 818:	ec1c                	sd	a5,24(s0)
 81a:	03043023          	sd	a6,32(s0)
 81e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 822:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 826:	8622                	mv	a2,s0
 828:	00000097          	auipc	ra,0x0
 82c:	e04080e7          	jalr	-508(ra) # 62c <vprintf>
}
 830:	60e2                	ld	ra,24(sp)
 832:	6442                	ld	s0,16(sp)
 834:	6161                	addi	sp,sp,80
 836:	8082                	ret

0000000000000838 <printf>:

void
printf(const char *fmt, ...)
{
 838:	711d                	addi	sp,sp,-96
 83a:	ec06                	sd	ra,24(sp)
 83c:	e822                	sd	s0,16(sp)
 83e:	1000                	addi	s0,sp,32
 840:	e40c                	sd	a1,8(s0)
 842:	e810                	sd	a2,16(s0)
 844:	ec14                	sd	a3,24(s0)
 846:	f018                	sd	a4,32(s0)
 848:	f41c                	sd	a5,40(s0)
 84a:	03043823          	sd	a6,48(s0)
 84e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 852:	00840613          	addi	a2,s0,8
 856:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 85a:	85aa                	mv	a1,a0
 85c:	4505                	li	a0,1
 85e:	00000097          	auipc	ra,0x0
 862:	dce080e7          	jalr	-562(ra) # 62c <vprintf>
}
 866:	60e2                	ld	ra,24(sp)
 868:	6442                	ld	s0,16(sp)
 86a:	6125                	addi	sp,sp,96
 86c:	8082                	ret

000000000000086e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86e:	1141                	addi	sp,sp,-16
 870:	e422                	sd	s0,8(sp)
 872:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 874:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 878:	00000797          	auipc	a5,0x0
 87c:	2187b783          	ld	a5,536(a5) # a90 <freep>
 880:	a805                	j	8b0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 882:	4618                	lw	a4,8(a2)
 884:	9db9                	addw	a1,a1,a4
 886:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 88a:	6398                	ld	a4,0(a5)
 88c:	6318                	ld	a4,0(a4)
 88e:	fee53823          	sd	a4,-16(a0)
 892:	a091                	j	8d6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 894:	ff852703          	lw	a4,-8(a0)
 898:	9e39                	addw	a2,a2,a4
 89a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 89c:	ff053703          	ld	a4,-16(a0)
 8a0:	e398                	sd	a4,0(a5)
 8a2:	a099                	j	8e8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a4:	6398                	ld	a4,0(a5)
 8a6:	00e7e463          	bltu	a5,a4,8ae <free+0x40>
 8aa:	00e6ea63          	bltu	a3,a4,8be <free+0x50>
{
 8ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b0:	fed7fae3          	bgeu	a5,a3,8a4 <free+0x36>
 8b4:	6398                	ld	a4,0(a5)
 8b6:	00e6e463          	bltu	a3,a4,8be <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ba:	fee7eae3          	bltu	a5,a4,8ae <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8be:	ff852583          	lw	a1,-8(a0)
 8c2:	6390                	ld	a2,0(a5)
 8c4:	02059713          	slli	a4,a1,0x20
 8c8:	9301                	srli	a4,a4,0x20
 8ca:	0712                	slli	a4,a4,0x4
 8cc:	9736                	add	a4,a4,a3
 8ce:	fae60ae3          	beq	a2,a4,882 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d6:	4790                	lw	a2,8(a5)
 8d8:	02061713          	slli	a4,a2,0x20
 8dc:	9301                	srli	a4,a4,0x20
 8de:	0712                	slli	a4,a4,0x4
 8e0:	973e                	add	a4,a4,a5
 8e2:	fae689e3          	beq	a3,a4,894 <free+0x26>
  } else
    p->s.ptr = bp;
 8e6:	e394                	sd	a3,0(a5)
  freep = p;
 8e8:	00000717          	auipc	a4,0x0
 8ec:	1af73423          	sd	a5,424(a4) # a90 <freep>
}
 8f0:	6422                	ld	s0,8(sp)
 8f2:	0141                	addi	sp,sp,16
 8f4:	8082                	ret

00000000000008f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f6:	7139                	addi	sp,sp,-64
 8f8:	fc06                	sd	ra,56(sp)
 8fa:	f822                	sd	s0,48(sp)
 8fc:	f426                	sd	s1,40(sp)
 8fe:	f04a                	sd	s2,32(sp)
 900:	ec4e                	sd	s3,24(sp)
 902:	e852                	sd	s4,16(sp)
 904:	e456                	sd	s5,8(sp)
 906:	e05a                	sd	s6,0(sp)
 908:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90a:	02051493          	slli	s1,a0,0x20
 90e:	9081                	srli	s1,s1,0x20
 910:	04bd                	addi	s1,s1,15
 912:	8091                	srli	s1,s1,0x4
 914:	0014899b          	addiw	s3,s1,1
 918:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 91a:	00000517          	auipc	a0,0x0
 91e:	17653503          	ld	a0,374(a0) # a90 <freep>
 922:	c515                	beqz	a0,94e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 924:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 926:	4798                	lw	a4,8(a5)
 928:	02977f63          	bgeu	a4,s1,966 <malloc+0x70>
 92c:	8a4e                	mv	s4,s3
 92e:	0009871b          	sext.w	a4,s3
 932:	6685                	lui	a3,0x1
 934:	00d77363          	bgeu	a4,a3,93a <malloc+0x44>
 938:	6a05                	lui	s4,0x1
 93a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 93e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 942:	00000917          	auipc	s2,0x0
 946:	14e90913          	addi	s2,s2,334 # a90 <freep>
  if(p == (char*)-1)
 94a:	5afd                	li	s5,-1
 94c:	a88d                	j	9be <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 94e:	00000797          	auipc	a5,0x0
 952:	14a78793          	addi	a5,a5,330 # a98 <base>
 956:	00000717          	auipc	a4,0x0
 95a:	12f73d23          	sd	a5,314(a4) # a90 <freep>
 95e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 960:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 964:	b7e1                	j	92c <malloc+0x36>
      if(p->s.size == nunits)
 966:	02e48b63          	beq	s1,a4,99c <malloc+0xa6>
        p->s.size -= nunits;
 96a:	4137073b          	subw	a4,a4,s3
 96e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 970:	1702                	slli	a4,a4,0x20
 972:	9301                	srli	a4,a4,0x20
 974:	0712                	slli	a4,a4,0x4
 976:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 978:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97c:	00000717          	auipc	a4,0x0
 980:	10a73a23          	sd	a0,276(a4) # a90 <freep>
      return (void*)(p + 1);
 984:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 988:	70e2                	ld	ra,56(sp)
 98a:	7442                	ld	s0,48(sp)
 98c:	74a2                	ld	s1,40(sp)
 98e:	7902                	ld	s2,32(sp)
 990:	69e2                	ld	s3,24(sp)
 992:	6a42                	ld	s4,16(sp)
 994:	6aa2                	ld	s5,8(sp)
 996:	6b02                	ld	s6,0(sp)
 998:	6121                	addi	sp,sp,64
 99a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 99c:	6398                	ld	a4,0(a5)
 99e:	e118                	sd	a4,0(a0)
 9a0:	bff1                	j	97c <malloc+0x86>
  hp->s.size = nu;
 9a2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9a6:	0541                	addi	a0,a0,16
 9a8:	00000097          	auipc	ra,0x0
 9ac:	ec6080e7          	jalr	-314(ra) # 86e <free>
  return freep;
 9b0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9b4:	d971                	beqz	a0,988 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b8:	4798                	lw	a4,8(a5)
 9ba:	fa9776e3          	bgeu	a4,s1,966 <malloc+0x70>
    if(p == freep)
 9be:	00093703          	ld	a4,0(s2)
 9c2:	853e                	mv	a0,a5
 9c4:	fef719e3          	bne	a4,a5,9b6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9c8:	8552                	mv	a0,s4
 9ca:	00000097          	auipc	ra,0x0
 9ce:	b7e080e7          	jalr	-1154(ra) # 548 <sbrk>
  if(p == (char*)-1)
 9d2:	fd5518e3          	bne	a0,s5,9a2 <malloc+0xac>
        return 0;
 9d6:	4501                	li	a0,0
 9d8:	bf45                	j	988 <malloc+0x92>
