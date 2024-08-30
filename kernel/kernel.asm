
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	88013103          	ld	sp,-1920(sp) # 80008880 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	782050ef          	jal	ra,80005798 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0002a797          	auipc	a5,0x2a
    80000034:	21078793          	addi	a5,a5,528 # 8002a240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	180080e7          	jalr	384(ra) # 800061da <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	220080e7          	jalr	544(ra) # 8000628e <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c30080e7          	jalr	-976(ra) # 80005cba <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	056080e7          	jalr	86(ra) # 8000614a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002a517          	auipc	a0,0x2a
    80000104:	14050513          	addi	a0,a0,320 # 8002a240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	0ae080e7          	jalr	174(ra) # 800061da <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	14a080e7          	jalr	330(ra) # 8000628e <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	120080e7          	jalr	288(ra) # 8000628e <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	9b0080e7          	jalr	-1616(ra) # 80005d0c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	736080e7          	jalr	1846(ra) # 80001aa2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	dac080e7          	jalr	-596(ra) # 80005120 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fe4080e7          	jalr	-28(ra) # 80001360 <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	7d6080e7          	jalr	2006(ra) # 80005b5a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	8bc080e7          	jalr	-1860(ra) # 80005c48 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	970080e7          	jalr	-1680(ra) # 80005d0c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	960080e7          	jalr	-1696(ra) # 80005d0c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	950080e7          	jalr	-1712(ra) # 80005d0c <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	696080e7          	jalr	1686(ra) # 80001a7a <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6b6080e7          	jalr	1718(ra) # 80001aa2 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d16080e7          	jalr	-746(ra) # 8000510a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d24080e7          	jalr	-732(ra) # 80005120 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f02080e7          	jalr	-254(ra) # 80002306 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	592080e7          	jalr	1426(ra) # 8000299e <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	53c080e7          	jalr	1340(ra) # 80003950 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e26080e7          	jalr	-474(ra) # 80005242 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d0a080e7          	jalr	-758(ra) # 8000112e <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	82c080e7          	jalr	-2004(ra) # 80005cba <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00005097          	auipc	ra,0x5
    8000058a:	734080e7          	jalr	1844(ra) # 80005cba <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	724080e7          	jalr	1828(ra) # 80005cba <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00005097          	auipc	ra,0x5
    80000614:	6aa080e7          	jalr	1706(ra) # 80005cba <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	55e080e7          	jalr	1374(ra) # 80005cba <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	54e080e7          	jalr	1358(ra) # 80005cba <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	53e080e7          	jalr	1342(ra) # 80005cba <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	52e080e7          	jalr	1326(ra) # 80005cba <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	450080e7          	jalr	1104(ra) # 80005cba <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	30e080e7          	jalr	782(ra) # 80005cba <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	232080e7          	jalr	562(ra) # 80005cba <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	222080e7          	jalr	546(ra) # 80005cba <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	1b8080e7          	jalr	440(ra) # 80005cba <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	00013a17          	auipc	s4,0x13
    80000d0a:	f7aa0a13          	addi	s4,s4,-134 # 80013c80 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	8595                	srai	a1,a1,0x5
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	2a048493          	addi	s1,s1,672
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	f56080e7          	jalr	-170(ra) # 80005cba <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	3ba080e7          	jalr	954(ra) # 8000614a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	3a2080e7          	jalr	930(ra) # 8000614a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	00013997          	auipc	s3,0x13
    80000dd6:	eae98993          	addi	s3,s3,-338 # 80013c80 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	36c080e7          	jalr	876(ra) # 8000614a <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	8795                	srai	a5,a5,0x5
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	2a048493          	addi	s1,s1,672
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	33c080e7          	jalr	828(ra) # 8000618e <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	3c2080e7          	jalr	962(ra) # 8000622e <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	3fe080e7          	jalr	1022(ra) # 8000628e <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9987a783          	lw	a5,-1640(a5) # 80008830 <first.1682>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c18080e7          	jalr	-1000(ra) # 80001aba <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9607af23          	sw	zero,-1666(a5) # 80008830 <first.1682>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	a62080e7          	jalr	-1438(ra) # 8000291e <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	2fe080e7          	jalr	766(ra) # 800061da <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	95078793          	addi	a5,a5,-1712 # 80008834 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	398080e7          	jalr	920(ra) # 8000628e <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	05893683          	ld	a3,88(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	6d28                	ld	a0,88(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001016:	68a8                	ld	a0,80(s1)
    80001018:	c511                	beqz	a0,80001024 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	64ac                	ld	a1,72(s1)
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	f8c080e7          	jalr	-116(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001024:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001028:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001030:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001034:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
    80001066:	00013917          	auipc	s2,0x13
    8000106a:	c1a90913          	addi	s2,s2,-998 # 80013c80 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	16a080e7          	jalr	362(ra) # 800061da <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	cf81                	beqz	a5,80001092 <allocproc+0x40>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	210080e7          	jalr	528(ra) # 8000628e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	2a048493          	addi	s1,s1,672
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
    80001090:	a085                	j	800010f0 <allocproc+0x9e>
  p->pid = allocpid();
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e34080e7          	jalr	-460(ra) # 80000ec6 <allocpid>
    8000109a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000109c:	4785                	li	a5,1
    8000109e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	078080e7          	jalr	120(ra) # 80000118 <kalloc>
    800010a8:	892a                	mv	s2,a0
    800010aa:	eca8                	sd	a0,88(s1)
    800010ac:	c929                	beqz	a0,800010fe <allocproc+0xac>
  p->pagetable = proc_pagetable(p);
    800010ae:	8526                	mv	a0,s1
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	e5c080e7          	jalr	-420(ra) # 80000f0c <proc_pagetable>
    800010b8:	892a                	mv	s2,a0
    800010ba:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010bc:	cd29                	beqz	a0,80001116 <allocproc+0xc4>
  memset(&p->context, 0, sizeof(p->context));
    800010be:	07000613          	li	a2,112
    800010c2:	4581                	li	a1,0
    800010c4:	06048513          	addi	a0,s1,96
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	0b0080e7          	jalr	176(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010d0:	00000797          	auipc	a5,0x0
    800010d4:	db078793          	addi	a5,a5,-592 # 80000e80 <forkret>
    800010d8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010da:	60bc                	ld	a5,64(s1)
    800010dc:	6705                	lui	a4,0x1
    800010de:	97ba                	add	a5,a5,a4
    800010e0:	f4bc                	sd	a5,104(s1)
  p->alarmticks = 0;
    800010e2:	1604a623          	sw	zero,364(s1)
  p->alarminterval = 0;
    800010e6:	1604a423          	sw	zero,360(s1)
  p->sigreturned = 1;
    800010ea:	4785                	li	a5,1
    800010ec:	28f4ac23          	sw	a5,664(s1)
}
    800010f0:	8526                	mv	a0,s1
    800010f2:	60e2                	ld	ra,24(sp)
    800010f4:	6442                	ld	s0,16(sp)
    800010f6:	64a2                	ld	s1,8(sp)
    800010f8:	6902                	ld	s2,0(sp)
    800010fa:	6105                	addi	sp,sp,32
    800010fc:	8082                	ret
    freeproc(p);
    800010fe:	8526                	mv	a0,s1
    80001100:	00000097          	auipc	ra,0x0
    80001104:	efa080e7          	jalr	-262(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001108:	8526                	mv	a0,s1
    8000110a:	00005097          	auipc	ra,0x5
    8000110e:	184080e7          	jalr	388(ra) # 8000628e <release>
    return 0;
    80001112:	84ca                	mv	s1,s2
    80001114:	bff1                	j	800010f0 <allocproc+0x9e>
    freeproc(p);
    80001116:	8526                	mv	a0,s1
    80001118:	00000097          	auipc	ra,0x0
    8000111c:	ee2080e7          	jalr	-286(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001120:	8526                	mv	a0,s1
    80001122:	00005097          	auipc	ra,0x5
    80001126:	16c080e7          	jalr	364(ra) # 8000628e <release>
    return 0;
    8000112a:	84ca                	mv	s1,s2
    8000112c:	b7d1                	j	800010f0 <allocproc+0x9e>

000000008000112e <userinit>:
{
    8000112e:	1101                	addi	sp,sp,-32
    80001130:	ec06                	sd	ra,24(sp)
    80001132:	e822                	sd	s0,16(sp)
    80001134:	e426                	sd	s1,8(sp)
    80001136:	1000                	addi	s0,sp,32
  p = allocproc();
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	f1a080e7          	jalr	-230(ra) # 80001052 <allocproc>
    80001140:	84aa                	mv	s1,a0
  initproc = p;
    80001142:	00008797          	auipc	a5,0x8
    80001146:	eca7b723          	sd	a0,-306(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000114a:	03400613          	li	a2,52
    8000114e:	00007597          	auipc	a1,0x7
    80001152:	6f258593          	addi	a1,a1,1778 # 80008840 <initcode>
    80001156:	6928                	ld	a0,80(a0)
    80001158:	fffff097          	auipc	ra,0xfffff
    8000115c:	6a8080e7          	jalr	1704(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001160:	6785                	lui	a5,0x1
    80001162:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001164:	6cb8                	ld	a4,88(s1)
    80001166:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000116a:	6cb8                	ld	a4,88(s1)
    8000116c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116e:	4641                	li	a2,16
    80001170:	00007597          	auipc	a1,0x7
    80001174:	01058593          	addi	a1,a1,16 # 80008180 <etext+0x180>
    80001178:	15848513          	addi	a0,s1,344
    8000117c:	fffff097          	auipc	ra,0xfffff
    80001180:	14e080e7          	jalr	334(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001184:	00007517          	auipc	a0,0x7
    80001188:	00c50513          	addi	a0,a0,12 # 80008190 <etext+0x190>
    8000118c:	00002097          	auipc	ra,0x2
    80001190:	1c0080e7          	jalr	448(ra) # 8000334c <namei>
    80001194:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001198:	478d                	li	a5,3
    8000119a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119c:	8526                	mv	a0,s1
    8000119e:	00005097          	auipc	ra,0x5
    800011a2:	0f0080e7          	jalr	240(ra) # 8000628e <release>
}
    800011a6:	60e2                	ld	ra,24(sp)
    800011a8:	6442                	ld	s0,16(sp)
    800011aa:	64a2                	ld	s1,8(sp)
    800011ac:	6105                	addi	sp,sp,32
    800011ae:	8082                	ret

00000000800011b0 <growproc>:
{
    800011b0:	1101                	addi	sp,sp,-32
    800011b2:	ec06                	sd	ra,24(sp)
    800011b4:	e822                	sd	s0,16(sp)
    800011b6:	e426                	sd	s1,8(sp)
    800011b8:	e04a                	sd	s2,0(sp)
    800011ba:	1000                	addi	s0,sp,32
    800011bc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	c8a080e7          	jalr	-886(ra) # 80000e48 <myproc>
    800011c6:	892a                	mv	s2,a0
  sz = p->sz;
    800011c8:	652c                	ld	a1,72(a0)
    800011ca:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011ce:	00904f63          	bgtz	s1,800011ec <growproc+0x3c>
  } else if(n < 0){
    800011d2:	0204cc63          	bltz	s1,8000120a <growproc+0x5a>
  p->sz = sz;
    800011d6:	1602                	slli	a2,a2,0x20
    800011d8:	9201                	srli	a2,a2,0x20
    800011da:	04c93423          	sd	a2,72(s2)
  return 0;
    800011de:	4501                	li	a0,0
}
    800011e0:	60e2                	ld	ra,24(sp)
    800011e2:	6442                	ld	s0,16(sp)
    800011e4:	64a2                	ld	s1,8(sp)
    800011e6:	6902                	ld	s2,0(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011ec:	9e25                	addw	a2,a2,s1
    800011ee:	1602                	slli	a2,a2,0x20
    800011f0:	9201                	srli	a2,a2,0x20
    800011f2:	1582                	slli	a1,a1,0x20
    800011f4:	9181                	srli	a1,a1,0x20
    800011f6:	6928                	ld	a0,80(a0)
    800011f8:	fffff097          	auipc	ra,0xfffff
    800011fc:	6c2080e7          	jalr	1730(ra) # 800008ba <uvmalloc>
    80001200:	0005061b          	sext.w	a2,a0
    80001204:	fa69                	bnez	a2,800011d6 <growproc+0x26>
      return -1;
    80001206:	557d                	li	a0,-1
    80001208:	bfe1                	j	800011e0 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000120a:	9e25                	addw	a2,a2,s1
    8000120c:	1602                	slli	a2,a2,0x20
    8000120e:	9201                	srli	a2,a2,0x20
    80001210:	1582                	slli	a1,a1,0x20
    80001212:	9181                	srli	a1,a1,0x20
    80001214:	6928                	ld	a0,80(a0)
    80001216:	fffff097          	auipc	ra,0xfffff
    8000121a:	65c080e7          	jalr	1628(ra) # 80000872 <uvmdealloc>
    8000121e:	0005061b          	sext.w	a2,a0
    80001222:	bf55                	j	800011d6 <growproc+0x26>

0000000080001224 <fork>:
{
    80001224:	7179                	addi	sp,sp,-48
    80001226:	f406                	sd	ra,40(sp)
    80001228:	f022                	sd	s0,32(sp)
    8000122a:	ec26                	sd	s1,24(sp)
    8000122c:	e84a                	sd	s2,16(sp)
    8000122e:	e44e                	sd	s3,8(sp)
    80001230:	e052                	sd	s4,0(sp)
    80001232:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001234:	00000097          	auipc	ra,0x0
    80001238:	c14080e7          	jalr	-1004(ra) # 80000e48 <myproc>
    8000123c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	e14080e7          	jalr	-492(ra) # 80001052 <allocproc>
    80001246:	10050b63          	beqz	a0,8000135c <fork+0x138>
    8000124a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000124c:	04893603          	ld	a2,72(s2)
    80001250:	692c                	ld	a1,80(a0)
    80001252:	05093503          	ld	a0,80(s2)
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	7b0080e7          	jalr	1968(ra) # 80000a06 <uvmcopy>
    8000125e:	04054663          	bltz	a0,800012aa <fork+0x86>
  np->sz = p->sz;
    80001262:	04893783          	ld	a5,72(s2)
    80001266:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000126a:	05893683          	ld	a3,88(s2)
    8000126e:	87b6                	mv	a5,a3
    80001270:	0589b703          	ld	a4,88(s3)
    80001274:	12068693          	addi	a3,a3,288
    80001278:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000127c:	6788                	ld	a0,8(a5)
    8000127e:	6b8c                	ld	a1,16(a5)
    80001280:	6f90                	ld	a2,24(a5)
    80001282:	01073023          	sd	a6,0(a4)
    80001286:	e708                	sd	a0,8(a4)
    80001288:	eb0c                	sd	a1,16(a4)
    8000128a:	ef10                	sd	a2,24(a4)
    8000128c:	02078793          	addi	a5,a5,32
    80001290:	02070713          	addi	a4,a4,32
    80001294:	fed792e3          	bne	a5,a3,80001278 <fork+0x54>
  np->trapframe->a0 = 0;
    80001298:	0589b783          	ld	a5,88(s3)
    8000129c:	0607b823          	sd	zero,112(a5)
    800012a0:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012a4:	15000a13          	li	s4,336
    800012a8:	a03d                	j	800012d6 <fork+0xb2>
    freeproc(np);
    800012aa:	854e                	mv	a0,s3
    800012ac:	00000097          	auipc	ra,0x0
    800012b0:	d4e080e7          	jalr	-690(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012b4:	854e                	mv	a0,s3
    800012b6:	00005097          	auipc	ra,0x5
    800012ba:	fd8080e7          	jalr	-40(ra) # 8000628e <release>
    return -1;
    800012be:	5a7d                	li	s4,-1
    800012c0:	a069                	j	8000134a <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c2:	00002097          	auipc	ra,0x2
    800012c6:	720080e7          	jalr	1824(ra) # 800039e2 <filedup>
    800012ca:	009987b3          	add	a5,s3,s1
    800012ce:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012d0:	04a1                	addi	s1,s1,8
    800012d2:	01448763          	beq	s1,s4,800012e0 <fork+0xbc>
    if(p->ofile[i])
    800012d6:	009907b3          	add	a5,s2,s1
    800012da:	6388                	ld	a0,0(a5)
    800012dc:	f17d                	bnez	a0,800012c2 <fork+0x9e>
    800012de:	bfcd                	j	800012d0 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012e0:	15093503          	ld	a0,336(s2)
    800012e4:	00002097          	auipc	ra,0x2
    800012e8:	874080e7          	jalr	-1932(ra) # 80002b58 <idup>
    800012ec:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012f0:	4641                	li	a2,16
    800012f2:	15890593          	addi	a1,s2,344
    800012f6:	15898513          	addi	a0,s3,344
    800012fa:	fffff097          	auipc	ra,0xfffff
    800012fe:	fd0080e7          	jalr	-48(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001302:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001306:	854e                	mv	a0,s3
    80001308:	00005097          	auipc	ra,0x5
    8000130c:	f86080e7          	jalr	-122(ra) # 8000628e <release>
  acquire(&wait_lock);
    80001310:	00008497          	auipc	s1,0x8
    80001314:	d5848493          	addi	s1,s1,-680 # 80009068 <wait_lock>
    80001318:	8526                	mv	a0,s1
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	ec0080e7          	jalr	-320(ra) # 800061da <acquire>
  np->parent = p;
    80001322:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001326:	8526                	mv	a0,s1
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	f66080e7          	jalr	-154(ra) # 8000628e <release>
  acquire(&np->lock);
    80001330:	854e                	mv	a0,s3
    80001332:	00005097          	auipc	ra,0x5
    80001336:	ea8080e7          	jalr	-344(ra) # 800061da <acquire>
  np->state = RUNNABLE;
    8000133a:	478d                	li	a5,3
    8000133c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001340:	854e                	mv	a0,s3
    80001342:	00005097          	auipc	ra,0x5
    80001346:	f4c080e7          	jalr	-180(ra) # 8000628e <release>
}
    8000134a:	8552                	mv	a0,s4
    8000134c:	70a2                	ld	ra,40(sp)
    8000134e:	7402                	ld	s0,32(sp)
    80001350:	64e2                	ld	s1,24(sp)
    80001352:	6942                	ld	s2,16(sp)
    80001354:	69a2                	ld	s3,8(sp)
    80001356:	6a02                	ld	s4,0(sp)
    80001358:	6145                	addi	sp,sp,48
    8000135a:	8082                	ret
    return -1;
    8000135c:	5a7d                	li	s4,-1
    8000135e:	b7f5                	j	8000134a <fork+0x126>

0000000080001360 <scheduler>:
{
    80001360:	7139                	addi	sp,sp,-64
    80001362:	fc06                	sd	ra,56(sp)
    80001364:	f822                	sd	s0,48(sp)
    80001366:	f426                	sd	s1,40(sp)
    80001368:	f04a                	sd	s2,32(sp)
    8000136a:	ec4e                	sd	s3,24(sp)
    8000136c:	e852                	sd	s4,16(sp)
    8000136e:	e456                	sd	s5,8(sp)
    80001370:	e05a                	sd	s6,0(sp)
    80001372:	0080                	addi	s0,sp,64
    80001374:	8792                	mv	a5,tp
  int id = r_tp();
    80001376:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001378:	00779a93          	slli	s5,a5,0x7
    8000137c:	00008717          	auipc	a4,0x8
    80001380:	cd470713          	addi	a4,a4,-812 # 80009050 <pid_lock>
    80001384:	9756                	add	a4,a4,s5
    80001386:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000138a:	00008717          	auipc	a4,0x8
    8000138e:	cfe70713          	addi	a4,a4,-770 # 80009088 <cpus+0x8>
    80001392:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001394:	498d                	li	s3,3
        p->state = RUNNING;
    80001396:	4b11                	li	s6,4
        c->proc = p;
    80001398:	079e                	slli	a5,a5,0x7
    8000139a:	00008a17          	auipc	s4,0x8
    8000139e:	cb6a0a13          	addi	s4,s4,-842 # 80009050 <pid_lock>
    800013a2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013a4:	00013917          	auipc	s2,0x13
    800013a8:	8dc90913          	addi	s2,s2,-1828 # 80013c80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013b4:	10079073          	csrw	sstatus,a5
    800013b8:	00008497          	auipc	s1,0x8
    800013bc:	0c848493          	addi	s1,s1,200 # 80009480 <proc>
    800013c0:	a03d                	j	800013ee <scheduler+0x8e>
        p->state = RUNNING;
    800013c2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013c6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013ca:	06048593          	addi	a1,s1,96
    800013ce:	8556                	mv	a0,s5
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	640080e7          	jalr	1600(ra) # 80001a10 <swtch>
        c->proc = 0;
    800013d8:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013dc:	8526                	mv	a0,s1
    800013de:	00005097          	auipc	ra,0x5
    800013e2:	eb0080e7          	jalr	-336(ra) # 8000628e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e6:	2a048493          	addi	s1,s1,672
    800013ea:	fd2481e3          	beq	s1,s2,800013ac <scheduler+0x4c>
      acquire(&p->lock);
    800013ee:	8526                	mv	a0,s1
    800013f0:	00005097          	auipc	ra,0x5
    800013f4:	dea080e7          	jalr	-534(ra) # 800061da <acquire>
      if(p->state == RUNNABLE) {
    800013f8:	4c9c                	lw	a5,24(s1)
    800013fa:	ff3791e3          	bne	a5,s3,800013dc <scheduler+0x7c>
    800013fe:	b7d1                	j	800013c2 <scheduler+0x62>

0000000080001400 <sched>:
{
    80001400:	7179                	addi	sp,sp,-48
    80001402:	f406                	sd	ra,40(sp)
    80001404:	f022                	sd	s0,32(sp)
    80001406:	ec26                	sd	s1,24(sp)
    80001408:	e84a                	sd	s2,16(sp)
    8000140a:	e44e                	sd	s3,8(sp)
    8000140c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	a3a080e7          	jalr	-1478(ra) # 80000e48 <myproc>
    80001416:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001418:	00005097          	auipc	ra,0x5
    8000141c:	d48080e7          	jalr	-696(ra) # 80006160 <holding>
    80001420:	c93d                	beqz	a0,80001496 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001422:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001424:	2781                	sext.w	a5,a5
    80001426:	079e                	slli	a5,a5,0x7
    80001428:	00008717          	auipc	a4,0x8
    8000142c:	c2870713          	addi	a4,a4,-984 # 80009050 <pid_lock>
    80001430:	97ba                	add	a5,a5,a4
    80001432:	0a87a703          	lw	a4,168(a5)
    80001436:	4785                	li	a5,1
    80001438:	06f71763          	bne	a4,a5,800014a6 <sched+0xa6>
  if(p->state == RUNNING)
    8000143c:	4c98                	lw	a4,24(s1)
    8000143e:	4791                	li	a5,4
    80001440:	06f70b63          	beq	a4,a5,800014b6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001444:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001448:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000144a:	efb5                	bnez	a5,800014c6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000144e:	00008917          	auipc	s2,0x8
    80001452:	c0290913          	addi	s2,s2,-1022 # 80009050 <pid_lock>
    80001456:	2781                	sext.w	a5,a5
    80001458:	079e                	slli	a5,a5,0x7
    8000145a:	97ca                	add	a5,a5,s2
    8000145c:	0ac7a983          	lw	s3,172(a5)
    80001460:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001462:	2781                	sext.w	a5,a5
    80001464:	079e                	slli	a5,a5,0x7
    80001466:	00008597          	auipc	a1,0x8
    8000146a:	c2258593          	addi	a1,a1,-990 # 80009088 <cpus+0x8>
    8000146e:	95be                	add	a1,a1,a5
    80001470:	06048513          	addi	a0,s1,96
    80001474:	00000097          	auipc	ra,0x0
    80001478:	59c080e7          	jalr	1436(ra) # 80001a10 <swtch>
    8000147c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000147e:	2781                	sext.w	a5,a5
    80001480:	079e                	slli	a5,a5,0x7
    80001482:	97ca                	add	a5,a5,s2
    80001484:	0b37a623          	sw	s3,172(a5)
}
    80001488:	70a2                	ld	ra,40(sp)
    8000148a:	7402                	ld	s0,32(sp)
    8000148c:	64e2                	ld	s1,24(sp)
    8000148e:	6942                	ld	s2,16(sp)
    80001490:	69a2                	ld	s3,8(sp)
    80001492:	6145                	addi	sp,sp,48
    80001494:	8082                	ret
    panic("sched p->lock");
    80001496:	00007517          	auipc	a0,0x7
    8000149a:	d0250513          	addi	a0,a0,-766 # 80008198 <etext+0x198>
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	81c080e7          	jalr	-2020(ra) # 80005cba <panic>
    panic("sched locks");
    800014a6:	00007517          	auipc	a0,0x7
    800014aa:	d0250513          	addi	a0,a0,-766 # 800081a8 <etext+0x1a8>
    800014ae:	00005097          	auipc	ra,0x5
    800014b2:	80c080e7          	jalr	-2036(ra) # 80005cba <panic>
    panic("sched running");
    800014b6:	00007517          	auipc	a0,0x7
    800014ba:	d0250513          	addi	a0,a0,-766 # 800081b8 <etext+0x1b8>
    800014be:	00004097          	auipc	ra,0x4
    800014c2:	7fc080e7          	jalr	2044(ra) # 80005cba <panic>
    panic("sched interruptible");
    800014c6:	00007517          	auipc	a0,0x7
    800014ca:	d0250513          	addi	a0,a0,-766 # 800081c8 <etext+0x1c8>
    800014ce:	00004097          	auipc	ra,0x4
    800014d2:	7ec080e7          	jalr	2028(ra) # 80005cba <panic>

00000000800014d6 <yield>:
{
    800014d6:	1101                	addi	sp,sp,-32
    800014d8:	ec06                	sd	ra,24(sp)
    800014da:	e822                	sd	s0,16(sp)
    800014dc:	e426                	sd	s1,8(sp)
    800014de:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	968080e7          	jalr	-1688(ra) # 80000e48 <myproc>
    800014e8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	cf0080e7          	jalr	-784(ra) # 800061da <acquire>
  p->state = RUNNABLE;
    800014f2:	478d                	li	a5,3
    800014f4:	cc9c                	sw	a5,24(s1)
  sched();
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	f0a080e7          	jalr	-246(ra) # 80001400 <sched>
  release(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	00005097          	auipc	ra,0x5
    80001504:	d8e080e7          	jalr	-626(ra) # 8000628e <release>
}
    80001508:	60e2                	ld	ra,24(sp)
    8000150a:	6442                	ld	s0,16(sp)
    8000150c:	64a2                	ld	s1,8(sp)
    8000150e:	6105                	addi	sp,sp,32
    80001510:	8082                	ret

0000000080001512 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001512:	7179                	addi	sp,sp,-48
    80001514:	f406                	sd	ra,40(sp)
    80001516:	f022                	sd	s0,32(sp)
    80001518:	ec26                	sd	s1,24(sp)
    8000151a:	e84a                	sd	s2,16(sp)
    8000151c:	e44e                	sd	s3,8(sp)
    8000151e:	1800                	addi	s0,sp,48
    80001520:	89aa                	mv	s3,a0
    80001522:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	924080e7          	jalr	-1756(ra) # 80000e48 <myproc>
    8000152c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	cac080e7          	jalr	-852(ra) # 800061da <acquire>
  release(lk);
    80001536:	854a                	mv	a0,s2
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	d56080e7          	jalr	-682(ra) # 8000628e <release>

  // Go to sleep.
  p->chan = chan;
    80001540:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001544:	4789                	li	a5,2
    80001546:	cc9c                	sw	a5,24(s1)

  sched();
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	eb8080e7          	jalr	-328(ra) # 80001400 <sched>

  // Tidy up.
  p->chan = 0;
    80001550:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001554:	8526                	mv	a0,s1
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	d38080e7          	jalr	-712(ra) # 8000628e <release>
  acquire(lk);
    8000155e:	854a                	mv	a0,s2
    80001560:	00005097          	auipc	ra,0x5
    80001564:	c7a080e7          	jalr	-902(ra) # 800061da <acquire>
}
    80001568:	70a2                	ld	ra,40(sp)
    8000156a:	7402                	ld	s0,32(sp)
    8000156c:	64e2                	ld	s1,24(sp)
    8000156e:	6942                	ld	s2,16(sp)
    80001570:	69a2                	ld	s3,8(sp)
    80001572:	6145                	addi	sp,sp,48
    80001574:	8082                	ret

0000000080001576 <wait>:
{
    80001576:	715d                	addi	sp,sp,-80
    80001578:	e486                	sd	ra,72(sp)
    8000157a:	e0a2                	sd	s0,64(sp)
    8000157c:	fc26                	sd	s1,56(sp)
    8000157e:	f84a                	sd	s2,48(sp)
    80001580:	f44e                	sd	s3,40(sp)
    80001582:	f052                	sd	s4,32(sp)
    80001584:	ec56                	sd	s5,24(sp)
    80001586:	e85a                	sd	s6,16(sp)
    80001588:	e45e                	sd	s7,8(sp)
    8000158a:	e062                	sd	s8,0(sp)
    8000158c:	0880                	addi	s0,sp,80
    8000158e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001590:	00000097          	auipc	ra,0x0
    80001594:	8b8080e7          	jalr	-1864(ra) # 80000e48 <myproc>
    80001598:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000159a:	00008517          	auipc	a0,0x8
    8000159e:	ace50513          	addi	a0,a0,-1330 # 80009068 <wait_lock>
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	c38080e7          	jalr	-968(ra) # 800061da <acquire>
    havekids = 0;
    800015aa:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015ac:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015ae:	00012997          	auipc	s3,0x12
    800015b2:	6d298993          	addi	s3,s3,1746 # 80013c80 <tickslock>
        havekids = 1;
    800015b6:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015b8:	00008c17          	auipc	s8,0x8
    800015bc:	ab0c0c13          	addi	s8,s8,-1360 # 80009068 <wait_lock>
    havekids = 0;
    800015c0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015c2:	00008497          	auipc	s1,0x8
    800015c6:	ebe48493          	addi	s1,s1,-322 # 80009480 <proc>
    800015ca:	a0bd                	j	80001638 <wait+0xc2>
          pid = np->pid;
    800015cc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015d0:	000b0e63          	beqz	s6,800015ec <wait+0x76>
    800015d4:	4691                	li	a3,4
    800015d6:	02c48613          	addi	a2,s1,44
    800015da:	85da                	mv	a1,s6
    800015dc:	05093503          	ld	a0,80(s2)
    800015e0:	fffff097          	auipc	ra,0xfffff
    800015e4:	52a080e7          	jalr	1322(ra) # 80000b0a <copyout>
    800015e8:	02054563          	bltz	a0,80001612 <wait+0x9c>
          freeproc(np);
    800015ec:	8526                	mv	a0,s1
    800015ee:	00000097          	auipc	ra,0x0
    800015f2:	a0c080e7          	jalr	-1524(ra) # 80000ffa <freeproc>
          release(&np->lock);
    800015f6:	8526                	mv	a0,s1
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	c96080e7          	jalr	-874(ra) # 8000628e <release>
          release(&wait_lock);
    80001600:	00008517          	auipc	a0,0x8
    80001604:	a6850513          	addi	a0,a0,-1432 # 80009068 <wait_lock>
    80001608:	00005097          	auipc	ra,0x5
    8000160c:	c86080e7          	jalr	-890(ra) # 8000628e <release>
          return pid;
    80001610:	a09d                	j	80001676 <wait+0x100>
            release(&np->lock);
    80001612:	8526                	mv	a0,s1
    80001614:	00005097          	auipc	ra,0x5
    80001618:	c7a080e7          	jalr	-902(ra) # 8000628e <release>
            release(&wait_lock);
    8000161c:	00008517          	auipc	a0,0x8
    80001620:	a4c50513          	addi	a0,a0,-1460 # 80009068 <wait_lock>
    80001624:	00005097          	auipc	ra,0x5
    80001628:	c6a080e7          	jalr	-918(ra) # 8000628e <release>
            return -1;
    8000162c:	59fd                	li	s3,-1
    8000162e:	a0a1                	j	80001676 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001630:	2a048493          	addi	s1,s1,672
    80001634:	03348463          	beq	s1,s3,8000165c <wait+0xe6>
      if(np->parent == p){
    80001638:	7c9c                	ld	a5,56(s1)
    8000163a:	ff279be3          	bne	a5,s2,80001630 <wait+0xba>
        acquire(&np->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	b9a080e7          	jalr	-1126(ra) # 800061da <acquire>
        if(np->state == ZOMBIE){
    80001648:	4c9c                	lw	a5,24(s1)
    8000164a:	f94781e3          	beq	a5,s4,800015cc <wait+0x56>
        release(&np->lock);
    8000164e:	8526                	mv	a0,s1
    80001650:	00005097          	auipc	ra,0x5
    80001654:	c3e080e7          	jalr	-962(ra) # 8000628e <release>
        havekids = 1;
    80001658:	8756                	mv	a4,s5
    8000165a:	bfd9                	j	80001630 <wait+0xba>
    if(!havekids || p->killed){
    8000165c:	c701                	beqz	a4,80001664 <wait+0xee>
    8000165e:	02892783          	lw	a5,40(s2)
    80001662:	c79d                	beqz	a5,80001690 <wait+0x11a>
      release(&wait_lock);
    80001664:	00008517          	auipc	a0,0x8
    80001668:	a0450513          	addi	a0,a0,-1532 # 80009068 <wait_lock>
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	c22080e7          	jalr	-990(ra) # 8000628e <release>
      return -1;
    80001674:	59fd                	li	s3,-1
}
    80001676:	854e                	mv	a0,s3
    80001678:	60a6                	ld	ra,72(sp)
    8000167a:	6406                	ld	s0,64(sp)
    8000167c:	74e2                	ld	s1,56(sp)
    8000167e:	7942                	ld	s2,48(sp)
    80001680:	79a2                	ld	s3,40(sp)
    80001682:	7a02                	ld	s4,32(sp)
    80001684:	6ae2                	ld	s5,24(sp)
    80001686:	6b42                	ld	s6,16(sp)
    80001688:	6ba2                	ld	s7,8(sp)
    8000168a:	6c02                	ld	s8,0(sp)
    8000168c:	6161                	addi	sp,sp,80
    8000168e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001690:	85e2                	mv	a1,s8
    80001692:	854a                	mv	a0,s2
    80001694:	00000097          	auipc	ra,0x0
    80001698:	e7e080e7          	jalr	-386(ra) # 80001512 <sleep>
    havekids = 0;
    8000169c:	b715                	j	800015c0 <wait+0x4a>

000000008000169e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000169e:	7139                	addi	sp,sp,-64
    800016a0:	fc06                	sd	ra,56(sp)
    800016a2:	f822                	sd	s0,48(sp)
    800016a4:	f426                	sd	s1,40(sp)
    800016a6:	f04a                	sd	s2,32(sp)
    800016a8:	ec4e                	sd	s3,24(sp)
    800016aa:	e852                	sd	s4,16(sp)
    800016ac:	e456                	sd	s5,8(sp)
    800016ae:	0080                	addi	s0,sp,64
    800016b0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016b2:	00008497          	auipc	s1,0x8
    800016b6:	dce48493          	addi	s1,s1,-562 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016ba:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016bc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016be:	00012917          	auipc	s2,0x12
    800016c2:	5c290913          	addi	s2,s2,1474 # 80013c80 <tickslock>
    800016c6:	a821                	j	800016de <wakeup+0x40>
        p->state = RUNNABLE;
    800016c8:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016cc:	8526                	mv	a0,s1
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	bc0080e7          	jalr	-1088(ra) # 8000628e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d6:	2a048493          	addi	s1,s1,672
    800016da:	03248463          	beq	s1,s2,80001702 <wakeup+0x64>
    if(p != myproc()){
    800016de:	fffff097          	auipc	ra,0xfffff
    800016e2:	76a080e7          	jalr	1898(ra) # 80000e48 <myproc>
    800016e6:	fea488e3          	beq	s1,a0,800016d6 <wakeup+0x38>
      acquire(&p->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	aee080e7          	jalr	-1298(ra) # 800061da <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016f4:	4c9c                	lw	a5,24(s1)
    800016f6:	fd379be3          	bne	a5,s3,800016cc <wakeup+0x2e>
    800016fa:	709c                	ld	a5,32(s1)
    800016fc:	fd4798e3          	bne	a5,s4,800016cc <wakeup+0x2e>
    80001700:	b7e1                	j	800016c8 <wakeup+0x2a>
    }
  }
}
    80001702:	70e2                	ld	ra,56(sp)
    80001704:	7442                	ld	s0,48(sp)
    80001706:	74a2                	ld	s1,40(sp)
    80001708:	7902                	ld	s2,32(sp)
    8000170a:	69e2                	ld	s3,24(sp)
    8000170c:	6a42                	ld	s4,16(sp)
    8000170e:	6aa2                	ld	s5,8(sp)
    80001710:	6121                	addi	sp,sp,64
    80001712:	8082                	ret

0000000080001714 <reparent>:
{
    80001714:	7179                	addi	sp,sp,-48
    80001716:	f406                	sd	ra,40(sp)
    80001718:	f022                	sd	s0,32(sp)
    8000171a:	ec26                	sd	s1,24(sp)
    8000171c:	e84a                	sd	s2,16(sp)
    8000171e:	e44e                	sd	s3,8(sp)
    80001720:	e052                	sd	s4,0(sp)
    80001722:	1800                	addi	s0,sp,48
    80001724:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001726:	00008497          	auipc	s1,0x8
    8000172a:	d5a48493          	addi	s1,s1,-678 # 80009480 <proc>
      pp->parent = initproc;
    8000172e:	00008a17          	auipc	s4,0x8
    80001732:	8e2a0a13          	addi	s4,s4,-1822 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001736:	00012997          	auipc	s3,0x12
    8000173a:	54a98993          	addi	s3,s3,1354 # 80013c80 <tickslock>
    8000173e:	a029                	j	80001748 <reparent+0x34>
    80001740:	2a048493          	addi	s1,s1,672
    80001744:	01348d63          	beq	s1,s3,8000175e <reparent+0x4a>
    if(pp->parent == p){
    80001748:	7c9c                	ld	a5,56(s1)
    8000174a:	ff279be3          	bne	a5,s2,80001740 <reparent+0x2c>
      pp->parent = initproc;
    8000174e:	000a3503          	ld	a0,0(s4)
    80001752:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001754:	00000097          	auipc	ra,0x0
    80001758:	f4a080e7          	jalr	-182(ra) # 8000169e <wakeup>
    8000175c:	b7d5                	j	80001740 <reparent+0x2c>
}
    8000175e:	70a2                	ld	ra,40(sp)
    80001760:	7402                	ld	s0,32(sp)
    80001762:	64e2                	ld	s1,24(sp)
    80001764:	6942                	ld	s2,16(sp)
    80001766:	69a2                	ld	s3,8(sp)
    80001768:	6a02                	ld	s4,0(sp)
    8000176a:	6145                	addi	sp,sp,48
    8000176c:	8082                	ret

000000008000176e <exit>:
{
    8000176e:	7179                	addi	sp,sp,-48
    80001770:	f406                	sd	ra,40(sp)
    80001772:	f022                	sd	s0,32(sp)
    80001774:	ec26                	sd	s1,24(sp)
    80001776:	e84a                	sd	s2,16(sp)
    80001778:	e44e                	sd	s3,8(sp)
    8000177a:	e052                	sd	s4,0(sp)
    8000177c:	1800                	addi	s0,sp,48
    8000177e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001780:	fffff097          	auipc	ra,0xfffff
    80001784:	6c8080e7          	jalr	1736(ra) # 80000e48 <myproc>
    80001788:	89aa                	mv	s3,a0
  if(p == initproc)
    8000178a:	00008797          	auipc	a5,0x8
    8000178e:	8867b783          	ld	a5,-1914(a5) # 80009010 <initproc>
    80001792:	0d050493          	addi	s1,a0,208
    80001796:	15050913          	addi	s2,a0,336
    8000179a:	02a79363          	bne	a5,a0,800017c0 <exit+0x52>
    panic("init exiting");
    8000179e:	00007517          	auipc	a0,0x7
    800017a2:	a4250513          	addi	a0,a0,-1470 # 800081e0 <etext+0x1e0>
    800017a6:	00004097          	auipc	ra,0x4
    800017aa:	514080e7          	jalr	1300(ra) # 80005cba <panic>
      fileclose(f);
    800017ae:	00002097          	auipc	ra,0x2
    800017b2:	286080e7          	jalr	646(ra) # 80003a34 <fileclose>
      p->ofile[fd] = 0;
    800017b6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017ba:	04a1                	addi	s1,s1,8
    800017bc:	01248563          	beq	s1,s2,800017c6 <exit+0x58>
    if(p->ofile[fd]){
    800017c0:	6088                	ld	a0,0(s1)
    800017c2:	f575                	bnez	a0,800017ae <exit+0x40>
    800017c4:	bfdd                	j	800017ba <exit+0x4c>
  begin_op();
    800017c6:	00002097          	auipc	ra,0x2
    800017ca:	da2080e7          	jalr	-606(ra) # 80003568 <begin_op>
  iput(p->cwd);
    800017ce:	1509b503          	ld	a0,336(s3)
    800017d2:	00001097          	auipc	ra,0x1
    800017d6:	57e080e7          	jalr	1406(ra) # 80002d50 <iput>
  end_op();
    800017da:	00002097          	auipc	ra,0x2
    800017de:	e0e080e7          	jalr	-498(ra) # 800035e8 <end_op>
  p->cwd = 0;
    800017e2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017e6:	00008497          	auipc	s1,0x8
    800017ea:	88248493          	addi	s1,s1,-1918 # 80009068 <wait_lock>
    800017ee:	8526                	mv	a0,s1
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	9ea080e7          	jalr	-1558(ra) # 800061da <acquire>
  reparent(p);
    800017f8:	854e                	mv	a0,s3
    800017fa:	00000097          	auipc	ra,0x0
    800017fe:	f1a080e7          	jalr	-230(ra) # 80001714 <reparent>
  wakeup(p->parent);
    80001802:	0389b503          	ld	a0,56(s3)
    80001806:	00000097          	auipc	ra,0x0
    8000180a:	e98080e7          	jalr	-360(ra) # 8000169e <wakeup>
  acquire(&p->lock);
    8000180e:	854e                	mv	a0,s3
    80001810:	00005097          	auipc	ra,0x5
    80001814:	9ca080e7          	jalr	-1590(ra) # 800061da <acquire>
  p->xstate = status;
    80001818:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000181c:	4795                	li	a5,5
    8000181e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001822:	8526                	mv	a0,s1
    80001824:	00005097          	auipc	ra,0x5
    80001828:	a6a080e7          	jalr	-1430(ra) # 8000628e <release>
  sched();
    8000182c:	00000097          	auipc	ra,0x0
    80001830:	bd4080e7          	jalr	-1068(ra) # 80001400 <sched>
  panic("zombie exit");
    80001834:	00007517          	auipc	a0,0x7
    80001838:	9bc50513          	addi	a0,a0,-1604 # 800081f0 <etext+0x1f0>
    8000183c:	00004097          	auipc	ra,0x4
    80001840:	47e080e7          	jalr	1150(ra) # 80005cba <panic>

0000000080001844 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001844:	7179                	addi	sp,sp,-48
    80001846:	f406                	sd	ra,40(sp)
    80001848:	f022                	sd	s0,32(sp)
    8000184a:	ec26                	sd	s1,24(sp)
    8000184c:	e84a                	sd	s2,16(sp)
    8000184e:	e44e                	sd	s3,8(sp)
    80001850:	1800                	addi	s0,sp,48
    80001852:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001854:	00008497          	auipc	s1,0x8
    80001858:	c2c48493          	addi	s1,s1,-980 # 80009480 <proc>
    8000185c:	00012997          	auipc	s3,0x12
    80001860:	42498993          	addi	s3,s3,1060 # 80013c80 <tickslock>
    acquire(&p->lock);
    80001864:	8526                	mv	a0,s1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	974080e7          	jalr	-1676(ra) # 800061da <acquire>
    if(p->pid == pid){
    8000186e:	589c                	lw	a5,48(s1)
    80001870:	01278d63          	beq	a5,s2,8000188a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001874:	8526                	mv	a0,s1
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	a18080e7          	jalr	-1512(ra) # 8000628e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000187e:	2a048493          	addi	s1,s1,672
    80001882:	ff3491e3          	bne	s1,s3,80001864 <kill+0x20>
  }
  return -1;
    80001886:	557d                	li	a0,-1
    80001888:	a829                	j	800018a2 <kill+0x5e>
      p->killed = 1;
    8000188a:	4785                	li	a5,1
    8000188c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000188e:	4c98                	lw	a4,24(s1)
    80001890:	4789                	li	a5,2
    80001892:	00f70f63          	beq	a4,a5,800018b0 <kill+0x6c>
      release(&p->lock);
    80001896:	8526                	mv	a0,s1
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	9f6080e7          	jalr	-1546(ra) # 8000628e <release>
      return 0;
    800018a0:	4501                	li	a0,0
}
    800018a2:	70a2                	ld	ra,40(sp)
    800018a4:	7402                	ld	s0,32(sp)
    800018a6:	64e2                	ld	s1,24(sp)
    800018a8:	6942                	ld	s2,16(sp)
    800018aa:	69a2                	ld	s3,8(sp)
    800018ac:	6145                	addi	sp,sp,48
    800018ae:	8082                	ret
        p->state = RUNNABLE;
    800018b0:	478d                	li	a5,3
    800018b2:	cc9c                	sw	a5,24(s1)
    800018b4:	b7cd                	j	80001896 <kill+0x52>

00000000800018b6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018b6:	7179                	addi	sp,sp,-48
    800018b8:	f406                	sd	ra,40(sp)
    800018ba:	f022                	sd	s0,32(sp)
    800018bc:	ec26                	sd	s1,24(sp)
    800018be:	e84a                	sd	s2,16(sp)
    800018c0:	e44e                	sd	s3,8(sp)
    800018c2:	e052                	sd	s4,0(sp)
    800018c4:	1800                	addi	s0,sp,48
    800018c6:	84aa                	mv	s1,a0
    800018c8:	892e                	mv	s2,a1
    800018ca:	89b2                	mv	s3,a2
    800018cc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018ce:	fffff097          	auipc	ra,0xfffff
    800018d2:	57a080e7          	jalr	1402(ra) # 80000e48 <myproc>
  if(user_dst){
    800018d6:	c08d                	beqz	s1,800018f8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018d8:	86d2                	mv	a3,s4
    800018da:	864e                	mv	a2,s3
    800018dc:	85ca                	mv	a1,s2
    800018de:	6928                	ld	a0,80(a0)
    800018e0:	fffff097          	auipc	ra,0xfffff
    800018e4:	22a080e7          	jalr	554(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018e8:	70a2                	ld	ra,40(sp)
    800018ea:	7402                	ld	s0,32(sp)
    800018ec:	64e2                	ld	s1,24(sp)
    800018ee:	6942                	ld	s2,16(sp)
    800018f0:	69a2                	ld	s3,8(sp)
    800018f2:	6a02                	ld	s4,0(sp)
    800018f4:	6145                	addi	sp,sp,48
    800018f6:	8082                	ret
    memmove((char *)dst, src, len);
    800018f8:	000a061b          	sext.w	a2,s4
    800018fc:	85ce                	mv	a1,s3
    800018fe:	854a                	mv	a0,s2
    80001900:	fffff097          	auipc	ra,0xfffff
    80001904:	8d8080e7          	jalr	-1832(ra) # 800001d8 <memmove>
    return 0;
    80001908:	8526                	mv	a0,s1
    8000190a:	bff9                	j	800018e8 <either_copyout+0x32>

000000008000190c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000190c:	7179                	addi	sp,sp,-48
    8000190e:	f406                	sd	ra,40(sp)
    80001910:	f022                	sd	s0,32(sp)
    80001912:	ec26                	sd	s1,24(sp)
    80001914:	e84a                	sd	s2,16(sp)
    80001916:	e44e                	sd	s3,8(sp)
    80001918:	e052                	sd	s4,0(sp)
    8000191a:	1800                	addi	s0,sp,48
    8000191c:	892a                	mv	s2,a0
    8000191e:	84ae                	mv	s1,a1
    80001920:	89b2                	mv	s3,a2
    80001922:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	524080e7          	jalr	1316(ra) # 80000e48 <myproc>
  if(user_src){
    8000192c:	c08d                	beqz	s1,8000194e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000192e:	86d2                	mv	a3,s4
    80001930:	864e                	mv	a2,s3
    80001932:	85ca                	mv	a1,s2
    80001934:	6928                	ld	a0,80(a0)
    80001936:	fffff097          	auipc	ra,0xfffff
    8000193a:	260080e7          	jalr	608(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000193e:	70a2                	ld	ra,40(sp)
    80001940:	7402                	ld	s0,32(sp)
    80001942:	64e2                	ld	s1,24(sp)
    80001944:	6942                	ld	s2,16(sp)
    80001946:	69a2                	ld	s3,8(sp)
    80001948:	6a02                	ld	s4,0(sp)
    8000194a:	6145                	addi	sp,sp,48
    8000194c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000194e:	000a061b          	sext.w	a2,s4
    80001952:	85ce                	mv	a1,s3
    80001954:	854a                	mv	a0,s2
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	882080e7          	jalr	-1918(ra) # 800001d8 <memmove>
    return 0;
    8000195e:	8526                	mv	a0,s1
    80001960:	bff9                	j	8000193e <either_copyin+0x32>

0000000080001962 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001962:	715d                	addi	sp,sp,-80
    80001964:	e486                	sd	ra,72(sp)
    80001966:	e0a2                	sd	s0,64(sp)
    80001968:	fc26                	sd	s1,56(sp)
    8000196a:	f84a                	sd	s2,48(sp)
    8000196c:	f44e                	sd	s3,40(sp)
    8000196e:	f052                	sd	s4,32(sp)
    80001970:	ec56                	sd	s5,24(sp)
    80001972:	e85a                	sd	s6,16(sp)
    80001974:	e45e                	sd	s7,8(sp)
    80001976:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001978:	00006517          	auipc	a0,0x6
    8000197c:	6d050513          	addi	a0,a0,1744 # 80008048 <etext+0x48>
    80001980:	00004097          	auipc	ra,0x4
    80001984:	38c080e7          	jalr	908(ra) # 80005d0c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001988:	00008497          	auipc	s1,0x8
    8000198c:	c5048493          	addi	s1,s1,-944 # 800095d8 <proc+0x158>
    80001990:	00012917          	auipc	s2,0x12
    80001994:	44890913          	addi	s2,s2,1096 # 80013dd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001998:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000199a:	00007997          	auipc	s3,0x7
    8000199e:	86698993          	addi	s3,s3,-1946 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019a2:	00007a97          	auipc	s5,0x7
    800019a6:	866a8a93          	addi	s5,s5,-1946 # 80008208 <etext+0x208>
    printf("\n");
    800019aa:	00006a17          	auipc	s4,0x6
    800019ae:	69ea0a13          	addi	s4,s4,1694 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019b2:	00007b97          	auipc	s7,0x7
    800019b6:	88eb8b93          	addi	s7,s7,-1906 # 80008240 <states.1719>
    800019ba:	a00d                	j	800019dc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019bc:	ed86a583          	lw	a1,-296(a3)
    800019c0:	8556                	mv	a0,s5
    800019c2:	00004097          	auipc	ra,0x4
    800019c6:	34a080e7          	jalr	842(ra) # 80005d0c <printf>
    printf("\n");
    800019ca:	8552                	mv	a0,s4
    800019cc:	00004097          	auipc	ra,0x4
    800019d0:	340080e7          	jalr	832(ra) # 80005d0c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d4:	2a048493          	addi	s1,s1,672
    800019d8:	03248163          	beq	s1,s2,800019fa <procdump+0x98>
    if(p->state == UNUSED)
    800019dc:	86a6                	mv	a3,s1
    800019de:	ec04a783          	lw	a5,-320(s1)
    800019e2:	dbed                	beqz	a5,800019d4 <procdump+0x72>
      state = "???";
    800019e4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e6:	fcfb6be3          	bltu	s6,a5,800019bc <procdump+0x5a>
    800019ea:	1782                	slli	a5,a5,0x20
    800019ec:	9381                	srli	a5,a5,0x20
    800019ee:	078e                	slli	a5,a5,0x3
    800019f0:	97de                	add	a5,a5,s7
    800019f2:	6390                	ld	a2,0(a5)
    800019f4:	f661                	bnez	a2,800019bc <procdump+0x5a>
      state = "???";
    800019f6:	864e                	mv	a2,s3
    800019f8:	b7d1                	j	800019bc <procdump+0x5a>
  }
    800019fa:	60a6                	ld	ra,72(sp)
    800019fc:	6406                	ld	s0,64(sp)
    800019fe:	74e2                	ld	s1,56(sp)
    80001a00:	7942                	ld	s2,48(sp)
    80001a02:	79a2                	ld	s3,40(sp)
    80001a04:	7a02                	ld	s4,32(sp)
    80001a06:	6ae2                	ld	s5,24(sp)
    80001a08:	6b42                	ld	s6,16(sp)
    80001a0a:	6ba2                	ld	s7,8(sp)
    80001a0c:	6161                	addi	sp,sp,80
    80001a0e:	8082                	ret

0000000080001a10 <swtch>:
    80001a10:	00153023          	sd	ra,0(a0)
    80001a14:	00253423          	sd	sp,8(a0)
    80001a18:	e900                	sd	s0,16(a0)
    80001a1a:	ed04                	sd	s1,24(a0)
    80001a1c:	03253023          	sd	s2,32(a0)
    80001a20:	03353423          	sd	s3,40(a0)
    80001a24:	03453823          	sd	s4,48(a0)
    80001a28:	03553c23          	sd	s5,56(a0)
    80001a2c:	05653023          	sd	s6,64(a0)
    80001a30:	05753423          	sd	s7,72(a0)
    80001a34:	05853823          	sd	s8,80(a0)
    80001a38:	05953c23          	sd	s9,88(a0)
    80001a3c:	07a53023          	sd	s10,96(a0)
    80001a40:	07b53423          	sd	s11,104(a0)
    80001a44:	0005b083          	ld	ra,0(a1)
    80001a48:	0085b103          	ld	sp,8(a1)
    80001a4c:	6980                	ld	s0,16(a1)
    80001a4e:	6d84                	ld	s1,24(a1)
    80001a50:	0205b903          	ld	s2,32(a1)
    80001a54:	0285b983          	ld	s3,40(a1)
    80001a58:	0305ba03          	ld	s4,48(a1)
    80001a5c:	0385ba83          	ld	s5,56(a1)
    80001a60:	0405bb03          	ld	s6,64(a1)
    80001a64:	0485bb83          	ld	s7,72(a1)
    80001a68:	0505bc03          	ld	s8,80(a1)
    80001a6c:	0585bc83          	ld	s9,88(a1)
    80001a70:	0605bd03          	ld	s10,96(a1)
    80001a74:	0685bd83          	ld	s11,104(a1)
    80001a78:	8082                	ret

0000000080001a7a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a7a:	1141                	addi	sp,sp,-16
    80001a7c:	e406                	sd	ra,8(sp)
    80001a7e:	e022                	sd	s0,0(sp)
    80001a80:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a82:	00006597          	auipc	a1,0x6
    80001a86:	7ee58593          	addi	a1,a1,2030 # 80008270 <states.1719+0x30>
    80001a8a:	00012517          	auipc	a0,0x12
    80001a8e:	1f650513          	addi	a0,a0,502 # 80013c80 <tickslock>
    80001a92:	00004097          	auipc	ra,0x4
    80001a96:	6b8080e7          	jalr	1720(ra) # 8000614a <initlock>
}
    80001a9a:	60a2                	ld	ra,8(sp)
    80001a9c:	6402                	ld	s0,0(sp)
    80001a9e:	0141                	addi	sp,sp,16
    80001aa0:	8082                	ret

0000000080001aa2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aa2:	1141                	addi	sp,sp,-16
    80001aa4:	e422                	sd	s0,8(sp)
    80001aa6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa8:	00003797          	auipc	a5,0x3
    80001aac:	5a878793          	addi	a5,a5,1448 # 80005050 <kernelvec>
    80001ab0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ab4:	6422                	ld	s0,8(sp)
    80001ab6:	0141                	addi	sp,sp,16
    80001ab8:	8082                	ret

0000000080001aba <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aba:	1141                	addi	sp,sp,-16
    80001abc:	e406                	sd	ra,8(sp)
    80001abe:	e022                	sd	s0,0(sp)
    80001ac0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ac2:	fffff097          	auipc	ra,0xfffff
    80001ac6:	386080e7          	jalr	902(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ace:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ad4:	00005617          	auipc	a2,0x5
    80001ad8:	52c60613          	addi	a2,a2,1324 # 80007000 <_trampoline>
    80001adc:	00005697          	auipc	a3,0x5
    80001ae0:	52468693          	addi	a3,a3,1316 # 80007000 <_trampoline>
    80001ae4:	8e91                	sub	a3,a3,a2
    80001ae6:	040007b7          	lui	a5,0x4000
    80001aea:	17fd                	addi	a5,a5,-1
    80001aec:	07b2                	slli	a5,a5,0xc
    80001aee:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af0:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001af4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001af6:	180026f3          	csrr	a3,satp
    80001afa:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001afc:	6d38                	ld	a4,88(a0)
    80001afe:	6134                	ld	a3,64(a0)
    80001b00:	6585                	lui	a1,0x1
    80001b02:	96ae                	add	a3,a3,a1
    80001b04:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b06:	6d38                	ld	a4,88(a0)
    80001b08:	00000697          	auipc	a3,0x0
    80001b0c:	13868693          	addi	a3,a3,312 # 80001c40 <usertrap>
    80001b10:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b12:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b14:	8692                	mv	a3,tp
    80001b16:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b18:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b1c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b20:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b24:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b28:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b2a:	6f18                	ld	a4,24(a4)
    80001b2c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b30:	692c                	ld	a1,80(a0)
    80001b32:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b34:	00005717          	auipc	a4,0x5
    80001b38:	55c70713          	addi	a4,a4,1372 # 80007090 <userret>
    80001b3c:	8f11                	sub	a4,a4,a2
    80001b3e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b40:	577d                	li	a4,-1
    80001b42:	177e                	slli	a4,a4,0x3f
    80001b44:	8dd9                	or	a1,a1,a4
    80001b46:	02000537          	lui	a0,0x2000
    80001b4a:	157d                	addi	a0,a0,-1
    80001b4c:	0536                	slli	a0,a0,0xd
    80001b4e:	9782                	jalr	a5
}
    80001b50:	60a2                	ld	ra,8(sp)
    80001b52:	6402                	ld	s0,0(sp)
    80001b54:	0141                	addi	sp,sp,16
    80001b56:	8082                	ret

0000000080001b58 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b58:	1101                	addi	sp,sp,-32
    80001b5a:	ec06                	sd	ra,24(sp)
    80001b5c:	e822                	sd	s0,16(sp)
    80001b5e:	e426                	sd	s1,8(sp)
    80001b60:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b62:	00012497          	auipc	s1,0x12
    80001b66:	11e48493          	addi	s1,s1,286 # 80013c80 <tickslock>
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	00004097          	auipc	ra,0x4
    80001b70:	66e080e7          	jalr	1646(ra) # 800061da <acquire>
  ticks++;
    80001b74:	00007517          	auipc	a0,0x7
    80001b78:	4a450513          	addi	a0,a0,1188 # 80009018 <ticks>
    80001b7c:	411c                	lw	a5,0(a0)
    80001b7e:	2785                	addiw	a5,a5,1
    80001b80:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b82:	00000097          	auipc	ra,0x0
    80001b86:	b1c080e7          	jalr	-1252(ra) # 8000169e <wakeup>
  release(&tickslock);
    80001b8a:	8526                	mv	a0,s1
    80001b8c:	00004097          	auipc	ra,0x4
    80001b90:	702080e7          	jalr	1794(ra) # 8000628e <release>
}
    80001b94:	60e2                	ld	ra,24(sp)
    80001b96:	6442                	ld	s0,16(sp)
    80001b98:	64a2                	ld	s1,8(sp)
    80001b9a:	6105                	addi	sp,sp,32
    80001b9c:	8082                	ret

0000000080001b9e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bac:	00074d63          	bltz	a4,80001bc6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bb0:	57fd                	li	a5,-1
    80001bb2:	17fe                	slli	a5,a5,0x3f
    80001bb4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bb6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bb8:	06f70363          	beq	a4,a5,80001c1e <devintr+0x80>
  }
}
    80001bbc:	60e2                	ld	ra,24(sp)
    80001bbe:	6442                	ld	s0,16(sp)
    80001bc0:	64a2                	ld	s1,8(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret
     (scause & 0xff) == 9){
    80001bc6:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bca:	46a5                	li	a3,9
    80001bcc:	fed792e3          	bne	a5,a3,80001bb0 <devintr+0x12>
    int irq = plic_claim();
    80001bd0:	00003097          	auipc	ra,0x3
    80001bd4:	588080e7          	jalr	1416(ra) # 80005158 <plic_claim>
    80001bd8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bda:	47a9                	li	a5,10
    80001bdc:	02f50763          	beq	a0,a5,80001c0a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001be0:	4785                	li	a5,1
    80001be2:	02f50963          	beq	a0,a5,80001c14 <devintr+0x76>
    return 1;
    80001be6:	4505                	li	a0,1
    } else if(irq){
    80001be8:	d8f1                	beqz	s1,80001bbc <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bea:	85a6                	mv	a1,s1
    80001bec:	00006517          	auipc	a0,0x6
    80001bf0:	68c50513          	addi	a0,a0,1676 # 80008278 <states.1719+0x38>
    80001bf4:	00004097          	auipc	ra,0x4
    80001bf8:	118080e7          	jalr	280(ra) # 80005d0c <printf>
      plic_complete(irq);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	00003097          	auipc	ra,0x3
    80001c02:	57e080e7          	jalr	1406(ra) # 8000517c <plic_complete>
    return 1;
    80001c06:	4505                	li	a0,1
    80001c08:	bf55                	j	80001bbc <devintr+0x1e>
      uartintr();
    80001c0a:	00004097          	auipc	ra,0x4
    80001c0e:	4f0080e7          	jalr	1264(ra) # 800060fa <uartintr>
    80001c12:	b7ed                	j	80001bfc <devintr+0x5e>
      virtio_disk_intr();
    80001c14:	00004097          	auipc	ra,0x4
    80001c18:	a48080e7          	jalr	-1464(ra) # 8000565c <virtio_disk_intr>
    80001c1c:	b7c5                	j	80001bfc <devintr+0x5e>
    if(cpuid() == 0){
    80001c1e:	fffff097          	auipc	ra,0xfffff
    80001c22:	1fe080e7          	jalr	510(ra) # 80000e1c <cpuid>
    80001c26:	c901                	beqz	a0,80001c36 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c28:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c2c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c2e:	14479073          	csrw	sip,a5
    return 2;
    80001c32:	4509                	li	a0,2
    80001c34:	b761                	j	80001bbc <devintr+0x1e>
      clockintr();
    80001c36:	00000097          	auipc	ra,0x0
    80001c3a:	f22080e7          	jalr	-222(ra) # 80001b58 <clockintr>
    80001c3e:	b7ed                	j	80001c28 <devintr+0x8a>

0000000080001c40 <usertrap>:
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	e04a                	sd	s2,0(sp)
    80001c4a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c4c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c50:	1007f793          	andi	a5,a5,256
    80001c54:	e3ad                	bnez	a5,80001cb6 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c56:	00003797          	auipc	a5,0x3
    80001c5a:	3fa78793          	addi	a5,a5,1018 # 80005050 <kernelvec>
    80001c5e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	1e6080e7          	jalr	486(ra) # 80000e48 <myproc>
    80001c6a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c6c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c6e:	14102773          	csrr	a4,sepc
    80001c72:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c74:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c78:	47a1                	li	a5,8
    80001c7a:	04f71c63          	bne	a4,a5,80001cd2 <usertrap+0x92>
    if(p->killed)
    80001c7e:	551c                	lw	a5,40(a0)
    80001c80:	e3b9                	bnez	a5,80001cc6 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c82:	6cb8                	ld	a4,88(s1)
    80001c84:	6f1c                	ld	a5,24(a4)
    80001c86:	0791                	addi	a5,a5,4
    80001c88:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c8e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c92:	10079073          	csrw	sstatus,a5
    syscall();
    80001c96:	00000097          	auipc	ra,0x0
    80001c9a:	348080e7          	jalr	840(ra) # 80001fde <syscall>
  if(p->killed)
    80001c9e:	549c                	lw	a5,40(s1)
    80001ca0:	efc5                	bnez	a5,80001d58 <usertrap+0x118>
  usertrapret();
    80001ca2:	00000097          	auipc	ra,0x0
    80001ca6:	e18080e7          	jalr	-488(ra) # 80001aba <usertrapret>
}
    80001caa:	60e2                	ld	ra,24(sp)
    80001cac:	6442                	ld	s0,16(sp)
    80001cae:	64a2                	ld	s1,8(sp)
    80001cb0:	6902                	ld	s2,0(sp)
    80001cb2:	6105                	addi	sp,sp,32
    80001cb4:	8082                	ret
    panic("usertrap: not from user mode");
    80001cb6:	00006517          	auipc	a0,0x6
    80001cba:	5e250513          	addi	a0,a0,1506 # 80008298 <states.1719+0x58>
    80001cbe:	00004097          	auipc	ra,0x4
    80001cc2:	ffc080e7          	jalr	-4(ra) # 80005cba <panic>
      exit(-1);
    80001cc6:	557d                	li	a0,-1
    80001cc8:	00000097          	auipc	ra,0x0
    80001ccc:	aa6080e7          	jalr	-1370(ra) # 8000176e <exit>
    80001cd0:	bf4d                	j	80001c82 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	ecc080e7          	jalr	-308(ra) # 80001b9e <devintr>
    80001cda:	892a                	mv	s2,a0
    80001cdc:	c501                	beqz	a0,80001ce4 <usertrap+0xa4>
  if(p->killed)
    80001cde:	549c                	lw	a5,40(s1)
    80001ce0:	c3a1                	beqz	a5,80001d20 <usertrap+0xe0>
    80001ce2:	a815                	j	80001d16 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ce4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ce8:	5890                	lw	a2,48(s1)
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	5ce50513          	addi	a0,a0,1486 # 800082b8 <states.1719+0x78>
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	01a080e7          	jalr	26(ra) # 80005d0c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cfa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cfe:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d02:	00006517          	auipc	a0,0x6
    80001d06:	5e650513          	addi	a0,a0,1510 # 800082e8 <states.1719+0xa8>
    80001d0a:	00004097          	auipc	ra,0x4
    80001d0e:	002080e7          	jalr	2(ra) # 80005d0c <printf>
    p->killed = 1;
    80001d12:	4785                	li	a5,1
    80001d14:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d16:	557d                	li	a0,-1
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	a56080e7          	jalr	-1450(ra) # 8000176e <exit>
  if(which_dev == 2)
    80001d20:	4789                	li	a5,2
    80001d22:	f8f910e3          	bne	s2,a5,80001ca2 <usertrap+0x62>
    p->alarmticks += 1;
    80001d26:	16c4a783          	lw	a5,364(s1)
    80001d2a:	2785                	addiw	a5,a5,1
    80001d2c:	0007871b          	sext.w	a4,a5
    80001d30:	16f4a623          	sw	a5,364(s1)
    if ((p->alarmticks >= p->alarminterval) && (p->alarminterval > 0))
    80001d34:	1684a783          	lw	a5,360(s1)
    80001d38:	00f74b63          	blt	a4,a5,80001d4e <usertrap+0x10e>
    80001d3c:	00f05963          	blez	a5,80001d4e <usertrap+0x10e>
      p->alarmticks = 0;
    80001d40:	1604a623          	sw	zero,364(s1)
      if (p->sigreturned == 1)
    80001d44:	2984a703          	lw	a4,664(s1)
    80001d48:	4785                	li	a5,1
    80001d4a:	00f70963          	beq	a4,a5,80001d5c <usertrap+0x11c>
    yield();
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	788080e7          	jalr	1928(ra) # 800014d6 <yield>
    80001d56:	b7b1                	j	80001ca2 <usertrap+0x62>
  int which_dev = 0;
    80001d58:	4901                	li	s2,0
    80001d5a:	bf75                	j	80001d16 <usertrap+0xd6>
        p->alarmtrapframe = *(p->trapframe);
    80001d5c:	0584b803          	ld	a6,88(s1)
    80001d60:	87c2                	mv	a5,a6
    80001d62:	17848713          	addi	a4,s1,376
    80001d66:	12080893          	addi	a7,a6,288
    80001d6a:	6388                	ld	a0,0(a5)
    80001d6c:	678c                	ld	a1,8(a5)
    80001d6e:	6b90                	ld	a2,16(a5)
    80001d70:	6f94                	ld	a3,24(a5)
    80001d72:	e308                	sd	a0,0(a4)
    80001d74:	e70c                	sd	a1,8(a4)
    80001d76:	eb10                	sd	a2,16(a4)
    80001d78:	ef14                	sd	a3,24(a4)
    80001d7a:	02078793          	addi	a5,a5,32
    80001d7e:	02070713          	addi	a4,a4,32
    80001d82:	ff1794e3          	bne	a5,a7,80001d6a <usertrap+0x12a>
        p->trapframe->epc = (uint64)p->alarmhandler;
    80001d86:	1704b783          	ld	a5,368(s1)
    80001d8a:	00f83c23          	sd	a5,24(a6)
        p->sigreturned = 0;
    80001d8e:	2804ac23          	sw	zero,664(s1)
        usertrapret();
    80001d92:	00000097          	auipc	ra,0x0
    80001d96:	d28080e7          	jalr	-728(ra) # 80001aba <usertrapret>
    80001d9a:	bf55                	j	80001d4e <usertrap+0x10e>

0000000080001d9c <kerneltrap>:
{
    80001d9c:	7179                	addi	sp,sp,-48
    80001d9e:	f406                	sd	ra,40(sp)
    80001da0:	f022                	sd	s0,32(sp)
    80001da2:	ec26                	sd	s1,24(sp)
    80001da4:	e84a                	sd	s2,16(sp)
    80001da6:	e44e                	sd	s3,8(sp)
    80001da8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001daa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dae:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001db6:	1004f793          	andi	a5,s1,256
    80001dba:	cb85                	beqz	a5,80001dea <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dbc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dc0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dc2:	ef85                	bnez	a5,80001dfa <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dc4:	00000097          	auipc	ra,0x0
    80001dc8:	dda080e7          	jalr	-550(ra) # 80001b9e <devintr>
    80001dcc:	cd1d                	beqz	a0,80001e0a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dce:	4789                	li	a5,2
    80001dd0:	06f50a63          	beq	a0,a5,80001e44 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dd4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd8:	10049073          	csrw	sstatus,s1
}
    80001ddc:	70a2                	ld	ra,40(sp)
    80001dde:	7402                	ld	s0,32(sp)
    80001de0:	64e2                	ld	s1,24(sp)
    80001de2:	6942                	ld	s2,16(sp)
    80001de4:	69a2                	ld	s3,8(sp)
    80001de6:	6145                	addi	sp,sp,48
    80001de8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dea:	00006517          	auipc	a0,0x6
    80001dee:	51e50513          	addi	a0,a0,1310 # 80008308 <states.1719+0xc8>
    80001df2:	00004097          	auipc	ra,0x4
    80001df6:	ec8080e7          	jalr	-312(ra) # 80005cba <panic>
    panic("kerneltrap: interrupts enabled");
    80001dfa:	00006517          	auipc	a0,0x6
    80001dfe:	53650513          	addi	a0,a0,1334 # 80008330 <states.1719+0xf0>
    80001e02:	00004097          	auipc	ra,0x4
    80001e06:	eb8080e7          	jalr	-328(ra) # 80005cba <panic>
    printf("scause %p\n", scause);
    80001e0a:	85ce                	mv	a1,s3
    80001e0c:	00006517          	auipc	a0,0x6
    80001e10:	54450513          	addi	a0,a0,1348 # 80008350 <states.1719+0x110>
    80001e14:	00004097          	auipc	ra,0x4
    80001e18:	ef8080e7          	jalr	-264(ra) # 80005d0c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e1c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e20:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e24:	00006517          	auipc	a0,0x6
    80001e28:	53c50513          	addi	a0,a0,1340 # 80008360 <states.1719+0x120>
    80001e2c:	00004097          	auipc	ra,0x4
    80001e30:	ee0080e7          	jalr	-288(ra) # 80005d0c <printf>
    panic("kerneltrap");
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	54450513          	addi	a0,a0,1348 # 80008378 <states.1719+0x138>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	e7e080e7          	jalr	-386(ra) # 80005cba <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	004080e7          	jalr	4(ra) # 80000e48 <myproc>
    80001e4c:	d541                	beqz	a0,80001dd4 <kerneltrap+0x38>
    80001e4e:	fffff097          	auipc	ra,0xfffff
    80001e52:	ffa080e7          	jalr	-6(ra) # 80000e48 <myproc>
    80001e56:	4d18                	lw	a4,24(a0)
    80001e58:	4791                	li	a5,4
    80001e5a:	f6f71de3          	bne	a4,a5,80001dd4 <kerneltrap+0x38>
    yield();
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	678080e7          	jalr	1656(ra) # 800014d6 <yield>
    80001e66:	b7bd                	j	80001dd4 <kerneltrap+0x38>

0000000080001e68 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e68:	1101                	addi	sp,sp,-32
    80001e6a:	ec06                	sd	ra,24(sp)
    80001e6c:	e822                	sd	s0,16(sp)
    80001e6e:	e426                	sd	s1,8(sp)
    80001e70:	1000                	addi	s0,sp,32
    80001e72:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	fd4080e7          	jalr	-44(ra) # 80000e48 <myproc>
  switch (n) {
    80001e7c:	4795                	li	a5,5
    80001e7e:	0497e163          	bltu	a5,s1,80001ec0 <argraw+0x58>
    80001e82:	048a                	slli	s1,s1,0x2
    80001e84:	00006717          	auipc	a4,0x6
    80001e88:	52c70713          	addi	a4,a4,1324 # 800083b0 <states.1719+0x170>
    80001e8c:	94ba                	add	s1,s1,a4
    80001e8e:	409c                	lw	a5,0(s1)
    80001e90:	97ba                	add	a5,a5,a4
    80001e92:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e94:	6d3c                	ld	a5,88(a0)
    80001e96:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e98:	60e2                	ld	ra,24(sp)
    80001e9a:	6442                	ld	s0,16(sp)
    80001e9c:	64a2                	ld	s1,8(sp)
    80001e9e:	6105                	addi	sp,sp,32
    80001ea0:	8082                	ret
    return p->trapframe->a1;
    80001ea2:	6d3c                	ld	a5,88(a0)
    80001ea4:	7fa8                	ld	a0,120(a5)
    80001ea6:	bfcd                	j	80001e98 <argraw+0x30>
    return p->trapframe->a2;
    80001ea8:	6d3c                	ld	a5,88(a0)
    80001eaa:	63c8                	ld	a0,128(a5)
    80001eac:	b7f5                	j	80001e98 <argraw+0x30>
    return p->trapframe->a3;
    80001eae:	6d3c                	ld	a5,88(a0)
    80001eb0:	67c8                	ld	a0,136(a5)
    80001eb2:	b7dd                	j	80001e98 <argraw+0x30>
    return p->trapframe->a4;
    80001eb4:	6d3c                	ld	a5,88(a0)
    80001eb6:	6bc8                	ld	a0,144(a5)
    80001eb8:	b7c5                	j	80001e98 <argraw+0x30>
    return p->trapframe->a5;
    80001eba:	6d3c                	ld	a5,88(a0)
    80001ebc:	6fc8                	ld	a0,152(a5)
    80001ebe:	bfe9                	j	80001e98 <argraw+0x30>
  panic("argraw");
    80001ec0:	00006517          	auipc	a0,0x6
    80001ec4:	4c850513          	addi	a0,a0,1224 # 80008388 <states.1719+0x148>
    80001ec8:	00004097          	auipc	ra,0x4
    80001ecc:	df2080e7          	jalr	-526(ra) # 80005cba <panic>

0000000080001ed0 <fetchaddr>:
{
    80001ed0:	1101                	addi	sp,sp,-32
    80001ed2:	ec06                	sd	ra,24(sp)
    80001ed4:	e822                	sd	s0,16(sp)
    80001ed6:	e426                	sd	s1,8(sp)
    80001ed8:	e04a                	sd	s2,0(sp)
    80001eda:	1000                	addi	s0,sp,32
    80001edc:	84aa                	mv	s1,a0
    80001ede:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ee0:	fffff097          	auipc	ra,0xfffff
    80001ee4:	f68080e7          	jalr	-152(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ee8:	653c                	ld	a5,72(a0)
    80001eea:	02f4f863          	bgeu	s1,a5,80001f1a <fetchaddr+0x4a>
    80001eee:	00848713          	addi	a4,s1,8
    80001ef2:	02e7e663          	bltu	a5,a4,80001f1e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ef6:	46a1                	li	a3,8
    80001ef8:	8626                	mv	a2,s1
    80001efa:	85ca                	mv	a1,s2
    80001efc:	6928                	ld	a0,80(a0)
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	c98080e7          	jalr	-872(ra) # 80000b96 <copyin>
    80001f06:	00a03533          	snez	a0,a0
    80001f0a:	40a00533          	neg	a0,a0
}
    80001f0e:	60e2                	ld	ra,24(sp)
    80001f10:	6442                	ld	s0,16(sp)
    80001f12:	64a2                	ld	s1,8(sp)
    80001f14:	6902                	ld	s2,0(sp)
    80001f16:	6105                	addi	sp,sp,32
    80001f18:	8082                	ret
    return -1;
    80001f1a:	557d                	li	a0,-1
    80001f1c:	bfcd                	j	80001f0e <fetchaddr+0x3e>
    80001f1e:	557d                	li	a0,-1
    80001f20:	b7fd                	j	80001f0e <fetchaddr+0x3e>

0000000080001f22 <fetchstr>:
{
    80001f22:	7179                	addi	sp,sp,-48
    80001f24:	f406                	sd	ra,40(sp)
    80001f26:	f022                	sd	s0,32(sp)
    80001f28:	ec26                	sd	s1,24(sp)
    80001f2a:	e84a                	sd	s2,16(sp)
    80001f2c:	e44e                	sd	s3,8(sp)
    80001f2e:	1800                	addi	s0,sp,48
    80001f30:	892a                	mv	s2,a0
    80001f32:	84ae                	mv	s1,a1
    80001f34:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	f12080e7          	jalr	-238(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f3e:	86ce                	mv	a3,s3
    80001f40:	864a                	mv	a2,s2
    80001f42:	85a6                	mv	a1,s1
    80001f44:	6928                	ld	a0,80(a0)
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	cdc080e7          	jalr	-804(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001f4e:	00054763          	bltz	a0,80001f5c <fetchstr+0x3a>
  return strlen(buf);
    80001f52:	8526                	mv	a0,s1
    80001f54:	ffffe097          	auipc	ra,0xffffe
    80001f58:	3a8080e7          	jalr	936(ra) # 800002fc <strlen>
}
    80001f5c:	70a2                	ld	ra,40(sp)
    80001f5e:	7402                	ld	s0,32(sp)
    80001f60:	64e2                	ld	s1,24(sp)
    80001f62:	6942                	ld	s2,16(sp)
    80001f64:	69a2                	ld	s3,8(sp)
    80001f66:	6145                	addi	sp,sp,48
    80001f68:	8082                	ret

0000000080001f6a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f6a:	1101                	addi	sp,sp,-32
    80001f6c:	ec06                	sd	ra,24(sp)
    80001f6e:	e822                	sd	s0,16(sp)
    80001f70:	e426                	sd	s1,8(sp)
    80001f72:	1000                	addi	s0,sp,32
    80001f74:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f76:	00000097          	auipc	ra,0x0
    80001f7a:	ef2080e7          	jalr	-270(ra) # 80001e68 <argraw>
    80001f7e:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f80:	4501                	li	a0,0
    80001f82:	60e2                	ld	ra,24(sp)
    80001f84:	6442                	ld	s0,16(sp)
    80001f86:	64a2                	ld	s1,8(sp)
    80001f88:	6105                	addi	sp,sp,32
    80001f8a:	8082                	ret

0000000080001f8c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f8c:	1101                	addi	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	e426                	sd	s1,8(sp)
    80001f94:	1000                	addi	s0,sp,32
    80001f96:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f98:	00000097          	auipc	ra,0x0
    80001f9c:	ed0080e7          	jalr	-304(ra) # 80001e68 <argraw>
    80001fa0:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fa2:	4501                	li	a0,0
    80001fa4:	60e2                	ld	ra,24(sp)
    80001fa6:	6442                	ld	s0,16(sp)
    80001fa8:	64a2                	ld	s1,8(sp)
    80001faa:	6105                	addi	sp,sp,32
    80001fac:	8082                	ret

0000000080001fae <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fae:	1101                	addi	sp,sp,-32
    80001fb0:	ec06                	sd	ra,24(sp)
    80001fb2:	e822                	sd	s0,16(sp)
    80001fb4:	e426                	sd	s1,8(sp)
    80001fb6:	e04a                	sd	s2,0(sp)
    80001fb8:	1000                	addi	s0,sp,32
    80001fba:	84ae                	mv	s1,a1
    80001fbc:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fbe:	00000097          	auipc	ra,0x0
    80001fc2:	eaa080e7          	jalr	-342(ra) # 80001e68 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fc6:	864a                	mv	a2,s2
    80001fc8:	85a6                	mv	a1,s1
    80001fca:	00000097          	auipc	ra,0x0
    80001fce:	f58080e7          	jalr	-168(ra) # 80001f22 <fetchstr>
}
    80001fd2:	60e2                	ld	ra,24(sp)
    80001fd4:	6442                	ld	s0,16(sp)
    80001fd6:	64a2                	ld	s1,8(sp)
    80001fd8:	6902                	ld	s2,0(sp)
    80001fda:	6105                	addi	sp,sp,32
    80001fdc:	8082                	ret

0000000080001fde <syscall>:
[SYS_sigreturn]   sys_sigreturn,
};

void
syscall(void)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	e04a                	sd	s2,0(sp)
    80001fe8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	e5e080e7          	jalr	-418(ra) # 80000e48 <myproc>
    80001ff2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ff4:	05853903          	ld	s2,88(a0)
    80001ff8:	0a893783          	ld	a5,168(s2)
    80001ffc:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002000:	37fd                	addiw	a5,a5,-1
    80002002:	4759                	li	a4,22
    80002004:	00f76f63          	bltu	a4,a5,80002022 <syscall+0x44>
    80002008:	00369713          	slli	a4,a3,0x3
    8000200c:	00006797          	auipc	a5,0x6
    80002010:	3bc78793          	addi	a5,a5,956 # 800083c8 <syscalls>
    80002014:	97ba                	add	a5,a5,a4
    80002016:	639c                	ld	a5,0(a5)
    80002018:	c789                	beqz	a5,80002022 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000201a:	9782                	jalr	a5
    8000201c:	06a93823          	sd	a0,112(s2)
    80002020:	a839                	j	8000203e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002022:	15848613          	addi	a2,s1,344
    80002026:	588c                	lw	a1,48(s1)
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	36850513          	addi	a0,a0,872 # 80008390 <states.1719+0x150>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	cdc080e7          	jalr	-804(ra) # 80005d0c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002038:	6cbc                	ld	a5,88(s1)
    8000203a:	577d                	li	a4,-1
    8000203c:	fbb8                	sd	a4,112(a5)
  }
    8000203e:	60e2                	ld	ra,24(sp)
    80002040:	6442                	ld	s0,16(sp)
    80002042:	64a2                	ld	s1,8(sp)
    80002044:	6902                	ld	s2,0(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002052:	fec40593          	addi	a1,s0,-20
    80002056:	4501                	li	a0,0
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	f12080e7          	jalr	-238(ra) # 80001f6a <argint>
    return -1;
    80002060:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002062:	00054963          	bltz	a0,80002074 <sys_exit+0x2a>
  exit(n);
    80002066:	fec42503          	lw	a0,-20(s0)
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	704080e7          	jalr	1796(ra) # 8000176e <exit>
  return 0;  // not reached
    80002072:	4781                	li	a5,0
}
    80002074:	853e                	mv	a0,a5
    80002076:	60e2                	ld	ra,24(sp)
    80002078:	6442                	ld	s0,16(sp)
    8000207a:	6105                	addi	sp,sp,32
    8000207c:	8082                	ret

000000008000207e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000207e:	1141                	addi	sp,sp,-16
    80002080:	e406                	sd	ra,8(sp)
    80002082:	e022                	sd	s0,0(sp)
    80002084:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	dc2080e7          	jalr	-574(ra) # 80000e48 <myproc>
}
    8000208e:	5908                	lw	a0,48(a0)
    80002090:	60a2                	ld	ra,8(sp)
    80002092:	6402                	ld	s0,0(sp)
    80002094:	0141                	addi	sp,sp,16
    80002096:	8082                	ret

0000000080002098 <sys_fork>:

uint64
sys_fork(void)
{
    80002098:	1141                	addi	sp,sp,-16
    8000209a:	e406                	sd	ra,8(sp)
    8000209c:	e022                	sd	s0,0(sp)
    8000209e:	0800                	addi	s0,sp,16
  return fork();
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	184080e7          	jalr	388(ra) # 80001224 <fork>
}
    800020a8:	60a2                	ld	ra,8(sp)
    800020aa:	6402                	ld	s0,0(sp)
    800020ac:	0141                	addi	sp,sp,16
    800020ae:	8082                	ret

00000000800020b0 <sys_wait>:

uint64
sys_wait(void)
{
    800020b0:	1101                	addi	sp,sp,-32
    800020b2:	ec06                	sd	ra,24(sp)
    800020b4:	e822                	sd	s0,16(sp)
    800020b6:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020b8:	fe840593          	addi	a1,s0,-24
    800020bc:	4501                	li	a0,0
    800020be:	00000097          	auipc	ra,0x0
    800020c2:	ece080e7          	jalr	-306(ra) # 80001f8c <argaddr>
    800020c6:	87aa                	mv	a5,a0
    return -1;
    800020c8:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020ca:	0007c863          	bltz	a5,800020da <sys_wait+0x2a>
  return wait(p);
    800020ce:	fe843503          	ld	a0,-24(s0)
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	4a4080e7          	jalr	1188(ra) # 80001576 <wait>
}
    800020da:	60e2                	ld	ra,24(sp)
    800020dc:	6442                	ld	s0,16(sp)
    800020de:	6105                	addi	sp,sp,32
    800020e0:	8082                	ret

00000000800020e2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020e2:	7179                	addi	sp,sp,-48
    800020e4:	f406                	sd	ra,40(sp)
    800020e6:	f022                	sd	s0,32(sp)
    800020e8:	ec26                	sd	s1,24(sp)
    800020ea:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020ec:	fdc40593          	addi	a1,s0,-36
    800020f0:	4501                	li	a0,0
    800020f2:	00000097          	auipc	ra,0x0
    800020f6:	e78080e7          	jalr	-392(ra) # 80001f6a <argint>
    800020fa:	87aa                	mv	a5,a0
    return -1;
    800020fc:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020fe:	0207c063          	bltz	a5,8000211e <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	d46080e7          	jalr	-698(ra) # 80000e48 <myproc>
    8000210a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000210c:	fdc42503          	lw	a0,-36(s0)
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	0a0080e7          	jalr	160(ra) # 800011b0 <growproc>
    80002118:	00054863          	bltz	a0,80002128 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000211c:	8526                	mv	a0,s1
}
    8000211e:	70a2                	ld	ra,40(sp)
    80002120:	7402                	ld	s0,32(sp)
    80002122:	64e2                	ld	s1,24(sp)
    80002124:	6145                	addi	sp,sp,48
    80002126:	8082                	ret
    return -1;
    80002128:	557d                	li	a0,-1
    8000212a:	bfd5                	j	8000211e <sys_sbrk+0x3c>

000000008000212c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000212c:	7139                	addi	sp,sp,-64
    8000212e:	fc06                	sd	ra,56(sp)
    80002130:	f822                	sd	s0,48(sp)
    80002132:	f426                	sd	s1,40(sp)
    80002134:	f04a                	sd	s2,32(sp)
    80002136:	ec4e                	sd	s3,24(sp)
    80002138:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;
  backtrace();
    8000213a:	00004097          	auipc	ra,0x4
    8000213e:	b40080e7          	jalr	-1216(ra) # 80005c7a <backtrace>

  if(argint(0, &n) < 0)
    80002142:	fcc40593          	addi	a1,s0,-52
    80002146:	4501                	li	a0,0
    80002148:	00000097          	auipc	ra,0x0
    8000214c:	e22080e7          	jalr	-478(ra) # 80001f6a <argint>
    return -1;
    80002150:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002152:	06054563          	bltz	a0,800021bc <sys_sleep+0x90>
  acquire(&tickslock);
    80002156:	00012517          	auipc	a0,0x12
    8000215a:	b2a50513          	addi	a0,a0,-1238 # 80013c80 <tickslock>
    8000215e:	00004097          	auipc	ra,0x4
    80002162:	07c080e7          	jalr	124(ra) # 800061da <acquire>
  ticks0 = ticks;
    80002166:	00007917          	auipc	s2,0x7
    8000216a:	eb292903          	lw	s2,-334(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000216e:	fcc42783          	lw	a5,-52(s0)
    80002172:	cf85                	beqz	a5,800021aa <sys_sleep+0x7e>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002174:	00012997          	auipc	s3,0x12
    80002178:	b0c98993          	addi	s3,s3,-1268 # 80013c80 <tickslock>
    8000217c:	00007497          	auipc	s1,0x7
    80002180:	e9c48493          	addi	s1,s1,-356 # 80009018 <ticks>
    if(myproc()->killed){
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	cc4080e7          	jalr	-828(ra) # 80000e48 <myproc>
    8000218c:	551c                	lw	a5,40(a0)
    8000218e:	ef9d                	bnez	a5,800021cc <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    80002190:	85ce                	mv	a1,s3
    80002192:	8526                	mv	a0,s1
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	37e080e7          	jalr	894(ra) # 80001512 <sleep>
  while(ticks - ticks0 < n){
    8000219c:	409c                	lw	a5,0(s1)
    8000219e:	412787bb          	subw	a5,a5,s2
    800021a2:	fcc42703          	lw	a4,-52(s0)
    800021a6:	fce7efe3          	bltu	a5,a4,80002184 <sys_sleep+0x58>
  }
  release(&tickslock);
    800021aa:	00012517          	auipc	a0,0x12
    800021ae:	ad650513          	addi	a0,a0,-1322 # 80013c80 <tickslock>
    800021b2:	00004097          	auipc	ra,0x4
    800021b6:	0dc080e7          	jalr	220(ra) # 8000628e <release>
  return 0;
    800021ba:	4781                	li	a5,0
}
    800021bc:	853e                	mv	a0,a5
    800021be:	70e2                	ld	ra,56(sp)
    800021c0:	7442                	ld	s0,48(sp)
    800021c2:	74a2                	ld	s1,40(sp)
    800021c4:	7902                	ld	s2,32(sp)
    800021c6:	69e2                	ld	s3,24(sp)
    800021c8:	6121                	addi	sp,sp,64
    800021ca:	8082                	ret
      release(&tickslock);
    800021cc:	00012517          	auipc	a0,0x12
    800021d0:	ab450513          	addi	a0,a0,-1356 # 80013c80 <tickslock>
    800021d4:	00004097          	auipc	ra,0x4
    800021d8:	0ba080e7          	jalr	186(ra) # 8000628e <release>
      return -1;
    800021dc:	57fd                	li	a5,-1
    800021de:	bff9                	j	800021bc <sys_sleep+0x90>

00000000800021e0 <sys_kill>:

uint64
sys_kill(void)
{
    800021e0:	1101                	addi	sp,sp,-32
    800021e2:	ec06                	sd	ra,24(sp)
    800021e4:	e822                	sd	s0,16(sp)
    800021e6:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021e8:	fec40593          	addi	a1,s0,-20
    800021ec:	4501                	li	a0,0
    800021ee:	00000097          	auipc	ra,0x0
    800021f2:	d7c080e7          	jalr	-644(ra) # 80001f6a <argint>
    800021f6:	87aa                	mv	a5,a0
    return -1;
    800021f8:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021fa:	0007c863          	bltz	a5,8000220a <sys_kill+0x2a>
  return kill(pid);
    800021fe:	fec42503          	lw	a0,-20(s0)
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	642080e7          	jalr	1602(ra) # 80001844 <kill>
}
    8000220a:	60e2                	ld	ra,24(sp)
    8000220c:	6442                	ld	s0,16(sp)
    8000220e:	6105                	addi	sp,sp,32
    80002210:	8082                	ret

0000000080002212 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002212:	1101                	addi	sp,sp,-32
    80002214:	ec06                	sd	ra,24(sp)
    80002216:	e822                	sd	s0,16(sp)
    80002218:	e426                	sd	s1,8(sp)
    8000221a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000221c:	00012517          	auipc	a0,0x12
    80002220:	a6450513          	addi	a0,a0,-1436 # 80013c80 <tickslock>
    80002224:	00004097          	auipc	ra,0x4
    80002228:	fb6080e7          	jalr	-74(ra) # 800061da <acquire>
  xticks = ticks;
    8000222c:	00007497          	auipc	s1,0x7
    80002230:	dec4a483          	lw	s1,-532(s1) # 80009018 <ticks>
  release(&tickslock);
    80002234:	00012517          	auipc	a0,0x12
    80002238:	a4c50513          	addi	a0,a0,-1460 # 80013c80 <tickslock>
    8000223c:	00004097          	auipc	ra,0x4
    80002240:	052080e7          	jalr	82(ra) # 8000628e <release>
  return xticks;
}
    80002244:	02049513          	slli	a0,s1,0x20
    80002248:	9101                	srli	a0,a0,0x20
    8000224a:	60e2                	ld	ra,24(sp)
    8000224c:	6442                	ld	s0,16(sp)
    8000224e:	64a2                	ld	s1,8(sp)
    80002250:	6105                	addi	sp,sp,32
    80002252:	8082                	ret

0000000080002254 <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    80002254:	7179                	addi	sp,sp,-48
    80002256:	f406                	sd	ra,40(sp)
    80002258:	f022                	sd	s0,32(sp)
    8000225a:	ec26                	sd	s1,24(sp)
    8000225c:	1800                	addi	s0,sp,48
	int ticks;
	uint64 handler;
	struct proc *p = myproc();
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	bea080e7          	jalr	-1046(ra) # 80000e48 <myproc>
    80002266:	84aa                	mv	s1,a0
	if(argint(0, &ticks) < 0 || argaddr(1, &handler) < 0)
    80002268:	fdc40593          	addi	a1,s0,-36
    8000226c:	4501                	li	a0,0
    8000226e:	00000097          	auipc	ra,0x0
    80002272:	cfc080e7          	jalr	-772(ra) # 80001f6a <argint>
	return -1;
    80002276:	57fd                	li	a5,-1
	if(argint(0, &ticks) < 0 || argaddr(1, &handler) < 0)
    80002278:	02054663          	bltz	a0,800022a4 <sys_sigalarm+0x50>
    8000227c:	fd040593          	addi	a1,s0,-48
    80002280:	4505                	li	a0,1
    80002282:	00000097          	auipc	ra,0x0
    80002286:	d0a080e7          	jalr	-758(ra) # 80001f8c <argaddr>
    8000228a:	02054363          	bltz	a0,800022b0 <sys_sigalarm+0x5c>
	p->alarminterval = ticks;
    8000228e:	fdc42783          	lw	a5,-36(s0)
    80002292:	16f4a423          	sw	a5,360(s1)
	p->alarmhandler = (void (*)())handler;
    80002296:	fd043783          	ld	a5,-48(s0)
    8000229a:	16f4b823          	sd	a5,368(s1)
	p->alarmticks = 0;
    8000229e:	1604a623          	sw	zero,364(s1)
	return 0;
    800022a2:	4781                	li	a5,0
}
    800022a4:	853e                	mv	a0,a5
    800022a6:	70a2                	ld	ra,40(sp)
    800022a8:	7402                	ld	s0,32(sp)
    800022aa:	64e2                	ld	s1,24(sp)
    800022ac:	6145                	addi	sp,sp,48
    800022ae:	8082                	ret
	return -1;
    800022b0:	57fd                	li	a5,-1
    800022b2:	bfcd                	j	800022a4 <sys_sigalarm+0x50>

00000000800022b4 <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    800022b4:	1141                	addi	sp,sp,-16
    800022b6:	e406                	sd	ra,8(sp)
    800022b8:	e022                	sd	s0,0(sp)
    800022ba:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	b8c080e7          	jalr	-1140(ra) # 80000e48 <myproc>
  p->sigreturned = 1;
    800022c4:	4785                	li	a5,1
    800022c6:	28f52c23          	sw	a5,664(a0)
  *(p->trapframe) = p->alarmtrapframe;
    800022ca:	17850793          	addi	a5,a0,376
    800022ce:	6d38                	ld	a4,88(a0)
    800022d0:	29850513          	addi	a0,a0,664
    800022d4:	0007b803          	ld	a6,0(a5)
    800022d8:	678c                	ld	a1,8(a5)
    800022da:	6b90                	ld	a2,16(a5)
    800022dc:	6f94                	ld	a3,24(a5)
    800022de:	01073023          	sd	a6,0(a4)
    800022e2:	e70c                	sd	a1,8(a4)
    800022e4:	eb10                	sd	a2,16(a4)
    800022e6:	ef14                	sd	a3,24(a4)
    800022e8:	02078793          	addi	a5,a5,32
    800022ec:	02070713          	addi	a4,a4,32
    800022f0:	fea792e3          	bne	a5,a0,800022d4 <sys_sigreturn+0x20>
  usertrapret();
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	7c6080e7          	jalr	1990(ra) # 80001aba <usertrapret>
  return 0;
}
    800022fc:	4501                	li	a0,0
    800022fe:	60a2                	ld	ra,8(sp)
    80002300:	6402                	ld	s0,0(sp)
    80002302:	0141                	addi	sp,sp,16
    80002304:	8082                	ret

0000000080002306 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002306:	7179                	addi	sp,sp,-48
    80002308:	f406                	sd	ra,40(sp)
    8000230a:	f022                	sd	s0,32(sp)
    8000230c:	ec26                	sd	s1,24(sp)
    8000230e:	e84a                	sd	s2,16(sp)
    80002310:	e44e                	sd	s3,8(sp)
    80002312:	e052                	sd	s4,0(sp)
    80002314:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002316:	00006597          	auipc	a1,0x6
    8000231a:	17258593          	addi	a1,a1,370 # 80008488 <syscalls+0xc0>
    8000231e:	00012517          	auipc	a0,0x12
    80002322:	97a50513          	addi	a0,a0,-1670 # 80013c98 <bcache>
    80002326:	00004097          	auipc	ra,0x4
    8000232a:	e24080e7          	jalr	-476(ra) # 8000614a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000232e:	0001a797          	auipc	a5,0x1a
    80002332:	96a78793          	addi	a5,a5,-1686 # 8001bc98 <bcache+0x8000>
    80002336:	0001a717          	auipc	a4,0x1a
    8000233a:	bca70713          	addi	a4,a4,-1078 # 8001bf00 <bcache+0x8268>
    8000233e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002342:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002346:	00012497          	auipc	s1,0x12
    8000234a:	96a48493          	addi	s1,s1,-1686 # 80013cb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000234e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002350:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002352:	00006a17          	auipc	s4,0x6
    80002356:	13ea0a13          	addi	s4,s4,318 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000235a:	2b893783          	ld	a5,696(s2)
    8000235e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002360:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002364:	85d2                	mv	a1,s4
    80002366:	01048513          	addi	a0,s1,16
    8000236a:	00001097          	auipc	ra,0x1
    8000236e:	4bc080e7          	jalr	1212(ra) # 80003826 <initsleeplock>
    bcache.head.next->prev = b;
    80002372:	2b893783          	ld	a5,696(s2)
    80002376:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002378:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000237c:	45848493          	addi	s1,s1,1112
    80002380:	fd349de3          	bne	s1,s3,8000235a <binit+0x54>
  }
}
    80002384:	70a2                	ld	ra,40(sp)
    80002386:	7402                	ld	s0,32(sp)
    80002388:	64e2                	ld	s1,24(sp)
    8000238a:	6942                	ld	s2,16(sp)
    8000238c:	69a2                	ld	s3,8(sp)
    8000238e:	6a02                	ld	s4,0(sp)
    80002390:	6145                	addi	sp,sp,48
    80002392:	8082                	ret

0000000080002394 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002394:	7179                	addi	sp,sp,-48
    80002396:	f406                	sd	ra,40(sp)
    80002398:	f022                	sd	s0,32(sp)
    8000239a:	ec26                	sd	s1,24(sp)
    8000239c:	e84a                	sd	s2,16(sp)
    8000239e:	e44e                	sd	s3,8(sp)
    800023a0:	1800                	addi	s0,sp,48
    800023a2:	89aa                	mv	s3,a0
    800023a4:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023a6:	00012517          	auipc	a0,0x12
    800023aa:	8f250513          	addi	a0,a0,-1806 # 80013c98 <bcache>
    800023ae:	00004097          	auipc	ra,0x4
    800023b2:	e2c080e7          	jalr	-468(ra) # 800061da <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023b6:	0001a497          	auipc	s1,0x1a
    800023ba:	b9a4b483          	ld	s1,-1126(s1) # 8001bf50 <bcache+0x82b8>
    800023be:	0001a797          	auipc	a5,0x1a
    800023c2:	b4278793          	addi	a5,a5,-1214 # 8001bf00 <bcache+0x8268>
    800023c6:	02f48f63          	beq	s1,a5,80002404 <bread+0x70>
    800023ca:	873e                	mv	a4,a5
    800023cc:	a021                	j	800023d4 <bread+0x40>
    800023ce:	68a4                	ld	s1,80(s1)
    800023d0:	02e48a63          	beq	s1,a4,80002404 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023d4:	449c                	lw	a5,8(s1)
    800023d6:	ff379ce3          	bne	a5,s3,800023ce <bread+0x3a>
    800023da:	44dc                	lw	a5,12(s1)
    800023dc:	ff2799e3          	bne	a5,s2,800023ce <bread+0x3a>
      b->refcnt++;
    800023e0:	40bc                	lw	a5,64(s1)
    800023e2:	2785                	addiw	a5,a5,1
    800023e4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023e6:	00012517          	auipc	a0,0x12
    800023ea:	8b250513          	addi	a0,a0,-1870 # 80013c98 <bcache>
    800023ee:	00004097          	auipc	ra,0x4
    800023f2:	ea0080e7          	jalr	-352(ra) # 8000628e <release>
      acquiresleep(&b->lock);
    800023f6:	01048513          	addi	a0,s1,16
    800023fa:	00001097          	auipc	ra,0x1
    800023fe:	466080e7          	jalr	1126(ra) # 80003860 <acquiresleep>
      return b;
    80002402:	a8b9                	j	80002460 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002404:	0001a497          	auipc	s1,0x1a
    80002408:	b444b483          	ld	s1,-1212(s1) # 8001bf48 <bcache+0x82b0>
    8000240c:	0001a797          	auipc	a5,0x1a
    80002410:	af478793          	addi	a5,a5,-1292 # 8001bf00 <bcache+0x8268>
    80002414:	00f48863          	beq	s1,a5,80002424 <bread+0x90>
    80002418:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000241a:	40bc                	lw	a5,64(s1)
    8000241c:	cf81                	beqz	a5,80002434 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000241e:	64a4                	ld	s1,72(s1)
    80002420:	fee49de3          	bne	s1,a4,8000241a <bread+0x86>
  panic("bget: no buffers");
    80002424:	00006517          	auipc	a0,0x6
    80002428:	07450513          	addi	a0,a0,116 # 80008498 <syscalls+0xd0>
    8000242c:	00004097          	auipc	ra,0x4
    80002430:	88e080e7          	jalr	-1906(ra) # 80005cba <panic>
      b->dev = dev;
    80002434:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002438:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000243c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002440:	4785                	li	a5,1
    80002442:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002444:	00012517          	auipc	a0,0x12
    80002448:	85450513          	addi	a0,a0,-1964 # 80013c98 <bcache>
    8000244c:	00004097          	auipc	ra,0x4
    80002450:	e42080e7          	jalr	-446(ra) # 8000628e <release>
      acquiresleep(&b->lock);
    80002454:	01048513          	addi	a0,s1,16
    80002458:	00001097          	auipc	ra,0x1
    8000245c:	408080e7          	jalr	1032(ra) # 80003860 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002460:	409c                	lw	a5,0(s1)
    80002462:	cb89                	beqz	a5,80002474 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002464:	8526                	mv	a0,s1
    80002466:	70a2                	ld	ra,40(sp)
    80002468:	7402                	ld	s0,32(sp)
    8000246a:	64e2                	ld	s1,24(sp)
    8000246c:	6942                	ld	s2,16(sp)
    8000246e:	69a2                	ld	s3,8(sp)
    80002470:	6145                	addi	sp,sp,48
    80002472:	8082                	ret
    virtio_disk_rw(b, 0);
    80002474:	4581                	li	a1,0
    80002476:	8526                	mv	a0,s1
    80002478:	00003097          	auipc	ra,0x3
    8000247c:	f0e080e7          	jalr	-242(ra) # 80005386 <virtio_disk_rw>
    b->valid = 1;
    80002480:	4785                	li	a5,1
    80002482:	c09c                	sw	a5,0(s1)
  return b;
    80002484:	b7c5                	j	80002464 <bread+0xd0>

0000000080002486 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002486:	1101                	addi	sp,sp,-32
    80002488:	ec06                	sd	ra,24(sp)
    8000248a:	e822                	sd	s0,16(sp)
    8000248c:	e426                	sd	s1,8(sp)
    8000248e:	1000                	addi	s0,sp,32
    80002490:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002492:	0541                	addi	a0,a0,16
    80002494:	00001097          	auipc	ra,0x1
    80002498:	466080e7          	jalr	1126(ra) # 800038fa <holdingsleep>
    8000249c:	cd01                	beqz	a0,800024b4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000249e:	4585                	li	a1,1
    800024a0:	8526                	mv	a0,s1
    800024a2:	00003097          	auipc	ra,0x3
    800024a6:	ee4080e7          	jalr	-284(ra) # 80005386 <virtio_disk_rw>
}
    800024aa:	60e2                	ld	ra,24(sp)
    800024ac:	6442                	ld	s0,16(sp)
    800024ae:	64a2                	ld	s1,8(sp)
    800024b0:	6105                	addi	sp,sp,32
    800024b2:	8082                	ret
    panic("bwrite");
    800024b4:	00006517          	auipc	a0,0x6
    800024b8:	ffc50513          	addi	a0,a0,-4 # 800084b0 <syscalls+0xe8>
    800024bc:	00003097          	auipc	ra,0x3
    800024c0:	7fe080e7          	jalr	2046(ra) # 80005cba <panic>

00000000800024c4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024c4:	1101                	addi	sp,sp,-32
    800024c6:	ec06                	sd	ra,24(sp)
    800024c8:	e822                	sd	s0,16(sp)
    800024ca:	e426                	sd	s1,8(sp)
    800024cc:	e04a                	sd	s2,0(sp)
    800024ce:	1000                	addi	s0,sp,32
    800024d0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024d2:	01050913          	addi	s2,a0,16
    800024d6:	854a                	mv	a0,s2
    800024d8:	00001097          	auipc	ra,0x1
    800024dc:	422080e7          	jalr	1058(ra) # 800038fa <holdingsleep>
    800024e0:	c92d                	beqz	a0,80002552 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024e2:	854a                	mv	a0,s2
    800024e4:	00001097          	auipc	ra,0x1
    800024e8:	3d2080e7          	jalr	978(ra) # 800038b6 <releasesleep>

  acquire(&bcache.lock);
    800024ec:	00011517          	auipc	a0,0x11
    800024f0:	7ac50513          	addi	a0,a0,1964 # 80013c98 <bcache>
    800024f4:	00004097          	auipc	ra,0x4
    800024f8:	ce6080e7          	jalr	-794(ra) # 800061da <acquire>
  b->refcnt--;
    800024fc:	40bc                	lw	a5,64(s1)
    800024fe:	37fd                	addiw	a5,a5,-1
    80002500:	0007871b          	sext.w	a4,a5
    80002504:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002506:	eb05                	bnez	a4,80002536 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002508:	68bc                	ld	a5,80(s1)
    8000250a:	64b8                	ld	a4,72(s1)
    8000250c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000250e:	64bc                	ld	a5,72(s1)
    80002510:	68b8                	ld	a4,80(s1)
    80002512:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002514:	00019797          	auipc	a5,0x19
    80002518:	78478793          	addi	a5,a5,1924 # 8001bc98 <bcache+0x8000>
    8000251c:	2b87b703          	ld	a4,696(a5)
    80002520:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002522:	0001a717          	auipc	a4,0x1a
    80002526:	9de70713          	addi	a4,a4,-1570 # 8001bf00 <bcache+0x8268>
    8000252a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000252c:	2b87b703          	ld	a4,696(a5)
    80002530:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002532:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002536:	00011517          	auipc	a0,0x11
    8000253a:	76250513          	addi	a0,a0,1890 # 80013c98 <bcache>
    8000253e:	00004097          	auipc	ra,0x4
    80002542:	d50080e7          	jalr	-688(ra) # 8000628e <release>
}
    80002546:	60e2                	ld	ra,24(sp)
    80002548:	6442                	ld	s0,16(sp)
    8000254a:	64a2                	ld	s1,8(sp)
    8000254c:	6902                	ld	s2,0(sp)
    8000254e:	6105                	addi	sp,sp,32
    80002550:	8082                	ret
    panic("brelse");
    80002552:	00006517          	auipc	a0,0x6
    80002556:	f6650513          	addi	a0,a0,-154 # 800084b8 <syscalls+0xf0>
    8000255a:	00003097          	auipc	ra,0x3
    8000255e:	760080e7          	jalr	1888(ra) # 80005cba <panic>

0000000080002562 <bpin>:

void
bpin(struct buf *b) {
    80002562:	1101                	addi	sp,sp,-32
    80002564:	ec06                	sd	ra,24(sp)
    80002566:	e822                	sd	s0,16(sp)
    80002568:	e426                	sd	s1,8(sp)
    8000256a:	1000                	addi	s0,sp,32
    8000256c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000256e:	00011517          	auipc	a0,0x11
    80002572:	72a50513          	addi	a0,a0,1834 # 80013c98 <bcache>
    80002576:	00004097          	auipc	ra,0x4
    8000257a:	c64080e7          	jalr	-924(ra) # 800061da <acquire>
  b->refcnt++;
    8000257e:	40bc                	lw	a5,64(s1)
    80002580:	2785                	addiw	a5,a5,1
    80002582:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002584:	00011517          	auipc	a0,0x11
    80002588:	71450513          	addi	a0,a0,1812 # 80013c98 <bcache>
    8000258c:	00004097          	auipc	ra,0x4
    80002590:	d02080e7          	jalr	-766(ra) # 8000628e <release>
}
    80002594:	60e2                	ld	ra,24(sp)
    80002596:	6442                	ld	s0,16(sp)
    80002598:	64a2                	ld	s1,8(sp)
    8000259a:	6105                	addi	sp,sp,32
    8000259c:	8082                	ret

000000008000259e <bunpin>:

void
bunpin(struct buf *b) {
    8000259e:	1101                	addi	sp,sp,-32
    800025a0:	ec06                	sd	ra,24(sp)
    800025a2:	e822                	sd	s0,16(sp)
    800025a4:	e426                	sd	s1,8(sp)
    800025a6:	1000                	addi	s0,sp,32
    800025a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025aa:	00011517          	auipc	a0,0x11
    800025ae:	6ee50513          	addi	a0,a0,1774 # 80013c98 <bcache>
    800025b2:	00004097          	auipc	ra,0x4
    800025b6:	c28080e7          	jalr	-984(ra) # 800061da <acquire>
  b->refcnt--;
    800025ba:	40bc                	lw	a5,64(s1)
    800025bc:	37fd                	addiw	a5,a5,-1
    800025be:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025c0:	00011517          	auipc	a0,0x11
    800025c4:	6d850513          	addi	a0,a0,1752 # 80013c98 <bcache>
    800025c8:	00004097          	auipc	ra,0x4
    800025cc:	cc6080e7          	jalr	-826(ra) # 8000628e <release>
}
    800025d0:	60e2                	ld	ra,24(sp)
    800025d2:	6442                	ld	s0,16(sp)
    800025d4:	64a2                	ld	s1,8(sp)
    800025d6:	6105                	addi	sp,sp,32
    800025d8:	8082                	ret

00000000800025da <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025da:	1101                	addi	sp,sp,-32
    800025dc:	ec06                	sd	ra,24(sp)
    800025de:	e822                	sd	s0,16(sp)
    800025e0:	e426                	sd	s1,8(sp)
    800025e2:	e04a                	sd	s2,0(sp)
    800025e4:	1000                	addi	s0,sp,32
    800025e6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025e8:	00d5d59b          	srliw	a1,a1,0xd
    800025ec:	0001a797          	auipc	a5,0x1a
    800025f0:	d887a783          	lw	a5,-632(a5) # 8001c374 <sb+0x1c>
    800025f4:	9dbd                	addw	a1,a1,a5
    800025f6:	00000097          	auipc	ra,0x0
    800025fa:	d9e080e7          	jalr	-610(ra) # 80002394 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025fe:	0074f713          	andi	a4,s1,7
    80002602:	4785                	li	a5,1
    80002604:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002608:	14ce                	slli	s1,s1,0x33
    8000260a:	90d9                	srli	s1,s1,0x36
    8000260c:	00950733          	add	a4,a0,s1
    80002610:	05874703          	lbu	a4,88(a4)
    80002614:	00e7f6b3          	and	a3,a5,a4
    80002618:	c69d                	beqz	a3,80002646 <bfree+0x6c>
    8000261a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000261c:	94aa                	add	s1,s1,a0
    8000261e:	fff7c793          	not	a5,a5
    80002622:	8ff9                	and	a5,a5,a4
    80002624:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002628:	00001097          	auipc	ra,0x1
    8000262c:	118080e7          	jalr	280(ra) # 80003740 <log_write>
  brelse(bp);
    80002630:	854a                	mv	a0,s2
    80002632:	00000097          	auipc	ra,0x0
    80002636:	e92080e7          	jalr	-366(ra) # 800024c4 <brelse>
}
    8000263a:	60e2                	ld	ra,24(sp)
    8000263c:	6442                	ld	s0,16(sp)
    8000263e:	64a2                	ld	s1,8(sp)
    80002640:	6902                	ld	s2,0(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret
    panic("freeing free block");
    80002646:	00006517          	auipc	a0,0x6
    8000264a:	e7a50513          	addi	a0,a0,-390 # 800084c0 <syscalls+0xf8>
    8000264e:	00003097          	auipc	ra,0x3
    80002652:	66c080e7          	jalr	1644(ra) # 80005cba <panic>

0000000080002656 <balloc>:
{
    80002656:	711d                	addi	sp,sp,-96
    80002658:	ec86                	sd	ra,88(sp)
    8000265a:	e8a2                	sd	s0,80(sp)
    8000265c:	e4a6                	sd	s1,72(sp)
    8000265e:	e0ca                	sd	s2,64(sp)
    80002660:	fc4e                	sd	s3,56(sp)
    80002662:	f852                	sd	s4,48(sp)
    80002664:	f456                	sd	s5,40(sp)
    80002666:	f05a                	sd	s6,32(sp)
    80002668:	ec5e                	sd	s7,24(sp)
    8000266a:	e862                	sd	s8,16(sp)
    8000266c:	e466                	sd	s9,8(sp)
    8000266e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002670:	0001a797          	auipc	a5,0x1a
    80002674:	cec7a783          	lw	a5,-788(a5) # 8001c35c <sb+0x4>
    80002678:	cbd1                	beqz	a5,8000270c <balloc+0xb6>
    8000267a:	8baa                	mv	s7,a0
    8000267c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000267e:	0001ab17          	auipc	s6,0x1a
    80002682:	cdab0b13          	addi	s6,s6,-806 # 8001c358 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002686:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002688:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000268a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000268c:	6c89                	lui	s9,0x2
    8000268e:	a831                	j	800026aa <balloc+0x54>
    brelse(bp);
    80002690:	854a                	mv	a0,s2
    80002692:	00000097          	auipc	ra,0x0
    80002696:	e32080e7          	jalr	-462(ra) # 800024c4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000269a:	015c87bb          	addw	a5,s9,s5
    8000269e:	00078a9b          	sext.w	s5,a5
    800026a2:	004b2703          	lw	a4,4(s6)
    800026a6:	06eaf363          	bgeu	s5,a4,8000270c <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026aa:	41fad79b          	sraiw	a5,s5,0x1f
    800026ae:	0137d79b          	srliw	a5,a5,0x13
    800026b2:	015787bb          	addw	a5,a5,s5
    800026b6:	40d7d79b          	sraiw	a5,a5,0xd
    800026ba:	01cb2583          	lw	a1,28(s6)
    800026be:	9dbd                	addw	a1,a1,a5
    800026c0:	855e                	mv	a0,s7
    800026c2:	00000097          	auipc	ra,0x0
    800026c6:	cd2080e7          	jalr	-814(ra) # 80002394 <bread>
    800026ca:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026cc:	004b2503          	lw	a0,4(s6)
    800026d0:	000a849b          	sext.w	s1,s5
    800026d4:	8662                	mv	a2,s8
    800026d6:	faa4fde3          	bgeu	s1,a0,80002690 <balloc+0x3a>
      m = 1 << (bi % 8);
    800026da:	41f6579b          	sraiw	a5,a2,0x1f
    800026de:	01d7d69b          	srliw	a3,a5,0x1d
    800026e2:	00c6873b          	addw	a4,a3,a2
    800026e6:	00777793          	andi	a5,a4,7
    800026ea:	9f95                	subw	a5,a5,a3
    800026ec:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026f0:	4037571b          	sraiw	a4,a4,0x3
    800026f4:	00e906b3          	add	a3,s2,a4
    800026f8:	0586c683          	lbu	a3,88(a3)
    800026fc:	00d7f5b3          	and	a1,a5,a3
    80002700:	cd91                	beqz	a1,8000271c <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002702:	2605                	addiw	a2,a2,1
    80002704:	2485                	addiw	s1,s1,1
    80002706:	fd4618e3          	bne	a2,s4,800026d6 <balloc+0x80>
    8000270a:	b759                	j	80002690 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000270c:	00006517          	auipc	a0,0x6
    80002710:	dcc50513          	addi	a0,a0,-564 # 800084d8 <syscalls+0x110>
    80002714:	00003097          	auipc	ra,0x3
    80002718:	5a6080e7          	jalr	1446(ra) # 80005cba <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000271c:	974a                	add	a4,a4,s2
    8000271e:	8fd5                	or	a5,a5,a3
    80002720:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002724:	854a                	mv	a0,s2
    80002726:	00001097          	auipc	ra,0x1
    8000272a:	01a080e7          	jalr	26(ra) # 80003740 <log_write>
        brelse(bp);
    8000272e:	854a                	mv	a0,s2
    80002730:	00000097          	auipc	ra,0x0
    80002734:	d94080e7          	jalr	-620(ra) # 800024c4 <brelse>
  bp = bread(dev, bno);
    80002738:	85a6                	mv	a1,s1
    8000273a:	855e                	mv	a0,s7
    8000273c:	00000097          	auipc	ra,0x0
    80002740:	c58080e7          	jalr	-936(ra) # 80002394 <bread>
    80002744:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002746:	40000613          	li	a2,1024
    8000274a:	4581                	li	a1,0
    8000274c:	05850513          	addi	a0,a0,88
    80002750:	ffffe097          	auipc	ra,0xffffe
    80002754:	a28080e7          	jalr	-1496(ra) # 80000178 <memset>
  log_write(bp);
    80002758:	854a                	mv	a0,s2
    8000275a:	00001097          	auipc	ra,0x1
    8000275e:	fe6080e7          	jalr	-26(ra) # 80003740 <log_write>
  brelse(bp);
    80002762:	854a                	mv	a0,s2
    80002764:	00000097          	auipc	ra,0x0
    80002768:	d60080e7          	jalr	-672(ra) # 800024c4 <brelse>
}
    8000276c:	8526                	mv	a0,s1
    8000276e:	60e6                	ld	ra,88(sp)
    80002770:	6446                	ld	s0,80(sp)
    80002772:	64a6                	ld	s1,72(sp)
    80002774:	6906                	ld	s2,64(sp)
    80002776:	79e2                	ld	s3,56(sp)
    80002778:	7a42                	ld	s4,48(sp)
    8000277a:	7aa2                	ld	s5,40(sp)
    8000277c:	7b02                	ld	s6,32(sp)
    8000277e:	6be2                	ld	s7,24(sp)
    80002780:	6c42                	ld	s8,16(sp)
    80002782:	6ca2                	ld	s9,8(sp)
    80002784:	6125                	addi	sp,sp,96
    80002786:	8082                	ret

0000000080002788 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002788:	7179                	addi	sp,sp,-48
    8000278a:	f406                	sd	ra,40(sp)
    8000278c:	f022                	sd	s0,32(sp)
    8000278e:	ec26                	sd	s1,24(sp)
    80002790:	e84a                	sd	s2,16(sp)
    80002792:	e44e                	sd	s3,8(sp)
    80002794:	e052                	sd	s4,0(sp)
    80002796:	1800                	addi	s0,sp,48
    80002798:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000279a:	47ad                	li	a5,11
    8000279c:	04b7fe63          	bgeu	a5,a1,800027f8 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027a0:	ff45849b          	addiw	s1,a1,-12
    800027a4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027a8:	0ff00793          	li	a5,255
    800027ac:	0ae7e363          	bltu	a5,a4,80002852 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027b0:	08052583          	lw	a1,128(a0)
    800027b4:	c5ad                	beqz	a1,8000281e <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027b6:	00092503          	lw	a0,0(s2)
    800027ba:	00000097          	auipc	ra,0x0
    800027be:	bda080e7          	jalr	-1062(ra) # 80002394 <bread>
    800027c2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027c4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027c8:	02049593          	slli	a1,s1,0x20
    800027cc:	9181                	srli	a1,a1,0x20
    800027ce:	058a                	slli	a1,a1,0x2
    800027d0:	00b784b3          	add	s1,a5,a1
    800027d4:	0004a983          	lw	s3,0(s1)
    800027d8:	04098d63          	beqz	s3,80002832 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027dc:	8552                	mv	a0,s4
    800027de:	00000097          	auipc	ra,0x0
    800027e2:	ce6080e7          	jalr	-794(ra) # 800024c4 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027e6:	854e                	mv	a0,s3
    800027e8:	70a2                	ld	ra,40(sp)
    800027ea:	7402                	ld	s0,32(sp)
    800027ec:	64e2                	ld	s1,24(sp)
    800027ee:	6942                	ld	s2,16(sp)
    800027f0:	69a2                	ld	s3,8(sp)
    800027f2:	6a02                	ld	s4,0(sp)
    800027f4:	6145                	addi	sp,sp,48
    800027f6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800027f8:	02059493          	slli	s1,a1,0x20
    800027fc:	9081                	srli	s1,s1,0x20
    800027fe:	048a                	slli	s1,s1,0x2
    80002800:	94aa                	add	s1,s1,a0
    80002802:	0504a983          	lw	s3,80(s1)
    80002806:	fe0990e3          	bnez	s3,800027e6 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000280a:	4108                	lw	a0,0(a0)
    8000280c:	00000097          	auipc	ra,0x0
    80002810:	e4a080e7          	jalr	-438(ra) # 80002656 <balloc>
    80002814:	0005099b          	sext.w	s3,a0
    80002818:	0534a823          	sw	s3,80(s1)
    8000281c:	b7e9                	j	800027e6 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000281e:	4108                	lw	a0,0(a0)
    80002820:	00000097          	auipc	ra,0x0
    80002824:	e36080e7          	jalr	-458(ra) # 80002656 <balloc>
    80002828:	0005059b          	sext.w	a1,a0
    8000282c:	08b92023          	sw	a1,128(s2)
    80002830:	b759                	j	800027b6 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002832:	00092503          	lw	a0,0(s2)
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	e20080e7          	jalr	-480(ra) # 80002656 <balloc>
    8000283e:	0005099b          	sext.w	s3,a0
    80002842:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002846:	8552                	mv	a0,s4
    80002848:	00001097          	auipc	ra,0x1
    8000284c:	ef8080e7          	jalr	-264(ra) # 80003740 <log_write>
    80002850:	b771                	j	800027dc <bmap+0x54>
  panic("bmap: out of range");
    80002852:	00006517          	auipc	a0,0x6
    80002856:	c9e50513          	addi	a0,a0,-866 # 800084f0 <syscalls+0x128>
    8000285a:	00003097          	auipc	ra,0x3
    8000285e:	460080e7          	jalr	1120(ra) # 80005cba <panic>

0000000080002862 <iget>:
{
    80002862:	7179                	addi	sp,sp,-48
    80002864:	f406                	sd	ra,40(sp)
    80002866:	f022                	sd	s0,32(sp)
    80002868:	ec26                	sd	s1,24(sp)
    8000286a:	e84a                	sd	s2,16(sp)
    8000286c:	e44e                	sd	s3,8(sp)
    8000286e:	e052                	sd	s4,0(sp)
    80002870:	1800                	addi	s0,sp,48
    80002872:	89aa                	mv	s3,a0
    80002874:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002876:	0001a517          	auipc	a0,0x1a
    8000287a:	b0250513          	addi	a0,a0,-1278 # 8001c378 <itable>
    8000287e:	00004097          	auipc	ra,0x4
    80002882:	95c080e7          	jalr	-1700(ra) # 800061da <acquire>
  empty = 0;
    80002886:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002888:	0001a497          	auipc	s1,0x1a
    8000288c:	b0848493          	addi	s1,s1,-1272 # 8001c390 <itable+0x18>
    80002890:	0001b697          	auipc	a3,0x1b
    80002894:	59068693          	addi	a3,a3,1424 # 8001de20 <log>
    80002898:	a039                	j	800028a6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000289a:	02090b63          	beqz	s2,800028d0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000289e:	08848493          	addi	s1,s1,136
    800028a2:	02d48a63          	beq	s1,a3,800028d6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028a6:	449c                	lw	a5,8(s1)
    800028a8:	fef059e3          	blez	a5,8000289a <iget+0x38>
    800028ac:	4098                	lw	a4,0(s1)
    800028ae:	ff3716e3          	bne	a4,s3,8000289a <iget+0x38>
    800028b2:	40d8                	lw	a4,4(s1)
    800028b4:	ff4713e3          	bne	a4,s4,8000289a <iget+0x38>
      ip->ref++;
    800028b8:	2785                	addiw	a5,a5,1
    800028ba:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028bc:	0001a517          	auipc	a0,0x1a
    800028c0:	abc50513          	addi	a0,a0,-1348 # 8001c378 <itable>
    800028c4:	00004097          	auipc	ra,0x4
    800028c8:	9ca080e7          	jalr	-1590(ra) # 8000628e <release>
      return ip;
    800028cc:	8926                	mv	s2,s1
    800028ce:	a03d                	j	800028fc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028d0:	f7f9                	bnez	a5,8000289e <iget+0x3c>
    800028d2:	8926                	mv	s2,s1
    800028d4:	b7e9                	j	8000289e <iget+0x3c>
  if(empty == 0)
    800028d6:	02090c63          	beqz	s2,8000290e <iget+0xac>
  ip->dev = dev;
    800028da:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028de:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028e2:	4785                	li	a5,1
    800028e4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028e8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028ec:	0001a517          	auipc	a0,0x1a
    800028f0:	a8c50513          	addi	a0,a0,-1396 # 8001c378 <itable>
    800028f4:	00004097          	auipc	ra,0x4
    800028f8:	99a080e7          	jalr	-1638(ra) # 8000628e <release>
}
    800028fc:	854a                	mv	a0,s2
    800028fe:	70a2                	ld	ra,40(sp)
    80002900:	7402                	ld	s0,32(sp)
    80002902:	64e2                	ld	s1,24(sp)
    80002904:	6942                	ld	s2,16(sp)
    80002906:	69a2                	ld	s3,8(sp)
    80002908:	6a02                	ld	s4,0(sp)
    8000290a:	6145                	addi	sp,sp,48
    8000290c:	8082                	ret
    panic("iget: no inodes");
    8000290e:	00006517          	auipc	a0,0x6
    80002912:	bfa50513          	addi	a0,a0,-1030 # 80008508 <syscalls+0x140>
    80002916:	00003097          	auipc	ra,0x3
    8000291a:	3a4080e7          	jalr	932(ra) # 80005cba <panic>

000000008000291e <fsinit>:
fsinit(int dev) {
    8000291e:	7179                	addi	sp,sp,-48
    80002920:	f406                	sd	ra,40(sp)
    80002922:	f022                	sd	s0,32(sp)
    80002924:	ec26                	sd	s1,24(sp)
    80002926:	e84a                	sd	s2,16(sp)
    80002928:	e44e                	sd	s3,8(sp)
    8000292a:	1800                	addi	s0,sp,48
    8000292c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000292e:	4585                	li	a1,1
    80002930:	00000097          	auipc	ra,0x0
    80002934:	a64080e7          	jalr	-1436(ra) # 80002394 <bread>
    80002938:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000293a:	0001a997          	auipc	s3,0x1a
    8000293e:	a1e98993          	addi	s3,s3,-1506 # 8001c358 <sb>
    80002942:	02000613          	li	a2,32
    80002946:	05850593          	addi	a1,a0,88
    8000294a:	854e                	mv	a0,s3
    8000294c:	ffffe097          	auipc	ra,0xffffe
    80002950:	88c080e7          	jalr	-1908(ra) # 800001d8 <memmove>
  brelse(bp);
    80002954:	8526                	mv	a0,s1
    80002956:	00000097          	auipc	ra,0x0
    8000295a:	b6e080e7          	jalr	-1170(ra) # 800024c4 <brelse>
  if(sb.magic != FSMAGIC)
    8000295e:	0009a703          	lw	a4,0(s3)
    80002962:	102037b7          	lui	a5,0x10203
    80002966:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000296a:	02f71263          	bne	a4,a5,8000298e <fsinit+0x70>
  initlog(dev, &sb);
    8000296e:	0001a597          	auipc	a1,0x1a
    80002972:	9ea58593          	addi	a1,a1,-1558 # 8001c358 <sb>
    80002976:	854a                	mv	a0,s2
    80002978:	00001097          	auipc	ra,0x1
    8000297c:	b4c080e7          	jalr	-1204(ra) # 800034c4 <initlog>
}
    80002980:	70a2                	ld	ra,40(sp)
    80002982:	7402                	ld	s0,32(sp)
    80002984:	64e2                	ld	s1,24(sp)
    80002986:	6942                	ld	s2,16(sp)
    80002988:	69a2                	ld	s3,8(sp)
    8000298a:	6145                	addi	sp,sp,48
    8000298c:	8082                	ret
    panic("invalid file system");
    8000298e:	00006517          	auipc	a0,0x6
    80002992:	b8a50513          	addi	a0,a0,-1142 # 80008518 <syscalls+0x150>
    80002996:	00003097          	auipc	ra,0x3
    8000299a:	324080e7          	jalr	804(ra) # 80005cba <panic>

000000008000299e <iinit>:
{
    8000299e:	7179                	addi	sp,sp,-48
    800029a0:	f406                	sd	ra,40(sp)
    800029a2:	f022                	sd	s0,32(sp)
    800029a4:	ec26                	sd	s1,24(sp)
    800029a6:	e84a                	sd	s2,16(sp)
    800029a8:	e44e                	sd	s3,8(sp)
    800029aa:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029ac:	00006597          	auipc	a1,0x6
    800029b0:	b8458593          	addi	a1,a1,-1148 # 80008530 <syscalls+0x168>
    800029b4:	0001a517          	auipc	a0,0x1a
    800029b8:	9c450513          	addi	a0,a0,-1596 # 8001c378 <itable>
    800029bc:	00003097          	auipc	ra,0x3
    800029c0:	78e080e7          	jalr	1934(ra) # 8000614a <initlock>
  for(i = 0; i < NINODE; i++) {
    800029c4:	0001a497          	auipc	s1,0x1a
    800029c8:	9dc48493          	addi	s1,s1,-1572 # 8001c3a0 <itable+0x28>
    800029cc:	0001b997          	auipc	s3,0x1b
    800029d0:	46498993          	addi	s3,s3,1124 # 8001de30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029d4:	00006917          	auipc	s2,0x6
    800029d8:	b6490913          	addi	s2,s2,-1180 # 80008538 <syscalls+0x170>
    800029dc:	85ca                	mv	a1,s2
    800029de:	8526                	mv	a0,s1
    800029e0:	00001097          	auipc	ra,0x1
    800029e4:	e46080e7          	jalr	-442(ra) # 80003826 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029e8:	08848493          	addi	s1,s1,136
    800029ec:	ff3498e3          	bne	s1,s3,800029dc <iinit+0x3e>
}
    800029f0:	70a2                	ld	ra,40(sp)
    800029f2:	7402                	ld	s0,32(sp)
    800029f4:	64e2                	ld	s1,24(sp)
    800029f6:	6942                	ld	s2,16(sp)
    800029f8:	69a2                	ld	s3,8(sp)
    800029fa:	6145                	addi	sp,sp,48
    800029fc:	8082                	ret

00000000800029fe <ialloc>:
{
    800029fe:	715d                	addi	sp,sp,-80
    80002a00:	e486                	sd	ra,72(sp)
    80002a02:	e0a2                	sd	s0,64(sp)
    80002a04:	fc26                	sd	s1,56(sp)
    80002a06:	f84a                	sd	s2,48(sp)
    80002a08:	f44e                	sd	s3,40(sp)
    80002a0a:	f052                	sd	s4,32(sp)
    80002a0c:	ec56                	sd	s5,24(sp)
    80002a0e:	e85a                	sd	s6,16(sp)
    80002a10:	e45e                	sd	s7,8(sp)
    80002a12:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a14:	0001a717          	auipc	a4,0x1a
    80002a18:	95072703          	lw	a4,-1712(a4) # 8001c364 <sb+0xc>
    80002a1c:	4785                	li	a5,1
    80002a1e:	04e7fa63          	bgeu	a5,a4,80002a72 <ialloc+0x74>
    80002a22:	8aaa                	mv	s5,a0
    80002a24:	8bae                	mv	s7,a1
    80002a26:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a28:	0001aa17          	auipc	s4,0x1a
    80002a2c:	930a0a13          	addi	s4,s4,-1744 # 8001c358 <sb>
    80002a30:	00048b1b          	sext.w	s6,s1
    80002a34:	0044d593          	srli	a1,s1,0x4
    80002a38:	018a2783          	lw	a5,24(s4)
    80002a3c:	9dbd                	addw	a1,a1,a5
    80002a3e:	8556                	mv	a0,s5
    80002a40:	00000097          	auipc	ra,0x0
    80002a44:	954080e7          	jalr	-1708(ra) # 80002394 <bread>
    80002a48:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a4a:	05850993          	addi	s3,a0,88
    80002a4e:	00f4f793          	andi	a5,s1,15
    80002a52:	079a                	slli	a5,a5,0x6
    80002a54:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a56:	00099783          	lh	a5,0(s3)
    80002a5a:	c785                	beqz	a5,80002a82 <ialloc+0x84>
    brelse(bp);
    80002a5c:	00000097          	auipc	ra,0x0
    80002a60:	a68080e7          	jalr	-1432(ra) # 800024c4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a64:	0485                	addi	s1,s1,1
    80002a66:	00ca2703          	lw	a4,12(s4)
    80002a6a:	0004879b          	sext.w	a5,s1
    80002a6e:	fce7e1e3          	bltu	a5,a4,80002a30 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a72:	00006517          	auipc	a0,0x6
    80002a76:	ace50513          	addi	a0,a0,-1330 # 80008540 <syscalls+0x178>
    80002a7a:	00003097          	auipc	ra,0x3
    80002a7e:	240080e7          	jalr	576(ra) # 80005cba <panic>
      memset(dip, 0, sizeof(*dip));
    80002a82:	04000613          	li	a2,64
    80002a86:	4581                	li	a1,0
    80002a88:	854e                	mv	a0,s3
    80002a8a:	ffffd097          	auipc	ra,0xffffd
    80002a8e:	6ee080e7          	jalr	1774(ra) # 80000178 <memset>
      dip->type = type;
    80002a92:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a96:	854a                	mv	a0,s2
    80002a98:	00001097          	auipc	ra,0x1
    80002a9c:	ca8080e7          	jalr	-856(ra) # 80003740 <log_write>
      brelse(bp);
    80002aa0:	854a                	mv	a0,s2
    80002aa2:	00000097          	auipc	ra,0x0
    80002aa6:	a22080e7          	jalr	-1502(ra) # 800024c4 <brelse>
      return iget(dev, inum);
    80002aaa:	85da                	mv	a1,s6
    80002aac:	8556                	mv	a0,s5
    80002aae:	00000097          	auipc	ra,0x0
    80002ab2:	db4080e7          	jalr	-588(ra) # 80002862 <iget>
}
    80002ab6:	60a6                	ld	ra,72(sp)
    80002ab8:	6406                	ld	s0,64(sp)
    80002aba:	74e2                	ld	s1,56(sp)
    80002abc:	7942                	ld	s2,48(sp)
    80002abe:	79a2                	ld	s3,40(sp)
    80002ac0:	7a02                	ld	s4,32(sp)
    80002ac2:	6ae2                	ld	s5,24(sp)
    80002ac4:	6b42                	ld	s6,16(sp)
    80002ac6:	6ba2                	ld	s7,8(sp)
    80002ac8:	6161                	addi	sp,sp,80
    80002aca:	8082                	ret

0000000080002acc <iupdate>:
{
    80002acc:	1101                	addi	sp,sp,-32
    80002ace:	ec06                	sd	ra,24(sp)
    80002ad0:	e822                	sd	s0,16(sp)
    80002ad2:	e426                	sd	s1,8(sp)
    80002ad4:	e04a                	sd	s2,0(sp)
    80002ad6:	1000                	addi	s0,sp,32
    80002ad8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ada:	415c                	lw	a5,4(a0)
    80002adc:	0047d79b          	srliw	a5,a5,0x4
    80002ae0:	0001a597          	auipc	a1,0x1a
    80002ae4:	8905a583          	lw	a1,-1904(a1) # 8001c370 <sb+0x18>
    80002ae8:	9dbd                	addw	a1,a1,a5
    80002aea:	4108                	lw	a0,0(a0)
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	8a8080e7          	jalr	-1880(ra) # 80002394 <bread>
    80002af4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002af6:	05850793          	addi	a5,a0,88
    80002afa:	40c8                	lw	a0,4(s1)
    80002afc:	893d                	andi	a0,a0,15
    80002afe:	051a                	slli	a0,a0,0x6
    80002b00:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b02:	04449703          	lh	a4,68(s1)
    80002b06:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b0a:	04649703          	lh	a4,70(s1)
    80002b0e:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b12:	04849703          	lh	a4,72(s1)
    80002b16:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b1a:	04a49703          	lh	a4,74(s1)
    80002b1e:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b22:	44f8                	lw	a4,76(s1)
    80002b24:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b26:	03400613          	li	a2,52
    80002b2a:	05048593          	addi	a1,s1,80
    80002b2e:	0531                	addi	a0,a0,12
    80002b30:	ffffd097          	auipc	ra,0xffffd
    80002b34:	6a8080e7          	jalr	1704(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b38:	854a                	mv	a0,s2
    80002b3a:	00001097          	auipc	ra,0x1
    80002b3e:	c06080e7          	jalr	-1018(ra) # 80003740 <log_write>
  brelse(bp);
    80002b42:	854a                	mv	a0,s2
    80002b44:	00000097          	auipc	ra,0x0
    80002b48:	980080e7          	jalr	-1664(ra) # 800024c4 <brelse>
}
    80002b4c:	60e2                	ld	ra,24(sp)
    80002b4e:	6442                	ld	s0,16(sp)
    80002b50:	64a2                	ld	s1,8(sp)
    80002b52:	6902                	ld	s2,0(sp)
    80002b54:	6105                	addi	sp,sp,32
    80002b56:	8082                	ret

0000000080002b58 <idup>:
{
    80002b58:	1101                	addi	sp,sp,-32
    80002b5a:	ec06                	sd	ra,24(sp)
    80002b5c:	e822                	sd	s0,16(sp)
    80002b5e:	e426                	sd	s1,8(sp)
    80002b60:	1000                	addi	s0,sp,32
    80002b62:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b64:	0001a517          	auipc	a0,0x1a
    80002b68:	81450513          	addi	a0,a0,-2028 # 8001c378 <itable>
    80002b6c:	00003097          	auipc	ra,0x3
    80002b70:	66e080e7          	jalr	1646(ra) # 800061da <acquire>
  ip->ref++;
    80002b74:	449c                	lw	a5,8(s1)
    80002b76:	2785                	addiw	a5,a5,1
    80002b78:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b7a:	00019517          	auipc	a0,0x19
    80002b7e:	7fe50513          	addi	a0,a0,2046 # 8001c378 <itable>
    80002b82:	00003097          	auipc	ra,0x3
    80002b86:	70c080e7          	jalr	1804(ra) # 8000628e <release>
}
    80002b8a:	8526                	mv	a0,s1
    80002b8c:	60e2                	ld	ra,24(sp)
    80002b8e:	6442                	ld	s0,16(sp)
    80002b90:	64a2                	ld	s1,8(sp)
    80002b92:	6105                	addi	sp,sp,32
    80002b94:	8082                	ret

0000000080002b96 <ilock>:
{
    80002b96:	1101                	addi	sp,sp,-32
    80002b98:	ec06                	sd	ra,24(sp)
    80002b9a:	e822                	sd	s0,16(sp)
    80002b9c:	e426                	sd	s1,8(sp)
    80002b9e:	e04a                	sd	s2,0(sp)
    80002ba0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ba2:	c115                	beqz	a0,80002bc6 <ilock+0x30>
    80002ba4:	84aa                	mv	s1,a0
    80002ba6:	451c                	lw	a5,8(a0)
    80002ba8:	00f05f63          	blez	a5,80002bc6 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bac:	0541                	addi	a0,a0,16
    80002bae:	00001097          	auipc	ra,0x1
    80002bb2:	cb2080e7          	jalr	-846(ra) # 80003860 <acquiresleep>
  if(ip->valid == 0){
    80002bb6:	40bc                	lw	a5,64(s1)
    80002bb8:	cf99                	beqz	a5,80002bd6 <ilock+0x40>
}
    80002bba:	60e2                	ld	ra,24(sp)
    80002bbc:	6442                	ld	s0,16(sp)
    80002bbe:	64a2                	ld	s1,8(sp)
    80002bc0:	6902                	ld	s2,0(sp)
    80002bc2:	6105                	addi	sp,sp,32
    80002bc4:	8082                	ret
    panic("ilock");
    80002bc6:	00006517          	auipc	a0,0x6
    80002bca:	99250513          	addi	a0,a0,-1646 # 80008558 <syscalls+0x190>
    80002bce:	00003097          	auipc	ra,0x3
    80002bd2:	0ec080e7          	jalr	236(ra) # 80005cba <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bd6:	40dc                	lw	a5,4(s1)
    80002bd8:	0047d79b          	srliw	a5,a5,0x4
    80002bdc:	00019597          	auipc	a1,0x19
    80002be0:	7945a583          	lw	a1,1940(a1) # 8001c370 <sb+0x18>
    80002be4:	9dbd                	addw	a1,a1,a5
    80002be6:	4088                	lw	a0,0(s1)
    80002be8:	fffff097          	auipc	ra,0xfffff
    80002bec:	7ac080e7          	jalr	1964(ra) # 80002394 <bread>
    80002bf0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bf2:	05850593          	addi	a1,a0,88
    80002bf6:	40dc                	lw	a5,4(s1)
    80002bf8:	8bbd                	andi	a5,a5,15
    80002bfa:	079a                	slli	a5,a5,0x6
    80002bfc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bfe:	00059783          	lh	a5,0(a1)
    80002c02:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c06:	00259783          	lh	a5,2(a1)
    80002c0a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c0e:	00459783          	lh	a5,4(a1)
    80002c12:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c16:	00659783          	lh	a5,6(a1)
    80002c1a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c1e:	459c                	lw	a5,8(a1)
    80002c20:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c22:	03400613          	li	a2,52
    80002c26:	05b1                	addi	a1,a1,12
    80002c28:	05048513          	addi	a0,s1,80
    80002c2c:	ffffd097          	auipc	ra,0xffffd
    80002c30:	5ac080e7          	jalr	1452(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c34:	854a                	mv	a0,s2
    80002c36:	00000097          	auipc	ra,0x0
    80002c3a:	88e080e7          	jalr	-1906(ra) # 800024c4 <brelse>
    ip->valid = 1;
    80002c3e:	4785                	li	a5,1
    80002c40:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c42:	04449783          	lh	a5,68(s1)
    80002c46:	fbb5                	bnez	a5,80002bba <ilock+0x24>
      panic("ilock: no type");
    80002c48:	00006517          	auipc	a0,0x6
    80002c4c:	91850513          	addi	a0,a0,-1768 # 80008560 <syscalls+0x198>
    80002c50:	00003097          	auipc	ra,0x3
    80002c54:	06a080e7          	jalr	106(ra) # 80005cba <panic>

0000000080002c58 <iunlock>:
{
    80002c58:	1101                	addi	sp,sp,-32
    80002c5a:	ec06                	sd	ra,24(sp)
    80002c5c:	e822                	sd	s0,16(sp)
    80002c5e:	e426                	sd	s1,8(sp)
    80002c60:	e04a                	sd	s2,0(sp)
    80002c62:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c64:	c905                	beqz	a0,80002c94 <iunlock+0x3c>
    80002c66:	84aa                	mv	s1,a0
    80002c68:	01050913          	addi	s2,a0,16
    80002c6c:	854a                	mv	a0,s2
    80002c6e:	00001097          	auipc	ra,0x1
    80002c72:	c8c080e7          	jalr	-884(ra) # 800038fa <holdingsleep>
    80002c76:	cd19                	beqz	a0,80002c94 <iunlock+0x3c>
    80002c78:	449c                	lw	a5,8(s1)
    80002c7a:	00f05d63          	blez	a5,80002c94 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c7e:	854a                	mv	a0,s2
    80002c80:	00001097          	auipc	ra,0x1
    80002c84:	c36080e7          	jalr	-970(ra) # 800038b6 <releasesleep>
}
    80002c88:	60e2                	ld	ra,24(sp)
    80002c8a:	6442                	ld	s0,16(sp)
    80002c8c:	64a2                	ld	s1,8(sp)
    80002c8e:	6902                	ld	s2,0(sp)
    80002c90:	6105                	addi	sp,sp,32
    80002c92:	8082                	ret
    panic("iunlock");
    80002c94:	00006517          	auipc	a0,0x6
    80002c98:	8dc50513          	addi	a0,a0,-1828 # 80008570 <syscalls+0x1a8>
    80002c9c:	00003097          	auipc	ra,0x3
    80002ca0:	01e080e7          	jalr	30(ra) # 80005cba <panic>

0000000080002ca4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ca4:	7179                	addi	sp,sp,-48
    80002ca6:	f406                	sd	ra,40(sp)
    80002ca8:	f022                	sd	s0,32(sp)
    80002caa:	ec26                	sd	s1,24(sp)
    80002cac:	e84a                	sd	s2,16(sp)
    80002cae:	e44e                	sd	s3,8(sp)
    80002cb0:	e052                	sd	s4,0(sp)
    80002cb2:	1800                	addi	s0,sp,48
    80002cb4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cb6:	05050493          	addi	s1,a0,80
    80002cba:	08050913          	addi	s2,a0,128
    80002cbe:	a021                	j	80002cc6 <itrunc+0x22>
    80002cc0:	0491                	addi	s1,s1,4
    80002cc2:	01248d63          	beq	s1,s2,80002cdc <itrunc+0x38>
    if(ip->addrs[i]){
    80002cc6:	408c                	lw	a1,0(s1)
    80002cc8:	dde5                	beqz	a1,80002cc0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cca:	0009a503          	lw	a0,0(s3)
    80002cce:	00000097          	auipc	ra,0x0
    80002cd2:	90c080e7          	jalr	-1780(ra) # 800025da <bfree>
      ip->addrs[i] = 0;
    80002cd6:	0004a023          	sw	zero,0(s1)
    80002cda:	b7dd                	j	80002cc0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cdc:	0809a583          	lw	a1,128(s3)
    80002ce0:	e185                	bnez	a1,80002d00 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ce2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ce6:	854e                	mv	a0,s3
    80002ce8:	00000097          	auipc	ra,0x0
    80002cec:	de4080e7          	jalr	-540(ra) # 80002acc <iupdate>
}
    80002cf0:	70a2                	ld	ra,40(sp)
    80002cf2:	7402                	ld	s0,32(sp)
    80002cf4:	64e2                	ld	s1,24(sp)
    80002cf6:	6942                	ld	s2,16(sp)
    80002cf8:	69a2                	ld	s3,8(sp)
    80002cfa:	6a02                	ld	s4,0(sp)
    80002cfc:	6145                	addi	sp,sp,48
    80002cfe:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d00:	0009a503          	lw	a0,0(s3)
    80002d04:	fffff097          	auipc	ra,0xfffff
    80002d08:	690080e7          	jalr	1680(ra) # 80002394 <bread>
    80002d0c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d0e:	05850493          	addi	s1,a0,88
    80002d12:	45850913          	addi	s2,a0,1112
    80002d16:	a811                	j	80002d2a <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d18:	0009a503          	lw	a0,0(s3)
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	8be080e7          	jalr	-1858(ra) # 800025da <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d24:	0491                	addi	s1,s1,4
    80002d26:	01248563          	beq	s1,s2,80002d30 <itrunc+0x8c>
      if(a[j])
    80002d2a:	408c                	lw	a1,0(s1)
    80002d2c:	dde5                	beqz	a1,80002d24 <itrunc+0x80>
    80002d2e:	b7ed                	j	80002d18 <itrunc+0x74>
    brelse(bp);
    80002d30:	8552                	mv	a0,s4
    80002d32:	fffff097          	auipc	ra,0xfffff
    80002d36:	792080e7          	jalr	1938(ra) # 800024c4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d3a:	0809a583          	lw	a1,128(s3)
    80002d3e:	0009a503          	lw	a0,0(s3)
    80002d42:	00000097          	auipc	ra,0x0
    80002d46:	898080e7          	jalr	-1896(ra) # 800025da <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d4a:	0809a023          	sw	zero,128(s3)
    80002d4e:	bf51                	j	80002ce2 <itrunc+0x3e>

0000000080002d50 <iput>:
{
    80002d50:	1101                	addi	sp,sp,-32
    80002d52:	ec06                	sd	ra,24(sp)
    80002d54:	e822                	sd	s0,16(sp)
    80002d56:	e426                	sd	s1,8(sp)
    80002d58:	e04a                	sd	s2,0(sp)
    80002d5a:	1000                	addi	s0,sp,32
    80002d5c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d5e:	00019517          	auipc	a0,0x19
    80002d62:	61a50513          	addi	a0,a0,1562 # 8001c378 <itable>
    80002d66:	00003097          	auipc	ra,0x3
    80002d6a:	474080e7          	jalr	1140(ra) # 800061da <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d6e:	4498                	lw	a4,8(s1)
    80002d70:	4785                	li	a5,1
    80002d72:	02f70363          	beq	a4,a5,80002d98 <iput+0x48>
  ip->ref--;
    80002d76:	449c                	lw	a5,8(s1)
    80002d78:	37fd                	addiw	a5,a5,-1
    80002d7a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d7c:	00019517          	auipc	a0,0x19
    80002d80:	5fc50513          	addi	a0,a0,1532 # 8001c378 <itable>
    80002d84:	00003097          	auipc	ra,0x3
    80002d88:	50a080e7          	jalr	1290(ra) # 8000628e <release>
}
    80002d8c:	60e2                	ld	ra,24(sp)
    80002d8e:	6442                	ld	s0,16(sp)
    80002d90:	64a2                	ld	s1,8(sp)
    80002d92:	6902                	ld	s2,0(sp)
    80002d94:	6105                	addi	sp,sp,32
    80002d96:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d98:	40bc                	lw	a5,64(s1)
    80002d9a:	dff1                	beqz	a5,80002d76 <iput+0x26>
    80002d9c:	04a49783          	lh	a5,74(s1)
    80002da0:	fbf9                	bnez	a5,80002d76 <iput+0x26>
    acquiresleep(&ip->lock);
    80002da2:	01048913          	addi	s2,s1,16
    80002da6:	854a                	mv	a0,s2
    80002da8:	00001097          	auipc	ra,0x1
    80002dac:	ab8080e7          	jalr	-1352(ra) # 80003860 <acquiresleep>
    release(&itable.lock);
    80002db0:	00019517          	auipc	a0,0x19
    80002db4:	5c850513          	addi	a0,a0,1480 # 8001c378 <itable>
    80002db8:	00003097          	auipc	ra,0x3
    80002dbc:	4d6080e7          	jalr	1238(ra) # 8000628e <release>
    itrunc(ip);
    80002dc0:	8526                	mv	a0,s1
    80002dc2:	00000097          	auipc	ra,0x0
    80002dc6:	ee2080e7          	jalr	-286(ra) # 80002ca4 <itrunc>
    ip->type = 0;
    80002dca:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dce:	8526                	mv	a0,s1
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	cfc080e7          	jalr	-772(ra) # 80002acc <iupdate>
    ip->valid = 0;
    80002dd8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ddc:	854a                	mv	a0,s2
    80002dde:	00001097          	auipc	ra,0x1
    80002de2:	ad8080e7          	jalr	-1320(ra) # 800038b6 <releasesleep>
    acquire(&itable.lock);
    80002de6:	00019517          	auipc	a0,0x19
    80002dea:	59250513          	addi	a0,a0,1426 # 8001c378 <itable>
    80002dee:	00003097          	auipc	ra,0x3
    80002df2:	3ec080e7          	jalr	1004(ra) # 800061da <acquire>
    80002df6:	b741                	j	80002d76 <iput+0x26>

0000000080002df8 <iunlockput>:
{
    80002df8:	1101                	addi	sp,sp,-32
    80002dfa:	ec06                	sd	ra,24(sp)
    80002dfc:	e822                	sd	s0,16(sp)
    80002dfe:	e426                	sd	s1,8(sp)
    80002e00:	1000                	addi	s0,sp,32
    80002e02:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e04:	00000097          	auipc	ra,0x0
    80002e08:	e54080e7          	jalr	-428(ra) # 80002c58 <iunlock>
  iput(ip);
    80002e0c:	8526                	mv	a0,s1
    80002e0e:	00000097          	auipc	ra,0x0
    80002e12:	f42080e7          	jalr	-190(ra) # 80002d50 <iput>
}
    80002e16:	60e2                	ld	ra,24(sp)
    80002e18:	6442                	ld	s0,16(sp)
    80002e1a:	64a2                	ld	s1,8(sp)
    80002e1c:	6105                	addi	sp,sp,32
    80002e1e:	8082                	ret

0000000080002e20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e20:	1141                	addi	sp,sp,-16
    80002e22:	e422                	sd	s0,8(sp)
    80002e24:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e26:	411c                	lw	a5,0(a0)
    80002e28:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e2a:	415c                	lw	a5,4(a0)
    80002e2c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e2e:	04451783          	lh	a5,68(a0)
    80002e32:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e36:	04a51783          	lh	a5,74(a0)
    80002e3a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e3e:	04c56783          	lwu	a5,76(a0)
    80002e42:	e99c                	sd	a5,16(a1)
}
    80002e44:	6422                	ld	s0,8(sp)
    80002e46:	0141                	addi	sp,sp,16
    80002e48:	8082                	ret

0000000080002e4a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e4a:	457c                	lw	a5,76(a0)
    80002e4c:	0ed7e963          	bltu	a5,a3,80002f3e <readi+0xf4>
{
    80002e50:	7159                	addi	sp,sp,-112
    80002e52:	f486                	sd	ra,104(sp)
    80002e54:	f0a2                	sd	s0,96(sp)
    80002e56:	eca6                	sd	s1,88(sp)
    80002e58:	e8ca                	sd	s2,80(sp)
    80002e5a:	e4ce                	sd	s3,72(sp)
    80002e5c:	e0d2                	sd	s4,64(sp)
    80002e5e:	fc56                	sd	s5,56(sp)
    80002e60:	f85a                	sd	s6,48(sp)
    80002e62:	f45e                	sd	s7,40(sp)
    80002e64:	f062                	sd	s8,32(sp)
    80002e66:	ec66                	sd	s9,24(sp)
    80002e68:	e86a                	sd	s10,16(sp)
    80002e6a:	e46e                	sd	s11,8(sp)
    80002e6c:	1880                	addi	s0,sp,112
    80002e6e:	8baa                	mv	s7,a0
    80002e70:	8c2e                	mv	s8,a1
    80002e72:	8ab2                	mv	s5,a2
    80002e74:	84b6                	mv	s1,a3
    80002e76:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e78:	9f35                	addw	a4,a4,a3
    return 0;
    80002e7a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e7c:	0ad76063          	bltu	a4,a3,80002f1c <readi+0xd2>
  if(off + n > ip->size)
    80002e80:	00e7f463          	bgeu	a5,a4,80002e88 <readi+0x3e>
    n = ip->size - off;
    80002e84:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e88:	0a0b0963          	beqz	s6,80002f3a <readi+0xf0>
    80002e8c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e8e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e92:	5cfd                	li	s9,-1
    80002e94:	a82d                	j	80002ece <readi+0x84>
    80002e96:	020a1d93          	slli	s11,s4,0x20
    80002e9a:	020ddd93          	srli	s11,s11,0x20
    80002e9e:	05890613          	addi	a2,s2,88
    80002ea2:	86ee                	mv	a3,s11
    80002ea4:	963a                	add	a2,a2,a4
    80002ea6:	85d6                	mv	a1,s5
    80002ea8:	8562                	mv	a0,s8
    80002eaa:	fffff097          	auipc	ra,0xfffff
    80002eae:	a0c080e7          	jalr	-1524(ra) # 800018b6 <either_copyout>
    80002eb2:	05950d63          	beq	a0,s9,80002f0c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eb6:	854a                	mv	a0,s2
    80002eb8:	fffff097          	auipc	ra,0xfffff
    80002ebc:	60c080e7          	jalr	1548(ra) # 800024c4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec0:	013a09bb          	addw	s3,s4,s3
    80002ec4:	009a04bb          	addw	s1,s4,s1
    80002ec8:	9aee                	add	s5,s5,s11
    80002eca:	0569f763          	bgeu	s3,s6,80002f18 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ece:	000ba903          	lw	s2,0(s7)
    80002ed2:	00a4d59b          	srliw	a1,s1,0xa
    80002ed6:	855e                	mv	a0,s7
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	8b0080e7          	jalr	-1872(ra) # 80002788 <bmap>
    80002ee0:	0005059b          	sext.w	a1,a0
    80002ee4:	854a                	mv	a0,s2
    80002ee6:	fffff097          	auipc	ra,0xfffff
    80002eea:	4ae080e7          	jalr	1198(ra) # 80002394 <bread>
    80002eee:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ef0:	3ff4f713          	andi	a4,s1,1023
    80002ef4:	40ed07bb          	subw	a5,s10,a4
    80002ef8:	413b06bb          	subw	a3,s6,s3
    80002efc:	8a3e                	mv	s4,a5
    80002efe:	2781                	sext.w	a5,a5
    80002f00:	0006861b          	sext.w	a2,a3
    80002f04:	f8f679e3          	bgeu	a2,a5,80002e96 <readi+0x4c>
    80002f08:	8a36                	mv	s4,a3
    80002f0a:	b771                	j	80002e96 <readi+0x4c>
      brelse(bp);
    80002f0c:	854a                	mv	a0,s2
    80002f0e:	fffff097          	auipc	ra,0xfffff
    80002f12:	5b6080e7          	jalr	1462(ra) # 800024c4 <brelse>
      tot = -1;
    80002f16:	59fd                	li	s3,-1
  }
  return tot;
    80002f18:	0009851b          	sext.w	a0,s3
}
    80002f1c:	70a6                	ld	ra,104(sp)
    80002f1e:	7406                	ld	s0,96(sp)
    80002f20:	64e6                	ld	s1,88(sp)
    80002f22:	6946                	ld	s2,80(sp)
    80002f24:	69a6                	ld	s3,72(sp)
    80002f26:	6a06                	ld	s4,64(sp)
    80002f28:	7ae2                	ld	s5,56(sp)
    80002f2a:	7b42                	ld	s6,48(sp)
    80002f2c:	7ba2                	ld	s7,40(sp)
    80002f2e:	7c02                	ld	s8,32(sp)
    80002f30:	6ce2                	ld	s9,24(sp)
    80002f32:	6d42                	ld	s10,16(sp)
    80002f34:	6da2                	ld	s11,8(sp)
    80002f36:	6165                	addi	sp,sp,112
    80002f38:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f3a:	89da                	mv	s3,s6
    80002f3c:	bff1                	j	80002f18 <readi+0xce>
    return 0;
    80002f3e:	4501                	li	a0,0
}
    80002f40:	8082                	ret

0000000080002f42 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f42:	457c                	lw	a5,76(a0)
    80002f44:	10d7e863          	bltu	a5,a3,80003054 <writei+0x112>
{
    80002f48:	7159                	addi	sp,sp,-112
    80002f4a:	f486                	sd	ra,104(sp)
    80002f4c:	f0a2                	sd	s0,96(sp)
    80002f4e:	eca6                	sd	s1,88(sp)
    80002f50:	e8ca                	sd	s2,80(sp)
    80002f52:	e4ce                	sd	s3,72(sp)
    80002f54:	e0d2                	sd	s4,64(sp)
    80002f56:	fc56                	sd	s5,56(sp)
    80002f58:	f85a                	sd	s6,48(sp)
    80002f5a:	f45e                	sd	s7,40(sp)
    80002f5c:	f062                	sd	s8,32(sp)
    80002f5e:	ec66                	sd	s9,24(sp)
    80002f60:	e86a                	sd	s10,16(sp)
    80002f62:	e46e                	sd	s11,8(sp)
    80002f64:	1880                	addi	s0,sp,112
    80002f66:	8b2a                	mv	s6,a0
    80002f68:	8c2e                	mv	s8,a1
    80002f6a:	8ab2                	mv	s5,a2
    80002f6c:	8936                	mv	s2,a3
    80002f6e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f70:	00e687bb          	addw	a5,a3,a4
    80002f74:	0ed7e263          	bltu	a5,a3,80003058 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f78:	00043737          	lui	a4,0x43
    80002f7c:	0ef76063          	bltu	a4,a5,8000305c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f80:	0c0b8863          	beqz	s7,80003050 <writei+0x10e>
    80002f84:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f86:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f8a:	5cfd                	li	s9,-1
    80002f8c:	a091                	j	80002fd0 <writei+0x8e>
    80002f8e:	02099d93          	slli	s11,s3,0x20
    80002f92:	020ddd93          	srli	s11,s11,0x20
    80002f96:	05848513          	addi	a0,s1,88
    80002f9a:	86ee                	mv	a3,s11
    80002f9c:	8656                	mv	a2,s5
    80002f9e:	85e2                	mv	a1,s8
    80002fa0:	953a                	add	a0,a0,a4
    80002fa2:	fffff097          	auipc	ra,0xfffff
    80002fa6:	96a080e7          	jalr	-1686(ra) # 8000190c <either_copyin>
    80002faa:	07950263          	beq	a0,s9,8000300e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fae:	8526                	mv	a0,s1
    80002fb0:	00000097          	auipc	ra,0x0
    80002fb4:	790080e7          	jalr	1936(ra) # 80003740 <log_write>
    brelse(bp);
    80002fb8:	8526                	mv	a0,s1
    80002fba:	fffff097          	auipc	ra,0xfffff
    80002fbe:	50a080e7          	jalr	1290(ra) # 800024c4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fc2:	01498a3b          	addw	s4,s3,s4
    80002fc6:	0129893b          	addw	s2,s3,s2
    80002fca:	9aee                	add	s5,s5,s11
    80002fcc:	057a7663          	bgeu	s4,s7,80003018 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fd0:	000b2483          	lw	s1,0(s6)
    80002fd4:	00a9559b          	srliw	a1,s2,0xa
    80002fd8:	855a                	mv	a0,s6
    80002fda:	fffff097          	auipc	ra,0xfffff
    80002fde:	7ae080e7          	jalr	1966(ra) # 80002788 <bmap>
    80002fe2:	0005059b          	sext.w	a1,a0
    80002fe6:	8526                	mv	a0,s1
    80002fe8:	fffff097          	auipc	ra,0xfffff
    80002fec:	3ac080e7          	jalr	940(ra) # 80002394 <bread>
    80002ff0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ff2:	3ff97713          	andi	a4,s2,1023
    80002ff6:	40ed07bb          	subw	a5,s10,a4
    80002ffa:	414b86bb          	subw	a3,s7,s4
    80002ffe:	89be                	mv	s3,a5
    80003000:	2781                	sext.w	a5,a5
    80003002:	0006861b          	sext.w	a2,a3
    80003006:	f8f674e3          	bgeu	a2,a5,80002f8e <writei+0x4c>
    8000300a:	89b6                	mv	s3,a3
    8000300c:	b749                	j	80002f8e <writei+0x4c>
      brelse(bp);
    8000300e:	8526                	mv	a0,s1
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	4b4080e7          	jalr	1204(ra) # 800024c4 <brelse>
  }

  if(off > ip->size)
    80003018:	04cb2783          	lw	a5,76(s6)
    8000301c:	0127f463          	bgeu	a5,s2,80003024 <writei+0xe2>
    ip->size = off;
    80003020:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003024:	855a                	mv	a0,s6
    80003026:	00000097          	auipc	ra,0x0
    8000302a:	aa6080e7          	jalr	-1370(ra) # 80002acc <iupdate>

  return tot;
    8000302e:	000a051b          	sext.w	a0,s4
}
    80003032:	70a6                	ld	ra,104(sp)
    80003034:	7406                	ld	s0,96(sp)
    80003036:	64e6                	ld	s1,88(sp)
    80003038:	6946                	ld	s2,80(sp)
    8000303a:	69a6                	ld	s3,72(sp)
    8000303c:	6a06                	ld	s4,64(sp)
    8000303e:	7ae2                	ld	s5,56(sp)
    80003040:	7b42                	ld	s6,48(sp)
    80003042:	7ba2                	ld	s7,40(sp)
    80003044:	7c02                	ld	s8,32(sp)
    80003046:	6ce2                	ld	s9,24(sp)
    80003048:	6d42                	ld	s10,16(sp)
    8000304a:	6da2                	ld	s11,8(sp)
    8000304c:	6165                	addi	sp,sp,112
    8000304e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003050:	8a5e                	mv	s4,s7
    80003052:	bfc9                	j	80003024 <writei+0xe2>
    return -1;
    80003054:	557d                	li	a0,-1
}
    80003056:	8082                	ret
    return -1;
    80003058:	557d                	li	a0,-1
    8000305a:	bfe1                	j	80003032 <writei+0xf0>
    return -1;
    8000305c:	557d                	li	a0,-1
    8000305e:	bfd1                	j	80003032 <writei+0xf0>

0000000080003060 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003060:	1141                	addi	sp,sp,-16
    80003062:	e406                	sd	ra,8(sp)
    80003064:	e022                	sd	s0,0(sp)
    80003066:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003068:	4639                	li	a2,14
    8000306a:	ffffd097          	auipc	ra,0xffffd
    8000306e:	1e6080e7          	jalr	486(ra) # 80000250 <strncmp>
}
    80003072:	60a2                	ld	ra,8(sp)
    80003074:	6402                	ld	s0,0(sp)
    80003076:	0141                	addi	sp,sp,16
    80003078:	8082                	ret

000000008000307a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000307a:	7139                	addi	sp,sp,-64
    8000307c:	fc06                	sd	ra,56(sp)
    8000307e:	f822                	sd	s0,48(sp)
    80003080:	f426                	sd	s1,40(sp)
    80003082:	f04a                	sd	s2,32(sp)
    80003084:	ec4e                	sd	s3,24(sp)
    80003086:	e852                	sd	s4,16(sp)
    80003088:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000308a:	04451703          	lh	a4,68(a0)
    8000308e:	4785                	li	a5,1
    80003090:	00f71a63          	bne	a4,a5,800030a4 <dirlookup+0x2a>
    80003094:	892a                	mv	s2,a0
    80003096:	89ae                	mv	s3,a1
    80003098:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000309a:	457c                	lw	a5,76(a0)
    8000309c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000309e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030a0:	e79d                	bnez	a5,800030ce <dirlookup+0x54>
    800030a2:	a8a5                	j	8000311a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030a4:	00005517          	auipc	a0,0x5
    800030a8:	4d450513          	addi	a0,a0,1236 # 80008578 <syscalls+0x1b0>
    800030ac:	00003097          	auipc	ra,0x3
    800030b0:	c0e080e7          	jalr	-1010(ra) # 80005cba <panic>
      panic("dirlookup read");
    800030b4:	00005517          	auipc	a0,0x5
    800030b8:	4dc50513          	addi	a0,a0,1244 # 80008590 <syscalls+0x1c8>
    800030bc:	00003097          	auipc	ra,0x3
    800030c0:	bfe080e7          	jalr	-1026(ra) # 80005cba <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c4:	24c1                	addiw	s1,s1,16
    800030c6:	04c92783          	lw	a5,76(s2)
    800030ca:	04f4f763          	bgeu	s1,a5,80003118 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030ce:	4741                	li	a4,16
    800030d0:	86a6                	mv	a3,s1
    800030d2:	fc040613          	addi	a2,s0,-64
    800030d6:	4581                	li	a1,0
    800030d8:	854a                	mv	a0,s2
    800030da:	00000097          	auipc	ra,0x0
    800030de:	d70080e7          	jalr	-656(ra) # 80002e4a <readi>
    800030e2:	47c1                	li	a5,16
    800030e4:	fcf518e3          	bne	a0,a5,800030b4 <dirlookup+0x3a>
    if(de.inum == 0)
    800030e8:	fc045783          	lhu	a5,-64(s0)
    800030ec:	dfe1                	beqz	a5,800030c4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030ee:	fc240593          	addi	a1,s0,-62
    800030f2:	854e                	mv	a0,s3
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	f6c080e7          	jalr	-148(ra) # 80003060 <namecmp>
    800030fc:	f561                	bnez	a0,800030c4 <dirlookup+0x4a>
      if(poff)
    800030fe:	000a0463          	beqz	s4,80003106 <dirlookup+0x8c>
        *poff = off;
    80003102:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003106:	fc045583          	lhu	a1,-64(s0)
    8000310a:	00092503          	lw	a0,0(s2)
    8000310e:	fffff097          	auipc	ra,0xfffff
    80003112:	754080e7          	jalr	1876(ra) # 80002862 <iget>
    80003116:	a011                	j	8000311a <dirlookup+0xa0>
  return 0;
    80003118:	4501                	li	a0,0
}
    8000311a:	70e2                	ld	ra,56(sp)
    8000311c:	7442                	ld	s0,48(sp)
    8000311e:	74a2                	ld	s1,40(sp)
    80003120:	7902                	ld	s2,32(sp)
    80003122:	69e2                	ld	s3,24(sp)
    80003124:	6a42                	ld	s4,16(sp)
    80003126:	6121                	addi	sp,sp,64
    80003128:	8082                	ret

000000008000312a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000312a:	711d                	addi	sp,sp,-96
    8000312c:	ec86                	sd	ra,88(sp)
    8000312e:	e8a2                	sd	s0,80(sp)
    80003130:	e4a6                	sd	s1,72(sp)
    80003132:	e0ca                	sd	s2,64(sp)
    80003134:	fc4e                	sd	s3,56(sp)
    80003136:	f852                	sd	s4,48(sp)
    80003138:	f456                	sd	s5,40(sp)
    8000313a:	f05a                	sd	s6,32(sp)
    8000313c:	ec5e                	sd	s7,24(sp)
    8000313e:	e862                	sd	s8,16(sp)
    80003140:	e466                	sd	s9,8(sp)
    80003142:	1080                	addi	s0,sp,96
    80003144:	84aa                	mv	s1,a0
    80003146:	8b2e                	mv	s6,a1
    80003148:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000314a:	00054703          	lbu	a4,0(a0)
    8000314e:	02f00793          	li	a5,47
    80003152:	02f70363          	beq	a4,a5,80003178 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003156:	ffffe097          	auipc	ra,0xffffe
    8000315a:	cf2080e7          	jalr	-782(ra) # 80000e48 <myproc>
    8000315e:	15053503          	ld	a0,336(a0)
    80003162:	00000097          	auipc	ra,0x0
    80003166:	9f6080e7          	jalr	-1546(ra) # 80002b58 <idup>
    8000316a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000316c:	02f00913          	li	s2,47
  len = path - s;
    80003170:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003172:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003174:	4c05                	li	s8,1
    80003176:	a865                	j	8000322e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003178:	4585                	li	a1,1
    8000317a:	4505                	li	a0,1
    8000317c:	fffff097          	auipc	ra,0xfffff
    80003180:	6e6080e7          	jalr	1766(ra) # 80002862 <iget>
    80003184:	89aa                	mv	s3,a0
    80003186:	b7dd                	j	8000316c <namex+0x42>
      iunlockput(ip);
    80003188:	854e                	mv	a0,s3
    8000318a:	00000097          	auipc	ra,0x0
    8000318e:	c6e080e7          	jalr	-914(ra) # 80002df8 <iunlockput>
      return 0;
    80003192:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003194:	854e                	mv	a0,s3
    80003196:	60e6                	ld	ra,88(sp)
    80003198:	6446                	ld	s0,80(sp)
    8000319a:	64a6                	ld	s1,72(sp)
    8000319c:	6906                	ld	s2,64(sp)
    8000319e:	79e2                	ld	s3,56(sp)
    800031a0:	7a42                	ld	s4,48(sp)
    800031a2:	7aa2                	ld	s5,40(sp)
    800031a4:	7b02                	ld	s6,32(sp)
    800031a6:	6be2                	ld	s7,24(sp)
    800031a8:	6c42                	ld	s8,16(sp)
    800031aa:	6ca2                	ld	s9,8(sp)
    800031ac:	6125                	addi	sp,sp,96
    800031ae:	8082                	ret
      iunlock(ip);
    800031b0:	854e                	mv	a0,s3
    800031b2:	00000097          	auipc	ra,0x0
    800031b6:	aa6080e7          	jalr	-1370(ra) # 80002c58 <iunlock>
      return ip;
    800031ba:	bfe9                	j	80003194 <namex+0x6a>
      iunlockput(ip);
    800031bc:	854e                	mv	a0,s3
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	c3a080e7          	jalr	-966(ra) # 80002df8 <iunlockput>
      return 0;
    800031c6:	89d2                	mv	s3,s4
    800031c8:	b7f1                	j	80003194 <namex+0x6a>
  len = path - s;
    800031ca:	40b48633          	sub	a2,s1,a1
    800031ce:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031d2:	094cd463          	bge	s9,s4,8000325a <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031d6:	4639                	li	a2,14
    800031d8:	8556                	mv	a0,s5
    800031da:	ffffd097          	auipc	ra,0xffffd
    800031de:	ffe080e7          	jalr	-2(ra) # 800001d8 <memmove>
  while(*path == '/')
    800031e2:	0004c783          	lbu	a5,0(s1)
    800031e6:	01279763          	bne	a5,s2,800031f4 <namex+0xca>
    path++;
    800031ea:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031ec:	0004c783          	lbu	a5,0(s1)
    800031f0:	ff278de3          	beq	a5,s2,800031ea <namex+0xc0>
    ilock(ip);
    800031f4:	854e                	mv	a0,s3
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	9a0080e7          	jalr	-1632(ra) # 80002b96 <ilock>
    if(ip->type != T_DIR){
    800031fe:	04499783          	lh	a5,68(s3)
    80003202:	f98793e3          	bne	a5,s8,80003188 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003206:	000b0563          	beqz	s6,80003210 <namex+0xe6>
    8000320a:	0004c783          	lbu	a5,0(s1)
    8000320e:	d3cd                	beqz	a5,800031b0 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003210:	865e                	mv	a2,s7
    80003212:	85d6                	mv	a1,s5
    80003214:	854e                	mv	a0,s3
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	e64080e7          	jalr	-412(ra) # 8000307a <dirlookup>
    8000321e:	8a2a                	mv	s4,a0
    80003220:	dd51                	beqz	a0,800031bc <namex+0x92>
    iunlockput(ip);
    80003222:	854e                	mv	a0,s3
    80003224:	00000097          	auipc	ra,0x0
    80003228:	bd4080e7          	jalr	-1068(ra) # 80002df8 <iunlockput>
    ip = next;
    8000322c:	89d2                	mv	s3,s4
  while(*path == '/')
    8000322e:	0004c783          	lbu	a5,0(s1)
    80003232:	05279763          	bne	a5,s2,80003280 <namex+0x156>
    path++;
    80003236:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003238:	0004c783          	lbu	a5,0(s1)
    8000323c:	ff278de3          	beq	a5,s2,80003236 <namex+0x10c>
  if(*path == 0)
    80003240:	c79d                	beqz	a5,8000326e <namex+0x144>
    path++;
    80003242:	85a6                	mv	a1,s1
  len = path - s;
    80003244:	8a5e                	mv	s4,s7
    80003246:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003248:	01278963          	beq	a5,s2,8000325a <namex+0x130>
    8000324c:	dfbd                	beqz	a5,800031ca <namex+0xa0>
    path++;
    8000324e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003250:	0004c783          	lbu	a5,0(s1)
    80003254:	ff279ce3          	bne	a5,s2,8000324c <namex+0x122>
    80003258:	bf8d                	j	800031ca <namex+0xa0>
    memmove(name, s, len);
    8000325a:	2601                	sext.w	a2,a2
    8000325c:	8556                	mv	a0,s5
    8000325e:	ffffd097          	auipc	ra,0xffffd
    80003262:	f7a080e7          	jalr	-134(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003266:	9a56                	add	s4,s4,s5
    80003268:	000a0023          	sb	zero,0(s4)
    8000326c:	bf9d                	j	800031e2 <namex+0xb8>
  if(nameiparent){
    8000326e:	f20b03e3          	beqz	s6,80003194 <namex+0x6a>
    iput(ip);
    80003272:	854e                	mv	a0,s3
    80003274:	00000097          	auipc	ra,0x0
    80003278:	adc080e7          	jalr	-1316(ra) # 80002d50 <iput>
    return 0;
    8000327c:	4981                	li	s3,0
    8000327e:	bf19                	j	80003194 <namex+0x6a>
  if(*path == 0)
    80003280:	d7fd                	beqz	a5,8000326e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003282:	0004c783          	lbu	a5,0(s1)
    80003286:	85a6                	mv	a1,s1
    80003288:	b7d1                	j	8000324c <namex+0x122>

000000008000328a <dirlink>:
{
    8000328a:	7139                	addi	sp,sp,-64
    8000328c:	fc06                	sd	ra,56(sp)
    8000328e:	f822                	sd	s0,48(sp)
    80003290:	f426                	sd	s1,40(sp)
    80003292:	f04a                	sd	s2,32(sp)
    80003294:	ec4e                	sd	s3,24(sp)
    80003296:	e852                	sd	s4,16(sp)
    80003298:	0080                	addi	s0,sp,64
    8000329a:	892a                	mv	s2,a0
    8000329c:	8a2e                	mv	s4,a1
    8000329e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032a0:	4601                	li	a2,0
    800032a2:	00000097          	auipc	ra,0x0
    800032a6:	dd8080e7          	jalr	-552(ra) # 8000307a <dirlookup>
    800032aa:	e93d                	bnez	a0,80003320 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ac:	04c92483          	lw	s1,76(s2)
    800032b0:	c49d                	beqz	s1,800032de <dirlink+0x54>
    800032b2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032b4:	4741                	li	a4,16
    800032b6:	86a6                	mv	a3,s1
    800032b8:	fc040613          	addi	a2,s0,-64
    800032bc:	4581                	li	a1,0
    800032be:	854a                	mv	a0,s2
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	b8a080e7          	jalr	-1142(ra) # 80002e4a <readi>
    800032c8:	47c1                	li	a5,16
    800032ca:	06f51163          	bne	a0,a5,8000332c <dirlink+0xa2>
    if(de.inum == 0)
    800032ce:	fc045783          	lhu	a5,-64(s0)
    800032d2:	c791                	beqz	a5,800032de <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d4:	24c1                	addiw	s1,s1,16
    800032d6:	04c92783          	lw	a5,76(s2)
    800032da:	fcf4ede3          	bltu	s1,a5,800032b4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032de:	4639                	li	a2,14
    800032e0:	85d2                	mv	a1,s4
    800032e2:	fc240513          	addi	a0,s0,-62
    800032e6:	ffffd097          	auipc	ra,0xffffd
    800032ea:	fa6080e7          	jalr	-90(ra) # 8000028c <strncpy>
  de.inum = inum;
    800032ee:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032f2:	4741                	li	a4,16
    800032f4:	86a6                	mv	a3,s1
    800032f6:	fc040613          	addi	a2,s0,-64
    800032fa:	4581                	li	a1,0
    800032fc:	854a                	mv	a0,s2
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	c44080e7          	jalr	-956(ra) # 80002f42 <writei>
    80003306:	872a                	mv	a4,a0
    80003308:	47c1                	li	a5,16
  return 0;
    8000330a:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000330c:	02f71863          	bne	a4,a5,8000333c <dirlink+0xb2>
}
    80003310:	70e2                	ld	ra,56(sp)
    80003312:	7442                	ld	s0,48(sp)
    80003314:	74a2                	ld	s1,40(sp)
    80003316:	7902                	ld	s2,32(sp)
    80003318:	69e2                	ld	s3,24(sp)
    8000331a:	6a42                	ld	s4,16(sp)
    8000331c:	6121                	addi	sp,sp,64
    8000331e:	8082                	ret
    iput(ip);
    80003320:	00000097          	auipc	ra,0x0
    80003324:	a30080e7          	jalr	-1488(ra) # 80002d50 <iput>
    return -1;
    80003328:	557d                	li	a0,-1
    8000332a:	b7dd                	j	80003310 <dirlink+0x86>
      panic("dirlink read");
    8000332c:	00005517          	auipc	a0,0x5
    80003330:	27450513          	addi	a0,a0,628 # 800085a0 <syscalls+0x1d8>
    80003334:	00003097          	auipc	ra,0x3
    80003338:	986080e7          	jalr	-1658(ra) # 80005cba <panic>
    panic("dirlink");
    8000333c:	00005517          	auipc	a0,0x5
    80003340:	37450513          	addi	a0,a0,884 # 800086b0 <syscalls+0x2e8>
    80003344:	00003097          	auipc	ra,0x3
    80003348:	976080e7          	jalr	-1674(ra) # 80005cba <panic>

000000008000334c <namei>:

struct inode*
namei(char *path)
{
    8000334c:	1101                	addi	sp,sp,-32
    8000334e:	ec06                	sd	ra,24(sp)
    80003350:	e822                	sd	s0,16(sp)
    80003352:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003354:	fe040613          	addi	a2,s0,-32
    80003358:	4581                	li	a1,0
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	dd0080e7          	jalr	-560(ra) # 8000312a <namex>
}
    80003362:	60e2                	ld	ra,24(sp)
    80003364:	6442                	ld	s0,16(sp)
    80003366:	6105                	addi	sp,sp,32
    80003368:	8082                	ret

000000008000336a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000336a:	1141                	addi	sp,sp,-16
    8000336c:	e406                	sd	ra,8(sp)
    8000336e:	e022                	sd	s0,0(sp)
    80003370:	0800                	addi	s0,sp,16
    80003372:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003374:	4585                	li	a1,1
    80003376:	00000097          	auipc	ra,0x0
    8000337a:	db4080e7          	jalr	-588(ra) # 8000312a <namex>
}
    8000337e:	60a2                	ld	ra,8(sp)
    80003380:	6402                	ld	s0,0(sp)
    80003382:	0141                	addi	sp,sp,16
    80003384:	8082                	ret

0000000080003386 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003386:	1101                	addi	sp,sp,-32
    80003388:	ec06                	sd	ra,24(sp)
    8000338a:	e822                	sd	s0,16(sp)
    8000338c:	e426                	sd	s1,8(sp)
    8000338e:	e04a                	sd	s2,0(sp)
    80003390:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003392:	0001b917          	auipc	s2,0x1b
    80003396:	a8e90913          	addi	s2,s2,-1394 # 8001de20 <log>
    8000339a:	01892583          	lw	a1,24(s2)
    8000339e:	02892503          	lw	a0,40(s2)
    800033a2:	fffff097          	auipc	ra,0xfffff
    800033a6:	ff2080e7          	jalr	-14(ra) # 80002394 <bread>
    800033aa:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033ac:	02c92683          	lw	a3,44(s2)
    800033b0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033b2:	02d05763          	blez	a3,800033e0 <write_head+0x5a>
    800033b6:	0001b797          	auipc	a5,0x1b
    800033ba:	a9a78793          	addi	a5,a5,-1382 # 8001de50 <log+0x30>
    800033be:	05c50713          	addi	a4,a0,92
    800033c2:	36fd                	addiw	a3,a3,-1
    800033c4:	1682                	slli	a3,a3,0x20
    800033c6:	9281                	srli	a3,a3,0x20
    800033c8:	068a                	slli	a3,a3,0x2
    800033ca:	0001b617          	auipc	a2,0x1b
    800033ce:	a8a60613          	addi	a2,a2,-1398 # 8001de54 <log+0x34>
    800033d2:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033d4:	4390                	lw	a2,0(a5)
    800033d6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033d8:	0791                	addi	a5,a5,4
    800033da:	0711                	addi	a4,a4,4
    800033dc:	fed79ce3          	bne	a5,a3,800033d4 <write_head+0x4e>
  }
  bwrite(buf);
    800033e0:	8526                	mv	a0,s1
    800033e2:	fffff097          	auipc	ra,0xfffff
    800033e6:	0a4080e7          	jalr	164(ra) # 80002486 <bwrite>
  brelse(buf);
    800033ea:	8526                	mv	a0,s1
    800033ec:	fffff097          	auipc	ra,0xfffff
    800033f0:	0d8080e7          	jalr	216(ra) # 800024c4 <brelse>
}
    800033f4:	60e2                	ld	ra,24(sp)
    800033f6:	6442                	ld	s0,16(sp)
    800033f8:	64a2                	ld	s1,8(sp)
    800033fa:	6902                	ld	s2,0(sp)
    800033fc:	6105                	addi	sp,sp,32
    800033fe:	8082                	ret

0000000080003400 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003400:	0001b797          	auipc	a5,0x1b
    80003404:	a4c7a783          	lw	a5,-1460(a5) # 8001de4c <log+0x2c>
    80003408:	0af05d63          	blez	a5,800034c2 <install_trans+0xc2>
{
    8000340c:	7139                	addi	sp,sp,-64
    8000340e:	fc06                	sd	ra,56(sp)
    80003410:	f822                	sd	s0,48(sp)
    80003412:	f426                	sd	s1,40(sp)
    80003414:	f04a                	sd	s2,32(sp)
    80003416:	ec4e                	sd	s3,24(sp)
    80003418:	e852                	sd	s4,16(sp)
    8000341a:	e456                	sd	s5,8(sp)
    8000341c:	e05a                	sd	s6,0(sp)
    8000341e:	0080                	addi	s0,sp,64
    80003420:	8b2a                	mv	s6,a0
    80003422:	0001ba97          	auipc	s5,0x1b
    80003426:	a2ea8a93          	addi	s5,s5,-1490 # 8001de50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000342a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000342c:	0001b997          	auipc	s3,0x1b
    80003430:	9f498993          	addi	s3,s3,-1548 # 8001de20 <log>
    80003434:	a035                	j	80003460 <install_trans+0x60>
      bunpin(dbuf);
    80003436:	8526                	mv	a0,s1
    80003438:	fffff097          	auipc	ra,0xfffff
    8000343c:	166080e7          	jalr	358(ra) # 8000259e <bunpin>
    brelse(lbuf);
    80003440:	854a                	mv	a0,s2
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	082080e7          	jalr	130(ra) # 800024c4 <brelse>
    brelse(dbuf);
    8000344a:	8526                	mv	a0,s1
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	078080e7          	jalr	120(ra) # 800024c4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003454:	2a05                	addiw	s4,s4,1
    80003456:	0a91                	addi	s5,s5,4
    80003458:	02c9a783          	lw	a5,44(s3)
    8000345c:	04fa5963          	bge	s4,a5,800034ae <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003460:	0189a583          	lw	a1,24(s3)
    80003464:	014585bb          	addw	a1,a1,s4
    80003468:	2585                	addiw	a1,a1,1
    8000346a:	0289a503          	lw	a0,40(s3)
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	f26080e7          	jalr	-218(ra) # 80002394 <bread>
    80003476:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003478:	000aa583          	lw	a1,0(s5)
    8000347c:	0289a503          	lw	a0,40(s3)
    80003480:	fffff097          	auipc	ra,0xfffff
    80003484:	f14080e7          	jalr	-236(ra) # 80002394 <bread>
    80003488:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000348a:	40000613          	li	a2,1024
    8000348e:	05890593          	addi	a1,s2,88
    80003492:	05850513          	addi	a0,a0,88
    80003496:	ffffd097          	auipc	ra,0xffffd
    8000349a:	d42080e7          	jalr	-702(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000349e:	8526                	mv	a0,s1
    800034a0:	fffff097          	auipc	ra,0xfffff
    800034a4:	fe6080e7          	jalr	-26(ra) # 80002486 <bwrite>
    if(recovering == 0)
    800034a8:	f80b1ce3          	bnez	s6,80003440 <install_trans+0x40>
    800034ac:	b769                	j	80003436 <install_trans+0x36>
}
    800034ae:	70e2                	ld	ra,56(sp)
    800034b0:	7442                	ld	s0,48(sp)
    800034b2:	74a2                	ld	s1,40(sp)
    800034b4:	7902                	ld	s2,32(sp)
    800034b6:	69e2                	ld	s3,24(sp)
    800034b8:	6a42                	ld	s4,16(sp)
    800034ba:	6aa2                	ld	s5,8(sp)
    800034bc:	6b02                	ld	s6,0(sp)
    800034be:	6121                	addi	sp,sp,64
    800034c0:	8082                	ret
    800034c2:	8082                	ret

00000000800034c4 <initlog>:
{
    800034c4:	7179                	addi	sp,sp,-48
    800034c6:	f406                	sd	ra,40(sp)
    800034c8:	f022                	sd	s0,32(sp)
    800034ca:	ec26                	sd	s1,24(sp)
    800034cc:	e84a                	sd	s2,16(sp)
    800034ce:	e44e                	sd	s3,8(sp)
    800034d0:	1800                	addi	s0,sp,48
    800034d2:	892a                	mv	s2,a0
    800034d4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034d6:	0001b497          	auipc	s1,0x1b
    800034da:	94a48493          	addi	s1,s1,-1718 # 8001de20 <log>
    800034de:	00005597          	auipc	a1,0x5
    800034e2:	0d258593          	addi	a1,a1,210 # 800085b0 <syscalls+0x1e8>
    800034e6:	8526                	mv	a0,s1
    800034e8:	00003097          	auipc	ra,0x3
    800034ec:	c62080e7          	jalr	-926(ra) # 8000614a <initlock>
  log.start = sb->logstart;
    800034f0:	0149a583          	lw	a1,20(s3)
    800034f4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034f6:	0109a783          	lw	a5,16(s3)
    800034fa:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034fc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003500:	854a                	mv	a0,s2
    80003502:	fffff097          	auipc	ra,0xfffff
    80003506:	e92080e7          	jalr	-366(ra) # 80002394 <bread>
  log.lh.n = lh->n;
    8000350a:	4d3c                	lw	a5,88(a0)
    8000350c:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000350e:	02f05563          	blez	a5,80003538 <initlog+0x74>
    80003512:	05c50713          	addi	a4,a0,92
    80003516:	0001b697          	auipc	a3,0x1b
    8000351a:	93a68693          	addi	a3,a3,-1734 # 8001de50 <log+0x30>
    8000351e:	37fd                	addiw	a5,a5,-1
    80003520:	1782                	slli	a5,a5,0x20
    80003522:	9381                	srli	a5,a5,0x20
    80003524:	078a                	slli	a5,a5,0x2
    80003526:	06050613          	addi	a2,a0,96
    8000352a:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000352c:	4310                	lw	a2,0(a4)
    8000352e:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003530:	0711                	addi	a4,a4,4
    80003532:	0691                	addi	a3,a3,4
    80003534:	fef71ce3          	bne	a4,a5,8000352c <initlog+0x68>
  brelse(buf);
    80003538:	fffff097          	auipc	ra,0xfffff
    8000353c:	f8c080e7          	jalr	-116(ra) # 800024c4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003540:	4505                	li	a0,1
    80003542:	00000097          	auipc	ra,0x0
    80003546:	ebe080e7          	jalr	-322(ra) # 80003400 <install_trans>
  log.lh.n = 0;
    8000354a:	0001b797          	auipc	a5,0x1b
    8000354e:	9007a123          	sw	zero,-1790(a5) # 8001de4c <log+0x2c>
  write_head(); // clear the log
    80003552:	00000097          	auipc	ra,0x0
    80003556:	e34080e7          	jalr	-460(ra) # 80003386 <write_head>
}
    8000355a:	70a2                	ld	ra,40(sp)
    8000355c:	7402                	ld	s0,32(sp)
    8000355e:	64e2                	ld	s1,24(sp)
    80003560:	6942                	ld	s2,16(sp)
    80003562:	69a2                	ld	s3,8(sp)
    80003564:	6145                	addi	sp,sp,48
    80003566:	8082                	ret

0000000080003568 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003568:	1101                	addi	sp,sp,-32
    8000356a:	ec06                	sd	ra,24(sp)
    8000356c:	e822                	sd	s0,16(sp)
    8000356e:	e426                	sd	s1,8(sp)
    80003570:	e04a                	sd	s2,0(sp)
    80003572:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003574:	0001b517          	auipc	a0,0x1b
    80003578:	8ac50513          	addi	a0,a0,-1876 # 8001de20 <log>
    8000357c:	00003097          	auipc	ra,0x3
    80003580:	c5e080e7          	jalr	-930(ra) # 800061da <acquire>
  while(1){
    if(log.committing){
    80003584:	0001b497          	auipc	s1,0x1b
    80003588:	89c48493          	addi	s1,s1,-1892 # 8001de20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000358c:	4979                	li	s2,30
    8000358e:	a039                	j	8000359c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003590:	85a6                	mv	a1,s1
    80003592:	8526                	mv	a0,s1
    80003594:	ffffe097          	auipc	ra,0xffffe
    80003598:	f7e080e7          	jalr	-130(ra) # 80001512 <sleep>
    if(log.committing){
    8000359c:	50dc                	lw	a5,36(s1)
    8000359e:	fbed                	bnez	a5,80003590 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035a0:	509c                	lw	a5,32(s1)
    800035a2:	0017871b          	addiw	a4,a5,1
    800035a6:	0007069b          	sext.w	a3,a4
    800035aa:	0027179b          	slliw	a5,a4,0x2
    800035ae:	9fb9                	addw	a5,a5,a4
    800035b0:	0017979b          	slliw	a5,a5,0x1
    800035b4:	54d8                	lw	a4,44(s1)
    800035b6:	9fb9                	addw	a5,a5,a4
    800035b8:	00f95963          	bge	s2,a5,800035ca <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035bc:	85a6                	mv	a1,s1
    800035be:	8526                	mv	a0,s1
    800035c0:	ffffe097          	auipc	ra,0xffffe
    800035c4:	f52080e7          	jalr	-174(ra) # 80001512 <sleep>
    800035c8:	bfd1                	j	8000359c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035ca:	0001b517          	auipc	a0,0x1b
    800035ce:	85650513          	addi	a0,a0,-1962 # 8001de20 <log>
    800035d2:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035d4:	00003097          	auipc	ra,0x3
    800035d8:	cba080e7          	jalr	-838(ra) # 8000628e <release>
      break;
    }
  }
}
    800035dc:	60e2                	ld	ra,24(sp)
    800035de:	6442                	ld	s0,16(sp)
    800035e0:	64a2                	ld	s1,8(sp)
    800035e2:	6902                	ld	s2,0(sp)
    800035e4:	6105                	addi	sp,sp,32
    800035e6:	8082                	ret

00000000800035e8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035e8:	7139                	addi	sp,sp,-64
    800035ea:	fc06                	sd	ra,56(sp)
    800035ec:	f822                	sd	s0,48(sp)
    800035ee:	f426                	sd	s1,40(sp)
    800035f0:	f04a                	sd	s2,32(sp)
    800035f2:	ec4e                	sd	s3,24(sp)
    800035f4:	e852                	sd	s4,16(sp)
    800035f6:	e456                	sd	s5,8(sp)
    800035f8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035fa:	0001b497          	auipc	s1,0x1b
    800035fe:	82648493          	addi	s1,s1,-2010 # 8001de20 <log>
    80003602:	8526                	mv	a0,s1
    80003604:	00003097          	auipc	ra,0x3
    80003608:	bd6080e7          	jalr	-1066(ra) # 800061da <acquire>
  log.outstanding -= 1;
    8000360c:	509c                	lw	a5,32(s1)
    8000360e:	37fd                	addiw	a5,a5,-1
    80003610:	0007891b          	sext.w	s2,a5
    80003614:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003616:	50dc                	lw	a5,36(s1)
    80003618:	efb9                	bnez	a5,80003676 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000361a:	06091663          	bnez	s2,80003686 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000361e:	0001b497          	auipc	s1,0x1b
    80003622:	80248493          	addi	s1,s1,-2046 # 8001de20 <log>
    80003626:	4785                	li	a5,1
    80003628:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000362a:	8526                	mv	a0,s1
    8000362c:	00003097          	auipc	ra,0x3
    80003630:	c62080e7          	jalr	-926(ra) # 8000628e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003634:	54dc                	lw	a5,44(s1)
    80003636:	06f04763          	bgtz	a5,800036a4 <end_op+0xbc>
    acquire(&log.lock);
    8000363a:	0001a497          	auipc	s1,0x1a
    8000363e:	7e648493          	addi	s1,s1,2022 # 8001de20 <log>
    80003642:	8526                	mv	a0,s1
    80003644:	00003097          	auipc	ra,0x3
    80003648:	b96080e7          	jalr	-1130(ra) # 800061da <acquire>
    log.committing = 0;
    8000364c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003650:	8526                	mv	a0,s1
    80003652:	ffffe097          	auipc	ra,0xffffe
    80003656:	04c080e7          	jalr	76(ra) # 8000169e <wakeup>
    release(&log.lock);
    8000365a:	8526                	mv	a0,s1
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	c32080e7          	jalr	-974(ra) # 8000628e <release>
}
    80003664:	70e2                	ld	ra,56(sp)
    80003666:	7442                	ld	s0,48(sp)
    80003668:	74a2                	ld	s1,40(sp)
    8000366a:	7902                	ld	s2,32(sp)
    8000366c:	69e2                	ld	s3,24(sp)
    8000366e:	6a42                	ld	s4,16(sp)
    80003670:	6aa2                	ld	s5,8(sp)
    80003672:	6121                	addi	sp,sp,64
    80003674:	8082                	ret
    panic("log.committing");
    80003676:	00005517          	auipc	a0,0x5
    8000367a:	f4250513          	addi	a0,a0,-190 # 800085b8 <syscalls+0x1f0>
    8000367e:	00002097          	auipc	ra,0x2
    80003682:	63c080e7          	jalr	1596(ra) # 80005cba <panic>
    wakeup(&log);
    80003686:	0001a497          	auipc	s1,0x1a
    8000368a:	79a48493          	addi	s1,s1,1946 # 8001de20 <log>
    8000368e:	8526                	mv	a0,s1
    80003690:	ffffe097          	auipc	ra,0xffffe
    80003694:	00e080e7          	jalr	14(ra) # 8000169e <wakeup>
  release(&log.lock);
    80003698:	8526                	mv	a0,s1
    8000369a:	00003097          	auipc	ra,0x3
    8000369e:	bf4080e7          	jalr	-1036(ra) # 8000628e <release>
  if(do_commit){
    800036a2:	b7c9                	j	80003664 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a4:	0001aa97          	auipc	s5,0x1a
    800036a8:	7aca8a93          	addi	s5,s5,1964 # 8001de50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036ac:	0001aa17          	auipc	s4,0x1a
    800036b0:	774a0a13          	addi	s4,s4,1908 # 8001de20 <log>
    800036b4:	018a2583          	lw	a1,24(s4)
    800036b8:	012585bb          	addw	a1,a1,s2
    800036bc:	2585                	addiw	a1,a1,1
    800036be:	028a2503          	lw	a0,40(s4)
    800036c2:	fffff097          	auipc	ra,0xfffff
    800036c6:	cd2080e7          	jalr	-814(ra) # 80002394 <bread>
    800036ca:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036cc:	000aa583          	lw	a1,0(s5)
    800036d0:	028a2503          	lw	a0,40(s4)
    800036d4:	fffff097          	auipc	ra,0xfffff
    800036d8:	cc0080e7          	jalr	-832(ra) # 80002394 <bread>
    800036dc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036de:	40000613          	li	a2,1024
    800036e2:	05850593          	addi	a1,a0,88
    800036e6:	05848513          	addi	a0,s1,88
    800036ea:	ffffd097          	auipc	ra,0xffffd
    800036ee:	aee080e7          	jalr	-1298(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800036f2:	8526                	mv	a0,s1
    800036f4:	fffff097          	auipc	ra,0xfffff
    800036f8:	d92080e7          	jalr	-622(ra) # 80002486 <bwrite>
    brelse(from);
    800036fc:	854e                	mv	a0,s3
    800036fe:	fffff097          	auipc	ra,0xfffff
    80003702:	dc6080e7          	jalr	-570(ra) # 800024c4 <brelse>
    brelse(to);
    80003706:	8526                	mv	a0,s1
    80003708:	fffff097          	auipc	ra,0xfffff
    8000370c:	dbc080e7          	jalr	-580(ra) # 800024c4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003710:	2905                	addiw	s2,s2,1
    80003712:	0a91                	addi	s5,s5,4
    80003714:	02ca2783          	lw	a5,44(s4)
    80003718:	f8f94ee3          	blt	s2,a5,800036b4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000371c:	00000097          	auipc	ra,0x0
    80003720:	c6a080e7          	jalr	-918(ra) # 80003386 <write_head>
    install_trans(0); // Now install writes to home locations
    80003724:	4501                	li	a0,0
    80003726:	00000097          	auipc	ra,0x0
    8000372a:	cda080e7          	jalr	-806(ra) # 80003400 <install_trans>
    log.lh.n = 0;
    8000372e:	0001a797          	auipc	a5,0x1a
    80003732:	7007af23          	sw	zero,1822(a5) # 8001de4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003736:	00000097          	auipc	ra,0x0
    8000373a:	c50080e7          	jalr	-944(ra) # 80003386 <write_head>
    8000373e:	bdf5                	j	8000363a <end_op+0x52>

0000000080003740 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003740:	1101                	addi	sp,sp,-32
    80003742:	ec06                	sd	ra,24(sp)
    80003744:	e822                	sd	s0,16(sp)
    80003746:	e426                	sd	s1,8(sp)
    80003748:	e04a                	sd	s2,0(sp)
    8000374a:	1000                	addi	s0,sp,32
    8000374c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000374e:	0001a917          	auipc	s2,0x1a
    80003752:	6d290913          	addi	s2,s2,1746 # 8001de20 <log>
    80003756:	854a                	mv	a0,s2
    80003758:	00003097          	auipc	ra,0x3
    8000375c:	a82080e7          	jalr	-1406(ra) # 800061da <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003760:	02c92603          	lw	a2,44(s2)
    80003764:	47f5                	li	a5,29
    80003766:	06c7c563          	blt	a5,a2,800037d0 <log_write+0x90>
    8000376a:	0001a797          	auipc	a5,0x1a
    8000376e:	6d27a783          	lw	a5,1746(a5) # 8001de3c <log+0x1c>
    80003772:	37fd                	addiw	a5,a5,-1
    80003774:	04f65e63          	bge	a2,a5,800037d0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003778:	0001a797          	auipc	a5,0x1a
    8000377c:	6c87a783          	lw	a5,1736(a5) # 8001de40 <log+0x20>
    80003780:	06f05063          	blez	a5,800037e0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003784:	4781                	li	a5,0
    80003786:	06c05563          	blez	a2,800037f0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000378a:	44cc                	lw	a1,12(s1)
    8000378c:	0001a717          	auipc	a4,0x1a
    80003790:	6c470713          	addi	a4,a4,1732 # 8001de50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003794:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003796:	4314                	lw	a3,0(a4)
    80003798:	04b68c63          	beq	a3,a1,800037f0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000379c:	2785                	addiw	a5,a5,1
    8000379e:	0711                	addi	a4,a4,4
    800037a0:	fef61be3          	bne	a2,a5,80003796 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037a4:	0621                	addi	a2,a2,8
    800037a6:	060a                	slli	a2,a2,0x2
    800037a8:	0001a797          	auipc	a5,0x1a
    800037ac:	67878793          	addi	a5,a5,1656 # 8001de20 <log>
    800037b0:	963e                	add	a2,a2,a5
    800037b2:	44dc                	lw	a5,12(s1)
    800037b4:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037b6:	8526                	mv	a0,s1
    800037b8:	fffff097          	auipc	ra,0xfffff
    800037bc:	daa080e7          	jalr	-598(ra) # 80002562 <bpin>
    log.lh.n++;
    800037c0:	0001a717          	auipc	a4,0x1a
    800037c4:	66070713          	addi	a4,a4,1632 # 8001de20 <log>
    800037c8:	575c                	lw	a5,44(a4)
    800037ca:	2785                	addiw	a5,a5,1
    800037cc:	d75c                	sw	a5,44(a4)
    800037ce:	a835                	j	8000380a <log_write+0xca>
    panic("too big a transaction");
    800037d0:	00005517          	auipc	a0,0x5
    800037d4:	df850513          	addi	a0,a0,-520 # 800085c8 <syscalls+0x200>
    800037d8:	00002097          	auipc	ra,0x2
    800037dc:	4e2080e7          	jalr	1250(ra) # 80005cba <panic>
    panic("log_write outside of trans");
    800037e0:	00005517          	auipc	a0,0x5
    800037e4:	e0050513          	addi	a0,a0,-512 # 800085e0 <syscalls+0x218>
    800037e8:	00002097          	auipc	ra,0x2
    800037ec:	4d2080e7          	jalr	1234(ra) # 80005cba <panic>
  log.lh.block[i] = b->blockno;
    800037f0:	00878713          	addi	a4,a5,8
    800037f4:	00271693          	slli	a3,a4,0x2
    800037f8:	0001a717          	auipc	a4,0x1a
    800037fc:	62870713          	addi	a4,a4,1576 # 8001de20 <log>
    80003800:	9736                	add	a4,a4,a3
    80003802:	44d4                	lw	a3,12(s1)
    80003804:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003806:	faf608e3          	beq	a2,a5,800037b6 <log_write+0x76>
  }
  release(&log.lock);
    8000380a:	0001a517          	auipc	a0,0x1a
    8000380e:	61650513          	addi	a0,a0,1558 # 8001de20 <log>
    80003812:	00003097          	auipc	ra,0x3
    80003816:	a7c080e7          	jalr	-1412(ra) # 8000628e <release>
}
    8000381a:	60e2                	ld	ra,24(sp)
    8000381c:	6442                	ld	s0,16(sp)
    8000381e:	64a2                	ld	s1,8(sp)
    80003820:	6902                	ld	s2,0(sp)
    80003822:	6105                	addi	sp,sp,32
    80003824:	8082                	ret

0000000080003826 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003826:	1101                	addi	sp,sp,-32
    80003828:	ec06                	sd	ra,24(sp)
    8000382a:	e822                	sd	s0,16(sp)
    8000382c:	e426                	sd	s1,8(sp)
    8000382e:	e04a                	sd	s2,0(sp)
    80003830:	1000                	addi	s0,sp,32
    80003832:	84aa                	mv	s1,a0
    80003834:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003836:	00005597          	auipc	a1,0x5
    8000383a:	dca58593          	addi	a1,a1,-566 # 80008600 <syscalls+0x238>
    8000383e:	0521                	addi	a0,a0,8
    80003840:	00003097          	auipc	ra,0x3
    80003844:	90a080e7          	jalr	-1782(ra) # 8000614a <initlock>
  lk->name = name;
    80003848:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000384c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003850:	0204a423          	sw	zero,40(s1)
}
    80003854:	60e2                	ld	ra,24(sp)
    80003856:	6442                	ld	s0,16(sp)
    80003858:	64a2                	ld	s1,8(sp)
    8000385a:	6902                	ld	s2,0(sp)
    8000385c:	6105                	addi	sp,sp,32
    8000385e:	8082                	ret

0000000080003860 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003860:	1101                	addi	sp,sp,-32
    80003862:	ec06                	sd	ra,24(sp)
    80003864:	e822                	sd	s0,16(sp)
    80003866:	e426                	sd	s1,8(sp)
    80003868:	e04a                	sd	s2,0(sp)
    8000386a:	1000                	addi	s0,sp,32
    8000386c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000386e:	00850913          	addi	s2,a0,8
    80003872:	854a                	mv	a0,s2
    80003874:	00003097          	auipc	ra,0x3
    80003878:	966080e7          	jalr	-1690(ra) # 800061da <acquire>
  while (lk->locked) {
    8000387c:	409c                	lw	a5,0(s1)
    8000387e:	cb89                	beqz	a5,80003890 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003880:	85ca                	mv	a1,s2
    80003882:	8526                	mv	a0,s1
    80003884:	ffffe097          	auipc	ra,0xffffe
    80003888:	c8e080e7          	jalr	-882(ra) # 80001512 <sleep>
  while (lk->locked) {
    8000388c:	409c                	lw	a5,0(s1)
    8000388e:	fbed                	bnez	a5,80003880 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003890:	4785                	li	a5,1
    80003892:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003894:	ffffd097          	auipc	ra,0xffffd
    80003898:	5b4080e7          	jalr	1460(ra) # 80000e48 <myproc>
    8000389c:	591c                	lw	a5,48(a0)
    8000389e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038a0:	854a                	mv	a0,s2
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	9ec080e7          	jalr	-1556(ra) # 8000628e <release>
}
    800038aa:	60e2                	ld	ra,24(sp)
    800038ac:	6442                	ld	s0,16(sp)
    800038ae:	64a2                	ld	s1,8(sp)
    800038b0:	6902                	ld	s2,0(sp)
    800038b2:	6105                	addi	sp,sp,32
    800038b4:	8082                	ret

00000000800038b6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038b6:	1101                	addi	sp,sp,-32
    800038b8:	ec06                	sd	ra,24(sp)
    800038ba:	e822                	sd	s0,16(sp)
    800038bc:	e426                	sd	s1,8(sp)
    800038be:	e04a                	sd	s2,0(sp)
    800038c0:	1000                	addi	s0,sp,32
    800038c2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c4:	00850913          	addi	s2,a0,8
    800038c8:	854a                	mv	a0,s2
    800038ca:	00003097          	auipc	ra,0x3
    800038ce:	910080e7          	jalr	-1776(ra) # 800061da <acquire>
  lk->locked = 0;
    800038d2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038da:	8526                	mv	a0,s1
    800038dc:	ffffe097          	auipc	ra,0xffffe
    800038e0:	dc2080e7          	jalr	-574(ra) # 8000169e <wakeup>
  release(&lk->lk);
    800038e4:	854a                	mv	a0,s2
    800038e6:	00003097          	auipc	ra,0x3
    800038ea:	9a8080e7          	jalr	-1624(ra) # 8000628e <release>
}
    800038ee:	60e2                	ld	ra,24(sp)
    800038f0:	6442                	ld	s0,16(sp)
    800038f2:	64a2                	ld	s1,8(sp)
    800038f4:	6902                	ld	s2,0(sp)
    800038f6:	6105                	addi	sp,sp,32
    800038f8:	8082                	ret

00000000800038fa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038fa:	7179                	addi	sp,sp,-48
    800038fc:	f406                	sd	ra,40(sp)
    800038fe:	f022                	sd	s0,32(sp)
    80003900:	ec26                	sd	s1,24(sp)
    80003902:	e84a                	sd	s2,16(sp)
    80003904:	e44e                	sd	s3,8(sp)
    80003906:	1800                	addi	s0,sp,48
    80003908:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000390a:	00850913          	addi	s2,a0,8
    8000390e:	854a                	mv	a0,s2
    80003910:	00003097          	auipc	ra,0x3
    80003914:	8ca080e7          	jalr	-1846(ra) # 800061da <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003918:	409c                	lw	a5,0(s1)
    8000391a:	ef99                	bnez	a5,80003938 <holdingsleep+0x3e>
    8000391c:	4481                	li	s1,0
  release(&lk->lk);
    8000391e:	854a                	mv	a0,s2
    80003920:	00003097          	auipc	ra,0x3
    80003924:	96e080e7          	jalr	-1682(ra) # 8000628e <release>
  return r;
}
    80003928:	8526                	mv	a0,s1
    8000392a:	70a2                	ld	ra,40(sp)
    8000392c:	7402                	ld	s0,32(sp)
    8000392e:	64e2                	ld	s1,24(sp)
    80003930:	6942                	ld	s2,16(sp)
    80003932:	69a2                	ld	s3,8(sp)
    80003934:	6145                	addi	sp,sp,48
    80003936:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003938:	0284a983          	lw	s3,40(s1)
    8000393c:	ffffd097          	auipc	ra,0xffffd
    80003940:	50c080e7          	jalr	1292(ra) # 80000e48 <myproc>
    80003944:	5904                	lw	s1,48(a0)
    80003946:	413484b3          	sub	s1,s1,s3
    8000394a:	0014b493          	seqz	s1,s1
    8000394e:	bfc1                	j	8000391e <holdingsleep+0x24>

0000000080003950 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003950:	1141                	addi	sp,sp,-16
    80003952:	e406                	sd	ra,8(sp)
    80003954:	e022                	sd	s0,0(sp)
    80003956:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003958:	00005597          	auipc	a1,0x5
    8000395c:	cb858593          	addi	a1,a1,-840 # 80008610 <syscalls+0x248>
    80003960:	0001a517          	auipc	a0,0x1a
    80003964:	60850513          	addi	a0,a0,1544 # 8001df68 <ftable>
    80003968:	00002097          	auipc	ra,0x2
    8000396c:	7e2080e7          	jalr	2018(ra) # 8000614a <initlock>
}
    80003970:	60a2                	ld	ra,8(sp)
    80003972:	6402                	ld	s0,0(sp)
    80003974:	0141                	addi	sp,sp,16
    80003976:	8082                	ret

0000000080003978 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003978:	1101                	addi	sp,sp,-32
    8000397a:	ec06                	sd	ra,24(sp)
    8000397c:	e822                	sd	s0,16(sp)
    8000397e:	e426                	sd	s1,8(sp)
    80003980:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003982:	0001a517          	auipc	a0,0x1a
    80003986:	5e650513          	addi	a0,a0,1510 # 8001df68 <ftable>
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	850080e7          	jalr	-1968(ra) # 800061da <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003992:	0001a497          	auipc	s1,0x1a
    80003996:	5ee48493          	addi	s1,s1,1518 # 8001df80 <ftable+0x18>
    8000399a:	0001b717          	auipc	a4,0x1b
    8000399e:	58670713          	addi	a4,a4,1414 # 8001ef20 <ftable+0xfb8>
    if(f->ref == 0){
    800039a2:	40dc                	lw	a5,4(s1)
    800039a4:	cf99                	beqz	a5,800039c2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039a6:	02848493          	addi	s1,s1,40
    800039aa:	fee49ce3          	bne	s1,a4,800039a2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039ae:	0001a517          	auipc	a0,0x1a
    800039b2:	5ba50513          	addi	a0,a0,1466 # 8001df68 <ftable>
    800039b6:	00003097          	auipc	ra,0x3
    800039ba:	8d8080e7          	jalr	-1832(ra) # 8000628e <release>
  return 0;
    800039be:	4481                	li	s1,0
    800039c0:	a819                	j	800039d6 <filealloc+0x5e>
      f->ref = 1;
    800039c2:	4785                	li	a5,1
    800039c4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039c6:	0001a517          	auipc	a0,0x1a
    800039ca:	5a250513          	addi	a0,a0,1442 # 8001df68 <ftable>
    800039ce:	00003097          	auipc	ra,0x3
    800039d2:	8c0080e7          	jalr	-1856(ra) # 8000628e <release>
}
    800039d6:	8526                	mv	a0,s1
    800039d8:	60e2                	ld	ra,24(sp)
    800039da:	6442                	ld	s0,16(sp)
    800039dc:	64a2                	ld	s1,8(sp)
    800039de:	6105                	addi	sp,sp,32
    800039e0:	8082                	ret

00000000800039e2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039e2:	1101                	addi	sp,sp,-32
    800039e4:	ec06                	sd	ra,24(sp)
    800039e6:	e822                	sd	s0,16(sp)
    800039e8:	e426                	sd	s1,8(sp)
    800039ea:	1000                	addi	s0,sp,32
    800039ec:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039ee:	0001a517          	auipc	a0,0x1a
    800039f2:	57a50513          	addi	a0,a0,1402 # 8001df68 <ftable>
    800039f6:	00002097          	auipc	ra,0x2
    800039fa:	7e4080e7          	jalr	2020(ra) # 800061da <acquire>
  if(f->ref < 1)
    800039fe:	40dc                	lw	a5,4(s1)
    80003a00:	02f05263          	blez	a5,80003a24 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a04:	2785                	addiw	a5,a5,1
    80003a06:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a08:	0001a517          	auipc	a0,0x1a
    80003a0c:	56050513          	addi	a0,a0,1376 # 8001df68 <ftable>
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	87e080e7          	jalr	-1922(ra) # 8000628e <release>
  return f;
}
    80003a18:	8526                	mv	a0,s1
    80003a1a:	60e2                	ld	ra,24(sp)
    80003a1c:	6442                	ld	s0,16(sp)
    80003a1e:	64a2                	ld	s1,8(sp)
    80003a20:	6105                	addi	sp,sp,32
    80003a22:	8082                	ret
    panic("filedup");
    80003a24:	00005517          	auipc	a0,0x5
    80003a28:	bf450513          	addi	a0,a0,-1036 # 80008618 <syscalls+0x250>
    80003a2c:	00002097          	auipc	ra,0x2
    80003a30:	28e080e7          	jalr	654(ra) # 80005cba <panic>

0000000080003a34 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a34:	7139                	addi	sp,sp,-64
    80003a36:	fc06                	sd	ra,56(sp)
    80003a38:	f822                	sd	s0,48(sp)
    80003a3a:	f426                	sd	s1,40(sp)
    80003a3c:	f04a                	sd	s2,32(sp)
    80003a3e:	ec4e                	sd	s3,24(sp)
    80003a40:	e852                	sd	s4,16(sp)
    80003a42:	e456                	sd	s5,8(sp)
    80003a44:	0080                	addi	s0,sp,64
    80003a46:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a48:	0001a517          	auipc	a0,0x1a
    80003a4c:	52050513          	addi	a0,a0,1312 # 8001df68 <ftable>
    80003a50:	00002097          	auipc	ra,0x2
    80003a54:	78a080e7          	jalr	1930(ra) # 800061da <acquire>
  if(f->ref < 1)
    80003a58:	40dc                	lw	a5,4(s1)
    80003a5a:	06f05163          	blez	a5,80003abc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a5e:	37fd                	addiw	a5,a5,-1
    80003a60:	0007871b          	sext.w	a4,a5
    80003a64:	c0dc                	sw	a5,4(s1)
    80003a66:	06e04363          	bgtz	a4,80003acc <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a6a:	0004a903          	lw	s2,0(s1)
    80003a6e:	0094ca83          	lbu	s5,9(s1)
    80003a72:	0104ba03          	ld	s4,16(s1)
    80003a76:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a7a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a7e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a82:	0001a517          	auipc	a0,0x1a
    80003a86:	4e650513          	addi	a0,a0,1254 # 8001df68 <ftable>
    80003a8a:	00003097          	auipc	ra,0x3
    80003a8e:	804080e7          	jalr	-2044(ra) # 8000628e <release>

  if(ff.type == FD_PIPE){
    80003a92:	4785                	li	a5,1
    80003a94:	04f90d63          	beq	s2,a5,80003aee <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a98:	3979                	addiw	s2,s2,-2
    80003a9a:	4785                	li	a5,1
    80003a9c:	0527e063          	bltu	a5,s2,80003adc <fileclose+0xa8>
    begin_op();
    80003aa0:	00000097          	auipc	ra,0x0
    80003aa4:	ac8080e7          	jalr	-1336(ra) # 80003568 <begin_op>
    iput(ff.ip);
    80003aa8:	854e                	mv	a0,s3
    80003aaa:	fffff097          	auipc	ra,0xfffff
    80003aae:	2a6080e7          	jalr	678(ra) # 80002d50 <iput>
    end_op();
    80003ab2:	00000097          	auipc	ra,0x0
    80003ab6:	b36080e7          	jalr	-1226(ra) # 800035e8 <end_op>
    80003aba:	a00d                	j	80003adc <fileclose+0xa8>
    panic("fileclose");
    80003abc:	00005517          	auipc	a0,0x5
    80003ac0:	b6450513          	addi	a0,a0,-1180 # 80008620 <syscalls+0x258>
    80003ac4:	00002097          	auipc	ra,0x2
    80003ac8:	1f6080e7          	jalr	502(ra) # 80005cba <panic>
    release(&ftable.lock);
    80003acc:	0001a517          	auipc	a0,0x1a
    80003ad0:	49c50513          	addi	a0,a0,1180 # 8001df68 <ftable>
    80003ad4:	00002097          	auipc	ra,0x2
    80003ad8:	7ba080e7          	jalr	1978(ra) # 8000628e <release>
  }
}
    80003adc:	70e2                	ld	ra,56(sp)
    80003ade:	7442                	ld	s0,48(sp)
    80003ae0:	74a2                	ld	s1,40(sp)
    80003ae2:	7902                	ld	s2,32(sp)
    80003ae4:	69e2                	ld	s3,24(sp)
    80003ae6:	6a42                	ld	s4,16(sp)
    80003ae8:	6aa2                	ld	s5,8(sp)
    80003aea:	6121                	addi	sp,sp,64
    80003aec:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003aee:	85d6                	mv	a1,s5
    80003af0:	8552                	mv	a0,s4
    80003af2:	00000097          	auipc	ra,0x0
    80003af6:	34c080e7          	jalr	844(ra) # 80003e3e <pipeclose>
    80003afa:	b7cd                	j	80003adc <fileclose+0xa8>

0000000080003afc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003afc:	715d                	addi	sp,sp,-80
    80003afe:	e486                	sd	ra,72(sp)
    80003b00:	e0a2                	sd	s0,64(sp)
    80003b02:	fc26                	sd	s1,56(sp)
    80003b04:	f84a                	sd	s2,48(sp)
    80003b06:	f44e                	sd	s3,40(sp)
    80003b08:	0880                	addi	s0,sp,80
    80003b0a:	84aa                	mv	s1,a0
    80003b0c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b0e:	ffffd097          	auipc	ra,0xffffd
    80003b12:	33a080e7          	jalr	826(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b16:	409c                	lw	a5,0(s1)
    80003b18:	37f9                	addiw	a5,a5,-2
    80003b1a:	4705                	li	a4,1
    80003b1c:	04f76763          	bltu	a4,a5,80003b6a <filestat+0x6e>
    80003b20:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b22:	6c88                	ld	a0,24(s1)
    80003b24:	fffff097          	auipc	ra,0xfffff
    80003b28:	072080e7          	jalr	114(ra) # 80002b96 <ilock>
    stati(f->ip, &st);
    80003b2c:	fb840593          	addi	a1,s0,-72
    80003b30:	6c88                	ld	a0,24(s1)
    80003b32:	fffff097          	auipc	ra,0xfffff
    80003b36:	2ee080e7          	jalr	750(ra) # 80002e20 <stati>
    iunlock(f->ip);
    80003b3a:	6c88                	ld	a0,24(s1)
    80003b3c:	fffff097          	auipc	ra,0xfffff
    80003b40:	11c080e7          	jalr	284(ra) # 80002c58 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b44:	46e1                	li	a3,24
    80003b46:	fb840613          	addi	a2,s0,-72
    80003b4a:	85ce                	mv	a1,s3
    80003b4c:	05093503          	ld	a0,80(s2)
    80003b50:	ffffd097          	auipc	ra,0xffffd
    80003b54:	fba080e7          	jalr	-70(ra) # 80000b0a <copyout>
    80003b58:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b5c:	60a6                	ld	ra,72(sp)
    80003b5e:	6406                	ld	s0,64(sp)
    80003b60:	74e2                	ld	s1,56(sp)
    80003b62:	7942                	ld	s2,48(sp)
    80003b64:	79a2                	ld	s3,40(sp)
    80003b66:	6161                	addi	sp,sp,80
    80003b68:	8082                	ret
  return -1;
    80003b6a:	557d                	li	a0,-1
    80003b6c:	bfc5                	j	80003b5c <filestat+0x60>

0000000080003b6e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b6e:	7179                	addi	sp,sp,-48
    80003b70:	f406                	sd	ra,40(sp)
    80003b72:	f022                	sd	s0,32(sp)
    80003b74:	ec26                	sd	s1,24(sp)
    80003b76:	e84a                	sd	s2,16(sp)
    80003b78:	e44e                	sd	s3,8(sp)
    80003b7a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b7c:	00854783          	lbu	a5,8(a0)
    80003b80:	c3d5                	beqz	a5,80003c24 <fileread+0xb6>
    80003b82:	84aa                	mv	s1,a0
    80003b84:	89ae                	mv	s3,a1
    80003b86:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b88:	411c                	lw	a5,0(a0)
    80003b8a:	4705                	li	a4,1
    80003b8c:	04e78963          	beq	a5,a4,80003bde <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b90:	470d                	li	a4,3
    80003b92:	04e78d63          	beq	a5,a4,80003bec <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b96:	4709                	li	a4,2
    80003b98:	06e79e63          	bne	a5,a4,80003c14 <fileread+0xa6>
    ilock(f->ip);
    80003b9c:	6d08                	ld	a0,24(a0)
    80003b9e:	fffff097          	auipc	ra,0xfffff
    80003ba2:	ff8080e7          	jalr	-8(ra) # 80002b96 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ba6:	874a                	mv	a4,s2
    80003ba8:	5094                	lw	a3,32(s1)
    80003baa:	864e                	mv	a2,s3
    80003bac:	4585                	li	a1,1
    80003bae:	6c88                	ld	a0,24(s1)
    80003bb0:	fffff097          	auipc	ra,0xfffff
    80003bb4:	29a080e7          	jalr	666(ra) # 80002e4a <readi>
    80003bb8:	892a                	mv	s2,a0
    80003bba:	00a05563          	blez	a0,80003bc4 <fileread+0x56>
      f->off += r;
    80003bbe:	509c                	lw	a5,32(s1)
    80003bc0:	9fa9                	addw	a5,a5,a0
    80003bc2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bc4:	6c88                	ld	a0,24(s1)
    80003bc6:	fffff097          	auipc	ra,0xfffff
    80003bca:	092080e7          	jalr	146(ra) # 80002c58 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bce:	854a                	mv	a0,s2
    80003bd0:	70a2                	ld	ra,40(sp)
    80003bd2:	7402                	ld	s0,32(sp)
    80003bd4:	64e2                	ld	s1,24(sp)
    80003bd6:	6942                	ld	s2,16(sp)
    80003bd8:	69a2                	ld	s3,8(sp)
    80003bda:	6145                	addi	sp,sp,48
    80003bdc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bde:	6908                	ld	a0,16(a0)
    80003be0:	00000097          	auipc	ra,0x0
    80003be4:	3c8080e7          	jalr	968(ra) # 80003fa8 <piperead>
    80003be8:	892a                	mv	s2,a0
    80003bea:	b7d5                	j	80003bce <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bec:	02451783          	lh	a5,36(a0)
    80003bf0:	03079693          	slli	a3,a5,0x30
    80003bf4:	92c1                	srli	a3,a3,0x30
    80003bf6:	4725                	li	a4,9
    80003bf8:	02d76863          	bltu	a4,a3,80003c28 <fileread+0xba>
    80003bfc:	0792                	slli	a5,a5,0x4
    80003bfe:	0001a717          	auipc	a4,0x1a
    80003c02:	2ca70713          	addi	a4,a4,714 # 8001dec8 <devsw>
    80003c06:	97ba                	add	a5,a5,a4
    80003c08:	639c                	ld	a5,0(a5)
    80003c0a:	c38d                	beqz	a5,80003c2c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c0c:	4505                	li	a0,1
    80003c0e:	9782                	jalr	a5
    80003c10:	892a                	mv	s2,a0
    80003c12:	bf75                	j	80003bce <fileread+0x60>
    panic("fileread");
    80003c14:	00005517          	auipc	a0,0x5
    80003c18:	a1c50513          	addi	a0,a0,-1508 # 80008630 <syscalls+0x268>
    80003c1c:	00002097          	auipc	ra,0x2
    80003c20:	09e080e7          	jalr	158(ra) # 80005cba <panic>
    return -1;
    80003c24:	597d                	li	s2,-1
    80003c26:	b765                	j	80003bce <fileread+0x60>
      return -1;
    80003c28:	597d                	li	s2,-1
    80003c2a:	b755                	j	80003bce <fileread+0x60>
    80003c2c:	597d                	li	s2,-1
    80003c2e:	b745                	j	80003bce <fileread+0x60>

0000000080003c30 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c30:	715d                	addi	sp,sp,-80
    80003c32:	e486                	sd	ra,72(sp)
    80003c34:	e0a2                	sd	s0,64(sp)
    80003c36:	fc26                	sd	s1,56(sp)
    80003c38:	f84a                	sd	s2,48(sp)
    80003c3a:	f44e                	sd	s3,40(sp)
    80003c3c:	f052                	sd	s4,32(sp)
    80003c3e:	ec56                	sd	s5,24(sp)
    80003c40:	e85a                	sd	s6,16(sp)
    80003c42:	e45e                	sd	s7,8(sp)
    80003c44:	e062                	sd	s8,0(sp)
    80003c46:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c48:	00954783          	lbu	a5,9(a0)
    80003c4c:	10078663          	beqz	a5,80003d58 <filewrite+0x128>
    80003c50:	892a                	mv	s2,a0
    80003c52:	8aae                	mv	s5,a1
    80003c54:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c56:	411c                	lw	a5,0(a0)
    80003c58:	4705                	li	a4,1
    80003c5a:	02e78263          	beq	a5,a4,80003c7e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c5e:	470d                	li	a4,3
    80003c60:	02e78663          	beq	a5,a4,80003c8c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c64:	4709                	li	a4,2
    80003c66:	0ee79163          	bne	a5,a4,80003d48 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c6a:	0ac05d63          	blez	a2,80003d24 <filewrite+0xf4>
    int i = 0;
    80003c6e:	4981                	li	s3,0
    80003c70:	6b05                	lui	s6,0x1
    80003c72:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c76:	6b85                	lui	s7,0x1
    80003c78:	c00b8b9b          	addiw	s7,s7,-1024
    80003c7c:	a861                	j	80003d14 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c7e:	6908                	ld	a0,16(a0)
    80003c80:	00000097          	auipc	ra,0x0
    80003c84:	22e080e7          	jalr	558(ra) # 80003eae <pipewrite>
    80003c88:	8a2a                	mv	s4,a0
    80003c8a:	a045                	j	80003d2a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c8c:	02451783          	lh	a5,36(a0)
    80003c90:	03079693          	slli	a3,a5,0x30
    80003c94:	92c1                	srli	a3,a3,0x30
    80003c96:	4725                	li	a4,9
    80003c98:	0cd76263          	bltu	a4,a3,80003d5c <filewrite+0x12c>
    80003c9c:	0792                	slli	a5,a5,0x4
    80003c9e:	0001a717          	auipc	a4,0x1a
    80003ca2:	22a70713          	addi	a4,a4,554 # 8001dec8 <devsw>
    80003ca6:	97ba                	add	a5,a5,a4
    80003ca8:	679c                	ld	a5,8(a5)
    80003caa:	cbdd                	beqz	a5,80003d60 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cac:	4505                	li	a0,1
    80003cae:	9782                	jalr	a5
    80003cb0:	8a2a                	mv	s4,a0
    80003cb2:	a8a5                	j	80003d2a <filewrite+0xfa>
    80003cb4:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cb8:	00000097          	auipc	ra,0x0
    80003cbc:	8b0080e7          	jalr	-1872(ra) # 80003568 <begin_op>
      ilock(f->ip);
    80003cc0:	01893503          	ld	a0,24(s2)
    80003cc4:	fffff097          	auipc	ra,0xfffff
    80003cc8:	ed2080e7          	jalr	-302(ra) # 80002b96 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ccc:	8762                	mv	a4,s8
    80003cce:	02092683          	lw	a3,32(s2)
    80003cd2:	01598633          	add	a2,s3,s5
    80003cd6:	4585                	li	a1,1
    80003cd8:	01893503          	ld	a0,24(s2)
    80003cdc:	fffff097          	auipc	ra,0xfffff
    80003ce0:	266080e7          	jalr	614(ra) # 80002f42 <writei>
    80003ce4:	84aa                	mv	s1,a0
    80003ce6:	00a05763          	blez	a0,80003cf4 <filewrite+0xc4>
        f->off += r;
    80003cea:	02092783          	lw	a5,32(s2)
    80003cee:	9fa9                	addw	a5,a5,a0
    80003cf0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cf4:	01893503          	ld	a0,24(s2)
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	f60080e7          	jalr	-160(ra) # 80002c58 <iunlock>
      end_op();
    80003d00:	00000097          	auipc	ra,0x0
    80003d04:	8e8080e7          	jalr	-1816(ra) # 800035e8 <end_op>

      if(r != n1){
    80003d08:	009c1f63          	bne	s8,s1,80003d26 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d0c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d10:	0149db63          	bge	s3,s4,80003d26 <filewrite+0xf6>
      int n1 = n - i;
    80003d14:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d18:	84be                	mv	s1,a5
    80003d1a:	2781                	sext.w	a5,a5
    80003d1c:	f8fb5ce3          	bge	s6,a5,80003cb4 <filewrite+0x84>
    80003d20:	84de                	mv	s1,s7
    80003d22:	bf49                	j	80003cb4 <filewrite+0x84>
    int i = 0;
    80003d24:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d26:	013a1f63          	bne	s4,s3,80003d44 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d2a:	8552                	mv	a0,s4
    80003d2c:	60a6                	ld	ra,72(sp)
    80003d2e:	6406                	ld	s0,64(sp)
    80003d30:	74e2                	ld	s1,56(sp)
    80003d32:	7942                	ld	s2,48(sp)
    80003d34:	79a2                	ld	s3,40(sp)
    80003d36:	7a02                	ld	s4,32(sp)
    80003d38:	6ae2                	ld	s5,24(sp)
    80003d3a:	6b42                	ld	s6,16(sp)
    80003d3c:	6ba2                	ld	s7,8(sp)
    80003d3e:	6c02                	ld	s8,0(sp)
    80003d40:	6161                	addi	sp,sp,80
    80003d42:	8082                	ret
    ret = (i == n ? n : -1);
    80003d44:	5a7d                	li	s4,-1
    80003d46:	b7d5                	j	80003d2a <filewrite+0xfa>
    panic("filewrite");
    80003d48:	00005517          	auipc	a0,0x5
    80003d4c:	8f850513          	addi	a0,a0,-1800 # 80008640 <syscalls+0x278>
    80003d50:	00002097          	auipc	ra,0x2
    80003d54:	f6a080e7          	jalr	-150(ra) # 80005cba <panic>
    return -1;
    80003d58:	5a7d                	li	s4,-1
    80003d5a:	bfc1                	j	80003d2a <filewrite+0xfa>
      return -1;
    80003d5c:	5a7d                	li	s4,-1
    80003d5e:	b7f1                	j	80003d2a <filewrite+0xfa>
    80003d60:	5a7d                	li	s4,-1
    80003d62:	b7e1                	j	80003d2a <filewrite+0xfa>

0000000080003d64 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d64:	7179                	addi	sp,sp,-48
    80003d66:	f406                	sd	ra,40(sp)
    80003d68:	f022                	sd	s0,32(sp)
    80003d6a:	ec26                	sd	s1,24(sp)
    80003d6c:	e84a                	sd	s2,16(sp)
    80003d6e:	e44e                	sd	s3,8(sp)
    80003d70:	e052                	sd	s4,0(sp)
    80003d72:	1800                	addi	s0,sp,48
    80003d74:	84aa                	mv	s1,a0
    80003d76:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d78:	0005b023          	sd	zero,0(a1)
    80003d7c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d80:	00000097          	auipc	ra,0x0
    80003d84:	bf8080e7          	jalr	-1032(ra) # 80003978 <filealloc>
    80003d88:	e088                	sd	a0,0(s1)
    80003d8a:	c551                	beqz	a0,80003e16 <pipealloc+0xb2>
    80003d8c:	00000097          	auipc	ra,0x0
    80003d90:	bec080e7          	jalr	-1044(ra) # 80003978 <filealloc>
    80003d94:	00aa3023          	sd	a0,0(s4)
    80003d98:	c92d                	beqz	a0,80003e0a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d9a:	ffffc097          	auipc	ra,0xffffc
    80003d9e:	37e080e7          	jalr	894(ra) # 80000118 <kalloc>
    80003da2:	892a                	mv	s2,a0
    80003da4:	c125                	beqz	a0,80003e04 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003da6:	4985                	li	s3,1
    80003da8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dac:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003db0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003db4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003db8:	00005597          	auipc	a1,0x5
    80003dbc:	89858593          	addi	a1,a1,-1896 # 80008650 <syscalls+0x288>
    80003dc0:	00002097          	auipc	ra,0x2
    80003dc4:	38a080e7          	jalr	906(ra) # 8000614a <initlock>
  (*f0)->type = FD_PIPE;
    80003dc8:	609c                	ld	a5,0(s1)
    80003dca:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dce:	609c                	ld	a5,0(s1)
    80003dd0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dd4:	609c                	ld	a5,0(s1)
    80003dd6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dda:	609c                	ld	a5,0(s1)
    80003ddc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003de0:	000a3783          	ld	a5,0(s4)
    80003de4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003de8:	000a3783          	ld	a5,0(s4)
    80003dec:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003df0:	000a3783          	ld	a5,0(s4)
    80003df4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003df8:	000a3783          	ld	a5,0(s4)
    80003dfc:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e00:	4501                	li	a0,0
    80003e02:	a025                	j	80003e2a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e04:	6088                	ld	a0,0(s1)
    80003e06:	e501                	bnez	a0,80003e0e <pipealloc+0xaa>
    80003e08:	a039                	j	80003e16 <pipealloc+0xb2>
    80003e0a:	6088                	ld	a0,0(s1)
    80003e0c:	c51d                	beqz	a0,80003e3a <pipealloc+0xd6>
    fileclose(*f0);
    80003e0e:	00000097          	auipc	ra,0x0
    80003e12:	c26080e7          	jalr	-986(ra) # 80003a34 <fileclose>
  if(*f1)
    80003e16:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e1a:	557d                	li	a0,-1
  if(*f1)
    80003e1c:	c799                	beqz	a5,80003e2a <pipealloc+0xc6>
    fileclose(*f1);
    80003e1e:	853e                	mv	a0,a5
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	c14080e7          	jalr	-1004(ra) # 80003a34 <fileclose>
  return -1;
    80003e28:	557d                	li	a0,-1
}
    80003e2a:	70a2                	ld	ra,40(sp)
    80003e2c:	7402                	ld	s0,32(sp)
    80003e2e:	64e2                	ld	s1,24(sp)
    80003e30:	6942                	ld	s2,16(sp)
    80003e32:	69a2                	ld	s3,8(sp)
    80003e34:	6a02                	ld	s4,0(sp)
    80003e36:	6145                	addi	sp,sp,48
    80003e38:	8082                	ret
  return -1;
    80003e3a:	557d                	li	a0,-1
    80003e3c:	b7fd                	j	80003e2a <pipealloc+0xc6>

0000000080003e3e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e3e:	1101                	addi	sp,sp,-32
    80003e40:	ec06                	sd	ra,24(sp)
    80003e42:	e822                	sd	s0,16(sp)
    80003e44:	e426                	sd	s1,8(sp)
    80003e46:	e04a                	sd	s2,0(sp)
    80003e48:	1000                	addi	s0,sp,32
    80003e4a:	84aa                	mv	s1,a0
    80003e4c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e4e:	00002097          	auipc	ra,0x2
    80003e52:	38c080e7          	jalr	908(ra) # 800061da <acquire>
  if(writable){
    80003e56:	02090d63          	beqz	s2,80003e90 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e5a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e5e:	21848513          	addi	a0,s1,536
    80003e62:	ffffe097          	auipc	ra,0xffffe
    80003e66:	83c080e7          	jalr	-1988(ra) # 8000169e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e6a:	2204b783          	ld	a5,544(s1)
    80003e6e:	eb95                	bnez	a5,80003ea2 <pipeclose+0x64>
    release(&pi->lock);
    80003e70:	8526                	mv	a0,s1
    80003e72:	00002097          	auipc	ra,0x2
    80003e76:	41c080e7          	jalr	1052(ra) # 8000628e <release>
    kfree((char*)pi);
    80003e7a:	8526                	mv	a0,s1
    80003e7c:	ffffc097          	auipc	ra,0xffffc
    80003e80:	1a0080e7          	jalr	416(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e84:	60e2                	ld	ra,24(sp)
    80003e86:	6442                	ld	s0,16(sp)
    80003e88:	64a2                	ld	s1,8(sp)
    80003e8a:	6902                	ld	s2,0(sp)
    80003e8c:	6105                	addi	sp,sp,32
    80003e8e:	8082                	ret
    pi->readopen = 0;
    80003e90:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e94:	21c48513          	addi	a0,s1,540
    80003e98:	ffffe097          	auipc	ra,0xffffe
    80003e9c:	806080e7          	jalr	-2042(ra) # 8000169e <wakeup>
    80003ea0:	b7e9                	j	80003e6a <pipeclose+0x2c>
    release(&pi->lock);
    80003ea2:	8526                	mv	a0,s1
    80003ea4:	00002097          	auipc	ra,0x2
    80003ea8:	3ea080e7          	jalr	1002(ra) # 8000628e <release>
}
    80003eac:	bfe1                	j	80003e84 <pipeclose+0x46>

0000000080003eae <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eae:	7159                	addi	sp,sp,-112
    80003eb0:	f486                	sd	ra,104(sp)
    80003eb2:	f0a2                	sd	s0,96(sp)
    80003eb4:	eca6                	sd	s1,88(sp)
    80003eb6:	e8ca                	sd	s2,80(sp)
    80003eb8:	e4ce                	sd	s3,72(sp)
    80003eba:	e0d2                	sd	s4,64(sp)
    80003ebc:	fc56                	sd	s5,56(sp)
    80003ebe:	f85a                	sd	s6,48(sp)
    80003ec0:	f45e                	sd	s7,40(sp)
    80003ec2:	f062                	sd	s8,32(sp)
    80003ec4:	ec66                	sd	s9,24(sp)
    80003ec6:	1880                	addi	s0,sp,112
    80003ec8:	84aa                	mv	s1,a0
    80003eca:	8aae                	mv	s5,a1
    80003ecc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ece:	ffffd097          	auipc	ra,0xffffd
    80003ed2:	f7a080e7          	jalr	-134(ra) # 80000e48 <myproc>
    80003ed6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ed8:	8526                	mv	a0,s1
    80003eda:	00002097          	auipc	ra,0x2
    80003ede:	300080e7          	jalr	768(ra) # 800061da <acquire>
  while(i < n){
    80003ee2:	0d405163          	blez	s4,80003fa4 <pipewrite+0xf6>
    80003ee6:	8ba6                	mv	s7,s1
  int i = 0;
    80003ee8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eea:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003eec:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ef0:	21c48c13          	addi	s8,s1,540
    80003ef4:	a08d                	j	80003f56 <pipewrite+0xa8>
      release(&pi->lock);
    80003ef6:	8526                	mv	a0,s1
    80003ef8:	00002097          	auipc	ra,0x2
    80003efc:	396080e7          	jalr	918(ra) # 8000628e <release>
      return -1;
    80003f00:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f02:	854a                	mv	a0,s2
    80003f04:	70a6                	ld	ra,104(sp)
    80003f06:	7406                	ld	s0,96(sp)
    80003f08:	64e6                	ld	s1,88(sp)
    80003f0a:	6946                	ld	s2,80(sp)
    80003f0c:	69a6                	ld	s3,72(sp)
    80003f0e:	6a06                	ld	s4,64(sp)
    80003f10:	7ae2                	ld	s5,56(sp)
    80003f12:	7b42                	ld	s6,48(sp)
    80003f14:	7ba2                	ld	s7,40(sp)
    80003f16:	7c02                	ld	s8,32(sp)
    80003f18:	6ce2                	ld	s9,24(sp)
    80003f1a:	6165                	addi	sp,sp,112
    80003f1c:	8082                	ret
      wakeup(&pi->nread);
    80003f1e:	8566                	mv	a0,s9
    80003f20:	ffffd097          	auipc	ra,0xffffd
    80003f24:	77e080e7          	jalr	1918(ra) # 8000169e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f28:	85de                	mv	a1,s7
    80003f2a:	8562                	mv	a0,s8
    80003f2c:	ffffd097          	auipc	ra,0xffffd
    80003f30:	5e6080e7          	jalr	1510(ra) # 80001512 <sleep>
    80003f34:	a839                	j	80003f52 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f36:	21c4a783          	lw	a5,540(s1)
    80003f3a:	0017871b          	addiw	a4,a5,1
    80003f3e:	20e4ae23          	sw	a4,540(s1)
    80003f42:	1ff7f793          	andi	a5,a5,511
    80003f46:	97a6                	add	a5,a5,s1
    80003f48:	f9f44703          	lbu	a4,-97(s0)
    80003f4c:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f50:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f52:	03495d63          	bge	s2,s4,80003f8c <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f56:	2204a783          	lw	a5,544(s1)
    80003f5a:	dfd1                	beqz	a5,80003ef6 <pipewrite+0x48>
    80003f5c:	0289a783          	lw	a5,40(s3)
    80003f60:	fbd9                	bnez	a5,80003ef6 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f62:	2184a783          	lw	a5,536(s1)
    80003f66:	21c4a703          	lw	a4,540(s1)
    80003f6a:	2007879b          	addiw	a5,a5,512
    80003f6e:	faf708e3          	beq	a4,a5,80003f1e <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f72:	4685                	li	a3,1
    80003f74:	01590633          	add	a2,s2,s5
    80003f78:	f9f40593          	addi	a1,s0,-97
    80003f7c:	0509b503          	ld	a0,80(s3)
    80003f80:	ffffd097          	auipc	ra,0xffffd
    80003f84:	c16080e7          	jalr	-1002(ra) # 80000b96 <copyin>
    80003f88:	fb6517e3          	bne	a0,s6,80003f36 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f8c:	21848513          	addi	a0,s1,536
    80003f90:	ffffd097          	auipc	ra,0xffffd
    80003f94:	70e080e7          	jalr	1806(ra) # 8000169e <wakeup>
  release(&pi->lock);
    80003f98:	8526                	mv	a0,s1
    80003f9a:	00002097          	auipc	ra,0x2
    80003f9e:	2f4080e7          	jalr	756(ra) # 8000628e <release>
  return i;
    80003fa2:	b785                	j	80003f02 <pipewrite+0x54>
  int i = 0;
    80003fa4:	4901                	li	s2,0
    80003fa6:	b7dd                	j	80003f8c <pipewrite+0xde>

0000000080003fa8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fa8:	715d                	addi	sp,sp,-80
    80003faa:	e486                	sd	ra,72(sp)
    80003fac:	e0a2                	sd	s0,64(sp)
    80003fae:	fc26                	sd	s1,56(sp)
    80003fb0:	f84a                	sd	s2,48(sp)
    80003fb2:	f44e                	sd	s3,40(sp)
    80003fb4:	f052                	sd	s4,32(sp)
    80003fb6:	ec56                	sd	s5,24(sp)
    80003fb8:	e85a                	sd	s6,16(sp)
    80003fba:	0880                	addi	s0,sp,80
    80003fbc:	84aa                	mv	s1,a0
    80003fbe:	892e                	mv	s2,a1
    80003fc0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fc2:	ffffd097          	auipc	ra,0xffffd
    80003fc6:	e86080e7          	jalr	-378(ra) # 80000e48 <myproc>
    80003fca:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fcc:	8b26                	mv	s6,s1
    80003fce:	8526                	mv	a0,s1
    80003fd0:	00002097          	auipc	ra,0x2
    80003fd4:	20a080e7          	jalr	522(ra) # 800061da <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fd8:	2184a703          	lw	a4,536(s1)
    80003fdc:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fe0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fe4:	02f71463          	bne	a4,a5,8000400c <piperead+0x64>
    80003fe8:	2244a783          	lw	a5,548(s1)
    80003fec:	c385                	beqz	a5,8000400c <piperead+0x64>
    if(pr->killed){
    80003fee:	028a2783          	lw	a5,40(s4)
    80003ff2:	ebc1                	bnez	a5,80004082 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ff4:	85da                	mv	a1,s6
    80003ff6:	854e                	mv	a0,s3
    80003ff8:	ffffd097          	auipc	ra,0xffffd
    80003ffc:	51a080e7          	jalr	1306(ra) # 80001512 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004000:	2184a703          	lw	a4,536(s1)
    80004004:	21c4a783          	lw	a5,540(s1)
    80004008:	fef700e3          	beq	a4,a5,80003fe8 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000400c:	09505263          	blez	s5,80004090 <piperead+0xe8>
    80004010:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004012:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004014:	2184a783          	lw	a5,536(s1)
    80004018:	21c4a703          	lw	a4,540(s1)
    8000401c:	02f70d63          	beq	a4,a5,80004056 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004020:	0017871b          	addiw	a4,a5,1
    80004024:	20e4ac23          	sw	a4,536(s1)
    80004028:	1ff7f793          	andi	a5,a5,511
    8000402c:	97a6                	add	a5,a5,s1
    8000402e:	0187c783          	lbu	a5,24(a5)
    80004032:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004036:	4685                	li	a3,1
    80004038:	fbf40613          	addi	a2,s0,-65
    8000403c:	85ca                	mv	a1,s2
    8000403e:	050a3503          	ld	a0,80(s4)
    80004042:	ffffd097          	auipc	ra,0xffffd
    80004046:	ac8080e7          	jalr	-1336(ra) # 80000b0a <copyout>
    8000404a:	01650663          	beq	a0,s6,80004056 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000404e:	2985                	addiw	s3,s3,1
    80004050:	0905                	addi	s2,s2,1
    80004052:	fd3a91e3          	bne	s5,s3,80004014 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004056:	21c48513          	addi	a0,s1,540
    8000405a:	ffffd097          	auipc	ra,0xffffd
    8000405e:	644080e7          	jalr	1604(ra) # 8000169e <wakeup>
  release(&pi->lock);
    80004062:	8526                	mv	a0,s1
    80004064:	00002097          	auipc	ra,0x2
    80004068:	22a080e7          	jalr	554(ra) # 8000628e <release>
  return i;
}
    8000406c:	854e                	mv	a0,s3
    8000406e:	60a6                	ld	ra,72(sp)
    80004070:	6406                	ld	s0,64(sp)
    80004072:	74e2                	ld	s1,56(sp)
    80004074:	7942                	ld	s2,48(sp)
    80004076:	79a2                	ld	s3,40(sp)
    80004078:	7a02                	ld	s4,32(sp)
    8000407a:	6ae2                	ld	s5,24(sp)
    8000407c:	6b42                	ld	s6,16(sp)
    8000407e:	6161                	addi	sp,sp,80
    80004080:	8082                	ret
      release(&pi->lock);
    80004082:	8526                	mv	a0,s1
    80004084:	00002097          	auipc	ra,0x2
    80004088:	20a080e7          	jalr	522(ra) # 8000628e <release>
      return -1;
    8000408c:	59fd                	li	s3,-1
    8000408e:	bff9                	j	8000406c <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004090:	4981                	li	s3,0
    80004092:	b7d1                	j	80004056 <piperead+0xae>

0000000080004094 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004094:	df010113          	addi	sp,sp,-528
    80004098:	20113423          	sd	ra,520(sp)
    8000409c:	20813023          	sd	s0,512(sp)
    800040a0:	ffa6                	sd	s1,504(sp)
    800040a2:	fbca                	sd	s2,496(sp)
    800040a4:	f7ce                	sd	s3,488(sp)
    800040a6:	f3d2                	sd	s4,480(sp)
    800040a8:	efd6                	sd	s5,472(sp)
    800040aa:	ebda                	sd	s6,464(sp)
    800040ac:	e7de                	sd	s7,456(sp)
    800040ae:	e3e2                	sd	s8,448(sp)
    800040b0:	ff66                	sd	s9,440(sp)
    800040b2:	fb6a                	sd	s10,432(sp)
    800040b4:	f76e                	sd	s11,424(sp)
    800040b6:	0c00                	addi	s0,sp,528
    800040b8:	84aa                	mv	s1,a0
    800040ba:	dea43c23          	sd	a0,-520(s0)
    800040be:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	d86080e7          	jalr	-634(ra) # 80000e48 <myproc>
    800040ca:	892a                	mv	s2,a0

  begin_op();
    800040cc:	fffff097          	auipc	ra,0xfffff
    800040d0:	49c080e7          	jalr	1180(ra) # 80003568 <begin_op>

  if((ip = namei(path)) == 0){
    800040d4:	8526                	mv	a0,s1
    800040d6:	fffff097          	auipc	ra,0xfffff
    800040da:	276080e7          	jalr	630(ra) # 8000334c <namei>
    800040de:	c92d                	beqz	a0,80004150 <exec+0xbc>
    800040e0:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040e2:	fffff097          	auipc	ra,0xfffff
    800040e6:	ab4080e7          	jalr	-1356(ra) # 80002b96 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040ea:	04000713          	li	a4,64
    800040ee:	4681                	li	a3,0
    800040f0:	e5040613          	addi	a2,s0,-432
    800040f4:	4581                	li	a1,0
    800040f6:	8526                	mv	a0,s1
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	d52080e7          	jalr	-686(ra) # 80002e4a <readi>
    80004100:	04000793          	li	a5,64
    80004104:	00f51a63          	bne	a0,a5,80004118 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004108:	e5042703          	lw	a4,-432(s0)
    8000410c:	464c47b7          	lui	a5,0x464c4
    80004110:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004114:	04f70463          	beq	a4,a5,8000415c <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004118:	8526                	mv	a0,s1
    8000411a:	fffff097          	auipc	ra,0xfffff
    8000411e:	cde080e7          	jalr	-802(ra) # 80002df8 <iunlockput>
    end_op();
    80004122:	fffff097          	auipc	ra,0xfffff
    80004126:	4c6080e7          	jalr	1222(ra) # 800035e8 <end_op>
  }
  return -1;
    8000412a:	557d                	li	a0,-1
}
    8000412c:	20813083          	ld	ra,520(sp)
    80004130:	20013403          	ld	s0,512(sp)
    80004134:	74fe                	ld	s1,504(sp)
    80004136:	795e                	ld	s2,496(sp)
    80004138:	79be                	ld	s3,488(sp)
    8000413a:	7a1e                	ld	s4,480(sp)
    8000413c:	6afe                	ld	s5,472(sp)
    8000413e:	6b5e                	ld	s6,464(sp)
    80004140:	6bbe                	ld	s7,456(sp)
    80004142:	6c1e                	ld	s8,448(sp)
    80004144:	7cfa                	ld	s9,440(sp)
    80004146:	7d5a                	ld	s10,432(sp)
    80004148:	7dba                	ld	s11,424(sp)
    8000414a:	21010113          	addi	sp,sp,528
    8000414e:	8082                	ret
    end_op();
    80004150:	fffff097          	auipc	ra,0xfffff
    80004154:	498080e7          	jalr	1176(ra) # 800035e8 <end_op>
    return -1;
    80004158:	557d                	li	a0,-1
    8000415a:	bfc9                	j	8000412c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000415c:	854a                	mv	a0,s2
    8000415e:	ffffd097          	auipc	ra,0xffffd
    80004162:	dae080e7          	jalr	-594(ra) # 80000f0c <proc_pagetable>
    80004166:	8baa                	mv	s7,a0
    80004168:	d945                	beqz	a0,80004118 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000416a:	e7042983          	lw	s3,-400(s0)
    8000416e:	e8845783          	lhu	a5,-376(s0)
    80004172:	c7ad                	beqz	a5,800041dc <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004174:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004176:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004178:	6c85                	lui	s9,0x1
    8000417a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000417e:	def43823          	sd	a5,-528(s0)
    80004182:	a42d                	j	800043ac <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004184:	00004517          	auipc	a0,0x4
    80004188:	4d450513          	addi	a0,a0,1236 # 80008658 <syscalls+0x290>
    8000418c:	00002097          	auipc	ra,0x2
    80004190:	b2e080e7          	jalr	-1234(ra) # 80005cba <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004194:	8756                	mv	a4,s5
    80004196:	012d86bb          	addw	a3,s11,s2
    8000419a:	4581                	li	a1,0
    8000419c:	8526                	mv	a0,s1
    8000419e:	fffff097          	auipc	ra,0xfffff
    800041a2:	cac080e7          	jalr	-852(ra) # 80002e4a <readi>
    800041a6:	2501                	sext.w	a0,a0
    800041a8:	1aaa9963          	bne	s5,a0,8000435a <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041ac:	6785                	lui	a5,0x1
    800041ae:	0127893b          	addw	s2,a5,s2
    800041b2:	77fd                	lui	a5,0xfffff
    800041b4:	01478a3b          	addw	s4,a5,s4
    800041b8:	1f897163          	bgeu	s2,s8,8000439a <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041bc:	02091593          	slli	a1,s2,0x20
    800041c0:	9181                	srli	a1,a1,0x20
    800041c2:	95ea                	add	a1,a1,s10
    800041c4:	855e                	mv	a0,s7
    800041c6:	ffffc097          	auipc	ra,0xffffc
    800041ca:	340080e7          	jalr	832(ra) # 80000506 <walkaddr>
    800041ce:	862a                	mv	a2,a0
    if(pa == 0)
    800041d0:	d955                	beqz	a0,80004184 <exec+0xf0>
      n = PGSIZE;
    800041d2:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800041d4:	fd9a70e3          	bgeu	s4,s9,80004194 <exec+0x100>
      n = sz - i;
    800041d8:	8ad2                	mv	s5,s4
    800041da:	bf6d                	j	80004194 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041dc:	4901                	li	s2,0
  iunlockput(ip);
    800041de:	8526                	mv	a0,s1
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	c18080e7          	jalr	-1000(ra) # 80002df8 <iunlockput>
  end_op();
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	400080e7          	jalr	1024(ra) # 800035e8 <end_op>
  p = myproc();
    800041f0:	ffffd097          	auipc	ra,0xffffd
    800041f4:	c58080e7          	jalr	-936(ra) # 80000e48 <myproc>
    800041f8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041fa:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041fe:	6785                	lui	a5,0x1
    80004200:	17fd                	addi	a5,a5,-1
    80004202:	993e                	add	s2,s2,a5
    80004204:	757d                	lui	a0,0xfffff
    80004206:	00a977b3          	and	a5,s2,a0
    8000420a:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000420e:	6609                	lui	a2,0x2
    80004210:	963e                	add	a2,a2,a5
    80004212:	85be                	mv	a1,a5
    80004214:	855e                	mv	a0,s7
    80004216:	ffffc097          	auipc	ra,0xffffc
    8000421a:	6a4080e7          	jalr	1700(ra) # 800008ba <uvmalloc>
    8000421e:	8b2a                	mv	s6,a0
  ip = 0;
    80004220:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004222:	12050c63          	beqz	a0,8000435a <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004226:	75f9                	lui	a1,0xffffe
    80004228:	95aa                	add	a1,a1,a0
    8000422a:	855e                	mv	a0,s7
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	8ac080e7          	jalr	-1876(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004234:	7c7d                	lui	s8,0xfffff
    80004236:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004238:	e0043783          	ld	a5,-512(s0)
    8000423c:	6388                	ld	a0,0(a5)
    8000423e:	c535                	beqz	a0,800042aa <exec+0x216>
    80004240:	e9040993          	addi	s3,s0,-368
    80004244:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004248:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000424a:	ffffc097          	auipc	ra,0xffffc
    8000424e:	0b2080e7          	jalr	178(ra) # 800002fc <strlen>
    80004252:	2505                	addiw	a0,a0,1
    80004254:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004258:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000425c:	13896363          	bltu	s2,s8,80004382 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004260:	e0043d83          	ld	s11,-512(s0)
    80004264:	000dba03          	ld	s4,0(s11)
    80004268:	8552                	mv	a0,s4
    8000426a:	ffffc097          	auipc	ra,0xffffc
    8000426e:	092080e7          	jalr	146(ra) # 800002fc <strlen>
    80004272:	0015069b          	addiw	a3,a0,1
    80004276:	8652                	mv	a2,s4
    80004278:	85ca                	mv	a1,s2
    8000427a:	855e                	mv	a0,s7
    8000427c:	ffffd097          	auipc	ra,0xffffd
    80004280:	88e080e7          	jalr	-1906(ra) # 80000b0a <copyout>
    80004284:	10054363          	bltz	a0,8000438a <exec+0x2f6>
    ustack[argc] = sp;
    80004288:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000428c:	0485                	addi	s1,s1,1
    8000428e:	008d8793          	addi	a5,s11,8
    80004292:	e0f43023          	sd	a5,-512(s0)
    80004296:	008db503          	ld	a0,8(s11)
    8000429a:	c911                	beqz	a0,800042ae <exec+0x21a>
    if(argc >= MAXARG)
    8000429c:	09a1                	addi	s3,s3,8
    8000429e:	fb3c96e3          	bne	s9,s3,8000424a <exec+0x1b6>
  sz = sz1;
    800042a2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042a6:	4481                	li	s1,0
    800042a8:	a84d                	j	8000435a <exec+0x2c6>
  sp = sz;
    800042aa:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042ac:	4481                	li	s1,0
  ustack[argc] = 0;
    800042ae:	00349793          	slli	a5,s1,0x3
    800042b2:	f9040713          	addi	a4,s0,-112
    800042b6:	97ba                	add	a5,a5,a4
    800042b8:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042bc:	00148693          	addi	a3,s1,1
    800042c0:	068e                	slli	a3,a3,0x3
    800042c2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042c6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042ca:	01897663          	bgeu	s2,s8,800042d6 <exec+0x242>
  sz = sz1;
    800042ce:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042d2:	4481                	li	s1,0
    800042d4:	a059                	j	8000435a <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042d6:	e9040613          	addi	a2,s0,-368
    800042da:	85ca                	mv	a1,s2
    800042dc:	855e                	mv	a0,s7
    800042de:	ffffd097          	auipc	ra,0xffffd
    800042e2:	82c080e7          	jalr	-2004(ra) # 80000b0a <copyout>
    800042e6:	0a054663          	bltz	a0,80004392 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800042ea:	058ab783          	ld	a5,88(s5)
    800042ee:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042f2:	df843783          	ld	a5,-520(s0)
    800042f6:	0007c703          	lbu	a4,0(a5)
    800042fa:	cf11                	beqz	a4,80004316 <exec+0x282>
    800042fc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042fe:	02f00693          	li	a3,47
    80004302:	a039                	j	80004310 <exec+0x27c>
      last = s+1;
    80004304:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004308:	0785                	addi	a5,a5,1
    8000430a:	fff7c703          	lbu	a4,-1(a5)
    8000430e:	c701                	beqz	a4,80004316 <exec+0x282>
    if(*s == '/')
    80004310:	fed71ce3          	bne	a4,a3,80004308 <exec+0x274>
    80004314:	bfc5                	j	80004304 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004316:	4641                	li	a2,16
    80004318:	df843583          	ld	a1,-520(s0)
    8000431c:	158a8513          	addi	a0,s5,344
    80004320:	ffffc097          	auipc	ra,0xffffc
    80004324:	faa080e7          	jalr	-86(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004328:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000432c:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004330:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004334:	058ab783          	ld	a5,88(s5)
    80004338:	e6843703          	ld	a4,-408(s0)
    8000433c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000433e:	058ab783          	ld	a5,88(s5)
    80004342:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004346:	85ea                	mv	a1,s10
    80004348:	ffffd097          	auipc	ra,0xffffd
    8000434c:	c60080e7          	jalr	-928(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004350:	0004851b          	sext.w	a0,s1
    80004354:	bbe1                	j	8000412c <exec+0x98>
    80004356:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000435a:	e0843583          	ld	a1,-504(s0)
    8000435e:	855e                	mv	a0,s7
    80004360:	ffffd097          	auipc	ra,0xffffd
    80004364:	c48080e7          	jalr	-952(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    80004368:	da0498e3          	bnez	s1,80004118 <exec+0x84>
  return -1;
    8000436c:	557d                	li	a0,-1
    8000436e:	bb7d                	j	8000412c <exec+0x98>
    80004370:	e1243423          	sd	s2,-504(s0)
    80004374:	b7dd                	j	8000435a <exec+0x2c6>
    80004376:	e1243423          	sd	s2,-504(s0)
    8000437a:	b7c5                	j	8000435a <exec+0x2c6>
    8000437c:	e1243423          	sd	s2,-504(s0)
    80004380:	bfe9                	j	8000435a <exec+0x2c6>
  sz = sz1;
    80004382:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004386:	4481                	li	s1,0
    80004388:	bfc9                	j	8000435a <exec+0x2c6>
  sz = sz1;
    8000438a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000438e:	4481                	li	s1,0
    80004390:	b7e9                	j	8000435a <exec+0x2c6>
  sz = sz1;
    80004392:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004396:	4481                	li	s1,0
    80004398:	b7c9                	j	8000435a <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000439a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000439e:	2b05                	addiw	s6,s6,1
    800043a0:	0389899b          	addiw	s3,s3,56
    800043a4:	e8845783          	lhu	a5,-376(s0)
    800043a8:	e2fb5be3          	bge	s6,a5,800041de <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043ac:	2981                	sext.w	s3,s3
    800043ae:	03800713          	li	a4,56
    800043b2:	86ce                	mv	a3,s3
    800043b4:	e1840613          	addi	a2,s0,-488
    800043b8:	4581                	li	a1,0
    800043ba:	8526                	mv	a0,s1
    800043bc:	fffff097          	auipc	ra,0xfffff
    800043c0:	a8e080e7          	jalr	-1394(ra) # 80002e4a <readi>
    800043c4:	03800793          	li	a5,56
    800043c8:	f8f517e3          	bne	a0,a5,80004356 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800043cc:	e1842783          	lw	a5,-488(s0)
    800043d0:	4705                	li	a4,1
    800043d2:	fce796e3          	bne	a5,a4,8000439e <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800043d6:	e4043603          	ld	a2,-448(s0)
    800043da:	e3843783          	ld	a5,-456(s0)
    800043de:	f8f669e3          	bltu	a2,a5,80004370 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043e2:	e2843783          	ld	a5,-472(s0)
    800043e6:	963e                	add	a2,a2,a5
    800043e8:	f8f667e3          	bltu	a2,a5,80004376 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043ec:	85ca                	mv	a1,s2
    800043ee:	855e                	mv	a0,s7
    800043f0:	ffffc097          	auipc	ra,0xffffc
    800043f4:	4ca080e7          	jalr	1226(ra) # 800008ba <uvmalloc>
    800043f8:	e0a43423          	sd	a0,-504(s0)
    800043fc:	d141                	beqz	a0,8000437c <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800043fe:	e2843d03          	ld	s10,-472(s0)
    80004402:	df043783          	ld	a5,-528(s0)
    80004406:	00fd77b3          	and	a5,s10,a5
    8000440a:	fba1                	bnez	a5,8000435a <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000440c:	e2042d83          	lw	s11,-480(s0)
    80004410:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004414:	f80c03e3          	beqz	s8,8000439a <exec+0x306>
    80004418:	8a62                	mv	s4,s8
    8000441a:	4901                	li	s2,0
    8000441c:	b345                	j	800041bc <exec+0x128>

000000008000441e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000441e:	7179                	addi	sp,sp,-48
    80004420:	f406                	sd	ra,40(sp)
    80004422:	f022                	sd	s0,32(sp)
    80004424:	ec26                	sd	s1,24(sp)
    80004426:	e84a                	sd	s2,16(sp)
    80004428:	1800                	addi	s0,sp,48
    8000442a:	892e                	mv	s2,a1
    8000442c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000442e:	fdc40593          	addi	a1,s0,-36
    80004432:	ffffe097          	auipc	ra,0xffffe
    80004436:	b38080e7          	jalr	-1224(ra) # 80001f6a <argint>
    8000443a:	04054063          	bltz	a0,8000447a <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000443e:	fdc42703          	lw	a4,-36(s0)
    80004442:	47bd                	li	a5,15
    80004444:	02e7ed63          	bltu	a5,a4,8000447e <argfd+0x60>
    80004448:	ffffd097          	auipc	ra,0xffffd
    8000444c:	a00080e7          	jalr	-1536(ra) # 80000e48 <myproc>
    80004450:	fdc42703          	lw	a4,-36(s0)
    80004454:	01a70793          	addi	a5,a4,26
    80004458:	078e                	slli	a5,a5,0x3
    8000445a:	953e                	add	a0,a0,a5
    8000445c:	611c                	ld	a5,0(a0)
    8000445e:	c395                	beqz	a5,80004482 <argfd+0x64>
    return -1;
  if(pfd)
    80004460:	00090463          	beqz	s2,80004468 <argfd+0x4a>
    *pfd = fd;
    80004464:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004468:	4501                	li	a0,0
  if(pf)
    8000446a:	c091                	beqz	s1,8000446e <argfd+0x50>
    *pf = f;
    8000446c:	e09c                	sd	a5,0(s1)
}
    8000446e:	70a2                	ld	ra,40(sp)
    80004470:	7402                	ld	s0,32(sp)
    80004472:	64e2                	ld	s1,24(sp)
    80004474:	6942                	ld	s2,16(sp)
    80004476:	6145                	addi	sp,sp,48
    80004478:	8082                	ret
    return -1;
    8000447a:	557d                	li	a0,-1
    8000447c:	bfcd                	j	8000446e <argfd+0x50>
    return -1;
    8000447e:	557d                	li	a0,-1
    80004480:	b7fd                	j	8000446e <argfd+0x50>
    80004482:	557d                	li	a0,-1
    80004484:	b7ed                	j	8000446e <argfd+0x50>

0000000080004486 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004486:	1101                	addi	sp,sp,-32
    80004488:	ec06                	sd	ra,24(sp)
    8000448a:	e822                	sd	s0,16(sp)
    8000448c:	e426                	sd	s1,8(sp)
    8000448e:	1000                	addi	s0,sp,32
    80004490:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004492:	ffffd097          	auipc	ra,0xffffd
    80004496:	9b6080e7          	jalr	-1610(ra) # 80000e48 <myproc>
    8000449a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000449c:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd4e90>
    800044a0:	4501                	li	a0,0
    800044a2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044a4:	6398                	ld	a4,0(a5)
    800044a6:	cb19                	beqz	a4,800044bc <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044a8:	2505                	addiw	a0,a0,1
    800044aa:	07a1                	addi	a5,a5,8
    800044ac:	fed51ce3          	bne	a0,a3,800044a4 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044b0:	557d                	li	a0,-1
}
    800044b2:	60e2                	ld	ra,24(sp)
    800044b4:	6442                	ld	s0,16(sp)
    800044b6:	64a2                	ld	s1,8(sp)
    800044b8:	6105                	addi	sp,sp,32
    800044ba:	8082                	ret
      p->ofile[fd] = f;
    800044bc:	01a50793          	addi	a5,a0,26
    800044c0:	078e                	slli	a5,a5,0x3
    800044c2:	963e                	add	a2,a2,a5
    800044c4:	e204                	sd	s1,0(a2)
      return fd;
    800044c6:	b7f5                	j	800044b2 <fdalloc+0x2c>

00000000800044c8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044c8:	715d                	addi	sp,sp,-80
    800044ca:	e486                	sd	ra,72(sp)
    800044cc:	e0a2                	sd	s0,64(sp)
    800044ce:	fc26                	sd	s1,56(sp)
    800044d0:	f84a                	sd	s2,48(sp)
    800044d2:	f44e                	sd	s3,40(sp)
    800044d4:	f052                	sd	s4,32(sp)
    800044d6:	ec56                	sd	s5,24(sp)
    800044d8:	0880                	addi	s0,sp,80
    800044da:	89ae                	mv	s3,a1
    800044dc:	8ab2                	mv	s5,a2
    800044de:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044e0:	fb040593          	addi	a1,s0,-80
    800044e4:	fffff097          	auipc	ra,0xfffff
    800044e8:	e86080e7          	jalr	-378(ra) # 8000336a <nameiparent>
    800044ec:	892a                	mv	s2,a0
    800044ee:	12050f63          	beqz	a0,8000462c <create+0x164>
    return 0;

  ilock(dp);
    800044f2:	ffffe097          	auipc	ra,0xffffe
    800044f6:	6a4080e7          	jalr	1700(ra) # 80002b96 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044fa:	4601                	li	a2,0
    800044fc:	fb040593          	addi	a1,s0,-80
    80004500:	854a                	mv	a0,s2
    80004502:	fffff097          	auipc	ra,0xfffff
    80004506:	b78080e7          	jalr	-1160(ra) # 8000307a <dirlookup>
    8000450a:	84aa                	mv	s1,a0
    8000450c:	c921                	beqz	a0,8000455c <create+0x94>
    iunlockput(dp);
    8000450e:	854a                	mv	a0,s2
    80004510:	fffff097          	auipc	ra,0xfffff
    80004514:	8e8080e7          	jalr	-1816(ra) # 80002df8 <iunlockput>
    ilock(ip);
    80004518:	8526                	mv	a0,s1
    8000451a:	ffffe097          	auipc	ra,0xffffe
    8000451e:	67c080e7          	jalr	1660(ra) # 80002b96 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004522:	2981                	sext.w	s3,s3
    80004524:	4789                	li	a5,2
    80004526:	02f99463          	bne	s3,a5,8000454e <create+0x86>
    8000452a:	0444d783          	lhu	a5,68(s1)
    8000452e:	37f9                	addiw	a5,a5,-2
    80004530:	17c2                	slli	a5,a5,0x30
    80004532:	93c1                	srli	a5,a5,0x30
    80004534:	4705                	li	a4,1
    80004536:	00f76c63          	bltu	a4,a5,8000454e <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000453a:	8526                	mv	a0,s1
    8000453c:	60a6                	ld	ra,72(sp)
    8000453e:	6406                	ld	s0,64(sp)
    80004540:	74e2                	ld	s1,56(sp)
    80004542:	7942                	ld	s2,48(sp)
    80004544:	79a2                	ld	s3,40(sp)
    80004546:	7a02                	ld	s4,32(sp)
    80004548:	6ae2                	ld	s5,24(sp)
    8000454a:	6161                	addi	sp,sp,80
    8000454c:	8082                	ret
    iunlockput(ip);
    8000454e:	8526                	mv	a0,s1
    80004550:	fffff097          	auipc	ra,0xfffff
    80004554:	8a8080e7          	jalr	-1880(ra) # 80002df8 <iunlockput>
    return 0;
    80004558:	4481                	li	s1,0
    8000455a:	b7c5                	j	8000453a <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000455c:	85ce                	mv	a1,s3
    8000455e:	00092503          	lw	a0,0(s2)
    80004562:	ffffe097          	auipc	ra,0xffffe
    80004566:	49c080e7          	jalr	1180(ra) # 800029fe <ialloc>
    8000456a:	84aa                	mv	s1,a0
    8000456c:	c529                	beqz	a0,800045b6 <create+0xee>
  ilock(ip);
    8000456e:	ffffe097          	auipc	ra,0xffffe
    80004572:	628080e7          	jalr	1576(ra) # 80002b96 <ilock>
  ip->major = major;
    80004576:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000457a:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000457e:	4785                	li	a5,1
    80004580:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004584:	8526                	mv	a0,s1
    80004586:	ffffe097          	auipc	ra,0xffffe
    8000458a:	546080e7          	jalr	1350(ra) # 80002acc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000458e:	2981                	sext.w	s3,s3
    80004590:	4785                	li	a5,1
    80004592:	02f98a63          	beq	s3,a5,800045c6 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004596:	40d0                	lw	a2,4(s1)
    80004598:	fb040593          	addi	a1,s0,-80
    8000459c:	854a                	mv	a0,s2
    8000459e:	fffff097          	auipc	ra,0xfffff
    800045a2:	cec080e7          	jalr	-788(ra) # 8000328a <dirlink>
    800045a6:	06054b63          	bltz	a0,8000461c <create+0x154>
  iunlockput(dp);
    800045aa:	854a                	mv	a0,s2
    800045ac:	fffff097          	auipc	ra,0xfffff
    800045b0:	84c080e7          	jalr	-1972(ra) # 80002df8 <iunlockput>
  return ip;
    800045b4:	b759                	j	8000453a <create+0x72>
    panic("create: ialloc");
    800045b6:	00004517          	auipc	a0,0x4
    800045ba:	0c250513          	addi	a0,a0,194 # 80008678 <syscalls+0x2b0>
    800045be:	00001097          	auipc	ra,0x1
    800045c2:	6fc080e7          	jalr	1788(ra) # 80005cba <panic>
    dp->nlink++;  // for ".."
    800045c6:	04a95783          	lhu	a5,74(s2)
    800045ca:	2785                	addiw	a5,a5,1
    800045cc:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045d0:	854a                	mv	a0,s2
    800045d2:	ffffe097          	auipc	ra,0xffffe
    800045d6:	4fa080e7          	jalr	1274(ra) # 80002acc <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045da:	40d0                	lw	a2,4(s1)
    800045dc:	00004597          	auipc	a1,0x4
    800045e0:	0ac58593          	addi	a1,a1,172 # 80008688 <syscalls+0x2c0>
    800045e4:	8526                	mv	a0,s1
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	ca4080e7          	jalr	-860(ra) # 8000328a <dirlink>
    800045ee:	00054f63          	bltz	a0,8000460c <create+0x144>
    800045f2:	00492603          	lw	a2,4(s2)
    800045f6:	00004597          	auipc	a1,0x4
    800045fa:	09a58593          	addi	a1,a1,154 # 80008690 <syscalls+0x2c8>
    800045fe:	8526                	mv	a0,s1
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	c8a080e7          	jalr	-886(ra) # 8000328a <dirlink>
    80004608:	f80557e3          	bgez	a0,80004596 <create+0xce>
      panic("create dots");
    8000460c:	00004517          	auipc	a0,0x4
    80004610:	08c50513          	addi	a0,a0,140 # 80008698 <syscalls+0x2d0>
    80004614:	00001097          	auipc	ra,0x1
    80004618:	6a6080e7          	jalr	1702(ra) # 80005cba <panic>
    panic("create: dirlink");
    8000461c:	00004517          	auipc	a0,0x4
    80004620:	08c50513          	addi	a0,a0,140 # 800086a8 <syscalls+0x2e0>
    80004624:	00001097          	auipc	ra,0x1
    80004628:	696080e7          	jalr	1686(ra) # 80005cba <panic>
    return 0;
    8000462c:	84aa                	mv	s1,a0
    8000462e:	b731                	j	8000453a <create+0x72>

0000000080004630 <sys_dup>:
{
    80004630:	7179                	addi	sp,sp,-48
    80004632:	f406                	sd	ra,40(sp)
    80004634:	f022                	sd	s0,32(sp)
    80004636:	ec26                	sd	s1,24(sp)
    80004638:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000463a:	fd840613          	addi	a2,s0,-40
    8000463e:	4581                	li	a1,0
    80004640:	4501                	li	a0,0
    80004642:	00000097          	auipc	ra,0x0
    80004646:	ddc080e7          	jalr	-548(ra) # 8000441e <argfd>
    return -1;
    8000464a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000464c:	02054363          	bltz	a0,80004672 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004650:	fd843503          	ld	a0,-40(s0)
    80004654:	00000097          	auipc	ra,0x0
    80004658:	e32080e7          	jalr	-462(ra) # 80004486 <fdalloc>
    8000465c:	84aa                	mv	s1,a0
    return -1;
    8000465e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004660:	00054963          	bltz	a0,80004672 <sys_dup+0x42>
  filedup(f);
    80004664:	fd843503          	ld	a0,-40(s0)
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	37a080e7          	jalr	890(ra) # 800039e2 <filedup>
  return fd;
    80004670:	87a6                	mv	a5,s1
}
    80004672:	853e                	mv	a0,a5
    80004674:	70a2                	ld	ra,40(sp)
    80004676:	7402                	ld	s0,32(sp)
    80004678:	64e2                	ld	s1,24(sp)
    8000467a:	6145                	addi	sp,sp,48
    8000467c:	8082                	ret

000000008000467e <sys_read>:
{
    8000467e:	7179                	addi	sp,sp,-48
    80004680:	f406                	sd	ra,40(sp)
    80004682:	f022                	sd	s0,32(sp)
    80004684:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004686:	fe840613          	addi	a2,s0,-24
    8000468a:	4581                	li	a1,0
    8000468c:	4501                	li	a0,0
    8000468e:	00000097          	auipc	ra,0x0
    80004692:	d90080e7          	jalr	-624(ra) # 8000441e <argfd>
    return -1;
    80004696:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004698:	04054163          	bltz	a0,800046da <sys_read+0x5c>
    8000469c:	fe440593          	addi	a1,s0,-28
    800046a0:	4509                	li	a0,2
    800046a2:	ffffe097          	auipc	ra,0xffffe
    800046a6:	8c8080e7          	jalr	-1848(ra) # 80001f6a <argint>
    return -1;
    800046aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ac:	02054763          	bltz	a0,800046da <sys_read+0x5c>
    800046b0:	fd840593          	addi	a1,s0,-40
    800046b4:	4505                	li	a0,1
    800046b6:	ffffe097          	auipc	ra,0xffffe
    800046ba:	8d6080e7          	jalr	-1834(ra) # 80001f8c <argaddr>
    return -1;
    800046be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c0:	00054d63          	bltz	a0,800046da <sys_read+0x5c>
  return fileread(f, p, n);
    800046c4:	fe442603          	lw	a2,-28(s0)
    800046c8:	fd843583          	ld	a1,-40(s0)
    800046cc:	fe843503          	ld	a0,-24(s0)
    800046d0:	fffff097          	auipc	ra,0xfffff
    800046d4:	49e080e7          	jalr	1182(ra) # 80003b6e <fileread>
    800046d8:	87aa                	mv	a5,a0
}
    800046da:	853e                	mv	a0,a5
    800046dc:	70a2                	ld	ra,40(sp)
    800046de:	7402                	ld	s0,32(sp)
    800046e0:	6145                	addi	sp,sp,48
    800046e2:	8082                	ret

00000000800046e4 <sys_write>:
{
    800046e4:	7179                	addi	sp,sp,-48
    800046e6:	f406                	sd	ra,40(sp)
    800046e8:	f022                	sd	s0,32(sp)
    800046ea:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ec:	fe840613          	addi	a2,s0,-24
    800046f0:	4581                	li	a1,0
    800046f2:	4501                	li	a0,0
    800046f4:	00000097          	auipc	ra,0x0
    800046f8:	d2a080e7          	jalr	-726(ra) # 8000441e <argfd>
    return -1;
    800046fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fe:	04054163          	bltz	a0,80004740 <sys_write+0x5c>
    80004702:	fe440593          	addi	a1,s0,-28
    80004706:	4509                	li	a0,2
    80004708:	ffffe097          	auipc	ra,0xffffe
    8000470c:	862080e7          	jalr	-1950(ra) # 80001f6a <argint>
    return -1;
    80004710:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004712:	02054763          	bltz	a0,80004740 <sys_write+0x5c>
    80004716:	fd840593          	addi	a1,s0,-40
    8000471a:	4505                	li	a0,1
    8000471c:	ffffe097          	auipc	ra,0xffffe
    80004720:	870080e7          	jalr	-1936(ra) # 80001f8c <argaddr>
    return -1;
    80004724:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004726:	00054d63          	bltz	a0,80004740 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000472a:	fe442603          	lw	a2,-28(s0)
    8000472e:	fd843583          	ld	a1,-40(s0)
    80004732:	fe843503          	ld	a0,-24(s0)
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	4fa080e7          	jalr	1274(ra) # 80003c30 <filewrite>
    8000473e:	87aa                	mv	a5,a0
}
    80004740:	853e                	mv	a0,a5
    80004742:	70a2                	ld	ra,40(sp)
    80004744:	7402                	ld	s0,32(sp)
    80004746:	6145                	addi	sp,sp,48
    80004748:	8082                	ret

000000008000474a <sys_close>:
{
    8000474a:	1101                	addi	sp,sp,-32
    8000474c:	ec06                	sd	ra,24(sp)
    8000474e:	e822                	sd	s0,16(sp)
    80004750:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004752:	fe040613          	addi	a2,s0,-32
    80004756:	fec40593          	addi	a1,s0,-20
    8000475a:	4501                	li	a0,0
    8000475c:	00000097          	auipc	ra,0x0
    80004760:	cc2080e7          	jalr	-830(ra) # 8000441e <argfd>
    return -1;
    80004764:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004766:	02054463          	bltz	a0,8000478e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000476a:	ffffc097          	auipc	ra,0xffffc
    8000476e:	6de080e7          	jalr	1758(ra) # 80000e48 <myproc>
    80004772:	fec42783          	lw	a5,-20(s0)
    80004776:	07e9                	addi	a5,a5,26
    80004778:	078e                	slli	a5,a5,0x3
    8000477a:	97aa                	add	a5,a5,a0
    8000477c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004780:	fe043503          	ld	a0,-32(s0)
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	2b0080e7          	jalr	688(ra) # 80003a34 <fileclose>
  return 0;
    8000478c:	4781                	li	a5,0
}
    8000478e:	853e                	mv	a0,a5
    80004790:	60e2                	ld	ra,24(sp)
    80004792:	6442                	ld	s0,16(sp)
    80004794:	6105                	addi	sp,sp,32
    80004796:	8082                	ret

0000000080004798 <sys_fstat>:
{
    80004798:	1101                	addi	sp,sp,-32
    8000479a:	ec06                	sd	ra,24(sp)
    8000479c:	e822                	sd	s0,16(sp)
    8000479e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047a0:	fe840613          	addi	a2,s0,-24
    800047a4:	4581                	li	a1,0
    800047a6:	4501                	li	a0,0
    800047a8:	00000097          	auipc	ra,0x0
    800047ac:	c76080e7          	jalr	-906(ra) # 8000441e <argfd>
    return -1;
    800047b0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047b2:	02054563          	bltz	a0,800047dc <sys_fstat+0x44>
    800047b6:	fe040593          	addi	a1,s0,-32
    800047ba:	4505                	li	a0,1
    800047bc:	ffffd097          	auipc	ra,0xffffd
    800047c0:	7d0080e7          	jalr	2000(ra) # 80001f8c <argaddr>
    return -1;
    800047c4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047c6:	00054b63          	bltz	a0,800047dc <sys_fstat+0x44>
  return filestat(f, st);
    800047ca:	fe043583          	ld	a1,-32(s0)
    800047ce:	fe843503          	ld	a0,-24(s0)
    800047d2:	fffff097          	auipc	ra,0xfffff
    800047d6:	32a080e7          	jalr	810(ra) # 80003afc <filestat>
    800047da:	87aa                	mv	a5,a0
}
    800047dc:	853e                	mv	a0,a5
    800047de:	60e2                	ld	ra,24(sp)
    800047e0:	6442                	ld	s0,16(sp)
    800047e2:	6105                	addi	sp,sp,32
    800047e4:	8082                	ret

00000000800047e6 <sys_link>:
{
    800047e6:	7169                	addi	sp,sp,-304
    800047e8:	f606                	sd	ra,296(sp)
    800047ea:	f222                	sd	s0,288(sp)
    800047ec:	ee26                	sd	s1,280(sp)
    800047ee:	ea4a                	sd	s2,272(sp)
    800047f0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047f2:	08000613          	li	a2,128
    800047f6:	ed040593          	addi	a1,s0,-304
    800047fa:	4501                	li	a0,0
    800047fc:	ffffd097          	auipc	ra,0xffffd
    80004800:	7b2080e7          	jalr	1970(ra) # 80001fae <argstr>
    return -1;
    80004804:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004806:	10054e63          	bltz	a0,80004922 <sys_link+0x13c>
    8000480a:	08000613          	li	a2,128
    8000480e:	f5040593          	addi	a1,s0,-176
    80004812:	4505                	li	a0,1
    80004814:	ffffd097          	auipc	ra,0xffffd
    80004818:	79a080e7          	jalr	1946(ra) # 80001fae <argstr>
    return -1;
    8000481c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000481e:	10054263          	bltz	a0,80004922 <sys_link+0x13c>
  begin_op();
    80004822:	fffff097          	auipc	ra,0xfffff
    80004826:	d46080e7          	jalr	-698(ra) # 80003568 <begin_op>
  if((ip = namei(old)) == 0){
    8000482a:	ed040513          	addi	a0,s0,-304
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	b1e080e7          	jalr	-1250(ra) # 8000334c <namei>
    80004836:	84aa                	mv	s1,a0
    80004838:	c551                	beqz	a0,800048c4 <sys_link+0xde>
  ilock(ip);
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	35c080e7          	jalr	860(ra) # 80002b96 <ilock>
  if(ip->type == T_DIR){
    80004842:	04449703          	lh	a4,68(s1)
    80004846:	4785                	li	a5,1
    80004848:	08f70463          	beq	a4,a5,800048d0 <sys_link+0xea>
  ip->nlink++;
    8000484c:	04a4d783          	lhu	a5,74(s1)
    80004850:	2785                	addiw	a5,a5,1
    80004852:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004856:	8526                	mv	a0,s1
    80004858:	ffffe097          	auipc	ra,0xffffe
    8000485c:	274080e7          	jalr	628(ra) # 80002acc <iupdate>
  iunlock(ip);
    80004860:	8526                	mv	a0,s1
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	3f6080e7          	jalr	1014(ra) # 80002c58 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000486a:	fd040593          	addi	a1,s0,-48
    8000486e:	f5040513          	addi	a0,s0,-176
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	af8080e7          	jalr	-1288(ra) # 8000336a <nameiparent>
    8000487a:	892a                	mv	s2,a0
    8000487c:	c935                	beqz	a0,800048f0 <sys_link+0x10a>
  ilock(dp);
    8000487e:	ffffe097          	auipc	ra,0xffffe
    80004882:	318080e7          	jalr	792(ra) # 80002b96 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004886:	00092703          	lw	a4,0(s2)
    8000488a:	409c                	lw	a5,0(s1)
    8000488c:	04f71d63          	bne	a4,a5,800048e6 <sys_link+0x100>
    80004890:	40d0                	lw	a2,4(s1)
    80004892:	fd040593          	addi	a1,s0,-48
    80004896:	854a                	mv	a0,s2
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	9f2080e7          	jalr	-1550(ra) # 8000328a <dirlink>
    800048a0:	04054363          	bltz	a0,800048e6 <sys_link+0x100>
  iunlockput(dp);
    800048a4:	854a                	mv	a0,s2
    800048a6:	ffffe097          	auipc	ra,0xffffe
    800048aa:	552080e7          	jalr	1362(ra) # 80002df8 <iunlockput>
  iput(ip);
    800048ae:	8526                	mv	a0,s1
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	4a0080e7          	jalr	1184(ra) # 80002d50 <iput>
  end_op();
    800048b8:	fffff097          	auipc	ra,0xfffff
    800048bc:	d30080e7          	jalr	-720(ra) # 800035e8 <end_op>
  return 0;
    800048c0:	4781                	li	a5,0
    800048c2:	a085                	j	80004922 <sys_link+0x13c>
    end_op();
    800048c4:	fffff097          	auipc	ra,0xfffff
    800048c8:	d24080e7          	jalr	-732(ra) # 800035e8 <end_op>
    return -1;
    800048cc:	57fd                	li	a5,-1
    800048ce:	a891                	j	80004922 <sys_link+0x13c>
    iunlockput(ip);
    800048d0:	8526                	mv	a0,s1
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	526080e7          	jalr	1318(ra) # 80002df8 <iunlockput>
    end_op();
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	d0e080e7          	jalr	-754(ra) # 800035e8 <end_op>
    return -1;
    800048e2:	57fd                	li	a5,-1
    800048e4:	a83d                	j	80004922 <sys_link+0x13c>
    iunlockput(dp);
    800048e6:	854a                	mv	a0,s2
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	510080e7          	jalr	1296(ra) # 80002df8 <iunlockput>
  ilock(ip);
    800048f0:	8526                	mv	a0,s1
    800048f2:	ffffe097          	auipc	ra,0xffffe
    800048f6:	2a4080e7          	jalr	676(ra) # 80002b96 <ilock>
  ip->nlink--;
    800048fa:	04a4d783          	lhu	a5,74(s1)
    800048fe:	37fd                	addiw	a5,a5,-1
    80004900:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004904:	8526                	mv	a0,s1
    80004906:	ffffe097          	auipc	ra,0xffffe
    8000490a:	1c6080e7          	jalr	454(ra) # 80002acc <iupdate>
  iunlockput(ip);
    8000490e:	8526                	mv	a0,s1
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	4e8080e7          	jalr	1256(ra) # 80002df8 <iunlockput>
  end_op();
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	cd0080e7          	jalr	-816(ra) # 800035e8 <end_op>
  return -1;
    80004920:	57fd                	li	a5,-1
}
    80004922:	853e                	mv	a0,a5
    80004924:	70b2                	ld	ra,296(sp)
    80004926:	7412                	ld	s0,288(sp)
    80004928:	64f2                	ld	s1,280(sp)
    8000492a:	6952                	ld	s2,272(sp)
    8000492c:	6155                	addi	sp,sp,304
    8000492e:	8082                	ret

0000000080004930 <sys_unlink>:
{
    80004930:	7151                	addi	sp,sp,-240
    80004932:	f586                	sd	ra,232(sp)
    80004934:	f1a2                	sd	s0,224(sp)
    80004936:	eda6                	sd	s1,216(sp)
    80004938:	e9ca                	sd	s2,208(sp)
    8000493a:	e5ce                	sd	s3,200(sp)
    8000493c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000493e:	08000613          	li	a2,128
    80004942:	f3040593          	addi	a1,s0,-208
    80004946:	4501                	li	a0,0
    80004948:	ffffd097          	auipc	ra,0xffffd
    8000494c:	666080e7          	jalr	1638(ra) # 80001fae <argstr>
    80004950:	18054163          	bltz	a0,80004ad2 <sys_unlink+0x1a2>
  begin_op();
    80004954:	fffff097          	auipc	ra,0xfffff
    80004958:	c14080e7          	jalr	-1004(ra) # 80003568 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000495c:	fb040593          	addi	a1,s0,-80
    80004960:	f3040513          	addi	a0,s0,-208
    80004964:	fffff097          	auipc	ra,0xfffff
    80004968:	a06080e7          	jalr	-1530(ra) # 8000336a <nameiparent>
    8000496c:	84aa                	mv	s1,a0
    8000496e:	c979                	beqz	a0,80004a44 <sys_unlink+0x114>
  ilock(dp);
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	226080e7          	jalr	550(ra) # 80002b96 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004978:	00004597          	auipc	a1,0x4
    8000497c:	d1058593          	addi	a1,a1,-752 # 80008688 <syscalls+0x2c0>
    80004980:	fb040513          	addi	a0,s0,-80
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	6dc080e7          	jalr	1756(ra) # 80003060 <namecmp>
    8000498c:	14050a63          	beqz	a0,80004ae0 <sys_unlink+0x1b0>
    80004990:	00004597          	auipc	a1,0x4
    80004994:	d0058593          	addi	a1,a1,-768 # 80008690 <syscalls+0x2c8>
    80004998:	fb040513          	addi	a0,s0,-80
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	6c4080e7          	jalr	1732(ra) # 80003060 <namecmp>
    800049a4:	12050e63          	beqz	a0,80004ae0 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049a8:	f2c40613          	addi	a2,s0,-212
    800049ac:	fb040593          	addi	a1,s0,-80
    800049b0:	8526                	mv	a0,s1
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	6c8080e7          	jalr	1736(ra) # 8000307a <dirlookup>
    800049ba:	892a                	mv	s2,a0
    800049bc:	12050263          	beqz	a0,80004ae0 <sys_unlink+0x1b0>
  ilock(ip);
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	1d6080e7          	jalr	470(ra) # 80002b96 <ilock>
  if(ip->nlink < 1)
    800049c8:	04a91783          	lh	a5,74(s2)
    800049cc:	08f05263          	blez	a5,80004a50 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049d0:	04491703          	lh	a4,68(s2)
    800049d4:	4785                	li	a5,1
    800049d6:	08f70563          	beq	a4,a5,80004a60 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049da:	4641                	li	a2,16
    800049dc:	4581                	li	a1,0
    800049de:	fc040513          	addi	a0,s0,-64
    800049e2:	ffffb097          	auipc	ra,0xffffb
    800049e6:	796080e7          	jalr	1942(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049ea:	4741                	li	a4,16
    800049ec:	f2c42683          	lw	a3,-212(s0)
    800049f0:	fc040613          	addi	a2,s0,-64
    800049f4:	4581                	li	a1,0
    800049f6:	8526                	mv	a0,s1
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	54a080e7          	jalr	1354(ra) # 80002f42 <writei>
    80004a00:	47c1                	li	a5,16
    80004a02:	0af51563          	bne	a0,a5,80004aac <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a06:	04491703          	lh	a4,68(s2)
    80004a0a:	4785                	li	a5,1
    80004a0c:	0af70863          	beq	a4,a5,80004abc <sys_unlink+0x18c>
  iunlockput(dp);
    80004a10:	8526                	mv	a0,s1
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	3e6080e7          	jalr	998(ra) # 80002df8 <iunlockput>
  ip->nlink--;
    80004a1a:	04a95783          	lhu	a5,74(s2)
    80004a1e:	37fd                	addiw	a5,a5,-1
    80004a20:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a24:	854a                	mv	a0,s2
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	0a6080e7          	jalr	166(ra) # 80002acc <iupdate>
  iunlockput(ip);
    80004a2e:	854a                	mv	a0,s2
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	3c8080e7          	jalr	968(ra) # 80002df8 <iunlockput>
  end_op();
    80004a38:	fffff097          	auipc	ra,0xfffff
    80004a3c:	bb0080e7          	jalr	-1104(ra) # 800035e8 <end_op>
  return 0;
    80004a40:	4501                	li	a0,0
    80004a42:	a84d                	j	80004af4 <sys_unlink+0x1c4>
    end_op();
    80004a44:	fffff097          	auipc	ra,0xfffff
    80004a48:	ba4080e7          	jalr	-1116(ra) # 800035e8 <end_op>
    return -1;
    80004a4c:	557d                	li	a0,-1
    80004a4e:	a05d                	j	80004af4 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a50:	00004517          	auipc	a0,0x4
    80004a54:	c6850513          	addi	a0,a0,-920 # 800086b8 <syscalls+0x2f0>
    80004a58:	00001097          	auipc	ra,0x1
    80004a5c:	262080e7          	jalr	610(ra) # 80005cba <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a60:	04c92703          	lw	a4,76(s2)
    80004a64:	02000793          	li	a5,32
    80004a68:	f6e7f9e3          	bgeu	a5,a4,800049da <sys_unlink+0xaa>
    80004a6c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a70:	4741                	li	a4,16
    80004a72:	86ce                	mv	a3,s3
    80004a74:	f1840613          	addi	a2,s0,-232
    80004a78:	4581                	li	a1,0
    80004a7a:	854a                	mv	a0,s2
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	3ce080e7          	jalr	974(ra) # 80002e4a <readi>
    80004a84:	47c1                	li	a5,16
    80004a86:	00f51b63          	bne	a0,a5,80004a9c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a8a:	f1845783          	lhu	a5,-232(s0)
    80004a8e:	e7a1                	bnez	a5,80004ad6 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a90:	29c1                	addiw	s3,s3,16
    80004a92:	04c92783          	lw	a5,76(s2)
    80004a96:	fcf9ede3          	bltu	s3,a5,80004a70 <sys_unlink+0x140>
    80004a9a:	b781                	j	800049da <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a9c:	00004517          	auipc	a0,0x4
    80004aa0:	c3450513          	addi	a0,a0,-972 # 800086d0 <syscalls+0x308>
    80004aa4:	00001097          	auipc	ra,0x1
    80004aa8:	216080e7          	jalr	534(ra) # 80005cba <panic>
    panic("unlink: writei");
    80004aac:	00004517          	auipc	a0,0x4
    80004ab0:	c3c50513          	addi	a0,a0,-964 # 800086e8 <syscalls+0x320>
    80004ab4:	00001097          	auipc	ra,0x1
    80004ab8:	206080e7          	jalr	518(ra) # 80005cba <panic>
    dp->nlink--;
    80004abc:	04a4d783          	lhu	a5,74(s1)
    80004ac0:	37fd                	addiw	a5,a5,-1
    80004ac2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ac6:	8526                	mv	a0,s1
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	004080e7          	jalr	4(ra) # 80002acc <iupdate>
    80004ad0:	b781                	j	80004a10 <sys_unlink+0xe0>
    return -1;
    80004ad2:	557d                	li	a0,-1
    80004ad4:	a005                	j	80004af4 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ad6:	854a                	mv	a0,s2
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	320080e7          	jalr	800(ra) # 80002df8 <iunlockput>
  iunlockput(dp);
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	316080e7          	jalr	790(ra) # 80002df8 <iunlockput>
  end_op();
    80004aea:	fffff097          	auipc	ra,0xfffff
    80004aee:	afe080e7          	jalr	-1282(ra) # 800035e8 <end_op>
  return -1;
    80004af2:	557d                	li	a0,-1
}
    80004af4:	70ae                	ld	ra,232(sp)
    80004af6:	740e                	ld	s0,224(sp)
    80004af8:	64ee                	ld	s1,216(sp)
    80004afa:	694e                	ld	s2,208(sp)
    80004afc:	69ae                	ld	s3,200(sp)
    80004afe:	616d                	addi	sp,sp,240
    80004b00:	8082                	ret

0000000080004b02 <sys_open>:

uint64
sys_open(void)
{
    80004b02:	7131                	addi	sp,sp,-192
    80004b04:	fd06                	sd	ra,184(sp)
    80004b06:	f922                	sd	s0,176(sp)
    80004b08:	f526                	sd	s1,168(sp)
    80004b0a:	f14a                	sd	s2,160(sp)
    80004b0c:	ed4e                	sd	s3,152(sp)
    80004b0e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b10:	08000613          	li	a2,128
    80004b14:	f5040593          	addi	a1,s0,-176
    80004b18:	4501                	li	a0,0
    80004b1a:	ffffd097          	auipc	ra,0xffffd
    80004b1e:	494080e7          	jalr	1172(ra) # 80001fae <argstr>
    return -1;
    80004b22:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b24:	0c054163          	bltz	a0,80004be6 <sys_open+0xe4>
    80004b28:	f4c40593          	addi	a1,s0,-180
    80004b2c:	4505                	li	a0,1
    80004b2e:	ffffd097          	auipc	ra,0xffffd
    80004b32:	43c080e7          	jalr	1084(ra) # 80001f6a <argint>
    80004b36:	0a054863          	bltz	a0,80004be6 <sys_open+0xe4>

  begin_op();
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	a2e080e7          	jalr	-1490(ra) # 80003568 <begin_op>

  if(omode & O_CREATE){
    80004b42:	f4c42783          	lw	a5,-180(s0)
    80004b46:	2007f793          	andi	a5,a5,512
    80004b4a:	cbdd                	beqz	a5,80004c00 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b4c:	4681                	li	a3,0
    80004b4e:	4601                	li	a2,0
    80004b50:	4589                	li	a1,2
    80004b52:	f5040513          	addi	a0,s0,-176
    80004b56:	00000097          	auipc	ra,0x0
    80004b5a:	972080e7          	jalr	-1678(ra) # 800044c8 <create>
    80004b5e:	892a                	mv	s2,a0
    if(ip == 0){
    80004b60:	c959                	beqz	a0,80004bf6 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b62:	04491703          	lh	a4,68(s2)
    80004b66:	478d                	li	a5,3
    80004b68:	00f71763          	bne	a4,a5,80004b76 <sys_open+0x74>
    80004b6c:	04695703          	lhu	a4,70(s2)
    80004b70:	47a5                	li	a5,9
    80004b72:	0ce7ec63          	bltu	a5,a4,80004c4a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b76:	fffff097          	auipc	ra,0xfffff
    80004b7a:	e02080e7          	jalr	-510(ra) # 80003978 <filealloc>
    80004b7e:	89aa                	mv	s3,a0
    80004b80:	10050263          	beqz	a0,80004c84 <sys_open+0x182>
    80004b84:	00000097          	auipc	ra,0x0
    80004b88:	902080e7          	jalr	-1790(ra) # 80004486 <fdalloc>
    80004b8c:	84aa                	mv	s1,a0
    80004b8e:	0e054663          	bltz	a0,80004c7a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b92:	04491703          	lh	a4,68(s2)
    80004b96:	478d                	li	a5,3
    80004b98:	0cf70463          	beq	a4,a5,80004c60 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b9c:	4789                	li	a5,2
    80004b9e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ba2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ba6:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004baa:	f4c42783          	lw	a5,-180(s0)
    80004bae:	0017c713          	xori	a4,a5,1
    80004bb2:	8b05                	andi	a4,a4,1
    80004bb4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bb8:	0037f713          	andi	a4,a5,3
    80004bbc:	00e03733          	snez	a4,a4
    80004bc0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bc4:	4007f793          	andi	a5,a5,1024
    80004bc8:	c791                	beqz	a5,80004bd4 <sys_open+0xd2>
    80004bca:	04491703          	lh	a4,68(s2)
    80004bce:	4789                	li	a5,2
    80004bd0:	08f70f63          	beq	a4,a5,80004c6e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bd4:	854a                	mv	a0,s2
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	082080e7          	jalr	130(ra) # 80002c58 <iunlock>
  end_op();
    80004bde:	fffff097          	auipc	ra,0xfffff
    80004be2:	a0a080e7          	jalr	-1526(ra) # 800035e8 <end_op>

  return fd;
}
    80004be6:	8526                	mv	a0,s1
    80004be8:	70ea                	ld	ra,184(sp)
    80004bea:	744a                	ld	s0,176(sp)
    80004bec:	74aa                	ld	s1,168(sp)
    80004bee:	790a                	ld	s2,160(sp)
    80004bf0:	69ea                	ld	s3,152(sp)
    80004bf2:	6129                	addi	sp,sp,192
    80004bf4:	8082                	ret
      end_op();
    80004bf6:	fffff097          	auipc	ra,0xfffff
    80004bfa:	9f2080e7          	jalr	-1550(ra) # 800035e8 <end_op>
      return -1;
    80004bfe:	b7e5                	j	80004be6 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c00:	f5040513          	addi	a0,s0,-176
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	748080e7          	jalr	1864(ra) # 8000334c <namei>
    80004c0c:	892a                	mv	s2,a0
    80004c0e:	c905                	beqz	a0,80004c3e <sys_open+0x13c>
    ilock(ip);
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	f86080e7          	jalr	-122(ra) # 80002b96 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c18:	04491703          	lh	a4,68(s2)
    80004c1c:	4785                	li	a5,1
    80004c1e:	f4f712e3          	bne	a4,a5,80004b62 <sys_open+0x60>
    80004c22:	f4c42783          	lw	a5,-180(s0)
    80004c26:	dba1                	beqz	a5,80004b76 <sys_open+0x74>
      iunlockput(ip);
    80004c28:	854a                	mv	a0,s2
    80004c2a:	ffffe097          	auipc	ra,0xffffe
    80004c2e:	1ce080e7          	jalr	462(ra) # 80002df8 <iunlockput>
      end_op();
    80004c32:	fffff097          	auipc	ra,0xfffff
    80004c36:	9b6080e7          	jalr	-1610(ra) # 800035e8 <end_op>
      return -1;
    80004c3a:	54fd                	li	s1,-1
    80004c3c:	b76d                	j	80004be6 <sys_open+0xe4>
      end_op();
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	9aa080e7          	jalr	-1622(ra) # 800035e8 <end_op>
      return -1;
    80004c46:	54fd                	li	s1,-1
    80004c48:	bf79                	j	80004be6 <sys_open+0xe4>
    iunlockput(ip);
    80004c4a:	854a                	mv	a0,s2
    80004c4c:	ffffe097          	auipc	ra,0xffffe
    80004c50:	1ac080e7          	jalr	428(ra) # 80002df8 <iunlockput>
    end_op();
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	994080e7          	jalr	-1644(ra) # 800035e8 <end_op>
    return -1;
    80004c5c:	54fd                	li	s1,-1
    80004c5e:	b761                	j	80004be6 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c60:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c64:	04691783          	lh	a5,70(s2)
    80004c68:	02f99223          	sh	a5,36(s3)
    80004c6c:	bf2d                	j	80004ba6 <sys_open+0xa4>
    itrunc(ip);
    80004c6e:	854a                	mv	a0,s2
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	034080e7          	jalr	52(ra) # 80002ca4 <itrunc>
    80004c78:	bfb1                	j	80004bd4 <sys_open+0xd2>
      fileclose(f);
    80004c7a:	854e                	mv	a0,s3
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	db8080e7          	jalr	-584(ra) # 80003a34 <fileclose>
    iunlockput(ip);
    80004c84:	854a                	mv	a0,s2
    80004c86:	ffffe097          	auipc	ra,0xffffe
    80004c8a:	172080e7          	jalr	370(ra) # 80002df8 <iunlockput>
    end_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	95a080e7          	jalr	-1702(ra) # 800035e8 <end_op>
    return -1;
    80004c96:	54fd                	li	s1,-1
    80004c98:	b7b9                	j	80004be6 <sys_open+0xe4>

0000000080004c9a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c9a:	7175                	addi	sp,sp,-144
    80004c9c:	e506                	sd	ra,136(sp)
    80004c9e:	e122                	sd	s0,128(sp)
    80004ca0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	8c6080e7          	jalr	-1850(ra) # 80003568 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004caa:	08000613          	li	a2,128
    80004cae:	f7040593          	addi	a1,s0,-144
    80004cb2:	4501                	li	a0,0
    80004cb4:	ffffd097          	auipc	ra,0xffffd
    80004cb8:	2fa080e7          	jalr	762(ra) # 80001fae <argstr>
    80004cbc:	02054963          	bltz	a0,80004cee <sys_mkdir+0x54>
    80004cc0:	4681                	li	a3,0
    80004cc2:	4601                	li	a2,0
    80004cc4:	4585                	li	a1,1
    80004cc6:	f7040513          	addi	a0,s0,-144
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	7fe080e7          	jalr	2046(ra) # 800044c8 <create>
    80004cd2:	cd11                	beqz	a0,80004cee <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	124080e7          	jalr	292(ra) # 80002df8 <iunlockput>
  end_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	90c080e7          	jalr	-1780(ra) # 800035e8 <end_op>
  return 0;
    80004ce4:	4501                	li	a0,0
}
    80004ce6:	60aa                	ld	ra,136(sp)
    80004ce8:	640a                	ld	s0,128(sp)
    80004cea:	6149                	addi	sp,sp,144
    80004cec:	8082                	ret
    end_op();
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	8fa080e7          	jalr	-1798(ra) # 800035e8 <end_op>
    return -1;
    80004cf6:	557d                	li	a0,-1
    80004cf8:	b7fd                	j	80004ce6 <sys_mkdir+0x4c>

0000000080004cfa <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cfa:	7135                	addi	sp,sp,-160
    80004cfc:	ed06                	sd	ra,152(sp)
    80004cfe:	e922                	sd	s0,144(sp)
    80004d00:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	866080e7          	jalr	-1946(ra) # 80003568 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d0a:	08000613          	li	a2,128
    80004d0e:	f7040593          	addi	a1,s0,-144
    80004d12:	4501                	li	a0,0
    80004d14:	ffffd097          	auipc	ra,0xffffd
    80004d18:	29a080e7          	jalr	666(ra) # 80001fae <argstr>
    80004d1c:	04054a63          	bltz	a0,80004d70 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d20:	f6c40593          	addi	a1,s0,-148
    80004d24:	4505                	li	a0,1
    80004d26:	ffffd097          	auipc	ra,0xffffd
    80004d2a:	244080e7          	jalr	580(ra) # 80001f6a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d2e:	04054163          	bltz	a0,80004d70 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d32:	f6840593          	addi	a1,s0,-152
    80004d36:	4509                	li	a0,2
    80004d38:	ffffd097          	auipc	ra,0xffffd
    80004d3c:	232080e7          	jalr	562(ra) # 80001f6a <argint>
     argint(1, &major) < 0 ||
    80004d40:	02054863          	bltz	a0,80004d70 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d44:	f6841683          	lh	a3,-152(s0)
    80004d48:	f6c41603          	lh	a2,-148(s0)
    80004d4c:	458d                	li	a1,3
    80004d4e:	f7040513          	addi	a0,s0,-144
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	776080e7          	jalr	1910(ra) # 800044c8 <create>
     argint(2, &minor) < 0 ||
    80004d5a:	c919                	beqz	a0,80004d70 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	09c080e7          	jalr	156(ra) # 80002df8 <iunlockput>
  end_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	884080e7          	jalr	-1916(ra) # 800035e8 <end_op>
  return 0;
    80004d6c:	4501                	li	a0,0
    80004d6e:	a031                	j	80004d7a <sys_mknod+0x80>
    end_op();
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	878080e7          	jalr	-1928(ra) # 800035e8 <end_op>
    return -1;
    80004d78:	557d                	li	a0,-1
}
    80004d7a:	60ea                	ld	ra,152(sp)
    80004d7c:	644a                	ld	s0,144(sp)
    80004d7e:	610d                	addi	sp,sp,160
    80004d80:	8082                	ret

0000000080004d82 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d82:	7135                	addi	sp,sp,-160
    80004d84:	ed06                	sd	ra,152(sp)
    80004d86:	e922                	sd	s0,144(sp)
    80004d88:	e526                	sd	s1,136(sp)
    80004d8a:	e14a                	sd	s2,128(sp)
    80004d8c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d8e:	ffffc097          	auipc	ra,0xffffc
    80004d92:	0ba080e7          	jalr	186(ra) # 80000e48 <myproc>
    80004d96:	892a                	mv	s2,a0
  
  begin_op();
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	7d0080e7          	jalr	2000(ra) # 80003568 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004da0:	08000613          	li	a2,128
    80004da4:	f6040593          	addi	a1,s0,-160
    80004da8:	4501                	li	a0,0
    80004daa:	ffffd097          	auipc	ra,0xffffd
    80004dae:	204080e7          	jalr	516(ra) # 80001fae <argstr>
    80004db2:	04054b63          	bltz	a0,80004e08 <sys_chdir+0x86>
    80004db6:	f6040513          	addi	a0,s0,-160
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	592080e7          	jalr	1426(ra) # 8000334c <namei>
    80004dc2:	84aa                	mv	s1,a0
    80004dc4:	c131                	beqz	a0,80004e08 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dc6:	ffffe097          	auipc	ra,0xffffe
    80004dca:	dd0080e7          	jalr	-560(ra) # 80002b96 <ilock>
  if(ip->type != T_DIR){
    80004dce:	04449703          	lh	a4,68(s1)
    80004dd2:	4785                	li	a5,1
    80004dd4:	04f71063          	bne	a4,a5,80004e14 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dd8:	8526                	mv	a0,s1
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	e7e080e7          	jalr	-386(ra) # 80002c58 <iunlock>
  iput(p->cwd);
    80004de2:	15093503          	ld	a0,336(s2)
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	f6a080e7          	jalr	-150(ra) # 80002d50 <iput>
  end_op();
    80004dee:	ffffe097          	auipc	ra,0xffffe
    80004df2:	7fa080e7          	jalr	2042(ra) # 800035e8 <end_op>
  p->cwd = ip;
    80004df6:	14993823          	sd	s1,336(s2)
  return 0;
    80004dfa:	4501                	li	a0,0
}
    80004dfc:	60ea                	ld	ra,152(sp)
    80004dfe:	644a                	ld	s0,144(sp)
    80004e00:	64aa                	ld	s1,136(sp)
    80004e02:	690a                	ld	s2,128(sp)
    80004e04:	610d                	addi	sp,sp,160
    80004e06:	8082                	ret
    end_op();
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	7e0080e7          	jalr	2016(ra) # 800035e8 <end_op>
    return -1;
    80004e10:	557d                	li	a0,-1
    80004e12:	b7ed                	j	80004dfc <sys_chdir+0x7a>
    iunlockput(ip);
    80004e14:	8526                	mv	a0,s1
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	fe2080e7          	jalr	-30(ra) # 80002df8 <iunlockput>
    end_op();
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	7ca080e7          	jalr	1994(ra) # 800035e8 <end_op>
    return -1;
    80004e26:	557d                	li	a0,-1
    80004e28:	bfd1                	j	80004dfc <sys_chdir+0x7a>

0000000080004e2a <sys_exec>:

uint64
sys_exec(void)
{
    80004e2a:	7145                	addi	sp,sp,-464
    80004e2c:	e786                	sd	ra,456(sp)
    80004e2e:	e3a2                	sd	s0,448(sp)
    80004e30:	ff26                	sd	s1,440(sp)
    80004e32:	fb4a                	sd	s2,432(sp)
    80004e34:	f74e                	sd	s3,424(sp)
    80004e36:	f352                	sd	s4,416(sp)
    80004e38:	ef56                	sd	s5,408(sp)
    80004e3a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e3c:	08000613          	li	a2,128
    80004e40:	f4040593          	addi	a1,s0,-192
    80004e44:	4501                	li	a0,0
    80004e46:	ffffd097          	auipc	ra,0xffffd
    80004e4a:	168080e7          	jalr	360(ra) # 80001fae <argstr>
    return -1;
    80004e4e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e50:	0c054a63          	bltz	a0,80004f24 <sys_exec+0xfa>
    80004e54:	e3840593          	addi	a1,s0,-456
    80004e58:	4505                	li	a0,1
    80004e5a:	ffffd097          	auipc	ra,0xffffd
    80004e5e:	132080e7          	jalr	306(ra) # 80001f8c <argaddr>
    80004e62:	0c054163          	bltz	a0,80004f24 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e66:	10000613          	li	a2,256
    80004e6a:	4581                	li	a1,0
    80004e6c:	e4040513          	addi	a0,s0,-448
    80004e70:	ffffb097          	auipc	ra,0xffffb
    80004e74:	308080e7          	jalr	776(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e78:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e7c:	89a6                	mv	s3,s1
    80004e7e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e80:	02000a13          	li	s4,32
    80004e84:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e88:	00391513          	slli	a0,s2,0x3
    80004e8c:	e3040593          	addi	a1,s0,-464
    80004e90:	e3843783          	ld	a5,-456(s0)
    80004e94:	953e                	add	a0,a0,a5
    80004e96:	ffffd097          	auipc	ra,0xffffd
    80004e9a:	03a080e7          	jalr	58(ra) # 80001ed0 <fetchaddr>
    80004e9e:	02054a63          	bltz	a0,80004ed2 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ea2:	e3043783          	ld	a5,-464(s0)
    80004ea6:	c3b9                	beqz	a5,80004eec <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ea8:	ffffb097          	auipc	ra,0xffffb
    80004eac:	270080e7          	jalr	624(ra) # 80000118 <kalloc>
    80004eb0:	85aa                	mv	a1,a0
    80004eb2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004eb6:	cd11                	beqz	a0,80004ed2 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004eb8:	6605                	lui	a2,0x1
    80004eba:	e3043503          	ld	a0,-464(s0)
    80004ebe:	ffffd097          	auipc	ra,0xffffd
    80004ec2:	064080e7          	jalr	100(ra) # 80001f22 <fetchstr>
    80004ec6:	00054663          	bltz	a0,80004ed2 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004eca:	0905                	addi	s2,s2,1
    80004ecc:	09a1                	addi	s3,s3,8
    80004ece:	fb491be3          	bne	s2,s4,80004e84 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ed2:	10048913          	addi	s2,s1,256
    80004ed6:	6088                	ld	a0,0(s1)
    80004ed8:	c529                	beqz	a0,80004f22 <sys_exec+0xf8>
    kfree(argv[i]);
    80004eda:	ffffb097          	auipc	ra,0xffffb
    80004ede:	142080e7          	jalr	322(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ee2:	04a1                	addi	s1,s1,8
    80004ee4:	ff2499e3          	bne	s1,s2,80004ed6 <sys_exec+0xac>
  return -1;
    80004ee8:	597d                	li	s2,-1
    80004eea:	a82d                	j	80004f24 <sys_exec+0xfa>
      argv[i] = 0;
    80004eec:	0a8e                	slli	s5,s5,0x3
    80004eee:	fc040793          	addi	a5,s0,-64
    80004ef2:	9abe                	add	s5,s5,a5
    80004ef4:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ef8:	e4040593          	addi	a1,s0,-448
    80004efc:	f4040513          	addi	a0,s0,-192
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	194080e7          	jalr	404(ra) # 80004094 <exec>
    80004f08:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f0a:	10048993          	addi	s3,s1,256
    80004f0e:	6088                	ld	a0,0(s1)
    80004f10:	c911                	beqz	a0,80004f24 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f12:	ffffb097          	auipc	ra,0xffffb
    80004f16:	10a080e7          	jalr	266(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f1a:	04a1                	addi	s1,s1,8
    80004f1c:	ff3499e3          	bne	s1,s3,80004f0e <sys_exec+0xe4>
    80004f20:	a011                	j	80004f24 <sys_exec+0xfa>
  return -1;
    80004f22:	597d                	li	s2,-1
}
    80004f24:	854a                	mv	a0,s2
    80004f26:	60be                	ld	ra,456(sp)
    80004f28:	641e                	ld	s0,448(sp)
    80004f2a:	74fa                	ld	s1,440(sp)
    80004f2c:	795a                	ld	s2,432(sp)
    80004f2e:	79ba                	ld	s3,424(sp)
    80004f30:	7a1a                	ld	s4,416(sp)
    80004f32:	6afa                	ld	s5,408(sp)
    80004f34:	6179                	addi	sp,sp,464
    80004f36:	8082                	ret

0000000080004f38 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f38:	7139                	addi	sp,sp,-64
    80004f3a:	fc06                	sd	ra,56(sp)
    80004f3c:	f822                	sd	s0,48(sp)
    80004f3e:	f426                	sd	s1,40(sp)
    80004f40:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f42:	ffffc097          	auipc	ra,0xffffc
    80004f46:	f06080e7          	jalr	-250(ra) # 80000e48 <myproc>
    80004f4a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f4c:	fd840593          	addi	a1,s0,-40
    80004f50:	4501                	li	a0,0
    80004f52:	ffffd097          	auipc	ra,0xffffd
    80004f56:	03a080e7          	jalr	58(ra) # 80001f8c <argaddr>
    return -1;
    80004f5a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f5c:	0e054063          	bltz	a0,8000503c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f60:	fc840593          	addi	a1,s0,-56
    80004f64:	fd040513          	addi	a0,s0,-48
    80004f68:	fffff097          	auipc	ra,0xfffff
    80004f6c:	dfc080e7          	jalr	-516(ra) # 80003d64 <pipealloc>
    return -1;
    80004f70:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f72:	0c054563          	bltz	a0,8000503c <sys_pipe+0x104>
  fd0 = -1;
    80004f76:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f7a:	fd043503          	ld	a0,-48(s0)
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	508080e7          	jalr	1288(ra) # 80004486 <fdalloc>
    80004f86:	fca42223          	sw	a0,-60(s0)
    80004f8a:	08054c63          	bltz	a0,80005022 <sys_pipe+0xea>
    80004f8e:	fc843503          	ld	a0,-56(s0)
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	4f4080e7          	jalr	1268(ra) # 80004486 <fdalloc>
    80004f9a:	fca42023          	sw	a0,-64(s0)
    80004f9e:	06054863          	bltz	a0,8000500e <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fa2:	4691                	li	a3,4
    80004fa4:	fc440613          	addi	a2,s0,-60
    80004fa8:	fd843583          	ld	a1,-40(s0)
    80004fac:	68a8                	ld	a0,80(s1)
    80004fae:	ffffc097          	auipc	ra,0xffffc
    80004fb2:	b5c080e7          	jalr	-1188(ra) # 80000b0a <copyout>
    80004fb6:	02054063          	bltz	a0,80004fd6 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fba:	4691                	li	a3,4
    80004fbc:	fc040613          	addi	a2,s0,-64
    80004fc0:	fd843583          	ld	a1,-40(s0)
    80004fc4:	0591                	addi	a1,a1,4
    80004fc6:	68a8                	ld	a0,80(s1)
    80004fc8:	ffffc097          	auipc	ra,0xffffc
    80004fcc:	b42080e7          	jalr	-1214(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fd0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fd2:	06055563          	bgez	a0,8000503c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fd6:	fc442783          	lw	a5,-60(s0)
    80004fda:	07e9                	addi	a5,a5,26
    80004fdc:	078e                	slli	a5,a5,0x3
    80004fde:	97a6                	add	a5,a5,s1
    80004fe0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fe4:	fc042503          	lw	a0,-64(s0)
    80004fe8:	0569                	addi	a0,a0,26
    80004fea:	050e                	slli	a0,a0,0x3
    80004fec:	9526                	add	a0,a0,s1
    80004fee:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004ff2:	fd043503          	ld	a0,-48(s0)
    80004ff6:	fffff097          	auipc	ra,0xfffff
    80004ffa:	a3e080e7          	jalr	-1474(ra) # 80003a34 <fileclose>
    fileclose(wf);
    80004ffe:	fc843503          	ld	a0,-56(s0)
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	a32080e7          	jalr	-1486(ra) # 80003a34 <fileclose>
    return -1;
    8000500a:	57fd                	li	a5,-1
    8000500c:	a805                	j	8000503c <sys_pipe+0x104>
    if(fd0 >= 0)
    8000500e:	fc442783          	lw	a5,-60(s0)
    80005012:	0007c863          	bltz	a5,80005022 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005016:	01a78513          	addi	a0,a5,26
    8000501a:	050e                	slli	a0,a0,0x3
    8000501c:	9526                	add	a0,a0,s1
    8000501e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005022:	fd043503          	ld	a0,-48(s0)
    80005026:	fffff097          	auipc	ra,0xfffff
    8000502a:	a0e080e7          	jalr	-1522(ra) # 80003a34 <fileclose>
    fileclose(wf);
    8000502e:	fc843503          	ld	a0,-56(s0)
    80005032:	fffff097          	auipc	ra,0xfffff
    80005036:	a02080e7          	jalr	-1534(ra) # 80003a34 <fileclose>
    return -1;
    8000503a:	57fd                	li	a5,-1
}
    8000503c:	853e                	mv	a0,a5
    8000503e:	70e2                	ld	ra,56(sp)
    80005040:	7442                	ld	s0,48(sp)
    80005042:	74a2                	ld	s1,40(sp)
    80005044:	6121                	addi	sp,sp,64
    80005046:	8082                	ret
	...

0000000080005050 <kernelvec>:
    80005050:	7111                	addi	sp,sp,-256
    80005052:	e006                	sd	ra,0(sp)
    80005054:	e40a                	sd	sp,8(sp)
    80005056:	e80e                	sd	gp,16(sp)
    80005058:	ec12                	sd	tp,24(sp)
    8000505a:	f016                	sd	t0,32(sp)
    8000505c:	f41a                	sd	t1,40(sp)
    8000505e:	f81e                	sd	t2,48(sp)
    80005060:	fc22                	sd	s0,56(sp)
    80005062:	e0a6                	sd	s1,64(sp)
    80005064:	e4aa                	sd	a0,72(sp)
    80005066:	e8ae                	sd	a1,80(sp)
    80005068:	ecb2                	sd	a2,88(sp)
    8000506a:	f0b6                	sd	a3,96(sp)
    8000506c:	f4ba                	sd	a4,104(sp)
    8000506e:	f8be                	sd	a5,112(sp)
    80005070:	fcc2                	sd	a6,120(sp)
    80005072:	e146                	sd	a7,128(sp)
    80005074:	e54a                	sd	s2,136(sp)
    80005076:	e94e                	sd	s3,144(sp)
    80005078:	ed52                	sd	s4,152(sp)
    8000507a:	f156                	sd	s5,160(sp)
    8000507c:	f55a                	sd	s6,168(sp)
    8000507e:	f95e                	sd	s7,176(sp)
    80005080:	fd62                	sd	s8,184(sp)
    80005082:	e1e6                	sd	s9,192(sp)
    80005084:	e5ea                	sd	s10,200(sp)
    80005086:	e9ee                	sd	s11,208(sp)
    80005088:	edf2                	sd	t3,216(sp)
    8000508a:	f1f6                	sd	t4,224(sp)
    8000508c:	f5fa                	sd	t5,232(sp)
    8000508e:	f9fe                	sd	t6,240(sp)
    80005090:	d0dfc0ef          	jal	ra,80001d9c <kerneltrap>
    80005094:	6082                	ld	ra,0(sp)
    80005096:	6122                	ld	sp,8(sp)
    80005098:	61c2                	ld	gp,16(sp)
    8000509a:	7282                	ld	t0,32(sp)
    8000509c:	7322                	ld	t1,40(sp)
    8000509e:	73c2                	ld	t2,48(sp)
    800050a0:	7462                	ld	s0,56(sp)
    800050a2:	6486                	ld	s1,64(sp)
    800050a4:	6526                	ld	a0,72(sp)
    800050a6:	65c6                	ld	a1,80(sp)
    800050a8:	6666                	ld	a2,88(sp)
    800050aa:	7686                	ld	a3,96(sp)
    800050ac:	7726                	ld	a4,104(sp)
    800050ae:	77c6                	ld	a5,112(sp)
    800050b0:	7866                	ld	a6,120(sp)
    800050b2:	688a                	ld	a7,128(sp)
    800050b4:	692a                	ld	s2,136(sp)
    800050b6:	69ca                	ld	s3,144(sp)
    800050b8:	6a6a                	ld	s4,152(sp)
    800050ba:	7a8a                	ld	s5,160(sp)
    800050bc:	7b2a                	ld	s6,168(sp)
    800050be:	7bca                	ld	s7,176(sp)
    800050c0:	7c6a                	ld	s8,184(sp)
    800050c2:	6c8e                	ld	s9,192(sp)
    800050c4:	6d2e                	ld	s10,200(sp)
    800050c6:	6dce                	ld	s11,208(sp)
    800050c8:	6e6e                	ld	t3,216(sp)
    800050ca:	7e8e                	ld	t4,224(sp)
    800050cc:	7f2e                	ld	t5,232(sp)
    800050ce:	7fce                	ld	t6,240(sp)
    800050d0:	6111                	addi	sp,sp,256
    800050d2:	10200073          	sret
    800050d6:	00000013          	nop
    800050da:	00000013          	nop
    800050de:	0001                	nop

00000000800050e0 <timervec>:
    800050e0:	34051573          	csrrw	a0,mscratch,a0
    800050e4:	e10c                	sd	a1,0(a0)
    800050e6:	e510                	sd	a2,8(a0)
    800050e8:	e914                	sd	a3,16(a0)
    800050ea:	6d0c                	ld	a1,24(a0)
    800050ec:	7110                	ld	a2,32(a0)
    800050ee:	6194                	ld	a3,0(a1)
    800050f0:	96b2                	add	a3,a3,a2
    800050f2:	e194                	sd	a3,0(a1)
    800050f4:	4589                	li	a1,2
    800050f6:	14459073          	csrw	sip,a1
    800050fa:	6914                	ld	a3,16(a0)
    800050fc:	6510                	ld	a2,8(a0)
    800050fe:	610c                	ld	a1,0(a0)
    80005100:	34051573          	csrrw	a0,mscratch,a0
    80005104:	30200073          	mret
	...

000000008000510a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000510a:	1141                	addi	sp,sp,-16
    8000510c:	e422                	sd	s0,8(sp)
    8000510e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005110:	0c0007b7          	lui	a5,0xc000
    80005114:	4705                	li	a4,1
    80005116:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005118:	c3d8                	sw	a4,4(a5)
}
    8000511a:	6422                	ld	s0,8(sp)
    8000511c:	0141                	addi	sp,sp,16
    8000511e:	8082                	ret

0000000080005120 <plicinithart>:

void
plicinithart(void)
{
    80005120:	1141                	addi	sp,sp,-16
    80005122:	e406                	sd	ra,8(sp)
    80005124:	e022                	sd	s0,0(sp)
    80005126:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005128:	ffffc097          	auipc	ra,0xffffc
    8000512c:	cf4080e7          	jalr	-780(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005130:	0085171b          	slliw	a4,a0,0x8
    80005134:	0c0027b7          	lui	a5,0xc002
    80005138:	97ba                	add	a5,a5,a4
    8000513a:	40200713          	li	a4,1026
    8000513e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005142:	00d5151b          	slliw	a0,a0,0xd
    80005146:	0c2017b7          	lui	a5,0xc201
    8000514a:	953e                	add	a0,a0,a5
    8000514c:	00052023          	sw	zero,0(a0)
}
    80005150:	60a2                	ld	ra,8(sp)
    80005152:	6402                	ld	s0,0(sp)
    80005154:	0141                	addi	sp,sp,16
    80005156:	8082                	ret

0000000080005158 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005158:	1141                	addi	sp,sp,-16
    8000515a:	e406                	sd	ra,8(sp)
    8000515c:	e022                	sd	s0,0(sp)
    8000515e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005160:	ffffc097          	auipc	ra,0xffffc
    80005164:	cbc080e7          	jalr	-836(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005168:	00d5179b          	slliw	a5,a0,0xd
    8000516c:	0c201537          	lui	a0,0xc201
    80005170:	953e                	add	a0,a0,a5
  return irq;
}
    80005172:	4148                	lw	a0,4(a0)
    80005174:	60a2                	ld	ra,8(sp)
    80005176:	6402                	ld	s0,0(sp)
    80005178:	0141                	addi	sp,sp,16
    8000517a:	8082                	ret

000000008000517c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000517c:	1101                	addi	sp,sp,-32
    8000517e:	ec06                	sd	ra,24(sp)
    80005180:	e822                	sd	s0,16(sp)
    80005182:	e426                	sd	s1,8(sp)
    80005184:	1000                	addi	s0,sp,32
    80005186:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005188:	ffffc097          	auipc	ra,0xffffc
    8000518c:	c94080e7          	jalr	-876(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005190:	00d5151b          	slliw	a0,a0,0xd
    80005194:	0c2017b7          	lui	a5,0xc201
    80005198:	97aa                	add	a5,a5,a0
    8000519a:	c3c4                	sw	s1,4(a5)
}
    8000519c:	60e2                	ld	ra,24(sp)
    8000519e:	6442                	ld	s0,16(sp)
    800051a0:	64a2                	ld	s1,8(sp)
    800051a2:	6105                	addi	sp,sp,32
    800051a4:	8082                	ret

00000000800051a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051a6:	1141                	addi	sp,sp,-16
    800051a8:	e406                	sd	ra,8(sp)
    800051aa:	e022                	sd	s0,0(sp)
    800051ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ae:	479d                	li	a5,7
    800051b0:	06a7c963          	blt	a5,a0,80005222 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051b4:	0001a797          	auipc	a5,0x1a
    800051b8:	e4c78793          	addi	a5,a5,-436 # 8001f000 <disk>
    800051bc:	00a78733          	add	a4,a5,a0
    800051c0:	6789                	lui	a5,0x2
    800051c2:	97ba                	add	a5,a5,a4
    800051c4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051c8:	e7ad                	bnez	a5,80005232 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051ca:	00451793          	slli	a5,a0,0x4
    800051ce:	0001c717          	auipc	a4,0x1c
    800051d2:	e3270713          	addi	a4,a4,-462 # 80021000 <disk+0x2000>
    800051d6:	6314                	ld	a3,0(a4)
    800051d8:	96be                	add	a3,a3,a5
    800051da:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051de:	6314                	ld	a3,0(a4)
    800051e0:	96be                	add	a3,a3,a5
    800051e2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051e6:	6314                	ld	a3,0(a4)
    800051e8:	96be                	add	a3,a3,a5
    800051ea:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051ee:	6318                	ld	a4,0(a4)
    800051f0:	97ba                	add	a5,a5,a4
    800051f2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800051f6:	0001a797          	auipc	a5,0x1a
    800051fa:	e0a78793          	addi	a5,a5,-502 # 8001f000 <disk>
    800051fe:	97aa                	add	a5,a5,a0
    80005200:	6509                	lui	a0,0x2
    80005202:	953e                	add	a0,a0,a5
    80005204:	4785                	li	a5,1
    80005206:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000520a:	0001c517          	auipc	a0,0x1c
    8000520e:	e0e50513          	addi	a0,a0,-498 # 80021018 <disk+0x2018>
    80005212:	ffffc097          	auipc	ra,0xffffc
    80005216:	48c080e7          	jalr	1164(ra) # 8000169e <wakeup>
}
    8000521a:	60a2                	ld	ra,8(sp)
    8000521c:	6402                	ld	s0,0(sp)
    8000521e:	0141                	addi	sp,sp,16
    80005220:	8082                	ret
    panic("free_desc 1");
    80005222:	00003517          	auipc	a0,0x3
    80005226:	4d650513          	addi	a0,a0,1238 # 800086f8 <syscalls+0x330>
    8000522a:	00001097          	auipc	ra,0x1
    8000522e:	a90080e7          	jalr	-1392(ra) # 80005cba <panic>
    panic("free_desc 2");
    80005232:	00003517          	auipc	a0,0x3
    80005236:	4d650513          	addi	a0,a0,1238 # 80008708 <syscalls+0x340>
    8000523a:	00001097          	auipc	ra,0x1
    8000523e:	a80080e7          	jalr	-1408(ra) # 80005cba <panic>

0000000080005242 <virtio_disk_init>:
{
    80005242:	1101                	addi	sp,sp,-32
    80005244:	ec06                	sd	ra,24(sp)
    80005246:	e822                	sd	s0,16(sp)
    80005248:	e426                	sd	s1,8(sp)
    8000524a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000524c:	00003597          	auipc	a1,0x3
    80005250:	4cc58593          	addi	a1,a1,1228 # 80008718 <syscalls+0x350>
    80005254:	0001c517          	auipc	a0,0x1c
    80005258:	ed450513          	addi	a0,a0,-300 # 80021128 <disk+0x2128>
    8000525c:	00001097          	auipc	ra,0x1
    80005260:	eee080e7          	jalr	-274(ra) # 8000614a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005264:	100017b7          	lui	a5,0x10001
    80005268:	4398                	lw	a4,0(a5)
    8000526a:	2701                	sext.w	a4,a4
    8000526c:	747277b7          	lui	a5,0x74727
    80005270:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005274:	0ef71163          	bne	a4,a5,80005356 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005278:	100017b7          	lui	a5,0x10001
    8000527c:	43dc                	lw	a5,4(a5)
    8000527e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005280:	4705                	li	a4,1
    80005282:	0ce79a63          	bne	a5,a4,80005356 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005286:	100017b7          	lui	a5,0x10001
    8000528a:	479c                	lw	a5,8(a5)
    8000528c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000528e:	4709                	li	a4,2
    80005290:	0ce79363          	bne	a5,a4,80005356 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005294:	100017b7          	lui	a5,0x10001
    80005298:	47d8                	lw	a4,12(a5)
    8000529a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000529c:	554d47b7          	lui	a5,0x554d4
    800052a0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052a4:	0af71963          	bne	a4,a5,80005356 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052a8:	100017b7          	lui	a5,0x10001
    800052ac:	4705                	li	a4,1
    800052ae:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b0:	470d                	li	a4,3
    800052b2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052b4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052b6:	c7ffe737          	lui	a4,0xc7ffe
    800052ba:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd451f>
    800052be:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052c0:	2701                	sext.w	a4,a4
    800052c2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c4:	472d                	li	a4,11
    800052c6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c8:	473d                	li	a4,15
    800052ca:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052cc:	6705                	lui	a4,0x1
    800052ce:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052d0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052d4:	5bdc                	lw	a5,52(a5)
    800052d6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052d8:	c7d9                	beqz	a5,80005366 <virtio_disk_init+0x124>
  if(max < NUM)
    800052da:	471d                	li	a4,7
    800052dc:	08f77d63          	bgeu	a4,a5,80005376 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052e0:	100014b7          	lui	s1,0x10001
    800052e4:	47a1                	li	a5,8
    800052e6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052e8:	6609                	lui	a2,0x2
    800052ea:	4581                	li	a1,0
    800052ec:	0001a517          	auipc	a0,0x1a
    800052f0:	d1450513          	addi	a0,a0,-748 # 8001f000 <disk>
    800052f4:	ffffb097          	auipc	ra,0xffffb
    800052f8:	e84080e7          	jalr	-380(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800052fc:	0001a717          	auipc	a4,0x1a
    80005300:	d0470713          	addi	a4,a4,-764 # 8001f000 <disk>
    80005304:	00c75793          	srli	a5,a4,0xc
    80005308:	2781                	sext.w	a5,a5
    8000530a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000530c:	0001c797          	auipc	a5,0x1c
    80005310:	cf478793          	addi	a5,a5,-780 # 80021000 <disk+0x2000>
    80005314:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005316:	0001a717          	auipc	a4,0x1a
    8000531a:	d6a70713          	addi	a4,a4,-662 # 8001f080 <disk+0x80>
    8000531e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005320:	0001b717          	auipc	a4,0x1b
    80005324:	ce070713          	addi	a4,a4,-800 # 80020000 <disk+0x1000>
    80005328:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000532a:	4705                	li	a4,1
    8000532c:	00e78c23          	sb	a4,24(a5)
    80005330:	00e78ca3          	sb	a4,25(a5)
    80005334:	00e78d23          	sb	a4,26(a5)
    80005338:	00e78da3          	sb	a4,27(a5)
    8000533c:	00e78e23          	sb	a4,28(a5)
    80005340:	00e78ea3          	sb	a4,29(a5)
    80005344:	00e78f23          	sb	a4,30(a5)
    80005348:	00e78fa3          	sb	a4,31(a5)
}
    8000534c:	60e2                	ld	ra,24(sp)
    8000534e:	6442                	ld	s0,16(sp)
    80005350:	64a2                	ld	s1,8(sp)
    80005352:	6105                	addi	sp,sp,32
    80005354:	8082                	ret
    panic("could not find virtio disk");
    80005356:	00003517          	auipc	a0,0x3
    8000535a:	3d250513          	addi	a0,a0,978 # 80008728 <syscalls+0x360>
    8000535e:	00001097          	auipc	ra,0x1
    80005362:	95c080e7          	jalr	-1700(ra) # 80005cba <panic>
    panic("virtio disk has no queue 0");
    80005366:	00003517          	auipc	a0,0x3
    8000536a:	3e250513          	addi	a0,a0,994 # 80008748 <syscalls+0x380>
    8000536e:	00001097          	auipc	ra,0x1
    80005372:	94c080e7          	jalr	-1716(ra) # 80005cba <panic>
    panic("virtio disk max queue too short");
    80005376:	00003517          	auipc	a0,0x3
    8000537a:	3f250513          	addi	a0,a0,1010 # 80008768 <syscalls+0x3a0>
    8000537e:	00001097          	auipc	ra,0x1
    80005382:	93c080e7          	jalr	-1732(ra) # 80005cba <panic>

0000000080005386 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005386:	7159                	addi	sp,sp,-112
    80005388:	f486                	sd	ra,104(sp)
    8000538a:	f0a2                	sd	s0,96(sp)
    8000538c:	eca6                	sd	s1,88(sp)
    8000538e:	e8ca                	sd	s2,80(sp)
    80005390:	e4ce                	sd	s3,72(sp)
    80005392:	e0d2                	sd	s4,64(sp)
    80005394:	fc56                	sd	s5,56(sp)
    80005396:	f85a                	sd	s6,48(sp)
    80005398:	f45e                	sd	s7,40(sp)
    8000539a:	f062                	sd	s8,32(sp)
    8000539c:	ec66                	sd	s9,24(sp)
    8000539e:	e86a                	sd	s10,16(sp)
    800053a0:	1880                	addi	s0,sp,112
    800053a2:	892a                	mv	s2,a0
    800053a4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053a6:	00c52c83          	lw	s9,12(a0)
    800053aa:	001c9c9b          	slliw	s9,s9,0x1
    800053ae:	1c82                	slli	s9,s9,0x20
    800053b0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053b4:	0001c517          	auipc	a0,0x1c
    800053b8:	d7450513          	addi	a0,a0,-652 # 80021128 <disk+0x2128>
    800053bc:	00001097          	auipc	ra,0x1
    800053c0:	e1e080e7          	jalr	-482(ra) # 800061da <acquire>
  for(int i = 0; i < 3; i++){
    800053c4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053c6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800053c8:	0001ab97          	auipc	s7,0x1a
    800053cc:	c38b8b93          	addi	s7,s7,-968 # 8001f000 <disk>
    800053d0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053d2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053d4:	8a4e                	mv	s4,s3
    800053d6:	a051                	j	8000545a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800053d8:	00fb86b3          	add	a3,s7,a5
    800053dc:	96da                	add	a3,a3,s6
    800053de:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800053e2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800053e4:	0207c563          	bltz	a5,8000540e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053e8:	2485                	addiw	s1,s1,1
    800053ea:	0711                	addi	a4,a4,4
    800053ec:	25548063          	beq	s1,s5,8000562c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800053f0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800053f2:	0001c697          	auipc	a3,0x1c
    800053f6:	c2668693          	addi	a3,a3,-986 # 80021018 <disk+0x2018>
    800053fa:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800053fc:	0006c583          	lbu	a1,0(a3)
    80005400:	fde1                	bnez	a1,800053d8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005402:	2785                	addiw	a5,a5,1
    80005404:	0685                	addi	a3,a3,1
    80005406:	ff879be3          	bne	a5,s8,800053fc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000540a:	57fd                	li	a5,-1
    8000540c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000540e:	02905a63          	blez	s1,80005442 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005412:	f9042503          	lw	a0,-112(s0)
    80005416:	00000097          	auipc	ra,0x0
    8000541a:	d90080e7          	jalr	-624(ra) # 800051a6 <free_desc>
      for(int j = 0; j < i; j++)
    8000541e:	4785                	li	a5,1
    80005420:	0297d163          	bge	a5,s1,80005442 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005424:	f9442503          	lw	a0,-108(s0)
    80005428:	00000097          	auipc	ra,0x0
    8000542c:	d7e080e7          	jalr	-642(ra) # 800051a6 <free_desc>
      for(int j = 0; j < i; j++)
    80005430:	4789                	li	a5,2
    80005432:	0097d863          	bge	a5,s1,80005442 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005436:	f9842503          	lw	a0,-104(s0)
    8000543a:	00000097          	auipc	ra,0x0
    8000543e:	d6c080e7          	jalr	-660(ra) # 800051a6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005442:	0001c597          	auipc	a1,0x1c
    80005446:	ce658593          	addi	a1,a1,-794 # 80021128 <disk+0x2128>
    8000544a:	0001c517          	auipc	a0,0x1c
    8000544e:	bce50513          	addi	a0,a0,-1074 # 80021018 <disk+0x2018>
    80005452:	ffffc097          	auipc	ra,0xffffc
    80005456:	0c0080e7          	jalr	192(ra) # 80001512 <sleep>
  for(int i = 0; i < 3; i++){
    8000545a:	f9040713          	addi	a4,s0,-112
    8000545e:	84ce                	mv	s1,s3
    80005460:	bf41                	j	800053f0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005462:	20058713          	addi	a4,a1,512
    80005466:	00471693          	slli	a3,a4,0x4
    8000546a:	0001a717          	auipc	a4,0x1a
    8000546e:	b9670713          	addi	a4,a4,-1130 # 8001f000 <disk>
    80005472:	9736                	add	a4,a4,a3
    80005474:	4685                	li	a3,1
    80005476:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000547a:	20058713          	addi	a4,a1,512
    8000547e:	00471693          	slli	a3,a4,0x4
    80005482:	0001a717          	auipc	a4,0x1a
    80005486:	b7e70713          	addi	a4,a4,-1154 # 8001f000 <disk>
    8000548a:	9736                	add	a4,a4,a3
    8000548c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005490:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005494:	7679                	lui	a2,0xffffe
    80005496:	963e                	add	a2,a2,a5
    80005498:	0001c697          	auipc	a3,0x1c
    8000549c:	b6868693          	addi	a3,a3,-1176 # 80021000 <disk+0x2000>
    800054a0:	6298                	ld	a4,0(a3)
    800054a2:	9732                	add	a4,a4,a2
    800054a4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054a6:	6298                	ld	a4,0(a3)
    800054a8:	9732                	add	a4,a4,a2
    800054aa:	4541                	li	a0,16
    800054ac:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054ae:	6298                	ld	a4,0(a3)
    800054b0:	9732                	add	a4,a4,a2
    800054b2:	4505                	li	a0,1
    800054b4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054b8:	f9442703          	lw	a4,-108(s0)
    800054bc:	6288                	ld	a0,0(a3)
    800054be:	962a                	add	a2,a2,a0
    800054c0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd3dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054c4:	0712                	slli	a4,a4,0x4
    800054c6:	6290                	ld	a2,0(a3)
    800054c8:	963a                	add	a2,a2,a4
    800054ca:	05890513          	addi	a0,s2,88
    800054ce:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800054d0:	6294                	ld	a3,0(a3)
    800054d2:	96ba                	add	a3,a3,a4
    800054d4:	40000613          	li	a2,1024
    800054d8:	c690                	sw	a2,8(a3)
  if(write)
    800054da:	140d0063          	beqz	s10,8000561a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054de:	0001c697          	auipc	a3,0x1c
    800054e2:	b226b683          	ld	a3,-1246(a3) # 80021000 <disk+0x2000>
    800054e6:	96ba                	add	a3,a3,a4
    800054e8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054ec:	0001a817          	auipc	a6,0x1a
    800054f0:	b1480813          	addi	a6,a6,-1260 # 8001f000 <disk>
    800054f4:	0001c517          	auipc	a0,0x1c
    800054f8:	b0c50513          	addi	a0,a0,-1268 # 80021000 <disk+0x2000>
    800054fc:	6114                	ld	a3,0(a0)
    800054fe:	96ba                	add	a3,a3,a4
    80005500:	00c6d603          	lhu	a2,12(a3)
    80005504:	00166613          	ori	a2,a2,1
    80005508:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000550c:	f9842683          	lw	a3,-104(s0)
    80005510:	6110                	ld	a2,0(a0)
    80005512:	9732                	add	a4,a4,a2
    80005514:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005518:	20058613          	addi	a2,a1,512
    8000551c:	0612                	slli	a2,a2,0x4
    8000551e:	9642                	add	a2,a2,a6
    80005520:	577d                	li	a4,-1
    80005522:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005526:	00469713          	slli	a4,a3,0x4
    8000552a:	6114                	ld	a3,0(a0)
    8000552c:	96ba                	add	a3,a3,a4
    8000552e:	03078793          	addi	a5,a5,48
    80005532:	97c2                	add	a5,a5,a6
    80005534:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005536:	611c                	ld	a5,0(a0)
    80005538:	97ba                	add	a5,a5,a4
    8000553a:	4685                	li	a3,1
    8000553c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000553e:	611c                	ld	a5,0(a0)
    80005540:	97ba                	add	a5,a5,a4
    80005542:	4809                	li	a6,2
    80005544:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005548:	611c                	ld	a5,0(a0)
    8000554a:	973e                	add	a4,a4,a5
    8000554c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005550:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005554:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005558:	6518                	ld	a4,8(a0)
    8000555a:	00275783          	lhu	a5,2(a4)
    8000555e:	8b9d                	andi	a5,a5,7
    80005560:	0786                	slli	a5,a5,0x1
    80005562:	97ba                	add	a5,a5,a4
    80005564:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005568:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000556c:	6518                	ld	a4,8(a0)
    8000556e:	00275783          	lhu	a5,2(a4)
    80005572:	2785                	addiw	a5,a5,1
    80005574:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005578:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000557c:	100017b7          	lui	a5,0x10001
    80005580:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005584:	00492703          	lw	a4,4(s2)
    80005588:	4785                	li	a5,1
    8000558a:	02f71163          	bne	a4,a5,800055ac <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000558e:	0001c997          	auipc	s3,0x1c
    80005592:	b9a98993          	addi	s3,s3,-1126 # 80021128 <disk+0x2128>
  while(b->disk == 1) {
    80005596:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005598:	85ce                	mv	a1,s3
    8000559a:	854a                	mv	a0,s2
    8000559c:	ffffc097          	auipc	ra,0xffffc
    800055a0:	f76080e7          	jalr	-138(ra) # 80001512 <sleep>
  while(b->disk == 1) {
    800055a4:	00492783          	lw	a5,4(s2)
    800055a8:	fe9788e3          	beq	a5,s1,80005598 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055ac:	f9042903          	lw	s2,-112(s0)
    800055b0:	20090793          	addi	a5,s2,512
    800055b4:	00479713          	slli	a4,a5,0x4
    800055b8:	0001a797          	auipc	a5,0x1a
    800055bc:	a4878793          	addi	a5,a5,-1464 # 8001f000 <disk>
    800055c0:	97ba                	add	a5,a5,a4
    800055c2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055c6:	0001c997          	auipc	s3,0x1c
    800055ca:	a3a98993          	addi	s3,s3,-1478 # 80021000 <disk+0x2000>
    800055ce:	00491713          	slli	a4,s2,0x4
    800055d2:	0009b783          	ld	a5,0(s3)
    800055d6:	97ba                	add	a5,a5,a4
    800055d8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055dc:	854a                	mv	a0,s2
    800055de:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055e2:	00000097          	auipc	ra,0x0
    800055e6:	bc4080e7          	jalr	-1084(ra) # 800051a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055ea:	8885                	andi	s1,s1,1
    800055ec:	f0ed                	bnez	s1,800055ce <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055ee:	0001c517          	auipc	a0,0x1c
    800055f2:	b3a50513          	addi	a0,a0,-1222 # 80021128 <disk+0x2128>
    800055f6:	00001097          	auipc	ra,0x1
    800055fa:	c98080e7          	jalr	-872(ra) # 8000628e <release>
}
    800055fe:	70a6                	ld	ra,104(sp)
    80005600:	7406                	ld	s0,96(sp)
    80005602:	64e6                	ld	s1,88(sp)
    80005604:	6946                	ld	s2,80(sp)
    80005606:	69a6                	ld	s3,72(sp)
    80005608:	6a06                	ld	s4,64(sp)
    8000560a:	7ae2                	ld	s5,56(sp)
    8000560c:	7b42                	ld	s6,48(sp)
    8000560e:	7ba2                	ld	s7,40(sp)
    80005610:	7c02                	ld	s8,32(sp)
    80005612:	6ce2                	ld	s9,24(sp)
    80005614:	6d42                	ld	s10,16(sp)
    80005616:	6165                	addi	sp,sp,112
    80005618:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000561a:	0001c697          	auipc	a3,0x1c
    8000561e:	9e66b683          	ld	a3,-1562(a3) # 80021000 <disk+0x2000>
    80005622:	96ba                	add	a3,a3,a4
    80005624:	4609                	li	a2,2
    80005626:	00c69623          	sh	a2,12(a3)
    8000562a:	b5c9                	j	800054ec <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000562c:	f9042583          	lw	a1,-112(s0)
    80005630:	20058793          	addi	a5,a1,512
    80005634:	0792                	slli	a5,a5,0x4
    80005636:	0001a517          	auipc	a0,0x1a
    8000563a:	a7250513          	addi	a0,a0,-1422 # 8001f0a8 <disk+0xa8>
    8000563e:	953e                	add	a0,a0,a5
  if(write)
    80005640:	e20d11e3          	bnez	s10,80005462 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005644:	20058713          	addi	a4,a1,512
    80005648:	00471693          	slli	a3,a4,0x4
    8000564c:	0001a717          	auipc	a4,0x1a
    80005650:	9b470713          	addi	a4,a4,-1612 # 8001f000 <disk>
    80005654:	9736                	add	a4,a4,a3
    80005656:	0a072423          	sw	zero,168(a4)
    8000565a:	b505                	j	8000547a <virtio_disk_rw+0xf4>

000000008000565c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000565c:	1101                	addi	sp,sp,-32
    8000565e:	ec06                	sd	ra,24(sp)
    80005660:	e822                	sd	s0,16(sp)
    80005662:	e426                	sd	s1,8(sp)
    80005664:	e04a                	sd	s2,0(sp)
    80005666:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005668:	0001c517          	auipc	a0,0x1c
    8000566c:	ac050513          	addi	a0,a0,-1344 # 80021128 <disk+0x2128>
    80005670:	00001097          	auipc	ra,0x1
    80005674:	b6a080e7          	jalr	-1174(ra) # 800061da <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005678:	10001737          	lui	a4,0x10001
    8000567c:	533c                	lw	a5,96(a4)
    8000567e:	8b8d                	andi	a5,a5,3
    80005680:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005682:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005686:	0001c797          	auipc	a5,0x1c
    8000568a:	97a78793          	addi	a5,a5,-1670 # 80021000 <disk+0x2000>
    8000568e:	6b94                	ld	a3,16(a5)
    80005690:	0207d703          	lhu	a4,32(a5)
    80005694:	0026d783          	lhu	a5,2(a3)
    80005698:	06f70163          	beq	a4,a5,800056fa <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000569c:	0001a917          	auipc	s2,0x1a
    800056a0:	96490913          	addi	s2,s2,-1692 # 8001f000 <disk>
    800056a4:	0001c497          	auipc	s1,0x1c
    800056a8:	95c48493          	addi	s1,s1,-1700 # 80021000 <disk+0x2000>
    __sync_synchronize();
    800056ac:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056b0:	6898                	ld	a4,16(s1)
    800056b2:	0204d783          	lhu	a5,32(s1)
    800056b6:	8b9d                	andi	a5,a5,7
    800056b8:	078e                	slli	a5,a5,0x3
    800056ba:	97ba                	add	a5,a5,a4
    800056bc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056be:	20078713          	addi	a4,a5,512
    800056c2:	0712                	slli	a4,a4,0x4
    800056c4:	974a                	add	a4,a4,s2
    800056c6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056ca:	e731                	bnez	a4,80005716 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056cc:	20078793          	addi	a5,a5,512
    800056d0:	0792                	slli	a5,a5,0x4
    800056d2:	97ca                	add	a5,a5,s2
    800056d4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056d6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056da:	ffffc097          	auipc	ra,0xffffc
    800056de:	fc4080e7          	jalr	-60(ra) # 8000169e <wakeup>

    disk.used_idx += 1;
    800056e2:	0204d783          	lhu	a5,32(s1)
    800056e6:	2785                	addiw	a5,a5,1
    800056e8:	17c2                	slli	a5,a5,0x30
    800056ea:	93c1                	srli	a5,a5,0x30
    800056ec:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056f0:	6898                	ld	a4,16(s1)
    800056f2:	00275703          	lhu	a4,2(a4)
    800056f6:	faf71be3          	bne	a4,a5,800056ac <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056fa:	0001c517          	auipc	a0,0x1c
    800056fe:	a2e50513          	addi	a0,a0,-1490 # 80021128 <disk+0x2128>
    80005702:	00001097          	auipc	ra,0x1
    80005706:	b8c080e7          	jalr	-1140(ra) # 8000628e <release>
}
    8000570a:	60e2                	ld	ra,24(sp)
    8000570c:	6442                	ld	s0,16(sp)
    8000570e:	64a2                	ld	s1,8(sp)
    80005710:	6902                	ld	s2,0(sp)
    80005712:	6105                	addi	sp,sp,32
    80005714:	8082                	ret
      panic("virtio_disk_intr status");
    80005716:	00003517          	auipc	a0,0x3
    8000571a:	07250513          	addi	a0,a0,114 # 80008788 <syscalls+0x3c0>
    8000571e:	00000097          	auipc	ra,0x0
    80005722:	59c080e7          	jalr	1436(ra) # 80005cba <panic>

0000000080005726 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005726:	1141                	addi	sp,sp,-16
    80005728:	e422                	sd	s0,8(sp)
    8000572a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000572c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005730:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005734:	0037979b          	slliw	a5,a5,0x3
    80005738:	02004737          	lui	a4,0x2004
    8000573c:	97ba                	add	a5,a5,a4
    8000573e:	0200c737          	lui	a4,0x200c
    80005742:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005746:	000f4637          	lui	a2,0xf4
    8000574a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000574e:	95b2                	add	a1,a1,a2
    80005750:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005752:	00269713          	slli	a4,a3,0x2
    80005756:	9736                	add	a4,a4,a3
    80005758:	00371693          	slli	a3,a4,0x3
    8000575c:	0001d717          	auipc	a4,0x1d
    80005760:	8a470713          	addi	a4,a4,-1884 # 80022000 <timer_scratch>
    80005764:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005766:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005768:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000576a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000576e:	00000797          	auipc	a5,0x0
    80005772:	97278793          	addi	a5,a5,-1678 # 800050e0 <timervec>
    80005776:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000577a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000577e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005782:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005786:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000578a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000578e:	30479073          	csrw	mie,a5
}
    80005792:	6422                	ld	s0,8(sp)
    80005794:	0141                	addi	sp,sp,16
    80005796:	8082                	ret

0000000080005798 <start>:
{
    80005798:	1141                	addi	sp,sp,-16
    8000579a:	e406                	sd	ra,8(sp)
    8000579c:	e022                	sd	s0,0(sp)
    8000579e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057a0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057a4:	7779                	lui	a4,0xffffe
    800057a6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd45bf>
    800057aa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057ac:	6705                	lui	a4,0x1
    800057ae:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057b4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057b8:	ffffb797          	auipc	a5,0xffffb
    800057bc:	b6e78793          	addi	a5,a5,-1170 # 80000326 <main>
    800057c0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057c4:	4781                	li	a5,0
    800057c6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057ca:	67c1                	lui	a5,0x10
    800057cc:	17fd                	addi	a5,a5,-1
    800057ce:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057d2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057d6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057da:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057de:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057e2:	57fd                	li	a5,-1
    800057e4:	83a9                	srli	a5,a5,0xa
    800057e6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057ea:	47bd                	li	a5,15
    800057ec:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057f0:	00000097          	auipc	ra,0x0
    800057f4:	f36080e7          	jalr	-202(ra) # 80005726 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057f8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057fc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057fe:	823e                	mv	tp,a5
  asm volatile("mret");
    80005800:	30200073          	mret
}
    80005804:	60a2                	ld	ra,8(sp)
    80005806:	6402                	ld	s0,0(sp)
    80005808:	0141                	addi	sp,sp,16
    8000580a:	8082                	ret

000000008000580c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000580c:	715d                	addi	sp,sp,-80
    8000580e:	e486                	sd	ra,72(sp)
    80005810:	e0a2                	sd	s0,64(sp)
    80005812:	fc26                	sd	s1,56(sp)
    80005814:	f84a                	sd	s2,48(sp)
    80005816:	f44e                	sd	s3,40(sp)
    80005818:	f052                	sd	s4,32(sp)
    8000581a:	ec56                	sd	s5,24(sp)
    8000581c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000581e:	04c05663          	blez	a2,8000586a <consolewrite+0x5e>
    80005822:	8a2a                	mv	s4,a0
    80005824:	84ae                	mv	s1,a1
    80005826:	89b2                	mv	s3,a2
    80005828:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000582a:	5afd                	li	s5,-1
    8000582c:	4685                	li	a3,1
    8000582e:	8626                	mv	a2,s1
    80005830:	85d2                	mv	a1,s4
    80005832:	fbf40513          	addi	a0,s0,-65
    80005836:	ffffc097          	auipc	ra,0xffffc
    8000583a:	0d6080e7          	jalr	214(ra) # 8000190c <either_copyin>
    8000583e:	01550c63          	beq	a0,s5,80005856 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005842:	fbf44503          	lbu	a0,-65(s0)
    80005846:	00000097          	auipc	ra,0x0
    8000584a:	7d6080e7          	jalr	2006(ra) # 8000601c <uartputc>
  for(i = 0; i < n; i++){
    8000584e:	2905                	addiw	s2,s2,1
    80005850:	0485                	addi	s1,s1,1
    80005852:	fd299de3          	bne	s3,s2,8000582c <consolewrite+0x20>
  }

  return i;
}
    80005856:	854a                	mv	a0,s2
    80005858:	60a6                	ld	ra,72(sp)
    8000585a:	6406                	ld	s0,64(sp)
    8000585c:	74e2                	ld	s1,56(sp)
    8000585e:	7942                	ld	s2,48(sp)
    80005860:	79a2                	ld	s3,40(sp)
    80005862:	7a02                	ld	s4,32(sp)
    80005864:	6ae2                	ld	s5,24(sp)
    80005866:	6161                	addi	sp,sp,80
    80005868:	8082                	ret
  for(i = 0; i < n; i++){
    8000586a:	4901                	li	s2,0
    8000586c:	b7ed                	j	80005856 <consolewrite+0x4a>

000000008000586e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000586e:	7119                	addi	sp,sp,-128
    80005870:	fc86                	sd	ra,120(sp)
    80005872:	f8a2                	sd	s0,112(sp)
    80005874:	f4a6                	sd	s1,104(sp)
    80005876:	f0ca                	sd	s2,96(sp)
    80005878:	ecce                	sd	s3,88(sp)
    8000587a:	e8d2                	sd	s4,80(sp)
    8000587c:	e4d6                	sd	s5,72(sp)
    8000587e:	e0da                	sd	s6,64(sp)
    80005880:	fc5e                	sd	s7,56(sp)
    80005882:	f862                	sd	s8,48(sp)
    80005884:	f466                	sd	s9,40(sp)
    80005886:	f06a                	sd	s10,32(sp)
    80005888:	ec6e                	sd	s11,24(sp)
    8000588a:	0100                	addi	s0,sp,128
    8000588c:	8b2a                	mv	s6,a0
    8000588e:	8aae                	mv	s5,a1
    80005890:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005892:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005896:	00025517          	auipc	a0,0x25
    8000589a:	8aa50513          	addi	a0,a0,-1878 # 8002a140 <cons>
    8000589e:	00001097          	auipc	ra,0x1
    800058a2:	93c080e7          	jalr	-1732(ra) # 800061da <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058a6:	00025497          	auipc	s1,0x25
    800058aa:	89a48493          	addi	s1,s1,-1894 # 8002a140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058ae:	89a6                	mv	s3,s1
    800058b0:	00025917          	auipc	s2,0x25
    800058b4:	92890913          	addi	s2,s2,-1752 # 8002a1d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058b8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058ba:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058bc:	4da9                	li	s11,10
  while(n > 0){
    800058be:	07405863          	blez	s4,8000592e <consoleread+0xc0>
    while(cons.r == cons.w){
    800058c2:	0984a783          	lw	a5,152(s1)
    800058c6:	09c4a703          	lw	a4,156(s1)
    800058ca:	02f71463          	bne	a4,a5,800058f2 <consoleread+0x84>
      if(myproc()->killed){
    800058ce:	ffffb097          	auipc	ra,0xffffb
    800058d2:	57a080e7          	jalr	1402(ra) # 80000e48 <myproc>
    800058d6:	551c                	lw	a5,40(a0)
    800058d8:	e7b5                	bnez	a5,80005944 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800058da:	85ce                	mv	a1,s3
    800058dc:	854a                	mv	a0,s2
    800058de:	ffffc097          	auipc	ra,0xffffc
    800058e2:	c34080e7          	jalr	-972(ra) # 80001512 <sleep>
    while(cons.r == cons.w){
    800058e6:	0984a783          	lw	a5,152(s1)
    800058ea:	09c4a703          	lw	a4,156(s1)
    800058ee:	fef700e3          	beq	a4,a5,800058ce <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058f2:	0017871b          	addiw	a4,a5,1
    800058f6:	08e4ac23          	sw	a4,152(s1)
    800058fa:	07f7f713          	andi	a4,a5,127
    800058fe:	9726                	add	a4,a4,s1
    80005900:	01874703          	lbu	a4,24(a4)
    80005904:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005908:	079c0663          	beq	s8,s9,80005974 <consoleread+0x106>
    cbuf = c;
    8000590c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005910:	4685                	li	a3,1
    80005912:	f8f40613          	addi	a2,s0,-113
    80005916:	85d6                	mv	a1,s5
    80005918:	855a                	mv	a0,s6
    8000591a:	ffffc097          	auipc	ra,0xffffc
    8000591e:	f9c080e7          	jalr	-100(ra) # 800018b6 <either_copyout>
    80005922:	01a50663          	beq	a0,s10,8000592e <consoleread+0xc0>
    dst++;
    80005926:	0a85                	addi	s5,s5,1
    --n;
    80005928:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000592a:	f9bc1ae3          	bne	s8,s11,800058be <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000592e:	00025517          	auipc	a0,0x25
    80005932:	81250513          	addi	a0,a0,-2030 # 8002a140 <cons>
    80005936:	00001097          	auipc	ra,0x1
    8000593a:	958080e7          	jalr	-1704(ra) # 8000628e <release>

  return target - n;
    8000593e:	414b853b          	subw	a0,s7,s4
    80005942:	a811                	j	80005956 <consoleread+0xe8>
        release(&cons.lock);
    80005944:	00024517          	auipc	a0,0x24
    80005948:	7fc50513          	addi	a0,a0,2044 # 8002a140 <cons>
    8000594c:	00001097          	auipc	ra,0x1
    80005950:	942080e7          	jalr	-1726(ra) # 8000628e <release>
        return -1;
    80005954:	557d                	li	a0,-1
}
    80005956:	70e6                	ld	ra,120(sp)
    80005958:	7446                	ld	s0,112(sp)
    8000595a:	74a6                	ld	s1,104(sp)
    8000595c:	7906                	ld	s2,96(sp)
    8000595e:	69e6                	ld	s3,88(sp)
    80005960:	6a46                	ld	s4,80(sp)
    80005962:	6aa6                	ld	s5,72(sp)
    80005964:	6b06                	ld	s6,64(sp)
    80005966:	7be2                	ld	s7,56(sp)
    80005968:	7c42                	ld	s8,48(sp)
    8000596a:	7ca2                	ld	s9,40(sp)
    8000596c:	7d02                	ld	s10,32(sp)
    8000596e:	6de2                	ld	s11,24(sp)
    80005970:	6109                	addi	sp,sp,128
    80005972:	8082                	ret
      if(n < target){
    80005974:	000a071b          	sext.w	a4,s4
    80005978:	fb777be3          	bgeu	a4,s7,8000592e <consoleread+0xc0>
        cons.r--;
    8000597c:	00025717          	auipc	a4,0x25
    80005980:	84f72e23          	sw	a5,-1956(a4) # 8002a1d8 <cons+0x98>
    80005984:	b76d                	j	8000592e <consoleread+0xc0>

0000000080005986 <consputc>:
{
    80005986:	1141                	addi	sp,sp,-16
    80005988:	e406                	sd	ra,8(sp)
    8000598a:	e022                	sd	s0,0(sp)
    8000598c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000598e:	10000793          	li	a5,256
    80005992:	00f50a63          	beq	a0,a5,800059a6 <consputc+0x20>
    uartputc_sync(c);
    80005996:	00000097          	auipc	ra,0x0
    8000599a:	5ac080e7          	jalr	1452(ra) # 80005f42 <uartputc_sync>
}
    8000599e:	60a2                	ld	ra,8(sp)
    800059a0:	6402                	ld	s0,0(sp)
    800059a2:	0141                	addi	sp,sp,16
    800059a4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059a6:	4521                	li	a0,8
    800059a8:	00000097          	auipc	ra,0x0
    800059ac:	59a080e7          	jalr	1434(ra) # 80005f42 <uartputc_sync>
    800059b0:	02000513          	li	a0,32
    800059b4:	00000097          	auipc	ra,0x0
    800059b8:	58e080e7          	jalr	1422(ra) # 80005f42 <uartputc_sync>
    800059bc:	4521                	li	a0,8
    800059be:	00000097          	auipc	ra,0x0
    800059c2:	584080e7          	jalr	1412(ra) # 80005f42 <uartputc_sync>
    800059c6:	bfe1                	j	8000599e <consputc+0x18>

00000000800059c8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059c8:	1101                	addi	sp,sp,-32
    800059ca:	ec06                	sd	ra,24(sp)
    800059cc:	e822                	sd	s0,16(sp)
    800059ce:	e426                	sd	s1,8(sp)
    800059d0:	e04a                	sd	s2,0(sp)
    800059d2:	1000                	addi	s0,sp,32
    800059d4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059d6:	00024517          	auipc	a0,0x24
    800059da:	76a50513          	addi	a0,a0,1898 # 8002a140 <cons>
    800059de:	00000097          	auipc	ra,0x0
    800059e2:	7fc080e7          	jalr	2044(ra) # 800061da <acquire>

  switch(c){
    800059e6:	47d5                	li	a5,21
    800059e8:	0af48663          	beq	s1,a5,80005a94 <consoleintr+0xcc>
    800059ec:	0297ca63          	blt	a5,s1,80005a20 <consoleintr+0x58>
    800059f0:	47a1                	li	a5,8
    800059f2:	0ef48763          	beq	s1,a5,80005ae0 <consoleintr+0x118>
    800059f6:	47c1                	li	a5,16
    800059f8:	10f49a63          	bne	s1,a5,80005b0c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059fc:	ffffc097          	auipc	ra,0xffffc
    80005a00:	f66080e7          	jalr	-154(ra) # 80001962 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a04:	00024517          	auipc	a0,0x24
    80005a08:	73c50513          	addi	a0,a0,1852 # 8002a140 <cons>
    80005a0c:	00001097          	auipc	ra,0x1
    80005a10:	882080e7          	jalr	-1918(ra) # 8000628e <release>
}
    80005a14:	60e2                	ld	ra,24(sp)
    80005a16:	6442                	ld	s0,16(sp)
    80005a18:	64a2                	ld	s1,8(sp)
    80005a1a:	6902                	ld	s2,0(sp)
    80005a1c:	6105                	addi	sp,sp,32
    80005a1e:	8082                	ret
  switch(c){
    80005a20:	07f00793          	li	a5,127
    80005a24:	0af48e63          	beq	s1,a5,80005ae0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a28:	00024717          	auipc	a4,0x24
    80005a2c:	71870713          	addi	a4,a4,1816 # 8002a140 <cons>
    80005a30:	0a072783          	lw	a5,160(a4)
    80005a34:	09872703          	lw	a4,152(a4)
    80005a38:	9f99                	subw	a5,a5,a4
    80005a3a:	07f00713          	li	a4,127
    80005a3e:	fcf763e3          	bltu	a4,a5,80005a04 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a42:	47b5                	li	a5,13
    80005a44:	0cf48763          	beq	s1,a5,80005b12 <consoleintr+0x14a>
      consputc(c);
    80005a48:	8526                	mv	a0,s1
    80005a4a:	00000097          	auipc	ra,0x0
    80005a4e:	f3c080e7          	jalr	-196(ra) # 80005986 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a52:	00024797          	auipc	a5,0x24
    80005a56:	6ee78793          	addi	a5,a5,1774 # 8002a140 <cons>
    80005a5a:	0a07a703          	lw	a4,160(a5)
    80005a5e:	0017069b          	addiw	a3,a4,1
    80005a62:	0006861b          	sext.w	a2,a3
    80005a66:	0ad7a023          	sw	a3,160(a5)
    80005a6a:	07f77713          	andi	a4,a4,127
    80005a6e:	97ba                	add	a5,a5,a4
    80005a70:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a74:	47a9                	li	a5,10
    80005a76:	0cf48563          	beq	s1,a5,80005b40 <consoleintr+0x178>
    80005a7a:	4791                	li	a5,4
    80005a7c:	0cf48263          	beq	s1,a5,80005b40 <consoleintr+0x178>
    80005a80:	00024797          	auipc	a5,0x24
    80005a84:	7587a783          	lw	a5,1880(a5) # 8002a1d8 <cons+0x98>
    80005a88:	0807879b          	addiw	a5,a5,128
    80005a8c:	f6f61ce3          	bne	a2,a5,80005a04 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a90:	863e                	mv	a2,a5
    80005a92:	a07d                	j	80005b40 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a94:	00024717          	auipc	a4,0x24
    80005a98:	6ac70713          	addi	a4,a4,1708 # 8002a140 <cons>
    80005a9c:	0a072783          	lw	a5,160(a4)
    80005aa0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005aa4:	00024497          	auipc	s1,0x24
    80005aa8:	69c48493          	addi	s1,s1,1692 # 8002a140 <cons>
    while(cons.e != cons.w &&
    80005aac:	4929                	li	s2,10
    80005aae:	f4f70be3          	beq	a4,a5,80005a04 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ab2:	37fd                	addiw	a5,a5,-1
    80005ab4:	07f7f713          	andi	a4,a5,127
    80005ab8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005aba:	01874703          	lbu	a4,24(a4)
    80005abe:	f52703e3          	beq	a4,s2,80005a04 <consoleintr+0x3c>
      cons.e--;
    80005ac2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ac6:	10000513          	li	a0,256
    80005aca:	00000097          	auipc	ra,0x0
    80005ace:	ebc080e7          	jalr	-324(ra) # 80005986 <consputc>
    while(cons.e != cons.w &&
    80005ad2:	0a04a783          	lw	a5,160(s1)
    80005ad6:	09c4a703          	lw	a4,156(s1)
    80005ada:	fcf71ce3          	bne	a4,a5,80005ab2 <consoleintr+0xea>
    80005ade:	b71d                	j	80005a04 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ae0:	00024717          	auipc	a4,0x24
    80005ae4:	66070713          	addi	a4,a4,1632 # 8002a140 <cons>
    80005ae8:	0a072783          	lw	a5,160(a4)
    80005aec:	09c72703          	lw	a4,156(a4)
    80005af0:	f0f70ae3          	beq	a4,a5,80005a04 <consoleintr+0x3c>
      cons.e--;
    80005af4:	37fd                	addiw	a5,a5,-1
    80005af6:	00024717          	auipc	a4,0x24
    80005afa:	6ef72523          	sw	a5,1770(a4) # 8002a1e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005afe:	10000513          	li	a0,256
    80005b02:	00000097          	auipc	ra,0x0
    80005b06:	e84080e7          	jalr	-380(ra) # 80005986 <consputc>
    80005b0a:	bded                	j	80005a04 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b0c:	ee048ce3          	beqz	s1,80005a04 <consoleintr+0x3c>
    80005b10:	bf21                	j	80005a28 <consoleintr+0x60>
      consputc(c);
    80005b12:	4529                	li	a0,10
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	e72080e7          	jalr	-398(ra) # 80005986 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b1c:	00024797          	auipc	a5,0x24
    80005b20:	62478793          	addi	a5,a5,1572 # 8002a140 <cons>
    80005b24:	0a07a703          	lw	a4,160(a5)
    80005b28:	0017069b          	addiw	a3,a4,1
    80005b2c:	0006861b          	sext.w	a2,a3
    80005b30:	0ad7a023          	sw	a3,160(a5)
    80005b34:	07f77713          	andi	a4,a4,127
    80005b38:	97ba                	add	a5,a5,a4
    80005b3a:	4729                	li	a4,10
    80005b3c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b40:	00024797          	auipc	a5,0x24
    80005b44:	68c7ae23          	sw	a2,1692(a5) # 8002a1dc <cons+0x9c>
        wakeup(&cons.r);
    80005b48:	00024517          	auipc	a0,0x24
    80005b4c:	69050513          	addi	a0,a0,1680 # 8002a1d8 <cons+0x98>
    80005b50:	ffffc097          	auipc	ra,0xffffc
    80005b54:	b4e080e7          	jalr	-1202(ra) # 8000169e <wakeup>
    80005b58:	b575                	j	80005a04 <consoleintr+0x3c>

0000000080005b5a <consoleinit>:

void
consoleinit(void)
{
    80005b5a:	1141                	addi	sp,sp,-16
    80005b5c:	e406                	sd	ra,8(sp)
    80005b5e:	e022                	sd	s0,0(sp)
    80005b60:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b62:	00003597          	auipc	a1,0x3
    80005b66:	c3e58593          	addi	a1,a1,-962 # 800087a0 <syscalls+0x3d8>
    80005b6a:	00024517          	auipc	a0,0x24
    80005b6e:	5d650513          	addi	a0,a0,1494 # 8002a140 <cons>
    80005b72:	00000097          	auipc	ra,0x0
    80005b76:	5d8080e7          	jalr	1496(ra) # 8000614a <initlock>

  uartinit();
    80005b7a:	00000097          	auipc	ra,0x0
    80005b7e:	378080e7          	jalr	888(ra) # 80005ef2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b82:	00018797          	auipc	a5,0x18
    80005b86:	34678793          	addi	a5,a5,838 # 8001dec8 <devsw>
    80005b8a:	00000717          	auipc	a4,0x0
    80005b8e:	ce470713          	addi	a4,a4,-796 # 8000586e <consoleread>
    80005b92:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b94:	00000717          	auipc	a4,0x0
    80005b98:	c7870713          	addi	a4,a4,-904 # 8000580c <consolewrite>
    80005b9c:	ef98                	sd	a4,24(a5)
}
    80005b9e:	60a2                	ld	ra,8(sp)
    80005ba0:	6402                	ld	s0,0(sp)
    80005ba2:	0141                	addi	sp,sp,16
    80005ba4:	8082                	ret

0000000080005ba6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ba6:	7179                	addi	sp,sp,-48
    80005ba8:	f406                	sd	ra,40(sp)
    80005baa:	f022                	sd	s0,32(sp)
    80005bac:	ec26                	sd	s1,24(sp)
    80005bae:	e84a                	sd	s2,16(sp)
    80005bb0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bb2:	c219                	beqz	a2,80005bb8 <printint+0x12>
    80005bb4:	08054663          	bltz	a0,80005c40 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bb8:	2501                	sext.w	a0,a0
    80005bba:	4881                	li	a7,0
    80005bbc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bc0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bc2:	2581                	sext.w	a1,a1
    80005bc4:	00003617          	auipc	a2,0x3
    80005bc8:	c1460613          	addi	a2,a2,-1004 # 800087d8 <digits>
    80005bcc:	883a                	mv	a6,a4
    80005bce:	2705                	addiw	a4,a4,1
    80005bd0:	02b577bb          	remuw	a5,a0,a1
    80005bd4:	1782                	slli	a5,a5,0x20
    80005bd6:	9381                	srli	a5,a5,0x20
    80005bd8:	97b2                	add	a5,a5,a2
    80005bda:	0007c783          	lbu	a5,0(a5)
    80005bde:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005be2:	0005079b          	sext.w	a5,a0
    80005be6:	02b5553b          	divuw	a0,a0,a1
    80005bea:	0685                	addi	a3,a3,1
    80005bec:	feb7f0e3          	bgeu	a5,a1,80005bcc <printint+0x26>

  if(sign)
    80005bf0:	00088b63          	beqz	a7,80005c06 <printint+0x60>
    buf[i++] = '-';
    80005bf4:	fe040793          	addi	a5,s0,-32
    80005bf8:	973e                	add	a4,a4,a5
    80005bfa:	02d00793          	li	a5,45
    80005bfe:	fef70823          	sb	a5,-16(a4)
    80005c02:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c06:	02e05763          	blez	a4,80005c34 <printint+0x8e>
    80005c0a:	fd040793          	addi	a5,s0,-48
    80005c0e:	00e784b3          	add	s1,a5,a4
    80005c12:	fff78913          	addi	s2,a5,-1
    80005c16:	993a                	add	s2,s2,a4
    80005c18:	377d                	addiw	a4,a4,-1
    80005c1a:	1702                	slli	a4,a4,0x20
    80005c1c:	9301                	srli	a4,a4,0x20
    80005c1e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c22:	fff4c503          	lbu	a0,-1(s1)
    80005c26:	00000097          	auipc	ra,0x0
    80005c2a:	d60080e7          	jalr	-672(ra) # 80005986 <consputc>
  while(--i >= 0)
    80005c2e:	14fd                	addi	s1,s1,-1
    80005c30:	ff2499e3          	bne	s1,s2,80005c22 <printint+0x7c>
}
    80005c34:	70a2                	ld	ra,40(sp)
    80005c36:	7402                	ld	s0,32(sp)
    80005c38:	64e2                	ld	s1,24(sp)
    80005c3a:	6942                	ld	s2,16(sp)
    80005c3c:	6145                	addi	sp,sp,48
    80005c3e:	8082                	ret
    x = -xx;
    80005c40:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c44:	4885                	li	a7,1
    x = -xx;
    80005c46:	bf9d                	j	80005bbc <printint+0x16>

0000000080005c48 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005c48:	1101                	addi	sp,sp,-32
    80005c4a:	ec06                	sd	ra,24(sp)
    80005c4c:	e822                	sd	s0,16(sp)
    80005c4e:	e426                	sd	s1,8(sp)
    80005c50:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005c52:	00024497          	auipc	s1,0x24
    80005c56:	59648493          	addi	s1,s1,1430 # 8002a1e8 <pr>
    80005c5a:	00003597          	auipc	a1,0x3
    80005c5e:	b4e58593          	addi	a1,a1,-1202 # 800087a8 <syscalls+0x3e0>
    80005c62:	8526                	mv	a0,s1
    80005c64:	00000097          	auipc	ra,0x0
    80005c68:	4e6080e7          	jalr	1254(ra) # 8000614a <initlock>
  pr.locking = 1;
    80005c6c:	4785                	li	a5,1
    80005c6e:	cc9c                	sw	a5,24(s1)
}
    80005c70:	60e2                	ld	ra,24(sp)
    80005c72:	6442                	ld	s0,16(sp)
    80005c74:	64a2                	ld	s1,8(sp)
    80005c76:	6105                	addi	sp,sp,32
    80005c78:	8082                	ret

0000000080005c7a <backtrace>:

void
backtrace(void)
{
    80005c7a:	1101                	addi	sp,sp,-32
    80005c7c:	ec06                	sd	ra,24(sp)
    80005c7e:	e822                	sd	s0,16(sp)
    80005c80:	e426                	sd	s1,8(sp)
    80005c82:	e04a                	sd	s2,0(sp)
    80005c84:	1000                	addi	s0,sp,32

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80005c86:	84a2                	mv	s1,s0
  uint64 fp_address = r_fp();
  while(fp_address != PGROUNDDOWN(fp_address)) {
    80005c88:	03449793          	slli	a5,s1,0x34
    80005c8c:	c38d                	beqz	a5,80005cae <backtrace+0x34>
    printf("%p\n", *(uint64*)(fp_address-8));
    80005c8e:	00003917          	auipc	s2,0x3
    80005c92:	b2290913          	addi	s2,s2,-1246 # 800087b0 <syscalls+0x3e8>
    80005c96:	ff84b583          	ld	a1,-8(s1)
    80005c9a:	854a                	mv	a0,s2
    80005c9c:	00000097          	auipc	ra,0x0
    80005ca0:	070080e7          	jalr	112(ra) # 80005d0c <printf>
    fp_address = *(uint64*)(fp_address - 16);
    80005ca4:	ff04b483          	ld	s1,-16(s1)
  while(fp_address != PGROUNDDOWN(fp_address)) {
    80005ca8:	03449793          	slli	a5,s1,0x34
    80005cac:	f7ed                	bnez	a5,80005c96 <backtrace+0x1c>
  }
    80005cae:	60e2                	ld	ra,24(sp)
    80005cb0:	6442                	ld	s0,16(sp)
    80005cb2:	64a2                	ld	s1,8(sp)
    80005cb4:	6902                	ld	s2,0(sp)
    80005cb6:	6105                	addi	sp,sp,32
    80005cb8:	8082                	ret

0000000080005cba <panic>:
{
    80005cba:	1101                	addi	sp,sp,-32
    80005cbc:	ec06                	sd	ra,24(sp)
    80005cbe:	e822                	sd	s0,16(sp)
    80005cc0:	e426                	sd	s1,8(sp)
    80005cc2:	1000                	addi	s0,sp,32
    80005cc4:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cc6:	00024797          	auipc	a5,0x24
    80005cca:	5207ad23          	sw	zero,1338(a5) # 8002a200 <pr+0x18>
  printf("panic: ");
    80005cce:	00003517          	auipc	a0,0x3
    80005cd2:	aea50513          	addi	a0,a0,-1302 # 800087b8 <syscalls+0x3f0>
    80005cd6:	00000097          	auipc	ra,0x0
    80005cda:	036080e7          	jalr	54(ra) # 80005d0c <printf>
  printf(s);
    80005cde:	8526                	mv	a0,s1
    80005ce0:	00000097          	auipc	ra,0x0
    80005ce4:	02c080e7          	jalr	44(ra) # 80005d0c <printf>
  printf("\n");
    80005ce8:	00002517          	auipc	a0,0x2
    80005cec:	36050513          	addi	a0,a0,864 # 80008048 <etext+0x48>
    80005cf0:	00000097          	auipc	ra,0x0
    80005cf4:	01c080e7          	jalr	28(ra) # 80005d0c <printf>
  backtrace();
    80005cf8:	00000097          	auipc	ra,0x0
    80005cfc:	f82080e7          	jalr	-126(ra) # 80005c7a <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005d00:	4785                	li	a5,1
    80005d02:	00003717          	auipc	a4,0x3
    80005d06:	30f72d23          	sw	a5,794(a4) # 8000901c <panicked>
  for(;;)
    80005d0a:	a001                	j	80005d0a <panic+0x50>

0000000080005d0c <printf>:
{
    80005d0c:	7131                	addi	sp,sp,-192
    80005d0e:	fc86                	sd	ra,120(sp)
    80005d10:	f8a2                	sd	s0,112(sp)
    80005d12:	f4a6                	sd	s1,104(sp)
    80005d14:	f0ca                	sd	s2,96(sp)
    80005d16:	ecce                	sd	s3,88(sp)
    80005d18:	e8d2                	sd	s4,80(sp)
    80005d1a:	e4d6                	sd	s5,72(sp)
    80005d1c:	e0da                	sd	s6,64(sp)
    80005d1e:	fc5e                	sd	s7,56(sp)
    80005d20:	f862                	sd	s8,48(sp)
    80005d22:	f466                	sd	s9,40(sp)
    80005d24:	f06a                	sd	s10,32(sp)
    80005d26:	ec6e                	sd	s11,24(sp)
    80005d28:	0100                	addi	s0,sp,128
    80005d2a:	8a2a                	mv	s4,a0
    80005d2c:	e40c                	sd	a1,8(s0)
    80005d2e:	e810                	sd	a2,16(s0)
    80005d30:	ec14                	sd	a3,24(s0)
    80005d32:	f018                	sd	a4,32(s0)
    80005d34:	f41c                	sd	a5,40(s0)
    80005d36:	03043823          	sd	a6,48(s0)
    80005d3a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d3e:	00024d97          	auipc	s11,0x24
    80005d42:	4c2dad83          	lw	s11,1218(s11) # 8002a200 <pr+0x18>
  if(locking)
    80005d46:	020d9b63          	bnez	s11,80005d7c <printf+0x70>
  if (fmt == 0)
    80005d4a:	040a0263          	beqz	s4,80005d8e <printf+0x82>
  va_start(ap, fmt);
    80005d4e:	00840793          	addi	a5,s0,8
    80005d52:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d56:	000a4503          	lbu	a0,0(s4)
    80005d5a:	16050263          	beqz	a0,80005ebe <printf+0x1b2>
    80005d5e:	4481                	li	s1,0
    if(c != '%'){
    80005d60:	02500a93          	li	s5,37
    switch(c){
    80005d64:	07000b13          	li	s6,112
  consputc('x');
    80005d68:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d6a:	00003b97          	auipc	s7,0x3
    80005d6e:	a6eb8b93          	addi	s7,s7,-1426 # 800087d8 <digits>
    switch(c){
    80005d72:	07300c93          	li	s9,115
    80005d76:	06400c13          	li	s8,100
    80005d7a:	a82d                	j	80005db4 <printf+0xa8>
    acquire(&pr.lock);
    80005d7c:	00024517          	auipc	a0,0x24
    80005d80:	46c50513          	addi	a0,a0,1132 # 8002a1e8 <pr>
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	456080e7          	jalr	1110(ra) # 800061da <acquire>
    80005d8c:	bf7d                	j	80005d4a <printf+0x3e>
    panic("null fmt");
    80005d8e:	00003517          	auipc	a0,0x3
    80005d92:	a3a50513          	addi	a0,a0,-1478 # 800087c8 <syscalls+0x400>
    80005d96:	00000097          	auipc	ra,0x0
    80005d9a:	f24080e7          	jalr	-220(ra) # 80005cba <panic>
      consputc(c);
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	be8080e7          	jalr	-1048(ra) # 80005986 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005da6:	2485                	addiw	s1,s1,1
    80005da8:	009a07b3          	add	a5,s4,s1
    80005dac:	0007c503          	lbu	a0,0(a5)
    80005db0:	10050763          	beqz	a0,80005ebe <printf+0x1b2>
    if(c != '%'){
    80005db4:	ff5515e3          	bne	a0,s5,80005d9e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005db8:	2485                	addiw	s1,s1,1
    80005dba:	009a07b3          	add	a5,s4,s1
    80005dbe:	0007c783          	lbu	a5,0(a5)
    80005dc2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005dc6:	cfe5                	beqz	a5,80005ebe <printf+0x1b2>
    switch(c){
    80005dc8:	05678a63          	beq	a5,s6,80005e1c <printf+0x110>
    80005dcc:	02fb7663          	bgeu	s6,a5,80005df8 <printf+0xec>
    80005dd0:	09978963          	beq	a5,s9,80005e62 <printf+0x156>
    80005dd4:	07800713          	li	a4,120
    80005dd8:	0ce79863          	bne	a5,a4,80005ea8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ddc:	f8843783          	ld	a5,-120(s0)
    80005de0:	00878713          	addi	a4,a5,8
    80005de4:	f8e43423          	sd	a4,-120(s0)
    80005de8:	4605                	li	a2,1
    80005dea:	85ea                	mv	a1,s10
    80005dec:	4388                	lw	a0,0(a5)
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	db8080e7          	jalr	-584(ra) # 80005ba6 <printint>
      break;
    80005df6:	bf45                	j	80005da6 <printf+0x9a>
    switch(c){
    80005df8:	0b578263          	beq	a5,s5,80005e9c <printf+0x190>
    80005dfc:	0b879663          	bne	a5,s8,80005ea8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e00:	f8843783          	ld	a5,-120(s0)
    80005e04:	00878713          	addi	a4,a5,8
    80005e08:	f8e43423          	sd	a4,-120(s0)
    80005e0c:	4605                	li	a2,1
    80005e0e:	45a9                	li	a1,10
    80005e10:	4388                	lw	a0,0(a5)
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	d94080e7          	jalr	-620(ra) # 80005ba6 <printint>
      break;
    80005e1a:	b771                	j	80005da6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e1c:	f8843783          	ld	a5,-120(s0)
    80005e20:	00878713          	addi	a4,a5,8
    80005e24:	f8e43423          	sd	a4,-120(s0)
    80005e28:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e2c:	03000513          	li	a0,48
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	b56080e7          	jalr	-1194(ra) # 80005986 <consputc>
  consputc('x');
    80005e38:	07800513          	li	a0,120
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	b4a080e7          	jalr	-1206(ra) # 80005986 <consputc>
    80005e44:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e46:	03c9d793          	srli	a5,s3,0x3c
    80005e4a:	97de                	add	a5,a5,s7
    80005e4c:	0007c503          	lbu	a0,0(a5)
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	b36080e7          	jalr	-1226(ra) # 80005986 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e58:	0992                	slli	s3,s3,0x4
    80005e5a:	397d                	addiw	s2,s2,-1
    80005e5c:	fe0915e3          	bnez	s2,80005e46 <printf+0x13a>
    80005e60:	b799                	j	80005da6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e62:	f8843783          	ld	a5,-120(s0)
    80005e66:	00878713          	addi	a4,a5,8
    80005e6a:	f8e43423          	sd	a4,-120(s0)
    80005e6e:	0007b903          	ld	s2,0(a5)
    80005e72:	00090e63          	beqz	s2,80005e8e <printf+0x182>
      for(; *s; s++)
    80005e76:	00094503          	lbu	a0,0(s2)
    80005e7a:	d515                	beqz	a0,80005da6 <printf+0x9a>
        consputc(*s);
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	b0a080e7          	jalr	-1270(ra) # 80005986 <consputc>
      for(; *s; s++)
    80005e84:	0905                	addi	s2,s2,1
    80005e86:	00094503          	lbu	a0,0(s2)
    80005e8a:	f96d                	bnez	a0,80005e7c <printf+0x170>
    80005e8c:	bf29                	j	80005da6 <printf+0x9a>
        s = "(null)";
    80005e8e:	00003917          	auipc	s2,0x3
    80005e92:	93290913          	addi	s2,s2,-1742 # 800087c0 <syscalls+0x3f8>
      for(; *s; s++)
    80005e96:	02800513          	li	a0,40
    80005e9a:	b7cd                	j	80005e7c <printf+0x170>
      consputc('%');
    80005e9c:	8556                	mv	a0,s5
    80005e9e:	00000097          	auipc	ra,0x0
    80005ea2:	ae8080e7          	jalr	-1304(ra) # 80005986 <consputc>
      break;
    80005ea6:	b701                	j	80005da6 <printf+0x9a>
      consputc('%');
    80005ea8:	8556                	mv	a0,s5
    80005eaa:	00000097          	auipc	ra,0x0
    80005eae:	adc080e7          	jalr	-1316(ra) # 80005986 <consputc>
      consputc(c);
    80005eb2:	854a                	mv	a0,s2
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	ad2080e7          	jalr	-1326(ra) # 80005986 <consputc>
      break;
    80005ebc:	b5ed                	j	80005da6 <printf+0x9a>
  if(locking)
    80005ebe:	020d9163          	bnez	s11,80005ee0 <printf+0x1d4>
}
    80005ec2:	70e6                	ld	ra,120(sp)
    80005ec4:	7446                	ld	s0,112(sp)
    80005ec6:	74a6                	ld	s1,104(sp)
    80005ec8:	7906                	ld	s2,96(sp)
    80005eca:	69e6                	ld	s3,88(sp)
    80005ecc:	6a46                	ld	s4,80(sp)
    80005ece:	6aa6                	ld	s5,72(sp)
    80005ed0:	6b06                	ld	s6,64(sp)
    80005ed2:	7be2                	ld	s7,56(sp)
    80005ed4:	7c42                	ld	s8,48(sp)
    80005ed6:	7ca2                	ld	s9,40(sp)
    80005ed8:	7d02                	ld	s10,32(sp)
    80005eda:	6de2                	ld	s11,24(sp)
    80005edc:	6129                	addi	sp,sp,192
    80005ede:	8082                	ret
    release(&pr.lock);
    80005ee0:	00024517          	auipc	a0,0x24
    80005ee4:	30850513          	addi	a0,a0,776 # 8002a1e8 <pr>
    80005ee8:	00000097          	auipc	ra,0x0
    80005eec:	3a6080e7          	jalr	934(ra) # 8000628e <release>
}
    80005ef0:	bfc9                	j	80005ec2 <printf+0x1b6>

0000000080005ef2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ef2:	1141                	addi	sp,sp,-16
    80005ef4:	e406                	sd	ra,8(sp)
    80005ef6:	e022                	sd	s0,0(sp)
    80005ef8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005efa:	100007b7          	lui	a5,0x10000
    80005efe:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f02:	f8000713          	li	a4,-128
    80005f06:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f0a:	470d                	li	a4,3
    80005f0c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f10:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f14:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f18:	469d                	li	a3,7
    80005f1a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f1e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f22:	00003597          	auipc	a1,0x3
    80005f26:	8ce58593          	addi	a1,a1,-1842 # 800087f0 <digits+0x18>
    80005f2a:	00024517          	auipc	a0,0x24
    80005f2e:	2de50513          	addi	a0,a0,734 # 8002a208 <uart_tx_lock>
    80005f32:	00000097          	auipc	ra,0x0
    80005f36:	218080e7          	jalr	536(ra) # 8000614a <initlock>
}
    80005f3a:	60a2                	ld	ra,8(sp)
    80005f3c:	6402                	ld	s0,0(sp)
    80005f3e:	0141                	addi	sp,sp,16
    80005f40:	8082                	ret

0000000080005f42 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f42:	1101                	addi	sp,sp,-32
    80005f44:	ec06                	sd	ra,24(sp)
    80005f46:	e822                	sd	s0,16(sp)
    80005f48:	e426                	sd	s1,8(sp)
    80005f4a:	1000                	addi	s0,sp,32
    80005f4c:	84aa                	mv	s1,a0
  push_off();
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	240080e7          	jalr	576(ra) # 8000618e <push_off>

  if(panicked){
    80005f56:	00003797          	auipc	a5,0x3
    80005f5a:	0c67a783          	lw	a5,198(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f5e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f62:	c391                	beqz	a5,80005f66 <uartputc_sync+0x24>
    for(;;)
    80005f64:	a001                	j	80005f64 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f66:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f6a:	0ff7f793          	andi	a5,a5,255
    80005f6e:	0207f793          	andi	a5,a5,32
    80005f72:	dbf5                	beqz	a5,80005f66 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f74:	0ff4f793          	andi	a5,s1,255
    80005f78:	10000737          	lui	a4,0x10000
    80005f7c:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f80:	00000097          	auipc	ra,0x0
    80005f84:	2ae080e7          	jalr	686(ra) # 8000622e <pop_off>
}
    80005f88:	60e2                	ld	ra,24(sp)
    80005f8a:	6442                	ld	s0,16(sp)
    80005f8c:	64a2                	ld	s1,8(sp)
    80005f8e:	6105                	addi	sp,sp,32
    80005f90:	8082                	ret

0000000080005f92 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f92:	00003717          	auipc	a4,0x3
    80005f96:	08e73703          	ld	a4,142(a4) # 80009020 <uart_tx_r>
    80005f9a:	00003797          	auipc	a5,0x3
    80005f9e:	08e7b783          	ld	a5,142(a5) # 80009028 <uart_tx_w>
    80005fa2:	06e78c63          	beq	a5,a4,8000601a <uartstart+0x88>
{
    80005fa6:	7139                	addi	sp,sp,-64
    80005fa8:	fc06                	sd	ra,56(sp)
    80005faa:	f822                	sd	s0,48(sp)
    80005fac:	f426                	sd	s1,40(sp)
    80005fae:	f04a                	sd	s2,32(sp)
    80005fb0:	ec4e                	sd	s3,24(sp)
    80005fb2:	e852                	sd	s4,16(sp)
    80005fb4:	e456                	sd	s5,8(sp)
    80005fb6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fb8:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fbc:	00024a17          	auipc	s4,0x24
    80005fc0:	24ca0a13          	addi	s4,s4,588 # 8002a208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fc4:	00003497          	auipc	s1,0x3
    80005fc8:	05c48493          	addi	s1,s1,92 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fcc:	00003997          	auipc	s3,0x3
    80005fd0:	05c98993          	addi	s3,s3,92 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fd4:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fd8:	0ff7f793          	andi	a5,a5,255
    80005fdc:	0207f793          	andi	a5,a5,32
    80005fe0:	c785                	beqz	a5,80006008 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fe2:	01f77793          	andi	a5,a4,31
    80005fe6:	97d2                	add	a5,a5,s4
    80005fe8:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005fec:	0705                	addi	a4,a4,1
    80005fee:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ff0:	8526                	mv	a0,s1
    80005ff2:	ffffb097          	auipc	ra,0xffffb
    80005ff6:	6ac080e7          	jalr	1708(ra) # 8000169e <wakeup>
    
    WriteReg(THR, c);
    80005ffa:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005ffe:	6098                	ld	a4,0(s1)
    80006000:	0009b783          	ld	a5,0(s3)
    80006004:	fce798e3          	bne	a5,a4,80005fd4 <uartstart+0x42>
  }
}
    80006008:	70e2                	ld	ra,56(sp)
    8000600a:	7442                	ld	s0,48(sp)
    8000600c:	74a2                	ld	s1,40(sp)
    8000600e:	7902                	ld	s2,32(sp)
    80006010:	69e2                	ld	s3,24(sp)
    80006012:	6a42                	ld	s4,16(sp)
    80006014:	6aa2                	ld	s5,8(sp)
    80006016:	6121                	addi	sp,sp,64
    80006018:	8082                	ret
    8000601a:	8082                	ret

000000008000601c <uartputc>:
{
    8000601c:	7179                	addi	sp,sp,-48
    8000601e:	f406                	sd	ra,40(sp)
    80006020:	f022                	sd	s0,32(sp)
    80006022:	ec26                	sd	s1,24(sp)
    80006024:	e84a                	sd	s2,16(sp)
    80006026:	e44e                	sd	s3,8(sp)
    80006028:	e052                	sd	s4,0(sp)
    8000602a:	1800                	addi	s0,sp,48
    8000602c:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    8000602e:	00024517          	auipc	a0,0x24
    80006032:	1da50513          	addi	a0,a0,474 # 8002a208 <uart_tx_lock>
    80006036:	00000097          	auipc	ra,0x0
    8000603a:	1a4080e7          	jalr	420(ra) # 800061da <acquire>
  if(panicked){
    8000603e:	00003797          	auipc	a5,0x3
    80006042:	fde7a783          	lw	a5,-34(a5) # 8000901c <panicked>
    80006046:	c391                	beqz	a5,8000604a <uartputc+0x2e>
    for(;;)
    80006048:	a001                	j	80006048 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000604a:	00003797          	auipc	a5,0x3
    8000604e:	fde7b783          	ld	a5,-34(a5) # 80009028 <uart_tx_w>
    80006052:	00003717          	auipc	a4,0x3
    80006056:	fce73703          	ld	a4,-50(a4) # 80009020 <uart_tx_r>
    8000605a:	02070713          	addi	a4,a4,32
    8000605e:	02f71b63          	bne	a4,a5,80006094 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006062:	00024a17          	auipc	s4,0x24
    80006066:	1a6a0a13          	addi	s4,s4,422 # 8002a208 <uart_tx_lock>
    8000606a:	00003497          	auipc	s1,0x3
    8000606e:	fb648493          	addi	s1,s1,-74 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006072:	00003917          	auipc	s2,0x3
    80006076:	fb690913          	addi	s2,s2,-74 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000607a:	85d2                	mv	a1,s4
    8000607c:	8526                	mv	a0,s1
    8000607e:	ffffb097          	auipc	ra,0xffffb
    80006082:	494080e7          	jalr	1172(ra) # 80001512 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006086:	00093783          	ld	a5,0(s2)
    8000608a:	6098                	ld	a4,0(s1)
    8000608c:	02070713          	addi	a4,a4,32
    80006090:	fef705e3          	beq	a4,a5,8000607a <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006094:	00024497          	auipc	s1,0x24
    80006098:	17448493          	addi	s1,s1,372 # 8002a208 <uart_tx_lock>
    8000609c:	01f7f713          	andi	a4,a5,31
    800060a0:	9726                	add	a4,a4,s1
    800060a2:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800060a6:	0785                	addi	a5,a5,1
    800060a8:	00003717          	auipc	a4,0x3
    800060ac:	f8f73023          	sd	a5,-128(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060b0:	00000097          	auipc	ra,0x0
    800060b4:	ee2080e7          	jalr	-286(ra) # 80005f92 <uartstart>
      release(&uart_tx_lock);
    800060b8:	8526                	mv	a0,s1
    800060ba:	00000097          	auipc	ra,0x0
    800060be:	1d4080e7          	jalr	468(ra) # 8000628e <release>
}
    800060c2:	70a2                	ld	ra,40(sp)
    800060c4:	7402                	ld	s0,32(sp)
    800060c6:	64e2                	ld	s1,24(sp)
    800060c8:	6942                	ld	s2,16(sp)
    800060ca:	69a2                	ld	s3,8(sp)
    800060cc:	6a02                	ld	s4,0(sp)
    800060ce:	6145                	addi	sp,sp,48
    800060d0:	8082                	ret

00000000800060d2 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060d2:	1141                	addi	sp,sp,-16
    800060d4:	e422                	sd	s0,8(sp)
    800060d6:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060d8:	100007b7          	lui	a5,0x10000
    800060dc:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060e0:	8b85                	andi	a5,a5,1
    800060e2:	cb91                	beqz	a5,800060f6 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060e4:	100007b7          	lui	a5,0x10000
    800060e8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060ec:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060f0:	6422                	ld	s0,8(sp)
    800060f2:	0141                	addi	sp,sp,16
    800060f4:	8082                	ret
    return -1;
    800060f6:	557d                	li	a0,-1
    800060f8:	bfe5                	j	800060f0 <uartgetc+0x1e>

00000000800060fa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060fa:	1101                	addi	sp,sp,-32
    800060fc:	ec06                	sd	ra,24(sp)
    800060fe:	e822                	sd	s0,16(sp)
    80006100:	e426                	sd	s1,8(sp)
    80006102:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006104:	54fd                	li	s1,-1
    int c = uartgetc();
    80006106:	00000097          	auipc	ra,0x0
    8000610a:	fcc080e7          	jalr	-52(ra) # 800060d2 <uartgetc>
    if(c == -1)
    8000610e:	00950763          	beq	a0,s1,8000611c <uartintr+0x22>
      break;
    consoleintr(c);
    80006112:	00000097          	auipc	ra,0x0
    80006116:	8b6080e7          	jalr	-1866(ra) # 800059c8 <consoleintr>
  while(1){
    8000611a:	b7f5                	j	80006106 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000611c:	00024497          	auipc	s1,0x24
    80006120:	0ec48493          	addi	s1,s1,236 # 8002a208 <uart_tx_lock>
    80006124:	8526                	mv	a0,s1
    80006126:	00000097          	auipc	ra,0x0
    8000612a:	0b4080e7          	jalr	180(ra) # 800061da <acquire>
  uartstart();
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	e64080e7          	jalr	-412(ra) # 80005f92 <uartstart>
  release(&uart_tx_lock);
    80006136:	8526                	mv	a0,s1
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	156080e7          	jalr	342(ra) # 8000628e <release>
}
    80006140:	60e2                	ld	ra,24(sp)
    80006142:	6442                	ld	s0,16(sp)
    80006144:	64a2                	ld	s1,8(sp)
    80006146:	6105                	addi	sp,sp,32
    80006148:	8082                	ret

000000008000614a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000614a:	1141                	addi	sp,sp,-16
    8000614c:	e422                	sd	s0,8(sp)
    8000614e:	0800                	addi	s0,sp,16
  lk->name = name;
    80006150:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006152:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006156:	00053823          	sd	zero,16(a0)
}
    8000615a:	6422                	ld	s0,8(sp)
    8000615c:	0141                	addi	sp,sp,16
    8000615e:	8082                	ret

0000000080006160 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006160:	411c                	lw	a5,0(a0)
    80006162:	e399                	bnez	a5,80006168 <holding+0x8>
    80006164:	4501                	li	a0,0
  return r;
}
    80006166:	8082                	ret
{
    80006168:	1101                	addi	sp,sp,-32
    8000616a:	ec06                	sd	ra,24(sp)
    8000616c:	e822                	sd	s0,16(sp)
    8000616e:	e426                	sd	s1,8(sp)
    80006170:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006172:	6904                	ld	s1,16(a0)
    80006174:	ffffb097          	auipc	ra,0xffffb
    80006178:	cb8080e7          	jalr	-840(ra) # 80000e2c <mycpu>
    8000617c:	40a48533          	sub	a0,s1,a0
    80006180:	00153513          	seqz	a0,a0
}
    80006184:	60e2                	ld	ra,24(sp)
    80006186:	6442                	ld	s0,16(sp)
    80006188:	64a2                	ld	s1,8(sp)
    8000618a:	6105                	addi	sp,sp,32
    8000618c:	8082                	ret

000000008000618e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000618e:	1101                	addi	sp,sp,-32
    80006190:	ec06                	sd	ra,24(sp)
    80006192:	e822                	sd	s0,16(sp)
    80006194:	e426                	sd	s1,8(sp)
    80006196:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006198:	100024f3          	csrr	s1,sstatus
    8000619c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061a0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061a2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061a6:	ffffb097          	auipc	ra,0xffffb
    800061aa:	c86080e7          	jalr	-890(ra) # 80000e2c <mycpu>
    800061ae:	5d3c                	lw	a5,120(a0)
    800061b0:	cf89                	beqz	a5,800061ca <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061b2:	ffffb097          	auipc	ra,0xffffb
    800061b6:	c7a080e7          	jalr	-902(ra) # 80000e2c <mycpu>
    800061ba:	5d3c                	lw	a5,120(a0)
    800061bc:	2785                	addiw	a5,a5,1
    800061be:	dd3c                	sw	a5,120(a0)
}
    800061c0:	60e2                	ld	ra,24(sp)
    800061c2:	6442                	ld	s0,16(sp)
    800061c4:	64a2                	ld	s1,8(sp)
    800061c6:	6105                	addi	sp,sp,32
    800061c8:	8082                	ret
    mycpu()->intena = old;
    800061ca:	ffffb097          	auipc	ra,0xffffb
    800061ce:	c62080e7          	jalr	-926(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061d2:	8085                	srli	s1,s1,0x1
    800061d4:	8885                	andi	s1,s1,1
    800061d6:	dd64                	sw	s1,124(a0)
    800061d8:	bfe9                	j	800061b2 <push_off+0x24>

00000000800061da <acquire>:
{
    800061da:	1101                	addi	sp,sp,-32
    800061dc:	ec06                	sd	ra,24(sp)
    800061de:	e822                	sd	s0,16(sp)
    800061e0:	e426                	sd	s1,8(sp)
    800061e2:	1000                	addi	s0,sp,32
    800061e4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	fa8080e7          	jalr	-88(ra) # 8000618e <push_off>
  if(holding(lk))
    800061ee:	8526                	mv	a0,s1
    800061f0:	00000097          	auipc	ra,0x0
    800061f4:	f70080e7          	jalr	-144(ra) # 80006160 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061f8:	4705                	li	a4,1
  if(holding(lk))
    800061fa:	e115                	bnez	a0,8000621e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061fc:	87ba                	mv	a5,a4
    800061fe:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006202:	2781                	sext.w	a5,a5
    80006204:	ffe5                	bnez	a5,800061fc <acquire+0x22>
  __sync_synchronize();
    80006206:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000620a:	ffffb097          	auipc	ra,0xffffb
    8000620e:	c22080e7          	jalr	-990(ra) # 80000e2c <mycpu>
    80006212:	e888                	sd	a0,16(s1)
}
    80006214:	60e2                	ld	ra,24(sp)
    80006216:	6442                	ld	s0,16(sp)
    80006218:	64a2                	ld	s1,8(sp)
    8000621a:	6105                	addi	sp,sp,32
    8000621c:	8082                	ret
    panic("acquire");
    8000621e:	00002517          	auipc	a0,0x2
    80006222:	5da50513          	addi	a0,a0,1498 # 800087f8 <digits+0x20>
    80006226:	00000097          	auipc	ra,0x0
    8000622a:	a94080e7          	jalr	-1388(ra) # 80005cba <panic>

000000008000622e <pop_off>:

void
pop_off(void)
{
    8000622e:	1141                	addi	sp,sp,-16
    80006230:	e406                	sd	ra,8(sp)
    80006232:	e022                	sd	s0,0(sp)
    80006234:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006236:	ffffb097          	auipc	ra,0xffffb
    8000623a:	bf6080e7          	jalr	-1034(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000623e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006242:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006244:	e78d                	bnez	a5,8000626e <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006246:	5d3c                	lw	a5,120(a0)
    80006248:	02f05b63          	blez	a5,8000627e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000624c:	37fd                	addiw	a5,a5,-1
    8000624e:	0007871b          	sext.w	a4,a5
    80006252:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006254:	eb09                	bnez	a4,80006266 <pop_off+0x38>
    80006256:	5d7c                	lw	a5,124(a0)
    80006258:	c799                	beqz	a5,80006266 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000625a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000625e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006262:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006266:	60a2                	ld	ra,8(sp)
    80006268:	6402                	ld	s0,0(sp)
    8000626a:	0141                	addi	sp,sp,16
    8000626c:	8082                	ret
    panic("pop_off - interruptible");
    8000626e:	00002517          	auipc	a0,0x2
    80006272:	59250513          	addi	a0,a0,1426 # 80008800 <digits+0x28>
    80006276:	00000097          	auipc	ra,0x0
    8000627a:	a44080e7          	jalr	-1468(ra) # 80005cba <panic>
    panic("pop_off");
    8000627e:	00002517          	auipc	a0,0x2
    80006282:	59a50513          	addi	a0,a0,1434 # 80008818 <digits+0x40>
    80006286:	00000097          	auipc	ra,0x0
    8000628a:	a34080e7          	jalr	-1484(ra) # 80005cba <panic>

000000008000628e <release>:
{
    8000628e:	1101                	addi	sp,sp,-32
    80006290:	ec06                	sd	ra,24(sp)
    80006292:	e822                	sd	s0,16(sp)
    80006294:	e426                	sd	s1,8(sp)
    80006296:	1000                	addi	s0,sp,32
    80006298:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000629a:	00000097          	auipc	ra,0x0
    8000629e:	ec6080e7          	jalr	-314(ra) # 80006160 <holding>
    800062a2:	c115                	beqz	a0,800062c6 <release+0x38>
  lk->cpu = 0;
    800062a4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062a8:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062ac:	0f50000f          	fence	iorw,ow
    800062b0:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062b4:	00000097          	auipc	ra,0x0
    800062b8:	f7a080e7          	jalr	-134(ra) # 8000622e <pop_off>
}
    800062bc:	60e2                	ld	ra,24(sp)
    800062be:	6442                	ld	s0,16(sp)
    800062c0:	64a2                	ld	s1,8(sp)
    800062c2:	6105                	addi	sp,sp,32
    800062c4:	8082                	ret
    panic("release");
    800062c6:	00002517          	auipc	a0,0x2
    800062ca:	55a50513          	addi	a0,a0,1370 # 80008820 <digits+0x48>
    800062ce:	00000097          	auipc	ra,0x0
    800062d2:	9ec080e7          	jalr	-1556(ra) # 80005cba <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
