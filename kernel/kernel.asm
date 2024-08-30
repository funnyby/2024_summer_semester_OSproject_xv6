
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8e013103          	ld	sp,-1824(sp) # 800088e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	113050ef          	jal	ra,80005928 <start>

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
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
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
    8000005e:	2c8080e7          	jalr	712(ra) # 80006322 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	368080e7          	jalr	872(ra) # 800063d6 <release>
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
    8000008e:	d4e080e7          	jalr	-690(ra) # 80005dd8 <panic>

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
    800000f8:	19e080e7          	jalr	414(ra) # 80006292 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
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
    80000130:	1f6080e7          	jalr	502(ra) # 80006322 <acquire>
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
    80000148:	292080e7          	jalr	658(ra) # 800063d6 <release>

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
    80000172:	268080e7          	jalr	616(ra) # 800063d6 <release>
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
    80000332:	bfe080e7          	jalr	-1026(ra) # 80000f2c <cpuid>
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
    8000034e:	be2080e7          	jalr	-1054(ra) # 80000f2c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	ac6080e7          	jalr	-1338(ra) # 80005e22 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	8be080e7          	jalr	-1858(ra) # 80001c2a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	f3c080e7          	jalr	-196(ra) # 800052b0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	16c080e7          	jalr	364(ra) # 800014e8 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	966080e7          	jalr	-1690(ra) # 80005cea <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	c7c080e7          	jalr	-900(ra) # 80006008 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	a86080e7          	jalr	-1402(ra) # 80005e22 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a76080e7          	jalr	-1418(ra) # 80005e22 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a66080e7          	jalr	-1434(ra) # 80005e22 <printf>
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
    800003e0:	aa2080e7          	jalr	-1374(ra) # 80000e7e <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	81e080e7          	jalr	-2018(ra) # 80001c02 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	83e080e7          	jalr	-1986(ra) # 80001c2a <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	ea6080e7          	jalr	-346(ra) # 8000529a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	eb4080e7          	jalr	-332(ra) # 800052b0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	07a080e7          	jalr	122(ra) # 8000247e <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	70a080e7          	jalr	1802(ra) # 80002b16 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	6b4080e7          	jalr	1716(ra) # 80003ac8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	fb6080e7          	jalr	-74(ra) # 800053d2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	e92080e7          	jalr	-366(ra) # 800012b6 <userinit>
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
    80000492:	94a080e7          	jalr	-1718(ra) # 80005dd8 <panic>
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
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	852080e7          	jalr	-1966(ra) # 80005dd8 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	842080e7          	jalr	-1982(ra) # 80005dd8 <panic>
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
    80000614:	7c8080e7          	jalr	1992(ra) # 80005dd8 <panic>

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
    800006dc:	712080e7          	jalr	1810(ra) # 80000dea <proc_mapstacks>
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
    80000760:	67c080e7          	jalr	1660(ra) # 80005dd8 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	66c080e7          	jalr	1644(ra) # 80005dd8 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	65c080e7          	jalr	1628(ra) # 80005dd8 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	64c080e7          	jalr	1612(ra) # 80005dd8 <panic>
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
    8000086e:	56e080e7          	jalr	1390(ra) # 80005dd8 <panic>

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
    800009b0:	42c080e7          	jalr	1068(ra) # 80005dd8 <panic>
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
    80000a8c:	350080e7          	jalr	848(ra) # 80005dd8 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	340080e7          	jalr	832(ra) # 80005dd8 <panic>
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
    80000b06:	2d6080e7          	jalr	726(ra) # 80005dd8 <panic>

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

0000000080000cd6 <vmprintwalk>:

// A function that prints the contents of a page table.

void
vmprintwalk(pagetable_t pagetable, int depth)
{
    80000cd6:	7159                	addi	sp,sp,-112
    80000cd8:	f486                	sd	ra,104(sp)
    80000cda:	f0a2                	sd	s0,96(sp)
    80000cdc:	eca6                	sd	s1,88(sp)
    80000cde:	e8ca                	sd	s2,80(sp)
    80000ce0:	e4ce                	sd	s3,72(sp)
    80000ce2:	e0d2                	sd	s4,64(sp)
    80000ce4:	fc56                	sd	s5,56(sp)
    80000ce6:	f85a                	sd	s6,48(sp)
    80000ce8:	f45e                	sd	s7,40(sp)
    80000cea:	f062                	sd	s8,32(sp)
    80000cec:	ec66                	sd	s9,24(sp)
    80000cee:	e86a                	sd	s10,16(sp)
    80000cf0:	e46e                	sd	s11,8(sp)
    80000cf2:	1880                	addi	s0,sp,112
    80000cf4:	89ae                	mv	s3,a1
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000cf6:	8b2a                	mv	s6,a0
    80000cf8:	4a01                	li	s4,0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000cfa:	4c05                	li	s8,1
      uint64 child = PTE2PA(pte);
      vmprintwalk((pagetable_t)child, depth+1);
    } else if(pte & PTE_V){
      for (int n = 0; n < depth; n++)
        printf(" ..");
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000cfc:	00007c97          	auipc	s9,0x7
    80000d00:	464c8c93          	addi	s9,s9,1124 # 80008160 <etext+0x160>
      for (int n = 0; n < depth; n++)
    80000d04:	4d01                	li	s10,0
        printf(" ..");
    80000d06:	00007a97          	auipc	s5,0x7
    80000d0a:	452a8a93          	addi	s5,s5,1106 # 80008158 <etext+0x158>
      vmprintwalk((pagetable_t)child, depth+1);
    80000d0e:	00158d9b          	addiw	s11,a1,1
  for(int i = 0; i < 512; i++){
    80000d12:	20000b93          	li	s7,512
    80000d16:	a8a1                	j	80000d6e <vmprintwalk+0x98>
      for (int n = 0; n < depth; n++)
    80000d18:	01305b63          	blez	s3,80000d2e <vmprintwalk+0x58>
    80000d1c:	84ea                	mv	s1,s10
        printf(" ..");
    80000d1e:	8556                	mv	a0,s5
    80000d20:	00005097          	auipc	ra,0x5
    80000d24:	102080e7          	jalr	258(ra) # 80005e22 <printf>
      for (int n = 0; n < depth; n++)
    80000d28:	2485                	addiw	s1,s1,1
    80000d2a:	fe999ae3          	bne	s3,s1,80000d1e <vmprintwalk+0x48>
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d2e:	00a95493          	srli	s1,s2,0xa
    80000d32:	04b2                	slli	s1,s1,0xc
    80000d34:	86a6                	mv	a3,s1
    80000d36:	864a                	mv	a2,s2
    80000d38:	85d2                	mv	a1,s4
    80000d3a:	8566                	mv	a0,s9
    80000d3c:	00005097          	auipc	ra,0x5
    80000d40:	0e6080e7          	jalr	230(ra) # 80005e22 <printf>
      vmprintwalk((pagetable_t)child, depth+1);
    80000d44:	85ee                	mv	a1,s11
    80000d46:	8526                	mv	a0,s1
    80000d48:	00000097          	auipc	ra,0x0
    80000d4c:	f8e080e7          	jalr	-114(ra) # 80000cd6 <vmprintwalk>
    80000d50:	a819                	j	80000d66 <vmprintwalk+0x90>
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d52:	00a95693          	srli	a3,s2,0xa
    80000d56:	06b2                	slli	a3,a3,0xc
    80000d58:	864a                	mv	a2,s2
    80000d5a:	85d2                	mv	a1,s4
    80000d5c:	8566                	mv	a0,s9
    80000d5e:	00005097          	auipc	ra,0x5
    80000d62:	0c4080e7          	jalr	196(ra) # 80005e22 <printf>
  for(int i = 0; i < 512; i++){
    80000d66:	2a05                	addiw	s4,s4,1
    80000d68:	0b21                	addi	s6,s6,8
    80000d6a:	037a0763          	beq	s4,s7,80000d98 <vmprintwalk+0xc2>
    pte_t pte = pagetable[i];
    80000d6e:	000b3903          	ld	s2,0(s6) # 1000 <_entry-0x7ffff000>
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d72:	00f97793          	andi	a5,s2,15
    80000d76:	fb8781e3          	beq	a5,s8,80000d18 <vmprintwalk+0x42>
    } else if(pte & PTE_V){
    80000d7a:	00197793          	andi	a5,s2,1
    80000d7e:	d7e5                	beqz	a5,80000d66 <vmprintwalk+0x90>
      for (int n = 0; n < depth; n++)
    80000d80:	fd3059e3          	blez	s3,80000d52 <vmprintwalk+0x7c>
    80000d84:	84ea                	mv	s1,s10
        printf(" ..");
    80000d86:	8556                	mv	a0,s5
    80000d88:	00005097          	auipc	ra,0x5
    80000d8c:	09a080e7          	jalr	154(ra) # 80005e22 <printf>
      for (int n = 0; n < depth; n++)
    80000d90:	2485                	addiw	s1,s1,1
    80000d92:	fe999ae3          	bne	s3,s1,80000d86 <vmprintwalk+0xb0>
    80000d96:	bf75                	j	80000d52 <vmprintwalk+0x7c>
    }
  }
}
    80000d98:	70a6                	ld	ra,104(sp)
    80000d9a:	7406                	ld	s0,96(sp)
    80000d9c:	64e6                	ld	s1,88(sp)
    80000d9e:	6946                	ld	s2,80(sp)
    80000da0:	69a6                	ld	s3,72(sp)
    80000da2:	6a06                	ld	s4,64(sp)
    80000da4:	7ae2                	ld	s5,56(sp)
    80000da6:	7b42                	ld	s6,48(sp)
    80000da8:	7ba2                	ld	s7,40(sp)
    80000daa:	7c02                	ld	s8,32(sp)
    80000dac:	6ce2                	ld	s9,24(sp)
    80000dae:	6d42                	ld	s10,16(sp)
    80000db0:	6da2                	ld	s11,8(sp)
    80000db2:	6165                	addi	sp,sp,112
    80000db4:	8082                	ret

0000000080000db6 <vmprint>:

void
vmprint(pagetable_t pagetable)
{
    80000db6:	1101                	addi	sp,sp,-32
    80000db8:	ec06                	sd	ra,24(sp)
    80000dba:	e822                	sd	s0,16(sp)
    80000dbc:	e426                	sd	s1,8(sp)
    80000dbe:	1000                	addi	s0,sp,32
    80000dc0:	84aa                	mv	s1,a0
  printf("page table %p\n",pagetable);
    80000dc2:	85aa                	mv	a1,a0
    80000dc4:	00007517          	auipc	a0,0x7
    80000dc8:	3b450513          	addi	a0,a0,948 # 80008178 <etext+0x178>
    80000dcc:	00005097          	auipc	ra,0x5
    80000dd0:	056080e7          	jalr	86(ra) # 80005e22 <printf>
  vmprintwalk(pagetable,1);
    80000dd4:	4585                	li	a1,1
    80000dd6:	8526                	mv	a0,s1
    80000dd8:	00000097          	auipc	ra,0x0
    80000ddc:	efe080e7          	jalr	-258(ra) # 80000cd6 <vmprintwalk>
    80000de0:	60e2                	ld	ra,24(sp)
    80000de2:	6442                	ld	s0,16(sp)
    80000de4:	64a2                	ld	s1,8(sp)
    80000de6:	6105                	addi	sp,sp,32
    80000de8:	8082                	ret

0000000080000dea <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000dea:	7139                	addi	sp,sp,-64
    80000dec:	fc06                	sd	ra,56(sp)
    80000dee:	f822                	sd	s0,48(sp)
    80000df0:	f426                	sd	s1,40(sp)
    80000df2:	f04a                	sd	s2,32(sp)
    80000df4:	ec4e                	sd	s3,24(sp)
    80000df6:	e852                	sd	s4,16(sp)
    80000df8:	e456                	sd	s5,8(sp)
    80000dfa:	e05a                	sd	s6,0(sp)
    80000dfc:	0080                	addi	s0,sp,64
    80000dfe:	89aa                	mv	s3,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	00008497          	auipc	s1,0x8
    80000e04:	68048493          	addi	s1,s1,1664 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e08:	8b26                	mv	s6,s1
    80000e0a:	00007a97          	auipc	s5,0x7
    80000e0e:	1f6a8a93          	addi	s5,s5,502 # 80008000 <etext>
    80000e12:	01000937          	lui	s2,0x1000
    80000e16:	197d                	addi	s2,s2,-1
    80000e18:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1a:	0000ea17          	auipc	s4,0xe
    80000e1e:	266a0a13          	addi	s4,s4,614 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000e22:	fffff097          	auipc	ra,0xfffff
    80000e26:	2f6080e7          	jalr	758(ra) # 80000118 <kalloc>
    80000e2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000e2c:	c129                	beqz	a0,80000e6e <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e2e:	416485b3          	sub	a1,s1,s6
    80000e32:	8591                	srai	a1,a1,0x4
    80000e34:	000ab783          	ld	a5,0(s5)
    80000e38:	02f585b3          	mul	a1,a1,a5
    80000e3c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e40:	4719                	li	a4,6
    80000e42:	6685                	lui	a3,0x1
    80000e44:	40b905b3          	sub	a1,s2,a1
    80000e48:	854e                	mv	a0,s3
    80000e4a:	fffff097          	auipc	ra,0xfffff
    80000e4e:	79e080e7          	jalr	1950(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e52:	17048493          	addi	s1,s1,368
    80000e56:	fd4496e3          	bne	s1,s4,80000e22 <proc_mapstacks+0x38>
  }
}
    80000e5a:	70e2                	ld	ra,56(sp)
    80000e5c:	7442                	ld	s0,48(sp)
    80000e5e:	74a2                	ld	s1,40(sp)
    80000e60:	7902                	ld	s2,32(sp)
    80000e62:	69e2                	ld	s3,24(sp)
    80000e64:	6a42                	ld	s4,16(sp)
    80000e66:	6aa2                	ld	s5,8(sp)
    80000e68:	6b02                	ld	s6,0(sp)
    80000e6a:	6121                	addi	sp,sp,64
    80000e6c:	8082                	ret
      panic("kalloc");
    80000e6e:	00007517          	auipc	a0,0x7
    80000e72:	31a50513          	addi	a0,a0,794 # 80008188 <etext+0x188>
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	f62080e7          	jalr	-158(ra) # 80005dd8 <panic>

0000000080000e7e <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e7e:	7139                	addi	sp,sp,-64
    80000e80:	fc06                	sd	ra,56(sp)
    80000e82:	f822                	sd	s0,48(sp)
    80000e84:	f426                	sd	s1,40(sp)
    80000e86:	f04a                	sd	s2,32(sp)
    80000e88:	ec4e                	sd	s3,24(sp)
    80000e8a:	e852                	sd	s4,16(sp)
    80000e8c:	e456                	sd	s5,8(sp)
    80000e8e:	e05a                	sd	s6,0(sp)
    80000e90:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000e92:	00007597          	auipc	a1,0x7
    80000e96:	2fe58593          	addi	a1,a1,766 # 80008190 <etext+0x190>
    80000e9a:	00008517          	auipc	a0,0x8
    80000e9e:	1b650513          	addi	a0,a0,438 # 80009050 <pid_lock>
    80000ea2:	00005097          	auipc	ra,0x5
    80000ea6:	3f0080e7          	jalr	1008(ra) # 80006292 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000eaa:	00007597          	auipc	a1,0x7
    80000eae:	2ee58593          	addi	a1,a1,750 # 80008198 <etext+0x198>
    80000eb2:	00008517          	auipc	a0,0x8
    80000eb6:	1b650513          	addi	a0,a0,438 # 80009068 <wait_lock>
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	3d8080e7          	jalr	984(ra) # 80006292 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ec2:	00008497          	auipc	s1,0x8
    80000ec6:	5be48493          	addi	s1,s1,1470 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000eca:	00007b17          	auipc	s6,0x7
    80000ece:	2deb0b13          	addi	s6,s6,734 # 800081a8 <etext+0x1a8>
      p->kstack = KSTACK((int) (p - proc));
    80000ed2:	8aa6                	mv	s5,s1
    80000ed4:	00007a17          	auipc	s4,0x7
    80000ed8:	12ca0a13          	addi	s4,s4,300 # 80008000 <etext>
    80000edc:	01000937          	lui	s2,0x1000
    80000ee0:	197d                	addi	s2,s2,-1
    80000ee2:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee4:	0000e997          	auipc	s3,0xe
    80000ee8:	19c98993          	addi	s3,s3,412 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000eec:	85da                	mv	a1,s6
    80000eee:	8526                	mv	a0,s1
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	3a2080e7          	jalr	930(ra) # 80006292 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ef8:	415487b3          	sub	a5,s1,s5
    80000efc:	8791                	srai	a5,a5,0x4
    80000efe:	000a3703          	ld	a4,0(s4)
    80000f02:	02e787b3          	mul	a5,a5,a4
    80000f06:	00d7979b          	slliw	a5,a5,0xd
    80000f0a:	40f907b3          	sub	a5,s2,a5
    80000f0e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f10:	17048493          	addi	s1,s1,368
    80000f14:	fd349ce3          	bne	s1,s3,80000eec <procinit+0x6e>
  }
}
    80000f18:	70e2                	ld	ra,56(sp)
    80000f1a:	7442                	ld	s0,48(sp)
    80000f1c:	74a2                	ld	s1,40(sp)
    80000f1e:	7902                	ld	s2,32(sp)
    80000f20:	69e2                	ld	s3,24(sp)
    80000f22:	6a42                	ld	s4,16(sp)
    80000f24:	6aa2                	ld	s5,8(sp)
    80000f26:	6b02                	ld	s6,0(sp)
    80000f28:	6121                	addi	sp,sp,64
    80000f2a:	8082                	ret

0000000080000f2c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f2c:	1141                	addi	sp,sp,-16
    80000f2e:	e422                	sd	s0,8(sp)
    80000f30:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f32:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f34:	2501                	sext.w	a0,a0
    80000f36:	6422                	ld	s0,8(sp)
    80000f38:	0141                	addi	sp,sp,16
    80000f3a:	8082                	ret

0000000080000f3c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f3c:	1141                	addi	sp,sp,-16
    80000f3e:	e422                	sd	s0,8(sp)
    80000f40:	0800                	addi	s0,sp,16
    80000f42:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f44:	2781                	sext.w	a5,a5
    80000f46:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f48:	00008517          	auipc	a0,0x8
    80000f4c:	13850513          	addi	a0,a0,312 # 80009080 <cpus>
    80000f50:	953e                	add	a0,a0,a5
    80000f52:	6422                	ld	s0,8(sp)
    80000f54:	0141                	addi	sp,sp,16
    80000f56:	8082                	ret

0000000080000f58 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f58:	1101                	addi	sp,sp,-32
    80000f5a:	ec06                	sd	ra,24(sp)
    80000f5c:	e822                	sd	s0,16(sp)
    80000f5e:	e426                	sd	s1,8(sp)
    80000f60:	1000                	addi	s0,sp,32
  push_off();
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	374080e7          	jalr	884(ra) # 800062d6 <push_off>
    80000f6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f6c:	2781                	sext.w	a5,a5
    80000f6e:	079e                	slli	a5,a5,0x7
    80000f70:	00008717          	auipc	a4,0x8
    80000f74:	0e070713          	addi	a4,a4,224 # 80009050 <pid_lock>
    80000f78:	97ba                	add	a5,a5,a4
    80000f7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f7c:	00005097          	auipc	ra,0x5
    80000f80:	3fa080e7          	jalr	1018(ra) # 80006376 <pop_off>
  return p;
}
    80000f84:	8526                	mv	a0,s1
    80000f86:	60e2                	ld	ra,24(sp)
    80000f88:	6442                	ld	s0,16(sp)
    80000f8a:	64a2                	ld	s1,8(sp)
    80000f8c:	6105                	addi	sp,sp,32
    80000f8e:	8082                	ret

0000000080000f90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f90:	1141                	addi	sp,sp,-16
    80000f92:	e406                	sd	ra,8(sp)
    80000f94:	e022                	sd	s0,0(sp)
    80000f96:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	fc0080e7          	jalr	-64(ra) # 80000f58 <myproc>
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	436080e7          	jalr	1078(ra) # 800063d6 <release>

  if (first) {
    80000fa8:	00008797          	auipc	a5,0x8
    80000fac:	8e87a783          	lw	a5,-1816(a5) # 80008890 <first.1675>
    80000fb0:	eb89                	bnez	a5,80000fc2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fb2:	00001097          	auipc	ra,0x1
    80000fb6:	c90080e7          	jalr	-880(ra) # 80001c42 <usertrapret>
}
    80000fba:	60a2                	ld	ra,8(sp)
    80000fbc:	6402                	ld	s0,0(sp)
    80000fbe:	0141                	addi	sp,sp,16
    80000fc0:	8082                	ret
    first = 0;
    80000fc2:	00008797          	auipc	a5,0x8
    80000fc6:	8c07a723          	sw	zero,-1842(a5) # 80008890 <first.1675>
    fsinit(ROOTDEV);
    80000fca:	4505                	li	a0,1
    80000fcc:	00002097          	auipc	ra,0x2
    80000fd0:	aca080e7          	jalr	-1334(ra) # 80002a96 <fsinit>
    80000fd4:	bff9                	j	80000fb2 <forkret+0x22>

0000000080000fd6 <allocpid>:
allocpid() {
    80000fd6:	1101                	addi	sp,sp,-32
    80000fd8:	ec06                	sd	ra,24(sp)
    80000fda:	e822                	sd	s0,16(sp)
    80000fdc:	e426                	sd	s1,8(sp)
    80000fde:	e04a                	sd	s2,0(sp)
    80000fe0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fe2:	00008917          	auipc	s2,0x8
    80000fe6:	06e90913          	addi	s2,s2,110 # 80009050 <pid_lock>
    80000fea:	854a                	mv	a0,s2
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	336080e7          	jalr	822(ra) # 80006322 <acquire>
  pid = nextpid;
    80000ff4:	00008797          	auipc	a5,0x8
    80000ff8:	8a078793          	addi	a5,a5,-1888 # 80008894 <nextpid>
    80000ffc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ffe:	0014871b          	addiw	a4,s1,1
    80001002:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001004:	854a                	mv	a0,s2
    80001006:	00005097          	auipc	ra,0x5
    8000100a:	3d0080e7          	jalr	976(ra) # 800063d6 <release>
}
    8000100e:	8526                	mv	a0,s1
    80001010:	60e2                	ld	ra,24(sp)
    80001012:	6442                	ld	s0,16(sp)
    80001014:	64a2                	ld	s1,8(sp)
    80001016:	6902                	ld	s2,0(sp)
    80001018:	6105                	addi	sp,sp,32
    8000101a:	8082                	ret

000000008000101c <proc_pagetable>:
{
    8000101c:	1101                	addi	sp,sp,-32
    8000101e:	ec06                	sd	ra,24(sp)
    80001020:	e822                	sd	s0,16(sp)
    80001022:	e426                	sd	s1,8(sp)
    80001024:	e04a                	sd	s2,0(sp)
    80001026:	1000                	addi	s0,sp,32
    80001028:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	7a8080e7          	jalr	1960(ra) # 800007d2 <uvmcreate>
    80001032:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001034:	cd39                	beqz	a0,80001092 <proc_pagetable+0x76>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80001036:	4749                	li	a4,18
    80001038:	16893683          	ld	a3,360(s2)
    8000103c:	6605                	lui	a2,0x1
    8000103e:	040005b7          	lui	a1,0x4000
    80001042:	15f5                	addi	a1,a1,-3
    80001044:	05b2                	slli	a1,a1,0xc
    80001046:	fffff097          	auipc	ra,0xfffff
    8000104a:	502080e7          	jalr	1282(ra) # 80000548 <mappages>
    8000104e:	04054963          	bltz	a0,800010a0 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001052:	4729                	li	a4,10
    80001054:	00006697          	auipc	a3,0x6
    80001058:	fac68693          	addi	a3,a3,-84 # 80007000 <_trampoline>
    8000105c:	6605                	lui	a2,0x1
    8000105e:	040005b7          	lui	a1,0x4000
    80001062:	15fd                	addi	a1,a1,-1
    80001064:	05b2                	slli	a1,a1,0xc
    80001066:	8526                	mv	a0,s1
    80001068:	fffff097          	auipc	ra,0xfffff
    8000106c:	4e0080e7          	jalr	1248(ra) # 80000548 <mappages>
    80001070:	04054063          	bltz	a0,800010b0 <proc_pagetable+0x94>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001074:	4719                	li	a4,6
    80001076:	05893683          	ld	a3,88(s2)
    8000107a:	6605                	lui	a2,0x1
    8000107c:	020005b7          	lui	a1,0x2000
    80001080:	15fd                	addi	a1,a1,-1
    80001082:	05b6                	slli	a1,a1,0xd
    80001084:	8526                	mv	a0,s1
    80001086:	fffff097          	auipc	ra,0xfffff
    8000108a:	4c2080e7          	jalr	1218(ra) # 80000548 <mappages>
    8000108e:	02054963          	bltz	a0,800010c0 <proc_pagetable+0xa4>
}
    80001092:	8526                	mv	a0,s1
    80001094:	60e2                	ld	ra,24(sp)
    80001096:	6442                	ld	s0,16(sp)
    80001098:	64a2                	ld	s1,8(sp)
    8000109a:	6902                	ld	s2,0(sp)
    8000109c:	6105                	addi	sp,sp,32
    8000109e:	8082                	ret
    uvmfree(pagetable, 0);
    800010a0:	4581                	li	a1,0
    800010a2:	8526                	mv	a0,s1
    800010a4:	00000097          	auipc	ra,0x0
    800010a8:	92a080e7          	jalr	-1750(ra) # 800009ce <uvmfree>
    return 0;
    800010ac:	4481                	li	s1,0
    800010ae:	b7d5                	j	80001092 <proc_pagetable+0x76>
    uvmfree(pagetable, 0);
    800010b0:	4581                	li	a1,0
    800010b2:	8526                	mv	a0,s1
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	91a080e7          	jalr	-1766(ra) # 800009ce <uvmfree>
    return 0;
    800010bc:	4481                	li	s1,0
    800010be:	bfd1                	j	80001092 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010c0:	4681                	li	a3,0
    800010c2:	4605                	li	a2,1
    800010c4:	040005b7          	lui	a1,0x4000
    800010c8:	15fd                	addi	a1,a1,-1
    800010ca:	05b2                	slli	a1,a1,0xc
    800010cc:	8526                	mv	a0,s1
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	640080e7          	jalr	1600(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    800010d6:	4581                	li	a1,0
    800010d8:	8526                	mv	a0,s1
    800010da:	00000097          	auipc	ra,0x0
    800010de:	8f4080e7          	jalr	-1804(ra) # 800009ce <uvmfree>
    return 0;
    800010e2:	4481                	li	s1,0
    800010e4:	b77d                	j	80001092 <proc_pagetable+0x76>

00000000800010e6 <proc_freepagetable>:
{
    800010e6:	7179                	addi	sp,sp,-48
    800010e8:	f406                	sd	ra,40(sp)
    800010ea:	f022                	sd	s0,32(sp)
    800010ec:	ec26                	sd	s1,24(sp)
    800010ee:	e84a                	sd	s2,16(sp)
    800010f0:	e44e                	sd	s3,8(sp)
    800010f2:	1800                	addi	s0,sp,48
    800010f4:	84aa                	mv	s1,a0
    800010f6:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010f8:	4681                	li	a3,0
    800010fa:	4605                	li	a2,1
    800010fc:	04000937          	lui	s2,0x4000
    80001100:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001104:	05b2                	slli	a1,a1,0xc
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	608080e7          	jalr	1544(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000110e:	4681                	li	a3,0
    80001110:	4605                	li	a2,1
    80001112:	020005b7          	lui	a1,0x2000
    80001116:	15fd                	addi	a1,a1,-1
    80001118:	05b6                	slli	a1,a1,0xd
    8000111a:	8526                	mv	a0,s1
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	5f2080e7          	jalr	1522(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0); // add
    80001124:	4681                	li	a3,0
    80001126:	4605                	li	a2,1
    80001128:	1975                	addi	s2,s2,-3
    8000112a:	00c91593          	slli	a1,s2,0xc
    8000112e:	8526                	mv	a0,s1
    80001130:	fffff097          	auipc	ra,0xfffff
    80001134:	5de080e7          	jalr	1502(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80001138:	85ce                	mv	a1,s3
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	892080e7          	jalr	-1902(ra) # 800009ce <uvmfree>
}
    80001144:	70a2                	ld	ra,40(sp)
    80001146:	7402                	ld	s0,32(sp)
    80001148:	64e2                	ld	s1,24(sp)
    8000114a:	6942                	ld	s2,16(sp)
    8000114c:	69a2                	ld	s3,8(sp)
    8000114e:	6145                	addi	sp,sp,48
    80001150:	8082                	ret

0000000080001152 <freeproc>:
{
    80001152:	1101                	addi	sp,sp,-32
    80001154:	ec06                	sd	ra,24(sp)
    80001156:	e822                	sd	s0,16(sp)
    80001158:	e426                	sd	s1,8(sp)
    8000115a:	1000                	addi	s0,sp,32
    8000115c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000115e:	6d28                	ld	a0,88(a0)
    80001160:	c509                	beqz	a0,8000116a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001162:	fffff097          	auipc	ra,0xfffff
    80001166:	eba080e7          	jalr	-326(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000116a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000116e:	68a8                	ld	a0,80(s1)
    80001170:	c511                	beqz	a0,8000117c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001172:	64ac                	ld	a1,72(s1)
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f72080e7          	jalr	-142(ra) # 800010e6 <proc_freepagetable>
  p->pagetable = 0;
    8000117c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001180:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001184:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001188:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000118c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001190:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001194:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001198:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000119c:	0004ac23          	sw	zero,24(s1)
  if(p->usyscall)
    800011a0:	1684b503          	ld	a0,360(s1)
    800011a4:	c509                	beqz	a0,800011ae <freeproc+0x5c>
    kfree((void*)p->usyscall);
    800011a6:	fffff097          	auipc	ra,0xfffff
    800011aa:	e76080e7          	jalr	-394(ra) # 8000001c <kfree>
  p->usyscall = 0;
    800011ae:	1604b423          	sd	zero,360(s1)
}
    800011b2:	60e2                	ld	ra,24(sp)
    800011b4:	6442                	ld	s0,16(sp)
    800011b6:	64a2                	ld	s1,8(sp)
    800011b8:	6105                	addi	sp,sp,32
    800011ba:	8082                	ret

00000000800011bc <allocproc>:
{
    800011bc:	1101                	addi	sp,sp,-32
    800011be:	ec06                	sd	ra,24(sp)
    800011c0:	e822                	sd	s0,16(sp)
    800011c2:	e426                	sd	s1,8(sp)
    800011c4:	e04a                	sd	s2,0(sp)
    800011c6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011c8:	00008497          	auipc	s1,0x8
    800011cc:	2b848493          	addi	s1,s1,696 # 80009480 <proc>
    800011d0:	0000e917          	auipc	s2,0xe
    800011d4:	eb090913          	addi	s2,s2,-336 # 8000f080 <tickslock>
    acquire(&p->lock);
    800011d8:	8526                	mv	a0,s1
    800011da:	00005097          	auipc	ra,0x5
    800011de:	148080e7          	jalr	328(ra) # 80006322 <acquire>
    if(p->state == UNUSED) {
    800011e2:	4c9c                	lw	a5,24(s1)
    800011e4:	cf81                	beqz	a5,800011fc <allocproc+0x40>
      release(&p->lock);
    800011e6:	8526                	mv	a0,s1
    800011e8:	00005097          	auipc	ra,0x5
    800011ec:	1ee080e7          	jalr	494(ra) # 800063d6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f0:	17048493          	addi	s1,s1,368
    800011f4:	ff2492e3          	bne	s1,s2,800011d8 <allocproc+0x1c>
  return 0;
    800011f8:	4481                	li	s1,0
    800011fa:	a09d                	j	80001260 <allocproc+0xa4>
  p->pid = allocpid();
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	dda080e7          	jalr	-550(ra) # 80000fd6 <allocpid>
    80001204:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001206:	4785                	li	a5,1
    80001208:	cc9c                	sw	a5,24(s1)
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    8000120a:	fffff097          	auipc	ra,0xfffff
    8000120e:	f0e080e7          	jalr	-242(ra) # 80000118 <kalloc>
    80001212:	892a                	mv	s2,a0
    80001214:	16a4b423          	sd	a0,360(s1)
    80001218:	c939                	beqz	a0,8000126e <allocproc+0xb2>
  p->usyscall->pid = p->pid;
    8000121a:	589c                	lw	a5,48(s1)
    8000121c:	c11c                	sw	a5,0(a0)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000121e:	fffff097          	auipc	ra,0xfffff
    80001222:	efa080e7          	jalr	-262(ra) # 80000118 <kalloc>
    80001226:	892a                	mv	s2,a0
    80001228:	eca8                	sd	a0,88(s1)
    8000122a:	cd31                	beqz	a0,80001286 <allocproc+0xca>
  p->pagetable = proc_pagetable(p);
    8000122c:	8526                	mv	a0,s1
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	dee080e7          	jalr	-530(ra) # 8000101c <proc_pagetable>
    80001236:	892a                	mv	s2,a0
    80001238:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000123a:	c135                	beqz	a0,8000129e <allocproc+0xe2>
  memset(&p->context, 0, sizeof(p->context));
    8000123c:	07000613          	li	a2,112
    80001240:	4581                	li	a1,0
    80001242:	06048513          	addi	a0,s1,96
    80001246:	fffff097          	auipc	ra,0xfffff
    8000124a:	f32080e7          	jalr	-206(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000124e:	00000797          	auipc	a5,0x0
    80001252:	d4278793          	addi	a5,a5,-702 # 80000f90 <forkret>
    80001256:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001258:	60bc                	ld	a5,64(s1)
    8000125a:	6705                	lui	a4,0x1
    8000125c:	97ba                	add	a5,a5,a4
    8000125e:	f4bc                	sd	a5,104(s1)
}
    80001260:	8526                	mv	a0,s1
    80001262:	60e2                	ld	ra,24(sp)
    80001264:	6442                	ld	s0,16(sp)
    80001266:	64a2                	ld	s1,8(sp)
    80001268:	6902                	ld	s2,0(sp)
    8000126a:	6105                	addi	sp,sp,32
    8000126c:	8082                	ret
    freeproc(p);
    8000126e:	8526                	mv	a0,s1
    80001270:	00000097          	auipc	ra,0x0
    80001274:	ee2080e7          	jalr	-286(ra) # 80001152 <freeproc>
    release(&p->lock);
    80001278:	8526                	mv	a0,s1
    8000127a:	00005097          	auipc	ra,0x5
    8000127e:	15c080e7          	jalr	348(ra) # 800063d6 <release>
    return 0;
    80001282:	84ca                	mv	s1,s2
    80001284:	bff1                	j	80001260 <allocproc+0xa4>
    freeproc(p);
    80001286:	8526                	mv	a0,s1
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	eca080e7          	jalr	-310(ra) # 80001152 <freeproc>
    release(&p->lock);
    80001290:	8526                	mv	a0,s1
    80001292:	00005097          	auipc	ra,0x5
    80001296:	144080e7          	jalr	324(ra) # 800063d6 <release>
    return 0;
    8000129a:	84ca                	mv	s1,s2
    8000129c:	b7d1                	j	80001260 <allocproc+0xa4>
    freeproc(p);
    8000129e:	8526                	mv	a0,s1
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	eb2080e7          	jalr	-334(ra) # 80001152 <freeproc>
    release(&p->lock);
    800012a8:	8526                	mv	a0,s1
    800012aa:	00005097          	auipc	ra,0x5
    800012ae:	12c080e7          	jalr	300(ra) # 800063d6 <release>
    return 0;
    800012b2:	84ca                	mv	s1,s2
    800012b4:	b775                	j	80001260 <allocproc+0xa4>

00000000800012b6 <userinit>:
{
    800012b6:	1101                	addi	sp,sp,-32
    800012b8:	ec06                	sd	ra,24(sp)
    800012ba:	e822                	sd	s0,16(sp)
    800012bc:	e426                	sd	s1,8(sp)
    800012be:	1000                	addi	s0,sp,32
  p = allocproc();
    800012c0:	00000097          	auipc	ra,0x0
    800012c4:	efc080e7          	jalr	-260(ra) # 800011bc <allocproc>
    800012c8:	84aa                	mv	s1,a0
  initproc = p;
    800012ca:	00008797          	auipc	a5,0x8
    800012ce:	d4a7b323          	sd	a0,-698(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012d2:	03400613          	li	a2,52
    800012d6:	00007597          	auipc	a1,0x7
    800012da:	5ca58593          	addi	a1,a1,1482 # 800088a0 <initcode>
    800012de:	6928                	ld	a0,80(a0)
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	520080e7          	jalr	1312(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    800012e8:	6785                	lui	a5,0x1
    800012ea:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012ec:	6cb8                	ld	a4,88(s1)
    800012ee:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012f2:	6cb8                	ld	a4,88(s1)
    800012f4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012f6:	4641                	li	a2,16
    800012f8:	00007597          	auipc	a1,0x7
    800012fc:	eb858593          	addi	a1,a1,-328 # 800081b0 <etext+0x1b0>
    80001300:	15848513          	addi	a0,s1,344
    80001304:	fffff097          	auipc	ra,0xfffff
    80001308:	fc6080e7          	jalr	-58(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000130c:	00007517          	auipc	a0,0x7
    80001310:	eb450513          	addi	a0,a0,-332 # 800081c0 <etext+0x1c0>
    80001314:	00002097          	auipc	ra,0x2
    80001318:	1b0080e7          	jalr	432(ra) # 800034c4 <namei>
    8000131c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001320:	478d                	li	a5,3
    80001322:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001324:	8526                	mv	a0,s1
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	0b0080e7          	jalr	176(ra) # 800063d6 <release>
}
    8000132e:	60e2                	ld	ra,24(sp)
    80001330:	6442                	ld	s0,16(sp)
    80001332:	64a2                	ld	s1,8(sp)
    80001334:	6105                	addi	sp,sp,32
    80001336:	8082                	ret

0000000080001338 <growproc>:
{
    80001338:	1101                	addi	sp,sp,-32
    8000133a:	ec06                	sd	ra,24(sp)
    8000133c:	e822                	sd	s0,16(sp)
    8000133e:	e426                	sd	s1,8(sp)
    80001340:	e04a                	sd	s2,0(sp)
    80001342:	1000                	addi	s0,sp,32
    80001344:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001346:	00000097          	auipc	ra,0x0
    8000134a:	c12080e7          	jalr	-1006(ra) # 80000f58 <myproc>
    8000134e:	892a                	mv	s2,a0
  sz = p->sz;
    80001350:	652c                	ld	a1,72(a0)
    80001352:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001356:	00904f63          	bgtz	s1,80001374 <growproc+0x3c>
  } else if(n < 0){
    8000135a:	0204cc63          	bltz	s1,80001392 <growproc+0x5a>
  p->sz = sz;
    8000135e:	1602                	slli	a2,a2,0x20
    80001360:	9201                	srli	a2,a2,0x20
    80001362:	04c93423          	sd	a2,72(s2)
  return 0;
    80001366:	4501                	li	a0,0
}
    80001368:	60e2                	ld	ra,24(sp)
    8000136a:	6442                	ld	s0,16(sp)
    8000136c:	64a2                	ld	s1,8(sp)
    8000136e:	6902                	ld	s2,0(sp)
    80001370:	6105                	addi	sp,sp,32
    80001372:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001374:	9e25                	addw	a2,a2,s1
    80001376:	1602                	slli	a2,a2,0x20
    80001378:	9201                	srli	a2,a2,0x20
    8000137a:	1582                	slli	a1,a1,0x20
    8000137c:	9181                	srli	a1,a1,0x20
    8000137e:	6928                	ld	a0,80(a0)
    80001380:	fffff097          	auipc	ra,0xfffff
    80001384:	53a080e7          	jalr	1338(ra) # 800008ba <uvmalloc>
    80001388:	0005061b          	sext.w	a2,a0
    8000138c:	fa69                	bnez	a2,8000135e <growproc+0x26>
      return -1;
    8000138e:	557d                	li	a0,-1
    80001390:	bfe1                	j	80001368 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001392:	9e25                	addw	a2,a2,s1
    80001394:	1602                	slli	a2,a2,0x20
    80001396:	9201                	srli	a2,a2,0x20
    80001398:	1582                	slli	a1,a1,0x20
    8000139a:	9181                	srli	a1,a1,0x20
    8000139c:	6928                	ld	a0,80(a0)
    8000139e:	fffff097          	auipc	ra,0xfffff
    800013a2:	4d4080e7          	jalr	1236(ra) # 80000872 <uvmdealloc>
    800013a6:	0005061b          	sext.w	a2,a0
    800013aa:	bf55                	j	8000135e <growproc+0x26>

00000000800013ac <fork>:
{
    800013ac:	7179                	addi	sp,sp,-48
    800013ae:	f406                	sd	ra,40(sp)
    800013b0:	f022                	sd	s0,32(sp)
    800013b2:	ec26                	sd	s1,24(sp)
    800013b4:	e84a                	sd	s2,16(sp)
    800013b6:	e44e                	sd	s3,8(sp)
    800013b8:	e052                	sd	s4,0(sp)
    800013ba:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013bc:	00000097          	auipc	ra,0x0
    800013c0:	b9c080e7          	jalr	-1124(ra) # 80000f58 <myproc>
    800013c4:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	df6080e7          	jalr	-522(ra) # 800011bc <allocproc>
    800013ce:	10050b63          	beqz	a0,800014e4 <fork+0x138>
    800013d2:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013d4:	04893603          	ld	a2,72(s2)
    800013d8:	692c                	ld	a1,80(a0)
    800013da:	05093503          	ld	a0,80(s2)
    800013de:	fffff097          	auipc	ra,0xfffff
    800013e2:	628080e7          	jalr	1576(ra) # 80000a06 <uvmcopy>
    800013e6:	04054663          	bltz	a0,80001432 <fork+0x86>
  np->sz = p->sz;
    800013ea:	04893783          	ld	a5,72(s2)
    800013ee:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800013f2:	05893683          	ld	a3,88(s2)
    800013f6:	87b6                	mv	a5,a3
    800013f8:	0589b703          	ld	a4,88(s3)
    800013fc:	12068693          	addi	a3,a3,288
    80001400:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001404:	6788                	ld	a0,8(a5)
    80001406:	6b8c                	ld	a1,16(a5)
    80001408:	6f90                	ld	a2,24(a5)
    8000140a:	01073023          	sd	a6,0(a4)
    8000140e:	e708                	sd	a0,8(a4)
    80001410:	eb0c                	sd	a1,16(a4)
    80001412:	ef10                	sd	a2,24(a4)
    80001414:	02078793          	addi	a5,a5,32
    80001418:	02070713          	addi	a4,a4,32
    8000141c:	fed792e3          	bne	a5,a3,80001400 <fork+0x54>
  np->trapframe->a0 = 0;
    80001420:	0589b783          	ld	a5,88(s3)
    80001424:	0607b823          	sd	zero,112(a5)
    80001428:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000142c:	15000a13          	li	s4,336
    80001430:	a03d                	j	8000145e <fork+0xb2>
    freeproc(np);
    80001432:	854e                	mv	a0,s3
    80001434:	00000097          	auipc	ra,0x0
    80001438:	d1e080e7          	jalr	-738(ra) # 80001152 <freeproc>
    release(&np->lock);
    8000143c:	854e                	mv	a0,s3
    8000143e:	00005097          	auipc	ra,0x5
    80001442:	f98080e7          	jalr	-104(ra) # 800063d6 <release>
    return -1;
    80001446:	5a7d                	li	s4,-1
    80001448:	a069                	j	800014d2 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000144a:	00002097          	auipc	ra,0x2
    8000144e:	710080e7          	jalr	1808(ra) # 80003b5a <filedup>
    80001452:	009987b3          	add	a5,s3,s1
    80001456:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001458:	04a1                	addi	s1,s1,8
    8000145a:	01448763          	beq	s1,s4,80001468 <fork+0xbc>
    if(p->ofile[i])
    8000145e:	009907b3          	add	a5,s2,s1
    80001462:	6388                	ld	a0,0(a5)
    80001464:	f17d                	bnez	a0,8000144a <fork+0x9e>
    80001466:	bfcd                	j	80001458 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001468:	15093503          	ld	a0,336(s2)
    8000146c:	00002097          	auipc	ra,0x2
    80001470:	864080e7          	jalr	-1948(ra) # 80002cd0 <idup>
    80001474:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001478:	4641                	li	a2,16
    8000147a:	15890593          	addi	a1,s2,344
    8000147e:	15898513          	addi	a0,s3,344
    80001482:	fffff097          	auipc	ra,0xfffff
    80001486:	e48080e7          	jalr	-440(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    8000148a:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000148e:	854e                	mv	a0,s3
    80001490:	00005097          	auipc	ra,0x5
    80001494:	f46080e7          	jalr	-186(ra) # 800063d6 <release>
  acquire(&wait_lock);
    80001498:	00008497          	auipc	s1,0x8
    8000149c:	bd048493          	addi	s1,s1,-1072 # 80009068 <wait_lock>
    800014a0:	8526                	mv	a0,s1
    800014a2:	00005097          	auipc	ra,0x5
    800014a6:	e80080e7          	jalr	-384(ra) # 80006322 <acquire>
  np->parent = p;
    800014aa:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014ae:	8526                	mv	a0,s1
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	f26080e7          	jalr	-218(ra) # 800063d6 <release>
  acquire(&np->lock);
    800014b8:	854e                	mv	a0,s3
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	e68080e7          	jalr	-408(ra) # 80006322 <acquire>
  np->state = RUNNABLE;
    800014c2:	478d                	li	a5,3
    800014c4:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014c8:	854e                	mv	a0,s3
    800014ca:	00005097          	auipc	ra,0x5
    800014ce:	f0c080e7          	jalr	-244(ra) # 800063d6 <release>
}
    800014d2:	8552                	mv	a0,s4
    800014d4:	70a2                	ld	ra,40(sp)
    800014d6:	7402                	ld	s0,32(sp)
    800014d8:	64e2                	ld	s1,24(sp)
    800014da:	6942                	ld	s2,16(sp)
    800014dc:	69a2                	ld	s3,8(sp)
    800014de:	6a02                	ld	s4,0(sp)
    800014e0:	6145                	addi	sp,sp,48
    800014e2:	8082                	ret
    return -1;
    800014e4:	5a7d                	li	s4,-1
    800014e6:	b7f5                	j	800014d2 <fork+0x126>

00000000800014e8 <scheduler>:
{
    800014e8:	7139                	addi	sp,sp,-64
    800014ea:	fc06                	sd	ra,56(sp)
    800014ec:	f822                	sd	s0,48(sp)
    800014ee:	f426                	sd	s1,40(sp)
    800014f0:	f04a                	sd	s2,32(sp)
    800014f2:	ec4e                	sd	s3,24(sp)
    800014f4:	e852                	sd	s4,16(sp)
    800014f6:	e456                	sd	s5,8(sp)
    800014f8:	e05a                	sd	s6,0(sp)
    800014fa:	0080                	addi	s0,sp,64
    800014fc:	8792                	mv	a5,tp
  int id = r_tp();
    800014fe:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001500:	00779a93          	slli	s5,a5,0x7
    80001504:	00008717          	auipc	a4,0x8
    80001508:	b4c70713          	addi	a4,a4,-1204 # 80009050 <pid_lock>
    8000150c:	9756                	add	a4,a4,s5
    8000150e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001512:	00008717          	auipc	a4,0x8
    80001516:	b7670713          	addi	a4,a4,-1162 # 80009088 <cpus+0x8>
    8000151a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000151c:	498d                	li	s3,3
        p->state = RUNNING;
    8000151e:	4b11                	li	s6,4
        c->proc = p;
    80001520:	079e                	slli	a5,a5,0x7
    80001522:	00008a17          	auipc	s4,0x8
    80001526:	b2ea0a13          	addi	s4,s4,-1234 # 80009050 <pid_lock>
    8000152a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000152c:	0000e917          	auipc	s2,0xe
    80001530:	b5490913          	addi	s2,s2,-1196 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001534:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001538:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000153c:	10079073          	csrw	sstatus,a5
    80001540:	00008497          	auipc	s1,0x8
    80001544:	f4048493          	addi	s1,s1,-192 # 80009480 <proc>
    80001548:	a03d                	j	80001576 <scheduler+0x8e>
        p->state = RUNNING;
    8000154a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000154e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001552:	06048593          	addi	a1,s1,96
    80001556:	8556                	mv	a0,s5
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	640080e7          	jalr	1600(ra) # 80001b98 <swtch>
        c->proc = 0;
    80001560:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001564:	8526                	mv	a0,s1
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	e70080e7          	jalr	-400(ra) # 800063d6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000156e:	17048493          	addi	s1,s1,368
    80001572:	fd2481e3          	beq	s1,s2,80001534 <scheduler+0x4c>
      acquire(&p->lock);
    80001576:	8526                	mv	a0,s1
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	daa080e7          	jalr	-598(ra) # 80006322 <acquire>
      if(p->state == RUNNABLE) {
    80001580:	4c9c                	lw	a5,24(s1)
    80001582:	ff3791e3          	bne	a5,s3,80001564 <scheduler+0x7c>
    80001586:	b7d1                	j	8000154a <scheduler+0x62>

0000000080001588 <sched>:
{
    80001588:	7179                	addi	sp,sp,-48
    8000158a:	f406                	sd	ra,40(sp)
    8000158c:	f022                	sd	s0,32(sp)
    8000158e:	ec26                	sd	s1,24(sp)
    80001590:	e84a                	sd	s2,16(sp)
    80001592:	e44e                	sd	s3,8(sp)
    80001594:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	9c2080e7          	jalr	-1598(ra) # 80000f58 <myproc>
    8000159e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	d08080e7          	jalr	-760(ra) # 800062a8 <holding>
    800015a8:	c93d                	beqz	a0,8000161e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015aa:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015ac:	2781                	sext.w	a5,a5
    800015ae:	079e                	slli	a5,a5,0x7
    800015b0:	00008717          	auipc	a4,0x8
    800015b4:	aa070713          	addi	a4,a4,-1376 # 80009050 <pid_lock>
    800015b8:	97ba                	add	a5,a5,a4
    800015ba:	0a87a703          	lw	a4,168(a5)
    800015be:	4785                	li	a5,1
    800015c0:	06f71763          	bne	a4,a5,8000162e <sched+0xa6>
  if(p->state == RUNNING)
    800015c4:	4c98                	lw	a4,24(s1)
    800015c6:	4791                	li	a5,4
    800015c8:	06f70b63          	beq	a4,a5,8000163e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015cc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015d0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015d2:	efb5                	bnez	a5,8000164e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015d4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015d6:	00008917          	auipc	s2,0x8
    800015da:	a7a90913          	addi	s2,s2,-1414 # 80009050 <pid_lock>
    800015de:	2781                	sext.w	a5,a5
    800015e0:	079e                	slli	a5,a5,0x7
    800015e2:	97ca                	add	a5,a5,s2
    800015e4:	0ac7a983          	lw	s3,172(a5)
    800015e8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015ea:	2781                	sext.w	a5,a5
    800015ec:	079e                	slli	a5,a5,0x7
    800015ee:	00008597          	auipc	a1,0x8
    800015f2:	a9a58593          	addi	a1,a1,-1382 # 80009088 <cpus+0x8>
    800015f6:	95be                	add	a1,a1,a5
    800015f8:	06048513          	addi	a0,s1,96
    800015fc:	00000097          	auipc	ra,0x0
    80001600:	59c080e7          	jalr	1436(ra) # 80001b98 <swtch>
    80001604:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001606:	2781                	sext.w	a5,a5
    80001608:	079e                	slli	a5,a5,0x7
    8000160a:	97ca                	add	a5,a5,s2
    8000160c:	0b37a623          	sw	s3,172(a5)
}
    80001610:	70a2                	ld	ra,40(sp)
    80001612:	7402                	ld	s0,32(sp)
    80001614:	64e2                	ld	s1,24(sp)
    80001616:	6942                	ld	s2,16(sp)
    80001618:	69a2                	ld	s3,8(sp)
    8000161a:	6145                	addi	sp,sp,48
    8000161c:	8082                	ret
    panic("sched p->lock");
    8000161e:	00007517          	auipc	a0,0x7
    80001622:	baa50513          	addi	a0,a0,-1110 # 800081c8 <etext+0x1c8>
    80001626:	00004097          	auipc	ra,0x4
    8000162a:	7b2080e7          	jalr	1970(ra) # 80005dd8 <panic>
    panic("sched locks");
    8000162e:	00007517          	auipc	a0,0x7
    80001632:	baa50513          	addi	a0,a0,-1110 # 800081d8 <etext+0x1d8>
    80001636:	00004097          	auipc	ra,0x4
    8000163a:	7a2080e7          	jalr	1954(ra) # 80005dd8 <panic>
    panic("sched running");
    8000163e:	00007517          	auipc	a0,0x7
    80001642:	baa50513          	addi	a0,a0,-1110 # 800081e8 <etext+0x1e8>
    80001646:	00004097          	auipc	ra,0x4
    8000164a:	792080e7          	jalr	1938(ra) # 80005dd8 <panic>
    panic("sched interruptible");
    8000164e:	00007517          	auipc	a0,0x7
    80001652:	baa50513          	addi	a0,a0,-1110 # 800081f8 <etext+0x1f8>
    80001656:	00004097          	auipc	ra,0x4
    8000165a:	782080e7          	jalr	1922(ra) # 80005dd8 <panic>

000000008000165e <yield>:
{
    8000165e:	1101                	addi	sp,sp,-32
    80001660:	ec06                	sd	ra,24(sp)
    80001662:	e822                	sd	s0,16(sp)
    80001664:	e426                	sd	s1,8(sp)
    80001666:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001668:	00000097          	auipc	ra,0x0
    8000166c:	8f0080e7          	jalr	-1808(ra) # 80000f58 <myproc>
    80001670:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001672:	00005097          	auipc	ra,0x5
    80001676:	cb0080e7          	jalr	-848(ra) # 80006322 <acquire>
  p->state = RUNNABLE;
    8000167a:	478d                	li	a5,3
    8000167c:	cc9c                	sw	a5,24(s1)
  sched();
    8000167e:	00000097          	auipc	ra,0x0
    80001682:	f0a080e7          	jalr	-246(ra) # 80001588 <sched>
  release(&p->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	00005097          	auipc	ra,0x5
    8000168c:	d4e080e7          	jalr	-690(ra) # 800063d6 <release>
}
    80001690:	60e2                	ld	ra,24(sp)
    80001692:	6442                	ld	s0,16(sp)
    80001694:	64a2                	ld	s1,8(sp)
    80001696:	6105                	addi	sp,sp,32
    80001698:	8082                	ret

000000008000169a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000169a:	7179                	addi	sp,sp,-48
    8000169c:	f406                	sd	ra,40(sp)
    8000169e:	f022                	sd	s0,32(sp)
    800016a0:	ec26                	sd	s1,24(sp)
    800016a2:	e84a                	sd	s2,16(sp)
    800016a4:	e44e                	sd	s3,8(sp)
    800016a6:	1800                	addi	s0,sp,48
    800016a8:	89aa                	mv	s3,a0
    800016aa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016ac:	00000097          	auipc	ra,0x0
    800016b0:	8ac080e7          	jalr	-1876(ra) # 80000f58 <myproc>
    800016b4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016b6:	00005097          	auipc	ra,0x5
    800016ba:	c6c080e7          	jalr	-916(ra) # 80006322 <acquire>
  release(lk);
    800016be:	854a                	mv	a0,s2
    800016c0:	00005097          	auipc	ra,0x5
    800016c4:	d16080e7          	jalr	-746(ra) # 800063d6 <release>

  // Go to sleep.
  p->chan = chan;
    800016c8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016cc:	4789                	li	a5,2
    800016ce:	cc9c                	sw	a5,24(s1)

  sched();
    800016d0:	00000097          	auipc	ra,0x0
    800016d4:	eb8080e7          	jalr	-328(ra) # 80001588 <sched>

  // Tidy up.
  p->chan = 0;
    800016d8:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016dc:	8526                	mv	a0,s1
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	cf8080e7          	jalr	-776(ra) # 800063d6 <release>
  acquire(lk);
    800016e6:	854a                	mv	a0,s2
    800016e8:	00005097          	auipc	ra,0x5
    800016ec:	c3a080e7          	jalr	-966(ra) # 80006322 <acquire>
}
    800016f0:	70a2                	ld	ra,40(sp)
    800016f2:	7402                	ld	s0,32(sp)
    800016f4:	64e2                	ld	s1,24(sp)
    800016f6:	6942                	ld	s2,16(sp)
    800016f8:	69a2                	ld	s3,8(sp)
    800016fa:	6145                	addi	sp,sp,48
    800016fc:	8082                	ret

00000000800016fe <wait>:
{
    800016fe:	715d                	addi	sp,sp,-80
    80001700:	e486                	sd	ra,72(sp)
    80001702:	e0a2                	sd	s0,64(sp)
    80001704:	fc26                	sd	s1,56(sp)
    80001706:	f84a                	sd	s2,48(sp)
    80001708:	f44e                	sd	s3,40(sp)
    8000170a:	f052                	sd	s4,32(sp)
    8000170c:	ec56                	sd	s5,24(sp)
    8000170e:	e85a                	sd	s6,16(sp)
    80001710:	e45e                	sd	s7,8(sp)
    80001712:	e062                	sd	s8,0(sp)
    80001714:	0880                	addi	s0,sp,80
    80001716:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001718:	00000097          	auipc	ra,0x0
    8000171c:	840080e7          	jalr	-1984(ra) # 80000f58 <myproc>
    80001720:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001722:	00008517          	auipc	a0,0x8
    80001726:	94650513          	addi	a0,a0,-1722 # 80009068 <wait_lock>
    8000172a:	00005097          	auipc	ra,0x5
    8000172e:	bf8080e7          	jalr	-1032(ra) # 80006322 <acquire>
    havekids = 0;
    80001732:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001734:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001736:	0000e997          	auipc	s3,0xe
    8000173a:	94a98993          	addi	s3,s3,-1718 # 8000f080 <tickslock>
        havekids = 1;
    8000173e:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001740:	00008c17          	auipc	s8,0x8
    80001744:	928c0c13          	addi	s8,s8,-1752 # 80009068 <wait_lock>
    havekids = 0;
    80001748:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000174a:	00008497          	auipc	s1,0x8
    8000174e:	d3648493          	addi	s1,s1,-714 # 80009480 <proc>
    80001752:	a0bd                	j	800017c0 <wait+0xc2>
          pid = np->pid;
    80001754:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001758:	000b0e63          	beqz	s6,80001774 <wait+0x76>
    8000175c:	4691                	li	a3,4
    8000175e:	02c48613          	addi	a2,s1,44
    80001762:	85da                	mv	a1,s6
    80001764:	05093503          	ld	a0,80(s2)
    80001768:	fffff097          	auipc	ra,0xfffff
    8000176c:	3a2080e7          	jalr	930(ra) # 80000b0a <copyout>
    80001770:	02054563          	bltz	a0,8000179a <wait+0x9c>
          freeproc(np);
    80001774:	8526                	mv	a0,s1
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	9dc080e7          	jalr	-1572(ra) # 80001152 <freeproc>
          release(&np->lock);
    8000177e:	8526                	mv	a0,s1
    80001780:	00005097          	auipc	ra,0x5
    80001784:	c56080e7          	jalr	-938(ra) # 800063d6 <release>
          release(&wait_lock);
    80001788:	00008517          	auipc	a0,0x8
    8000178c:	8e050513          	addi	a0,a0,-1824 # 80009068 <wait_lock>
    80001790:	00005097          	auipc	ra,0x5
    80001794:	c46080e7          	jalr	-954(ra) # 800063d6 <release>
          return pid;
    80001798:	a09d                	j	800017fe <wait+0x100>
            release(&np->lock);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00005097          	auipc	ra,0x5
    800017a0:	c3a080e7          	jalr	-966(ra) # 800063d6 <release>
            release(&wait_lock);
    800017a4:	00008517          	auipc	a0,0x8
    800017a8:	8c450513          	addi	a0,a0,-1852 # 80009068 <wait_lock>
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	c2a080e7          	jalr	-982(ra) # 800063d6 <release>
            return -1;
    800017b4:	59fd                	li	s3,-1
    800017b6:	a0a1                	j	800017fe <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017b8:	17048493          	addi	s1,s1,368
    800017bc:	03348463          	beq	s1,s3,800017e4 <wait+0xe6>
      if(np->parent == p){
    800017c0:	7c9c                	ld	a5,56(s1)
    800017c2:	ff279be3          	bne	a5,s2,800017b8 <wait+0xba>
        acquire(&np->lock);
    800017c6:	8526                	mv	a0,s1
    800017c8:	00005097          	auipc	ra,0x5
    800017cc:	b5a080e7          	jalr	-1190(ra) # 80006322 <acquire>
        if(np->state == ZOMBIE){
    800017d0:	4c9c                	lw	a5,24(s1)
    800017d2:	f94781e3          	beq	a5,s4,80001754 <wait+0x56>
        release(&np->lock);
    800017d6:	8526                	mv	a0,s1
    800017d8:	00005097          	auipc	ra,0x5
    800017dc:	bfe080e7          	jalr	-1026(ra) # 800063d6 <release>
        havekids = 1;
    800017e0:	8756                	mv	a4,s5
    800017e2:	bfd9                	j	800017b8 <wait+0xba>
    if(!havekids || p->killed){
    800017e4:	c701                	beqz	a4,800017ec <wait+0xee>
    800017e6:	02892783          	lw	a5,40(s2)
    800017ea:	c79d                	beqz	a5,80001818 <wait+0x11a>
      release(&wait_lock);
    800017ec:	00008517          	auipc	a0,0x8
    800017f0:	87c50513          	addi	a0,a0,-1924 # 80009068 <wait_lock>
    800017f4:	00005097          	auipc	ra,0x5
    800017f8:	be2080e7          	jalr	-1054(ra) # 800063d6 <release>
      return -1;
    800017fc:	59fd                	li	s3,-1
}
    800017fe:	854e                	mv	a0,s3
    80001800:	60a6                	ld	ra,72(sp)
    80001802:	6406                	ld	s0,64(sp)
    80001804:	74e2                	ld	s1,56(sp)
    80001806:	7942                	ld	s2,48(sp)
    80001808:	79a2                	ld	s3,40(sp)
    8000180a:	7a02                	ld	s4,32(sp)
    8000180c:	6ae2                	ld	s5,24(sp)
    8000180e:	6b42                	ld	s6,16(sp)
    80001810:	6ba2                	ld	s7,8(sp)
    80001812:	6c02                	ld	s8,0(sp)
    80001814:	6161                	addi	sp,sp,80
    80001816:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001818:	85e2                	mv	a1,s8
    8000181a:	854a                	mv	a0,s2
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	e7e080e7          	jalr	-386(ra) # 8000169a <sleep>
    havekids = 0;
    80001824:	b715                	j	80001748 <wait+0x4a>

0000000080001826 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001826:	7139                	addi	sp,sp,-64
    80001828:	fc06                	sd	ra,56(sp)
    8000182a:	f822                	sd	s0,48(sp)
    8000182c:	f426                	sd	s1,40(sp)
    8000182e:	f04a                	sd	s2,32(sp)
    80001830:	ec4e                	sd	s3,24(sp)
    80001832:	e852                	sd	s4,16(sp)
    80001834:	e456                	sd	s5,8(sp)
    80001836:	0080                	addi	s0,sp,64
    80001838:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000183a:	00008497          	auipc	s1,0x8
    8000183e:	c4648493          	addi	s1,s1,-954 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001842:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001844:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001846:	0000e917          	auipc	s2,0xe
    8000184a:	83a90913          	addi	s2,s2,-1990 # 8000f080 <tickslock>
    8000184e:	a821                	j	80001866 <wakeup+0x40>
        p->state = RUNNABLE;
    80001850:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001854:	8526                	mv	a0,s1
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	b80080e7          	jalr	-1152(ra) # 800063d6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185e:	17048493          	addi	s1,s1,368
    80001862:	03248463          	beq	s1,s2,8000188a <wakeup+0x64>
    if(p != myproc()){
    80001866:	fffff097          	auipc	ra,0xfffff
    8000186a:	6f2080e7          	jalr	1778(ra) # 80000f58 <myproc>
    8000186e:	fea488e3          	beq	s1,a0,8000185e <wakeup+0x38>
      acquire(&p->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	aae080e7          	jalr	-1362(ra) # 80006322 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000187c:	4c9c                	lw	a5,24(s1)
    8000187e:	fd379be3          	bne	a5,s3,80001854 <wakeup+0x2e>
    80001882:	709c                	ld	a5,32(s1)
    80001884:	fd4798e3          	bne	a5,s4,80001854 <wakeup+0x2e>
    80001888:	b7e1                	j	80001850 <wakeup+0x2a>
    }
  }
}
    8000188a:	70e2                	ld	ra,56(sp)
    8000188c:	7442                	ld	s0,48(sp)
    8000188e:	74a2                	ld	s1,40(sp)
    80001890:	7902                	ld	s2,32(sp)
    80001892:	69e2                	ld	s3,24(sp)
    80001894:	6a42                	ld	s4,16(sp)
    80001896:	6aa2                	ld	s5,8(sp)
    80001898:	6121                	addi	sp,sp,64
    8000189a:	8082                	ret

000000008000189c <reparent>:
{
    8000189c:	7179                	addi	sp,sp,-48
    8000189e:	f406                	sd	ra,40(sp)
    800018a0:	f022                	sd	s0,32(sp)
    800018a2:	ec26                	sd	s1,24(sp)
    800018a4:	e84a                	sd	s2,16(sp)
    800018a6:	e44e                	sd	s3,8(sp)
    800018a8:	e052                	sd	s4,0(sp)
    800018aa:	1800                	addi	s0,sp,48
    800018ac:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018ae:	00008497          	auipc	s1,0x8
    800018b2:	bd248493          	addi	s1,s1,-1070 # 80009480 <proc>
      pp->parent = initproc;
    800018b6:	00007a17          	auipc	s4,0x7
    800018ba:	75aa0a13          	addi	s4,s4,1882 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018be:	0000d997          	auipc	s3,0xd
    800018c2:	7c298993          	addi	s3,s3,1986 # 8000f080 <tickslock>
    800018c6:	a029                	j	800018d0 <reparent+0x34>
    800018c8:	17048493          	addi	s1,s1,368
    800018cc:	01348d63          	beq	s1,s3,800018e6 <reparent+0x4a>
    if(pp->parent == p){
    800018d0:	7c9c                	ld	a5,56(s1)
    800018d2:	ff279be3          	bne	a5,s2,800018c8 <reparent+0x2c>
      pp->parent = initproc;
    800018d6:	000a3503          	ld	a0,0(s4)
    800018da:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018dc:	00000097          	auipc	ra,0x0
    800018e0:	f4a080e7          	jalr	-182(ra) # 80001826 <wakeup>
    800018e4:	b7d5                	j	800018c8 <reparent+0x2c>
}
    800018e6:	70a2                	ld	ra,40(sp)
    800018e8:	7402                	ld	s0,32(sp)
    800018ea:	64e2                	ld	s1,24(sp)
    800018ec:	6942                	ld	s2,16(sp)
    800018ee:	69a2                	ld	s3,8(sp)
    800018f0:	6a02                	ld	s4,0(sp)
    800018f2:	6145                	addi	sp,sp,48
    800018f4:	8082                	ret

00000000800018f6 <exit>:
{
    800018f6:	7179                	addi	sp,sp,-48
    800018f8:	f406                	sd	ra,40(sp)
    800018fa:	f022                	sd	s0,32(sp)
    800018fc:	ec26                	sd	s1,24(sp)
    800018fe:	e84a                	sd	s2,16(sp)
    80001900:	e44e                	sd	s3,8(sp)
    80001902:	e052                	sd	s4,0(sp)
    80001904:	1800                	addi	s0,sp,48
    80001906:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	650080e7          	jalr	1616(ra) # 80000f58 <myproc>
    80001910:	89aa                	mv	s3,a0
  if(p == initproc)
    80001912:	00007797          	auipc	a5,0x7
    80001916:	6fe7b783          	ld	a5,1790(a5) # 80009010 <initproc>
    8000191a:	0d050493          	addi	s1,a0,208
    8000191e:	15050913          	addi	s2,a0,336
    80001922:	02a79363          	bne	a5,a0,80001948 <exit+0x52>
    panic("init exiting");
    80001926:	00007517          	auipc	a0,0x7
    8000192a:	8ea50513          	addi	a0,a0,-1814 # 80008210 <etext+0x210>
    8000192e:	00004097          	auipc	ra,0x4
    80001932:	4aa080e7          	jalr	1194(ra) # 80005dd8 <panic>
      fileclose(f);
    80001936:	00002097          	auipc	ra,0x2
    8000193a:	276080e7          	jalr	630(ra) # 80003bac <fileclose>
      p->ofile[fd] = 0;
    8000193e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001942:	04a1                	addi	s1,s1,8
    80001944:	01248563          	beq	s1,s2,8000194e <exit+0x58>
    if(p->ofile[fd]){
    80001948:	6088                	ld	a0,0(s1)
    8000194a:	f575                	bnez	a0,80001936 <exit+0x40>
    8000194c:	bfdd                	j	80001942 <exit+0x4c>
  begin_op();
    8000194e:	00002097          	auipc	ra,0x2
    80001952:	d92080e7          	jalr	-622(ra) # 800036e0 <begin_op>
  iput(p->cwd);
    80001956:	1509b503          	ld	a0,336(s3)
    8000195a:	00001097          	auipc	ra,0x1
    8000195e:	56e080e7          	jalr	1390(ra) # 80002ec8 <iput>
  end_op();
    80001962:	00002097          	auipc	ra,0x2
    80001966:	dfe080e7          	jalr	-514(ra) # 80003760 <end_op>
  p->cwd = 0;
    8000196a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000196e:	00007497          	auipc	s1,0x7
    80001972:	6fa48493          	addi	s1,s1,1786 # 80009068 <wait_lock>
    80001976:	8526                	mv	a0,s1
    80001978:	00005097          	auipc	ra,0x5
    8000197c:	9aa080e7          	jalr	-1622(ra) # 80006322 <acquire>
  reparent(p);
    80001980:	854e                	mv	a0,s3
    80001982:	00000097          	auipc	ra,0x0
    80001986:	f1a080e7          	jalr	-230(ra) # 8000189c <reparent>
  wakeup(p->parent);
    8000198a:	0389b503          	ld	a0,56(s3)
    8000198e:	00000097          	auipc	ra,0x0
    80001992:	e98080e7          	jalr	-360(ra) # 80001826 <wakeup>
  acquire(&p->lock);
    80001996:	854e                	mv	a0,s3
    80001998:	00005097          	auipc	ra,0x5
    8000199c:	98a080e7          	jalr	-1654(ra) # 80006322 <acquire>
  p->xstate = status;
    800019a0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019a4:	4795                	li	a5,5
    800019a6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019aa:	8526                	mv	a0,s1
    800019ac:	00005097          	auipc	ra,0x5
    800019b0:	a2a080e7          	jalr	-1494(ra) # 800063d6 <release>
  sched();
    800019b4:	00000097          	auipc	ra,0x0
    800019b8:	bd4080e7          	jalr	-1068(ra) # 80001588 <sched>
  panic("zombie exit");
    800019bc:	00007517          	auipc	a0,0x7
    800019c0:	86450513          	addi	a0,a0,-1948 # 80008220 <etext+0x220>
    800019c4:	00004097          	auipc	ra,0x4
    800019c8:	414080e7          	jalr	1044(ra) # 80005dd8 <panic>

00000000800019cc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019cc:	7179                	addi	sp,sp,-48
    800019ce:	f406                	sd	ra,40(sp)
    800019d0:	f022                	sd	s0,32(sp)
    800019d2:	ec26                	sd	s1,24(sp)
    800019d4:	e84a                	sd	s2,16(sp)
    800019d6:	e44e                	sd	s3,8(sp)
    800019d8:	1800                	addi	s0,sp,48
    800019da:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019dc:	00008497          	auipc	s1,0x8
    800019e0:	aa448493          	addi	s1,s1,-1372 # 80009480 <proc>
    800019e4:	0000d997          	auipc	s3,0xd
    800019e8:	69c98993          	addi	s3,s3,1692 # 8000f080 <tickslock>
    acquire(&p->lock);
    800019ec:	8526                	mv	a0,s1
    800019ee:	00005097          	auipc	ra,0x5
    800019f2:	934080e7          	jalr	-1740(ra) # 80006322 <acquire>
    if(p->pid == pid){
    800019f6:	589c                	lw	a5,48(s1)
    800019f8:	01278d63          	beq	a5,s2,80001a12 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019fc:	8526                	mv	a0,s1
    800019fe:	00005097          	auipc	ra,0x5
    80001a02:	9d8080e7          	jalr	-1576(ra) # 800063d6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a06:	17048493          	addi	s1,s1,368
    80001a0a:	ff3491e3          	bne	s1,s3,800019ec <kill+0x20>
  }
  return -1;
    80001a0e:	557d                	li	a0,-1
    80001a10:	a829                	j	80001a2a <kill+0x5e>
      p->killed = 1;
    80001a12:	4785                	li	a5,1
    80001a14:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a16:	4c98                	lw	a4,24(s1)
    80001a18:	4789                	li	a5,2
    80001a1a:	00f70f63          	beq	a4,a5,80001a38 <kill+0x6c>
      release(&p->lock);
    80001a1e:	8526                	mv	a0,s1
    80001a20:	00005097          	auipc	ra,0x5
    80001a24:	9b6080e7          	jalr	-1610(ra) # 800063d6 <release>
      return 0;
    80001a28:	4501                	li	a0,0
}
    80001a2a:	70a2                	ld	ra,40(sp)
    80001a2c:	7402                	ld	s0,32(sp)
    80001a2e:	64e2                	ld	s1,24(sp)
    80001a30:	6942                	ld	s2,16(sp)
    80001a32:	69a2                	ld	s3,8(sp)
    80001a34:	6145                	addi	sp,sp,48
    80001a36:	8082                	ret
        p->state = RUNNABLE;
    80001a38:	478d                	li	a5,3
    80001a3a:	cc9c                	sw	a5,24(s1)
    80001a3c:	b7cd                	j	80001a1e <kill+0x52>

0000000080001a3e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a3e:	7179                	addi	sp,sp,-48
    80001a40:	f406                	sd	ra,40(sp)
    80001a42:	f022                	sd	s0,32(sp)
    80001a44:	ec26                	sd	s1,24(sp)
    80001a46:	e84a                	sd	s2,16(sp)
    80001a48:	e44e                	sd	s3,8(sp)
    80001a4a:	e052                	sd	s4,0(sp)
    80001a4c:	1800                	addi	s0,sp,48
    80001a4e:	84aa                	mv	s1,a0
    80001a50:	892e                	mv	s2,a1
    80001a52:	89b2                	mv	s3,a2
    80001a54:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a56:	fffff097          	auipc	ra,0xfffff
    80001a5a:	502080e7          	jalr	1282(ra) # 80000f58 <myproc>
  if(user_dst){
    80001a5e:	c08d                	beqz	s1,80001a80 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a60:	86d2                	mv	a3,s4
    80001a62:	864e                	mv	a2,s3
    80001a64:	85ca                	mv	a1,s2
    80001a66:	6928                	ld	a0,80(a0)
    80001a68:	fffff097          	auipc	ra,0xfffff
    80001a6c:	0a2080e7          	jalr	162(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a70:	70a2                	ld	ra,40(sp)
    80001a72:	7402                	ld	s0,32(sp)
    80001a74:	64e2                	ld	s1,24(sp)
    80001a76:	6942                	ld	s2,16(sp)
    80001a78:	69a2                	ld	s3,8(sp)
    80001a7a:	6a02                	ld	s4,0(sp)
    80001a7c:	6145                	addi	sp,sp,48
    80001a7e:	8082                	ret
    memmove((char *)dst, src, len);
    80001a80:	000a061b          	sext.w	a2,s4
    80001a84:	85ce                	mv	a1,s3
    80001a86:	854a                	mv	a0,s2
    80001a88:	ffffe097          	auipc	ra,0xffffe
    80001a8c:	750080e7          	jalr	1872(ra) # 800001d8 <memmove>
    return 0;
    80001a90:	8526                	mv	a0,s1
    80001a92:	bff9                	j	80001a70 <either_copyout+0x32>

0000000080001a94 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a94:	7179                	addi	sp,sp,-48
    80001a96:	f406                	sd	ra,40(sp)
    80001a98:	f022                	sd	s0,32(sp)
    80001a9a:	ec26                	sd	s1,24(sp)
    80001a9c:	e84a                	sd	s2,16(sp)
    80001a9e:	e44e                	sd	s3,8(sp)
    80001aa0:	e052                	sd	s4,0(sp)
    80001aa2:	1800                	addi	s0,sp,48
    80001aa4:	892a                	mv	s2,a0
    80001aa6:	84ae                	mv	s1,a1
    80001aa8:	89b2                	mv	s3,a2
    80001aaa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aac:	fffff097          	auipc	ra,0xfffff
    80001ab0:	4ac080e7          	jalr	1196(ra) # 80000f58 <myproc>
  if(user_src){
    80001ab4:	c08d                	beqz	s1,80001ad6 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ab6:	86d2                	mv	a3,s4
    80001ab8:	864e                	mv	a2,s3
    80001aba:	85ca                	mv	a1,s2
    80001abc:	6928                	ld	a0,80(a0)
    80001abe:	fffff097          	auipc	ra,0xfffff
    80001ac2:	0d8080e7          	jalr	216(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001ac6:	70a2                	ld	ra,40(sp)
    80001ac8:	7402                	ld	s0,32(sp)
    80001aca:	64e2                	ld	s1,24(sp)
    80001acc:	6942                	ld	s2,16(sp)
    80001ace:	69a2                	ld	s3,8(sp)
    80001ad0:	6a02                	ld	s4,0(sp)
    80001ad2:	6145                	addi	sp,sp,48
    80001ad4:	8082                	ret
    memmove(dst, (char*)src, len);
    80001ad6:	000a061b          	sext.w	a2,s4
    80001ada:	85ce                	mv	a1,s3
    80001adc:	854a                	mv	a0,s2
    80001ade:	ffffe097          	auipc	ra,0xffffe
    80001ae2:	6fa080e7          	jalr	1786(ra) # 800001d8 <memmove>
    return 0;
    80001ae6:	8526                	mv	a0,s1
    80001ae8:	bff9                	j	80001ac6 <either_copyin+0x32>

0000000080001aea <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001aea:	715d                	addi	sp,sp,-80
    80001aec:	e486                	sd	ra,72(sp)
    80001aee:	e0a2                	sd	s0,64(sp)
    80001af0:	fc26                	sd	s1,56(sp)
    80001af2:	f84a                	sd	s2,48(sp)
    80001af4:	f44e                	sd	s3,40(sp)
    80001af6:	f052                	sd	s4,32(sp)
    80001af8:	ec56                	sd	s5,24(sp)
    80001afa:	e85a                	sd	s6,16(sp)
    80001afc:	e45e                	sd	s7,8(sp)
    80001afe:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b00:	00006517          	auipc	a0,0x6
    80001b04:	54850513          	addi	a0,a0,1352 # 80008048 <etext+0x48>
    80001b08:	00004097          	auipc	ra,0x4
    80001b0c:	31a080e7          	jalr	794(ra) # 80005e22 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b10:	00008497          	auipc	s1,0x8
    80001b14:	ac848493          	addi	s1,s1,-1336 # 800095d8 <proc+0x158>
    80001b18:	0000d917          	auipc	s2,0xd
    80001b1c:	6c090913          	addi	s2,s2,1728 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b20:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b22:	00006997          	auipc	s3,0x6
    80001b26:	70e98993          	addi	s3,s3,1806 # 80008230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    80001b2a:	00006a97          	auipc	s5,0x6
    80001b2e:	70ea8a93          	addi	s5,s5,1806 # 80008238 <etext+0x238>
    printf("\n");
    80001b32:	00006a17          	auipc	s4,0x6
    80001b36:	516a0a13          	addi	s4,s4,1302 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b3a:	00006b97          	auipc	s7,0x6
    80001b3e:	736b8b93          	addi	s7,s7,1846 # 80008270 <states.1712>
    80001b42:	a00d                	j	80001b64 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b44:	ed86a583          	lw	a1,-296(a3)
    80001b48:	8556                	mv	a0,s5
    80001b4a:	00004097          	auipc	ra,0x4
    80001b4e:	2d8080e7          	jalr	728(ra) # 80005e22 <printf>
    printf("\n");
    80001b52:	8552                	mv	a0,s4
    80001b54:	00004097          	auipc	ra,0x4
    80001b58:	2ce080e7          	jalr	718(ra) # 80005e22 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b5c:	17048493          	addi	s1,s1,368
    80001b60:	03248163          	beq	s1,s2,80001b82 <procdump+0x98>
    if(p->state == UNUSED)
    80001b64:	86a6                	mv	a3,s1
    80001b66:	ec04a783          	lw	a5,-320(s1)
    80001b6a:	dbed                	beqz	a5,80001b5c <procdump+0x72>
      state = "???";
    80001b6c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b6e:	fcfb6be3          	bltu	s6,a5,80001b44 <procdump+0x5a>
    80001b72:	1782                	slli	a5,a5,0x20
    80001b74:	9381                	srli	a5,a5,0x20
    80001b76:	078e                	slli	a5,a5,0x3
    80001b78:	97de                	add	a5,a5,s7
    80001b7a:	6390                	ld	a2,0(a5)
    80001b7c:	f661                	bnez	a2,80001b44 <procdump+0x5a>
      state = "???";
    80001b7e:	864e                	mv	a2,s3
    80001b80:	b7d1                	j	80001b44 <procdump+0x5a>
  }
    80001b82:	60a6                	ld	ra,72(sp)
    80001b84:	6406                	ld	s0,64(sp)
    80001b86:	74e2                	ld	s1,56(sp)
    80001b88:	7942                	ld	s2,48(sp)
    80001b8a:	79a2                	ld	s3,40(sp)
    80001b8c:	7a02                	ld	s4,32(sp)
    80001b8e:	6ae2                	ld	s5,24(sp)
    80001b90:	6b42                	ld	s6,16(sp)
    80001b92:	6ba2                	ld	s7,8(sp)
    80001b94:	6161                	addi	sp,sp,80
    80001b96:	8082                	ret

0000000080001b98 <swtch>:
    80001b98:	00153023          	sd	ra,0(a0)
    80001b9c:	00253423          	sd	sp,8(a0)
    80001ba0:	e900                	sd	s0,16(a0)
    80001ba2:	ed04                	sd	s1,24(a0)
    80001ba4:	03253023          	sd	s2,32(a0)
    80001ba8:	03353423          	sd	s3,40(a0)
    80001bac:	03453823          	sd	s4,48(a0)
    80001bb0:	03553c23          	sd	s5,56(a0)
    80001bb4:	05653023          	sd	s6,64(a0)
    80001bb8:	05753423          	sd	s7,72(a0)
    80001bbc:	05853823          	sd	s8,80(a0)
    80001bc0:	05953c23          	sd	s9,88(a0)
    80001bc4:	07a53023          	sd	s10,96(a0)
    80001bc8:	07b53423          	sd	s11,104(a0)
    80001bcc:	0005b083          	ld	ra,0(a1)
    80001bd0:	0085b103          	ld	sp,8(a1)
    80001bd4:	6980                	ld	s0,16(a1)
    80001bd6:	6d84                	ld	s1,24(a1)
    80001bd8:	0205b903          	ld	s2,32(a1)
    80001bdc:	0285b983          	ld	s3,40(a1)
    80001be0:	0305ba03          	ld	s4,48(a1)
    80001be4:	0385ba83          	ld	s5,56(a1)
    80001be8:	0405bb03          	ld	s6,64(a1)
    80001bec:	0485bb83          	ld	s7,72(a1)
    80001bf0:	0505bc03          	ld	s8,80(a1)
    80001bf4:	0585bc83          	ld	s9,88(a1)
    80001bf8:	0605bd03          	ld	s10,96(a1)
    80001bfc:	0685bd83          	ld	s11,104(a1)
    80001c00:	8082                	ret

0000000080001c02 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c02:	1141                	addi	sp,sp,-16
    80001c04:	e406                	sd	ra,8(sp)
    80001c06:	e022                	sd	s0,0(sp)
    80001c08:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c0a:	00006597          	auipc	a1,0x6
    80001c0e:	69658593          	addi	a1,a1,1686 # 800082a0 <states.1712+0x30>
    80001c12:	0000d517          	auipc	a0,0xd
    80001c16:	46e50513          	addi	a0,a0,1134 # 8000f080 <tickslock>
    80001c1a:	00004097          	auipc	ra,0x4
    80001c1e:	678080e7          	jalr	1656(ra) # 80006292 <initlock>
}
    80001c22:	60a2                	ld	ra,8(sp)
    80001c24:	6402                	ld	s0,0(sp)
    80001c26:	0141                	addi	sp,sp,16
    80001c28:	8082                	ret

0000000080001c2a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c2a:	1141                	addi	sp,sp,-16
    80001c2c:	e422                	sd	s0,8(sp)
    80001c2e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c30:	00003797          	auipc	a5,0x3
    80001c34:	5b078793          	addi	a5,a5,1456 # 800051e0 <kernelvec>
    80001c38:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c3c:	6422                	ld	s0,8(sp)
    80001c3e:	0141                	addi	sp,sp,16
    80001c40:	8082                	ret

0000000080001c42 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c42:	1141                	addi	sp,sp,-16
    80001c44:	e406                	sd	ra,8(sp)
    80001c46:	e022                	sd	s0,0(sp)
    80001c48:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	30e080e7          	jalr	782(ra) # 80000f58 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c56:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c58:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c5c:	00005617          	auipc	a2,0x5
    80001c60:	3a460613          	addi	a2,a2,932 # 80007000 <_trampoline>
    80001c64:	00005697          	auipc	a3,0x5
    80001c68:	39c68693          	addi	a3,a3,924 # 80007000 <_trampoline>
    80001c6c:	8e91                	sub	a3,a3,a2
    80001c6e:	040007b7          	lui	a5,0x4000
    80001c72:	17fd                	addi	a5,a5,-1
    80001c74:	07b2                	slli	a5,a5,0xc
    80001c76:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c78:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c7c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c7e:	180026f3          	csrr	a3,satp
    80001c82:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c84:	6d38                	ld	a4,88(a0)
    80001c86:	6134                	ld	a3,64(a0)
    80001c88:	6585                	lui	a1,0x1
    80001c8a:	96ae                	add	a3,a3,a1
    80001c8c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c8e:	6d38                	ld	a4,88(a0)
    80001c90:	00000697          	auipc	a3,0x0
    80001c94:	13868693          	addi	a3,a3,312 # 80001dc8 <usertrap>
    80001c98:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c9a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c9c:	8692                	mv	a3,tp
    80001c9e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ca4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001ca8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cac:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cb0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cb2:	6f18                	ld	a4,24(a4)
    80001cb4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cb8:	692c                	ld	a1,80(a0)
    80001cba:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cbc:	00005717          	auipc	a4,0x5
    80001cc0:	3d470713          	addi	a4,a4,980 # 80007090 <userret>
    80001cc4:	8f11                	sub	a4,a4,a2
    80001cc6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cc8:	577d                	li	a4,-1
    80001cca:	177e                	slli	a4,a4,0x3f
    80001ccc:	8dd9                	or	a1,a1,a4
    80001cce:	02000537          	lui	a0,0x2000
    80001cd2:	157d                	addi	a0,a0,-1
    80001cd4:	0536                	slli	a0,a0,0xd
    80001cd6:	9782                	jalr	a5
}
    80001cd8:	60a2                	ld	ra,8(sp)
    80001cda:	6402                	ld	s0,0(sp)
    80001cdc:	0141                	addi	sp,sp,16
    80001cde:	8082                	ret

0000000080001ce0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ce0:	1101                	addi	sp,sp,-32
    80001ce2:	ec06                	sd	ra,24(sp)
    80001ce4:	e822                	sd	s0,16(sp)
    80001ce6:	e426                	sd	s1,8(sp)
    80001ce8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cea:	0000d497          	auipc	s1,0xd
    80001cee:	39648493          	addi	s1,s1,918 # 8000f080 <tickslock>
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	00004097          	auipc	ra,0x4
    80001cf8:	62e080e7          	jalr	1582(ra) # 80006322 <acquire>
  ticks++;
    80001cfc:	00007517          	auipc	a0,0x7
    80001d00:	31c50513          	addi	a0,a0,796 # 80009018 <ticks>
    80001d04:	411c                	lw	a5,0(a0)
    80001d06:	2785                	addiw	a5,a5,1
    80001d08:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	b1c080e7          	jalr	-1252(ra) # 80001826 <wakeup>
  release(&tickslock);
    80001d12:	8526                	mv	a0,s1
    80001d14:	00004097          	auipc	ra,0x4
    80001d18:	6c2080e7          	jalr	1730(ra) # 800063d6 <release>
}
    80001d1c:	60e2                	ld	ra,24(sp)
    80001d1e:	6442                	ld	s0,16(sp)
    80001d20:	64a2                	ld	s1,8(sp)
    80001d22:	6105                	addi	sp,sp,32
    80001d24:	8082                	ret

0000000080001d26 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d26:	1101                	addi	sp,sp,-32
    80001d28:	ec06                	sd	ra,24(sp)
    80001d2a:	e822                	sd	s0,16(sp)
    80001d2c:	e426                	sd	s1,8(sp)
    80001d2e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d30:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d34:	00074d63          	bltz	a4,80001d4e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d38:	57fd                	li	a5,-1
    80001d3a:	17fe                	slli	a5,a5,0x3f
    80001d3c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d3e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d40:	06f70363          	beq	a4,a5,80001da6 <devintr+0x80>
  }
}
    80001d44:	60e2                	ld	ra,24(sp)
    80001d46:	6442                	ld	s0,16(sp)
    80001d48:	64a2                	ld	s1,8(sp)
    80001d4a:	6105                	addi	sp,sp,32
    80001d4c:	8082                	ret
     (scause & 0xff) == 9){
    80001d4e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d52:	46a5                	li	a3,9
    80001d54:	fed792e3          	bne	a5,a3,80001d38 <devintr+0x12>
    int irq = plic_claim();
    80001d58:	00003097          	auipc	ra,0x3
    80001d5c:	590080e7          	jalr	1424(ra) # 800052e8 <plic_claim>
    80001d60:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d62:	47a9                	li	a5,10
    80001d64:	02f50763          	beq	a0,a5,80001d92 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d68:	4785                	li	a5,1
    80001d6a:	02f50963          	beq	a0,a5,80001d9c <devintr+0x76>
    return 1;
    80001d6e:	4505                	li	a0,1
    } else if(irq){
    80001d70:	d8f1                	beqz	s1,80001d44 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d72:	85a6                	mv	a1,s1
    80001d74:	00006517          	auipc	a0,0x6
    80001d78:	53450513          	addi	a0,a0,1332 # 800082a8 <states.1712+0x38>
    80001d7c:	00004097          	auipc	ra,0x4
    80001d80:	0a6080e7          	jalr	166(ra) # 80005e22 <printf>
      plic_complete(irq);
    80001d84:	8526                	mv	a0,s1
    80001d86:	00003097          	auipc	ra,0x3
    80001d8a:	586080e7          	jalr	1414(ra) # 8000530c <plic_complete>
    return 1;
    80001d8e:	4505                	li	a0,1
    80001d90:	bf55                	j	80001d44 <devintr+0x1e>
      uartintr();
    80001d92:	00004097          	auipc	ra,0x4
    80001d96:	4b0080e7          	jalr	1200(ra) # 80006242 <uartintr>
    80001d9a:	b7ed                	j	80001d84 <devintr+0x5e>
      virtio_disk_intr();
    80001d9c:	00004097          	auipc	ra,0x4
    80001da0:	a50080e7          	jalr	-1456(ra) # 800057ec <virtio_disk_intr>
    80001da4:	b7c5                	j	80001d84 <devintr+0x5e>
    if(cpuid() == 0){
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	186080e7          	jalr	390(ra) # 80000f2c <cpuid>
    80001dae:	c901                	beqz	a0,80001dbe <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001db0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001db4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001db6:	14479073          	csrw	sip,a5
    return 2;
    80001dba:	4509                	li	a0,2
    80001dbc:	b761                	j	80001d44 <devintr+0x1e>
      clockintr();
    80001dbe:	00000097          	auipc	ra,0x0
    80001dc2:	f22080e7          	jalr	-222(ra) # 80001ce0 <clockintr>
    80001dc6:	b7ed                	j	80001db0 <devintr+0x8a>

0000000080001dc8 <usertrap>:
{
    80001dc8:	1101                	addi	sp,sp,-32
    80001dca:	ec06                	sd	ra,24(sp)
    80001dcc:	e822                	sd	s0,16(sp)
    80001dce:	e426                	sd	s1,8(sp)
    80001dd0:	e04a                	sd	s2,0(sp)
    80001dd2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001dd8:	1007f793          	andi	a5,a5,256
    80001ddc:	e3ad                	bnez	a5,80001e3e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001dde:	00003797          	auipc	a5,0x3
    80001de2:	40278793          	addi	a5,a5,1026 # 800051e0 <kernelvec>
    80001de6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dea:	fffff097          	auipc	ra,0xfffff
    80001dee:	16e080e7          	jalr	366(ra) # 80000f58 <myproc>
    80001df2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001df4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df6:	14102773          	csrr	a4,sepc
    80001dfa:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dfc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e00:	47a1                	li	a5,8
    80001e02:	04f71c63          	bne	a4,a5,80001e5a <usertrap+0x92>
    if(p->killed)
    80001e06:	551c                	lw	a5,40(a0)
    80001e08:	e3b9                	bnez	a5,80001e4e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e0a:	6cb8                	ld	a4,88(s1)
    80001e0c:	6f1c                	ld	a5,24(a4)
    80001e0e:	0791                	addi	a5,a5,4
    80001e10:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e12:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e16:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e1a:	10079073          	csrw	sstatus,a5
    syscall();
    80001e1e:	00000097          	auipc	ra,0x0
    80001e22:	2e0080e7          	jalr	736(ra) # 800020fe <syscall>
  if(p->killed)
    80001e26:	549c                	lw	a5,40(s1)
    80001e28:	ebc1                	bnez	a5,80001eb8 <usertrap+0xf0>
  usertrapret();
    80001e2a:	00000097          	auipc	ra,0x0
    80001e2e:	e18080e7          	jalr	-488(ra) # 80001c42 <usertrapret>
}
    80001e32:	60e2                	ld	ra,24(sp)
    80001e34:	6442                	ld	s0,16(sp)
    80001e36:	64a2                	ld	s1,8(sp)
    80001e38:	6902                	ld	s2,0(sp)
    80001e3a:	6105                	addi	sp,sp,32
    80001e3c:	8082                	ret
    panic("usertrap: not from user mode");
    80001e3e:	00006517          	auipc	a0,0x6
    80001e42:	48a50513          	addi	a0,a0,1162 # 800082c8 <states.1712+0x58>
    80001e46:	00004097          	auipc	ra,0x4
    80001e4a:	f92080e7          	jalr	-110(ra) # 80005dd8 <panic>
      exit(-1);
    80001e4e:	557d                	li	a0,-1
    80001e50:	00000097          	auipc	ra,0x0
    80001e54:	aa6080e7          	jalr	-1370(ra) # 800018f6 <exit>
    80001e58:	bf4d                	j	80001e0a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e5a:	00000097          	auipc	ra,0x0
    80001e5e:	ecc080e7          	jalr	-308(ra) # 80001d26 <devintr>
    80001e62:	892a                	mv	s2,a0
    80001e64:	c501                	beqz	a0,80001e6c <usertrap+0xa4>
  if(p->killed)
    80001e66:	549c                	lw	a5,40(s1)
    80001e68:	c3a1                	beqz	a5,80001ea8 <usertrap+0xe0>
    80001e6a:	a815                	j	80001e9e <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e6c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e70:	5890                	lw	a2,48(s1)
    80001e72:	00006517          	auipc	a0,0x6
    80001e76:	47650513          	addi	a0,a0,1142 # 800082e8 <states.1712+0x78>
    80001e7a:	00004097          	auipc	ra,0x4
    80001e7e:	fa8080e7          	jalr	-88(ra) # 80005e22 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e82:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e86:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e8a:	00006517          	auipc	a0,0x6
    80001e8e:	48e50513          	addi	a0,a0,1166 # 80008318 <states.1712+0xa8>
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	f90080e7          	jalr	-112(ra) # 80005e22 <printf>
    p->killed = 1;
    80001e9a:	4785                	li	a5,1
    80001e9c:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001e9e:	557d                	li	a0,-1
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	a56080e7          	jalr	-1450(ra) # 800018f6 <exit>
  if(which_dev == 2)
    80001ea8:	4789                	li	a5,2
    80001eaa:	f8f910e3          	bne	s2,a5,80001e2a <usertrap+0x62>
    yield();
    80001eae:	fffff097          	auipc	ra,0xfffff
    80001eb2:	7b0080e7          	jalr	1968(ra) # 8000165e <yield>
    80001eb6:	bf95                	j	80001e2a <usertrap+0x62>
  int which_dev = 0;
    80001eb8:	4901                	li	s2,0
    80001eba:	b7d5                	j	80001e9e <usertrap+0xd6>

0000000080001ebc <kerneltrap>:
{
    80001ebc:	7179                	addi	sp,sp,-48
    80001ebe:	f406                	sd	ra,40(sp)
    80001ec0:	f022                	sd	s0,32(sp)
    80001ec2:	ec26                	sd	s1,24(sp)
    80001ec4:	e84a                	sd	s2,16(sp)
    80001ec6:	e44e                	sd	s3,8(sp)
    80001ec8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eca:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ece:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ed2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ed6:	1004f793          	andi	a5,s1,256
    80001eda:	cb85                	beqz	a5,80001f0a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001edc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ee0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ee2:	ef85                	bnez	a5,80001f1a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ee4:	00000097          	auipc	ra,0x0
    80001ee8:	e42080e7          	jalr	-446(ra) # 80001d26 <devintr>
    80001eec:	cd1d                	beqz	a0,80001f2a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eee:	4789                	li	a5,2
    80001ef0:	06f50a63          	beq	a0,a5,80001f64 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ef4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ef8:	10049073          	csrw	sstatus,s1
}
    80001efc:	70a2                	ld	ra,40(sp)
    80001efe:	7402                	ld	s0,32(sp)
    80001f00:	64e2                	ld	s1,24(sp)
    80001f02:	6942                	ld	s2,16(sp)
    80001f04:	69a2                	ld	s3,8(sp)
    80001f06:	6145                	addi	sp,sp,48
    80001f08:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f0a:	00006517          	auipc	a0,0x6
    80001f0e:	42e50513          	addi	a0,a0,1070 # 80008338 <states.1712+0xc8>
    80001f12:	00004097          	auipc	ra,0x4
    80001f16:	ec6080e7          	jalr	-314(ra) # 80005dd8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f1a:	00006517          	auipc	a0,0x6
    80001f1e:	44650513          	addi	a0,a0,1094 # 80008360 <states.1712+0xf0>
    80001f22:	00004097          	auipc	ra,0x4
    80001f26:	eb6080e7          	jalr	-330(ra) # 80005dd8 <panic>
    printf("scause %p\n", scause);
    80001f2a:	85ce                	mv	a1,s3
    80001f2c:	00006517          	auipc	a0,0x6
    80001f30:	45450513          	addi	a0,a0,1108 # 80008380 <states.1712+0x110>
    80001f34:	00004097          	auipc	ra,0x4
    80001f38:	eee080e7          	jalr	-274(ra) # 80005e22 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f3c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f40:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f44:	00006517          	auipc	a0,0x6
    80001f48:	44c50513          	addi	a0,a0,1100 # 80008390 <states.1712+0x120>
    80001f4c:	00004097          	auipc	ra,0x4
    80001f50:	ed6080e7          	jalr	-298(ra) # 80005e22 <printf>
    panic("kerneltrap");
    80001f54:	00006517          	auipc	a0,0x6
    80001f58:	45450513          	addi	a0,a0,1108 # 800083a8 <states.1712+0x138>
    80001f5c:	00004097          	auipc	ra,0x4
    80001f60:	e7c080e7          	jalr	-388(ra) # 80005dd8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	ff4080e7          	jalr	-12(ra) # 80000f58 <myproc>
    80001f6c:	d541                	beqz	a0,80001ef4 <kerneltrap+0x38>
    80001f6e:	fffff097          	auipc	ra,0xfffff
    80001f72:	fea080e7          	jalr	-22(ra) # 80000f58 <myproc>
    80001f76:	4d18                	lw	a4,24(a0)
    80001f78:	4791                	li	a5,4
    80001f7a:	f6f71de3          	bne	a4,a5,80001ef4 <kerneltrap+0x38>
    yield();
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	6e0080e7          	jalr	1760(ra) # 8000165e <yield>
    80001f86:	b7bd                	j	80001ef4 <kerneltrap+0x38>

0000000080001f88 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f88:	1101                	addi	sp,sp,-32
    80001f8a:	ec06                	sd	ra,24(sp)
    80001f8c:	e822                	sd	s0,16(sp)
    80001f8e:	e426                	sd	s1,8(sp)
    80001f90:	1000                	addi	s0,sp,32
    80001f92:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	fc4080e7          	jalr	-60(ra) # 80000f58 <myproc>
  switch (n) {
    80001f9c:	4795                	li	a5,5
    80001f9e:	0497e163          	bltu	a5,s1,80001fe0 <argraw+0x58>
    80001fa2:	048a                	slli	s1,s1,0x2
    80001fa4:	00006717          	auipc	a4,0x6
    80001fa8:	43c70713          	addi	a4,a4,1084 # 800083e0 <states.1712+0x170>
    80001fac:	94ba                	add	s1,s1,a4
    80001fae:	409c                	lw	a5,0(s1)
    80001fb0:	97ba                	add	a5,a5,a4
    80001fb2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fb4:	6d3c                	ld	a5,88(a0)
    80001fb6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fb8:	60e2                	ld	ra,24(sp)
    80001fba:	6442                	ld	s0,16(sp)
    80001fbc:	64a2                	ld	s1,8(sp)
    80001fbe:	6105                	addi	sp,sp,32
    80001fc0:	8082                	ret
    return p->trapframe->a1;
    80001fc2:	6d3c                	ld	a5,88(a0)
    80001fc4:	7fa8                	ld	a0,120(a5)
    80001fc6:	bfcd                	j	80001fb8 <argraw+0x30>
    return p->trapframe->a2;
    80001fc8:	6d3c                	ld	a5,88(a0)
    80001fca:	63c8                	ld	a0,128(a5)
    80001fcc:	b7f5                	j	80001fb8 <argraw+0x30>
    return p->trapframe->a3;
    80001fce:	6d3c                	ld	a5,88(a0)
    80001fd0:	67c8                	ld	a0,136(a5)
    80001fd2:	b7dd                	j	80001fb8 <argraw+0x30>
    return p->trapframe->a4;
    80001fd4:	6d3c                	ld	a5,88(a0)
    80001fd6:	6bc8                	ld	a0,144(a5)
    80001fd8:	b7c5                	j	80001fb8 <argraw+0x30>
    return p->trapframe->a5;
    80001fda:	6d3c                	ld	a5,88(a0)
    80001fdc:	6fc8                	ld	a0,152(a5)
    80001fde:	bfe9                	j	80001fb8 <argraw+0x30>
  panic("argraw");
    80001fe0:	00006517          	auipc	a0,0x6
    80001fe4:	3d850513          	addi	a0,a0,984 # 800083b8 <states.1712+0x148>
    80001fe8:	00004097          	auipc	ra,0x4
    80001fec:	df0080e7          	jalr	-528(ra) # 80005dd8 <panic>

0000000080001ff0 <fetchaddr>:
{
    80001ff0:	1101                	addi	sp,sp,-32
    80001ff2:	ec06                	sd	ra,24(sp)
    80001ff4:	e822                	sd	s0,16(sp)
    80001ff6:	e426                	sd	s1,8(sp)
    80001ff8:	e04a                	sd	s2,0(sp)
    80001ffa:	1000                	addi	s0,sp,32
    80001ffc:	84aa                	mv	s1,a0
    80001ffe:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	f58080e7          	jalr	-168(ra) # 80000f58 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002008:	653c                	ld	a5,72(a0)
    8000200a:	02f4f863          	bgeu	s1,a5,8000203a <fetchaddr+0x4a>
    8000200e:	00848713          	addi	a4,s1,8
    80002012:	02e7e663          	bltu	a5,a4,8000203e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002016:	46a1                	li	a3,8
    80002018:	8626                	mv	a2,s1
    8000201a:	85ca                	mv	a1,s2
    8000201c:	6928                	ld	a0,80(a0)
    8000201e:	fffff097          	auipc	ra,0xfffff
    80002022:	b78080e7          	jalr	-1160(ra) # 80000b96 <copyin>
    80002026:	00a03533          	snez	a0,a0
    8000202a:	40a00533          	neg	a0,a0
}
    8000202e:	60e2                	ld	ra,24(sp)
    80002030:	6442                	ld	s0,16(sp)
    80002032:	64a2                	ld	s1,8(sp)
    80002034:	6902                	ld	s2,0(sp)
    80002036:	6105                	addi	sp,sp,32
    80002038:	8082                	ret
    return -1;
    8000203a:	557d                	li	a0,-1
    8000203c:	bfcd                	j	8000202e <fetchaddr+0x3e>
    8000203e:	557d                	li	a0,-1
    80002040:	b7fd                	j	8000202e <fetchaddr+0x3e>

0000000080002042 <fetchstr>:
{
    80002042:	7179                	addi	sp,sp,-48
    80002044:	f406                	sd	ra,40(sp)
    80002046:	f022                	sd	s0,32(sp)
    80002048:	ec26                	sd	s1,24(sp)
    8000204a:	e84a                	sd	s2,16(sp)
    8000204c:	e44e                	sd	s3,8(sp)
    8000204e:	1800                	addi	s0,sp,48
    80002050:	892a                	mv	s2,a0
    80002052:	84ae                	mv	s1,a1
    80002054:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002056:	fffff097          	auipc	ra,0xfffff
    8000205a:	f02080e7          	jalr	-254(ra) # 80000f58 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000205e:	86ce                	mv	a3,s3
    80002060:	864a                	mv	a2,s2
    80002062:	85a6                	mv	a1,s1
    80002064:	6928                	ld	a0,80(a0)
    80002066:	fffff097          	auipc	ra,0xfffff
    8000206a:	bbc080e7          	jalr	-1092(ra) # 80000c22 <copyinstr>
  if(err < 0)
    8000206e:	00054763          	bltz	a0,8000207c <fetchstr+0x3a>
  return strlen(buf);
    80002072:	8526                	mv	a0,s1
    80002074:	ffffe097          	auipc	ra,0xffffe
    80002078:	288080e7          	jalr	648(ra) # 800002fc <strlen>
}
    8000207c:	70a2                	ld	ra,40(sp)
    8000207e:	7402                	ld	s0,32(sp)
    80002080:	64e2                	ld	s1,24(sp)
    80002082:	6942                	ld	s2,16(sp)
    80002084:	69a2                	ld	s3,8(sp)
    80002086:	6145                	addi	sp,sp,48
    80002088:	8082                	ret

000000008000208a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000208a:	1101                	addi	sp,sp,-32
    8000208c:	ec06                	sd	ra,24(sp)
    8000208e:	e822                	sd	s0,16(sp)
    80002090:	e426                	sd	s1,8(sp)
    80002092:	1000                	addi	s0,sp,32
    80002094:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002096:	00000097          	auipc	ra,0x0
    8000209a:	ef2080e7          	jalr	-270(ra) # 80001f88 <argraw>
    8000209e:	c088                	sw	a0,0(s1)
  return 0;
}
    800020a0:	4501                	li	a0,0
    800020a2:	60e2                	ld	ra,24(sp)
    800020a4:	6442                	ld	s0,16(sp)
    800020a6:	64a2                	ld	s1,8(sp)
    800020a8:	6105                	addi	sp,sp,32
    800020aa:	8082                	ret

00000000800020ac <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020ac:	1101                	addi	sp,sp,-32
    800020ae:	ec06                	sd	ra,24(sp)
    800020b0:	e822                	sd	s0,16(sp)
    800020b2:	e426                	sd	s1,8(sp)
    800020b4:	1000                	addi	s0,sp,32
    800020b6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020b8:	00000097          	auipc	ra,0x0
    800020bc:	ed0080e7          	jalr	-304(ra) # 80001f88 <argraw>
    800020c0:	e088                	sd	a0,0(s1)
  return 0;
}
    800020c2:	4501                	li	a0,0
    800020c4:	60e2                	ld	ra,24(sp)
    800020c6:	6442                	ld	s0,16(sp)
    800020c8:	64a2                	ld	s1,8(sp)
    800020ca:	6105                	addi	sp,sp,32
    800020cc:	8082                	ret

00000000800020ce <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020ce:	1101                	addi	sp,sp,-32
    800020d0:	ec06                	sd	ra,24(sp)
    800020d2:	e822                	sd	s0,16(sp)
    800020d4:	e426                	sd	s1,8(sp)
    800020d6:	e04a                	sd	s2,0(sp)
    800020d8:	1000                	addi	s0,sp,32
    800020da:	84ae                	mv	s1,a1
    800020dc:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020de:	00000097          	auipc	ra,0x0
    800020e2:	eaa080e7          	jalr	-342(ra) # 80001f88 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020e6:	864a                	mv	a2,s2
    800020e8:	85a6                	mv	a1,s1
    800020ea:	00000097          	auipc	ra,0x0
    800020ee:	f58080e7          	jalr	-168(ra) # 80002042 <fetchstr>
}
    800020f2:	60e2                	ld	ra,24(sp)
    800020f4:	6442                	ld	s0,16(sp)
    800020f6:	64a2                	ld	s1,8(sp)
    800020f8:	6902                	ld	s2,0(sp)
    800020fa:	6105                	addi	sp,sp,32
    800020fc:	8082                	ret

00000000800020fe <syscall>:



void
syscall(void)
{
    800020fe:	1101                	addi	sp,sp,-32
    80002100:	ec06                	sd	ra,24(sp)
    80002102:	e822                	sd	s0,16(sp)
    80002104:	e426                	sd	s1,8(sp)
    80002106:	e04a                	sd	s2,0(sp)
    80002108:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000210a:	fffff097          	auipc	ra,0xfffff
    8000210e:	e4e080e7          	jalr	-434(ra) # 80000f58 <myproc>
    80002112:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002114:	05853903          	ld	s2,88(a0)
    80002118:	0a893783          	ld	a5,168(s2)
    8000211c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002120:	37fd                	addiw	a5,a5,-1
    80002122:	4775                	li	a4,29
    80002124:	00f76f63          	bltu	a4,a5,80002142 <syscall+0x44>
    80002128:	00369713          	slli	a4,a3,0x3
    8000212c:	00006797          	auipc	a5,0x6
    80002130:	2cc78793          	addi	a5,a5,716 # 800083f8 <syscalls>
    80002134:	97ba                	add	a5,a5,a4
    80002136:	639c                	ld	a5,0(a5)
    80002138:	c789                	beqz	a5,80002142 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000213a:	9782                	jalr	a5
    8000213c:	06a93823          	sd	a0,112(s2)
    80002140:	a839                	j	8000215e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002142:	15848613          	addi	a2,s1,344
    80002146:	588c                	lw	a1,48(s1)
    80002148:	00006517          	auipc	a0,0x6
    8000214c:	27850513          	addi	a0,a0,632 # 800083c0 <states.1712+0x150>
    80002150:	00004097          	auipc	ra,0x4
    80002154:	cd2080e7          	jalr	-814(ra) # 80005e22 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002158:	6cbc                	ld	a5,88(s1)
    8000215a:	577d                	li	a4,-1
    8000215c:	fbb8                	sd	a4,112(a5)
  }
}
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	64a2                	ld	s1,8(sp)
    80002164:	6902                	ld	s2,0(sp)
    80002166:	6105                	addi	sp,sp,32
    80002168:	8082                	ret

000000008000216a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002172:	fec40593          	addi	a1,s0,-20
    80002176:	4501                	li	a0,0
    80002178:	00000097          	auipc	ra,0x0
    8000217c:	f12080e7          	jalr	-238(ra) # 8000208a <argint>
    return -1;
    80002180:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002182:	00054963          	bltz	a0,80002194 <sys_exit+0x2a>
  exit(n);
    80002186:	fec42503          	lw	a0,-20(s0)
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	76c080e7          	jalr	1900(ra) # 800018f6 <exit>
  return 0;  // not reached
    80002192:	4781                	li	a5,0
}
    80002194:	853e                	mv	a0,a5
    80002196:	60e2                	ld	ra,24(sp)
    80002198:	6442                	ld	s0,16(sp)
    8000219a:	6105                	addi	sp,sp,32
    8000219c:	8082                	ret

000000008000219e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000219e:	1141                	addi	sp,sp,-16
    800021a0:	e406                	sd	ra,8(sp)
    800021a2:	e022                	sd	s0,0(sp)
    800021a4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	db2080e7          	jalr	-590(ra) # 80000f58 <myproc>
}
    800021ae:	5908                	lw	a0,48(a0)
    800021b0:	60a2                	ld	ra,8(sp)
    800021b2:	6402                	ld	s0,0(sp)
    800021b4:	0141                	addi	sp,sp,16
    800021b6:	8082                	ret

00000000800021b8 <sys_fork>:

uint64
sys_fork(void)
{
    800021b8:	1141                	addi	sp,sp,-16
    800021ba:	e406                	sd	ra,8(sp)
    800021bc:	e022                	sd	s0,0(sp)
    800021be:	0800                	addi	s0,sp,16
  return fork();
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	1ec080e7          	jalr	492(ra) # 800013ac <fork>
}
    800021c8:	60a2                	ld	ra,8(sp)
    800021ca:	6402                	ld	s0,0(sp)
    800021cc:	0141                	addi	sp,sp,16
    800021ce:	8082                	ret

00000000800021d0 <sys_wait>:

uint64
sys_wait(void)
{
    800021d0:	1101                	addi	sp,sp,-32
    800021d2:	ec06                	sd	ra,24(sp)
    800021d4:	e822                	sd	s0,16(sp)
    800021d6:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021d8:	fe840593          	addi	a1,s0,-24
    800021dc:	4501                	li	a0,0
    800021de:	00000097          	auipc	ra,0x0
    800021e2:	ece080e7          	jalr	-306(ra) # 800020ac <argaddr>
    800021e6:	87aa                	mv	a5,a0
    return -1;
    800021e8:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021ea:	0007c863          	bltz	a5,800021fa <sys_wait+0x2a>
  return wait(p);
    800021ee:	fe843503          	ld	a0,-24(s0)
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	50c080e7          	jalr	1292(ra) # 800016fe <wait>
}
    800021fa:	60e2                	ld	ra,24(sp)
    800021fc:	6442                	ld	s0,16(sp)
    800021fe:	6105                	addi	sp,sp,32
    80002200:	8082                	ret

0000000080002202 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002202:	7179                	addi	sp,sp,-48
    80002204:	f406                	sd	ra,40(sp)
    80002206:	f022                	sd	s0,32(sp)
    80002208:	ec26                	sd	s1,24(sp)
    8000220a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000220c:	fdc40593          	addi	a1,s0,-36
    80002210:	4501                	li	a0,0
    80002212:	00000097          	auipc	ra,0x0
    80002216:	e78080e7          	jalr	-392(ra) # 8000208a <argint>
    8000221a:	87aa                	mv	a5,a0
    return -1;
    8000221c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000221e:	0207c063          	bltz	a5,8000223e <sys_sbrk+0x3c>

  addr = myproc()->sz;
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	d36080e7          	jalr	-714(ra) # 80000f58 <myproc>
    8000222a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000222c:	fdc42503          	lw	a0,-36(s0)
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	108080e7          	jalr	264(ra) # 80001338 <growproc>
    80002238:	00054863          	bltz	a0,80002248 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000223c:	8526                	mv	a0,s1
}
    8000223e:	70a2                	ld	ra,40(sp)
    80002240:	7402                	ld	s0,32(sp)
    80002242:	64e2                	ld	s1,24(sp)
    80002244:	6145                	addi	sp,sp,48
    80002246:	8082                	ret
    return -1;
    80002248:	557d                	li	a0,-1
    8000224a:	bfd5                	j	8000223e <sys_sbrk+0x3c>

000000008000224c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000224c:	7139                	addi	sp,sp,-64
    8000224e:	fc06                	sd	ra,56(sp)
    80002250:	f822                	sd	s0,48(sp)
    80002252:	f426                	sd	s1,40(sp)
    80002254:	f04a                	sd	s2,32(sp)
    80002256:	ec4e                	sd	s3,24(sp)
    80002258:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    8000225a:	fcc40593          	addi	a1,s0,-52
    8000225e:	4501                	li	a0,0
    80002260:	00000097          	auipc	ra,0x0
    80002264:	e2a080e7          	jalr	-470(ra) # 8000208a <argint>
    return -1;
    80002268:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000226a:	06054563          	bltz	a0,800022d4 <sys_sleep+0x88>
  acquire(&tickslock);
    8000226e:	0000d517          	auipc	a0,0xd
    80002272:	e1250513          	addi	a0,a0,-494 # 8000f080 <tickslock>
    80002276:	00004097          	auipc	ra,0x4
    8000227a:	0ac080e7          	jalr	172(ra) # 80006322 <acquire>
  ticks0 = ticks;
    8000227e:	00007917          	auipc	s2,0x7
    80002282:	d9a92903          	lw	s2,-614(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002286:	fcc42783          	lw	a5,-52(s0)
    8000228a:	cf85                	beqz	a5,800022c2 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000228c:	0000d997          	auipc	s3,0xd
    80002290:	df498993          	addi	s3,s3,-524 # 8000f080 <tickslock>
    80002294:	00007497          	auipc	s1,0x7
    80002298:	d8448493          	addi	s1,s1,-636 # 80009018 <ticks>
    if(myproc()->killed){
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	cbc080e7          	jalr	-836(ra) # 80000f58 <myproc>
    800022a4:	551c                	lw	a5,40(a0)
    800022a6:	ef9d                	bnez	a5,800022e4 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022a8:	85ce                	mv	a1,s3
    800022aa:	8526                	mv	a0,s1
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	3ee080e7          	jalr	1006(ra) # 8000169a <sleep>
  while(ticks - ticks0 < n){
    800022b4:	409c                	lw	a5,0(s1)
    800022b6:	412787bb          	subw	a5,a5,s2
    800022ba:	fcc42703          	lw	a4,-52(s0)
    800022be:	fce7efe3          	bltu	a5,a4,8000229c <sys_sleep+0x50>
  }
  release(&tickslock);
    800022c2:	0000d517          	auipc	a0,0xd
    800022c6:	dbe50513          	addi	a0,a0,-578 # 8000f080 <tickslock>
    800022ca:	00004097          	auipc	ra,0x4
    800022ce:	10c080e7          	jalr	268(ra) # 800063d6 <release>
  return 0;
    800022d2:	4781                	li	a5,0
}
    800022d4:	853e                	mv	a0,a5
    800022d6:	70e2                	ld	ra,56(sp)
    800022d8:	7442                	ld	s0,48(sp)
    800022da:	74a2                	ld	s1,40(sp)
    800022dc:	7902                	ld	s2,32(sp)
    800022de:	69e2                	ld	s3,24(sp)
    800022e0:	6121                	addi	sp,sp,64
    800022e2:	8082                	ret
      release(&tickslock);
    800022e4:	0000d517          	auipc	a0,0xd
    800022e8:	d9c50513          	addi	a0,a0,-612 # 8000f080 <tickslock>
    800022ec:	00004097          	auipc	ra,0x4
    800022f0:	0ea080e7          	jalr	234(ra) # 800063d6 <release>
      return -1;
    800022f4:	57fd                	li	a5,-1
    800022f6:	bff9                	j	800022d4 <sys_sleep+0x88>

00000000800022f8 <sys_pgaccess>:

#ifdef LAB_PGTBL
extern pte_t *walk(pagetable_t, uint64, int);
int
sys_pgaccess(void)
{
    800022f8:	711d                	addi	sp,sp,-96
    800022fa:	ec86                	sd	ra,88(sp)
    800022fc:	e8a2                	sd	s0,80(sp)
    800022fe:	e4a6                	sd	s1,72(sp)
    80002300:	e0ca                	sd	s2,64(sp)
    80002302:	fc4e                	sd	s3,56(sp)
    80002304:	f852                	sd	s4,48(sp)
    80002306:	f456                	sd	s5,40(sp)
    80002308:	1080                	addi	s0,sp,96
  // lab pgtbl: your code here.
  uint64 srcva, st;
  int len;
  uint64 buf = 0;
    8000230a:	fa043023          	sd	zero,-96(s0)
  struct proc *p = myproc();
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	c4a080e7          	jalr	-950(ra) # 80000f58 <myproc>
    80002316:	89aa                	mv	s3,a0

  acquire(&p->lock);
    80002318:	00004097          	auipc	ra,0x4
    8000231c:	00a080e7          	jalr	10(ra) # 80006322 <acquire>

  argaddr(0, &srcva);
    80002320:	fb840593          	addi	a1,s0,-72
    80002324:	4501                	li	a0,0
    80002326:	00000097          	auipc	ra,0x0
    8000232a:	d86080e7          	jalr	-634(ra) # 800020ac <argaddr>
  argint(1, &len);
    8000232e:	fac40593          	addi	a1,s0,-84
    80002332:	4505                	li	a0,1
    80002334:	00000097          	auipc	ra,0x0
    80002338:	d56080e7          	jalr	-682(ra) # 8000208a <argint>
  argaddr(2, &st);
    8000233c:	fb040593          	addi	a1,s0,-80
    80002340:	4509                	li	a0,2
    80002342:	00000097          	auipc	ra,0x0
    80002346:	d6a080e7          	jalr	-662(ra) # 800020ac <argaddr>
  if ((len > 64) || (len < 1))
    8000234a:	fac42783          	lw	a5,-84(s0)
    8000234e:	37fd                	addiw	a5,a5,-1
    80002350:	03f00713          	li	a4,63
    80002354:	08f76d63          	bltu	a4,a5,800023ee <sys_pgaccess+0xf6>
    80002358:	4481                	li	s1,0
      return -1;
    }
    if((*pte & PTE_V) == 0){
      return -1;
    }
    if((*pte & PTE_U) == 0){
    8000235a:	4a45                	li	s4,17
      return -1;
    }
    if(*pte & PTE_A){
      *pte = *pte & ~PTE_A;
      buf |= (1 << i);
    8000235c:	4a85                	li	s5,1
    8000235e:	a801                	j	8000236e <sys_pgaccess+0x76>
  for (int i = 0; i < len; i++)
    80002360:	0485                	addi	s1,s1,1
    80002362:	fac42703          	lw	a4,-84(s0)
    80002366:	0004879b          	sext.w	a5,s1
    8000236a:	04e7d563          	bge	a5,a4,800023b4 <sys_pgaccess+0xbc>
    8000236e:	0004891b          	sext.w	s2,s1
    pte = walk(p->pagetable, srcva + i * PGSIZE, 0);
    80002372:	00c49593          	slli	a1,s1,0xc
    80002376:	4601                	li	a2,0
    80002378:	fb843783          	ld	a5,-72(s0)
    8000237c:	95be                	add	a1,a1,a5
    8000237e:	0509b503          	ld	a0,80(s3)
    80002382:	ffffe097          	auipc	ra,0xffffe
    80002386:	0de080e7          	jalr	222(ra) # 80000460 <walk>
    if(pte == 0){
    8000238a:	c525                	beqz	a0,800023f2 <sys_pgaccess+0xfa>
    if((*pte & PTE_V) == 0){
    8000238c:	611c                	ld	a5,0(a0)
    if((*pte & PTE_U) == 0){
    8000238e:	0117f713          	andi	a4,a5,17
    80002392:	07471263          	bne	a4,s4,800023f6 <sys_pgaccess+0xfe>
    if(*pte & PTE_A){
    80002396:	0407f713          	andi	a4,a5,64
    8000239a:	d379                	beqz	a4,80002360 <sys_pgaccess+0x68>
      *pte = *pte & ~PTE_A;
    8000239c:	fbf7f793          	andi	a5,a5,-65
    800023a0:	e11c                	sd	a5,0(a0)
      buf |= (1 << i);
    800023a2:	012a993b          	sllw	s2,s5,s2
    800023a6:	fa043783          	ld	a5,-96(s0)
    800023aa:	0127e933          	or	s2,a5,s2
    800023ae:	fb243023          	sd	s2,-96(s0)
    800023b2:	b77d                	j	80002360 <sys_pgaccess+0x68>
    }
  }
  release(&p->lock);
    800023b4:	854e                	mv	a0,s3
    800023b6:	00004097          	auipc	ra,0x4
    800023ba:	020080e7          	jalr	32(ra) # 800063d6 <release>
  copyout(p->pagetable, st, (char *)&buf, ((len -1) / 8) + 1);
    800023be:	fac42683          	lw	a3,-84(s0)
    800023c2:	fff6879b          	addiw	a5,a3,-1
    800023c6:	41f7d69b          	sraiw	a3,a5,0x1f
    800023ca:	01d6d69b          	srliw	a3,a3,0x1d
    800023ce:	9ebd                	addw	a3,a3,a5
    800023d0:	4036d69b          	sraiw	a3,a3,0x3
    800023d4:	2685                	addiw	a3,a3,1
    800023d6:	fa040613          	addi	a2,s0,-96
    800023da:	fb043583          	ld	a1,-80(s0)
    800023de:	0509b503          	ld	a0,80(s3)
    800023e2:	ffffe097          	auipc	ra,0xffffe
    800023e6:	728080e7          	jalr	1832(ra) # 80000b0a <copyout>
  return 0;
    800023ea:	4501                	li	a0,0
    800023ec:	a031                	j	800023f8 <sys_pgaccess+0x100>
    return -1;
    800023ee:	557d                	li	a0,-1
    800023f0:	a021                	j	800023f8 <sys_pgaccess+0x100>
      return -1;
    800023f2:	557d                	li	a0,-1
    800023f4:	a011                	j	800023f8 <sys_pgaccess+0x100>
      return -1;
    800023f6:	557d                	li	a0,-1
}
    800023f8:	60e6                	ld	ra,88(sp)
    800023fa:	6446                	ld	s0,80(sp)
    800023fc:	64a6                	ld	s1,72(sp)
    800023fe:	6906                	ld	s2,64(sp)
    80002400:	79e2                	ld	s3,56(sp)
    80002402:	7a42                	ld	s4,48(sp)
    80002404:	7aa2                	ld	s5,40(sp)
    80002406:	6125                	addi	sp,sp,96
    80002408:	8082                	ret

000000008000240a <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000240a:	1101                	addi	sp,sp,-32
    8000240c:	ec06                	sd	ra,24(sp)
    8000240e:	e822                	sd	s0,16(sp)
    80002410:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002412:	fec40593          	addi	a1,s0,-20
    80002416:	4501                	li	a0,0
    80002418:	00000097          	auipc	ra,0x0
    8000241c:	c72080e7          	jalr	-910(ra) # 8000208a <argint>
    80002420:	87aa                	mv	a5,a0
    return -1;
    80002422:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002424:	0007c863          	bltz	a5,80002434 <sys_kill+0x2a>
  return kill(pid);
    80002428:	fec42503          	lw	a0,-20(s0)
    8000242c:	fffff097          	auipc	ra,0xfffff
    80002430:	5a0080e7          	jalr	1440(ra) # 800019cc <kill>
}
    80002434:	60e2                	ld	ra,24(sp)
    80002436:	6442                	ld	s0,16(sp)
    80002438:	6105                	addi	sp,sp,32
    8000243a:	8082                	ret

000000008000243c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000243c:	1101                	addi	sp,sp,-32
    8000243e:	ec06                	sd	ra,24(sp)
    80002440:	e822                	sd	s0,16(sp)
    80002442:	e426                	sd	s1,8(sp)
    80002444:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002446:	0000d517          	auipc	a0,0xd
    8000244a:	c3a50513          	addi	a0,a0,-966 # 8000f080 <tickslock>
    8000244e:	00004097          	auipc	ra,0x4
    80002452:	ed4080e7          	jalr	-300(ra) # 80006322 <acquire>
  xticks = ticks;
    80002456:	00007497          	auipc	s1,0x7
    8000245a:	bc24a483          	lw	s1,-1086(s1) # 80009018 <ticks>
  release(&tickslock);
    8000245e:	0000d517          	auipc	a0,0xd
    80002462:	c2250513          	addi	a0,a0,-990 # 8000f080 <tickslock>
    80002466:	00004097          	auipc	ra,0x4
    8000246a:	f70080e7          	jalr	-144(ra) # 800063d6 <release>
  return xticks;
    8000246e:	02049513          	slli	a0,s1,0x20
    80002472:	9101                	srli	a0,a0,0x20
    80002474:	60e2                	ld	ra,24(sp)
    80002476:	6442                	ld	s0,16(sp)
    80002478:	64a2                	ld	s1,8(sp)
    8000247a:	6105                	addi	sp,sp,32
    8000247c:	8082                	ret

000000008000247e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000247e:	7179                	addi	sp,sp,-48
    80002480:	f406                	sd	ra,40(sp)
    80002482:	f022                	sd	s0,32(sp)
    80002484:	ec26                	sd	s1,24(sp)
    80002486:	e84a                	sd	s2,16(sp)
    80002488:	e44e                	sd	s3,8(sp)
    8000248a:	e052                	sd	s4,0(sp)
    8000248c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000248e:	00006597          	auipc	a1,0x6
    80002492:	06258593          	addi	a1,a1,98 # 800084f0 <syscalls+0xf8>
    80002496:	0000d517          	auipc	a0,0xd
    8000249a:	c0250513          	addi	a0,a0,-1022 # 8000f098 <bcache>
    8000249e:	00004097          	auipc	ra,0x4
    800024a2:	df4080e7          	jalr	-524(ra) # 80006292 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024a6:	00015797          	auipc	a5,0x15
    800024aa:	bf278793          	addi	a5,a5,-1038 # 80017098 <bcache+0x8000>
    800024ae:	00015717          	auipc	a4,0x15
    800024b2:	e5270713          	addi	a4,a4,-430 # 80017300 <bcache+0x8268>
    800024b6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024ba:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024be:	0000d497          	auipc	s1,0xd
    800024c2:	bf248493          	addi	s1,s1,-1038 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024c6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024c8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024ca:	00006a17          	auipc	s4,0x6
    800024ce:	02ea0a13          	addi	s4,s4,46 # 800084f8 <syscalls+0x100>
    b->next = bcache.head.next;
    800024d2:	2b893783          	ld	a5,696(s2)
    800024d6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024d8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024dc:	85d2                	mv	a1,s4
    800024de:	01048513          	addi	a0,s1,16
    800024e2:	00001097          	auipc	ra,0x1
    800024e6:	4bc080e7          	jalr	1212(ra) # 8000399e <initsleeplock>
    bcache.head.next->prev = b;
    800024ea:	2b893783          	ld	a5,696(s2)
    800024ee:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024f0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024f4:	45848493          	addi	s1,s1,1112
    800024f8:	fd349de3          	bne	s1,s3,800024d2 <binit+0x54>
  }
}
    800024fc:	70a2                	ld	ra,40(sp)
    800024fe:	7402                	ld	s0,32(sp)
    80002500:	64e2                	ld	s1,24(sp)
    80002502:	6942                	ld	s2,16(sp)
    80002504:	69a2                	ld	s3,8(sp)
    80002506:	6a02                	ld	s4,0(sp)
    80002508:	6145                	addi	sp,sp,48
    8000250a:	8082                	ret

000000008000250c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000250c:	7179                	addi	sp,sp,-48
    8000250e:	f406                	sd	ra,40(sp)
    80002510:	f022                	sd	s0,32(sp)
    80002512:	ec26                	sd	s1,24(sp)
    80002514:	e84a                	sd	s2,16(sp)
    80002516:	e44e                	sd	s3,8(sp)
    80002518:	1800                	addi	s0,sp,48
    8000251a:	89aa                	mv	s3,a0
    8000251c:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000251e:	0000d517          	auipc	a0,0xd
    80002522:	b7a50513          	addi	a0,a0,-1158 # 8000f098 <bcache>
    80002526:	00004097          	auipc	ra,0x4
    8000252a:	dfc080e7          	jalr	-516(ra) # 80006322 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000252e:	00015497          	auipc	s1,0x15
    80002532:	e224b483          	ld	s1,-478(s1) # 80017350 <bcache+0x82b8>
    80002536:	00015797          	auipc	a5,0x15
    8000253a:	dca78793          	addi	a5,a5,-566 # 80017300 <bcache+0x8268>
    8000253e:	02f48f63          	beq	s1,a5,8000257c <bread+0x70>
    80002542:	873e                	mv	a4,a5
    80002544:	a021                	j	8000254c <bread+0x40>
    80002546:	68a4                	ld	s1,80(s1)
    80002548:	02e48a63          	beq	s1,a4,8000257c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000254c:	449c                	lw	a5,8(s1)
    8000254e:	ff379ce3          	bne	a5,s3,80002546 <bread+0x3a>
    80002552:	44dc                	lw	a5,12(s1)
    80002554:	ff2799e3          	bne	a5,s2,80002546 <bread+0x3a>
      b->refcnt++;
    80002558:	40bc                	lw	a5,64(s1)
    8000255a:	2785                	addiw	a5,a5,1
    8000255c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000255e:	0000d517          	auipc	a0,0xd
    80002562:	b3a50513          	addi	a0,a0,-1222 # 8000f098 <bcache>
    80002566:	00004097          	auipc	ra,0x4
    8000256a:	e70080e7          	jalr	-400(ra) # 800063d6 <release>
      acquiresleep(&b->lock);
    8000256e:	01048513          	addi	a0,s1,16
    80002572:	00001097          	auipc	ra,0x1
    80002576:	466080e7          	jalr	1126(ra) # 800039d8 <acquiresleep>
      return b;
    8000257a:	a8b9                	j	800025d8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000257c:	00015497          	auipc	s1,0x15
    80002580:	dcc4b483          	ld	s1,-564(s1) # 80017348 <bcache+0x82b0>
    80002584:	00015797          	auipc	a5,0x15
    80002588:	d7c78793          	addi	a5,a5,-644 # 80017300 <bcache+0x8268>
    8000258c:	00f48863          	beq	s1,a5,8000259c <bread+0x90>
    80002590:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002592:	40bc                	lw	a5,64(s1)
    80002594:	cf81                	beqz	a5,800025ac <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002596:	64a4                	ld	s1,72(s1)
    80002598:	fee49de3          	bne	s1,a4,80002592 <bread+0x86>
  panic("bget: no buffers");
    8000259c:	00006517          	auipc	a0,0x6
    800025a0:	f6450513          	addi	a0,a0,-156 # 80008500 <syscalls+0x108>
    800025a4:	00004097          	auipc	ra,0x4
    800025a8:	834080e7          	jalr	-1996(ra) # 80005dd8 <panic>
      b->dev = dev;
    800025ac:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800025b0:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025b4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025b8:	4785                	li	a5,1
    800025ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025bc:	0000d517          	auipc	a0,0xd
    800025c0:	adc50513          	addi	a0,a0,-1316 # 8000f098 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	e12080e7          	jalr	-494(ra) # 800063d6 <release>
      acquiresleep(&b->lock);
    800025cc:	01048513          	addi	a0,s1,16
    800025d0:	00001097          	auipc	ra,0x1
    800025d4:	408080e7          	jalr	1032(ra) # 800039d8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025d8:	409c                	lw	a5,0(s1)
    800025da:	cb89                	beqz	a5,800025ec <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025dc:	8526                	mv	a0,s1
    800025de:	70a2                	ld	ra,40(sp)
    800025e0:	7402                	ld	s0,32(sp)
    800025e2:	64e2                	ld	s1,24(sp)
    800025e4:	6942                	ld	s2,16(sp)
    800025e6:	69a2                	ld	s3,8(sp)
    800025e8:	6145                	addi	sp,sp,48
    800025ea:	8082                	ret
    virtio_disk_rw(b, 0);
    800025ec:	4581                	li	a1,0
    800025ee:	8526                	mv	a0,s1
    800025f0:	00003097          	auipc	ra,0x3
    800025f4:	f26080e7          	jalr	-218(ra) # 80005516 <virtio_disk_rw>
    b->valid = 1;
    800025f8:	4785                	li	a5,1
    800025fa:	c09c                	sw	a5,0(s1)
  return b;
    800025fc:	b7c5                	j	800025dc <bread+0xd0>

00000000800025fe <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025fe:	1101                	addi	sp,sp,-32
    80002600:	ec06                	sd	ra,24(sp)
    80002602:	e822                	sd	s0,16(sp)
    80002604:	e426                	sd	s1,8(sp)
    80002606:	1000                	addi	s0,sp,32
    80002608:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000260a:	0541                	addi	a0,a0,16
    8000260c:	00001097          	auipc	ra,0x1
    80002610:	466080e7          	jalr	1126(ra) # 80003a72 <holdingsleep>
    80002614:	cd01                	beqz	a0,8000262c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002616:	4585                	li	a1,1
    80002618:	8526                	mv	a0,s1
    8000261a:	00003097          	auipc	ra,0x3
    8000261e:	efc080e7          	jalr	-260(ra) # 80005516 <virtio_disk_rw>
}
    80002622:	60e2                	ld	ra,24(sp)
    80002624:	6442                	ld	s0,16(sp)
    80002626:	64a2                	ld	s1,8(sp)
    80002628:	6105                	addi	sp,sp,32
    8000262a:	8082                	ret
    panic("bwrite");
    8000262c:	00006517          	auipc	a0,0x6
    80002630:	eec50513          	addi	a0,a0,-276 # 80008518 <syscalls+0x120>
    80002634:	00003097          	auipc	ra,0x3
    80002638:	7a4080e7          	jalr	1956(ra) # 80005dd8 <panic>

000000008000263c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000263c:	1101                	addi	sp,sp,-32
    8000263e:	ec06                	sd	ra,24(sp)
    80002640:	e822                	sd	s0,16(sp)
    80002642:	e426                	sd	s1,8(sp)
    80002644:	e04a                	sd	s2,0(sp)
    80002646:	1000                	addi	s0,sp,32
    80002648:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000264a:	01050913          	addi	s2,a0,16
    8000264e:	854a                	mv	a0,s2
    80002650:	00001097          	auipc	ra,0x1
    80002654:	422080e7          	jalr	1058(ra) # 80003a72 <holdingsleep>
    80002658:	c92d                	beqz	a0,800026ca <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000265a:	854a                	mv	a0,s2
    8000265c:	00001097          	auipc	ra,0x1
    80002660:	3d2080e7          	jalr	978(ra) # 80003a2e <releasesleep>

  acquire(&bcache.lock);
    80002664:	0000d517          	auipc	a0,0xd
    80002668:	a3450513          	addi	a0,a0,-1484 # 8000f098 <bcache>
    8000266c:	00004097          	auipc	ra,0x4
    80002670:	cb6080e7          	jalr	-842(ra) # 80006322 <acquire>
  b->refcnt--;
    80002674:	40bc                	lw	a5,64(s1)
    80002676:	37fd                	addiw	a5,a5,-1
    80002678:	0007871b          	sext.w	a4,a5
    8000267c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000267e:	eb05                	bnez	a4,800026ae <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002680:	68bc                	ld	a5,80(s1)
    80002682:	64b8                	ld	a4,72(s1)
    80002684:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002686:	64bc                	ld	a5,72(s1)
    80002688:	68b8                	ld	a4,80(s1)
    8000268a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000268c:	00015797          	auipc	a5,0x15
    80002690:	a0c78793          	addi	a5,a5,-1524 # 80017098 <bcache+0x8000>
    80002694:	2b87b703          	ld	a4,696(a5)
    80002698:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000269a:	00015717          	auipc	a4,0x15
    8000269e:	c6670713          	addi	a4,a4,-922 # 80017300 <bcache+0x8268>
    800026a2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026a4:	2b87b703          	ld	a4,696(a5)
    800026a8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026aa:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026ae:	0000d517          	auipc	a0,0xd
    800026b2:	9ea50513          	addi	a0,a0,-1558 # 8000f098 <bcache>
    800026b6:	00004097          	auipc	ra,0x4
    800026ba:	d20080e7          	jalr	-736(ra) # 800063d6 <release>
}
    800026be:	60e2                	ld	ra,24(sp)
    800026c0:	6442                	ld	s0,16(sp)
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	6902                	ld	s2,0(sp)
    800026c6:	6105                	addi	sp,sp,32
    800026c8:	8082                	ret
    panic("brelse");
    800026ca:	00006517          	auipc	a0,0x6
    800026ce:	e5650513          	addi	a0,a0,-426 # 80008520 <syscalls+0x128>
    800026d2:	00003097          	auipc	ra,0x3
    800026d6:	706080e7          	jalr	1798(ra) # 80005dd8 <panic>

00000000800026da <bpin>:

void
bpin(struct buf *b) {
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	1000                	addi	s0,sp,32
    800026e4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026e6:	0000d517          	auipc	a0,0xd
    800026ea:	9b250513          	addi	a0,a0,-1614 # 8000f098 <bcache>
    800026ee:	00004097          	auipc	ra,0x4
    800026f2:	c34080e7          	jalr	-972(ra) # 80006322 <acquire>
  b->refcnt++;
    800026f6:	40bc                	lw	a5,64(s1)
    800026f8:	2785                	addiw	a5,a5,1
    800026fa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026fc:	0000d517          	auipc	a0,0xd
    80002700:	99c50513          	addi	a0,a0,-1636 # 8000f098 <bcache>
    80002704:	00004097          	auipc	ra,0x4
    80002708:	cd2080e7          	jalr	-814(ra) # 800063d6 <release>
}
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6105                	addi	sp,sp,32
    80002714:	8082                	ret

0000000080002716 <bunpin>:

void
bunpin(struct buf *b) {
    80002716:	1101                	addi	sp,sp,-32
    80002718:	ec06                	sd	ra,24(sp)
    8000271a:	e822                	sd	s0,16(sp)
    8000271c:	e426                	sd	s1,8(sp)
    8000271e:	1000                	addi	s0,sp,32
    80002720:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002722:	0000d517          	auipc	a0,0xd
    80002726:	97650513          	addi	a0,a0,-1674 # 8000f098 <bcache>
    8000272a:	00004097          	auipc	ra,0x4
    8000272e:	bf8080e7          	jalr	-1032(ra) # 80006322 <acquire>
  b->refcnt--;
    80002732:	40bc                	lw	a5,64(s1)
    80002734:	37fd                	addiw	a5,a5,-1
    80002736:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002738:	0000d517          	auipc	a0,0xd
    8000273c:	96050513          	addi	a0,a0,-1696 # 8000f098 <bcache>
    80002740:	00004097          	auipc	ra,0x4
    80002744:	c96080e7          	jalr	-874(ra) # 800063d6 <release>
}
    80002748:	60e2                	ld	ra,24(sp)
    8000274a:	6442                	ld	s0,16(sp)
    8000274c:	64a2                	ld	s1,8(sp)
    8000274e:	6105                	addi	sp,sp,32
    80002750:	8082                	ret

0000000080002752 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002752:	1101                	addi	sp,sp,-32
    80002754:	ec06                	sd	ra,24(sp)
    80002756:	e822                	sd	s0,16(sp)
    80002758:	e426                	sd	s1,8(sp)
    8000275a:	e04a                	sd	s2,0(sp)
    8000275c:	1000                	addi	s0,sp,32
    8000275e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002760:	00d5d59b          	srliw	a1,a1,0xd
    80002764:	00015797          	auipc	a5,0x15
    80002768:	0107a783          	lw	a5,16(a5) # 80017774 <sb+0x1c>
    8000276c:	9dbd                	addw	a1,a1,a5
    8000276e:	00000097          	auipc	ra,0x0
    80002772:	d9e080e7          	jalr	-610(ra) # 8000250c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002776:	0074f713          	andi	a4,s1,7
    8000277a:	4785                	li	a5,1
    8000277c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002780:	14ce                	slli	s1,s1,0x33
    80002782:	90d9                	srli	s1,s1,0x36
    80002784:	00950733          	add	a4,a0,s1
    80002788:	05874703          	lbu	a4,88(a4)
    8000278c:	00e7f6b3          	and	a3,a5,a4
    80002790:	c69d                	beqz	a3,800027be <bfree+0x6c>
    80002792:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002794:	94aa                	add	s1,s1,a0
    80002796:	fff7c793          	not	a5,a5
    8000279a:	8ff9                	and	a5,a5,a4
    8000279c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027a0:	00001097          	auipc	ra,0x1
    800027a4:	118080e7          	jalr	280(ra) # 800038b8 <log_write>
  brelse(bp);
    800027a8:	854a                	mv	a0,s2
    800027aa:	00000097          	auipc	ra,0x0
    800027ae:	e92080e7          	jalr	-366(ra) # 8000263c <brelse>
}
    800027b2:	60e2                	ld	ra,24(sp)
    800027b4:	6442                	ld	s0,16(sp)
    800027b6:	64a2                	ld	s1,8(sp)
    800027b8:	6902                	ld	s2,0(sp)
    800027ba:	6105                	addi	sp,sp,32
    800027bc:	8082                	ret
    panic("freeing free block");
    800027be:	00006517          	auipc	a0,0x6
    800027c2:	d6a50513          	addi	a0,a0,-662 # 80008528 <syscalls+0x130>
    800027c6:	00003097          	auipc	ra,0x3
    800027ca:	612080e7          	jalr	1554(ra) # 80005dd8 <panic>

00000000800027ce <balloc>:
{
    800027ce:	711d                	addi	sp,sp,-96
    800027d0:	ec86                	sd	ra,88(sp)
    800027d2:	e8a2                	sd	s0,80(sp)
    800027d4:	e4a6                	sd	s1,72(sp)
    800027d6:	e0ca                	sd	s2,64(sp)
    800027d8:	fc4e                	sd	s3,56(sp)
    800027da:	f852                	sd	s4,48(sp)
    800027dc:	f456                	sd	s5,40(sp)
    800027de:	f05a                	sd	s6,32(sp)
    800027e0:	ec5e                	sd	s7,24(sp)
    800027e2:	e862                	sd	s8,16(sp)
    800027e4:	e466                	sd	s9,8(sp)
    800027e6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027e8:	00015797          	auipc	a5,0x15
    800027ec:	f747a783          	lw	a5,-140(a5) # 8001775c <sb+0x4>
    800027f0:	cbd1                	beqz	a5,80002884 <balloc+0xb6>
    800027f2:	8baa                	mv	s7,a0
    800027f4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027f6:	00015b17          	auipc	s6,0x15
    800027fa:	f62b0b13          	addi	s6,s6,-158 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fe:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002800:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002802:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002804:	6c89                	lui	s9,0x2
    80002806:	a831                	j	80002822 <balloc+0x54>
    brelse(bp);
    80002808:	854a                	mv	a0,s2
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	e32080e7          	jalr	-462(ra) # 8000263c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002812:	015c87bb          	addw	a5,s9,s5
    80002816:	00078a9b          	sext.w	s5,a5
    8000281a:	004b2703          	lw	a4,4(s6)
    8000281e:	06eaf363          	bgeu	s5,a4,80002884 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002822:	41fad79b          	sraiw	a5,s5,0x1f
    80002826:	0137d79b          	srliw	a5,a5,0x13
    8000282a:	015787bb          	addw	a5,a5,s5
    8000282e:	40d7d79b          	sraiw	a5,a5,0xd
    80002832:	01cb2583          	lw	a1,28(s6)
    80002836:	9dbd                	addw	a1,a1,a5
    80002838:	855e                	mv	a0,s7
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	cd2080e7          	jalr	-814(ra) # 8000250c <bread>
    80002842:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002844:	004b2503          	lw	a0,4(s6)
    80002848:	000a849b          	sext.w	s1,s5
    8000284c:	8662                	mv	a2,s8
    8000284e:	faa4fde3          	bgeu	s1,a0,80002808 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002852:	41f6579b          	sraiw	a5,a2,0x1f
    80002856:	01d7d69b          	srliw	a3,a5,0x1d
    8000285a:	00c6873b          	addw	a4,a3,a2
    8000285e:	00777793          	andi	a5,a4,7
    80002862:	9f95                	subw	a5,a5,a3
    80002864:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002868:	4037571b          	sraiw	a4,a4,0x3
    8000286c:	00e906b3          	add	a3,s2,a4
    80002870:	0586c683          	lbu	a3,88(a3)
    80002874:	00d7f5b3          	and	a1,a5,a3
    80002878:	cd91                	beqz	a1,80002894 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000287a:	2605                	addiw	a2,a2,1
    8000287c:	2485                	addiw	s1,s1,1
    8000287e:	fd4618e3          	bne	a2,s4,8000284e <balloc+0x80>
    80002882:	b759                	j	80002808 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002884:	00006517          	auipc	a0,0x6
    80002888:	cbc50513          	addi	a0,a0,-836 # 80008540 <syscalls+0x148>
    8000288c:	00003097          	auipc	ra,0x3
    80002890:	54c080e7          	jalr	1356(ra) # 80005dd8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002894:	974a                	add	a4,a4,s2
    80002896:	8fd5                	or	a5,a5,a3
    80002898:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000289c:	854a                	mv	a0,s2
    8000289e:	00001097          	auipc	ra,0x1
    800028a2:	01a080e7          	jalr	26(ra) # 800038b8 <log_write>
        brelse(bp);
    800028a6:	854a                	mv	a0,s2
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	d94080e7          	jalr	-620(ra) # 8000263c <brelse>
  bp = bread(dev, bno);
    800028b0:	85a6                	mv	a1,s1
    800028b2:	855e                	mv	a0,s7
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	c58080e7          	jalr	-936(ra) # 8000250c <bread>
    800028bc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028be:	40000613          	li	a2,1024
    800028c2:	4581                	li	a1,0
    800028c4:	05850513          	addi	a0,a0,88
    800028c8:	ffffe097          	auipc	ra,0xffffe
    800028cc:	8b0080e7          	jalr	-1872(ra) # 80000178 <memset>
  log_write(bp);
    800028d0:	854a                	mv	a0,s2
    800028d2:	00001097          	auipc	ra,0x1
    800028d6:	fe6080e7          	jalr	-26(ra) # 800038b8 <log_write>
  brelse(bp);
    800028da:	854a                	mv	a0,s2
    800028dc:	00000097          	auipc	ra,0x0
    800028e0:	d60080e7          	jalr	-672(ra) # 8000263c <brelse>
}
    800028e4:	8526                	mv	a0,s1
    800028e6:	60e6                	ld	ra,88(sp)
    800028e8:	6446                	ld	s0,80(sp)
    800028ea:	64a6                	ld	s1,72(sp)
    800028ec:	6906                	ld	s2,64(sp)
    800028ee:	79e2                	ld	s3,56(sp)
    800028f0:	7a42                	ld	s4,48(sp)
    800028f2:	7aa2                	ld	s5,40(sp)
    800028f4:	7b02                	ld	s6,32(sp)
    800028f6:	6be2                	ld	s7,24(sp)
    800028f8:	6c42                	ld	s8,16(sp)
    800028fa:	6ca2                	ld	s9,8(sp)
    800028fc:	6125                	addi	sp,sp,96
    800028fe:	8082                	ret

0000000080002900 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002900:	7179                	addi	sp,sp,-48
    80002902:	f406                	sd	ra,40(sp)
    80002904:	f022                	sd	s0,32(sp)
    80002906:	ec26                	sd	s1,24(sp)
    80002908:	e84a                	sd	s2,16(sp)
    8000290a:	e44e                	sd	s3,8(sp)
    8000290c:	e052                	sd	s4,0(sp)
    8000290e:	1800                	addi	s0,sp,48
    80002910:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002912:	47ad                	li	a5,11
    80002914:	04b7fe63          	bgeu	a5,a1,80002970 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002918:	ff45849b          	addiw	s1,a1,-12
    8000291c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002920:	0ff00793          	li	a5,255
    80002924:	0ae7e363          	bltu	a5,a4,800029ca <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002928:	08052583          	lw	a1,128(a0)
    8000292c:	c5ad                	beqz	a1,80002996 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000292e:	00092503          	lw	a0,0(s2)
    80002932:	00000097          	auipc	ra,0x0
    80002936:	bda080e7          	jalr	-1062(ra) # 8000250c <bread>
    8000293a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000293c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002940:	02049593          	slli	a1,s1,0x20
    80002944:	9181                	srli	a1,a1,0x20
    80002946:	058a                	slli	a1,a1,0x2
    80002948:	00b784b3          	add	s1,a5,a1
    8000294c:	0004a983          	lw	s3,0(s1)
    80002950:	04098d63          	beqz	s3,800029aa <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002954:	8552                	mv	a0,s4
    80002956:	00000097          	auipc	ra,0x0
    8000295a:	ce6080e7          	jalr	-794(ra) # 8000263c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000295e:	854e                	mv	a0,s3
    80002960:	70a2                	ld	ra,40(sp)
    80002962:	7402                	ld	s0,32(sp)
    80002964:	64e2                	ld	s1,24(sp)
    80002966:	6942                	ld	s2,16(sp)
    80002968:	69a2                	ld	s3,8(sp)
    8000296a:	6a02                	ld	s4,0(sp)
    8000296c:	6145                	addi	sp,sp,48
    8000296e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002970:	02059493          	slli	s1,a1,0x20
    80002974:	9081                	srli	s1,s1,0x20
    80002976:	048a                	slli	s1,s1,0x2
    80002978:	94aa                	add	s1,s1,a0
    8000297a:	0504a983          	lw	s3,80(s1)
    8000297e:	fe0990e3          	bnez	s3,8000295e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002982:	4108                	lw	a0,0(a0)
    80002984:	00000097          	auipc	ra,0x0
    80002988:	e4a080e7          	jalr	-438(ra) # 800027ce <balloc>
    8000298c:	0005099b          	sext.w	s3,a0
    80002990:	0534a823          	sw	s3,80(s1)
    80002994:	b7e9                	j	8000295e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002996:	4108                	lw	a0,0(a0)
    80002998:	00000097          	auipc	ra,0x0
    8000299c:	e36080e7          	jalr	-458(ra) # 800027ce <balloc>
    800029a0:	0005059b          	sext.w	a1,a0
    800029a4:	08b92023          	sw	a1,128(s2)
    800029a8:	b759                	j	8000292e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029aa:	00092503          	lw	a0,0(s2)
    800029ae:	00000097          	auipc	ra,0x0
    800029b2:	e20080e7          	jalr	-480(ra) # 800027ce <balloc>
    800029b6:	0005099b          	sext.w	s3,a0
    800029ba:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029be:	8552                	mv	a0,s4
    800029c0:	00001097          	auipc	ra,0x1
    800029c4:	ef8080e7          	jalr	-264(ra) # 800038b8 <log_write>
    800029c8:	b771                	j	80002954 <bmap+0x54>
  panic("bmap: out of range");
    800029ca:	00006517          	auipc	a0,0x6
    800029ce:	b8e50513          	addi	a0,a0,-1138 # 80008558 <syscalls+0x160>
    800029d2:	00003097          	auipc	ra,0x3
    800029d6:	406080e7          	jalr	1030(ra) # 80005dd8 <panic>

00000000800029da <iget>:
{
    800029da:	7179                	addi	sp,sp,-48
    800029dc:	f406                	sd	ra,40(sp)
    800029de:	f022                	sd	s0,32(sp)
    800029e0:	ec26                	sd	s1,24(sp)
    800029e2:	e84a                	sd	s2,16(sp)
    800029e4:	e44e                	sd	s3,8(sp)
    800029e6:	e052                	sd	s4,0(sp)
    800029e8:	1800                	addi	s0,sp,48
    800029ea:	89aa                	mv	s3,a0
    800029ec:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029ee:	00015517          	auipc	a0,0x15
    800029f2:	d8a50513          	addi	a0,a0,-630 # 80017778 <itable>
    800029f6:	00004097          	auipc	ra,0x4
    800029fa:	92c080e7          	jalr	-1748(ra) # 80006322 <acquire>
  empty = 0;
    800029fe:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a00:	00015497          	auipc	s1,0x15
    80002a04:	d9048493          	addi	s1,s1,-624 # 80017790 <itable+0x18>
    80002a08:	00017697          	auipc	a3,0x17
    80002a0c:	81868693          	addi	a3,a3,-2024 # 80019220 <log>
    80002a10:	a039                	j	80002a1e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a12:	02090b63          	beqz	s2,80002a48 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a16:	08848493          	addi	s1,s1,136
    80002a1a:	02d48a63          	beq	s1,a3,80002a4e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a1e:	449c                	lw	a5,8(s1)
    80002a20:	fef059e3          	blez	a5,80002a12 <iget+0x38>
    80002a24:	4098                	lw	a4,0(s1)
    80002a26:	ff3716e3          	bne	a4,s3,80002a12 <iget+0x38>
    80002a2a:	40d8                	lw	a4,4(s1)
    80002a2c:	ff4713e3          	bne	a4,s4,80002a12 <iget+0x38>
      ip->ref++;
    80002a30:	2785                	addiw	a5,a5,1
    80002a32:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a34:	00015517          	auipc	a0,0x15
    80002a38:	d4450513          	addi	a0,a0,-700 # 80017778 <itable>
    80002a3c:	00004097          	auipc	ra,0x4
    80002a40:	99a080e7          	jalr	-1638(ra) # 800063d6 <release>
      return ip;
    80002a44:	8926                	mv	s2,s1
    80002a46:	a03d                	j	80002a74 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a48:	f7f9                	bnez	a5,80002a16 <iget+0x3c>
    80002a4a:	8926                	mv	s2,s1
    80002a4c:	b7e9                	j	80002a16 <iget+0x3c>
  if(empty == 0)
    80002a4e:	02090c63          	beqz	s2,80002a86 <iget+0xac>
  ip->dev = dev;
    80002a52:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a56:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a5a:	4785                	li	a5,1
    80002a5c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a60:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a64:	00015517          	auipc	a0,0x15
    80002a68:	d1450513          	addi	a0,a0,-748 # 80017778 <itable>
    80002a6c:	00004097          	auipc	ra,0x4
    80002a70:	96a080e7          	jalr	-1686(ra) # 800063d6 <release>
}
    80002a74:	854a                	mv	a0,s2
    80002a76:	70a2                	ld	ra,40(sp)
    80002a78:	7402                	ld	s0,32(sp)
    80002a7a:	64e2                	ld	s1,24(sp)
    80002a7c:	6942                	ld	s2,16(sp)
    80002a7e:	69a2                	ld	s3,8(sp)
    80002a80:	6a02                	ld	s4,0(sp)
    80002a82:	6145                	addi	sp,sp,48
    80002a84:	8082                	ret
    panic("iget: no inodes");
    80002a86:	00006517          	auipc	a0,0x6
    80002a8a:	aea50513          	addi	a0,a0,-1302 # 80008570 <syscalls+0x178>
    80002a8e:	00003097          	auipc	ra,0x3
    80002a92:	34a080e7          	jalr	842(ra) # 80005dd8 <panic>

0000000080002a96 <fsinit>:
fsinit(int dev) {
    80002a96:	7179                	addi	sp,sp,-48
    80002a98:	f406                	sd	ra,40(sp)
    80002a9a:	f022                	sd	s0,32(sp)
    80002a9c:	ec26                	sd	s1,24(sp)
    80002a9e:	e84a                	sd	s2,16(sp)
    80002aa0:	e44e                	sd	s3,8(sp)
    80002aa2:	1800                	addi	s0,sp,48
    80002aa4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aa6:	4585                	li	a1,1
    80002aa8:	00000097          	auipc	ra,0x0
    80002aac:	a64080e7          	jalr	-1436(ra) # 8000250c <bread>
    80002ab0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ab2:	00015997          	auipc	s3,0x15
    80002ab6:	ca698993          	addi	s3,s3,-858 # 80017758 <sb>
    80002aba:	02000613          	li	a2,32
    80002abe:	05850593          	addi	a1,a0,88
    80002ac2:	854e                	mv	a0,s3
    80002ac4:	ffffd097          	auipc	ra,0xffffd
    80002ac8:	714080e7          	jalr	1812(ra) # 800001d8 <memmove>
  brelse(bp);
    80002acc:	8526                	mv	a0,s1
    80002ace:	00000097          	auipc	ra,0x0
    80002ad2:	b6e080e7          	jalr	-1170(ra) # 8000263c <brelse>
  if(sb.magic != FSMAGIC)
    80002ad6:	0009a703          	lw	a4,0(s3)
    80002ada:	102037b7          	lui	a5,0x10203
    80002ade:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ae2:	02f71263          	bne	a4,a5,80002b06 <fsinit+0x70>
  initlog(dev, &sb);
    80002ae6:	00015597          	auipc	a1,0x15
    80002aea:	c7258593          	addi	a1,a1,-910 # 80017758 <sb>
    80002aee:	854a                	mv	a0,s2
    80002af0:	00001097          	auipc	ra,0x1
    80002af4:	b4c080e7          	jalr	-1204(ra) # 8000363c <initlog>
}
    80002af8:	70a2                	ld	ra,40(sp)
    80002afa:	7402                	ld	s0,32(sp)
    80002afc:	64e2                	ld	s1,24(sp)
    80002afe:	6942                	ld	s2,16(sp)
    80002b00:	69a2                	ld	s3,8(sp)
    80002b02:	6145                	addi	sp,sp,48
    80002b04:	8082                	ret
    panic("invalid file system");
    80002b06:	00006517          	auipc	a0,0x6
    80002b0a:	a7a50513          	addi	a0,a0,-1414 # 80008580 <syscalls+0x188>
    80002b0e:	00003097          	auipc	ra,0x3
    80002b12:	2ca080e7          	jalr	714(ra) # 80005dd8 <panic>

0000000080002b16 <iinit>:
{
    80002b16:	7179                	addi	sp,sp,-48
    80002b18:	f406                	sd	ra,40(sp)
    80002b1a:	f022                	sd	s0,32(sp)
    80002b1c:	ec26                	sd	s1,24(sp)
    80002b1e:	e84a                	sd	s2,16(sp)
    80002b20:	e44e                	sd	s3,8(sp)
    80002b22:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b24:	00006597          	auipc	a1,0x6
    80002b28:	a7458593          	addi	a1,a1,-1420 # 80008598 <syscalls+0x1a0>
    80002b2c:	00015517          	auipc	a0,0x15
    80002b30:	c4c50513          	addi	a0,a0,-948 # 80017778 <itable>
    80002b34:	00003097          	auipc	ra,0x3
    80002b38:	75e080e7          	jalr	1886(ra) # 80006292 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b3c:	00015497          	auipc	s1,0x15
    80002b40:	c6448493          	addi	s1,s1,-924 # 800177a0 <itable+0x28>
    80002b44:	00016997          	auipc	s3,0x16
    80002b48:	6ec98993          	addi	s3,s3,1772 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b4c:	00006917          	auipc	s2,0x6
    80002b50:	a5490913          	addi	s2,s2,-1452 # 800085a0 <syscalls+0x1a8>
    80002b54:	85ca                	mv	a1,s2
    80002b56:	8526                	mv	a0,s1
    80002b58:	00001097          	auipc	ra,0x1
    80002b5c:	e46080e7          	jalr	-442(ra) # 8000399e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b60:	08848493          	addi	s1,s1,136
    80002b64:	ff3498e3          	bne	s1,s3,80002b54 <iinit+0x3e>
}
    80002b68:	70a2                	ld	ra,40(sp)
    80002b6a:	7402                	ld	s0,32(sp)
    80002b6c:	64e2                	ld	s1,24(sp)
    80002b6e:	6942                	ld	s2,16(sp)
    80002b70:	69a2                	ld	s3,8(sp)
    80002b72:	6145                	addi	sp,sp,48
    80002b74:	8082                	ret

0000000080002b76 <ialloc>:
{
    80002b76:	715d                	addi	sp,sp,-80
    80002b78:	e486                	sd	ra,72(sp)
    80002b7a:	e0a2                	sd	s0,64(sp)
    80002b7c:	fc26                	sd	s1,56(sp)
    80002b7e:	f84a                	sd	s2,48(sp)
    80002b80:	f44e                	sd	s3,40(sp)
    80002b82:	f052                	sd	s4,32(sp)
    80002b84:	ec56                	sd	s5,24(sp)
    80002b86:	e85a                	sd	s6,16(sp)
    80002b88:	e45e                	sd	s7,8(sp)
    80002b8a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b8c:	00015717          	auipc	a4,0x15
    80002b90:	bd872703          	lw	a4,-1064(a4) # 80017764 <sb+0xc>
    80002b94:	4785                	li	a5,1
    80002b96:	04e7fa63          	bgeu	a5,a4,80002bea <ialloc+0x74>
    80002b9a:	8aaa                	mv	s5,a0
    80002b9c:	8bae                	mv	s7,a1
    80002b9e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ba0:	00015a17          	auipc	s4,0x15
    80002ba4:	bb8a0a13          	addi	s4,s4,-1096 # 80017758 <sb>
    80002ba8:	00048b1b          	sext.w	s6,s1
    80002bac:	0044d593          	srli	a1,s1,0x4
    80002bb0:	018a2783          	lw	a5,24(s4)
    80002bb4:	9dbd                	addw	a1,a1,a5
    80002bb6:	8556                	mv	a0,s5
    80002bb8:	00000097          	auipc	ra,0x0
    80002bbc:	954080e7          	jalr	-1708(ra) # 8000250c <bread>
    80002bc0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bc2:	05850993          	addi	s3,a0,88
    80002bc6:	00f4f793          	andi	a5,s1,15
    80002bca:	079a                	slli	a5,a5,0x6
    80002bcc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bce:	00099783          	lh	a5,0(s3)
    80002bd2:	c785                	beqz	a5,80002bfa <ialloc+0x84>
    brelse(bp);
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	a68080e7          	jalr	-1432(ra) # 8000263c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bdc:	0485                	addi	s1,s1,1
    80002bde:	00ca2703          	lw	a4,12(s4)
    80002be2:	0004879b          	sext.w	a5,s1
    80002be6:	fce7e1e3          	bltu	a5,a4,80002ba8 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bea:	00006517          	auipc	a0,0x6
    80002bee:	9be50513          	addi	a0,a0,-1602 # 800085a8 <syscalls+0x1b0>
    80002bf2:	00003097          	auipc	ra,0x3
    80002bf6:	1e6080e7          	jalr	486(ra) # 80005dd8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bfa:	04000613          	li	a2,64
    80002bfe:	4581                	li	a1,0
    80002c00:	854e                	mv	a0,s3
    80002c02:	ffffd097          	auipc	ra,0xffffd
    80002c06:	576080e7          	jalr	1398(ra) # 80000178 <memset>
      dip->type = type;
    80002c0a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c0e:	854a                	mv	a0,s2
    80002c10:	00001097          	auipc	ra,0x1
    80002c14:	ca8080e7          	jalr	-856(ra) # 800038b8 <log_write>
      brelse(bp);
    80002c18:	854a                	mv	a0,s2
    80002c1a:	00000097          	auipc	ra,0x0
    80002c1e:	a22080e7          	jalr	-1502(ra) # 8000263c <brelse>
      return iget(dev, inum);
    80002c22:	85da                	mv	a1,s6
    80002c24:	8556                	mv	a0,s5
    80002c26:	00000097          	auipc	ra,0x0
    80002c2a:	db4080e7          	jalr	-588(ra) # 800029da <iget>
}
    80002c2e:	60a6                	ld	ra,72(sp)
    80002c30:	6406                	ld	s0,64(sp)
    80002c32:	74e2                	ld	s1,56(sp)
    80002c34:	7942                	ld	s2,48(sp)
    80002c36:	79a2                	ld	s3,40(sp)
    80002c38:	7a02                	ld	s4,32(sp)
    80002c3a:	6ae2                	ld	s5,24(sp)
    80002c3c:	6b42                	ld	s6,16(sp)
    80002c3e:	6ba2                	ld	s7,8(sp)
    80002c40:	6161                	addi	sp,sp,80
    80002c42:	8082                	ret

0000000080002c44 <iupdate>:
{
    80002c44:	1101                	addi	sp,sp,-32
    80002c46:	ec06                	sd	ra,24(sp)
    80002c48:	e822                	sd	s0,16(sp)
    80002c4a:	e426                	sd	s1,8(sp)
    80002c4c:	e04a                	sd	s2,0(sp)
    80002c4e:	1000                	addi	s0,sp,32
    80002c50:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c52:	415c                	lw	a5,4(a0)
    80002c54:	0047d79b          	srliw	a5,a5,0x4
    80002c58:	00015597          	auipc	a1,0x15
    80002c5c:	b185a583          	lw	a1,-1256(a1) # 80017770 <sb+0x18>
    80002c60:	9dbd                	addw	a1,a1,a5
    80002c62:	4108                	lw	a0,0(a0)
    80002c64:	00000097          	auipc	ra,0x0
    80002c68:	8a8080e7          	jalr	-1880(ra) # 8000250c <bread>
    80002c6c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c6e:	05850793          	addi	a5,a0,88
    80002c72:	40c8                	lw	a0,4(s1)
    80002c74:	893d                	andi	a0,a0,15
    80002c76:	051a                	slli	a0,a0,0x6
    80002c78:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c7a:	04449703          	lh	a4,68(s1)
    80002c7e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c82:	04649703          	lh	a4,70(s1)
    80002c86:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c8a:	04849703          	lh	a4,72(s1)
    80002c8e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c92:	04a49703          	lh	a4,74(s1)
    80002c96:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c9a:	44f8                	lw	a4,76(s1)
    80002c9c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c9e:	03400613          	li	a2,52
    80002ca2:	05048593          	addi	a1,s1,80
    80002ca6:	0531                	addi	a0,a0,12
    80002ca8:	ffffd097          	auipc	ra,0xffffd
    80002cac:	530080e7          	jalr	1328(ra) # 800001d8 <memmove>
  log_write(bp);
    80002cb0:	854a                	mv	a0,s2
    80002cb2:	00001097          	auipc	ra,0x1
    80002cb6:	c06080e7          	jalr	-1018(ra) # 800038b8 <log_write>
  brelse(bp);
    80002cba:	854a                	mv	a0,s2
    80002cbc:	00000097          	auipc	ra,0x0
    80002cc0:	980080e7          	jalr	-1664(ra) # 8000263c <brelse>
}
    80002cc4:	60e2                	ld	ra,24(sp)
    80002cc6:	6442                	ld	s0,16(sp)
    80002cc8:	64a2                	ld	s1,8(sp)
    80002cca:	6902                	ld	s2,0(sp)
    80002ccc:	6105                	addi	sp,sp,32
    80002cce:	8082                	ret

0000000080002cd0 <idup>:
{
    80002cd0:	1101                	addi	sp,sp,-32
    80002cd2:	ec06                	sd	ra,24(sp)
    80002cd4:	e822                	sd	s0,16(sp)
    80002cd6:	e426                	sd	s1,8(sp)
    80002cd8:	1000                	addi	s0,sp,32
    80002cda:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cdc:	00015517          	auipc	a0,0x15
    80002ce0:	a9c50513          	addi	a0,a0,-1380 # 80017778 <itable>
    80002ce4:	00003097          	auipc	ra,0x3
    80002ce8:	63e080e7          	jalr	1598(ra) # 80006322 <acquire>
  ip->ref++;
    80002cec:	449c                	lw	a5,8(s1)
    80002cee:	2785                	addiw	a5,a5,1
    80002cf0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cf2:	00015517          	auipc	a0,0x15
    80002cf6:	a8650513          	addi	a0,a0,-1402 # 80017778 <itable>
    80002cfa:	00003097          	auipc	ra,0x3
    80002cfe:	6dc080e7          	jalr	1756(ra) # 800063d6 <release>
}
    80002d02:	8526                	mv	a0,s1
    80002d04:	60e2                	ld	ra,24(sp)
    80002d06:	6442                	ld	s0,16(sp)
    80002d08:	64a2                	ld	s1,8(sp)
    80002d0a:	6105                	addi	sp,sp,32
    80002d0c:	8082                	ret

0000000080002d0e <ilock>:
{
    80002d0e:	1101                	addi	sp,sp,-32
    80002d10:	ec06                	sd	ra,24(sp)
    80002d12:	e822                	sd	s0,16(sp)
    80002d14:	e426                	sd	s1,8(sp)
    80002d16:	e04a                	sd	s2,0(sp)
    80002d18:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d1a:	c115                	beqz	a0,80002d3e <ilock+0x30>
    80002d1c:	84aa                	mv	s1,a0
    80002d1e:	451c                	lw	a5,8(a0)
    80002d20:	00f05f63          	blez	a5,80002d3e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d24:	0541                	addi	a0,a0,16
    80002d26:	00001097          	auipc	ra,0x1
    80002d2a:	cb2080e7          	jalr	-846(ra) # 800039d8 <acquiresleep>
  if(ip->valid == 0){
    80002d2e:	40bc                	lw	a5,64(s1)
    80002d30:	cf99                	beqz	a5,80002d4e <ilock+0x40>
}
    80002d32:	60e2                	ld	ra,24(sp)
    80002d34:	6442                	ld	s0,16(sp)
    80002d36:	64a2                	ld	s1,8(sp)
    80002d38:	6902                	ld	s2,0(sp)
    80002d3a:	6105                	addi	sp,sp,32
    80002d3c:	8082                	ret
    panic("ilock");
    80002d3e:	00006517          	auipc	a0,0x6
    80002d42:	88250513          	addi	a0,a0,-1918 # 800085c0 <syscalls+0x1c8>
    80002d46:	00003097          	auipc	ra,0x3
    80002d4a:	092080e7          	jalr	146(ra) # 80005dd8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d4e:	40dc                	lw	a5,4(s1)
    80002d50:	0047d79b          	srliw	a5,a5,0x4
    80002d54:	00015597          	auipc	a1,0x15
    80002d58:	a1c5a583          	lw	a1,-1508(a1) # 80017770 <sb+0x18>
    80002d5c:	9dbd                	addw	a1,a1,a5
    80002d5e:	4088                	lw	a0,0(s1)
    80002d60:	fffff097          	auipc	ra,0xfffff
    80002d64:	7ac080e7          	jalr	1964(ra) # 8000250c <bread>
    80002d68:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d6a:	05850593          	addi	a1,a0,88
    80002d6e:	40dc                	lw	a5,4(s1)
    80002d70:	8bbd                	andi	a5,a5,15
    80002d72:	079a                	slli	a5,a5,0x6
    80002d74:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d76:	00059783          	lh	a5,0(a1)
    80002d7a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d7e:	00259783          	lh	a5,2(a1)
    80002d82:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d86:	00459783          	lh	a5,4(a1)
    80002d8a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d8e:	00659783          	lh	a5,6(a1)
    80002d92:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d96:	459c                	lw	a5,8(a1)
    80002d98:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d9a:	03400613          	li	a2,52
    80002d9e:	05b1                	addi	a1,a1,12
    80002da0:	05048513          	addi	a0,s1,80
    80002da4:	ffffd097          	auipc	ra,0xffffd
    80002da8:	434080e7          	jalr	1076(ra) # 800001d8 <memmove>
    brelse(bp);
    80002dac:	854a                	mv	a0,s2
    80002dae:	00000097          	auipc	ra,0x0
    80002db2:	88e080e7          	jalr	-1906(ra) # 8000263c <brelse>
    ip->valid = 1;
    80002db6:	4785                	li	a5,1
    80002db8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dba:	04449783          	lh	a5,68(s1)
    80002dbe:	fbb5                	bnez	a5,80002d32 <ilock+0x24>
      panic("ilock: no type");
    80002dc0:	00006517          	auipc	a0,0x6
    80002dc4:	80850513          	addi	a0,a0,-2040 # 800085c8 <syscalls+0x1d0>
    80002dc8:	00003097          	auipc	ra,0x3
    80002dcc:	010080e7          	jalr	16(ra) # 80005dd8 <panic>

0000000080002dd0 <iunlock>:
{
    80002dd0:	1101                	addi	sp,sp,-32
    80002dd2:	ec06                	sd	ra,24(sp)
    80002dd4:	e822                	sd	s0,16(sp)
    80002dd6:	e426                	sd	s1,8(sp)
    80002dd8:	e04a                	sd	s2,0(sp)
    80002dda:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ddc:	c905                	beqz	a0,80002e0c <iunlock+0x3c>
    80002dde:	84aa                	mv	s1,a0
    80002de0:	01050913          	addi	s2,a0,16
    80002de4:	854a                	mv	a0,s2
    80002de6:	00001097          	auipc	ra,0x1
    80002dea:	c8c080e7          	jalr	-884(ra) # 80003a72 <holdingsleep>
    80002dee:	cd19                	beqz	a0,80002e0c <iunlock+0x3c>
    80002df0:	449c                	lw	a5,8(s1)
    80002df2:	00f05d63          	blez	a5,80002e0c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002df6:	854a                	mv	a0,s2
    80002df8:	00001097          	auipc	ra,0x1
    80002dfc:	c36080e7          	jalr	-970(ra) # 80003a2e <releasesleep>
}
    80002e00:	60e2                	ld	ra,24(sp)
    80002e02:	6442                	ld	s0,16(sp)
    80002e04:	64a2                	ld	s1,8(sp)
    80002e06:	6902                	ld	s2,0(sp)
    80002e08:	6105                	addi	sp,sp,32
    80002e0a:	8082                	ret
    panic("iunlock");
    80002e0c:	00005517          	auipc	a0,0x5
    80002e10:	7cc50513          	addi	a0,a0,1996 # 800085d8 <syscalls+0x1e0>
    80002e14:	00003097          	auipc	ra,0x3
    80002e18:	fc4080e7          	jalr	-60(ra) # 80005dd8 <panic>

0000000080002e1c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e1c:	7179                	addi	sp,sp,-48
    80002e1e:	f406                	sd	ra,40(sp)
    80002e20:	f022                	sd	s0,32(sp)
    80002e22:	ec26                	sd	s1,24(sp)
    80002e24:	e84a                	sd	s2,16(sp)
    80002e26:	e44e                	sd	s3,8(sp)
    80002e28:	e052                	sd	s4,0(sp)
    80002e2a:	1800                	addi	s0,sp,48
    80002e2c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e2e:	05050493          	addi	s1,a0,80
    80002e32:	08050913          	addi	s2,a0,128
    80002e36:	a021                	j	80002e3e <itrunc+0x22>
    80002e38:	0491                	addi	s1,s1,4
    80002e3a:	01248d63          	beq	s1,s2,80002e54 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e3e:	408c                	lw	a1,0(s1)
    80002e40:	dde5                	beqz	a1,80002e38 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e42:	0009a503          	lw	a0,0(s3)
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	90c080e7          	jalr	-1780(ra) # 80002752 <bfree>
      ip->addrs[i] = 0;
    80002e4e:	0004a023          	sw	zero,0(s1)
    80002e52:	b7dd                	j	80002e38 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e54:	0809a583          	lw	a1,128(s3)
    80002e58:	e185                	bnez	a1,80002e78 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e5a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e5e:	854e                	mv	a0,s3
    80002e60:	00000097          	auipc	ra,0x0
    80002e64:	de4080e7          	jalr	-540(ra) # 80002c44 <iupdate>
}
    80002e68:	70a2                	ld	ra,40(sp)
    80002e6a:	7402                	ld	s0,32(sp)
    80002e6c:	64e2                	ld	s1,24(sp)
    80002e6e:	6942                	ld	s2,16(sp)
    80002e70:	69a2                	ld	s3,8(sp)
    80002e72:	6a02                	ld	s4,0(sp)
    80002e74:	6145                	addi	sp,sp,48
    80002e76:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e78:	0009a503          	lw	a0,0(s3)
    80002e7c:	fffff097          	auipc	ra,0xfffff
    80002e80:	690080e7          	jalr	1680(ra) # 8000250c <bread>
    80002e84:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e86:	05850493          	addi	s1,a0,88
    80002e8a:	45850913          	addi	s2,a0,1112
    80002e8e:	a811                	j	80002ea2 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e90:	0009a503          	lw	a0,0(s3)
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	8be080e7          	jalr	-1858(ra) # 80002752 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e9c:	0491                	addi	s1,s1,4
    80002e9e:	01248563          	beq	s1,s2,80002ea8 <itrunc+0x8c>
      if(a[j])
    80002ea2:	408c                	lw	a1,0(s1)
    80002ea4:	dde5                	beqz	a1,80002e9c <itrunc+0x80>
    80002ea6:	b7ed                	j	80002e90 <itrunc+0x74>
    brelse(bp);
    80002ea8:	8552                	mv	a0,s4
    80002eaa:	fffff097          	auipc	ra,0xfffff
    80002eae:	792080e7          	jalr	1938(ra) # 8000263c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002eb2:	0809a583          	lw	a1,128(s3)
    80002eb6:	0009a503          	lw	a0,0(s3)
    80002eba:	00000097          	auipc	ra,0x0
    80002ebe:	898080e7          	jalr	-1896(ra) # 80002752 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ec2:	0809a023          	sw	zero,128(s3)
    80002ec6:	bf51                	j	80002e5a <itrunc+0x3e>

0000000080002ec8 <iput>:
{
    80002ec8:	1101                	addi	sp,sp,-32
    80002eca:	ec06                	sd	ra,24(sp)
    80002ecc:	e822                	sd	s0,16(sp)
    80002ece:	e426                	sd	s1,8(sp)
    80002ed0:	e04a                	sd	s2,0(sp)
    80002ed2:	1000                	addi	s0,sp,32
    80002ed4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ed6:	00015517          	auipc	a0,0x15
    80002eda:	8a250513          	addi	a0,a0,-1886 # 80017778 <itable>
    80002ede:	00003097          	auipc	ra,0x3
    80002ee2:	444080e7          	jalr	1092(ra) # 80006322 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ee6:	4498                	lw	a4,8(s1)
    80002ee8:	4785                	li	a5,1
    80002eea:	02f70363          	beq	a4,a5,80002f10 <iput+0x48>
  ip->ref--;
    80002eee:	449c                	lw	a5,8(s1)
    80002ef0:	37fd                	addiw	a5,a5,-1
    80002ef2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ef4:	00015517          	auipc	a0,0x15
    80002ef8:	88450513          	addi	a0,a0,-1916 # 80017778 <itable>
    80002efc:	00003097          	auipc	ra,0x3
    80002f00:	4da080e7          	jalr	1242(ra) # 800063d6 <release>
}
    80002f04:	60e2                	ld	ra,24(sp)
    80002f06:	6442                	ld	s0,16(sp)
    80002f08:	64a2                	ld	s1,8(sp)
    80002f0a:	6902                	ld	s2,0(sp)
    80002f0c:	6105                	addi	sp,sp,32
    80002f0e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f10:	40bc                	lw	a5,64(s1)
    80002f12:	dff1                	beqz	a5,80002eee <iput+0x26>
    80002f14:	04a49783          	lh	a5,74(s1)
    80002f18:	fbf9                	bnez	a5,80002eee <iput+0x26>
    acquiresleep(&ip->lock);
    80002f1a:	01048913          	addi	s2,s1,16
    80002f1e:	854a                	mv	a0,s2
    80002f20:	00001097          	auipc	ra,0x1
    80002f24:	ab8080e7          	jalr	-1352(ra) # 800039d8 <acquiresleep>
    release(&itable.lock);
    80002f28:	00015517          	auipc	a0,0x15
    80002f2c:	85050513          	addi	a0,a0,-1968 # 80017778 <itable>
    80002f30:	00003097          	auipc	ra,0x3
    80002f34:	4a6080e7          	jalr	1190(ra) # 800063d6 <release>
    itrunc(ip);
    80002f38:	8526                	mv	a0,s1
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	ee2080e7          	jalr	-286(ra) # 80002e1c <itrunc>
    ip->type = 0;
    80002f42:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f46:	8526                	mv	a0,s1
    80002f48:	00000097          	auipc	ra,0x0
    80002f4c:	cfc080e7          	jalr	-772(ra) # 80002c44 <iupdate>
    ip->valid = 0;
    80002f50:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f54:	854a                	mv	a0,s2
    80002f56:	00001097          	auipc	ra,0x1
    80002f5a:	ad8080e7          	jalr	-1320(ra) # 80003a2e <releasesleep>
    acquire(&itable.lock);
    80002f5e:	00015517          	auipc	a0,0x15
    80002f62:	81a50513          	addi	a0,a0,-2022 # 80017778 <itable>
    80002f66:	00003097          	auipc	ra,0x3
    80002f6a:	3bc080e7          	jalr	956(ra) # 80006322 <acquire>
    80002f6e:	b741                	j	80002eee <iput+0x26>

0000000080002f70 <iunlockput>:
{
    80002f70:	1101                	addi	sp,sp,-32
    80002f72:	ec06                	sd	ra,24(sp)
    80002f74:	e822                	sd	s0,16(sp)
    80002f76:	e426                	sd	s1,8(sp)
    80002f78:	1000                	addi	s0,sp,32
    80002f7a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f7c:	00000097          	auipc	ra,0x0
    80002f80:	e54080e7          	jalr	-428(ra) # 80002dd0 <iunlock>
  iput(ip);
    80002f84:	8526                	mv	a0,s1
    80002f86:	00000097          	auipc	ra,0x0
    80002f8a:	f42080e7          	jalr	-190(ra) # 80002ec8 <iput>
}
    80002f8e:	60e2                	ld	ra,24(sp)
    80002f90:	6442                	ld	s0,16(sp)
    80002f92:	64a2                	ld	s1,8(sp)
    80002f94:	6105                	addi	sp,sp,32
    80002f96:	8082                	ret

0000000080002f98 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f98:	1141                	addi	sp,sp,-16
    80002f9a:	e422                	sd	s0,8(sp)
    80002f9c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f9e:	411c                	lw	a5,0(a0)
    80002fa0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fa2:	415c                	lw	a5,4(a0)
    80002fa4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fa6:	04451783          	lh	a5,68(a0)
    80002faa:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fae:	04a51783          	lh	a5,74(a0)
    80002fb2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fb6:	04c56783          	lwu	a5,76(a0)
    80002fba:	e99c                	sd	a5,16(a1)
}
    80002fbc:	6422                	ld	s0,8(sp)
    80002fbe:	0141                	addi	sp,sp,16
    80002fc0:	8082                	ret

0000000080002fc2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fc2:	457c                	lw	a5,76(a0)
    80002fc4:	0ed7e963          	bltu	a5,a3,800030b6 <readi+0xf4>
{
    80002fc8:	7159                	addi	sp,sp,-112
    80002fca:	f486                	sd	ra,104(sp)
    80002fcc:	f0a2                	sd	s0,96(sp)
    80002fce:	eca6                	sd	s1,88(sp)
    80002fd0:	e8ca                	sd	s2,80(sp)
    80002fd2:	e4ce                	sd	s3,72(sp)
    80002fd4:	e0d2                	sd	s4,64(sp)
    80002fd6:	fc56                	sd	s5,56(sp)
    80002fd8:	f85a                	sd	s6,48(sp)
    80002fda:	f45e                	sd	s7,40(sp)
    80002fdc:	f062                	sd	s8,32(sp)
    80002fde:	ec66                	sd	s9,24(sp)
    80002fe0:	e86a                	sd	s10,16(sp)
    80002fe2:	e46e                	sd	s11,8(sp)
    80002fe4:	1880                	addi	s0,sp,112
    80002fe6:	8baa                	mv	s7,a0
    80002fe8:	8c2e                	mv	s8,a1
    80002fea:	8ab2                	mv	s5,a2
    80002fec:	84b6                	mv	s1,a3
    80002fee:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ff0:	9f35                	addw	a4,a4,a3
    return 0;
    80002ff2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ff4:	0ad76063          	bltu	a4,a3,80003094 <readi+0xd2>
  if(off + n > ip->size)
    80002ff8:	00e7f463          	bgeu	a5,a4,80003000 <readi+0x3e>
    n = ip->size - off;
    80002ffc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003000:	0a0b0963          	beqz	s6,800030b2 <readi+0xf0>
    80003004:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003006:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000300a:	5cfd                	li	s9,-1
    8000300c:	a82d                	j	80003046 <readi+0x84>
    8000300e:	020a1d93          	slli	s11,s4,0x20
    80003012:	020ddd93          	srli	s11,s11,0x20
    80003016:	05890613          	addi	a2,s2,88
    8000301a:	86ee                	mv	a3,s11
    8000301c:	963a                	add	a2,a2,a4
    8000301e:	85d6                	mv	a1,s5
    80003020:	8562                	mv	a0,s8
    80003022:	fffff097          	auipc	ra,0xfffff
    80003026:	a1c080e7          	jalr	-1508(ra) # 80001a3e <either_copyout>
    8000302a:	05950d63          	beq	a0,s9,80003084 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000302e:	854a                	mv	a0,s2
    80003030:	fffff097          	auipc	ra,0xfffff
    80003034:	60c080e7          	jalr	1548(ra) # 8000263c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003038:	013a09bb          	addw	s3,s4,s3
    8000303c:	009a04bb          	addw	s1,s4,s1
    80003040:	9aee                	add	s5,s5,s11
    80003042:	0569f763          	bgeu	s3,s6,80003090 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003046:	000ba903          	lw	s2,0(s7)
    8000304a:	00a4d59b          	srliw	a1,s1,0xa
    8000304e:	855e                	mv	a0,s7
    80003050:	00000097          	auipc	ra,0x0
    80003054:	8b0080e7          	jalr	-1872(ra) # 80002900 <bmap>
    80003058:	0005059b          	sext.w	a1,a0
    8000305c:	854a                	mv	a0,s2
    8000305e:	fffff097          	auipc	ra,0xfffff
    80003062:	4ae080e7          	jalr	1198(ra) # 8000250c <bread>
    80003066:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003068:	3ff4f713          	andi	a4,s1,1023
    8000306c:	40ed07bb          	subw	a5,s10,a4
    80003070:	413b06bb          	subw	a3,s6,s3
    80003074:	8a3e                	mv	s4,a5
    80003076:	2781                	sext.w	a5,a5
    80003078:	0006861b          	sext.w	a2,a3
    8000307c:	f8f679e3          	bgeu	a2,a5,8000300e <readi+0x4c>
    80003080:	8a36                	mv	s4,a3
    80003082:	b771                	j	8000300e <readi+0x4c>
      brelse(bp);
    80003084:	854a                	mv	a0,s2
    80003086:	fffff097          	auipc	ra,0xfffff
    8000308a:	5b6080e7          	jalr	1462(ra) # 8000263c <brelse>
      tot = -1;
    8000308e:	59fd                	li	s3,-1
  }
  return tot;
    80003090:	0009851b          	sext.w	a0,s3
}
    80003094:	70a6                	ld	ra,104(sp)
    80003096:	7406                	ld	s0,96(sp)
    80003098:	64e6                	ld	s1,88(sp)
    8000309a:	6946                	ld	s2,80(sp)
    8000309c:	69a6                	ld	s3,72(sp)
    8000309e:	6a06                	ld	s4,64(sp)
    800030a0:	7ae2                	ld	s5,56(sp)
    800030a2:	7b42                	ld	s6,48(sp)
    800030a4:	7ba2                	ld	s7,40(sp)
    800030a6:	7c02                	ld	s8,32(sp)
    800030a8:	6ce2                	ld	s9,24(sp)
    800030aa:	6d42                	ld	s10,16(sp)
    800030ac:	6da2                	ld	s11,8(sp)
    800030ae:	6165                	addi	sp,sp,112
    800030b0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030b2:	89da                	mv	s3,s6
    800030b4:	bff1                	j	80003090 <readi+0xce>
    return 0;
    800030b6:	4501                	li	a0,0
}
    800030b8:	8082                	ret

00000000800030ba <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030ba:	457c                	lw	a5,76(a0)
    800030bc:	10d7e863          	bltu	a5,a3,800031cc <writei+0x112>
{
    800030c0:	7159                	addi	sp,sp,-112
    800030c2:	f486                	sd	ra,104(sp)
    800030c4:	f0a2                	sd	s0,96(sp)
    800030c6:	eca6                	sd	s1,88(sp)
    800030c8:	e8ca                	sd	s2,80(sp)
    800030ca:	e4ce                	sd	s3,72(sp)
    800030cc:	e0d2                	sd	s4,64(sp)
    800030ce:	fc56                	sd	s5,56(sp)
    800030d0:	f85a                	sd	s6,48(sp)
    800030d2:	f45e                	sd	s7,40(sp)
    800030d4:	f062                	sd	s8,32(sp)
    800030d6:	ec66                	sd	s9,24(sp)
    800030d8:	e86a                	sd	s10,16(sp)
    800030da:	e46e                	sd	s11,8(sp)
    800030dc:	1880                	addi	s0,sp,112
    800030de:	8b2a                	mv	s6,a0
    800030e0:	8c2e                	mv	s8,a1
    800030e2:	8ab2                	mv	s5,a2
    800030e4:	8936                	mv	s2,a3
    800030e6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030e8:	00e687bb          	addw	a5,a3,a4
    800030ec:	0ed7e263          	bltu	a5,a3,800031d0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030f0:	00043737          	lui	a4,0x43
    800030f4:	0ef76063          	bltu	a4,a5,800031d4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f8:	0c0b8863          	beqz	s7,800031c8 <writei+0x10e>
    800030fc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030fe:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003102:	5cfd                	li	s9,-1
    80003104:	a091                	j	80003148 <writei+0x8e>
    80003106:	02099d93          	slli	s11,s3,0x20
    8000310a:	020ddd93          	srli	s11,s11,0x20
    8000310e:	05848513          	addi	a0,s1,88
    80003112:	86ee                	mv	a3,s11
    80003114:	8656                	mv	a2,s5
    80003116:	85e2                	mv	a1,s8
    80003118:	953a                	add	a0,a0,a4
    8000311a:	fffff097          	auipc	ra,0xfffff
    8000311e:	97a080e7          	jalr	-1670(ra) # 80001a94 <either_copyin>
    80003122:	07950263          	beq	a0,s9,80003186 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003126:	8526                	mv	a0,s1
    80003128:	00000097          	auipc	ra,0x0
    8000312c:	790080e7          	jalr	1936(ra) # 800038b8 <log_write>
    brelse(bp);
    80003130:	8526                	mv	a0,s1
    80003132:	fffff097          	auipc	ra,0xfffff
    80003136:	50a080e7          	jalr	1290(ra) # 8000263c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000313a:	01498a3b          	addw	s4,s3,s4
    8000313e:	0129893b          	addw	s2,s3,s2
    80003142:	9aee                	add	s5,s5,s11
    80003144:	057a7663          	bgeu	s4,s7,80003190 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003148:	000b2483          	lw	s1,0(s6)
    8000314c:	00a9559b          	srliw	a1,s2,0xa
    80003150:	855a                	mv	a0,s6
    80003152:	fffff097          	auipc	ra,0xfffff
    80003156:	7ae080e7          	jalr	1966(ra) # 80002900 <bmap>
    8000315a:	0005059b          	sext.w	a1,a0
    8000315e:	8526                	mv	a0,s1
    80003160:	fffff097          	auipc	ra,0xfffff
    80003164:	3ac080e7          	jalr	940(ra) # 8000250c <bread>
    80003168:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000316a:	3ff97713          	andi	a4,s2,1023
    8000316e:	40ed07bb          	subw	a5,s10,a4
    80003172:	414b86bb          	subw	a3,s7,s4
    80003176:	89be                	mv	s3,a5
    80003178:	2781                	sext.w	a5,a5
    8000317a:	0006861b          	sext.w	a2,a3
    8000317e:	f8f674e3          	bgeu	a2,a5,80003106 <writei+0x4c>
    80003182:	89b6                	mv	s3,a3
    80003184:	b749                	j	80003106 <writei+0x4c>
      brelse(bp);
    80003186:	8526                	mv	a0,s1
    80003188:	fffff097          	auipc	ra,0xfffff
    8000318c:	4b4080e7          	jalr	1204(ra) # 8000263c <brelse>
  }

  if(off > ip->size)
    80003190:	04cb2783          	lw	a5,76(s6)
    80003194:	0127f463          	bgeu	a5,s2,8000319c <writei+0xe2>
    ip->size = off;
    80003198:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000319c:	855a                	mv	a0,s6
    8000319e:	00000097          	auipc	ra,0x0
    800031a2:	aa6080e7          	jalr	-1370(ra) # 80002c44 <iupdate>

  return tot;
    800031a6:	000a051b          	sext.w	a0,s4
}
    800031aa:	70a6                	ld	ra,104(sp)
    800031ac:	7406                	ld	s0,96(sp)
    800031ae:	64e6                	ld	s1,88(sp)
    800031b0:	6946                	ld	s2,80(sp)
    800031b2:	69a6                	ld	s3,72(sp)
    800031b4:	6a06                	ld	s4,64(sp)
    800031b6:	7ae2                	ld	s5,56(sp)
    800031b8:	7b42                	ld	s6,48(sp)
    800031ba:	7ba2                	ld	s7,40(sp)
    800031bc:	7c02                	ld	s8,32(sp)
    800031be:	6ce2                	ld	s9,24(sp)
    800031c0:	6d42                	ld	s10,16(sp)
    800031c2:	6da2                	ld	s11,8(sp)
    800031c4:	6165                	addi	sp,sp,112
    800031c6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031c8:	8a5e                	mv	s4,s7
    800031ca:	bfc9                	j	8000319c <writei+0xe2>
    return -1;
    800031cc:	557d                	li	a0,-1
}
    800031ce:	8082                	ret
    return -1;
    800031d0:	557d                	li	a0,-1
    800031d2:	bfe1                	j	800031aa <writei+0xf0>
    return -1;
    800031d4:	557d                	li	a0,-1
    800031d6:	bfd1                	j	800031aa <writei+0xf0>

00000000800031d8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031d8:	1141                	addi	sp,sp,-16
    800031da:	e406                	sd	ra,8(sp)
    800031dc:	e022                	sd	s0,0(sp)
    800031de:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031e0:	4639                	li	a2,14
    800031e2:	ffffd097          	auipc	ra,0xffffd
    800031e6:	06e080e7          	jalr	110(ra) # 80000250 <strncmp>
}
    800031ea:	60a2                	ld	ra,8(sp)
    800031ec:	6402                	ld	s0,0(sp)
    800031ee:	0141                	addi	sp,sp,16
    800031f0:	8082                	ret

00000000800031f2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031f2:	7139                	addi	sp,sp,-64
    800031f4:	fc06                	sd	ra,56(sp)
    800031f6:	f822                	sd	s0,48(sp)
    800031f8:	f426                	sd	s1,40(sp)
    800031fa:	f04a                	sd	s2,32(sp)
    800031fc:	ec4e                	sd	s3,24(sp)
    800031fe:	e852                	sd	s4,16(sp)
    80003200:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003202:	04451703          	lh	a4,68(a0)
    80003206:	4785                	li	a5,1
    80003208:	00f71a63          	bne	a4,a5,8000321c <dirlookup+0x2a>
    8000320c:	892a                	mv	s2,a0
    8000320e:	89ae                	mv	s3,a1
    80003210:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003212:	457c                	lw	a5,76(a0)
    80003214:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003216:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003218:	e79d                	bnez	a5,80003246 <dirlookup+0x54>
    8000321a:	a8a5                	j	80003292 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000321c:	00005517          	auipc	a0,0x5
    80003220:	3c450513          	addi	a0,a0,964 # 800085e0 <syscalls+0x1e8>
    80003224:	00003097          	auipc	ra,0x3
    80003228:	bb4080e7          	jalr	-1100(ra) # 80005dd8 <panic>
      panic("dirlookup read");
    8000322c:	00005517          	auipc	a0,0x5
    80003230:	3cc50513          	addi	a0,a0,972 # 800085f8 <syscalls+0x200>
    80003234:	00003097          	auipc	ra,0x3
    80003238:	ba4080e7          	jalr	-1116(ra) # 80005dd8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000323c:	24c1                	addiw	s1,s1,16
    8000323e:	04c92783          	lw	a5,76(s2)
    80003242:	04f4f763          	bgeu	s1,a5,80003290 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003246:	4741                	li	a4,16
    80003248:	86a6                	mv	a3,s1
    8000324a:	fc040613          	addi	a2,s0,-64
    8000324e:	4581                	li	a1,0
    80003250:	854a                	mv	a0,s2
    80003252:	00000097          	auipc	ra,0x0
    80003256:	d70080e7          	jalr	-656(ra) # 80002fc2 <readi>
    8000325a:	47c1                	li	a5,16
    8000325c:	fcf518e3          	bne	a0,a5,8000322c <dirlookup+0x3a>
    if(de.inum == 0)
    80003260:	fc045783          	lhu	a5,-64(s0)
    80003264:	dfe1                	beqz	a5,8000323c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003266:	fc240593          	addi	a1,s0,-62
    8000326a:	854e                	mv	a0,s3
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	f6c080e7          	jalr	-148(ra) # 800031d8 <namecmp>
    80003274:	f561                	bnez	a0,8000323c <dirlookup+0x4a>
      if(poff)
    80003276:	000a0463          	beqz	s4,8000327e <dirlookup+0x8c>
        *poff = off;
    8000327a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000327e:	fc045583          	lhu	a1,-64(s0)
    80003282:	00092503          	lw	a0,0(s2)
    80003286:	fffff097          	auipc	ra,0xfffff
    8000328a:	754080e7          	jalr	1876(ra) # 800029da <iget>
    8000328e:	a011                	j	80003292 <dirlookup+0xa0>
  return 0;
    80003290:	4501                	li	a0,0
}
    80003292:	70e2                	ld	ra,56(sp)
    80003294:	7442                	ld	s0,48(sp)
    80003296:	74a2                	ld	s1,40(sp)
    80003298:	7902                	ld	s2,32(sp)
    8000329a:	69e2                	ld	s3,24(sp)
    8000329c:	6a42                	ld	s4,16(sp)
    8000329e:	6121                	addi	sp,sp,64
    800032a0:	8082                	ret

00000000800032a2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032a2:	711d                	addi	sp,sp,-96
    800032a4:	ec86                	sd	ra,88(sp)
    800032a6:	e8a2                	sd	s0,80(sp)
    800032a8:	e4a6                	sd	s1,72(sp)
    800032aa:	e0ca                	sd	s2,64(sp)
    800032ac:	fc4e                	sd	s3,56(sp)
    800032ae:	f852                	sd	s4,48(sp)
    800032b0:	f456                	sd	s5,40(sp)
    800032b2:	f05a                	sd	s6,32(sp)
    800032b4:	ec5e                	sd	s7,24(sp)
    800032b6:	e862                	sd	s8,16(sp)
    800032b8:	e466                	sd	s9,8(sp)
    800032ba:	1080                	addi	s0,sp,96
    800032bc:	84aa                	mv	s1,a0
    800032be:	8b2e                	mv	s6,a1
    800032c0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032c2:	00054703          	lbu	a4,0(a0)
    800032c6:	02f00793          	li	a5,47
    800032ca:	02f70363          	beq	a4,a5,800032f0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ce:	ffffe097          	auipc	ra,0xffffe
    800032d2:	c8a080e7          	jalr	-886(ra) # 80000f58 <myproc>
    800032d6:	15053503          	ld	a0,336(a0)
    800032da:	00000097          	auipc	ra,0x0
    800032de:	9f6080e7          	jalr	-1546(ra) # 80002cd0 <idup>
    800032e2:	89aa                	mv	s3,a0
  while(*path == '/')
    800032e4:	02f00913          	li	s2,47
  len = path - s;
    800032e8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032ea:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032ec:	4c05                	li	s8,1
    800032ee:	a865                	j	800033a6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032f0:	4585                	li	a1,1
    800032f2:	4505                	li	a0,1
    800032f4:	fffff097          	auipc	ra,0xfffff
    800032f8:	6e6080e7          	jalr	1766(ra) # 800029da <iget>
    800032fc:	89aa                	mv	s3,a0
    800032fe:	b7dd                	j	800032e4 <namex+0x42>
      iunlockput(ip);
    80003300:	854e                	mv	a0,s3
    80003302:	00000097          	auipc	ra,0x0
    80003306:	c6e080e7          	jalr	-914(ra) # 80002f70 <iunlockput>
      return 0;
    8000330a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000330c:	854e                	mv	a0,s3
    8000330e:	60e6                	ld	ra,88(sp)
    80003310:	6446                	ld	s0,80(sp)
    80003312:	64a6                	ld	s1,72(sp)
    80003314:	6906                	ld	s2,64(sp)
    80003316:	79e2                	ld	s3,56(sp)
    80003318:	7a42                	ld	s4,48(sp)
    8000331a:	7aa2                	ld	s5,40(sp)
    8000331c:	7b02                	ld	s6,32(sp)
    8000331e:	6be2                	ld	s7,24(sp)
    80003320:	6c42                	ld	s8,16(sp)
    80003322:	6ca2                	ld	s9,8(sp)
    80003324:	6125                	addi	sp,sp,96
    80003326:	8082                	ret
      iunlock(ip);
    80003328:	854e                	mv	a0,s3
    8000332a:	00000097          	auipc	ra,0x0
    8000332e:	aa6080e7          	jalr	-1370(ra) # 80002dd0 <iunlock>
      return ip;
    80003332:	bfe9                	j	8000330c <namex+0x6a>
      iunlockput(ip);
    80003334:	854e                	mv	a0,s3
    80003336:	00000097          	auipc	ra,0x0
    8000333a:	c3a080e7          	jalr	-966(ra) # 80002f70 <iunlockput>
      return 0;
    8000333e:	89d2                	mv	s3,s4
    80003340:	b7f1                	j	8000330c <namex+0x6a>
  len = path - s;
    80003342:	40b48633          	sub	a2,s1,a1
    80003346:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000334a:	094cd463          	bge	s9,s4,800033d2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000334e:	4639                	li	a2,14
    80003350:	8556                	mv	a0,s5
    80003352:	ffffd097          	auipc	ra,0xffffd
    80003356:	e86080e7          	jalr	-378(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000335a:	0004c783          	lbu	a5,0(s1)
    8000335e:	01279763          	bne	a5,s2,8000336c <namex+0xca>
    path++;
    80003362:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003364:	0004c783          	lbu	a5,0(s1)
    80003368:	ff278de3          	beq	a5,s2,80003362 <namex+0xc0>
    ilock(ip);
    8000336c:	854e                	mv	a0,s3
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	9a0080e7          	jalr	-1632(ra) # 80002d0e <ilock>
    if(ip->type != T_DIR){
    80003376:	04499783          	lh	a5,68(s3)
    8000337a:	f98793e3          	bne	a5,s8,80003300 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000337e:	000b0563          	beqz	s6,80003388 <namex+0xe6>
    80003382:	0004c783          	lbu	a5,0(s1)
    80003386:	d3cd                	beqz	a5,80003328 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003388:	865e                	mv	a2,s7
    8000338a:	85d6                	mv	a1,s5
    8000338c:	854e                	mv	a0,s3
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	e64080e7          	jalr	-412(ra) # 800031f2 <dirlookup>
    80003396:	8a2a                	mv	s4,a0
    80003398:	dd51                	beqz	a0,80003334 <namex+0x92>
    iunlockput(ip);
    8000339a:	854e                	mv	a0,s3
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	bd4080e7          	jalr	-1068(ra) # 80002f70 <iunlockput>
    ip = next;
    800033a4:	89d2                	mv	s3,s4
  while(*path == '/')
    800033a6:	0004c783          	lbu	a5,0(s1)
    800033aa:	05279763          	bne	a5,s2,800033f8 <namex+0x156>
    path++;
    800033ae:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033b0:	0004c783          	lbu	a5,0(s1)
    800033b4:	ff278de3          	beq	a5,s2,800033ae <namex+0x10c>
  if(*path == 0)
    800033b8:	c79d                	beqz	a5,800033e6 <namex+0x144>
    path++;
    800033ba:	85a6                	mv	a1,s1
  len = path - s;
    800033bc:	8a5e                	mv	s4,s7
    800033be:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033c0:	01278963          	beq	a5,s2,800033d2 <namex+0x130>
    800033c4:	dfbd                	beqz	a5,80003342 <namex+0xa0>
    path++;
    800033c6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033c8:	0004c783          	lbu	a5,0(s1)
    800033cc:	ff279ce3          	bne	a5,s2,800033c4 <namex+0x122>
    800033d0:	bf8d                	j	80003342 <namex+0xa0>
    memmove(name, s, len);
    800033d2:	2601                	sext.w	a2,a2
    800033d4:	8556                	mv	a0,s5
    800033d6:	ffffd097          	auipc	ra,0xffffd
    800033da:	e02080e7          	jalr	-510(ra) # 800001d8 <memmove>
    name[len] = 0;
    800033de:	9a56                	add	s4,s4,s5
    800033e0:	000a0023          	sb	zero,0(s4)
    800033e4:	bf9d                	j	8000335a <namex+0xb8>
  if(nameiparent){
    800033e6:	f20b03e3          	beqz	s6,8000330c <namex+0x6a>
    iput(ip);
    800033ea:	854e                	mv	a0,s3
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	adc080e7          	jalr	-1316(ra) # 80002ec8 <iput>
    return 0;
    800033f4:	4981                	li	s3,0
    800033f6:	bf19                	j	8000330c <namex+0x6a>
  if(*path == 0)
    800033f8:	d7fd                	beqz	a5,800033e6 <namex+0x144>
  while(*path != '/' && *path != 0)
    800033fa:	0004c783          	lbu	a5,0(s1)
    800033fe:	85a6                	mv	a1,s1
    80003400:	b7d1                	j	800033c4 <namex+0x122>

0000000080003402 <dirlink>:
{
    80003402:	7139                	addi	sp,sp,-64
    80003404:	fc06                	sd	ra,56(sp)
    80003406:	f822                	sd	s0,48(sp)
    80003408:	f426                	sd	s1,40(sp)
    8000340a:	f04a                	sd	s2,32(sp)
    8000340c:	ec4e                	sd	s3,24(sp)
    8000340e:	e852                	sd	s4,16(sp)
    80003410:	0080                	addi	s0,sp,64
    80003412:	892a                	mv	s2,a0
    80003414:	8a2e                	mv	s4,a1
    80003416:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003418:	4601                	li	a2,0
    8000341a:	00000097          	auipc	ra,0x0
    8000341e:	dd8080e7          	jalr	-552(ra) # 800031f2 <dirlookup>
    80003422:	e93d                	bnez	a0,80003498 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003424:	04c92483          	lw	s1,76(s2)
    80003428:	c49d                	beqz	s1,80003456 <dirlink+0x54>
    8000342a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000342c:	4741                	li	a4,16
    8000342e:	86a6                	mv	a3,s1
    80003430:	fc040613          	addi	a2,s0,-64
    80003434:	4581                	li	a1,0
    80003436:	854a                	mv	a0,s2
    80003438:	00000097          	auipc	ra,0x0
    8000343c:	b8a080e7          	jalr	-1142(ra) # 80002fc2 <readi>
    80003440:	47c1                	li	a5,16
    80003442:	06f51163          	bne	a0,a5,800034a4 <dirlink+0xa2>
    if(de.inum == 0)
    80003446:	fc045783          	lhu	a5,-64(s0)
    8000344a:	c791                	beqz	a5,80003456 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000344c:	24c1                	addiw	s1,s1,16
    8000344e:	04c92783          	lw	a5,76(s2)
    80003452:	fcf4ede3          	bltu	s1,a5,8000342c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003456:	4639                	li	a2,14
    80003458:	85d2                	mv	a1,s4
    8000345a:	fc240513          	addi	a0,s0,-62
    8000345e:	ffffd097          	auipc	ra,0xffffd
    80003462:	e2e080e7          	jalr	-466(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003466:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000346a:	4741                	li	a4,16
    8000346c:	86a6                	mv	a3,s1
    8000346e:	fc040613          	addi	a2,s0,-64
    80003472:	4581                	li	a1,0
    80003474:	854a                	mv	a0,s2
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	c44080e7          	jalr	-956(ra) # 800030ba <writei>
    8000347e:	872a                	mv	a4,a0
    80003480:	47c1                	li	a5,16
  return 0;
    80003482:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003484:	02f71863          	bne	a4,a5,800034b4 <dirlink+0xb2>
}
    80003488:	70e2                	ld	ra,56(sp)
    8000348a:	7442                	ld	s0,48(sp)
    8000348c:	74a2                	ld	s1,40(sp)
    8000348e:	7902                	ld	s2,32(sp)
    80003490:	69e2                	ld	s3,24(sp)
    80003492:	6a42                	ld	s4,16(sp)
    80003494:	6121                	addi	sp,sp,64
    80003496:	8082                	ret
    iput(ip);
    80003498:	00000097          	auipc	ra,0x0
    8000349c:	a30080e7          	jalr	-1488(ra) # 80002ec8 <iput>
    return -1;
    800034a0:	557d                	li	a0,-1
    800034a2:	b7dd                	j	80003488 <dirlink+0x86>
      panic("dirlink read");
    800034a4:	00005517          	auipc	a0,0x5
    800034a8:	16450513          	addi	a0,a0,356 # 80008608 <syscalls+0x210>
    800034ac:	00003097          	auipc	ra,0x3
    800034b0:	92c080e7          	jalr	-1748(ra) # 80005dd8 <panic>
    panic("dirlink");
    800034b4:	00005517          	auipc	a0,0x5
    800034b8:	26450513          	addi	a0,a0,612 # 80008718 <syscalls+0x320>
    800034bc:	00003097          	auipc	ra,0x3
    800034c0:	91c080e7          	jalr	-1764(ra) # 80005dd8 <panic>

00000000800034c4 <namei>:

struct inode*
namei(char *path)
{
    800034c4:	1101                	addi	sp,sp,-32
    800034c6:	ec06                	sd	ra,24(sp)
    800034c8:	e822                	sd	s0,16(sp)
    800034ca:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034cc:	fe040613          	addi	a2,s0,-32
    800034d0:	4581                	li	a1,0
    800034d2:	00000097          	auipc	ra,0x0
    800034d6:	dd0080e7          	jalr	-560(ra) # 800032a2 <namex>
}
    800034da:	60e2                	ld	ra,24(sp)
    800034dc:	6442                	ld	s0,16(sp)
    800034de:	6105                	addi	sp,sp,32
    800034e0:	8082                	ret

00000000800034e2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034e2:	1141                	addi	sp,sp,-16
    800034e4:	e406                	sd	ra,8(sp)
    800034e6:	e022                	sd	s0,0(sp)
    800034e8:	0800                	addi	s0,sp,16
    800034ea:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034ec:	4585                	li	a1,1
    800034ee:	00000097          	auipc	ra,0x0
    800034f2:	db4080e7          	jalr	-588(ra) # 800032a2 <namex>
}
    800034f6:	60a2                	ld	ra,8(sp)
    800034f8:	6402                	ld	s0,0(sp)
    800034fa:	0141                	addi	sp,sp,16
    800034fc:	8082                	ret

00000000800034fe <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034fe:	1101                	addi	sp,sp,-32
    80003500:	ec06                	sd	ra,24(sp)
    80003502:	e822                	sd	s0,16(sp)
    80003504:	e426                	sd	s1,8(sp)
    80003506:	e04a                	sd	s2,0(sp)
    80003508:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000350a:	00016917          	auipc	s2,0x16
    8000350e:	d1690913          	addi	s2,s2,-746 # 80019220 <log>
    80003512:	01892583          	lw	a1,24(s2)
    80003516:	02892503          	lw	a0,40(s2)
    8000351a:	fffff097          	auipc	ra,0xfffff
    8000351e:	ff2080e7          	jalr	-14(ra) # 8000250c <bread>
    80003522:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003524:	02c92683          	lw	a3,44(s2)
    80003528:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000352a:	02d05763          	blez	a3,80003558 <write_head+0x5a>
    8000352e:	00016797          	auipc	a5,0x16
    80003532:	d2278793          	addi	a5,a5,-734 # 80019250 <log+0x30>
    80003536:	05c50713          	addi	a4,a0,92
    8000353a:	36fd                	addiw	a3,a3,-1
    8000353c:	1682                	slli	a3,a3,0x20
    8000353e:	9281                	srli	a3,a3,0x20
    80003540:	068a                	slli	a3,a3,0x2
    80003542:	00016617          	auipc	a2,0x16
    80003546:	d1260613          	addi	a2,a2,-750 # 80019254 <log+0x34>
    8000354a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000354c:	4390                	lw	a2,0(a5)
    8000354e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003550:	0791                	addi	a5,a5,4
    80003552:	0711                	addi	a4,a4,4
    80003554:	fed79ce3          	bne	a5,a3,8000354c <write_head+0x4e>
  }
  bwrite(buf);
    80003558:	8526                	mv	a0,s1
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	0a4080e7          	jalr	164(ra) # 800025fe <bwrite>
  brelse(buf);
    80003562:	8526                	mv	a0,s1
    80003564:	fffff097          	auipc	ra,0xfffff
    80003568:	0d8080e7          	jalr	216(ra) # 8000263c <brelse>
}
    8000356c:	60e2                	ld	ra,24(sp)
    8000356e:	6442                	ld	s0,16(sp)
    80003570:	64a2                	ld	s1,8(sp)
    80003572:	6902                	ld	s2,0(sp)
    80003574:	6105                	addi	sp,sp,32
    80003576:	8082                	ret

0000000080003578 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003578:	00016797          	auipc	a5,0x16
    8000357c:	cd47a783          	lw	a5,-812(a5) # 8001924c <log+0x2c>
    80003580:	0af05d63          	blez	a5,8000363a <install_trans+0xc2>
{
    80003584:	7139                	addi	sp,sp,-64
    80003586:	fc06                	sd	ra,56(sp)
    80003588:	f822                	sd	s0,48(sp)
    8000358a:	f426                	sd	s1,40(sp)
    8000358c:	f04a                	sd	s2,32(sp)
    8000358e:	ec4e                	sd	s3,24(sp)
    80003590:	e852                	sd	s4,16(sp)
    80003592:	e456                	sd	s5,8(sp)
    80003594:	e05a                	sd	s6,0(sp)
    80003596:	0080                	addi	s0,sp,64
    80003598:	8b2a                	mv	s6,a0
    8000359a:	00016a97          	auipc	s5,0x16
    8000359e:	cb6a8a93          	addi	s5,s5,-842 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035a2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035a4:	00016997          	auipc	s3,0x16
    800035a8:	c7c98993          	addi	s3,s3,-900 # 80019220 <log>
    800035ac:	a035                	j	800035d8 <install_trans+0x60>
      bunpin(dbuf);
    800035ae:	8526                	mv	a0,s1
    800035b0:	fffff097          	auipc	ra,0xfffff
    800035b4:	166080e7          	jalr	358(ra) # 80002716 <bunpin>
    brelse(lbuf);
    800035b8:	854a                	mv	a0,s2
    800035ba:	fffff097          	auipc	ra,0xfffff
    800035be:	082080e7          	jalr	130(ra) # 8000263c <brelse>
    brelse(dbuf);
    800035c2:	8526                	mv	a0,s1
    800035c4:	fffff097          	auipc	ra,0xfffff
    800035c8:	078080e7          	jalr	120(ra) # 8000263c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035cc:	2a05                	addiw	s4,s4,1
    800035ce:	0a91                	addi	s5,s5,4
    800035d0:	02c9a783          	lw	a5,44(s3)
    800035d4:	04fa5963          	bge	s4,a5,80003626 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035d8:	0189a583          	lw	a1,24(s3)
    800035dc:	014585bb          	addw	a1,a1,s4
    800035e0:	2585                	addiw	a1,a1,1
    800035e2:	0289a503          	lw	a0,40(s3)
    800035e6:	fffff097          	auipc	ra,0xfffff
    800035ea:	f26080e7          	jalr	-218(ra) # 8000250c <bread>
    800035ee:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035f0:	000aa583          	lw	a1,0(s5)
    800035f4:	0289a503          	lw	a0,40(s3)
    800035f8:	fffff097          	auipc	ra,0xfffff
    800035fc:	f14080e7          	jalr	-236(ra) # 8000250c <bread>
    80003600:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003602:	40000613          	li	a2,1024
    80003606:	05890593          	addi	a1,s2,88
    8000360a:	05850513          	addi	a0,a0,88
    8000360e:	ffffd097          	auipc	ra,0xffffd
    80003612:	bca080e7          	jalr	-1078(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003616:	8526                	mv	a0,s1
    80003618:	fffff097          	auipc	ra,0xfffff
    8000361c:	fe6080e7          	jalr	-26(ra) # 800025fe <bwrite>
    if(recovering == 0)
    80003620:	f80b1ce3          	bnez	s6,800035b8 <install_trans+0x40>
    80003624:	b769                	j	800035ae <install_trans+0x36>
}
    80003626:	70e2                	ld	ra,56(sp)
    80003628:	7442                	ld	s0,48(sp)
    8000362a:	74a2                	ld	s1,40(sp)
    8000362c:	7902                	ld	s2,32(sp)
    8000362e:	69e2                	ld	s3,24(sp)
    80003630:	6a42                	ld	s4,16(sp)
    80003632:	6aa2                	ld	s5,8(sp)
    80003634:	6b02                	ld	s6,0(sp)
    80003636:	6121                	addi	sp,sp,64
    80003638:	8082                	ret
    8000363a:	8082                	ret

000000008000363c <initlog>:
{
    8000363c:	7179                	addi	sp,sp,-48
    8000363e:	f406                	sd	ra,40(sp)
    80003640:	f022                	sd	s0,32(sp)
    80003642:	ec26                	sd	s1,24(sp)
    80003644:	e84a                	sd	s2,16(sp)
    80003646:	e44e                	sd	s3,8(sp)
    80003648:	1800                	addi	s0,sp,48
    8000364a:	892a                	mv	s2,a0
    8000364c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000364e:	00016497          	auipc	s1,0x16
    80003652:	bd248493          	addi	s1,s1,-1070 # 80019220 <log>
    80003656:	00005597          	auipc	a1,0x5
    8000365a:	fc258593          	addi	a1,a1,-62 # 80008618 <syscalls+0x220>
    8000365e:	8526                	mv	a0,s1
    80003660:	00003097          	auipc	ra,0x3
    80003664:	c32080e7          	jalr	-974(ra) # 80006292 <initlock>
  log.start = sb->logstart;
    80003668:	0149a583          	lw	a1,20(s3)
    8000366c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000366e:	0109a783          	lw	a5,16(s3)
    80003672:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003674:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003678:	854a                	mv	a0,s2
    8000367a:	fffff097          	auipc	ra,0xfffff
    8000367e:	e92080e7          	jalr	-366(ra) # 8000250c <bread>
  log.lh.n = lh->n;
    80003682:	4d3c                	lw	a5,88(a0)
    80003684:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003686:	02f05563          	blez	a5,800036b0 <initlog+0x74>
    8000368a:	05c50713          	addi	a4,a0,92
    8000368e:	00016697          	auipc	a3,0x16
    80003692:	bc268693          	addi	a3,a3,-1086 # 80019250 <log+0x30>
    80003696:	37fd                	addiw	a5,a5,-1
    80003698:	1782                	slli	a5,a5,0x20
    8000369a:	9381                	srli	a5,a5,0x20
    8000369c:	078a                	slli	a5,a5,0x2
    8000369e:	06050613          	addi	a2,a0,96
    800036a2:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036a4:	4310                	lw	a2,0(a4)
    800036a6:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036a8:	0711                	addi	a4,a4,4
    800036aa:	0691                	addi	a3,a3,4
    800036ac:	fef71ce3          	bne	a4,a5,800036a4 <initlog+0x68>
  brelse(buf);
    800036b0:	fffff097          	auipc	ra,0xfffff
    800036b4:	f8c080e7          	jalr	-116(ra) # 8000263c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036b8:	4505                	li	a0,1
    800036ba:	00000097          	auipc	ra,0x0
    800036be:	ebe080e7          	jalr	-322(ra) # 80003578 <install_trans>
  log.lh.n = 0;
    800036c2:	00016797          	auipc	a5,0x16
    800036c6:	b807a523          	sw	zero,-1142(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800036ca:	00000097          	auipc	ra,0x0
    800036ce:	e34080e7          	jalr	-460(ra) # 800034fe <write_head>
}
    800036d2:	70a2                	ld	ra,40(sp)
    800036d4:	7402                	ld	s0,32(sp)
    800036d6:	64e2                	ld	s1,24(sp)
    800036d8:	6942                	ld	s2,16(sp)
    800036da:	69a2                	ld	s3,8(sp)
    800036dc:	6145                	addi	sp,sp,48
    800036de:	8082                	ret

00000000800036e0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036e0:	1101                	addi	sp,sp,-32
    800036e2:	ec06                	sd	ra,24(sp)
    800036e4:	e822                	sd	s0,16(sp)
    800036e6:	e426                	sd	s1,8(sp)
    800036e8:	e04a                	sd	s2,0(sp)
    800036ea:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036ec:	00016517          	auipc	a0,0x16
    800036f0:	b3450513          	addi	a0,a0,-1228 # 80019220 <log>
    800036f4:	00003097          	auipc	ra,0x3
    800036f8:	c2e080e7          	jalr	-978(ra) # 80006322 <acquire>
  while(1){
    if(log.committing){
    800036fc:	00016497          	auipc	s1,0x16
    80003700:	b2448493          	addi	s1,s1,-1244 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003704:	4979                	li	s2,30
    80003706:	a039                	j	80003714 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003708:	85a6                	mv	a1,s1
    8000370a:	8526                	mv	a0,s1
    8000370c:	ffffe097          	auipc	ra,0xffffe
    80003710:	f8e080e7          	jalr	-114(ra) # 8000169a <sleep>
    if(log.committing){
    80003714:	50dc                	lw	a5,36(s1)
    80003716:	fbed                	bnez	a5,80003708 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003718:	509c                	lw	a5,32(s1)
    8000371a:	0017871b          	addiw	a4,a5,1
    8000371e:	0007069b          	sext.w	a3,a4
    80003722:	0027179b          	slliw	a5,a4,0x2
    80003726:	9fb9                	addw	a5,a5,a4
    80003728:	0017979b          	slliw	a5,a5,0x1
    8000372c:	54d8                	lw	a4,44(s1)
    8000372e:	9fb9                	addw	a5,a5,a4
    80003730:	00f95963          	bge	s2,a5,80003742 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003734:	85a6                	mv	a1,s1
    80003736:	8526                	mv	a0,s1
    80003738:	ffffe097          	auipc	ra,0xffffe
    8000373c:	f62080e7          	jalr	-158(ra) # 8000169a <sleep>
    80003740:	bfd1                	j	80003714 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003742:	00016517          	auipc	a0,0x16
    80003746:	ade50513          	addi	a0,a0,-1314 # 80019220 <log>
    8000374a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000374c:	00003097          	auipc	ra,0x3
    80003750:	c8a080e7          	jalr	-886(ra) # 800063d6 <release>
      break;
    }
  }
}
    80003754:	60e2                	ld	ra,24(sp)
    80003756:	6442                	ld	s0,16(sp)
    80003758:	64a2                	ld	s1,8(sp)
    8000375a:	6902                	ld	s2,0(sp)
    8000375c:	6105                	addi	sp,sp,32
    8000375e:	8082                	ret

0000000080003760 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003760:	7139                	addi	sp,sp,-64
    80003762:	fc06                	sd	ra,56(sp)
    80003764:	f822                	sd	s0,48(sp)
    80003766:	f426                	sd	s1,40(sp)
    80003768:	f04a                	sd	s2,32(sp)
    8000376a:	ec4e                	sd	s3,24(sp)
    8000376c:	e852                	sd	s4,16(sp)
    8000376e:	e456                	sd	s5,8(sp)
    80003770:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003772:	00016497          	auipc	s1,0x16
    80003776:	aae48493          	addi	s1,s1,-1362 # 80019220 <log>
    8000377a:	8526                	mv	a0,s1
    8000377c:	00003097          	auipc	ra,0x3
    80003780:	ba6080e7          	jalr	-1114(ra) # 80006322 <acquire>
  log.outstanding -= 1;
    80003784:	509c                	lw	a5,32(s1)
    80003786:	37fd                	addiw	a5,a5,-1
    80003788:	0007891b          	sext.w	s2,a5
    8000378c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000378e:	50dc                	lw	a5,36(s1)
    80003790:	efb9                	bnez	a5,800037ee <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003792:	06091663          	bnez	s2,800037fe <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003796:	00016497          	auipc	s1,0x16
    8000379a:	a8a48493          	addi	s1,s1,-1398 # 80019220 <log>
    8000379e:	4785                	li	a5,1
    800037a0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037a2:	8526                	mv	a0,s1
    800037a4:	00003097          	auipc	ra,0x3
    800037a8:	c32080e7          	jalr	-974(ra) # 800063d6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037ac:	54dc                	lw	a5,44(s1)
    800037ae:	06f04763          	bgtz	a5,8000381c <end_op+0xbc>
    acquire(&log.lock);
    800037b2:	00016497          	auipc	s1,0x16
    800037b6:	a6e48493          	addi	s1,s1,-1426 # 80019220 <log>
    800037ba:	8526                	mv	a0,s1
    800037bc:	00003097          	auipc	ra,0x3
    800037c0:	b66080e7          	jalr	-1178(ra) # 80006322 <acquire>
    log.committing = 0;
    800037c4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037c8:	8526                	mv	a0,s1
    800037ca:	ffffe097          	auipc	ra,0xffffe
    800037ce:	05c080e7          	jalr	92(ra) # 80001826 <wakeup>
    release(&log.lock);
    800037d2:	8526                	mv	a0,s1
    800037d4:	00003097          	auipc	ra,0x3
    800037d8:	c02080e7          	jalr	-1022(ra) # 800063d6 <release>
}
    800037dc:	70e2                	ld	ra,56(sp)
    800037de:	7442                	ld	s0,48(sp)
    800037e0:	74a2                	ld	s1,40(sp)
    800037e2:	7902                	ld	s2,32(sp)
    800037e4:	69e2                	ld	s3,24(sp)
    800037e6:	6a42                	ld	s4,16(sp)
    800037e8:	6aa2                	ld	s5,8(sp)
    800037ea:	6121                	addi	sp,sp,64
    800037ec:	8082                	ret
    panic("log.committing");
    800037ee:	00005517          	auipc	a0,0x5
    800037f2:	e3250513          	addi	a0,a0,-462 # 80008620 <syscalls+0x228>
    800037f6:	00002097          	auipc	ra,0x2
    800037fa:	5e2080e7          	jalr	1506(ra) # 80005dd8 <panic>
    wakeup(&log);
    800037fe:	00016497          	auipc	s1,0x16
    80003802:	a2248493          	addi	s1,s1,-1502 # 80019220 <log>
    80003806:	8526                	mv	a0,s1
    80003808:	ffffe097          	auipc	ra,0xffffe
    8000380c:	01e080e7          	jalr	30(ra) # 80001826 <wakeup>
  release(&log.lock);
    80003810:	8526                	mv	a0,s1
    80003812:	00003097          	auipc	ra,0x3
    80003816:	bc4080e7          	jalr	-1084(ra) # 800063d6 <release>
  if(do_commit){
    8000381a:	b7c9                	j	800037dc <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000381c:	00016a97          	auipc	s5,0x16
    80003820:	a34a8a93          	addi	s5,s5,-1484 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003824:	00016a17          	auipc	s4,0x16
    80003828:	9fca0a13          	addi	s4,s4,-1540 # 80019220 <log>
    8000382c:	018a2583          	lw	a1,24(s4)
    80003830:	012585bb          	addw	a1,a1,s2
    80003834:	2585                	addiw	a1,a1,1
    80003836:	028a2503          	lw	a0,40(s4)
    8000383a:	fffff097          	auipc	ra,0xfffff
    8000383e:	cd2080e7          	jalr	-814(ra) # 8000250c <bread>
    80003842:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003844:	000aa583          	lw	a1,0(s5)
    80003848:	028a2503          	lw	a0,40(s4)
    8000384c:	fffff097          	auipc	ra,0xfffff
    80003850:	cc0080e7          	jalr	-832(ra) # 8000250c <bread>
    80003854:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003856:	40000613          	li	a2,1024
    8000385a:	05850593          	addi	a1,a0,88
    8000385e:	05848513          	addi	a0,s1,88
    80003862:	ffffd097          	auipc	ra,0xffffd
    80003866:	976080e7          	jalr	-1674(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000386a:	8526                	mv	a0,s1
    8000386c:	fffff097          	auipc	ra,0xfffff
    80003870:	d92080e7          	jalr	-622(ra) # 800025fe <bwrite>
    brelse(from);
    80003874:	854e                	mv	a0,s3
    80003876:	fffff097          	auipc	ra,0xfffff
    8000387a:	dc6080e7          	jalr	-570(ra) # 8000263c <brelse>
    brelse(to);
    8000387e:	8526                	mv	a0,s1
    80003880:	fffff097          	auipc	ra,0xfffff
    80003884:	dbc080e7          	jalr	-580(ra) # 8000263c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003888:	2905                	addiw	s2,s2,1
    8000388a:	0a91                	addi	s5,s5,4
    8000388c:	02ca2783          	lw	a5,44(s4)
    80003890:	f8f94ee3          	blt	s2,a5,8000382c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003894:	00000097          	auipc	ra,0x0
    80003898:	c6a080e7          	jalr	-918(ra) # 800034fe <write_head>
    install_trans(0); // Now install writes to home locations
    8000389c:	4501                	li	a0,0
    8000389e:	00000097          	auipc	ra,0x0
    800038a2:	cda080e7          	jalr	-806(ra) # 80003578 <install_trans>
    log.lh.n = 0;
    800038a6:	00016797          	auipc	a5,0x16
    800038aa:	9a07a323          	sw	zero,-1626(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038ae:	00000097          	auipc	ra,0x0
    800038b2:	c50080e7          	jalr	-944(ra) # 800034fe <write_head>
    800038b6:	bdf5                	j	800037b2 <end_op+0x52>

00000000800038b8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038b8:	1101                	addi	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	e426                	sd	s1,8(sp)
    800038c0:	e04a                	sd	s2,0(sp)
    800038c2:	1000                	addi	s0,sp,32
    800038c4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038c6:	00016917          	auipc	s2,0x16
    800038ca:	95a90913          	addi	s2,s2,-1702 # 80019220 <log>
    800038ce:	854a                	mv	a0,s2
    800038d0:	00003097          	auipc	ra,0x3
    800038d4:	a52080e7          	jalr	-1454(ra) # 80006322 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038d8:	02c92603          	lw	a2,44(s2)
    800038dc:	47f5                	li	a5,29
    800038de:	06c7c563          	blt	a5,a2,80003948 <log_write+0x90>
    800038e2:	00016797          	auipc	a5,0x16
    800038e6:	95a7a783          	lw	a5,-1702(a5) # 8001923c <log+0x1c>
    800038ea:	37fd                	addiw	a5,a5,-1
    800038ec:	04f65e63          	bge	a2,a5,80003948 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038f0:	00016797          	auipc	a5,0x16
    800038f4:	9507a783          	lw	a5,-1712(a5) # 80019240 <log+0x20>
    800038f8:	06f05063          	blez	a5,80003958 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038fc:	4781                	li	a5,0
    800038fe:	06c05563          	blez	a2,80003968 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003902:	44cc                	lw	a1,12(s1)
    80003904:	00016717          	auipc	a4,0x16
    80003908:	94c70713          	addi	a4,a4,-1716 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000390c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000390e:	4314                	lw	a3,0(a4)
    80003910:	04b68c63          	beq	a3,a1,80003968 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003914:	2785                	addiw	a5,a5,1
    80003916:	0711                	addi	a4,a4,4
    80003918:	fef61be3          	bne	a2,a5,8000390e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000391c:	0621                	addi	a2,a2,8
    8000391e:	060a                	slli	a2,a2,0x2
    80003920:	00016797          	auipc	a5,0x16
    80003924:	90078793          	addi	a5,a5,-1792 # 80019220 <log>
    80003928:	963e                	add	a2,a2,a5
    8000392a:	44dc                	lw	a5,12(s1)
    8000392c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000392e:	8526                	mv	a0,s1
    80003930:	fffff097          	auipc	ra,0xfffff
    80003934:	daa080e7          	jalr	-598(ra) # 800026da <bpin>
    log.lh.n++;
    80003938:	00016717          	auipc	a4,0x16
    8000393c:	8e870713          	addi	a4,a4,-1816 # 80019220 <log>
    80003940:	575c                	lw	a5,44(a4)
    80003942:	2785                	addiw	a5,a5,1
    80003944:	d75c                	sw	a5,44(a4)
    80003946:	a835                	j	80003982 <log_write+0xca>
    panic("too big a transaction");
    80003948:	00005517          	auipc	a0,0x5
    8000394c:	ce850513          	addi	a0,a0,-792 # 80008630 <syscalls+0x238>
    80003950:	00002097          	auipc	ra,0x2
    80003954:	488080e7          	jalr	1160(ra) # 80005dd8 <panic>
    panic("log_write outside of trans");
    80003958:	00005517          	auipc	a0,0x5
    8000395c:	cf050513          	addi	a0,a0,-784 # 80008648 <syscalls+0x250>
    80003960:	00002097          	auipc	ra,0x2
    80003964:	478080e7          	jalr	1144(ra) # 80005dd8 <panic>
  log.lh.block[i] = b->blockno;
    80003968:	00878713          	addi	a4,a5,8
    8000396c:	00271693          	slli	a3,a4,0x2
    80003970:	00016717          	auipc	a4,0x16
    80003974:	8b070713          	addi	a4,a4,-1872 # 80019220 <log>
    80003978:	9736                	add	a4,a4,a3
    8000397a:	44d4                	lw	a3,12(s1)
    8000397c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000397e:	faf608e3          	beq	a2,a5,8000392e <log_write+0x76>
  }
  release(&log.lock);
    80003982:	00016517          	auipc	a0,0x16
    80003986:	89e50513          	addi	a0,a0,-1890 # 80019220 <log>
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	a4c080e7          	jalr	-1460(ra) # 800063d6 <release>
}
    80003992:	60e2                	ld	ra,24(sp)
    80003994:	6442                	ld	s0,16(sp)
    80003996:	64a2                	ld	s1,8(sp)
    80003998:	6902                	ld	s2,0(sp)
    8000399a:	6105                	addi	sp,sp,32
    8000399c:	8082                	ret

000000008000399e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000399e:	1101                	addi	sp,sp,-32
    800039a0:	ec06                	sd	ra,24(sp)
    800039a2:	e822                	sd	s0,16(sp)
    800039a4:	e426                	sd	s1,8(sp)
    800039a6:	e04a                	sd	s2,0(sp)
    800039a8:	1000                	addi	s0,sp,32
    800039aa:	84aa                	mv	s1,a0
    800039ac:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039ae:	00005597          	auipc	a1,0x5
    800039b2:	cba58593          	addi	a1,a1,-838 # 80008668 <syscalls+0x270>
    800039b6:	0521                	addi	a0,a0,8
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	8da080e7          	jalr	-1830(ra) # 80006292 <initlock>
  lk->name = name;
    800039c0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039c4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039c8:	0204a423          	sw	zero,40(s1)
}
    800039cc:	60e2                	ld	ra,24(sp)
    800039ce:	6442                	ld	s0,16(sp)
    800039d0:	64a2                	ld	s1,8(sp)
    800039d2:	6902                	ld	s2,0(sp)
    800039d4:	6105                	addi	sp,sp,32
    800039d6:	8082                	ret

00000000800039d8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039d8:	1101                	addi	sp,sp,-32
    800039da:	ec06                	sd	ra,24(sp)
    800039dc:	e822                	sd	s0,16(sp)
    800039de:	e426                	sd	s1,8(sp)
    800039e0:	e04a                	sd	s2,0(sp)
    800039e2:	1000                	addi	s0,sp,32
    800039e4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039e6:	00850913          	addi	s2,a0,8
    800039ea:	854a                	mv	a0,s2
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	936080e7          	jalr	-1738(ra) # 80006322 <acquire>
  while (lk->locked) {
    800039f4:	409c                	lw	a5,0(s1)
    800039f6:	cb89                	beqz	a5,80003a08 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039f8:	85ca                	mv	a1,s2
    800039fa:	8526                	mv	a0,s1
    800039fc:	ffffe097          	auipc	ra,0xffffe
    80003a00:	c9e080e7          	jalr	-866(ra) # 8000169a <sleep>
  while (lk->locked) {
    80003a04:	409c                	lw	a5,0(s1)
    80003a06:	fbed                	bnez	a5,800039f8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a08:	4785                	li	a5,1
    80003a0a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a0c:	ffffd097          	auipc	ra,0xffffd
    80003a10:	54c080e7          	jalr	1356(ra) # 80000f58 <myproc>
    80003a14:	591c                	lw	a5,48(a0)
    80003a16:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a18:	854a                	mv	a0,s2
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	9bc080e7          	jalr	-1604(ra) # 800063d6 <release>
}
    80003a22:	60e2                	ld	ra,24(sp)
    80003a24:	6442                	ld	s0,16(sp)
    80003a26:	64a2                	ld	s1,8(sp)
    80003a28:	6902                	ld	s2,0(sp)
    80003a2a:	6105                	addi	sp,sp,32
    80003a2c:	8082                	ret

0000000080003a2e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a2e:	1101                	addi	sp,sp,-32
    80003a30:	ec06                	sd	ra,24(sp)
    80003a32:	e822                	sd	s0,16(sp)
    80003a34:	e426                	sd	s1,8(sp)
    80003a36:	e04a                	sd	s2,0(sp)
    80003a38:	1000                	addi	s0,sp,32
    80003a3a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a3c:	00850913          	addi	s2,a0,8
    80003a40:	854a                	mv	a0,s2
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	8e0080e7          	jalr	-1824(ra) # 80006322 <acquire>
  lk->locked = 0;
    80003a4a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a4e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a52:	8526                	mv	a0,s1
    80003a54:	ffffe097          	auipc	ra,0xffffe
    80003a58:	dd2080e7          	jalr	-558(ra) # 80001826 <wakeup>
  release(&lk->lk);
    80003a5c:	854a                	mv	a0,s2
    80003a5e:	00003097          	auipc	ra,0x3
    80003a62:	978080e7          	jalr	-1672(ra) # 800063d6 <release>
}
    80003a66:	60e2                	ld	ra,24(sp)
    80003a68:	6442                	ld	s0,16(sp)
    80003a6a:	64a2                	ld	s1,8(sp)
    80003a6c:	6902                	ld	s2,0(sp)
    80003a6e:	6105                	addi	sp,sp,32
    80003a70:	8082                	ret

0000000080003a72 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a72:	7179                	addi	sp,sp,-48
    80003a74:	f406                	sd	ra,40(sp)
    80003a76:	f022                	sd	s0,32(sp)
    80003a78:	ec26                	sd	s1,24(sp)
    80003a7a:	e84a                	sd	s2,16(sp)
    80003a7c:	e44e                	sd	s3,8(sp)
    80003a7e:	1800                	addi	s0,sp,48
    80003a80:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a82:	00850913          	addi	s2,a0,8
    80003a86:	854a                	mv	a0,s2
    80003a88:	00003097          	auipc	ra,0x3
    80003a8c:	89a080e7          	jalr	-1894(ra) # 80006322 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a90:	409c                	lw	a5,0(s1)
    80003a92:	ef99                	bnez	a5,80003ab0 <holdingsleep+0x3e>
    80003a94:	4481                	li	s1,0
  release(&lk->lk);
    80003a96:	854a                	mv	a0,s2
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	93e080e7          	jalr	-1730(ra) # 800063d6 <release>
  return r;
}
    80003aa0:	8526                	mv	a0,s1
    80003aa2:	70a2                	ld	ra,40(sp)
    80003aa4:	7402                	ld	s0,32(sp)
    80003aa6:	64e2                	ld	s1,24(sp)
    80003aa8:	6942                	ld	s2,16(sp)
    80003aaa:	69a2                	ld	s3,8(sp)
    80003aac:	6145                	addi	sp,sp,48
    80003aae:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ab0:	0284a983          	lw	s3,40(s1)
    80003ab4:	ffffd097          	auipc	ra,0xffffd
    80003ab8:	4a4080e7          	jalr	1188(ra) # 80000f58 <myproc>
    80003abc:	5904                	lw	s1,48(a0)
    80003abe:	413484b3          	sub	s1,s1,s3
    80003ac2:	0014b493          	seqz	s1,s1
    80003ac6:	bfc1                	j	80003a96 <holdingsleep+0x24>

0000000080003ac8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ac8:	1141                	addi	sp,sp,-16
    80003aca:	e406                	sd	ra,8(sp)
    80003acc:	e022                	sd	s0,0(sp)
    80003ace:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ad0:	00005597          	auipc	a1,0x5
    80003ad4:	ba858593          	addi	a1,a1,-1112 # 80008678 <syscalls+0x280>
    80003ad8:	00016517          	auipc	a0,0x16
    80003adc:	89050513          	addi	a0,a0,-1904 # 80019368 <ftable>
    80003ae0:	00002097          	auipc	ra,0x2
    80003ae4:	7b2080e7          	jalr	1970(ra) # 80006292 <initlock>
}
    80003ae8:	60a2                	ld	ra,8(sp)
    80003aea:	6402                	ld	s0,0(sp)
    80003aec:	0141                	addi	sp,sp,16
    80003aee:	8082                	ret

0000000080003af0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003af0:	1101                	addi	sp,sp,-32
    80003af2:	ec06                	sd	ra,24(sp)
    80003af4:	e822                	sd	s0,16(sp)
    80003af6:	e426                	sd	s1,8(sp)
    80003af8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003afa:	00016517          	auipc	a0,0x16
    80003afe:	86e50513          	addi	a0,a0,-1938 # 80019368 <ftable>
    80003b02:	00003097          	auipc	ra,0x3
    80003b06:	820080e7          	jalr	-2016(ra) # 80006322 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b0a:	00016497          	auipc	s1,0x16
    80003b0e:	87648493          	addi	s1,s1,-1930 # 80019380 <ftable+0x18>
    80003b12:	00017717          	auipc	a4,0x17
    80003b16:	80e70713          	addi	a4,a4,-2034 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b1a:	40dc                	lw	a5,4(s1)
    80003b1c:	cf99                	beqz	a5,80003b3a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b1e:	02848493          	addi	s1,s1,40
    80003b22:	fee49ce3          	bne	s1,a4,80003b1a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b26:	00016517          	auipc	a0,0x16
    80003b2a:	84250513          	addi	a0,a0,-1982 # 80019368 <ftable>
    80003b2e:	00003097          	auipc	ra,0x3
    80003b32:	8a8080e7          	jalr	-1880(ra) # 800063d6 <release>
  return 0;
    80003b36:	4481                	li	s1,0
    80003b38:	a819                	j	80003b4e <filealloc+0x5e>
      f->ref = 1;
    80003b3a:	4785                	li	a5,1
    80003b3c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b3e:	00016517          	auipc	a0,0x16
    80003b42:	82a50513          	addi	a0,a0,-2006 # 80019368 <ftable>
    80003b46:	00003097          	auipc	ra,0x3
    80003b4a:	890080e7          	jalr	-1904(ra) # 800063d6 <release>
}
    80003b4e:	8526                	mv	a0,s1
    80003b50:	60e2                	ld	ra,24(sp)
    80003b52:	6442                	ld	s0,16(sp)
    80003b54:	64a2                	ld	s1,8(sp)
    80003b56:	6105                	addi	sp,sp,32
    80003b58:	8082                	ret

0000000080003b5a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b5a:	1101                	addi	sp,sp,-32
    80003b5c:	ec06                	sd	ra,24(sp)
    80003b5e:	e822                	sd	s0,16(sp)
    80003b60:	e426                	sd	s1,8(sp)
    80003b62:	1000                	addi	s0,sp,32
    80003b64:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b66:	00016517          	auipc	a0,0x16
    80003b6a:	80250513          	addi	a0,a0,-2046 # 80019368 <ftable>
    80003b6e:	00002097          	auipc	ra,0x2
    80003b72:	7b4080e7          	jalr	1972(ra) # 80006322 <acquire>
  if(f->ref < 1)
    80003b76:	40dc                	lw	a5,4(s1)
    80003b78:	02f05263          	blez	a5,80003b9c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b7c:	2785                	addiw	a5,a5,1
    80003b7e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b80:	00015517          	auipc	a0,0x15
    80003b84:	7e850513          	addi	a0,a0,2024 # 80019368 <ftable>
    80003b88:	00003097          	auipc	ra,0x3
    80003b8c:	84e080e7          	jalr	-1970(ra) # 800063d6 <release>
  return f;
}
    80003b90:	8526                	mv	a0,s1
    80003b92:	60e2                	ld	ra,24(sp)
    80003b94:	6442                	ld	s0,16(sp)
    80003b96:	64a2                	ld	s1,8(sp)
    80003b98:	6105                	addi	sp,sp,32
    80003b9a:	8082                	ret
    panic("filedup");
    80003b9c:	00005517          	auipc	a0,0x5
    80003ba0:	ae450513          	addi	a0,a0,-1308 # 80008680 <syscalls+0x288>
    80003ba4:	00002097          	auipc	ra,0x2
    80003ba8:	234080e7          	jalr	564(ra) # 80005dd8 <panic>

0000000080003bac <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bac:	7139                	addi	sp,sp,-64
    80003bae:	fc06                	sd	ra,56(sp)
    80003bb0:	f822                	sd	s0,48(sp)
    80003bb2:	f426                	sd	s1,40(sp)
    80003bb4:	f04a                	sd	s2,32(sp)
    80003bb6:	ec4e                	sd	s3,24(sp)
    80003bb8:	e852                	sd	s4,16(sp)
    80003bba:	e456                	sd	s5,8(sp)
    80003bbc:	0080                	addi	s0,sp,64
    80003bbe:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bc0:	00015517          	auipc	a0,0x15
    80003bc4:	7a850513          	addi	a0,a0,1960 # 80019368 <ftable>
    80003bc8:	00002097          	auipc	ra,0x2
    80003bcc:	75a080e7          	jalr	1882(ra) # 80006322 <acquire>
  if(f->ref < 1)
    80003bd0:	40dc                	lw	a5,4(s1)
    80003bd2:	06f05163          	blez	a5,80003c34 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bd6:	37fd                	addiw	a5,a5,-1
    80003bd8:	0007871b          	sext.w	a4,a5
    80003bdc:	c0dc                	sw	a5,4(s1)
    80003bde:	06e04363          	bgtz	a4,80003c44 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003be2:	0004a903          	lw	s2,0(s1)
    80003be6:	0094ca83          	lbu	s5,9(s1)
    80003bea:	0104ba03          	ld	s4,16(s1)
    80003bee:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bf2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bf6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bfa:	00015517          	auipc	a0,0x15
    80003bfe:	76e50513          	addi	a0,a0,1902 # 80019368 <ftable>
    80003c02:	00002097          	auipc	ra,0x2
    80003c06:	7d4080e7          	jalr	2004(ra) # 800063d6 <release>

  if(ff.type == FD_PIPE){
    80003c0a:	4785                	li	a5,1
    80003c0c:	04f90d63          	beq	s2,a5,80003c66 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c10:	3979                	addiw	s2,s2,-2
    80003c12:	4785                	li	a5,1
    80003c14:	0527e063          	bltu	a5,s2,80003c54 <fileclose+0xa8>
    begin_op();
    80003c18:	00000097          	auipc	ra,0x0
    80003c1c:	ac8080e7          	jalr	-1336(ra) # 800036e0 <begin_op>
    iput(ff.ip);
    80003c20:	854e                	mv	a0,s3
    80003c22:	fffff097          	auipc	ra,0xfffff
    80003c26:	2a6080e7          	jalr	678(ra) # 80002ec8 <iput>
    end_op();
    80003c2a:	00000097          	auipc	ra,0x0
    80003c2e:	b36080e7          	jalr	-1226(ra) # 80003760 <end_op>
    80003c32:	a00d                	j	80003c54 <fileclose+0xa8>
    panic("fileclose");
    80003c34:	00005517          	auipc	a0,0x5
    80003c38:	a5450513          	addi	a0,a0,-1452 # 80008688 <syscalls+0x290>
    80003c3c:	00002097          	auipc	ra,0x2
    80003c40:	19c080e7          	jalr	412(ra) # 80005dd8 <panic>
    release(&ftable.lock);
    80003c44:	00015517          	auipc	a0,0x15
    80003c48:	72450513          	addi	a0,a0,1828 # 80019368 <ftable>
    80003c4c:	00002097          	auipc	ra,0x2
    80003c50:	78a080e7          	jalr	1930(ra) # 800063d6 <release>
  }
}
    80003c54:	70e2                	ld	ra,56(sp)
    80003c56:	7442                	ld	s0,48(sp)
    80003c58:	74a2                	ld	s1,40(sp)
    80003c5a:	7902                	ld	s2,32(sp)
    80003c5c:	69e2                	ld	s3,24(sp)
    80003c5e:	6a42                	ld	s4,16(sp)
    80003c60:	6aa2                	ld	s5,8(sp)
    80003c62:	6121                	addi	sp,sp,64
    80003c64:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c66:	85d6                	mv	a1,s5
    80003c68:	8552                	mv	a0,s4
    80003c6a:	00000097          	auipc	ra,0x0
    80003c6e:	34c080e7          	jalr	844(ra) # 80003fb6 <pipeclose>
    80003c72:	b7cd                	j	80003c54 <fileclose+0xa8>

0000000080003c74 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c74:	715d                	addi	sp,sp,-80
    80003c76:	e486                	sd	ra,72(sp)
    80003c78:	e0a2                	sd	s0,64(sp)
    80003c7a:	fc26                	sd	s1,56(sp)
    80003c7c:	f84a                	sd	s2,48(sp)
    80003c7e:	f44e                	sd	s3,40(sp)
    80003c80:	0880                	addi	s0,sp,80
    80003c82:	84aa                	mv	s1,a0
    80003c84:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c86:	ffffd097          	auipc	ra,0xffffd
    80003c8a:	2d2080e7          	jalr	722(ra) # 80000f58 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c8e:	409c                	lw	a5,0(s1)
    80003c90:	37f9                	addiw	a5,a5,-2
    80003c92:	4705                	li	a4,1
    80003c94:	04f76763          	bltu	a4,a5,80003ce2 <filestat+0x6e>
    80003c98:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c9a:	6c88                	ld	a0,24(s1)
    80003c9c:	fffff097          	auipc	ra,0xfffff
    80003ca0:	072080e7          	jalr	114(ra) # 80002d0e <ilock>
    stati(f->ip, &st);
    80003ca4:	fb840593          	addi	a1,s0,-72
    80003ca8:	6c88                	ld	a0,24(s1)
    80003caa:	fffff097          	auipc	ra,0xfffff
    80003cae:	2ee080e7          	jalr	750(ra) # 80002f98 <stati>
    iunlock(f->ip);
    80003cb2:	6c88                	ld	a0,24(s1)
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	11c080e7          	jalr	284(ra) # 80002dd0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cbc:	46e1                	li	a3,24
    80003cbe:	fb840613          	addi	a2,s0,-72
    80003cc2:	85ce                	mv	a1,s3
    80003cc4:	05093503          	ld	a0,80(s2)
    80003cc8:	ffffd097          	auipc	ra,0xffffd
    80003ccc:	e42080e7          	jalr	-446(ra) # 80000b0a <copyout>
    80003cd0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cd4:	60a6                	ld	ra,72(sp)
    80003cd6:	6406                	ld	s0,64(sp)
    80003cd8:	74e2                	ld	s1,56(sp)
    80003cda:	7942                	ld	s2,48(sp)
    80003cdc:	79a2                	ld	s3,40(sp)
    80003cde:	6161                	addi	sp,sp,80
    80003ce0:	8082                	ret
  return -1;
    80003ce2:	557d                	li	a0,-1
    80003ce4:	bfc5                	j	80003cd4 <filestat+0x60>

0000000080003ce6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ce6:	7179                	addi	sp,sp,-48
    80003ce8:	f406                	sd	ra,40(sp)
    80003cea:	f022                	sd	s0,32(sp)
    80003cec:	ec26                	sd	s1,24(sp)
    80003cee:	e84a                	sd	s2,16(sp)
    80003cf0:	e44e                	sd	s3,8(sp)
    80003cf2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cf4:	00854783          	lbu	a5,8(a0)
    80003cf8:	c3d5                	beqz	a5,80003d9c <fileread+0xb6>
    80003cfa:	84aa                	mv	s1,a0
    80003cfc:	89ae                	mv	s3,a1
    80003cfe:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d00:	411c                	lw	a5,0(a0)
    80003d02:	4705                	li	a4,1
    80003d04:	04e78963          	beq	a5,a4,80003d56 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d08:	470d                	li	a4,3
    80003d0a:	04e78d63          	beq	a5,a4,80003d64 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d0e:	4709                	li	a4,2
    80003d10:	06e79e63          	bne	a5,a4,80003d8c <fileread+0xa6>
    ilock(f->ip);
    80003d14:	6d08                	ld	a0,24(a0)
    80003d16:	fffff097          	auipc	ra,0xfffff
    80003d1a:	ff8080e7          	jalr	-8(ra) # 80002d0e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d1e:	874a                	mv	a4,s2
    80003d20:	5094                	lw	a3,32(s1)
    80003d22:	864e                	mv	a2,s3
    80003d24:	4585                	li	a1,1
    80003d26:	6c88                	ld	a0,24(s1)
    80003d28:	fffff097          	auipc	ra,0xfffff
    80003d2c:	29a080e7          	jalr	666(ra) # 80002fc2 <readi>
    80003d30:	892a                	mv	s2,a0
    80003d32:	00a05563          	blez	a0,80003d3c <fileread+0x56>
      f->off += r;
    80003d36:	509c                	lw	a5,32(s1)
    80003d38:	9fa9                	addw	a5,a5,a0
    80003d3a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d3c:	6c88                	ld	a0,24(s1)
    80003d3e:	fffff097          	auipc	ra,0xfffff
    80003d42:	092080e7          	jalr	146(ra) # 80002dd0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d46:	854a                	mv	a0,s2
    80003d48:	70a2                	ld	ra,40(sp)
    80003d4a:	7402                	ld	s0,32(sp)
    80003d4c:	64e2                	ld	s1,24(sp)
    80003d4e:	6942                	ld	s2,16(sp)
    80003d50:	69a2                	ld	s3,8(sp)
    80003d52:	6145                	addi	sp,sp,48
    80003d54:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d56:	6908                	ld	a0,16(a0)
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	3c8080e7          	jalr	968(ra) # 80004120 <piperead>
    80003d60:	892a                	mv	s2,a0
    80003d62:	b7d5                	j	80003d46 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d64:	02451783          	lh	a5,36(a0)
    80003d68:	03079693          	slli	a3,a5,0x30
    80003d6c:	92c1                	srli	a3,a3,0x30
    80003d6e:	4725                	li	a4,9
    80003d70:	02d76863          	bltu	a4,a3,80003da0 <fileread+0xba>
    80003d74:	0792                	slli	a5,a5,0x4
    80003d76:	00015717          	auipc	a4,0x15
    80003d7a:	55270713          	addi	a4,a4,1362 # 800192c8 <devsw>
    80003d7e:	97ba                	add	a5,a5,a4
    80003d80:	639c                	ld	a5,0(a5)
    80003d82:	c38d                	beqz	a5,80003da4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d84:	4505                	li	a0,1
    80003d86:	9782                	jalr	a5
    80003d88:	892a                	mv	s2,a0
    80003d8a:	bf75                	j	80003d46 <fileread+0x60>
    panic("fileread");
    80003d8c:	00005517          	auipc	a0,0x5
    80003d90:	90c50513          	addi	a0,a0,-1780 # 80008698 <syscalls+0x2a0>
    80003d94:	00002097          	auipc	ra,0x2
    80003d98:	044080e7          	jalr	68(ra) # 80005dd8 <panic>
    return -1;
    80003d9c:	597d                	li	s2,-1
    80003d9e:	b765                	j	80003d46 <fileread+0x60>
      return -1;
    80003da0:	597d                	li	s2,-1
    80003da2:	b755                	j	80003d46 <fileread+0x60>
    80003da4:	597d                	li	s2,-1
    80003da6:	b745                	j	80003d46 <fileread+0x60>

0000000080003da8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003da8:	715d                	addi	sp,sp,-80
    80003daa:	e486                	sd	ra,72(sp)
    80003dac:	e0a2                	sd	s0,64(sp)
    80003dae:	fc26                	sd	s1,56(sp)
    80003db0:	f84a                	sd	s2,48(sp)
    80003db2:	f44e                	sd	s3,40(sp)
    80003db4:	f052                	sd	s4,32(sp)
    80003db6:	ec56                	sd	s5,24(sp)
    80003db8:	e85a                	sd	s6,16(sp)
    80003dba:	e45e                	sd	s7,8(sp)
    80003dbc:	e062                	sd	s8,0(sp)
    80003dbe:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dc0:	00954783          	lbu	a5,9(a0)
    80003dc4:	10078663          	beqz	a5,80003ed0 <filewrite+0x128>
    80003dc8:	892a                	mv	s2,a0
    80003dca:	8aae                	mv	s5,a1
    80003dcc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dce:	411c                	lw	a5,0(a0)
    80003dd0:	4705                	li	a4,1
    80003dd2:	02e78263          	beq	a5,a4,80003df6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dd6:	470d                	li	a4,3
    80003dd8:	02e78663          	beq	a5,a4,80003e04 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ddc:	4709                	li	a4,2
    80003dde:	0ee79163          	bne	a5,a4,80003ec0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003de2:	0ac05d63          	blez	a2,80003e9c <filewrite+0xf4>
    int i = 0;
    80003de6:	4981                	li	s3,0
    80003de8:	6b05                	lui	s6,0x1
    80003dea:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003dee:	6b85                	lui	s7,0x1
    80003df0:	c00b8b9b          	addiw	s7,s7,-1024
    80003df4:	a861                	j	80003e8c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003df6:	6908                	ld	a0,16(a0)
    80003df8:	00000097          	auipc	ra,0x0
    80003dfc:	22e080e7          	jalr	558(ra) # 80004026 <pipewrite>
    80003e00:	8a2a                	mv	s4,a0
    80003e02:	a045                	j	80003ea2 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e04:	02451783          	lh	a5,36(a0)
    80003e08:	03079693          	slli	a3,a5,0x30
    80003e0c:	92c1                	srli	a3,a3,0x30
    80003e0e:	4725                	li	a4,9
    80003e10:	0cd76263          	bltu	a4,a3,80003ed4 <filewrite+0x12c>
    80003e14:	0792                	slli	a5,a5,0x4
    80003e16:	00015717          	auipc	a4,0x15
    80003e1a:	4b270713          	addi	a4,a4,1202 # 800192c8 <devsw>
    80003e1e:	97ba                	add	a5,a5,a4
    80003e20:	679c                	ld	a5,8(a5)
    80003e22:	cbdd                	beqz	a5,80003ed8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e24:	4505                	li	a0,1
    80003e26:	9782                	jalr	a5
    80003e28:	8a2a                	mv	s4,a0
    80003e2a:	a8a5                	j	80003ea2 <filewrite+0xfa>
    80003e2c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e30:	00000097          	auipc	ra,0x0
    80003e34:	8b0080e7          	jalr	-1872(ra) # 800036e0 <begin_op>
      ilock(f->ip);
    80003e38:	01893503          	ld	a0,24(s2)
    80003e3c:	fffff097          	auipc	ra,0xfffff
    80003e40:	ed2080e7          	jalr	-302(ra) # 80002d0e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e44:	8762                	mv	a4,s8
    80003e46:	02092683          	lw	a3,32(s2)
    80003e4a:	01598633          	add	a2,s3,s5
    80003e4e:	4585                	li	a1,1
    80003e50:	01893503          	ld	a0,24(s2)
    80003e54:	fffff097          	auipc	ra,0xfffff
    80003e58:	266080e7          	jalr	614(ra) # 800030ba <writei>
    80003e5c:	84aa                	mv	s1,a0
    80003e5e:	00a05763          	blez	a0,80003e6c <filewrite+0xc4>
        f->off += r;
    80003e62:	02092783          	lw	a5,32(s2)
    80003e66:	9fa9                	addw	a5,a5,a0
    80003e68:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e6c:	01893503          	ld	a0,24(s2)
    80003e70:	fffff097          	auipc	ra,0xfffff
    80003e74:	f60080e7          	jalr	-160(ra) # 80002dd0 <iunlock>
      end_op();
    80003e78:	00000097          	auipc	ra,0x0
    80003e7c:	8e8080e7          	jalr	-1816(ra) # 80003760 <end_op>

      if(r != n1){
    80003e80:	009c1f63          	bne	s8,s1,80003e9e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e84:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e88:	0149db63          	bge	s3,s4,80003e9e <filewrite+0xf6>
      int n1 = n - i;
    80003e8c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e90:	84be                	mv	s1,a5
    80003e92:	2781                	sext.w	a5,a5
    80003e94:	f8fb5ce3          	bge	s6,a5,80003e2c <filewrite+0x84>
    80003e98:	84de                	mv	s1,s7
    80003e9a:	bf49                	j	80003e2c <filewrite+0x84>
    int i = 0;
    80003e9c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e9e:	013a1f63          	bne	s4,s3,80003ebc <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ea2:	8552                	mv	a0,s4
    80003ea4:	60a6                	ld	ra,72(sp)
    80003ea6:	6406                	ld	s0,64(sp)
    80003ea8:	74e2                	ld	s1,56(sp)
    80003eaa:	7942                	ld	s2,48(sp)
    80003eac:	79a2                	ld	s3,40(sp)
    80003eae:	7a02                	ld	s4,32(sp)
    80003eb0:	6ae2                	ld	s5,24(sp)
    80003eb2:	6b42                	ld	s6,16(sp)
    80003eb4:	6ba2                	ld	s7,8(sp)
    80003eb6:	6c02                	ld	s8,0(sp)
    80003eb8:	6161                	addi	sp,sp,80
    80003eba:	8082                	ret
    ret = (i == n ? n : -1);
    80003ebc:	5a7d                	li	s4,-1
    80003ebe:	b7d5                	j	80003ea2 <filewrite+0xfa>
    panic("filewrite");
    80003ec0:	00004517          	auipc	a0,0x4
    80003ec4:	7e850513          	addi	a0,a0,2024 # 800086a8 <syscalls+0x2b0>
    80003ec8:	00002097          	auipc	ra,0x2
    80003ecc:	f10080e7          	jalr	-240(ra) # 80005dd8 <panic>
    return -1;
    80003ed0:	5a7d                	li	s4,-1
    80003ed2:	bfc1                	j	80003ea2 <filewrite+0xfa>
      return -1;
    80003ed4:	5a7d                	li	s4,-1
    80003ed6:	b7f1                	j	80003ea2 <filewrite+0xfa>
    80003ed8:	5a7d                	li	s4,-1
    80003eda:	b7e1                	j	80003ea2 <filewrite+0xfa>

0000000080003edc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003edc:	7179                	addi	sp,sp,-48
    80003ede:	f406                	sd	ra,40(sp)
    80003ee0:	f022                	sd	s0,32(sp)
    80003ee2:	ec26                	sd	s1,24(sp)
    80003ee4:	e84a                	sd	s2,16(sp)
    80003ee6:	e44e                	sd	s3,8(sp)
    80003ee8:	e052                	sd	s4,0(sp)
    80003eea:	1800                	addi	s0,sp,48
    80003eec:	84aa                	mv	s1,a0
    80003eee:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ef0:	0005b023          	sd	zero,0(a1)
    80003ef4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ef8:	00000097          	auipc	ra,0x0
    80003efc:	bf8080e7          	jalr	-1032(ra) # 80003af0 <filealloc>
    80003f00:	e088                	sd	a0,0(s1)
    80003f02:	c551                	beqz	a0,80003f8e <pipealloc+0xb2>
    80003f04:	00000097          	auipc	ra,0x0
    80003f08:	bec080e7          	jalr	-1044(ra) # 80003af0 <filealloc>
    80003f0c:	00aa3023          	sd	a0,0(s4)
    80003f10:	c92d                	beqz	a0,80003f82 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f12:	ffffc097          	auipc	ra,0xffffc
    80003f16:	206080e7          	jalr	518(ra) # 80000118 <kalloc>
    80003f1a:	892a                	mv	s2,a0
    80003f1c:	c125                	beqz	a0,80003f7c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f1e:	4985                	li	s3,1
    80003f20:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f24:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f28:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f2c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f30:	00004597          	auipc	a1,0x4
    80003f34:	78858593          	addi	a1,a1,1928 # 800086b8 <syscalls+0x2c0>
    80003f38:	00002097          	auipc	ra,0x2
    80003f3c:	35a080e7          	jalr	858(ra) # 80006292 <initlock>
  (*f0)->type = FD_PIPE;
    80003f40:	609c                	ld	a5,0(s1)
    80003f42:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f46:	609c                	ld	a5,0(s1)
    80003f48:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f4c:	609c                	ld	a5,0(s1)
    80003f4e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f52:	609c                	ld	a5,0(s1)
    80003f54:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f58:	000a3783          	ld	a5,0(s4)
    80003f5c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f60:	000a3783          	ld	a5,0(s4)
    80003f64:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f68:	000a3783          	ld	a5,0(s4)
    80003f6c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f70:	000a3783          	ld	a5,0(s4)
    80003f74:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f78:	4501                	li	a0,0
    80003f7a:	a025                	j	80003fa2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f7c:	6088                	ld	a0,0(s1)
    80003f7e:	e501                	bnez	a0,80003f86 <pipealloc+0xaa>
    80003f80:	a039                	j	80003f8e <pipealloc+0xb2>
    80003f82:	6088                	ld	a0,0(s1)
    80003f84:	c51d                	beqz	a0,80003fb2 <pipealloc+0xd6>
    fileclose(*f0);
    80003f86:	00000097          	auipc	ra,0x0
    80003f8a:	c26080e7          	jalr	-986(ra) # 80003bac <fileclose>
  if(*f1)
    80003f8e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f92:	557d                	li	a0,-1
  if(*f1)
    80003f94:	c799                	beqz	a5,80003fa2 <pipealloc+0xc6>
    fileclose(*f1);
    80003f96:	853e                	mv	a0,a5
    80003f98:	00000097          	auipc	ra,0x0
    80003f9c:	c14080e7          	jalr	-1004(ra) # 80003bac <fileclose>
  return -1;
    80003fa0:	557d                	li	a0,-1
}
    80003fa2:	70a2                	ld	ra,40(sp)
    80003fa4:	7402                	ld	s0,32(sp)
    80003fa6:	64e2                	ld	s1,24(sp)
    80003fa8:	6942                	ld	s2,16(sp)
    80003faa:	69a2                	ld	s3,8(sp)
    80003fac:	6a02                	ld	s4,0(sp)
    80003fae:	6145                	addi	sp,sp,48
    80003fb0:	8082                	ret
  return -1;
    80003fb2:	557d                	li	a0,-1
    80003fb4:	b7fd                	j	80003fa2 <pipealloc+0xc6>

0000000080003fb6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fb6:	1101                	addi	sp,sp,-32
    80003fb8:	ec06                	sd	ra,24(sp)
    80003fba:	e822                	sd	s0,16(sp)
    80003fbc:	e426                	sd	s1,8(sp)
    80003fbe:	e04a                	sd	s2,0(sp)
    80003fc0:	1000                	addi	s0,sp,32
    80003fc2:	84aa                	mv	s1,a0
    80003fc4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fc6:	00002097          	auipc	ra,0x2
    80003fca:	35c080e7          	jalr	860(ra) # 80006322 <acquire>
  if(writable){
    80003fce:	02090d63          	beqz	s2,80004008 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fd2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fd6:	21848513          	addi	a0,s1,536
    80003fda:	ffffe097          	auipc	ra,0xffffe
    80003fde:	84c080e7          	jalr	-1972(ra) # 80001826 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fe2:	2204b783          	ld	a5,544(s1)
    80003fe6:	eb95                	bnez	a5,8000401a <pipeclose+0x64>
    release(&pi->lock);
    80003fe8:	8526                	mv	a0,s1
    80003fea:	00002097          	auipc	ra,0x2
    80003fee:	3ec080e7          	jalr	1004(ra) # 800063d6 <release>
    kfree((char*)pi);
    80003ff2:	8526                	mv	a0,s1
    80003ff4:	ffffc097          	auipc	ra,0xffffc
    80003ff8:	028080e7          	jalr	40(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ffc:	60e2                	ld	ra,24(sp)
    80003ffe:	6442                	ld	s0,16(sp)
    80004000:	64a2                	ld	s1,8(sp)
    80004002:	6902                	ld	s2,0(sp)
    80004004:	6105                	addi	sp,sp,32
    80004006:	8082                	ret
    pi->readopen = 0;
    80004008:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000400c:	21c48513          	addi	a0,s1,540
    80004010:	ffffe097          	auipc	ra,0xffffe
    80004014:	816080e7          	jalr	-2026(ra) # 80001826 <wakeup>
    80004018:	b7e9                	j	80003fe2 <pipeclose+0x2c>
    release(&pi->lock);
    8000401a:	8526                	mv	a0,s1
    8000401c:	00002097          	auipc	ra,0x2
    80004020:	3ba080e7          	jalr	954(ra) # 800063d6 <release>
}
    80004024:	bfe1                	j	80003ffc <pipeclose+0x46>

0000000080004026 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004026:	7159                	addi	sp,sp,-112
    80004028:	f486                	sd	ra,104(sp)
    8000402a:	f0a2                	sd	s0,96(sp)
    8000402c:	eca6                	sd	s1,88(sp)
    8000402e:	e8ca                	sd	s2,80(sp)
    80004030:	e4ce                	sd	s3,72(sp)
    80004032:	e0d2                	sd	s4,64(sp)
    80004034:	fc56                	sd	s5,56(sp)
    80004036:	f85a                	sd	s6,48(sp)
    80004038:	f45e                	sd	s7,40(sp)
    8000403a:	f062                	sd	s8,32(sp)
    8000403c:	ec66                	sd	s9,24(sp)
    8000403e:	1880                	addi	s0,sp,112
    80004040:	84aa                	mv	s1,a0
    80004042:	8aae                	mv	s5,a1
    80004044:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004046:	ffffd097          	auipc	ra,0xffffd
    8000404a:	f12080e7          	jalr	-238(ra) # 80000f58 <myproc>
    8000404e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004050:	8526                	mv	a0,s1
    80004052:	00002097          	auipc	ra,0x2
    80004056:	2d0080e7          	jalr	720(ra) # 80006322 <acquire>
  while(i < n){
    8000405a:	0d405163          	blez	s4,8000411c <pipewrite+0xf6>
    8000405e:	8ba6                	mv	s7,s1
  int i = 0;
    80004060:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004062:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004064:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004068:	21c48c13          	addi	s8,s1,540
    8000406c:	a08d                	j	800040ce <pipewrite+0xa8>
      release(&pi->lock);
    8000406e:	8526                	mv	a0,s1
    80004070:	00002097          	auipc	ra,0x2
    80004074:	366080e7          	jalr	870(ra) # 800063d6 <release>
      return -1;
    80004078:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000407a:	854a                	mv	a0,s2
    8000407c:	70a6                	ld	ra,104(sp)
    8000407e:	7406                	ld	s0,96(sp)
    80004080:	64e6                	ld	s1,88(sp)
    80004082:	6946                	ld	s2,80(sp)
    80004084:	69a6                	ld	s3,72(sp)
    80004086:	6a06                	ld	s4,64(sp)
    80004088:	7ae2                	ld	s5,56(sp)
    8000408a:	7b42                	ld	s6,48(sp)
    8000408c:	7ba2                	ld	s7,40(sp)
    8000408e:	7c02                	ld	s8,32(sp)
    80004090:	6ce2                	ld	s9,24(sp)
    80004092:	6165                	addi	sp,sp,112
    80004094:	8082                	ret
      wakeup(&pi->nread);
    80004096:	8566                	mv	a0,s9
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	78e080e7          	jalr	1934(ra) # 80001826 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040a0:	85de                	mv	a1,s7
    800040a2:	8562                	mv	a0,s8
    800040a4:	ffffd097          	auipc	ra,0xffffd
    800040a8:	5f6080e7          	jalr	1526(ra) # 8000169a <sleep>
    800040ac:	a839                	j	800040ca <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040ae:	21c4a783          	lw	a5,540(s1)
    800040b2:	0017871b          	addiw	a4,a5,1
    800040b6:	20e4ae23          	sw	a4,540(s1)
    800040ba:	1ff7f793          	andi	a5,a5,511
    800040be:	97a6                	add	a5,a5,s1
    800040c0:	f9f44703          	lbu	a4,-97(s0)
    800040c4:	00e78c23          	sb	a4,24(a5)
      i++;
    800040c8:	2905                	addiw	s2,s2,1
  while(i < n){
    800040ca:	03495d63          	bge	s2,s4,80004104 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800040ce:	2204a783          	lw	a5,544(s1)
    800040d2:	dfd1                	beqz	a5,8000406e <pipewrite+0x48>
    800040d4:	0289a783          	lw	a5,40(s3)
    800040d8:	fbd9                	bnez	a5,8000406e <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040da:	2184a783          	lw	a5,536(s1)
    800040de:	21c4a703          	lw	a4,540(s1)
    800040e2:	2007879b          	addiw	a5,a5,512
    800040e6:	faf708e3          	beq	a4,a5,80004096 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ea:	4685                	li	a3,1
    800040ec:	01590633          	add	a2,s2,s5
    800040f0:	f9f40593          	addi	a1,s0,-97
    800040f4:	0509b503          	ld	a0,80(s3)
    800040f8:	ffffd097          	auipc	ra,0xffffd
    800040fc:	a9e080e7          	jalr	-1378(ra) # 80000b96 <copyin>
    80004100:	fb6517e3          	bne	a0,s6,800040ae <pipewrite+0x88>
  wakeup(&pi->nread);
    80004104:	21848513          	addi	a0,s1,536
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	71e080e7          	jalr	1822(ra) # 80001826 <wakeup>
  release(&pi->lock);
    80004110:	8526                	mv	a0,s1
    80004112:	00002097          	auipc	ra,0x2
    80004116:	2c4080e7          	jalr	708(ra) # 800063d6 <release>
  return i;
    8000411a:	b785                	j	8000407a <pipewrite+0x54>
  int i = 0;
    8000411c:	4901                	li	s2,0
    8000411e:	b7dd                	j	80004104 <pipewrite+0xde>

0000000080004120 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004120:	715d                	addi	sp,sp,-80
    80004122:	e486                	sd	ra,72(sp)
    80004124:	e0a2                	sd	s0,64(sp)
    80004126:	fc26                	sd	s1,56(sp)
    80004128:	f84a                	sd	s2,48(sp)
    8000412a:	f44e                	sd	s3,40(sp)
    8000412c:	f052                	sd	s4,32(sp)
    8000412e:	ec56                	sd	s5,24(sp)
    80004130:	e85a                	sd	s6,16(sp)
    80004132:	0880                	addi	s0,sp,80
    80004134:	84aa                	mv	s1,a0
    80004136:	892e                	mv	s2,a1
    80004138:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000413a:	ffffd097          	auipc	ra,0xffffd
    8000413e:	e1e080e7          	jalr	-482(ra) # 80000f58 <myproc>
    80004142:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004144:	8b26                	mv	s6,s1
    80004146:	8526                	mv	a0,s1
    80004148:	00002097          	auipc	ra,0x2
    8000414c:	1da080e7          	jalr	474(ra) # 80006322 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004150:	2184a703          	lw	a4,536(s1)
    80004154:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004158:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000415c:	02f71463          	bne	a4,a5,80004184 <piperead+0x64>
    80004160:	2244a783          	lw	a5,548(s1)
    80004164:	c385                	beqz	a5,80004184 <piperead+0x64>
    if(pr->killed){
    80004166:	028a2783          	lw	a5,40(s4)
    8000416a:	ebc1                	bnez	a5,800041fa <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000416c:	85da                	mv	a1,s6
    8000416e:	854e                	mv	a0,s3
    80004170:	ffffd097          	auipc	ra,0xffffd
    80004174:	52a080e7          	jalr	1322(ra) # 8000169a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004178:	2184a703          	lw	a4,536(s1)
    8000417c:	21c4a783          	lw	a5,540(s1)
    80004180:	fef700e3          	beq	a4,a5,80004160 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004184:	09505263          	blez	s5,80004208 <piperead+0xe8>
    80004188:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000418a:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000418c:	2184a783          	lw	a5,536(s1)
    80004190:	21c4a703          	lw	a4,540(s1)
    80004194:	02f70d63          	beq	a4,a5,800041ce <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004198:	0017871b          	addiw	a4,a5,1
    8000419c:	20e4ac23          	sw	a4,536(s1)
    800041a0:	1ff7f793          	andi	a5,a5,511
    800041a4:	97a6                	add	a5,a5,s1
    800041a6:	0187c783          	lbu	a5,24(a5)
    800041aa:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041ae:	4685                	li	a3,1
    800041b0:	fbf40613          	addi	a2,s0,-65
    800041b4:	85ca                	mv	a1,s2
    800041b6:	050a3503          	ld	a0,80(s4)
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	950080e7          	jalr	-1712(ra) # 80000b0a <copyout>
    800041c2:	01650663          	beq	a0,s6,800041ce <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041c6:	2985                	addiw	s3,s3,1
    800041c8:	0905                	addi	s2,s2,1
    800041ca:	fd3a91e3          	bne	s5,s3,8000418c <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041ce:	21c48513          	addi	a0,s1,540
    800041d2:	ffffd097          	auipc	ra,0xffffd
    800041d6:	654080e7          	jalr	1620(ra) # 80001826 <wakeup>
  release(&pi->lock);
    800041da:	8526                	mv	a0,s1
    800041dc:	00002097          	auipc	ra,0x2
    800041e0:	1fa080e7          	jalr	506(ra) # 800063d6 <release>
  return i;
}
    800041e4:	854e                	mv	a0,s3
    800041e6:	60a6                	ld	ra,72(sp)
    800041e8:	6406                	ld	s0,64(sp)
    800041ea:	74e2                	ld	s1,56(sp)
    800041ec:	7942                	ld	s2,48(sp)
    800041ee:	79a2                	ld	s3,40(sp)
    800041f0:	7a02                	ld	s4,32(sp)
    800041f2:	6ae2                	ld	s5,24(sp)
    800041f4:	6b42                	ld	s6,16(sp)
    800041f6:	6161                	addi	sp,sp,80
    800041f8:	8082                	ret
      release(&pi->lock);
    800041fa:	8526                	mv	a0,s1
    800041fc:	00002097          	auipc	ra,0x2
    80004200:	1da080e7          	jalr	474(ra) # 800063d6 <release>
      return -1;
    80004204:	59fd                	li	s3,-1
    80004206:	bff9                	j	800041e4 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004208:	4981                	li	s3,0
    8000420a:	b7d1                	j	800041ce <piperead+0xae>

000000008000420c <exec>:
static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);
extern void vmprint(pagetable_t);

int
exec(char *path, char **argv)
{
    8000420c:	df010113          	addi	sp,sp,-528
    80004210:	20113423          	sd	ra,520(sp)
    80004214:	20813023          	sd	s0,512(sp)
    80004218:	ffa6                	sd	s1,504(sp)
    8000421a:	fbca                	sd	s2,496(sp)
    8000421c:	f7ce                	sd	s3,488(sp)
    8000421e:	f3d2                	sd	s4,480(sp)
    80004220:	efd6                	sd	s5,472(sp)
    80004222:	ebda                	sd	s6,464(sp)
    80004224:	e7de                	sd	s7,456(sp)
    80004226:	e3e2                	sd	s8,448(sp)
    80004228:	ff66                	sd	s9,440(sp)
    8000422a:	fb6a                	sd	s10,432(sp)
    8000422c:	f76e                	sd	s11,424(sp)
    8000422e:	0c00                	addi	s0,sp,528
    80004230:	84aa                	mv	s1,a0
    80004232:	dea43c23          	sd	a0,-520(s0)
    80004236:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	d1e080e7          	jalr	-738(ra) # 80000f58 <myproc>
    80004242:	892a                	mv	s2,a0

  begin_op();
    80004244:	fffff097          	auipc	ra,0xfffff
    80004248:	49c080e7          	jalr	1180(ra) # 800036e0 <begin_op>

  if((ip = namei(path)) == 0){
    8000424c:	8526                	mv	a0,s1
    8000424e:	fffff097          	auipc	ra,0xfffff
    80004252:	276080e7          	jalr	630(ra) # 800034c4 <namei>
    80004256:	c92d                	beqz	a0,800042c8 <exec+0xbc>
    80004258:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000425a:	fffff097          	auipc	ra,0xfffff
    8000425e:	ab4080e7          	jalr	-1356(ra) # 80002d0e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004262:	04000713          	li	a4,64
    80004266:	4681                	li	a3,0
    80004268:	e5040613          	addi	a2,s0,-432
    8000426c:	4581                	li	a1,0
    8000426e:	8526                	mv	a0,s1
    80004270:	fffff097          	auipc	ra,0xfffff
    80004274:	d52080e7          	jalr	-686(ra) # 80002fc2 <readi>
    80004278:	04000793          	li	a5,64
    8000427c:	00f51a63          	bne	a0,a5,80004290 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004280:	e5042703          	lw	a4,-432(s0)
    80004284:	464c47b7          	lui	a5,0x464c4
    80004288:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000428c:	04f70463          	beq	a4,a5,800042d4 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004290:	8526                	mv	a0,s1
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	cde080e7          	jalr	-802(ra) # 80002f70 <iunlockput>
    end_op();
    8000429a:	fffff097          	auipc	ra,0xfffff
    8000429e:	4c6080e7          	jalr	1222(ra) # 80003760 <end_op>
  }
  return -1;
    800042a2:	557d                	li	a0,-1
}
    800042a4:	20813083          	ld	ra,520(sp)
    800042a8:	20013403          	ld	s0,512(sp)
    800042ac:	74fe                	ld	s1,504(sp)
    800042ae:	795e                	ld	s2,496(sp)
    800042b0:	79be                	ld	s3,488(sp)
    800042b2:	7a1e                	ld	s4,480(sp)
    800042b4:	6afe                	ld	s5,472(sp)
    800042b6:	6b5e                	ld	s6,464(sp)
    800042b8:	6bbe                	ld	s7,456(sp)
    800042ba:	6c1e                	ld	s8,448(sp)
    800042bc:	7cfa                	ld	s9,440(sp)
    800042be:	7d5a                	ld	s10,432(sp)
    800042c0:	7dba                	ld	s11,424(sp)
    800042c2:	21010113          	addi	sp,sp,528
    800042c6:	8082                	ret
    end_op();
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	498080e7          	jalr	1176(ra) # 80003760 <end_op>
    return -1;
    800042d0:	557d                	li	a0,-1
    800042d2:	bfc9                	j	800042a4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042d4:	854a                	mv	a0,s2
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	d46080e7          	jalr	-698(ra) # 8000101c <proc_pagetable>
    800042de:	8baa                	mv	s7,a0
    800042e0:	d945                	beqz	a0,80004290 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042e2:	e7042983          	lw	s3,-400(s0)
    800042e6:	e8845783          	lhu	a5,-376(s0)
    800042ea:	c7ad                	beqz	a5,80004354 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ec:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ee:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042f0:	6c85                	lui	s9,0x1
    800042f2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042f6:	def43823          	sd	a5,-528(s0)
    800042fa:	a489                	j	8000453c <exec+0x330>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042fc:	00004517          	auipc	a0,0x4
    80004300:	3c450513          	addi	a0,a0,964 # 800086c0 <syscalls+0x2c8>
    80004304:	00002097          	auipc	ra,0x2
    80004308:	ad4080e7          	jalr	-1324(ra) # 80005dd8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000430c:	8756                	mv	a4,s5
    8000430e:	012d86bb          	addw	a3,s11,s2
    80004312:	4581                	li	a1,0
    80004314:	8526                	mv	a0,s1
    80004316:	fffff097          	auipc	ra,0xfffff
    8000431a:	cac080e7          	jalr	-852(ra) # 80002fc2 <readi>
    8000431e:	2501                	sext.w	a0,a0
    80004320:	1caa9563          	bne	s5,a0,800044ea <exec+0x2de>
  for(i = 0; i < sz; i += PGSIZE){
    80004324:	6785                	lui	a5,0x1
    80004326:	0127893b          	addw	s2,a5,s2
    8000432a:	77fd                	lui	a5,0xfffff
    8000432c:	01478a3b          	addw	s4,a5,s4
    80004330:	1f897d63          	bgeu	s2,s8,8000452a <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    80004334:	02091593          	slli	a1,s2,0x20
    80004338:	9181                	srli	a1,a1,0x20
    8000433a:	95ea                	add	a1,a1,s10
    8000433c:	855e                	mv	a0,s7
    8000433e:	ffffc097          	auipc	ra,0xffffc
    80004342:	1c8080e7          	jalr	456(ra) # 80000506 <walkaddr>
    80004346:	862a                	mv	a2,a0
    if(pa == 0)
    80004348:	d955                	beqz	a0,800042fc <exec+0xf0>
      n = PGSIZE;
    8000434a:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000434c:	fd9a70e3          	bgeu	s4,s9,8000430c <exec+0x100>
      n = sz - i;
    80004350:	8ad2                	mv	s5,s4
    80004352:	bf6d                	j	8000430c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004354:	4901                	li	s2,0
  iunlockput(ip);
    80004356:	8526                	mv	a0,s1
    80004358:	fffff097          	auipc	ra,0xfffff
    8000435c:	c18080e7          	jalr	-1000(ra) # 80002f70 <iunlockput>
  end_op();
    80004360:	fffff097          	auipc	ra,0xfffff
    80004364:	400080e7          	jalr	1024(ra) # 80003760 <end_op>
  p = myproc();
    80004368:	ffffd097          	auipc	ra,0xffffd
    8000436c:	bf0080e7          	jalr	-1040(ra) # 80000f58 <myproc>
    80004370:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004372:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004376:	6785                	lui	a5,0x1
    80004378:	17fd                	addi	a5,a5,-1
    8000437a:	993e                	add	s2,s2,a5
    8000437c:	757d                	lui	a0,0xfffff
    8000437e:	00a977b3          	and	a5,s2,a0
    80004382:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004386:	6609                	lui	a2,0x2
    80004388:	963e                	add	a2,a2,a5
    8000438a:	85be                	mv	a1,a5
    8000438c:	855e                	mv	a0,s7
    8000438e:	ffffc097          	auipc	ra,0xffffc
    80004392:	52c080e7          	jalr	1324(ra) # 800008ba <uvmalloc>
    80004396:	8b2a                	mv	s6,a0
  ip = 0;
    80004398:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000439a:	14050863          	beqz	a0,800044ea <exec+0x2de>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000439e:	75f9                	lui	a1,0xffffe
    800043a0:	95aa                	add	a1,a1,a0
    800043a2:	855e                	mv	a0,s7
    800043a4:	ffffc097          	auipc	ra,0xffffc
    800043a8:	734080e7          	jalr	1844(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    800043ac:	7c7d                	lui	s8,0xfffff
    800043ae:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800043b0:	e0043783          	ld	a5,-512(s0)
    800043b4:	6388                	ld	a0,0(a5)
    800043b6:	c535                	beqz	a0,80004422 <exec+0x216>
    800043b8:	e9040993          	addi	s3,s0,-368
    800043bc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043c0:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800043c2:	ffffc097          	auipc	ra,0xffffc
    800043c6:	f3a080e7          	jalr	-198(ra) # 800002fc <strlen>
    800043ca:	2505                	addiw	a0,a0,1
    800043cc:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043d0:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043d4:	13896f63          	bltu	s2,s8,80004512 <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043d8:	e0043d83          	ld	s11,-512(s0)
    800043dc:	000dba03          	ld	s4,0(s11)
    800043e0:	8552                	mv	a0,s4
    800043e2:	ffffc097          	auipc	ra,0xffffc
    800043e6:	f1a080e7          	jalr	-230(ra) # 800002fc <strlen>
    800043ea:	0015069b          	addiw	a3,a0,1
    800043ee:	8652                	mv	a2,s4
    800043f0:	85ca                	mv	a1,s2
    800043f2:	855e                	mv	a0,s7
    800043f4:	ffffc097          	auipc	ra,0xffffc
    800043f8:	716080e7          	jalr	1814(ra) # 80000b0a <copyout>
    800043fc:	10054f63          	bltz	a0,8000451a <exec+0x30e>
    ustack[argc] = sp;
    80004400:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004404:	0485                	addi	s1,s1,1
    80004406:	008d8793          	addi	a5,s11,8
    8000440a:	e0f43023          	sd	a5,-512(s0)
    8000440e:	008db503          	ld	a0,8(s11)
    80004412:	c911                	beqz	a0,80004426 <exec+0x21a>
    if(argc >= MAXARG)
    80004414:	09a1                	addi	s3,s3,8
    80004416:	fb3c96e3          	bne	s9,s3,800043c2 <exec+0x1b6>
  sz = sz1;
    8000441a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000441e:	4481                	li	s1,0
    80004420:	a0e9                	j	800044ea <exec+0x2de>
  sp = sz;
    80004422:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004424:	4481                	li	s1,0
  ustack[argc] = 0;
    80004426:	00349793          	slli	a5,s1,0x3
    8000442a:	f9040713          	addi	a4,s0,-112
    8000442e:	97ba                	add	a5,a5,a4
    80004430:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004434:	00148693          	addi	a3,s1,1
    80004438:	068e                	slli	a3,a3,0x3
    8000443a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000443e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004442:	01897663          	bgeu	s2,s8,8000444e <exec+0x242>
  sz = sz1;
    80004446:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000444a:	4481                	li	s1,0
    8000444c:	a879                	j	800044ea <exec+0x2de>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000444e:	e9040613          	addi	a2,s0,-368
    80004452:	85ca                	mv	a1,s2
    80004454:	855e                	mv	a0,s7
    80004456:	ffffc097          	auipc	ra,0xffffc
    8000445a:	6b4080e7          	jalr	1716(ra) # 80000b0a <copyout>
    8000445e:	0c054263          	bltz	a0,80004522 <exec+0x316>
  p->trapframe->a1 = sp;
    80004462:	058ab783          	ld	a5,88(s5)
    80004466:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000446a:	df843783          	ld	a5,-520(s0)
    8000446e:	0007c703          	lbu	a4,0(a5)
    80004472:	cf11                	beqz	a4,8000448e <exec+0x282>
    80004474:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004476:	02f00693          	li	a3,47
    8000447a:	a039                	j	80004488 <exec+0x27c>
      last = s+1;
    8000447c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004480:	0785                	addi	a5,a5,1
    80004482:	fff7c703          	lbu	a4,-1(a5)
    80004486:	c701                	beqz	a4,8000448e <exec+0x282>
    if(*s == '/')
    80004488:	fed71ce3          	bne	a4,a3,80004480 <exec+0x274>
    8000448c:	bfc5                	j	8000447c <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000448e:	4641                	li	a2,16
    80004490:	df843583          	ld	a1,-520(s0)
    80004494:	158a8513          	addi	a0,s5,344
    80004498:	ffffc097          	auipc	ra,0xffffc
    8000449c:	e32080e7          	jalr	-462(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800044a0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044a4:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800044a8:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044ac:	058ab783          	ld	a5,88(s5)
    800044b0:	e6843703          	ld	a4,-408(s0)
    800044b4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044b6:	058ab783          	ld	a5,88(s5)
    800044ba:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044be:	85ea                	mv	a1,s10
    800044c0:	ffffd097          	auipc	ra,0xffffd
    800044c4:	c26080e7          	jalr	-986(ra) # 800010e6 <proc_freepagetable>
  if(p->pid==1) vmprint(p->pagetable);
    800044c8:	030aa703          	lw	a4,48(s5)
    800044cc:	4785                	li	a5,1
    800044ce:	00f70563          	beq	a4,a5,800044d8 <exec+0x2cc>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044d2:	0004851b          	sext.w	a0,s1
    800044d6:	b3f9                	j	800042a4 <exec+0x98>
  if(p->pid==1) vmprint(p->pagetable);
    800044d8:	050ab503          	ld	a0,80(s5)
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	8da080e7          	jalr	-1830(ra) # 80000db6 <vmprint>
    800044e4:	b7fd                	j	800044d2 <exec+0x2c6>
    800044e6:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044ea:	e0843583          	ld	a1,-504(s0)
    800044ee:	855e                	mv	a0,s7
    800044f0:	ffffd097          	auipc	ra,0xffffd
    800044f4:	bf6080e7          	jalr	-1034(ra) # 800010e6 <proc_freepagetable>
  if(ip){
    800044f8:	d8049ce3          	bnez	s1,80004290 <exec+0x84>
  return -1;
    800044fc:	557d                	li	a0,-1
    800044fe:	b35d                	j	800042a4 <exec+0x98>
    80004500:	e1243423          	sd	s2,-504(s0)
    80004504:	b7dd                	j	800044ea <exec+0x2de>
    80004506:	e1243423          	sd	s2,-504(s0)
    8000450a:	b7c5                	j	800044ea <exec+0x2de>
    8000450c:	e1243423          	sd	s2,-504(s0)
    80004510:	bfe9                	j	800044ea <exec+0x2de>
  sz = sz1;
    80004512:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004516:	4481                	li	s1,0
    80004518:	bfc9                	j	800044ea <exec+0x2de>
  sz = sz1;
    8000451a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000451e:	4481                	li	s1,0
    80004520:	b7e9                	j	800044ea <exec+0x2de>
  sz = sz1;
    80004522:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004526:	4481                	li	s1,0
    80004528:	b7c9                	j	800044ea <exec+0x2de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000452a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000452e:	2b05                	addiw	s6,s6,1
    80004530:	0389899b          	addiw	s3,s3,56
    80004534:	e8845783          	lhu	a5,-376(s0)
    80004538:	e0fb5fe3          	bge	s6,a5,80004356 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000453c:	2981                	sext.w	s3,s3
    8000453e:	03800713          	li	a4,56
    80004542:	86ce                	mv	a3,s3
    80004544:	e1840613          	addi	a2,s0,-488
    80004548:	4581                	li	a1,0
    8000454a:	8526                	mv	a0,s1
    8000454c:	fffff097          	auipc	ra,0xfffff
    80004550:	a76080e7          	jalr	-1418(ra) # 80002fc2 <readi>
    80004554:	03800793          	li	a5,56
    80004558:	f8f517e3          	bne	a0,a5,800044e6 <exec+0x2da>
    if(ph.type != ELF_PROG_LOAD)
    8000455c:	e1842783          	lw	a5,-488(s0)
    80004560:	4705                	li	a4,1
    80004562:	fce796e3          	bne	a5,a4,8000452e <exec+0x322>
    if(ph.memsz < ph.filesz)
    80004566:	e4043603          	ld	a2,-448(s0)
    8000456a:	e3843783          	ld	a5,-456(s0)
    8000456e:	f8f669e3          	bltu	a2,a5,80004500 <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004572:	e2843783          	ld	a5,-472(s0)
    80004576:	963e                	add	a2,a2,a5
    80004578:	f8f667e3          	bltu	a2,a5,80004506 <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000457c:	85ca                	mv	a1,s2
    8000457e:	855e                	mv	a0,s7
    80004580:	ffffc097          	auipc	ra,0xffffc
    80004584:	33a080e7          	jalr	826(ra) # 800008ba <uvmalloc>
    80004588:	e0a43423          	sd	a0,-504(s0)
    8000458c:	d141                	beqz	a0,8000450c <exec+0x300>
    if((ph.vaddr % PGSIZE) != 0)
    8000458e:	e2843d03          	ld	s10,-472(s0)
    80004592:	df043783          	ld	a5,-528(s0)
    80004596:	00fd77b3          	and	a5,s10,a5
    8000459a:	fba1                	bnez	a5,800044ea <exec+0x2de>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000459c:	e2042d83          	lw	s11,-480(s0)
    800045a0:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045a4:	f80c03e3          	beqz	s8,8000452a <exec+0x31e>
    800045a8:	8a62                	mv	s4,s8
    800045aa:	4901                	li	s2,0
    800045ac:	b361                	j	80004334 <exec+0x128>

00000000800045ae <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045ae:	7179                	addi	sp,sp,-48
    800045b0:	f406                	sd	ra,40(sp)
    800045b2:	f022                	sd	s0,32(sp)
    800045b4:	ec26                	sd	s1,24(sp)
    800045b6:	e84a                	sd	s2,16(sp)
    800045b8:	1800                	addi	s0,sp,48
    800045ba:	892e                	mv	s2,a1
    800045bc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045be:	fdc40593          	addi	a1,s0,-36
    800045c2:	ffffe097          	auipc	ra,0xffffe
    800045c6:	ac8080e7          	jalr	-1336(ra) # 8000208a <argint>
    800045ca:	04054063          	bltz	a0,8000460a <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045ce:	fdc42703          	lw	a4,-36(s0)
    800045d2:	47bd                	li	a5,15
    800045d4:	02e7ed63          	bltu	a5,a4,8000460e <argfd+0x60>
    800045d8:	ffffd097          	auipc	ra,0xffffd
    800045dc:	980080e7          	jalr	-1664(ra) # 80000f58 <myproc>
    800045e0:	fdc42703          	lw	a4,-36(s0)
    800045e4:	01a70793          	addi	a5,a4,26
    800045e8:	078e                	slli	a5,a5,0x3
    800045ea:	953e                	add	a0,a0,a5
    800045ec:	611c                	ld	a5,0(a0)
    800045ee:	c395                	beqz	a5,80004612 <argfd+0x64>
    return -1;
  if(pfd)
    800045f0:	00090463          	beqz	s2,800045f8 <argfd+0x4a>
    *pfd = fd;
    800045f4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045f8:	4501                	li	a0,0
  if(pf)
    800045fa:	c091                	beqz	s1,800045fe <argfd+0x50>
    *pf = f;
    800045fc:	e09c                	sd	a5,0(s1)
}
    800045fe:	70a2                	ld	ra,40(sp)
    80004600:	7402                	ld	s0,32(sp)
    80004602:	64e2                	ld	s1,24(sp)
    80004604:	6942                	ld	s2,16(sp)
    80004606:	6145                	addi	sp,sp,48
    80004608:	8082                	ret
    return -1;
    8000460a:	557d                	li	a0,-1
    8000460c:	bfcd                	j	800045fe <argfd+0x50>
    return -1;
    8000460e:	557d                	li	a0,-1
    80004610:	b7fd                	j	800045fe <argfd+0x50>
    80004612:	557d                	li	a0,-1
    80004614:	b7ed                	j	800045fe <argfd+0x50>

0000000080004616 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004616:	1101                	addi	sp,sp,-32
    80004618:	ec06                	sd	ra,24(sp)
    8000461a:	e822                	sd	s0,16(sp)
    8000461c:	e426                	sd	s1,8(sp)
    8000461e:	1000                	addi	s0,sp,32
    80004620:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004622:	ffffd097          	auipc	ra,0xffffd
    80004626:	936080e7          	jalr	-1738(ra) # 80000f58 <myproc>
    8000462a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000462c:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    80004630:	4501                	li	a0,0
    80004632:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004634:	6398                	ld	a4,0(a5)
    80004636:	cb19                	beqz	a4,8000464c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004638:	2505                	addiw	a0,a0,1
    8000463a:	07a1                	addi	a5,a5,8
    8000463c:	fed51ce3          	bne	a0,a3,80004634 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004640:	557d                	li	a0,-1
}
    80004642:	60e2                	ld	ra,24(sp)
    80004644:	6442                	ld	s0,16(sp)
    80004646:	64a2                	ld	s1,8(sp)
    80004648:	6105                	addi	sp,sp,32
    8000464a:	8082                	ret
      p->ofile[fd] = f;
    8000464c:	01a50793          	addi	a5,a0,26
    80004650:	078e                	slli	a5,a5,0x3
    80004652:	963e                	add	a2,a2,a5
    80004654:	e204                	sd	s1,0(a2)
      return fd;
    80004656:	b7f5                	j	80004642 <fdalloc+0x2c>

0000000080004658 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004658:	715d                	addi	sp,sp,-80
    8000465a:	e486                	sd	ra,72(sp)
    8000465c:	e0a2                	sd	s0,64(sp)
    8000465e:	fc26                	sd	s1,56(sp)
    80004660:	f84a                	sd	s2,48(sp)
    80004662:	f44e                	sd	s3,40(sp)
    80004664:	f052                	sd	s4,32(sp)
    80004666:	ec56                	sd	s5,24(sp)
    80004668:	0880                	addi	s0,sp,80
    8000466a:	89ae                	mv	s3,a1
    8000466c:	8ab2                	mv	s5,a2
    8000466e:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004670:	fb040593          	addi	a1,s0,-80
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	e6e080e7          	jalr	-402(ra) # 800034e2 <nameiparent>
    8000467c:	892a                	mv	s2,a0
    8000467e:	12050f63          	beqz	a0,800047bc <create+0x164>
    return 0;

  ilock(dp);
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	68c080e7          	jalr	1676(ra) # 80002d0e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000468a:	4601                	li	a2,0
    8000468c:	fb040593          	addi	a1,s0,-80
    80004690:	854a                	mv	a0,s2
    80004692:	fffff097          	auipc	ra,0xfffff
    80004696:	b60080e7          	jalr	-1184(ra) # 800031f2 <dirlookup>
    8000469a:	84aa                	mv	s1,a0
    8000469c:	c921                	beqz	a0,800046ec <create+0x94>
    iunlockput(dp);
    8000469e:	854a                	mv	a0,s2
    800046a0:	fffff097          	auipc	ra,0xfffff
    800046a4:	8d0080e7          	jalr	-1840(ra) # 80002f70 <iunlockput>
    ilock(ip);
    800046a8:	8526                	mv	a0,s1
    800046aa:	ffffe097          	auipc	ra,0xffffe
    800046ae:	664080e7          	jalr	1636(ra) # 80002d0e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046b2:	2981                	sext.w	s3,s3
    800046b4:	4789                	li	a5,2
    800046b6:	02f99463          	bne	s3,a5,800046de <create+0x86>
    800046ba:	0444d783          	lhu	a5,68(s1)
    800046be:	37f9                	addiw	a5,a5,-2
    800046c0:	17c2                	slli	a5,a5,0x30
    800046c2:	93c1                	srli	a5,a5,0x30
    800046c4:	4705                	li	a4,1
    800046c6:	00f76c63          	bltu	a4,a5,800046de <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046ca:	8526                	mv	a0,s1
    800046cc:	60a6                	ld	ra,72(sp)
    800046ce:	6406                	ld	s0,64(sp)
    800046d0:	74e2                	ld	s1,56(sp)
    800046d2:	7942                	ld	s2,48(sp)
    800046d4:	79a2                	ld	s3,40(sp)
    800046d6:	7a02                	ld	s4,32(sp)
    800046d8:	6ae2                	ld	s5,24(sp)
    800046da:	6161                	addi	sp,sp,80
    800046dc:	8082                	ret
    iunlockput(ip);
    800046de:	8526                	mv	a0,s1
    800046e0:	fffff097          	auipc	ra,0xfffff
    800046e4:	890080e7          	jalr	-1904(ra) # 80002f70 <iunlockput>
    return 0;
    800046e8:	4481                	li	s1,0
    800046ea:	b7c5                	j	800046ca <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046ec:	85ce                	mv	a1,s3
    800046ee:	00092503          	lw	a0,0(s2)
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	484080e7          	jalr	1156(ra) # 80002b76 <ialloc>
    800046fa:	84aa                	mv	s1,a0
    800046fc:	c529                	beqz	a0,80004746 <create+0xee>
  ilock(ip);
    800046fe:	ffffe097          	auipc	ra,0xffffe
    80004702:	610080e7          	jalr	1552(ra) # 80002d0e <ilock>
  ip->major = major;
    80004706:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000470a:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000470e:	4785                	li	a5,1
    80004710:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004714:	8526                	mv	a0,s1
    80004716:	ffffe097          	auipc	ra,0xffffe
    8000471a:	52e080e7          	jalr	1326(ra) # 80002c44 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000471e:	2981                	sext.w	s3,s3
    80004720:	4785                	li	a5,1
    80004722:	02f98a63          	beq	s3,a5,80004756 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004726:	40d0                	lw	a2,4(s1)
    80004728:	fb040593          	addi	a1,s0,-80
    8000472c:	854a                	mv	a0,s2
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	cd4080e7          	jalr	-812(ra) # 80003402 <dirlink>
    80004736:	06054b63          	bltz	a0,800047ac <create+0x154>
  iunlockput(dp);
    8000473a:	854a                	mv	a0,s2
    8000473c:	fffff097          	auipc	ra,0xfffff
    80004740:	834080e7          	jalr	-1996(ra) # 80002f70 <iunlockput>
  return ip;
    80004744:	b759                	j	800046ca <create+0x72>
    panic("create: ialloc");
    80004746:	00004517          	auipc	a0,0x4
    8000474a:	f9a50513          	addi	a0,a0,-102 # 800086e0 <syscalls+0x2e8>
    8000474e:	00001097          	auipc	ra,0x1
    80004752:	68a080e7          	jalr	1674(ra) # 80005dd8 <panic>
    dp->nlink++;  // for ".."
    80004756:	04a95783          	lhu	a5,74(s2)
    8000475a:	2785                	addiw	a5,a5,1
    8000475c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004760:	854a                	mv	a0,s2
    80004762:	ffffe097          	auipc	ra,0xffffe
    80004766:	4e2080e7          	jalr	1250(ra) # 80002c44 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000476a:	40d0                	lw	a2,4(s1)
    8000476c:	00004597          	auipc	a1,0x4
    80004770:	f8458593          	addi	a1,a1,-124 # 800086f0 <syscalls+0x2f8>
    80004774:	8526                	mv	a0,s1
    80004776:	fffff097          	auipc	ra,0xfffff
    8000477a:	c8c080e7          	jalr	-884(ra) # 80003402 <dirlink>
    8000477e:	00054f63          	bltz	a0,8000479c <create+0x144>
    80004782:	00492603          	lw	a2,4(s2)
    80004786:	00004597          	auipc	a1,0x4
    8000478a:	f7258593          	addi	a1,a1,-142 # 800086f8 <syscalls+0x300>
    8000478e:	8526                	mv	a0,s1
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	c72080e7          	jalr	-910(ra) # 80003402 <dirlink>
    80004798:	f80557e3          	bgez	a0,80004726 <create+0xce>
      panic("create dots");
    8000479c:	00004517          	auipc	a0,0x4
    800047a0:	f6450513          	addi	a0,a0,-156 # 80008700 <syscalls+0x308>
    800047a4:	00001097          	auipc	ra,0x1
    800047a8:	634080e7          	jalr	1588(ra) # 80005dd8 <panic>
    panic("create: dirlink");
    800047ac:	00004517          	auipc	a0,0x4
    800047b0:	f6450513          	addi	a0,a0,-156 # 80008710 <syscalls+0x318>
    800047b4:	00001097          	auipc	ra,0x1
    800047b8:	624080e7          	jalr	1572(ra) # 80005dd8 <panic>
    return 0;
    800047bc:	84aa                	mv	s1,a0
    800047be:	b731                	j	800046ca <create+0x72>

00000000800047c0 <sys_dup>:
{
    800047c0:	7179                	addi	sp,sp,-48
    800047c2:	f406                	sd	ra,40(sp)
    800047c4:	f022                	sd	s0,32(sp)
    800047c6:	ec26                	sd	s1,24(sp)
    800047c8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047ca:	fd840613          	addi	a2,s0,-40
    800047ce:	4581                	li	a1,0
    800047d0:	4501                	li	a0,0
    800047d2:	00000097          	auipc	ra,0x0
    800047d6:	ddc080e7          	jalr	-548(ra) # 800045ae <argfd>
    return -1;
    800047da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047dc:	02054363          	bltz	a0,80004802 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047e0:	fd843503          	ld	a0,-40(s0)
    800047e4:	00000097          	auipc	ra,0x0
    800047e8:	e32080e7          	jalr	-462(ra) # 80004616 <fdalloc>
    800047ec:	84aa                	mv	s1,a0
    return -1;
    800047ee:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047f0:	00054963          	bltz	a0,80004802 <sys_dup+0x42>
  filedup(f);
    800047f4:	fd843503          	ld	a0,-40(s0)
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	362080e7          	jalr	866(ra) # 80003b5a <filedup>
  return fd;
    80004800:	87a6                	mv	a5,s1
}
    80004802:	853e                	mv	a0,a5
    80004804:	70a2                	ld	ra,40(sp)
    80004806:	7402                	ld	s0,32(sp)
    80004808:	64e2                	ld	s1,24(sp)
    8000480a:	6145                	addi	sp,sp,48
    8000480c:	8082                	ret

000000008000480e <sys_read>:
{
    8000480e:	7179                	addi	sp,sp,-48
    80004810:	f406                	sd	ra,40(sp)
    80004812:	f022                	sd	s0,32(sp)
    80004814:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004816:	fe840613          	addi	a2,s0,-24
    8000481a:	4581                	li	a1,0
    8000481c:	4501                	li	a0,0
    8000481e:	00000097          	auipc	ra,0x0
    80004822:	d90080e7          	jalr	-624(ra) # 800045ae <argfd>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004828:	04054163          	bltz	a0,8000486a <sys_read+0x5c>
    8000482c:	fe440593          	addi	a1,s0,-28
    80004830:	4509                	li	a0,2
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	858080e7          	jalr	-1960(ra) # 8000208a <argint>
    return -1;
    8000483a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000483c:	02054763          	bltz	a0,8000486a <sys_read+0x5c>
    80004840:	fd840593          	addi	a1,s0,-40
    80004844:	4505                	li	a0,1
    80004846:	ffffe097          	auipc	ra,0xffffe
    8000484a:	866080e7          	jalr	-1946(ra) # 800020ac <argaddr>
    return -1;
    8000484e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004850:	00054d63          	bltz	a0,8000486a <sys_read+0x5c>
  return fileread(f, p, n);
    80004854:	fe442603          	lw	a2,-28(s0)
    80004858:	fd843583          	ld	a1,-40(s0)
    8000485c:	fe843503          	ld	a0,-24(s0)
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	486080e7          	jalr	1158(ra) # 80003ce6 <fileread>
    80004868:	87aa                	mv	a5,a0
}
    8000486a:	853e                	mv	a0,a5
    8000486c:	70a2                	ld	ra,40(sp)
    8000486e:	7402                	ld	s0,32(sp)
    80004870:	6145                	addi	sp,sp,48
    80004872:	8082                	ret

0000000080004874 <sys_write>:
{
    80004874:	7179                	addi	sp,sp,-48
    80004876:	f406                	sd	ra,40(sp)
    80004878:	f022                	sd	s0,32(sp)
    8000487a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487c:	fe840613          	addi	a2,s0,-24
    80004880:	4581                	li	a1,0
    80004882:	4501                	li	a0,0
    80004884:	00000097          	auipc	ra,0x0
    80004888:	d2a080e7          	jalr	-726(ra) # 800045ae <argfd>
    return -1;
    8000488c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000488e:	04054163          	bltz	a0,800048d0 <sys_write+0x5c>
    80004892:	fe440593          	addi	a1,s0,-28
    80004896:	4509                	li	a0,2
    80004898:	ffffd097          	auipc	ra,0xffffd
    8000489c:	7f2080e7          	jalr	2034(ra) # 8000208a <argint>
    return -1;
    800048a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a2:	02054763          	bltz	a0,800048d0 <sys_write+0x5c>
    800048a6:	fd840593          	addi	a1,s0,-40
    800048aa:	4505                	li	a0,1
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	800080e7          	jalr	-2048(ra) # 800020ac <argaddr>
    return -1;
    800048b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048b6:	00054d63          	bltz	a0,800048d0 <sys_write+0x5c>
  return filewrite(f, p, n);
    800048ba:	fe442603          	lw	a2,-28(s0)
    800048be:	fd843583          	ld	a1,-40(s0)
    800048c2:	fe843503          	ld	a0,-24(s0)
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	4e2080e7          	jalr	1250(ra) # 80003da8 <filewrite>
    800048ce:	87aa                	mv	a5,a0
}
    800048d0:	853e                	mv	a0,a5
    800048d2:	70a2                	ld	ra,40(sp)
    800048d4:	7402                	ld	s0,32(sp)
    800048d6:	6145                	addi	sp,sp,48
    800048d8:	8082                	ret

00000000800048da <sys_close>:
{
    800048da:	1101                	addi	sp,sp,-32
    800048dc:	ec06                	sd	ra,24(sp)
    800048de:	e822                	sd	s0,16(sp)
    800048e0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048e2:	fe040613          	addi	a2,s0,-32
    800048e6:	fec40593          	addi	a1,s0,-20
    800048ea:	4501                	li	a0,0
    800048ec:	00000097          	auipc	ra,0x0
    800048f0:	cc2080e7          	jalr	-830(ra) # 800045ae <argfd>
    return -1;
    800048f4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048f6:	02054463          	bltz	a0,8000491e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048fa:	ffffc097          	auipc	ra,0xffffc
    800048fe:	65e080e7          	jalr	1630(ra) # 80000f58 <myproc>
    80004902:	fec42783          	lw	a5,-20(s0)
    80004906:	07e9                	addi	a5,a5,26
    80004908:	078e                	slli	a5,a5,0x3
    8000490a:	97aa                	add	a5,a5,a0
    8000490c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004910:	fe043503          	ld	a0,-32(s0)
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	298080e7          	jalr	664(ra) # 80003bac <fileclose>
  return 0;
    8000491c:	4781                	li	a5,0
}
    8000491e:	853e                	mv	a0,a5
    80004920:	60e2                	ld	ra,24(sp)
    80004922:	6442                	ld	s0,16(sp)
    80004924:	6105                	addi	sp,sp,32
    80004926:	8082                	ret

0000000080004928 <sys_fstat>:
{
    80004928:	1101                	addi	sp,sp,-32
    8000492a:	ec06                	sd	ra,24(sp)
    8000492c:	e822                	sd	s0,16(sp)
    8000492e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004930:	fe840613          	addi	a2,s0,-24
    80004934:	4581                	li	a1,0
    80004936:	4501                	li	a0,0
    80004938:	00000097          	auipc	ra,0x0
    8000493c:	c76080e7          	jalr	-906(ra) # 800045ae <argfd>
    return -1;
    80004940:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004942:	02054563          	bltz	a0,8000496c <sys_fstat+0x44>
    80004946:	fe040593          	addi	a1,s0,-32
    8000494a:	4505                	li	a0,1
    8000494c:	ffffd097          	auipc	ra,0xffffd
    80004950:	760080e7          	jalr	1888(ra) # 800020ac <argaddr>
    return -1;
    80004954:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004956:	00054b63          	bltz	a0,8000496c <sys_fstat+0x44>
  return filestat(f, st);
    8000495a:	fe043583          	ld	a1,-32(s0)
    8000495e:	fe843503          	ld	a0,-24(s0)
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	312080e7          	jalr	786(ra) # 80003c74 <filestat>
    8000496a:	87aa                	mv	a5,a0
}
    8000496c:	853e                	mv	a0,a5
    8000496e:	60e2                	ld	ra,24(sp)
    80004970:	6442                	ld	s0,16(sp)
    80004972:	6105                	addi	sp,sp,32
    80004974:	8082                	ret

0000000080004976 <sys_link>:
{
    80004976:	7169                	addi	sp,sp,-304
    80004978:	f606                	sd	ra,296(sp)
    8000497a:	f222                	sd	s0,288(sp)
    8000497c:	ee26                	sd	s1,280(sp)
    8000497e:	ea4a                	sd	s2,272(sp)
    80004980:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004982:	08000613          	li	a2,128
    80004986:	ed040593          	addi	a1,s0,-304
    8000498a:	4501                	li	a0,0
    8000498c:	ffffd097          	auipc	ra,0xffffd
    80004990:	742080e7          	jalr	1858(ra) # 800020ce <argstr>
    return -1;
    80004994:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004996:	10054e63          	bltz	a0,80004ab2 <sys_link+0x13c>
    8000499a:	08000613          	li	a2,128
    8000499e:	f5040593          	addi	a1,s0,-176
    800049a2:	4505                	li	a0,1
    800049a4:	ffffd097          	auipc	ra,0xffffd
    800049a8:	72a080e7          	jalr	1834(ra) # 800020ce <argstr>
    return -1;
    800049ac:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ae:	10054263          	bltz	a0,80004ab2 <sys_link+0x13c>
  begin_op();
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	d2e080e7          	jalr	-722(ra) # 800036e0 <begin_op>
  if((ip = namei(old)) == 0){
    800049ba:	ed040513          	addi	a0,s0,-304
    800049be:	fffff097          	auipc	ra,0xfffff
    800049c2:	b06080e7          	jalr	-1274(ra) # 800034c4 <namei>
    800049c6:	84aa                	mv	s1,a0
    800049c8:	c551                	beqz	a0,80004a54 <sys_link+0xde>
  ilock(ip);
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	344080e7          	jalr	836(ra) # 80002d0e <ilock>
  if(ip->type == T_DIR){
    800049d2:	04449703          	lh	a4,68(s1)
    800049d6:	4785                	li	a5,1
    800049d8:	08f70463          	beq	a4,a5,80004a60 <sys_link+0xea>
  ip->nlink++;
    800049dc:	04a4d783          	lhu	a5,74(s1)
    800049e0:	2785                	addiw	a5,a5,1
    800049e2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049e6:	8526                	mv	a0,s1
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	25c080e7          	jalr	604(ra) # 80002c44 <iupdate>
  iunlock(ip);
    800049f0:	8526                	mv	a0,s1
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	3de080e7          	jalr	990(ra) # 80002dd0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049fa:	fd040593          	addi	a1,s0,-48
    800049fe:	f5040513          	addi	a0,s0,-176
    80004a02:	fffff097          	auipc	ra,0xfffff
    80004a06:	ae0080e7          	jalr	-1312(ra) # 800034e2 <nameiparent>
    80004a0a:	892a                	mv	s2,a0
    80004a0c:	c935                	beqz	a0,80004a80 <sys_link+0x10a>
  ilock(dp);
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	300080e7          	jalr	768(ra) # 80002d0e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a16:	00092703          	lw	a4,0(s2)
    80004a1a:	409c                	lw	a5,0(s1)
    80004a1c:	04f71d63          	bne	a4,a5,80004a76 <sys_link+0x100>
    80004a20:	40d0                	lw	a2,4(s1)
    80004a22:	fd040593          	addi	a1,s0,-48
    80004a26:	854a                	mv	a0,s2
    80004a28:	fffff097          	auipc	ra,0xfffff
    80004a2c:	9da080e7          	jalr	-1574(ra) # 80003402 <dirlink>
    80004a30:	04054363          	bltz	a0,80004a76 <sys_link+0x100>
  iunlockput(dp);
    80004a34:	854a                	mv	a0,s2
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	53a080e7          	jalr	1338(ra) # 80002f70 <iunlockput>
  iput(ip);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	488080e7          	jalr	1160(ra) # 80002ec8 <iput>
  end_op();
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	d18080e7          	jalr	-744(ra) # 80003760 <end_op>
  return 0;
    80004a50:	4781                	li	a5,0
    80004a52:	a085                	j	80004ab2 <sys_link+0x13c>
    end_op();
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	d0c080e7          	jalr	-756(ra) # 80003760 <end_op>
    return -1;
    80004a5c:	57fd                	li	a5,-1
    80004a5e:	a891                	j	80004ab2 <sys_link+0x13c>
    iunlockput(ip);
    80004a60:	8526                	mv	a0,s1
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	50e080e7          	jalr	1294(ra) # 80002f70 <iunlockput>
    end_op();
    80004a6a:	fffff097          	auipc	ra,0xfffff
    80004a6e:	cf6080e7          	jalr	-778(ra) # 80003760 <end_op>
    return -1;
    80004a72:	57fd                	li	a5,-1
    80004a74:	a83d                	j	80004ab2 <sys_link+0x13c>
    iunlockput(dp);
    80004a76:	854a                	mv	a0,s2
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	4f8080e7          	jalr	1272(ra) # 80002f70 <iunlockput>
  ilock(ip);
    80004a80:	8526                	mv	a0,s1
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	28c080e7          	jalr	652(ra) # 80002d0e <ilock>
  ip->nlink--;
    80004a8a:	04a4d783          	lhu	a5,74(s1)
    80004a8e:	37fd                	addiw	a5,a5,-1
    80004a90:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	1ae080e7          	jalr	430(ra) # 80002c44 <iupdate>
  iunlockput(ip);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	4d0080e7          	jalr	1232(ra) # 80002f70 <iunlockput>
  end_op();
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	cb8080e7          	jalr	-840(ra) # 80003760 <end_op>
  return -1;
    80004ab0:	57fd                	li	a5,-1
}
    80004ab2:	853e                	mv	a0,a5
    80004ab4:	70b2                	ld	ra,296(sp)
    80004ab6:	7412                	ld	s0,288(sp)
    80004ab8:	64f2                	ld	s1,280(sp)
    80004aba:	6952                	ld	s2,272(sp)
    80004abc:	6155                	addi	sp,sp,304
    80004abe:	8082                	ret

0000000080004ac0 <sys_unlink>:
{
    80004ac0:	7151                	addi	sp,sp,-240
    80004ac2:	f586                	sd	ra,232(sp)
    80004ac4:	f1a2                	sd	s0,224(sp)
    80004ac6:	eda6                	sd	s1,216(sp)
    80004ac8:	e9ca                	sd	s2,208(sp)
    80004aca:	e5ce                	sd	s3,200(sp)
    80004acc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ace:	08000613          	li	a2,128
    80004ad2:	f3040593          	addi	a1,s0,-208
    80004ad6:	4501                	li	a0,0
    80004ad8:	ffffd097          	auipc	ra,0xffffd
    80004adc:	5f6080e7          	jalr	1526(ra) # 800020ce <argstr>
    80004ae0:	18054163          	bltz	a0,80004c62 <sys_unlink+0x1a2>
  begin_op();
    80004ae4:	fffff097          	auipc	ra,0xfffff
    80004ae8:	bfc080e7          	jalr	-1028(ra) # 800036e0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004aec:	fb040593          	addi	a1,s0,-80
    80004af0:	f3040513          	addi	a0,s0,-208
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	9ee080e7          	jalr	-1554(ra) # 800034e2 <nameiparent>
    80004afc:	84aa                	mv	s1,a0
    80004afe:	c979                	beqz	a0,80004bd4 <sys_unlink+0x114>
  ilock(dp);
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	20e080e7          	jalr	526(ra) # 80002d0e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b08:	00004597          	auipc	a1,0x4
    80004b0c:	be858593          	addi	a1,a1,-1048 # 800086f0 <syscalls+0x2f8>
    80004b10:	fb040513          	addi	a0,s0,-80
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	6c4080e7          	jalr	1732(ra) # 800031d8 <namecmp>
    80004b1c:	14050a63          	beqz	a0,80004c70 <sys_unlink+0x1b0>
    80004b20:	00004597          	auipc	a1,0x4
    80004b24:	bd858593          	addi	a1,a1,-1064 # 800086f8 <syscalls+0x300>
    80004b28:	fb040513          	addi	a0,s0,-80
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	6ac080e7          	jalr	1708(ra) # 800031d8 <namecmp>
    80004b34:	12050e63          	beqz	a0,80004c70 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b38:	f2c40613          	addi	a2,s0,-212
    80004b3c:	fb040593          	addi	a1,s0,-80
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	6b0080e7          	jalr	1712(ra) # 800031f2 <dirlookup>
    80004b4a:	892a                	mv	s2,a0
    80004b4c:	12050263          	beqz	a0,80004c70 <sys_unlink+0x1b0>
  ilock(ip);
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	1be080e7          	jalr	446(ra) # 80002d0e <ilock>
  if(ip->nlink < 1)
    80004b58:	04a91783          	lh	a5,74(s2)
    80004b5c:	08f05263          	blez	a5,80004be0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b60:	04491703          	lh	a4,68(s2)
    80004b64:	4785                	li	a5,1
    80004b66:	08f70563          	beq	a4,a5,80004bf0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b6a:	4641                	li	a2,16
    80004b6c:	4581                	li	a1,0
    80004b6e:	fc040513          	addi	a0,s0,-64
    80004b72:	ffffb097          	auipc	ra,0xffffb
    80004b76:	606080e7          	jalr	1542(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7a:	4741                	li	a4,16
    80004b7c:	f2c42683          	lw	a3,-212(s0)
    80004b80:	fc040613          	addi	a2,s0,-64
    80004b84:	4581                	li	a1,0
    80004b86:	8526                	mv	a0,s1
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	532080e7          	jalr	1330(ra) # 800030ba <writei>
    80004b90:	47c1                	li	a5,16
    80004b92:	0af51563          	bne	a0,a5,80004c3c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b96:	04491703          	lh	a4,68(s2)
    80004b9a:	4785                	li	a5,1
    80004b9c:	0af70863          	beq	a4,a5,80004c4c <sys_unlink+0x18c>
  iunlockput(dp);
    80004ba0:	8526                	mv	a0,s1
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	3ce080e7          	jalr	974(ra) # 80002f70 <iunlockput>
  ip->nlink--;
    80004baa:	04a95783          	lhu	a5,74(s2)
    80004bae:	37fd                	addiw	a5,a5,-1
    80004bb0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bb4:	854a                	mv	a0,s2
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	08e080e7          	jalr	142(ra) # 80002c44 <iupdate>
  iunlockput(ip);
    80004bbe:	854a                	mv	a0,s2
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	3b0080e7          	jalr	944(ra) # 80002f70 <iunlockput>
  end_op();
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	b98080e7          	jalr	-1128(ra) # 80003760 <end_op>
  return 0;
    80004bd0:	4501                	li	a0,0
    80004bd2:	a84d                	j	80004c84 <sys_unlink+0x1c4>
    end_op();
    80004bd4:	fffff097          	auipc	ra,0xfffff
    80004bd8:	b8c080e7          	jalr	-1140(ra) # 80003760 <end_op>
    return -1;
    80004bdc:	557d                	li	a0,-1
    80004bde:	a05d                	j	80004c84 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004be0:	00004517          	auipc	a0,0x4
    80004be4:	b4050513          	addi	a0,a0,-1216 # 80008720 <syscalls+0x328>
    80004be8:	00001097          	auipc	ra,0x1
    80004bec:	1f0080e7          	jalr	496(ra) # 80005dd8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bf0:	04c92703          	lw	a4,76(s2)
    80004bf4:	02000793          	li	a5,32
    80004bf8:	f6e7f9e3          	bgeu	a5,a4,80004b6a <sys_unlink+0xaa>
    80004bfc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c00:	4741                	li	a4,16
    80004c02:	86ce                	mv	a3,s3
    80004c04:	f1840613          	addi	a2,s0,-232
    80004c08:	4581                	li	a1,0
    80004c0a:	854a                	mv	a0,s2
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	3b6080e7          	jalr	950(ra) # 80002fc2 <readi>
    80004c14:	47c1                	li	a5,16
    80004c16:	00f51b63          	bne	a0,a5,80004c2c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c1a:	f1845783          	lhu	a5,-232(s0)
    80004c1e:	e7a1                	bnez	a5,80004c66 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c20:	29c1                	addiw	s3,s3,16
    80004c22:	04c92783          	lw	a5,76(s2)
    80004c26:	fcf9ede3          	bltu	s3,a5,80004c00 <sys_unlink+0x140>
    80004c2a:	b781                	j	80004b6a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c2c:	00004517          	auipc	a0,0x4
    80004c30:	b0c50513          	addi	a0,a0,-1268 # 80008738 <syscalls+0x340>
    80004c34:	00001097          	auipc	ra,0x1
    80004c38:	1a4080e7          	jalr	420(ra) # 80005dd8 <panic>
    panic("unlink: writei");
    80004c3c:	00004517          	auipc	a0,0x4
    80004c40:	b1450513          	addi	a0,a0,-1260 # 80008750 <syscalls+0x358>
    80004c44:	00001097          	auipc	ra,0x1
    80004c48:	194080e7          	jalr	404(ra) # 80005dd8 <panic>
    dp->nlink--;
    80004c4c:	04a4d783          	lhu	a5,74(s1)
    80004c50:	37fd                	addiw	a5,a5,-1
    80004c52:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c56:	8526                	mv	a0,s1
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	fec080e7          	jalr	-20(ra) # 80002c44 <iupdate>
    80004c60:	b781                	j	80004ba0 <sys_unlink+0xe0>
    return -1;
    80004c62:	557d                	li	a0,-1
    80004c64:	a005                	j	80004c84 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c66:	854a                	mv	a0,s2
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	308080e7          	jalr	776(ra) # 80002f70 <iunlockput>
  iunlockput(dp);
    80004c70:	8526                	mv	a0,s1
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	2fe080e7          	jalr	766(ra) # 80002f70 <iunlockput>
  end_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	ae6080e7          	jalr	-1306(ra) # 80003760 <end_op>
  return -1;
    80004c82:	557d                	li	a0,-1
}
    80004c84:	70ae                	ld	ra,232(sp)
    80004c86:	740e                	ld	s0,224(sp)
    80004c88:	64ee                	ld	s1,216(sp)
    80004c8a:	694e                	ld	s2,208(sp)
    80004c8c:	69ae                	ld	s3,200(sp)
    80004c8e:	616d                	addi	sp,sp,240
    80004c90:	8082                	ret

0000000080004c92 <sys_open>:

uint64
sys_open(void)
{
    80004c92:	7131                	addi	sp,sp,-192
    80004c94:	fd06                	sd	ra,184(sp)
    80004c96:	f922                	sd	s0,176(sp)
    80004c98:	f526                	sd	s1,168(sp)
    80004c9a:	f14a                	sd	s2,160(sp)
    80004c9c:	ed4e                	sd	s3,152(sp)
    80004c9e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ca0:	08000613          	li	a2,128
    80004ca4:	f5040593          	addi	a1,s0,-176
    80004ca8:	4501                	li	a0,0
    80004caa:	ffffd097          	auipc	ra,0xffffd
    80004cae:	424080e7          	jalr	1060(ra) # 800020ce <argstr>
    return -1;
    80004cb2:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cb4:	0c054163          	bltz	a0,80004d76 <sys_open+0xe4>
    80004cb8:	f4c40593          	addi	a1,s0,-180
    80004cbc:	4505                	li	a0,1
    80004cbe:	ffffd097          	auipc	ra,0xffffd
    80004cc2:	3cc080e7          	jalr	972(ra) # 8000208a <argint>
    80004cc6:	0a054863          	bltz	a0,80004d76 <sys_open+0xe4>

  begin_op();
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	a16080e7          	jalr	-1514(ra) # 800036e0 <begin_op>

  if(omode & O_CREATE){
    80004cd2:	f4c42783          	lw	a5,-180(s0)
    80004cd6:	2007f793          	andi	a5,a5,512
    80004cda:	cbdd                	beqz	a5,80004d90 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cdc:	4681                	li	a3,0
    80004cde:	4601                	li	a2,0
    80004ce0:	4589                	li	a1,2
    80004ce2:	f5040513          	addi	a0,s0,-176
    80004ce6:	00000097          	auipc	ra,0x0
    80004cea:	972080e7          	jalr	-1678(ra) # 80004658 <create>
    80004cee:	892a                	mv	s2,a0
    if(ip == 0){
    80004cf0:	c959                	beqz	a0,80004d86 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cf2:	04491703          	lh	a4,68(s2)
    80004cf6:	478d                	li	a5,3
    80004cf8:	00f71763          	bne	a4,a5,80004d06 <sys_open+0x74>
    80004cfc:	04695703          	lhu	a4,70(s2)
    80004d00:	47a5                	li	a5,9
    80004d02:	0ce7ec63          	bltu	a5,a4,80004dda <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d06:	fffff097          	auipc	ra,0xfffff
    80004d0a:	dea080e7          	jalr	-534(ra) # 80003af0 <filealloc>
    80004d0e:	89aa                	mv	s3,a0
    80004d10:	10050263          	beqz	a0,80004e14 <sys_open+0x182>
    80004d14:	00000097          	auipc	ra,0x0
    80004d18:	902080e7          	jalr	-1790(ra) # 80004616 <fdalloc>
    80004d1c:	84aa                	mv	s1,a0
    80004d1e:	0e054663          	bltz	a0,80004e0a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d22:	04491703          	lh	a4,68(s2)
    80004d26:	478d                	li	a5,3
    80004d28:	0cf70463          	beq	a4,a5,80004df0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d2c:	4789                	li	a5,2
    80004d2e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d32:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d36:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d3a:	f4c42783          	lw	a5,-180(s0)
    80004d3e:	0017c713          	xori	a4,a5,1
    80004d42:	8b05                	andi	a4,a4,1
    80004d44:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d48:	0037f713          	andi	a4,a5,3
    80004d4c:	00e03733          	snez	a4,a4
    80004d50:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d54:	4007f793          	andi	a5,a5,1024
    80004d58:	c791                	beqz	a5,80004d64 <sys_open+0xd2>
    80004d5a:	04491703          	lh	a4,68(s2)
    80004d5e:	4789                	li	a5,2
    80004d60:	08f70f63          	beq	a4,a5,80004dfe <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d64:	854a                	mv	a0,s2
    80004d66:	ffffe097          	auipc	ra,0xffffe
    80004d6a:	06a080e7          	jalr	106(ra) # 80002dd0 <iunlock>
  end_op();
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	9f2080e7          	jalr	-1550(ra) # 80003760 <end_op>

  return fd;
}
    80004d76:	8526                	mv	a0,s1
    80004d78:	70ea                	ld	ra,184(sp)
    80004d7a:	744a                	ld	s0,176(sp)
    80004d7c:	74aa                	ld	s1,168(sp)
    80004d7e:	790a                	ld	s2,160(sp)
    80004d80:	69ea                	ld	s3,152(sp)
    80004d82:	6129                	addi	sp,sp,192
    80004d84:	8082                	ret
      end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	9da080e7          	jalr	-1574(ra) # 80003760 <end_op>
      return -1;
    80004d8e:	b7e5                	j	80004d76 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d90:	f5040513          	addi	a0,s0,-176
    80004d94:	ffffe097          	auipc	ra,0xffffe
    80004d98:	730080e7          	jalr	1840(ra) # 800034c4 <namei>
    80004d9c:	892a                	mv	s2,a0
    80004d9e:	c905                	beqz	a0,80004dce <sys_open+0x13c>
    ilock(ip);
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	f6e080e7          	jalr	-146(ra) # 80002d0e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004da8:	04491703          	lh	a4,68(s2)
    80004dac:	4785                	li	a5,1
    80004dae:	f4f712e3          	bne	a4,a5,80004cf2 <sys_open+0x60>
    80004db2:	f4c42783          	lw	a5,-180(s0)
    80004db6:	dba1                	beqz	a5,80004d06 <sys_open+0x74>
      iunlockput(ip);
    80004db8:	854a                	mv	a0,s2
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	1b6080e7          	jalr	438(ra) # 80002f70 <iunlockput>
      end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	99e080e7          	jalr	-1634(ra) # 80003760 <end_op>
      return -1;
    80004dca:	54fd                	li	s1,-1
    80004dcc:	b76d                	j	80004d76 <sys_open+0xe4>
      end_op();
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	992080e7          	jalr	-1646(ra) # 80003760 <end_op>
      return -1;
    80004dd6:	54fd                	li	s1,-1
    80004dd8:	bf79                	j	80004d76 <sys_open+0xe4>
    iunlockput(ip);
    80004dda:	854a                	mv	a0,s2
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	194080e7          	jalr	404(ra) # 80002f70 <iunlockput>
    end_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	97c080e7          	jalr	-1668(ra) # 80003760 <end_op>
    return -1;
    80004dec:	54fd                	li	s1,-1
    80004dee:	b761                	j	80004d76 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004df0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004df4:	04691783          	lh	a5,70(s2)
    80004df8:	02f99223          	sh	a5,36(s3)
    80004dfc:	bf2d                	j	80004d36 <sys_open+0xa4>
    itrunc(ip);
    80004dfe:	854a                	mv	a0,s2
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	01c080e7          	jalr	28(ra) # 80002e1c <itrunc>
    80004e08:	bfb1                	j	80004d64 <sys_open+0xd2>
      fileclose(f);
    80004e0a:	854e                	mv	a0,s3
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	da0080e7          	jalr	-608(ra) # 80003bac <fileclose>
    iunlockput(ip);
    80004e14:	854a                	mv	a0,s2
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	15a080e7          	jalr	346(ra) # 80002f70 <iunlockput>
    end_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	942080e7          	jalr	-1726(ra) # 80003760 <end_op>
    return -1;
    80004e26:	54fd                	li	s1,-1
    80004e28:	b7b9                	j	80004d76 <sys_open+0xe4>

0000000080004e2a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e2a:	7175                	addi	sp,sp,-144
    80004e2c:	e506                	sd	ra,136(sp)
    80004e2e:	e122                	sd	s0,128(sp)
    80004e30:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	8ae080e7          	jalr	-1874(ra) # 800036e0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e3a:	08000613          	li	a2,128
    80004e3e:	f7040593          	addi	a1,s0,-144
    80004e42:	4501                	li	a0,0
    80004e44:	ffffd097          	auipc	ra,0xffffd
    80004e48:	28a080e7          	jalr	650(ra) # 800020ce <argstr>
    80004e4c:	02054963          	bltz	a0,80004e7e <sys_mkdir+0x54>
    80004e50:	4681                	li	a3,0
    80004e52:	4601                	li	a2,0
    80004e54:	4585                	li	a1,1
    80004e56:	f7040513          	addi	a0,s0,-144
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	7fe080e7          	jalr	2046(ra) # 80004658 <create>
    80004e62:	cd11                	beqz	a0,80004e7e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	10c080e7          	jalr	268(ra) # 80002f70 <iunlockput>
  end_op();
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	8f4080e7          	jalr	-1804(ra) # 80003760 <end_op>
  return 0;
    80004e74:	4501                	li	a0,0
}
    80004e76:	60aa                	ld	ra,136(sp)
    80004e78:	640a                	ld	s0,128(sp)
    80004e7a:	6149                	addi	sp,sp,144
    80004e7c:	8082                	ret
    end_op();
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	8e2080e7          	jalr	-1822(ra) # 80003760 <end_op>
    return -1;
    80004e86:	557d                	li	a0,-1
    80004e88:	b7fd                	j	80004e76 <sys_mkdir+0x4c>

0000000080004e8a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e8a:	7135                	addi	sp,sp,-160
    80004e8c:	ed06                	sd	ra,152(sp)
    80004e8e:	e922                	sd	s0,144(sp)
    80004e90:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e92:	fffff097          	auipc	ra,0xfffff
    80004e96:	84e080e7          	jalr	-1970(ra) # 800036e0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e9a:	08000613          	li	a2,128
    80004e9e:	f7040593          	addi	a1,s0,-144
    80004ea2:	4501                	li	a0,0
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	22a080e7          	jalr	554(ra) # 800020ce <argstr>
    80004eac:	04054a63          	bltz	a0,80004f00 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004eb0:	f6c40593          	addi	a1,s0,-148
    80004eb4:	4505                	li	a0,1
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	1d4080e7          	jalr	468(ra) # 8000208a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ebe:	04054163          	bltz	a0,80004f00 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004ec2:	f6840593          	addi	a1,s0,-152
    80004ec6:	4509                	li	a0,2
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	1c2080e7          	jalr	450(ra) # 8000208a <argint>
     argint(1, &major) < 0 ||
    80004ed0:	02054863          	bltz	a0,80004f00 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ed4:	f6841683          	lh	a3,-152(s0)
    80004ed8:	f6c41603          	lh	a2,-148(s0)
    80004edc:	458d                	li	a1,3
    80004ede:	f7040513          	addi	a0,s0,-144
    80004ee2:	fffff097          	auipc	ra,0xfffff
    80004ee6:	776080e7          	jalr	1910(ra) # 80004658 <create>
     argint(2, &minor) < 0 ||
    80004eea:	c919                	beqz	a0,80004f00 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	084080e7          	jalr	132(ra) # 80002f70 <iunlockput>
  end_op();
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	86c080e7          	jalr	-1940(ra) # 80003760 <end_op>
  return 0;
    80004efc:	4501                	li	a0,0
    80004efe:	a031                	j	80004f0a <sys_mknod+0x80>
    end_op();
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	860080e7          	jalr	-1952(ra) # 80003760 <end_op>
    return -1;
    80004f08:	557d                	li	a0,-1
}
    80004f0a:	60ea                	ld	ra,152(sp)
    80004f0c:	644a                	ld	s0,144(sp)
    80004f0e:	610d                	addi	sp,sp,160
    80004f10:	8082                	ret

0000000080004f12 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f12:	7135                	addi	sp,sp,-160
    80004f14:	ed06                	sd	ra,152(sp)
    80004f16:	e922                	sd	s0,144(sp)
    80004f18:	e526                	sd	s1,136(sp)
    80004f1a:	e14a                	sd	s2,128(sp)
    80004f1c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f1e:	ffffc097          	auipc	ra,0xffffc
    80004f22:	03a080e7          	jalr	58(ra) # 80000f58 <myproc>
    80004f26:	892a                	mv	s2,a0
  
  begin_op();
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	7b8080e7          	jalr	1976(ra) # 800036e0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f30:	08000613          	li	a2,128
    80004f34:	f6040593          	addi	a1,s0,-160
    80004f38:	4501                	li	a0,0
    80004f3a:	ffffd097          	auipc	ra,0xffffd
    80004f3e:	194080e7          	jalr	404(ra) # 800020ce <argstr>
    80004f42:	04054b63          	bltz	a0,80004f98 <sys_chdir+0x86>
    80004f46:	f6040513          	addi	a0,s0,-160
    80004f4a:	ffffe097          	auipc	ra,0xffffe
    80004f4e:	57a080e7          	jalr	1402(ra) # 800034c4 <namei>
    80004f52:	84aa                	mv	s1,a0
    80004f54:	c131                	beqz	a0,80004f98 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f56:	ffffe097          	auipc	ra,0xffffe
    80004f5a:	db8080e7          	jalr	-584(ra) # 80002d0e <ilock>
  if(ip->type != T_DIR){
    80004f5e:	04449703          	lh	a4,68(s1)
    80004f62:	4785                	li	a5,1
    80004f64:	04f71063          	bne	a4,a5,80004fa4 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f68:	8526                	mv	a0,s1
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	e66080e7          	jalr	-410(ra) # 80002dd0 <iunlock>
  iput(p->cwd);
    80004f72:	15093503          	ld	a0,336(s2)
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	f52080e7          	jalr	-174(ra) # 80002ec8 <iput>
  end_op();
    80004f7e:	ffffe097          	auipc	ra,0xffffe
    80004f82:	7e2080e7          	jalr	2018(ra) # 80003760 <end_op>
  p->cwd = ip;
    80004f86:	14993823          	sd	s1,336(s2)
  return 0;
    80004f8a:	4501                	li	a0,0
}
    80004f8c:	60ea                	ld	ra,152(sp)
    80004f8e:	644a                	ld	s0,144(sp)
    80004f90:	64aa                	ld	s1,136(sp)
    80004f92:	690a                	ld	s2,128(sp)
    80004f94:	610d                	addi	sp,sp,160
    80004f96:	8082                	ret
    end_op();
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	7c8080e7          	jalr	1992(ra) # 80003760 <end_op>
    return -1;
    80004fa0:	557d                	li	a0,-1
    80004fa2:	b7ed                	j	80004f8c <sys_chdir+0x7a>
    iunlockput(ip);
    80004fa4:	8526                	mv	a0,s1
    80004fa6:	ffffe097          	auipc	ra,0xffffe
    80004faa:	fca080e7          	jalr	-54(ra) # 80002f70 <iunlockput>
    end_op();
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	7b2080e7          	jalr	1970(ra) # 80003760 <end_op>
    return -1;
    80004fb6:	557d                	li	a0,-1
    80004fb8:	bfd1                	j	80004f8c <sys_chdir+0x7a>

0000000080004fba <sys_exec>:

uint64
sys_exec(void)
{
    80004fba:	7145                	addi	sp,sp,-464
    80004fbc:	e786                	sd	ra,456(sp)
    80004fbe:	e3a2                	sd	s0,448(sp)
    80004fc0:	ff26                	sd	s1,440(sp)
    80004fc2:	fb4a                	sd	s2,432(sp)
    80004fc4:	f74e                	sd	s3,424(sp)
    80004fc6:	f352                	sd	s4,416(sp)
    80004fc8:	ef56                	sd	s5,408(sp)
    80004fca:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fcc:	08000613          	li	a2,128
    80004fd0:	f4040593          	addi	a1,s0,-192
    80004fd4:	4501                	li	a0,0
    80004fd6:	ffffd097          	auipc	ra,0xffffd
    80004fda:	0f8080e7          	jalr	248(ra) # 800020ce <argstr>
    return -1;
    80004fde:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fe0:	0c054a63          	bltz	a0,800050b4 <sys_exec+0xfa>
    80004fe4:	e3840593          	addi	a1,s0,-456
    80004fe8:	4505                	li	a0,1
    80004fea:	ffffd097          	auipc	ra,0xffffd
    80004fee:	0c2080e7          	jalr	194(ra) # 800020ac <argaddr>
    80004ff2:	0c054163          	bltz	a0,800050b4 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ff6:	10000613          	li	a2,256
    80004ffa:	4581                	li	a1,0
    80004ffc:	e4040513          	addi	a0,s0,-448
    80005000:	ffffb097          	auipc	ra,0xffffb
    80005004:	178080e7          	jalr	376(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005008:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000500c:	89a6                	mv	s3,s1
    8000500e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005010:	02000a13          	li	s4,32
    80005014:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005018:	00391513          	slli	a0,s2,0x3
    8000501c:	e3040593          	addi	a1,s0,-464
    80005020:	e3843783          	ld	a5,-456(s0)
    80005024:	953e                	add	a0,a0,a5
    80005026:	ffffd097          	auipc	ra,0xffffd
    8000502a:	fca080e7          	jalr	-54(ra) # 80001ff0 <fetchaddr>
    8000502e:	02054a63          	bltz	a0,80005062 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005032:	e3043783          	ld	a5,-464(s0)
    80005036:	c3b9                	beqz	a5,8000507c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005038:	ffffb097          	auipc	ra,0xffffb
    8000503c:	0e0080e7          	jalr	224(ra) # 80000118 <kalloc>
    80005040:	85aa                	mv	a1,a0
    80005042:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005046:	cd11                	beqz	a0,80005062 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005048:	6605                	lui	a2,0x1
    8000504a:	e3043503          	ld	a0,-464(s0)
    8000504e:	ffffd097          	auipc	ra,0xffffd
    80005052:	ff4080e7          	jalr	-12(ra) # 80002042 <fetchstr>
    80005056:	00054663          	bltz	a0,80005062 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000505a:	0905                	addi	s2,s2,1
    8000505c:	09a1                	addi	s3,s3,8
    8000505e:	fb491be3          	bne	s2,s4,80005014 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005062:	10048913          	addi	s2,s1,256
    80005066:	6088                	ld	a0,0(s1)
    80005068:	c529                	beqz	a0,800050b2 <sys_exec+0xf8>
    kfree(argv[i]);
    8000506a:	ffffb097          	auipc	ra,0xffffb
    8000506e:	fb2080e7          	jalr	-78(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005072:	04a1                	addi	s1,s1,8
    80005074:	ff2499e3          	bne	s1,s2,80005066 <sys_exec+0xac>
  return -1;
    80005078:	597d                	li	s2,-1
    8000507a:	a82d                	j	800050b4 <sys_exec+0xfa>
      argv[i] = 0;
    8000507c:	0a8e                	slli	s5,s5,0x3
    8000507e:	fc040793          	addi	a5,s0,-64
    80005082:	9abe                	add	s5,s5,a5
    80005084:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005088:	e4040593          	addi	a1,s0,-448
    8000508c:	f4040513          	addi	a0,s0,-192
    80005090:	fffff097          	auipc	ra,0xfffff
    80005094:	17c080e7          	jalr	380(ra) # 8000420c <exec>
    80005098:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000509a:	10048993          	addi	s3,s1,256
    8000509e:	6088                	ld	a0,0(s1)
    800050a0:	c911                	beqz	a0,800050b4 <sys_exec+0xfa>
    kfree(argv[i]);
    800050a2:	ffffb097          	auipc	ra,0xffffb
    800050a6:	f7a080e7          	jalr	-134(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050aa:	04a1                	addi	s1,s1,8
    800050ac:	ff3499e3          	bne	s1,s3,8000509e <sys_exec+0xe4>
    800050b0:	a011                	j	800050b4 <sys_exec+0xfa>
  return -1;
    800050b2:	597d                	li	s2,-1
}
    800050b4:	854a                	mv	a0,s2
    800050b6:	60be                	ld	ra,456(sp)
    800050b8:	641e                	ld	s0,448(sp)
    800050ba:	74fa                	ld	s1,440(sp)
    800050bc:	795a                	ld	s2,432(sp)
    800050be:	79ba                	ld	s3,424(sp)
    800050c0:	7a1a                	ld	s4,416(sp)
    800050c2:	6afa                	ld	s5,408(sp)
    800050c4:	6179                	addi	sp,sp,464
    800050c6:	8082                	ret

00000000800050c8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050c8:	7139                	addi	sp,sp,-64
    800050ca:	fc06                	sd	ra,56(sp)
    800050cc:	f822                	sd	s0,48(sp)
    800050ce:	f426                	sd	s1,40(sp)
    800050d0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050d2:	ffffc097          	auipc	ra,0xffffc
    800050d6:	e86080e7          	jalr	-378(ra) # 80000f58 <myproc>
    800050da:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050dc:	fd840593          	addi	a1,s0,-40
    800050e0:	4501                	li	a0,0
    800050e2:	ffffd097          	auipc	ra,0xffffd
    800050e6:	fca080e7          	jalr	-54(ra) # 800020ac <argaddr>
    return -1;
    800050ea:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050ec:	0e054063          	bltz	a0,800051cc <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050f0:	fc840593          	addi	a1,s0,-56
    800050f4:	fd040513          	addi	a0,s0,-48
    800050f8:	fffff097          	auipc	ra,0xfffff
    800050fc:	de4080e7          	jalr	-540(ra) # 80003edc <pipealloc>
    return -1;
    80005100:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005102:	0c054563          	bltz	a0,800051cc <sys_pipe+0x104>
  fd0 = -1;
    80005106:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000510a:	fd043503          	ld	a0,-48(s0)
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	508080e7          	jalr	1288(ra) # 80004616 <fdalloc>
    80005116:	fca42223          	sw	a0,-60(s0)
    8000511a:	08054c63          	bltz	a0,800051b2 <sys_pipe+0xea>
    8000511e:	fc843503          	ld	a0,-56(s0)
    80005122:	fffff097          	auipc	ra,0xfffff
    80005126:	4f4080e7          	jalr	1268(ra) # 80004616 <fdalloc>
    8000512a:	fca42023          	sw	a0,-64(s0)
    8000512e:	06054863          	bltz	a0,8000519e <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005132:	4691                	li	a3,4
    80005134:	fc440613          	addi	a2,s0,-60
    80005138:	fd843583          	ld	a1,-40(s0)
    8000513c:	68a8                	ld	a0,80(s1)
    8000513e:	ffffc097          	auipc	ra,0xffffc
    80005142:	9cc080e7          	jalr	-1588(ra) # 80000b0a <copyout>
    80005146:	02054063          	bltz	a0,80005166 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000514a:	4691                	li	a3,4
    8000514c:	fc040613          	addi	a2,s0,-64
    80005150:	fd843583          	ld	a1,-40(s0)
    80005154:	0591                	addi	a1,a1,4
    80005156:	68a8                	ld	a0,80(s1)
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	9b2080e7          	jalr	-1614(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005160:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005162:	06055563          	bgez	a0,800051cc <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005166:	fc442783          	lw	a5,-60(s0)
    8000516a:	07e9                	addi	a5,a5,26
    8000516c:	078e                	slli	a5,a5,0x3
    8000516e:	97a6                	add	a5,a5,s1
    80005170:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005174:	fc042503          	lw	a0,-64(s0)
    80005178:	0569                	addi	a0,a0,26
    8000517a:	050e                	slli	a0,a0,0x3
    8000517c:	9526                	add	a0,a0,s1
    8000517e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005182:	fd043503          	ld	a0,-48(s0)
    80005186:	fffff097          	auipc	ra,0xfffff
    8000518a:	a26080e7          	jalr	-1498(ra) # 80003bac <fileclose>
    fileclose(wf);
    8000518e:	fc843503          	ld	a0,-56(s0)
    80005192:	fffff097          	auipc	ra,0xfffff
    80005196:	a1a080e7          	jalr	-1510(ra) # 80003bac <fileclose>
    return -1;
    8000519a:	57fd                	li	a5,-1
    8000519c:	a805                	j	800051cc <sys_pipe+0x104>
    if(fd0 >= 0)
    8000519e:	fc442783          	lw	a5,-60(s0)
    800051a2:	0007c863          	bltz	a5,800051b2 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051a6:	01a78513          	addi	a0,a5,26
    800051aa:	050e                	slli	a0,a0,0x3
    800051ac:	9526                	add	a0,a0,s1
    800051ae:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051b2:	fd043503          	ld	a0,-48(s0)
    800051b6:	fffff097          	auipc	ra,0xfffff
    800051ba:	9f6080e7          	jalr	-1546(ra) # 80003bac <fileclose>
    fileclose(wf);
    800051be:	fc843503          	ld	a0,-56(s0)
    800051c2:	fffff097          	auipc	ra,0xfffff
    800051c6:	9ea080e7          	jalr	-1558(ra) # 80003bac <fileclose>
    return -1;
    800051ca:	57fd                	li	a5,-1
}
    800051cc:	853e                	mv	a0,a5
    800051ce:	70e2                	ld	ra,56(sp)
    800051d0:	7442                	ld	s0,48(sp)
    800051d2:	74a2                	ld	s1,40(sp)
    800051d4:	6121                	addi	sp,sp,64
    800051d6:	8082                	ret
	...

00000000800051e0 <kernelvec>:
    800051e0:	7111                	addi	sp,sp,-256
    800051e2:	e006                	sd	ra,0(sp)
    800051e4:	e40a                	sd	sp,8(sp)
    800051e6:	e80e                	sd	gp,16(sp)
    800051e8:	ec12                	sd	tp,24(sp)
    800051ea:	f016                	sd	t0,32(sp)
    800051ec:	f41a                	sd	t1,40(sp)
    800051ee:	f81e                	sd	t2,48(sp)
    800051f0:	fc22                	sd	s0,56(sp)
    800051f2:	e0a6                	sd	s1,64(sp)
    800051f4:	e4aa                	sd	a0,72(sp)
    800051f6:	e8ae                	sd	a1,80(sp)
    800051f8:	ecb2                	sd	a2,88(sp)
    800051fa:	f0b6                	sd	a3,96(sp)
    800051fc:	f4ba                	sd	a4,104(sp)
    800051fe:	f8be                	sd	a5,112(sp)
    80005200:	fcc2                	sd	a6,120(sp)
    80005202:	e146                	sd	a7,128(sp)
    80005204:	e54a                	sd	s2,136(sp)
    80005206:	e94e                	sd	s3,144(sp)
    80005208:	ed52                	sd	s4,152(sp)
    8000520a:	f156                	sd	s5,160(sp)
    8000520c:	f55a                	sd	s6,168(sp)
    8000520e:	f95e                	sd	s7,176(sp)
    80005210:	fd62                	sd	s8,184(sp)
    80005212:	e1e6                	sd	s9,192(sp)
    80005214:	e5ea                	sd	s10,200(sp)
    80005216:	e9ee                	sd	s11,208(sp)
    80005218:	edf2                	sd	t3,216(sp)
    8000521a:	f1f6                	sd	t4,224(sp)
    8000521c:	f5fa                	sd	t5,232(sp)
    8000521e:	f9fe                	sd	t6,240(sp)
    80005220:	c9dfc0ef          	jal	ra,80001ebc <kerneltrap>
    80005224:	6082                	ld	ra,0(sp)
    80005226:	6122                	ld	sp,8(sp)
    80005228:	61c2                	ld	gp,16(sp)
    8000522a:	7282                	ld	t0,32(sp)
    8000522c:	7322                	ld	t1,40(sp)
    8000522e:	73c2                	ld	t2,48(sp)
    80005230:	7462                	ld	s0,56(sp)
    80005232:	6486                	ld	s1,64(sp)
    80005234:	6526                	ld	a0,72(sp)
    80005236:	65c6                	ld	a1,80(sp)
    80005238:	6666                	ld	a2,88(sp)
    8000523a:	7686                	ld	a3,96(sp)
    8000523c:	7726                	ld	a4,104(sp)
    8000523e:	77c6                	ld	a5,112(sp)
    80005240:	7866                	ld	a6,120(sp)
    80005242:	688a                	ld	a7,128(sp)
    80005244:	692a                	ld	s2,136(sp)
    80005246:	69ca                	ld	s3,144(sp)
    80005248:	6a6a                	ld	s4,152(sp)
    8000524a:	7a8a                	ld	s5,160(sp)
    8000524c:	7b2a                	ld	s6,168(sp)
    8000524e:	7bca                	ld	s7,176(sp)
    80005250:	7c6a                	ld	s8,184(sp)
    80005252:	6c8e                	ld	s9,192(sp)
    80005254:	6d2e                	ld	s10,200(sp)
    80005256:	6dce                	ld	s11,208(sp)
    80005258:	6e6e                	ld	t3,216(sp)
    8000525a:	7e8e                	ld	t4,224(sp)
    8000525c:	7f2e                	ld	t5,232(sp)
    8000525e:	7fce                	ld	t6,240(sp)
    80005260:	6111                	addi	sp,sp,256
    80005262:	10200073          	sret
    80005266:	00000013          	nop
    8000526a:	00000013          	nop
    8000526e:	0001                	nop

0000000080005270 <timervec>:
    80005270:	34051573          	csrrw	a0,mscratch,a0
    80005274:	e10c                	sd	a1,0(a0)
    80005276:	e510                	sd	a2,8(a0)
    80005278:	e914                	sd	a3,16(a0)
    8000527a:	6d0c                	ld	a1,24(a0)
    8000527c:	7110                	ld	a2,32(a0)
    8000527e:	6194                	ld	a3,0(a1)
    80005280:	96b2                	add	a3,a3,a2
    80005282:	e194                	sd	a3,0(a1)
    80005284:	4589                	li	a1,2
    80005286:	14459073          	csrw	sip,a1
    8000528a:	6914                	ld	a3,16(a0)
    8000528c:	6510                	ld	a2,8(a0)
    8000528e:	610c                	ld	a1,0(a0)
    80005290:	34051573          	csrrw	a0,mscratch,a0
    80005294:	30200073          	mret
	...

000000008000529a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000529a:	1141                	addi	sp,sp,-16
    8000529c:	e422                	sd	s0,8(sp)
    8000529e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052a0:	0c0007b7          	lui	a5,0xc000
    800052a4:	4705                	li	a4,1
    800052a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052a8:	c3d8                	sw	a4,4(a5)
}
    800052aa:	6422                	ld	s0,8(sp)
    800052ac:	0141                	addi	sp,sp,16
    800052ae:	8082                	ret

00000000800052b0 <plicinithart>:

void
plicinithart(void)
{
    800052b0:	1141                	addi	sp,sp,-16
    800052b2:	e406                	sd	ra,8(sp)
    800052b4:	e022                	sd	s0,0(sp)
    800052b6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052b8:	ffffc097          	auipc	ra,0xffffc
    800052bc:	c74080e7          	jalr	-908(ra) # 80000f2c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052c0:	0085171b          	slliw	a4,a0,0x8
    800052c4:	0c0027b7          	lui	a5,0xc002
    800052c8:	97ba                	add	a5,a5,a4
    800052ca:	40200713          	li	a4,1026
    800052ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052d2:	00d5151b          	slliw	a0,a0,0xd
    800052d6:	0c2017b7          	lui	a5,0xc201
    800052da:	953e                	add	a0,a0,a5
    800052dc:	00052023          	sw	zero,0(a0)
}
    800052e0:	60a2                	ld	ra,8(sp)
    800052e2:	6402                	ld	s0,0(sp)
    800052e4:	0141                	addi	sp,sp,16
    800052e6:	8082                	ret

00000000800052e8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052e8:	1141                	addi	sp,sp,-16
    800052ea:	e406                	sd	ra,8(sp)
    800052ec:	e022                	sd	s0,0(sp)
    800052ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052f0:	ffffc097          	auipc	ra,0xffffc
    800052f4:	c3c080e7          	jalr	-964(ra) # 80000f2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052f8:	00d5179b          	slliw	a5,a0,0xd
    800052fc:	0c201537          	lui	a0,0xc201
    80005300:	953e                	add	a0,a0,a5
  return irq;
}
    80005302:	4148                	lw	a0,4(a0)
    80005304:	60a2                	ld	ra,8(sp)
    80005306:	6402                	ld	s0,0(sp)
    80005308:	0141                	addi	sp,sp,16
    8000530a:	8082                	ret

000000008000530c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000530c:	1101                	addi	sp,sp,-32
    8000530e:	ec06                	sd	ra,24(sp)
    80005310:	e822                	sd	s0,16(sp)
    80005312:	e426                	sd	s1,8(sp)
    80005314:	1000                	addi	s0,sp,32
    80005316:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	c14080e7          	jalr	-1004(ra) # 80000f2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005320:	00d5151b          	slliw	a0,a0,0xd
    80005324:	0c2017b7          	lui	a5,0xc201
    80005328:	97aa                	add	a5,a5,a0
    8000532a:	c3c4                	sw	s1,4(a5)
}
    8000532c:	60e2                	ld	ra,24(sp)
    8000532e:	6442                	ld	s0,16(sp)
    80005330:	64a2                	ld	s1,8(sp)
    80005332:	6105                	addi	sp,sp,32
    80005334:	8082                	ret

0000000080005336 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005336:	1141                	addi	sp,sp,-16
    80005338:	e406                	sd	ra,8(sp)
    8000533a:	e022                	sd	s0,0(sp)
    8000533c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000533e:	479d                	li	a5,7
    80005340:	06a7c963          	blt	a5,a0,800053b2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005344:	00016797          	auipc	a5,0x16
    80005348:	cbc78793          	addi	a5,a5,-836 # 8001b000 <disk>
    8000534c:	00a78733          	add	a4,a5,a0
    80005350:	6789                	lui	a5,0x2
    80005352:	97ba                	add	a5,a5,a4
    80005354:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005358:	e7ad                	bnez	a5,800053c2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000535a:	00451793          	slli	a5,a0,0x4
    8000535e:	00018717          	auipc	a4,0x18
    80005362:	ca270713          	addi	a4,a4,-862 # 8001d000 <disk+0x2000>
    80005366:	6314                	ld	a3,0(a4)
    80005368:	96be                	add	a3,a3,a5
    8000536a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000536e:	6314                	ld	a3,0(a4)
    80005370:	96be                	add	a3,a3,a5
    80005372:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005376:	6314                	ld	a3,0(a4)
    80005378:	96be                	add	a3,a3,a5
    8000537a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000537e:	6318                	ld	a4,0(a4)
    80005380:	97ba                	add	a5,a5,a4
    80005382:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005386:	00016797          	auipc	a5,0x16
    8000538a:	c7a78793          	addi	a5,a5,-902 # 8001b000 <disk>
    8000538e:	97aa                	add	a5,a5,a0
    80005390:	6509                	lui	a0,0x2
    80005392:	953e                	add	a0,a0,a5
    80005394:	4785                	li	a5,1
    80005396:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000539a:	00018517          	auipc	a0,0x18
    8000539e:	c7e50513          	addi	a0,a0,-898 # 8001d018 <disk+0x2018>
    800053a2:	ffffc097          	auipc	ra,0xffffc
    800053a6:	484080e7          	jalr	1156(ra) # 80001826 <wakeup>
}
    800053aa:	60a2                	ld	ra,8(sp)
    800053ac:	6402                	ld	s0,0(sp)
    800053ae:	0141                	addi	sp,sp,16
    800053b0:	8082                	ret
    panic("free_desc 1");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	3ae50513          	addi	a0,a0,942 # 80008760 <syscalls+0x368>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	a1e080e7          	jalr	-1506(ra) # 80005dd8 <panic>
    panic("free_desc 2");
    800053c2:	00003517          	auipc	a0,0x3
    800053c6:	3ae50513          	addi	a0,a0,942 # 80008770 <syscalls+0x378>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	a0e080e7          	jalr	-1522(ra) # 80005dd8 <panic>

00000000800053d2 <virtio_disk_init>:
{
    800053d2:	1101                	addi	sp,sp,-32
    800053d4:	ec06                	sd	ra,24(sp)
    800053d6:	e822                	sd	s0,16(sp)
    800053d8:	e426                	sd	s1,8(sp)
    800053da:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053dc:	00003597          	auipc	a1,0x3
    800053e0:	3a458593          	addi	a1,a1,932 # 80008780 <syscalls+0x388>
    800053e4:	00018517          	auipc	a0,0x18
    800053e8:	d4450513          	addi	a0,a0,-700 # 8001d128 <disk+0x2128>
    800053ec:	00001097          	auipc	ra,0x1
    800053f0:	ea6080e7          	jalr	-346(ra) # 80006292 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053f4:	100017b7          	lui	a5,0x10001
    800053f8:	4398                	lw	a4,0(a5)
    800053fa:	2701                	sext.w	a4,a4
    800053fc:	747277b7          	lui	a5,0x74727
    80005400:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005404:	0ef71163          	bne	a4,a5,800054e6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005408:	100017b7          	lui	a5,0x10001
    8000540c:	43dc                	lw	a5,4(a5)
    8000540e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005410:	4705                	li	a4,1
    80005412:	0ce79a63          	bne	a5,a4,800054e6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005416:	100017b7          	lui	a5,0x10001
    8000541a:	479c                	lw	a5,8(a5)
    8000541c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000541e:	4709                	li	a4,2
    80005420:	0ce79363          	bne	a5,a4,800054e6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005424:	100017b7          	lui	a5,0x10001
    80005428:	47d8                	lw	a4,12(a5)
    8000542a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000542c:	554d47b7          	lui	a5,0x554d4
    80005430:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005434:	0af71963          	bne	a4,a5,800054e6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005438:	100017b7          	lui	a5,0x10001
    8000543c:	4705                	li	a4,1
    8000543e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005440:	470d                	li	a4,3
    80005442:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005444:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005446:	c7ffe737          	lui	a4,0xc7ffe
    8000544a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000544e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005450:	2701                	sext.w	a4,a4
    80005452:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005454:	472d                	li	a4,11
    80005456:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005458:	473d                	li	a4,15
    8000545a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000545c:	6705                	lui	a4,0x1
    8000545e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005460:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005464:	5bdc                	lw	a5,52(a5)
    80005466:	2781                	sext.w	a5,a5
  if(max == 0)
    80005468:	c7d9                	beqz	a5,800054f6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000546a:	471d                	li	a4,7
    8000546c:	08f77d63          	bgeu	a4,a5,80005506 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005470:	100014b7          	lui	s1,0x10001
    80005474:	47a1                	li	a5,8
    80005476:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005478:	6609                	lui	a2,0x2
    8000547a:	4581                	li	a1,0
    8000547c:	00016517          	auipc	a0,0x16
    80005480:	b8450513          	addi	a0,a0,-1148 # 8001b000 <disk>
    80005484:	ffffb097          	auipc	ra,0xffffb
    80005488:	cf4080e7          	jalr	-780(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000548c:	00016717          	auipc	a4,0x16
    80005490:	b7470713          	addi	a4,a4,-1164 # 8001b000 <disk>
    80005494:	00c75793          	srli	a5,a4,0xc
    80005498:	2781                	sext.w	a5,a5
    8000549a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000549c:	00018797          	auipc	a5,0x18
    800054a0:	b6478793          	addi	a5,a5,-1180 # 8001d000 <disk+0x2000>
    800054a4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054a6:	00016717          	auipc	a4,0x16
    800054aa:	bda70713          	addi	a4,a4,-1062 # 8001b080 <disk+0x80>
    800054ae:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054b0:	00017717          	auipc	a4,0x17
    800054b4:	b5070713          	addi	a4,a4,-1200 # 8001c000 <disk+0x1000>
    800054b8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054ba:	4705                	li	a4,1
    800054bc:	00e78c23          	sb	a4,24(a5)
    800054c0:	00e78ca3          	sb	a4,25(a5)
    800054c4:	00e78d23          	sb	a4,26(a5)
    800054c8:	00e78da3          	sb	a4,27(a5)
    800054cc:	00e78e23          	sb	a4,28(a5)
    800054d0:	00e78ea3          	sb	a4,29(a5)
    800054d4:	00e78f23          	sb	a4,30(a5)
    800054d8:	00e78fa3          	sb	a4,31(a5)
}
    800054dc:	60e2                	ld	ra,24(sp)
    800054de:	6442                	ld	s0,16(sp)
    800054e0:	64a2                	ld	s1,8(sp)
    800054e2:	6105                	addi	sp,sp,32
    800054e4:	8082                	ret
    panic("could not find virtio disk");
    800054e6:	00003517          	auipc	a0,0x3
    800054ea:	2aa50513          	addi	a0,a0,682 # 80008790 <syscalls+0x398>
    800054ee:	00001097          	auipc	ra,0x1
    800054f2:	8ea080e7          	jalr	-1814(ra) # 80005dd8 <panic>
    panic("virtio disk has no queue 0");
    800054f6:	00003517          	auipc	a0,0x3
    800054fa:	2ba50513          	addi	a0,a0,698 # 800087b0 <syscalls+0x3b8>
    800054fe:	00001097          	auipc	ra,0x1
    80005502:	8da080e7          	jalr	-1830(ra) # 80005dd8 <panic>
    panic("virtio disk max queue too short");
    80005506:	00003517          	auipc	a0,0x3
    8000550a:	2ca50513          	addi	a0,a0,714 # 800087d0 <syscalls+0x3d8>
    8000550e:	00001097          	auipc	ra,0x1
    80005512:	8ca080e7          	jalr	-1846(ra) # 80005dd8 <panic>

0000000080005516 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005516:	7159                	addi	sp,sp,-112
    80005518:	f486                	sd	ra,104(sp)
    8000551a:	f0a2                	sd	s0,96(sp)
    8000551c:	eca6                	sd	s1,88(sp)
    8000551e:	e8ca                	sd	s2,80(sp)
    80005520:	e4ce                	sd	s3,72(sp)
    80005522:	e0d2                	sd	s4,64(sp)
    80005524:	fc56                	sd	s5,56(sp)
    80005526:	f85a                	sd	s6,48(sp)
    80005528:	f45e                	sd	s7,40(sp)
    8000552a:	f062                	sd	s8,32(sp)
    8000552c:	ec66                	sd	s9,24(sp)
    8000552e:	e86a                	sd	s10,16(sp)
    80005530:	1880                	addi	s0,sp,112
    80005532:	892a                	mv	s2,a0
    80005534:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005536:	00c52c83          	lw	s9,12(a0)
    8000553a:	001c9c9b          	slliw	s9,s9,0x1
    8000553e:	1c82                	slli	s9,s9,0x20
    80005540:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005544:	00018517          	auipc	a0,0x18
    80005548:	be450513          	addi	a0,a0,-1052 # 8001d128 <disk+0x2128>
    8000554c:	00001097          	auipc	ra,0x1
    80005550:	dd6080e7          	jalr	-554(ra) # 80006322 <acquire>
  for(int i = 0; i < 3; i++){
    80005554:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005556:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005558:	00016b97          	auipc	s7,0x16
    8000555c:	aa8b8b93          	addi	s7,s7,-1368 # 8001b000 <disk>
    80005560:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005562:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005564:	8a4e                	mv	s4,s3
    80005566:	a051                	j	800055ea <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005568:	00fb86b3          	add	a3,s7,a5
    8000556c:	96da                	add	a3,a3,s6
    8000556e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005572:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005574:	0207c563          	bltz	a5,8000559e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005578:	2485                	addiw	s1,s1,1
    8000557a:	0711                	addi	a4,a4,4
    8000557c:	25548063          	beq	s1,s5,800057bc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005580:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005582:	00018697          	auipc	a3,0x18
    80005586:	a9668693          	addi	a3,a3,-1386 # 8001d018 <disk+0x2018>
    8000558a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000558c:	0006c583          	lbu	a1,0(a3)
    80005590:	fde1                	bnez	a1,80005568 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005592:	2785                	addiw	a5,a5,1
    80005594:	0685                	addi	a3,a3,1
    80005596:	ff879be3          	bne	a5,s8,8000558c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000559a:	57fd                	li	a5,-1
    8000559c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000559e:	02905a63          	blez	s1,800055d2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055a2:	f9042503          	lw	a0,-112(s0)
    800055a6:	00000097          	auipc	ra,0x0
    800055aa:	d90080e7          	jalr	-624(ra) # 80005336 <free_desc>
      for(int j = 0; j < i; j++)
    800055ae:	4785                	li	a5,1
    800055b0:	0297d163          	bge	a5,s1,800055d2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055b4:	f9442503          	lw	a0,-108(s0)
    800055b8:	00000097          	auipc	ra,0x0
    800055bc:	d7e080e7          	jalr	-642(ra) # 80005336 <free_desc>
      for(int j = 0; j < i; j++)
    800055c0:	4789                	li	a5,2
    800055c2:	0097d863          	bge	a5,s1,800055d2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055c6:	f9842503          	lw	a0,-104(s0)
    800055ca:	00000097          	auipc	ra,0x0
    800055ce:	d6c080e7          	jalr	-660(ra) # 80005336 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055d2:	00018597          	auipc	a1,0x18
    800055d6:	b5658593          	addi	a1,a1,-1194 # 8001d128 <disk+0x2128>
    800055da:	00018517          	auipc	a0,0x18
    800055de:	a3e50513          	addi	a0,a0,-1474 # 8001d018 <disk+0x2018>
    800055e2:	ffffc097          	auipc	ra,0xffffc
    800055e6:	0b8080e7          	jalr	184(ra) # 8000169a <sleep>
  for(int i = 0; i < 3; i++){
    800055ea:	f9040713          	addi	a4,s0,-112
    800055ee:	84ce                	mv	s1,s3
    800055f0:	bf41                	j	80005580 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055f2:	20058713          	addi	a4,a1,512
    800055f6:	00471693          	slli	a3,a4,0x4
    800055fa:	00016717          	auipc	a4,0x16
    800055fe:	a0670713          	addi	a4,a4,-1530 # 8001b000 <disk>
    80005602:	9736                	add	a4,a4,a3
    80005604:	4685                	li	a3,1
    80005606:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000560a:	20058713          	addi	a4,a1,512
    8000560e:	00471693          	slli	a3,a4,0x4
    80005612:	00016717          	auipc	a4,0x16
    80005616:	9ee70713          	addi	a4,a4,-1554 # 8001b000 <disk>
    8000561a:	9736                	add	a4,a4,a3
    8000561c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005620:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005624:	7679                	lui	a2,0xffffe
    80005626:	963e                	add	a2,a2,a5
    80005628:	00018697          	auipc	a3,0x18
    8000562c:	9d868693          	addi	a3,a3,-1576 # 8001d000 <disk+0x2000>
    80005630:	6298                	ld	a4,0(a3)
    80005632:	9732                	add	a4,a4,a2
    80005634:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005636:	6298                	ld	a4,0(a3)
    80005638:	9732                	add	a4,a4,a2
    8000563a:	4541                	li	a0,16
    8000563c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000563e:	6298                	ld	a4,0(a3)
    80005640:	9732                	add	a4,a4,a2
    80005642:	4505                	li	a0,1
    80005644:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005648:	f9442703          	lw	a4,-108(s0)
    8000564c:	6288                	ld	a0,0(a3)
    8000564e:	962a                	add	a2,a2,a0
    80005650:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005654:	0712                	slli	a4,a4,0x4
    80005656:	6290                	ld	a2,0(a3)
    80005658:	963a                	add	a2,a2,a4
    8000565a:	05890513          	addi	a0,s2,88
    8000565e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005660:	6294                	ld	a3,0(a3)
    80005662:	96ba                	add	a3,a3,a4
    80005664:	40000613          	li	a2,1024
    80005668:	c690                	sw	a2,8(a3)
  if(write)
    8000566a:	140d0063          	beqz	s10,800057aa <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000566e:	00018697          	auipc	a3,0x18
    80005672:	9926b683          	ld	a3,-1646(a3) # 8001d000 <disk+0x2000>
    80005676:	96ba                	add	a3,a3,a4
    80005678:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000567c:	00016817          	auipc	a6,0x16
    80005680:	98480813          	addi	a6,a6,-1660 # 8001b000 <disk>
    80005684:	00018517          	auipc	a0,0x18
    80005688:	97c50513          	addi	a0,a0,-1668 # 8001d000 <disk+0x2000>
    8000568c:	6114                	ld	a3,0(a0)
    8000568e:	96ba                	add	a3,a3,a4
    80005690:	00c6d603          	lhu	a2,12(a3)
    80005694:	00166613          	ori	a2,a2,1
    80005698:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000569c:	f9842683          	lw	a3,-104(s0)
    800056a0:	6110                	ld	a2,0(a0)
    800056a2:	9732                	add	a4,a4,a2
    800056a4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056a8:	20058613          	addi	a2,a1,512
    800056ac:	0612                	slli	a2,a2,0x4
    800056ae:	9642                	add	a2,a2,a6
    800056b0:	577d                	li	a4,-1
    800056b2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056b6:	00469713          	slli	a4,a3,0x4
    800056ba:	6114                	ld	a3,0(a0)
    800056bc:	96ba                	add	a3,a3,a4
    800056be:	03078793          	addi	a5,a5,48
    800056c2:	97c2                	add	a5,a5,a6
    800056c4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800056c6:	611c                	ld	a5,0(a0)
    800056c8:	97ba                	add	a5,a5,a4
    800056ca:	4685                	li	a3,1
    800056cc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056ce:	611c                	ld	a5,0(a0)
    800056d0:	97ba                	add	a5,a5,a4
    800056d2:	4809                	li	a6,2
    800056d4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056d8:	611c                	ld	a5,0(a0)
    800056da:	973e                	add	a4,a4,a5
    800056dc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056e0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800056e4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056e8:	6518                	ld	a4,8(a0)
    800056ea:	00275783          	lhu	a5,2(a4)
    800056ee:	8b9d                	andi	a5,a5,7
    800056f0:	0786                	slli	a5,a5,0x1
    800056f2:	97ba                	add	a5,a5,a4
    800056f4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056f8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056fc:	6518                	ld	a4,8(a0)
    800056fe:	00275783          	lhu	a5,2(a4)
    80005702:	2785                	addiw	a5,a5,1
    80005704:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005708:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000570c:	100017b7          	lui	a5,0x10001
    80005710:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005714:	00492703          	lw	a4,4(s2)
    80005718:	4785                	li	a5,1
    8000571a:	02f71163          	bne	a4,a5,8000573c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000571e:	00018997          	auipc	s3,0x18
    80005722:	a0a98993          	addi	s3,s3,-1526 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005726:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005728:	85ce                	mv	a1,s3
    8000572a:	854a                	mv	a0,s2
    8000572c:	ffffc097          	auipc	ra,0xffffc
    80005730:	f6e080e7          	jalr	-146(ra) # 8000169a <sleep>
  while(b->disk == 1) {
    80005734:	00492783          	lw	a5,4(s2)
    80005738:	fe9788e3          	beq	a5,s1,80005728 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000573c:	f9042903          	lw	s2,-112(s0)
    80005740:	20090793          	addi	a5,s2,512
    80005744:	00479713          	slli	a4,a5,0x4
    80005748:	00016797          	auipc	a5,0x16
    8000574c:	8b878793          	addi	a5,a5,-1864 # 8001b000 <disk>
    80005750:	97ba                	add	a5,a5,a4
    80005752:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005756:	00018997          	auipc	s3,0x18
    8000575a:	8aa98993          	addi	s3,s3,-1878 # 8001d000 <disk+0x2000>
    8000575e:	00491713          	slli	a4,s2,0x4
    80005762:	0009b783          	ld	a5,0(s3)
    80005766:	97ba                	add	a5,a5,a4
    80005768:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000576c:	854a                	mv	a0,s2
    8000576e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005772:	00000097          	auipc	ra,0x0
    80005776:	bc4080e7          	jalr	-1084(ra) # 80005336 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000577a:	8885                	andi	s1,s1,1
    8000577c:	f0ed                	bnez	s1,8000575e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000577e:	00018517          	auipc	a0,0x18
    80005782:	9aa50513          	addi	a0,a0,-1622 # 8001d128 <disk+0x2128>
    80005786:	00001097          	auipc	ra,0x1
    8000578a:	c50080e7          	jalr	-944(ra) # 800063d6 <release>
}
    8000578e:	70a6                	ld	ra,104(sp)
    80005790:	7406                	ld	s0,96(sp)
    80005792:	64e6                	ld	s1,88(sp)
    80005794:	6946                	ld	s2,80(sp)
    80005796:	69a6                	ld	s3,72(sp)
    80005798:	6a06                	ld	s4,64(sp)
    8000579a:	7ae2                	ld	s5,56(sp)
    8000579c:	7b42                	ld	s6,48(sp)
    8000579e:	7ba2                	ld	s7,40(sp)
    800057a0:	7c02                	ld	s8,32(sp)
    800057a2:	6ce2                	ld	s9,24(sp)
    800057a4:	6d42                	ld	s10,16(sp)
    800057a6:	6165                	addi	sp,sp,112
    800057a8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057aa:	00018697          	auipc	a3,0x18
    800057ae:	8566b683          	ld	a3,-1962(a3) # 8001d000 <disk+0x2000>
    800057b2:	96ba                	add	a3,a3,a4
    800057b4:	4609                	li	a2,2
    800057b6:	00c69623          	sh	a2,12(a3)
    800057ba:	b5c9                	j	8000567c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057bc:	f9042583          	lw	a1,-112(s0)
    800057c0:	20058793          	addi	a5,a1,512
    800057c4:	0792                	slli	a5,a5,0x4
    800057c6:	00016517          	auipc	a0,0x16
    800057ca:	8e250513          	addi	a0,a0,-1822 # 8001b0a8 <disk+0xa8>
    800057ce:	953e                	add	a0,a0,a5
  if(write)
    800057d0:	e20d11e3          	bnez	s10,800055f2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800057d4:	20058713          	addi	a4,a1,512
    800057d8:	00471693          	slli	a3,a4,0x4
    800057dc:	00016717          	auipc	a4,0x16
    800057e0:	82470713          	addi	a4,a4,-2012 # 8001b000 <disk>
    800057e4:	9736                	add	a4,a4,a3
    800057e6:	0a072423          	sw	zero,168(a4)
    800057ea:	b505                	j	8000560a <virtio_disk_rw+0xf4>

00000000800057ec <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057ec:	1101                	addi	sp,sp,-32
    800057ee:	ec06                	sd	ra,24(sp)
    800057f0:	e822                	sd	s0,16(sp)
    800057f2:	e426                	sd	s1,8(sp)
    800057f4:	e04a                	sd	s2,0(sp)
    800057f6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057f8:	00018517          	auipc	a0,0x18
    800057fc:	93050513          	addi	a0,a0,-1744 # 8001d128 <disk+0x2128>
    80005800:	00001097          	auipc	ra,0x1
    80005804:	b22080e7          	jalr	-1246(ra) # 80006322 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005808:	10001737          	lui	a4,0x10001
    8000580c:	533c                	lw	a5,96(a4)
    8000580e:	8b8d                	andi	a5,a5,3
    80005810:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005812:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005816:	00017797          	auipc	a5,0x17
    8000581a:	7ea78793          	addi	a5,a5,2026 # 8001d000 <disk+0x2000>
    8000581e:	6b94                	ld	a3,16(a5)
    80005820:	0207d703          	lhu	a4,32(a5)
    80005824:	0026d783          	lhu	a5,2(a3)
    80005828:	06f70163          	beq	a4,a5,8000588a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000582c:	00015917          	auipc	s2,0x15
    80005830:	7d490913          	addi	s2,s2,2004 # 8001b000 <disk>
    80005834:	00017497          	auipc	s1,0x17
    80005838:	7cc48493          	addi	s1,s1,1996 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000583c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005840:	6898                	ld	a4,16(s1)
    80005842:	0204d783          	lhu	a5,32(s1)
    80005846:	8b9d                	andi	a5,a5,7
    80005848:	078e                	slli	a5,a5,0x3
    8000584a:	97ba                	add	a5,a5,a4
    8000584c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000584e:	20078713          	addi	a4,a5,512
    80005852:	0712                	slli	a4,a4,0x4
    80005854:	974a                	add	a4,a4,s2
    80005856:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000585a:	e731                	bnez	a4,800058a6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000585c:	20078793          	addi	a5,a5,512
    80005860:	0792                	slli	a5,a5,0x4
    80005862:	97ca                	add	a5,a5,s2
    80005864:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005866:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000586a:	ffffc097          	auipc	ra,0xffffc
    8000586e:	fbc080e7          	jalr	-68(ra) # 80001826 <wakeup>

    disk.used_idx += 1;
    80005872:	0204d783          	lhu	a5,32(s1)
    80005876:	2785                	addiw	a5,a5,1
    80005878:	17c2                	slli	a5,a5,0x30
    8000587a:	93c1                	srli	a5,a5,0x30
    8000587c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005880:	6898                	ld	a4,16(s1)
    80005882:	00275703          	lhu	a4,2(a4)
    80005886:	faf71be3          	bne	a4,a5,8000583c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000588a:	00018517          	auipc	a0,0x18
    8000588e:	89e50513          	addi	a0,a0,-1890 # 8001d128 <disk+0x2128>
    80005892:	00001097          	auipc	ra,0x1
    80005896:	b44080e7          	jalr	-1212(ra) # 800063d6 <release>
}
    8000589a:	60e2                	ld	ra,24(sp)
    8000589c:	6442                	ld	s0,16(sp)
    8000589e:	64a2                	ld	s1,8(sp)
    800058a0:	6902                	ld	s2,0(sp)
    800058a2:	6105                	addi	sp,sp,32
    800058a4:	8082                	ret
      panic("virtio_disk_intr status");
    800058a6:	00003517          	auipc	a0,0x3
    800058aa:	f4a50513          	addi	a0,a0,-182 # 800087f0 <syscalls+0x3f8>
    800058ae:	00000097          	auipc	ra,0x0
    800058b2:	52a080e7          	jalr	1322(ra) # 80005dd8 <panic>

00000000800058b6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058b6:	1141                	addi	sp,sp,-16
    800058b8:	e422                	sd	s0,8(sp)
    800058ba:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058bc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058c0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058c4:	0037979b          	slliw	a5,a5,0x3
    800058c8:	02004737          	lui	a4,0x2004
    800058cc:	97ba                	add	a5,a5,a4
    800058ce:	0200c737          	lui	a4,0x200c
    800058d2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058d6:	000f4637          	lui	a2,0xf4
    800058da:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058de:	95b2                	add	a1,a1,a2
    800058e0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058e2:	00269713          	slli	a4,a3,0x2
    800058e6:	9736                	add	a4,a4,a3
    800058e8:	00371693          	slli	a3,a4,0x3
    800058ec:	00018717          	auipc	a4,0x18
    800058f0:	71470713          	addi	a4,a4,1812 # 8001e000 <timer_scratch>
    800058f4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058f6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058f8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058fa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058fe:	00000797          	auipc	a5,0x0
    80005902:	97278793          	addi	a5,a5,-1678 # 80005270 <timervec>
    80005906:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000590a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000590e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005912:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005916:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000591a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000591e:	30479073          	csrw	mie,a5
}
    80005922:	6422                	ld	s0,8(sp)
    80005924:	0141                	addi	sp,sp,16
    80005926:	8082                	ret

0000000080005928 <start>:
{
    80005928:	1141                	addi	sp,sp,-16
    8000592a:	e406                	sd	ra,8(sp)
    8000592c:	e022                	sd	s0,0(sp)
    8000592e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005930:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005934:	7779                	lui	a4,0xffffe
    80005936:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000593a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000593c:	6705                	lui	a4,0x1
    8000593e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005942:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005944:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005948:	ffffb797          	auipc	a5,0xffffb
    8000594c:	9de78793          	addi	a5,a5,-1570 # 80000326 <main>
    80005950:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005954:	4781                	li	a5,0
    80005956:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000595a:	67c1                	lui	a5,0x10
    8000595c:	17fd                	addi	a5,a5,-1
    8000595e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005962:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005966:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000596a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000596e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005972:	57fd                	li	a5,-1
    80005974:	83a9                	srli	a5,a5,0xa
    80005976:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000597a:	47bd                	li	a5,15
    8000597c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005980:	00000097          	auipc	ra,0x0
    80005984:	f36080e7          	jalr	-202(ra) # 800058b6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005988:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000598c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000598e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005990:	30200073          	mret
}
    80005994:	60a2                	ld	ra,8(sp)
    80005996:	6402                	ld	s0,0(sp)
    80005998:	0141                	addi	sp,sp,16
    8000599a:	8082                	ret

000000008000599c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000599c:	715d                	addi	sp,sp,-80
    8000599e:	e486                	sd	ra,72(sp)
    800059a0:	e0a2                	sd	s0,64(sp)
    800059a2:	fc26                	sd	s1,56(sp)
    800059a4:	f84a                	sd	s2,48(sp)
    800059a6:	f44e                	sd	s3,40(sp)
    800059a8:	f052                	sd	s4,32(sp)
    800059aa:	ec56                	sd	s5,24(sp)
    800059ac:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059ae:	04c05663          	blez	a2,800059fa <consolewrite+0x5e>
    800059b2:	8a2a                	mv	s4,a0
    800059b4:	84ae                	mv	s1,a1
    800059b6:	89b2                	mv	s3,a2
    800059b8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059ba:	5afd                	li	s5,-1
    800059bc:	4685                	li	a3,1
    800059be:	8626                	mv	a2,s1
    800059c0:	85d2                	mv	a1,s4
    800059c2:	fbf40513          	addi	a0,s0,-65
    800059c6:	ffffc097          	auipc	ra,0xffffc
    800059ca:	0ce080e7          	jalr	206(ra) # 80001a94 <either_copyin>
    800059ce:	01550c63          	beq	a0,s5,800059e6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800059d2:	fbf44503          	lbu	a0,-65(s0)
    800059d6:	00000097          	auipc	ra,0x0
    800059da:	78e080e7          	jalr	1934(ra) # 80006164 <uartputc>
  for(i = 0; i < n; i++){
    800059de:	2905                	addiw	s2,s2,1
    800059e0:	0485                	addi	s1,s1,1
    800059e2:	fd299de3          	bne	s3,s2,800059bc <consolewrite+0x20>
  }

  return i;
}
    800059e6:	854a                	mv	a0,s2
    800059e8:	60a6                	ld	ra,72(sp)
    800059ea:	6406                	ld	s0,64(sp)
    800059ec:	74e2                	ld	s1,56(sp)
    800059ee:	7942                	ld	s2,48(sp)
    800059f0:	79a2                	ld	s3,40(sp)
    800059f2:	7a02                	ld	s4,32(sp)
    800059f4:	6ae2                	ld	s5,24(sp)
    800059f6:	6161                	addi	sp,sp,80
    800059f8:	8082                	ret
  for(i = 0; i < n; i++){
    800059fa:	4901                	li	s2,0
    800059fc:	b7ed                	j	800059e6 <consolewrite+0x4a>

00000000800059fe <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059fe:	7119                	addi	sp,sp,-128
    80005a00:	fc86                	sd	ra,120(sp)
    80005a02:	f8a2                	sd	s0,112(sp)
    80005a04:	f4a6                	sd	s1,104(sp)
    80005a06:	f0ca                	sd	s2,96(sp)
    80005a08:	ecce                	sd	s3,88(sp)
    80005a0a:	e8d2                	sd	s4,80(sp)
    80005a0c:	e4d6                	sd	s5,72(sp)
    80005a0e:	e0da                	sd	s6,64(sp)
    80005a10:	fc5e                	sd	s7,56(sp)
    80005a12:	f862                	sd	s8,48(sp)
    80005a14:	f466                	sd	s9,40(sp)
    80005a16:	f06a                	sd	s10,32(sp)
    80005a18:	ec6e                	sd	s11,24(sp)
    80005a1a:	0100                	addi	s0,sp,128
    80005a1c:	8b2a                	mv	s6,a0
    80005a1e:	8aae                	mv	s5,a1
    80005a20:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a22:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a26:	00020517          	auipc	a0,0x20
    80005a2a:	71a50513          	addi	a0,a0,1818 # 80026140 <cons>
    80005a2e:	00001097          	auipc	ra,0x1
    80005a32:	8f4080e7          	jalr	-1804(ra) # 80006322 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a36:	00020497          	auipc	s1,0x20
    80005a3a:	70a48493          	addi	s1,s1,1802 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a3e:	89a6                	mv	s3,s1
    80005a40:	00020917          	auipc	s2,0x20
    80005a44:	79890913          	addi	s2,s2,1944 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a48:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a4a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a4c:	4da9                	li	s11,10
  while(n > 0){
    80005a4e:	07405863          	blez	s4,80005abe <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a52:	0984a783          	lw	a5,152(s1)
    80005a56:	09c4a703          	lw	a4,156(s1)
    80005a5a:	02f71463          	bne	a4,a5,80005a82 <consoleread+0x84>
      if(myproc()->killed){
    80005a5e:	ffffb097          	auipc	ra,0xffffb
    80005a62:	4fa080e7          	jalr	1274(ra) # 80000f58 <myproc>
    80005a66:	551c                	lw	a5,40(a0)
    80005a68:	e7b5                	bnez	a5,80005ad4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a6a:	85ce                	mv	a1,s3
    80005a6c:	854a                	mv	a0,s2
    80005a6e:	ffffc097          	auipc	ra,0xffffc
    80005a72:	c2c080e7          	jalr	-980(ra) # 8000169a <sleep>
    while(cons.r == cons.w){
    80005a76:	0984a783          	lw	a5,152(s1)
    80005a7a:	09c4a703          	lw	a4,156(s1)
    80005a7e:	fef700e3          	beq	a4,a5,80005a5e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a82:	0017871b          	addiw	a4,a5,1
    80005a86:	08e4ac23          	sw	a4,152(s1)
    80005a8a:	07f7f713          	andi	a4,a5,127
    80005a8e:	9726                	add	a4,a4,s1
    80005a90:	01874703          	lbu	a4,24(a4)
    80005a94:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a98:	079c0663          	beq	s8,s9,80005b04 <consoleread+0x106>
    cbuf = c;
    80005a9c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005aa0:	4685                	li	a3,1
    80005aa2:	f8f40613          	addi	a2,s0,-113
    80005aa6:	85d6                	mv	a1,s5
    80005aa8:	855a                	mv	a0,s6
    80005aaa:	ffffc097          	auipc	ra,0xffffc
    80005aae:	f94080e7          	jalr	-108(ra) # 80001a3e <either_copyout>
    80005ab2:	01a50663          	beq	a0,s10,80005abe <consoleread+0xc0>
    dst++;
    80005ab6:	0a85                	addi	s5,s5,1
    --n;
    80005ab8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005aba:	f9bc1ae3          	bne	s8,s11,80005a4e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005abe:	00020517          	auipc	a0,0x20
    80005ac2:	68250513          	addi	a0,a0,1666 # 80026140 <cons>
    80005ac6:	00001097          	auipc	ra,0x1
    80005aca:	910080e7          	jalr	-1776(ra) # 800063d6 <release>

  return target - n;
    80005ace:	414b853b          	subw	a0,s7,s4
    80005ad2:	a811                	j	80005ae6 <consoleread+0xe8>
        release(&cons.lock);
    80005ad4:	00020517          	auipc	a0,0x20
    80005ad8:	66c50513          	addi	a0,a0,1644 # 80026140 <cons>
    80005adc:	00001097          	auipc	ra,0x1
    80005ae0:	8fa080e7          	jalr	-1798(ra) # 800063d6 <release>
        return -1;
    80005ae4:	557d                	li	a0,-1
}
    80005ae6:	70e6                	ld	ra,120(sp)
    80005ae8:	7446                	ld	s0,112(sp)
    80005aea:	74a6                	ld	s1,104(sp)
    80005aec:	7906                	ld	s2,96(sp)
    80005aee:	69e6                	ld	s3,88(sp)
    80005af0:	6a46                	ld	s4,80(sp)
    80005af2:	6aa6                	ld	s5,72(sp)
    80005af4:	6b06                	ld	s6,64(sp)
    80005af6:	7be2                	ld	s7,56(sp)
    80005af8:	7c42                	ld	s8,48(sp)
    80005afa:	7ca2                	ld	s9,40(sp)
    80005afc:	7d02                	ld	s10,32(sp)
    80005afe:	6de2                	ld	s11,24(sp)
    80005b00:	6109                	addi	sp,sp,128
    80005b02:	8082                	ret
      if(n < target){
    80005b04:	000a071b          	sext.w	a4,s4
    80005b08:	fb777be3          	bgeu	a4,s7,80005abe <consoleread+0xc0>
        cons.r--;
    80005b0c:	00020717          	auipc	a4,0x20
    80005b10:	6cf72623          	sw	a5,1740(a4) # 800261d8 <cons+0x98>
    80005b14:	b76d                	j	80005abe <consoleread+0xc0>

0000000080005b16 <consputc>:
{
    80005b16:	1141                	addi	sp,sp,-16
    80005b18:	e406                	sd	ra,8(sp)
    80005b1a:	e022                	sd	s0,0(sp)
    80005b1c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b1e:	10000793          	li	a5,256
    80005b22:	00f50a63          	beq	a0,a5,80005b36 <consputc+0x20>
    uartputc_sync(c);
    80005b26:	00000097          	auipc	ra,0x0
    80005b2a:	564080e7          	jalr	1380(ra) # 8000608a <uartputc_sync>
}
    80005b2e:	60a2                	ld	ra,8(sp)
    80005b30:	6402                	ld	s0,0(sp)
    80005b32:	0141                	addi	sp,sp,16
    80005b34:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b36:	4521                	li	a0,8
    80005b38:	00000097          	auipc	ra,0x0
    80005b3c:	552080e7          	jalr	1362(ra) # 8000608a <uartputc_sync>
    80005b40:	02000513          	li	a0,32
    80005b44:	00000097          	auipc	ra,0x0
    80005b48:	546080e7          	jalr	1350(ra) # 8000608a <uartputc_sync>
    80005b4c:	4521                	li	a0,8
    80005b4e:	00000097          	auipc	ra,0x0
    80005b52:	53c080e7          	jalr	1340(ra) # 8000608a <uartputc_sync>
    80005b56:	bfe1                	j	80005b2e <consputc+0x18>

0000000080005b58 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b58:	1101                	addi	sp,sp,-32
    80005b5a:	ec06                	sd	ra,24(sp)
    80005b5c:	e822                	sd	s0,16(sp)
    80005b5e:	e426                	sd	s1,8(sp)
    80005b60:	e04a                	sd	s2,0(sp)
    80005b62:	1000                	addi	s0,sp,32
    80005b64:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b66:	00020517          	auipc	a0,0x20
    80005b6a:	5da50513          	addi	a0,a0,1498 # 80026140 <cons>
    80005b6e:	00000097          	auipc	ra,0x0
    80005b72:	7b4080e7          	jalr	1972(ra) # 80006322 <acquire>

  switch(c){
    80005b76:	47d5                	li	a5,21
    80005b78:	0af48663          	beq	s1,a5,80005c24 <consoleintr+0xcc>
    80005b7c:	0297ca63          	blt	a5,s1,80005bb0 <consoleintr+0x58>
    80005b80:	47a1                	li	a5,8
    80005b82:	0ef48763          	beq	s1,a5,80005c70 <consoleintr+0x118>
    80005b86:	47c1                	li	a5,16
    80005b88:	10f49a63          	bne	s1,a5,80005c9c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b8c:	ffffc097          	auipc	ra,0xffffc
    80005b90:	f5e080e7          	jalr	-162(ra) # 80001aea <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b94:	00020517          	auipc	a0,0x20
    80005b98:	5ac50513          	addi	a0,a0,1452 # 80026140 <cons>
    80005b9c:	00001097          	auipc	ra,0x1
    80005ba0:	83a080e7          	jalr	-1990(ra) # 800063d6 <release>
}
    80005ba4:	60e2                	ld	ra,24(sp)
    80005ba6:	6442                	ld	s0,16(sp)
    80005ba8:	64a2                	ld	s1,8(sp)
    80005baa:	6902                	ld	s2,0(sp)
    80005bac:	6105                	addi	sp,sp,32
    80005bae:	8082                	ret
  switch(c){
    80005bb0:	07f00793          	li	a5,127
    80005bb4:	0af48e63          	beq	s1,a5,80005c70 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bb8:	00020717          	auipc	a4,0x20
    80005bbc:	58870713          	addi	a4,a4,1416 # 80026140 <cons>
    80005bc0:	0a072783          	lw	a5,160(a4)
    80005bc4:	09872703          	lw	a4,152(a4)
    80005bc8:	9f99                	subw	a5,a5,a4
    80005bca:	07f00713          	li	a4,127
    80005bce:	fcf763e3          	bltu	a4,a5,80005b94 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bd2:	47b5                	li	a5,13
    80005bd4:	0cf48763          	beq	s1,a5,80005ca2 <consoleintr+0x14a>
      consputc(c);
    80005bd8:	8526                	mv	a0,s1
    80005bda:	00000097          	auipc	ra,0x0
    80005bde:	f3c080e7          	jalr	-196(ra) # 80005b16 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005be2:	00020797          	auipc	a5,0x20
    80005be6:	55e78793          	addi	a5,a5,1374 # 80026140 <cons>
    80005bea:	0a07a703          	lw	a4,160(a5)
    80005bee:	0017069b          	addiw	a3,a4,1
    80005bf2:	0006861b          	sext.w	a2,a3
    80005bf6:	0ad7a023          	sw	a3,160(a5)
    80005bfa:	07f77713          	andi	a4,a4,127
    80005bfe:	97ba                	add	a5,a5,a4
    80005c00:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005c04:	47a9                	li	a5,10
    80005c06:	0cf48563          	beq	s1,a5,80005cd0 <consoleintr+0x178>
    80005c0a:	4791                	li	a5,4
    80005c0c:	0cf48263          	beq	s1,a5,80005cd0 <consoleintr+0x178>
    80005c10:	00020797          	auipc	a5,0x20
    80005c14:	5c87a783          	lw	a5,1480(a5) # 800261d8 <cons+0x98>
    80005c18:	0807879b          	addiw	a5,a5,128
    80005c1c:	f6f61ce3          	bne	a2,a5,80005b94 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c20:	863e                	mv	a2,a5
    80005c22:	a07d                	j	80005cd0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c24:	00020717          	auipc	a4,0x20
    80005c28:	51c70713          	addi	a4,a4,1308 # 80026140 <cons>
    80005c2c:	0a072783          	lw	a5,160(a4)
    80005c30:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c34:	00020497          	auipc	s1,0x20
    80005c38:	50c48493          	addi	s1,s1,1292 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005c3c:	4929                	li	s2,10
    80005c3e:	f4f70be3          	beq	a4,a5,80005b94 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c42:	37fd                	addiw	a5,a5,-1
    80005c44:	07f7f713          	andi	a4,a5,127
    80005c48:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c4a:	01874703          	lbu	a4,24(a4)
    80005c4e:	f52703e3          	beq	a4,s2,80005b94 <consoleintr+0x3c>
      cons.e--;
    80005c52:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c56:	10000513          	li	a0,256
    80005c5a:	00000097          	auipc	ra,0x0
    80005c5e:	ebc080e7          	jalr	-324(ra) # 80005b16 <consputc>
    while(cons.e != cons.w &&
    80005c62:	0a04a783          	lw	a5,160(s1)
    80005c66:	09c4a703          	lw	a4,156(s1)
    80005c6a:	fcf71ce3          	bne	a4,a5,80005c42 <consoleintr+0xea>
    80005c6e:	b71d                	j	80005b94 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c70:	00020717          	auipc	a4,0x20
    80005c74:	4d070713          	addi	a4,a4,1232 # 80026140 <cons>
    80005c78:	0a072783          	lw	a5,160(a4)
    80005c7c:	09c72703          	lw	a4,156(a4)
    80005c80:	f0f70ae3          	beq	a4,a5,80005b94 <consoleintr+0x3c>
      cons.e--;
    80005c84:	37fd                	addiw	a5,a5,-1
    80005c86:	00020717          	auipc	a4,0x20
    80005c8a:	54f72d23          	sw	a5,1370(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c8e:	10000513          	li	a0,256
    80005c92:	00000097          	auipc	ra,0x0
    80005c96:	e84080e7          	jalr	-380(ra) # 80005b16 <consputc>
    80005c9a:	bded                	j	80005b94 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c9c:	ee048ce3          	beqz	s1,80005b94 <consoleintr+0x3c>
    80005ca0:	bf21                	j	80005bb8 <consoleintr+0x60>
      consputc(c);
    80005ca2:	4529                	li	a0,10
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	e72080e7          	jalr	-398(ra) # 80005b16 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005cac:	00020797          	auipc	a5,0x20
    80005cb0:	49478793          	addi	a5,a5,1172 # 80026140 <cons>
    80005cb4:	0a07a703          	lw	a4,160(a5)
    80005cb8:	0017069b          	addiw	a3,a4,1
    80005cbc:	0006861b          	sext.w	a2,a3
    80005cc0:	0ad7a023          	sw	a3,160(a5)
    80005cc4:	07f77713          	andi	a4,a4,127
    80005cc8:	97ba                	add	a5,a5,a4
    80005cca:	4729                	li	a4,10
    80005ccc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cd0:	00020797          	auipc	a5,0x20
    80005cd4:	50c7a623          	sw	a2,1292(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005cd8:	00020517          	auipc	a0,0x20
    80005cdc:	50050513          	addi	a0,a0,1280 # 800261d8 <cons+0x98>
    80005ce0:	ffffc097          	auipc	ra,0xffffc
    80005ce4:	b46080e7          	jalr	-1210(ra) # 80001826 <wakeup>
    80005ce8:	b575                	j	80005b94 <consoleintr+0x3c>

0000000080005cea <consoleinit>:

void
consoleinit(void)
{
    80005cea:	1141                	addi	sp,sp,-16
    80005cec:	e406                	sd	ra,8(sp)
    80005cee:	e022                	sd	s0,0(sp)
    80005cf0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cf2:	00003597          	auipc	a1,0x3
    80005cf6:	b1658593          	addi	a1,a1,-1258 # 80008808 <syscalls+0x410>
    80005cfa:	00020517          	auipc	a0,0x20
    80005cfe:	44650513          	addi	a0,a0,1094 # 80026140 <cons>
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	590080e7          	jalr	1424(ra) # 80006292 <initlock>

  uartinit();
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	330080e7          	jalr	816(ra) # 8000603a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d12:	00013797          	auipc	a5,0x13
    80005d16:	5b678793          	addi	a5,a5,1462 # 800192c8 <devsw>
    80005d1a:	00000717          	auipc	a4,0x0
    80005d1e:	ce470713          	addi	a4,a4,-796 # 800059fe <consoleread>
    80005d22:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d24:	00000717          	auipc	a4,0x0
    80005d28:	c7870713          	addi	a4,a4,-904 # 8000599c <consolewrite>
    80005d2c:	ef98                	sd	a4,24(a5)
}
    80005d2e:	60a2                	ld	ra,8(sp)
    80005d30:	6402                	ld	s0,0(sp)
    80005d32:	0141                	addi	sp,sp,16
    80005d34:	8082                	ret

0000000080005d36 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d36:	7179                	addi	sp,sp,-48
    80005d38:	f406                	sd	ra,40(sp)
    80005d3a:	f022                	sd	s0,32(sp)
    80005d3c:	ec26                	sd	s1,24(sp)
    80005d3e:	e84a                	sd	s2,16(sp)
    80005d40:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d42:	c219                	beqz	a2,80005d48 <printint+0x12>
    80005d44:	08054663          	bltz	a0,80005dd0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d48:	2501                	sext.w	a0,a0
    80005d4a:	4881                	li	a7,0
    80005d4c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d50:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d52:	2581                	sext.w	a1,a1
    80005d54:	00003617          	auipc	a2,0x3
    80005d58:	ae460613          	addi	a2,a2,-1308 # 80008838 <digits>
    80005d5c:	883a                	mv	a6,a4
    80005d5e:	2705                	addiw	a4,a4,1
    80005d60:	02b577bb          	remuw	a5,a0,a1
    80005d64:	1782                	slli	a5,a5,0x20
    80005d66:	9381                	srli	a5,a5,0x20
    80005d68:	97b2                	add	a5,a5,a2
    80005d6a:	0007c783          	lbu	a5,0(a5)
    80005d6e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d72:	0005079b          	sext.w	a5,a0
    80005d76:	02b5553b          	divuw	a0,a0,a1
    80005d7a:	0685                	addi	a3,a3,1
    80005d7c:	feb7f0e3          	bgeu	a5,a1,80005d5c <printint+0x26>

  if(sign)
    80005d80:	00088b63          	beqz	a7,80005d96 <printint+0x60>
    buf[i++] = '-';
    80005d84:	fe040793          	addi	a5,s0,-32
    80005d88:	973e                	add	a4,a4,a5
    80005d8a:	02d00793          	li	a5,45
    80005d8e:	fef70823          	sb	a5,-16(a4)
    80005d92:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d96:	02e05763          	blez	a4,80005dc4 <printint+0x8e>
    80005d9a:	fd040793          	addi	a5,s0,-48
    80005d9e:	00e784b3          	add	s1,a5,a4
    80005da2:	fff78913          	addi	s2,a5,-1
    80005da6:	993a                	add	s2,s2,a4
    80005da8:	377d                	addiw	a4,a4,-1
    80005daa:	1702                	slli	a4,a4,0x20
    80005dac:	9301                	srli	a4,a4,0x20
    80005dae:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005db2:	fff4c503          	lbu	a0,-1(s1)
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	d60080e7          	jalr	-672(ra) # 80005b16 <consputc>
  while(--i >= 0)
    80005dbe:	14fd                	addi	s1,s1,-1
    80005dc0:	ff2499e3          	bne	s1,s2,80005db2 <printint+0x7c>
}
    80005dc4:	70a2                	ld	ra,40(sp)
    80005dc6:	7402                	ld	s0,32(sp)
    80005dc8:	64e2                	ld	s1,24(sp)
    80005dca:	6942                	ld	s2,16(sp)
    80005dcc:	6145                	addi	sp,sp,48
    80005dce:	8082                	ret
    x = -xx;
    80005dd0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dd4:	4885                	li	a7,1
    x = -xx;
    80005dd6:	bf9d                	j	80005d4c <printint+0x16>

0000000080005dd8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dd8:	1101                	addi	sp,sp,-32
    80005dda:	ec06                	sd	ra,24(sp)
    80005ddc:	e822                	sd	s0,16(sp)
    80005dde:	e426                	sd	s1,8(sp)
    80005de0:	1000                	addi	s0,sp,32
    80005de2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005de4:	00020797          	auipc	a5,0x20
    80005de8:	4007ae23          	sw	zero,1052(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005dec:	00003517          	auipc	a0,0x3
    80005df0:	a2450513          	addi	a0,a0,-1500 # 80008810 <syscalls+0x418>
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	02e080e7          	jalr	46(ra) # 80005e22 <printf>
  printf(s);
    80005dfc:	8526                	mv	a0,s1
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	024080e7          	jalr	36(ra) # 80005e22 <printf>
  printf("\n");
    80005e06:	00002517          	auipc	a0,0x2
    80005e0a:	24250513          	addi	a0,a0,578 # 80008048 <etext+0x48>
    80005e0e:	00000097          	auipc	ra,0x0
    80005e12:	014080e7          	jalr	20(ra) # 80005e22 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e16:	4785                	li	a5,1
    80005e18:	00003717          	auipc	a4,0x3
    80005e1c:	20f72223          	sw	a5,516(a4) # 8000901c <panicked>
  for(;;)
    80005e20:	a001                	j	80005e20 <panic+0x48>

0000000080005e22 <printf>:
{
    80005e22:	7131                	addi	sp,sp,-192
    80005e24:	fc86                	sd	ra,120(sp)
    80005e26:	f8a2                	sd	s0,112(sp)
    80005e28:	f4a6                	sd	s1,104(sp)
    80005e2a:	f0ca                	sd	s2,96(sp)
    80005e2c:	ecce                	sd	s3,88(sp)
    80005e2e:	e8d2                	sd	s4,80(sp)
    80005e30:	e4d6                	sd	s5,72(sp)
    80005e32:	e0da                	sd	s6,64(sp)
    80005e34:	fc5e                	sd	s7,56(sp)
    80005e36:	f862                	sd	s8,48(sp)
    80005e38:	f466                	sd	s9,40(sp)
    80005e3a:	f06a                	sd	s10,32(sp)
    80005e3c:	ec6e                	sd	s11,24(sp)
    80005e3e:	0100                	addi	s0,sp,128
    80005e40:	8a2a                	mv	s4,a0
    80005e42:	e40c                	sd	a1,8(s0)
    80005e44:	e810                	sd	a2,16(s0)
    80005e46:	ec14                	sd	a3,24(s0)
    80005e48:	f018                	sd	a4,32(s0)
    80005e4a:	f41c                	sd	a5,40(s0)
    80005e4c:	03043823          	sd	a6,48(s0)
    80005e50:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e54:	00020d97          	auipc	s11,0x20
    80005e58:	3acdad83          	lw	s11,940(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e5c:	020d9b63          	bnez	s11,80005e92 <printf+0x70>
  if (fmt == 0)
    80005e60:	040a0263          	beqz	s4,80005ea4 <printf+0x82>
  va_start(ap, fmt);
    80005e64:	00840793          	addi	a5,s0,8
    80005e68:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e6c:	000a4503          	lbu	a0,0(s4)
    80005e70:	16050263          	beqz	a0,80005fd4 <printf+0x1b2>
    80005e74:	4481                	li	s1,0
    if(c != '%'){
    80005e76:	02500a93          	li	s5,37
    switch(c){
    80005e7a:	07000b13          	li	s6,112
  consputc('x');
    80005e7e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e80:	00003b97          	auipc	s7,0x3
    80005e84:	9b8b8b93          	addi	s7,s7,-1608 # 80008838 <digits>
    switch(c){
    80005e88:	07300c93          	li	s9,115
    80005e8c:	06400c13          	li	s8,100
    80005e90:	a82d                	j	80005eca <printf+0xa8>
    acquire(&pr.lock);
    80005e92:	00020517          	auipc	a0,0x20
    80005e96:	35650513          	addi	a0,a0,854 # 800261e8 <pr>
    80005e9a:	00000097          	auipc	ra,0x0
    80005e9e:	488080e7          	jalr	1160(ra) # 80006322 <acquire>
    80005ea2:	bf7d                	j	80005e60 <printf+0x3e>
    panic("null fmt");
    80005ea4:	00003517          	auipc	a0,0x3
    80005ea8:	97c50513          	addi	a0,a0,-1668 # 80008820 <syscalls+0x428>
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	f2c080e7          	jalr	-212(ra) # 80005dd8 <panic>
      consputc(c);
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	c62080e7          	jalr	-926(ra) # 80005b16 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ebc:	2485                	addiw	s1,s1,1
    80005ebe:	009a07b3          	add	a5,s4,s1
    80005ec2:	0007c503          	lbu	a0,0(a5)
    80005ec6:	10050763          	beqz	a0,80005fd4 <printf+0x1b2>
    if(c != '%'){
    80005eca:	ff5515e3          	bne	a0,s5,80005eb4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ece:	2485                	addiw	s1,s1,1
    80005ed0:	009a07b3          	add	a5,s4,s1
    80005ed4:	0007c783          	lbu	a5,0(a5)
    80005ed8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005edc:	cfe5                	beqz	a5,80005fd4 <printf+0x1b2>
    switch(c){
    80005ede:	05678a63          	beq	a5,s6,80005f32 <printf+0x110>
    80005ee2:	02fb7663          	bgeu	s6,a5,80005f0e <printf+0xec>
    80005ee6:	09978963          	beq	a5,s9,80005f78 <printf+0x156>
    80005eea:	07800713          	li	a4,120
    80005eee:	0ce79863          	bne	a5,a4,80005fbe <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ef2:	f8843783          	ld	a5,-120(s0)
    80005ef6:	00878713          	addi	a4,a5,8
    80005efa:	f8e43423          	sd	a4,-120(s0)
    80005efe:	4605                	li	a2,1
    80005f00:	85ea                	mv	a1,s10
    80005f02:	4388                	lw	a0,0(a5)
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	e32080e7          	jalr	-462(ra) # 80005d36 <printint>
      break;
    80005f0c:	bf45                	j	80005ebc <printf+0x9a>
    switch(c){
    80005f0e:	0b578263          	beq	a5,s5,80005fb2 <printf+0x190>
    80005f12:	0b879663          	bne	a5,s8,80005fbe <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f16:	f8843783          	ld	a5,-120(s0)
    80005f1a:	00878713          	addi	a4,a5,8
    80005f1e:	f8e43423          	sd	a4,-120(s0)
    80005f22:	4605                	li	a2,1
    80005f24:	45a9                	li	a1,10
    80005f26:	4388                	lw	a0,0(a5)
    80005f28:	00000097          	auipc	ra,0x0
    80005f2c:	e0e080e7          	jalr	-498(ra) # 80005d36 <printint>
      break;
    80005f30:	b771                	j	80005ebc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f32:	f8843783          	ld	a5,-120(s0)
    80005f36:	00878713          	addi	a4,a5,8
    80005f3a:	f8e43423          	sd	a4,-120(s0)
    80005f3e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f42:	03000513          	li	a0,48
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	bd0080e7          	jalr	-1072(ra) # 80005b16 <consputc>
  consputc('x');
    80005f4e:	07800513          	li	a0,120
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	bc4080e7          	jalr	-1084(ra) # 80005b16 <consputc>
    80005f5a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f5c:	03c9d793          	srli	a5,s3,0x3c
    80005f60:	97de                	add	a5,a5,s7
    80005f62:	0007c503          	lbu	a0,0(a5)
    80005f66:	00000097          	auipc	ra,0x0
    80005f6a:	bb0080e7          	jalr	-1104(ra) # 80005b16 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f6e:	0992                	slli	s3,s3,0x4
    80005f70:	397d                	addiw	s2,s2,-1
    80005f72:	fe0915e3          	bnez	s2,80005f5c <printf+0x13a>
    80005f76:	b799                	j	80005ebc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f78:	f8843783          	ld	a5,-120(s0)
    80005f7c:	00878713          	addi	a4,a5,8
    80005f80:	f8e43423          	sd	a4,-120(s0)
    80005f84:	0007b903          	ld	s2,0(a5)
    80005f88:	00090e63          	beqz	s2,80005fa4 <printf+0x182>
      for(; *s; s++)
    80005f8c:	00094503          	lbu	a0,0(s2)
    80005f90:	d515                	beqz	a0,80005ebc <printf+0x9a>
        consputc(*s);
    80005f92:	00000097          	auipc	ra,0x0
    80005f96:	b84080e7          	jalr	-1148(ra) # 80005b16 <consputc>
      for(; *s; s++)
    80005f9a:	0905                	addi	s2,s2,1
    80005f9c:	00094503          	lbu	a0,0(s2)
    80005fa0:	f96d                	bnez	a0,80005f92 <printf+0x170>
    80005fa2:	bf29                	j	80005ebc <printf+0x9a>
        s = "(null)";
    80005fa4:	00003917          	auipc	s2,0x3
    80005fa8:	87490913          	addi	s2,s2,-1932 # 80008818 <syscalls+0x420>
      for(; *s; s++)
    80005fac:	02800513          	li	a0,40
    80005fb0:	b7cd                	j	80005f92 <printf+0x170>
      consputc('%');
    80005fb2:	8556                	mv	a0,s5
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	b62080e7          	jalr	-1182(ra) # 80005b16 <consputc>
      break;
    80005fbc:	b701                	j	80005ebc <printf+0x9a>
      consputc('%');
    80005fbe:	8556                	mv	a0,s5
    80005fc0:	00000097          	auipc	ra,0x0
    80005fc4:	b56080e7          	jalr	-1194(ra) # 80005b16 <consputc>
      consputc(c);
    80005fc8:	854a                	mv	a0,s2
    80005fca:	00000097          	auipc	ra,0x0
    80005fce:	b4c080e7          	jalr	-1204(ra) # 80005b16 <consputc>
      break;
    80005fd2:	b5ed                	j	80005ebc <printf+0x9a>
  if(locking)
    80005fd4:	020d9163          	bnez	s11,80005ff6 <printf+0x1d4>
}
    80005fd8:	70e6                	ld	ra,120(sp)
    80005fda:	7446                	ld	s0,112(sp)
    80005fdc:	74a6                	ld	s1,104(sp)
    80005fde:	7906                	ld	s2,96(sp)
    80005fe0:	69e6                	ld	s3,88(sp)
    80005fe2:	6a46                	ld	s4,80(sp)
    80005fe4:	6aa6                	ld	s5,72(sp)
    80005fe6:	6b06                	ld	s6,64(sp)
    80005fe8:	7be2                	ld	s7,56(sp)
    80005fea:	7c42                	ld	s8,48(sp)
    80005fec:	7ca2                	ld	s9,40(sp)
    80005fee:	7d02                	ld	s10,32(sp)
    80005ff0:	6de2                	ld	s11,24(sp)
    80005ff2:	6129                	addi	sp,sp,192
    80005ff4:	8082                	ret
    release(&pr.lock);
    80005ff6:	00020517          	auipc	a0,0x20
    80005ffa:	1f250513          	addi	a0,a0,498 # 800261e8 <pr>
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	3d8080e7          	jalr	984(ra) # 800063d6 <release>
}
    80006006:	bfc9                	j	80005fd8 <printf+0x1b6>

0000000080006008 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006008:	1101                	addi	sp,sp,-32
    8000600a:	ec06                	sd	ra,24(sp)
    8000600c:	e822                	sd	s0,16(sp)
    8000600e:	e426                	sd	s1,8(sp)
    80006010:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006012:	00020497          	auipc	s1,0x20
    80006016:	1d648493          	addi	s1,s1,470 # 800261e8 <pr>
    8000601a:	00003597          	auipc	a1,0x3
    8000601e:	81658593          	addi	a1,a1,-2026 # 80008830 <syscalls+0x438>
    80006022:	8526                	mv	a0,s1
    80006024:	00000097          	auipc	ra,0x0
    80006028:	26e080e7          	jalr	622(ra) # 80006292 <initlock>
  pr.locking = 1;
    8000602c:	4785                	li	a5,1
    8000602e:	cc9c                	sw	a5,24(s1)
}
    80006030:	60e2                	ld	ra,24(sp)
    80006032:	6442                	ld	s0,16(sp)
    80006034:	64a2                	ld	s1,8(sp)
    80006036:	6105                	addi	sp,sp,32
    80006038:	8082                	ret

000000008000603a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000603a:	1141                	addi	sp,sp,-16
    8000603c:	e406                	sd	ra,8(sp)
    8000603e:	e022                	sd	s0,0(sp)
    80006040:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006042:	100007b7          	lui	a5,0x10000
    80006046:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000604a:	f8000713          	li	a4,-128
    8000604e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006052:	470d                	li	a4,3
    80006054:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006058:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000605c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006060:	469d                	li	a3,7
    80006062:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006066:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000606a:	00002597          	auipc	a1,0x2
    8000606e:	7e658593          	addi	a1,a1,2022 # 80008850 <digits+0x18>
    80006072:	00020517          	auipc	a0,0x20
    80006076:	19650513          	addi	a0,a0,406 # 80026208 <uart_tx_lock>
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	218080e7          	jalr	536(ra) # 80006292 <initlock>
}
    80006082:	60a2                	ld	ra,8(sp)
    80006084:	6402                	ld	s0,0(sp)
    80006086:	0141                	addi	sp,sp,16
    80006088:	8082                	ret

000000008000608a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000608a:	1101                	addi	sp,sp,-32
    8000608c:	ec06                	sd	ra,24(sp)
    8000608e:	e822                	sd	s0,16(sp)
    80006090:	e426                	sd	s1,8(sp)
    80006092:	1000                	addi	s0,sp,32
    80006094:	84aa                	mv	s1,a0
  push_off();
    80006096:	00000097          	auipc	ra,0x0
    8000609a:	240080e7          	jalr	576(ra) # 800062d6 <push_off>

  if(panicked){
    8000609e:	00003797          	auipc	a5,0x3
    800060a2:	f7e7a783          	lw	a5,-130(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060a6:	10000737          	lui	a4,0x10000
  if(panicked){
    800060aa:	c391                	beqz	a5,800060ae <uartputc_sync+0x24>
    for(;;)
    800060ac:	a001                	j	800060ac <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060ae:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060b2:	0ff7f793          	andi	a5,a5,255
    800060b6:	0207f793          	andi	a5,a5,32
    800060ba:	dbf5                	beqz	a5,800060ae <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060bc:	0ff4f793          	andi	a5,s1,255
    800060c0:	10000737          	lui	a4,0x10000
    800060c4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800060c8:	00000097          	auipc	ra,0x0
    800060cc:	2ae080e7          	jalr	686(ra) # 80006376 <pop_off>
}
    800060d0:	60e2                	ld	ra,24(sp)
    800060d2:	6442                	ld	s0,16(sp)
    800060d4:	64a2                	ld	s1,8(sp)
    800060d6:	6105                	addi	sp,sp,32
    800060d8:	8082                	ret

00000000800060da <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060da:	00003717          	auipc	a4,0x3
    800060de:	f4673703          	ld	a4,-186(a4) # 80009020 <uart_tx_r>
    800060e2:	00003797          	auipc	a5,0x3
    800060e6:	f467b783          	ld	a5,-186(a5) # 80009028 <uart_tx_w>
    800060ea:	06e78c63          	beq	a5,a4,80006162 <uartstart+0x88>
{
    800060ee:	7139                	addi	sp,sp,-64
    800060f0:	fc06                	sd	ra,56(sp)
    800060f2:	f822                	sd	s0,48(sp)
    800060f4:	f426                	sd	s1,40(sp)
    800060f6:	f04a                	sd	s2,32(sp)
    800060f8:	ec4e                	sd	s3,24(sp)
    800060fa:	e852                	sd	s4,16(sp)
    800060fc:	e456                	sd	s5,8(sp)
    800060fe:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006100:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006104:	00020a17          	auipc	s4,0x20
    80006108:	104a0a13          	addi	s4,s4,260 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    8000610c:	00003497          	auipc	s1,0x3
    80006110:	f1448493          	addi	s1,s1,-236 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006114:	00003997          	auipc	s3,0x3
    80006118:	f1498993          	addi	s3,s3,-236 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000611c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006120:	0ff7f793          	andi	a5,a5,255
    80006124:	0207f793          	andi	a5,a5,32
    80006128:	c785                	beqz	a5,80006150 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000612a:	01f77793          	andi	a5,a4,31
    8000612e:	97d2                	add	a5,a5,s4
    80006130:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006134:	0705                	addi	a4,a4,1
    80006136:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006138:	8526                	mv	a0,s1
    8000613a:	ffffb097          	auipc	ra,0xffffb
    8000613e:	6ec080e7          	jalr	1772(ra) # 80001826 <wakeup>
    
    WriteReg(THR, c);
    80006142:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006146:	6098                	ld	a4,0(s1)
    80006148:	0009b783          	ld	a5,0(s3)
    8000614c:	fce798e3          	bne	a5,a4,8000611c <uartstart+0x42>
  }
}
    80006150:	70e2                	ld	ra,56(sp)
    80006152:	7442                	ld	s0,48(sp)
    80006154:	74a2                	ld	s1,40(sp)
    80006156:	7902                	ld	s2,32(sp)
    80006158:	69e2                	ld	s3,24(sp)
    8000615a:	6a42                	ld	s4,16(sp)
    8000615c:	6aa2                	ld	s5,8(sp)
    8000615e:	6121                	addi	sp,sp,64
    80006160:	8082                	ret
    80006162:	8082                	ret

0000000080006164 <uartputc>:
{
    80006164:	7179                	addi	sp,sp,-48
    80006166:	f406                	sd	ra,40(sp)
    80006168:	f022                	sd	s0,32(sp)
    8000616a:	ec26                	sd	s1,24(sp)
    8000616c:	e84a                	sd	s2,16(sp)
    8000616e:	e44e                	sd	s3,8(sp)
    80006170:	e052                	sd	s4,0(sp)
    80006172:	1800                	addi	s0,sp,48
    80006174:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006176:	00020517          	auipc	a0,0x20
    8000617a:	09250513          	addi	a0,a0,146 # 80026208 <uart_tx_lock>
    8000617e:	00000097          	auipc	ra,0x0
    80006182:	1a4080e7          	jalr	420(ra) # 80006322 <acquire>
  if(panicked){
    80006186:	00003797          	auipc	a5,0x3
    8000618a:	e967a783          	lw	a5,-362(a5) # 8000901c <panicked>
    8000618e:	c391                	beqz	a5,80006192 <uartputc+0x2e>
    for(;;)
    80006190:	a001                	j	80006190 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006192:	00003797          	auipc	a5,0x3
    80006196:	e967b783          	ld	a5,-362(a5) # 80009028 <uart_tx_w>
    8000619a:	00003717          	auipc	a4,0x3
    8000619e:	e8673703          	ld	a4,-378(a4) # 80009020 <uart_tx_r>
    800061a2:	02070713          	addi	a4,a4,32
    800061a6:	02f71b63          	bne	a4,a5,800061dc <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061aa:	00020a17          	auipc	s4,0x20
    800061ae:	05ea0a13          	addi	s4,s4,94 # 80026208 <uart_tx_lock>
    800061b2:	00003497          	auipc	s1,0x3
    800061b6:	e6e48493          	addi	s1,s1,-402 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061ba:	00003917          	auipc	s2,0x3
    800061be:	e6e90913          	addi	s2,s2,-402 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061c2:	85d2                	mv	a1,s4
    800061c4:	8526                	mv	a0,s1
    800061c6:	ffffb097          	auipc	ra,0xffffb
    800061ca:	4d4080e7          	jalr	1236(ra) # 8000169a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061ce:	00093783          	ld	a5,0(s2)
    800061d2:	6098                	ld	a4,0(s1)
    800061d4:	02070713          	addi	a4,a4,32
    800061d8:	fef705e3          	beq	a4,a5,800061c2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061dc:	00020497          	auipc	s1,0x20
    800061e0:	02c48493          	addi	s1,s1,44 # 80026208 <uart_tx_lock>
    800061e4:	01f7f713          	andi	a4,a5,31
    800061e8:	9726                	add	a4,a4,s1
    800061ea:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800061ee:	0785                	addi	a5,a5,1
    800061f0:	00003717          	auipc	a4,0x3
    800061f4:	e2f73c23          	sd	a5,-456(a4) # 80009028 <uart_tx_w>
      uartstart();
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	ee2080e7          	jalr	-286(ra) # 800060da <uartstart>
      release(&uart_tx_lock);
    80006200:	8526                	mv	a0,s1
    80006202:	00000097          	auipc	ra,0x0
    80006206:	1d4080e7          	jalr	468(ra) # 800063d6 <release>
}
    8000620a:	70a2                	ld	ra,40(sp)
    8000620c:	7402                	ld	s0,32(sp)
    8000620e:	64e2                	ld	s1,24(sp)
    80006210:	6942                	ld	s2,16(sp)
    80006212:	69a2                	ld	s3,8(sp)
    80006214:	6a02                	ld	s4,0(sp)
    80006216:	6145                	addi	sp,sp,48
    80006218:	8082                	ret

000000008000621a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000621a:	1141                	addi	sp,sp,-16
    8000621c:	e422                	sd	s0,8(sp)
    8000621e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006220:	100007b7          	lui	a5,0x10000
    80006224:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006228:	8b85                	andi	a5,a5,1
    8000622a:	cb91                	beqz	a5,8000623e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000622c:	100007b7          	lui	a5,0x10000
    80006230:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006234:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006238:	6422                	ld	s0,8(sp)
    8000623a:	0141                	addi	sp,sp,16
    8000623c:	8082                	ret
    return -1;
    8000623e:	557d                	li	a0,-1
    80006240:	bfe5                	j	80006238 <uartgetc+0x1e>

0000000080006242 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006242:	1101                	addi	sp,sp,-32
    80006244:	ec06                	sd	ra,24(sp)
    80006246:	e822                	sd	s0,16(sp)
    80006248:	e426                	sd	s1,8(sp)
    8000624a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000624c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000624e:	00000097          	auipc	ra,0x0
    80006252:	fcc080e7          	jalr	-52(ra) # 8000621a <uartgetc>
    if(c == -1)
    80006256:	00950763          	beq	a0,s1,80006264 <uartintr+0x22>
      break;
    consoleintr(c);
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	8fe080e7          	jalr	-1794(ra) # 80005b58 <consoleintr>
  while(1){
    80006262:	b7f5                	j	8000624e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006264:	00020497          	auipc	s1,0x20
    80006268:	fa448493          	addi	s1,s1,-92 # 80026208 <uart_tx_lock>
    8000626c:	8526                	mv	a0,s1
    8000626e:	00000097          	auipc	ra,0x0
    80006272:	0b4080e7          	jalr	180(ra) # 80006322 <acquire>
  uartstart();
    80006276:	00000097          	auipc	ra,0x0
    8000627a:	e64080e7          	jalr	-412(ra) # 800060da <uartstart>
  release(&uart_tx_lock);
    8000627e:	8526                	mv	a0,s1
    80006280:	00000097          	auipc	ra,0x0
    80006284:	156080e7          	jalr	342(ra) # 800063d6 <release>
}
    80006288:	60e2                	ld	ra,24(sp)
    8000628a:	6442                	ld	s0,16(sp)
    8000628c:	64a2                	ld	s1,8(sp)
    8000628e:	6105                	addi	sp,sp,32
    80006290:	8082                	ret

0000000080006292 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006292:	1141                	addi	sp,sp,-16
    80006294:	e422                	sd	s0,8(sp)
    80006296:	0800                	addi	s0,sp,16
  lk->name = name;
    80006298:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000629a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000629e:	00053823          	sd	zero,16(a0)
}
    800062a2:	6422                	ld	s0,8(sp)
    800062a4:	0141                	addi	sp,sp,16
    800062a6:	8082                	ret

00000000800062a8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062a8:	411c                	lw	a5,0(a0)
    800062aa:	e399                	bnez	a5,800062b0 <holding+0x8>
    800062ac:	4501                	li	a0,0
  return r;
}
    800062ae:	8082                	ret
{
    800062b0:	1101                	addi	sp,sp,-32
    800062b2:	ec06                	sd	ra,24(sp)
    800062b4:	e822                	sd	s0,16(sp)
    800062b6:	e426                	sd	s1,8(sp)
    800062b8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062ba:	6904                	ld	s1,16(a0)
    800062bc:	ffffb097          	auipc	ra,0xffffb
    800062c0:	c80080e7          	jalr	-896(ra) # 80000f3c <mycpu>
    800062c4:	40a48533          	sub	a0,s1,a0
    800062c8:	00153513          	seqz	a0,a0
}
    800062cc:	60e2                	ld	ra,24(sp)
    800062ce:	6442                	ld	s0,16(sp)
    800062d0:	64a2                	ld	s1,8(sp)
    800062d2:	6105                	addi	sp,sp,32
    800062d4:	8082                	ret

00000000800062d6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062d6:	1101                	addi	sp,sp,-32
    800062d8:	ec06                	sd	ra,24(sp)
    800062da:	e822                	sd	s0,16(sp)
    800062dc:	e426                	sd	s1,8(sp)
    800062de:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062e0:	100024f3          	csrr	s1,sstatus
    800062e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062e8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062ea:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062ee:	ffffb097          	auipc	ra,0xffffb
    800062f2:	c4e080e7          	jalr	-946(ra) # 80000f3c <mycpu>
    800062f6:	5d3c                	lw	a5,120(a0)
    800062f8:	cf89                	beqz	a5,80006312 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062fa:	ffffb097          	auipc	ra,0xffffb
    800062fe:	c42080e7          	jalr	-958(ra) # 80000f3c <mycpu>
    80006302:	5d3c                	lw	a5,120(a0)
    80006304:	2785                	addiw	a5,a5,1
    80006306:	dd3c                	sw	a5,120(a0)
}
    80006308:	60e2                	ld	ra,24(sp)
    8000630a:	6442                	ld	s0,16(sp)
    8000630c:	64a2                	ld	s1,8(sp)
    8000630e:	6105                	addi	sp,sp,32
    80006310:	8082                	ret
    mycpu()->intena = old;
    80006312:	ffffb097          	auipc	ra,0xffffb
    80006316:	c2a080e7          	jalr	-982(ra) # 80000f3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000631a:	8085                	srli	s1,s1,0x1
    8000631c:	8885                	andi	s1,s1,1
    8000631e:	dd64                	sw	s1,124(a0)
    80006320:	bfe9                	j	800062fa <push_off+0x24>

0000000080006322 <acquire>:
{
    80006322:	1101                	addi	sp,sp,-32
    80006324:	ec06                	sd	ra,24(sp)
    80006326:	e822                	sd	s0,16(sp)
    80006328:	e426                	sd	s1,8(sp)
    8000632a:	1000                	addi	s0,sp,32
    8000632c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000632e:	00000097          	auipc	ra,0x0
    80006332:	fa8080e7          	jalr	-88(ra) # 800062d6 <push_off>
  if(holding(lk))
    80006336:	8526                	mv	a0,s1
    80006338:	00000097          	auipc	ra,0x0
    8000633c:	f70080e7          	jalr	-144(ra) # 800062a8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006340:	4705                	li	a4,1
  if(holding(lk))
    80006342:	e115                	bnez	a0,80006366 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006344:	87ba                	mv	a5,a4
    80006346:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000634a:	2781                	sext.w	a5,a5
    8000634c:	ffe5                	bnez	a5,80006344 <acquire+0x22>
  __sync_synchronize();
    8000634e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006352:	ffffb097          	auipc	ra,0xffffb
    80006356:	bea080e7          	jalr	-1046(ra) # 80000f3c <mycpu>
    8000635a:	e888                	sd	a0,16(s1)
}
    8000635c:	60e2                	ld	ra,24(sp)
    8000635e:	6442                	ld	s0,16(sp)
    80006360:	64a2                	ld	s1,8(sp)
    80006362:	6105                	addi	sp,sp,32
    80006364:	8082                	ret
    panic("acquire");
    80006366:	00002517          	auipc	a0,0x2
    8000636a:	4f250513          	addi	a0,a0,1266 # 80008858 <digits+0x20>
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	a6a080e7          	jalr	-1430(ra) # 80005dd8 <panic>

0000000080006376 <pop_off>:

void
pop_off(void)
{
    80006376:	1141                	addi	sp,sp,-16
    80006378:	e406                	sd	ra,8(sp)
    8000637a:	e022                	sd	s0,0(sp)
    8000637c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000637e:	ffffb097          	auipc	ra,0xffffb
    80006382:	bbe080e7          	jalr	-1090(ra) # 80000f3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006386:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000638a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000638c:	e78d                	bnez	a5,800063b6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000638e:	5d3c                	lw	a5,120(a0)
    80006390:	02f05b63          	blez	a5,800063c6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006394:	37fd                	addiw	a5,a5,-1
    80006396:	0007871b          	sext.w	a4,a5
    8000639a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000639c:	eb09                	bnez	a4,800063ae <pop_off+0x38>
    8000639e:	5d7c                	lw	a5,124(a0)
    800063a0:	c799                	beqz	a5,800063ae <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063a2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063a6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063aa:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063ae:	60a2                	ld	ra,8(sp)
    800063b0:	6402                	ld	s0,0(sp)
    800063b2:	0141                	addi	sp,sp,16
    800063b4:	8082                	ret
    panic("pop_off - interruptible");
    800063b6:	00002517          	auipc	a0,0x2
    800063ba:	4aa50513          	addi	a0,a0,1194 # 80008860 <digits+0x28>
    800063be:	00000097          	auipc	ra,0x0
    800063c2:	a1a080e7          	jalr	-1510(ra) # 80005dd8 <panic>
    panic("pop_off");
    800063c6:	00002517          	auipc	a0,0x2
    800063ca:	4b250513          	addi	a0,a0,1202 # 80008878 <digits+0x40>
    800063ce:	00000097          	auipc	ra,0x0
    800063d2:	a0a080e7          	jalr	-1526(ra) # 80005dd8 <panic>

00000000800063d6 <release>:
{
    800063d6:	1101                	addi	sp,sp,-32
    800063d8:	ec06                	sd	ra,24(sp)
    800063da:	e822                	sd	s0,16(sp)
    800063dc:	e426                	sd	s1,8(sp)
    800063de:	1000                	addi	s0,sp,32
    800063e0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063e2:	00000097          	auipc	ra,0x0
    800063e6:	ec6080e7          	jalr	-314(ra) # 800062a8 <holding>
    800063ea:	c115                	beqz	a0,8000640e <release+0x38>
  lk->cpu = 0;
    800063ec:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063f0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063f4:	0f50000f          	fence	iorw,ow
    800063f8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063fc:	00000097          	auipc	ra,0x0
    80006400:	f7a080e7          	jalr	-134(ra) # 80006376 <pop_off>
}
    80006404:	60e2                	ld	ra,24(sp)
    80006406:	6442                	ld	s0,16(sp)
    80006408:	64a2                	ld	s1,8(sp)
    8000640a:	6105                	addi	sp,sp,32
    8000640c:	8082                	ret
    panic("release");
    8000640e:	00002517          	auipc	a0,0x2
    80006412:	47250513          	addi	a0,a0,1138 # 80008880 <digits+0x48>
    80006416:	00000097          	auipc	ra,0x0
    8000641a:	9c2080e7          	jalr	-1598(ra) # 80005dd8 <panic>
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
