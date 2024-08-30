
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	86013103          	ld	sp,-1952(sp) # 80008860 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	073050ef          	jal	ra,80005888 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7179                	addi	sp,sp,-48
    8000001e:	f406                	sd	ra,40(sp)
    80000020:	f022                	sd	s0,32(sp)
    80000022:	ec26                	sd	s1,24(sp)
    80000024:	e84a                	sd	s2,16(sp)
    80000026:	e44e                	sd	s3,8(sp)
    80000028:	1800                	addi	s0,sp,48
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002a:	03451793          	slli	a5,a0,0x34
    8000002e:	e3ad                	bnez	a5,80000090 <kfree+0x74>
    80000030:	84aa                	mv	s1,a0
    80000032:	00246797          	auipc	a5,0x246
    80000036:	20e78793          	addi	a5,a5,526 # 80246240 <end>
    8000003a:	04f56b63          	bltu	a0,a5,80000090 <kfree+0x74>
    8000003e:	47c5                	li	a5,17
    80000040:	07ee                	slli	a5,a5,0x1b
    80000042:	04f57763          	bgeu	a0,a5,80000090 <kfree+0x74>
    panic("kfree");

  int temp;
  acquire(&ref_count_lock);
    80000046:	00009917          	auipc	s2,0x9
    8000004a:	fea90913          	addi	s2,s2,-22 # 80009030 <ref_count_lock>
    8000004e:	854a                	mv	a0,s2
    80000050:	00006097          	auipc	ra,0x6
    80000054:	232080e7          	jalr	562(ra) # 80006282 <acquire>
  // decrease the reference count, if use reference is not zero, then return
  useReference[(uint64)pa/PGSIZE] -= 1;
    80000058:	00c4d793          	srli	a5,s1,0xc
    8000005c:	00279713          	slli	a4,a5,0x2
    80000060:	00009797          	auipc	a5,0x9
    80000064:	00878793          	addi	a5,a5,8 # 80009068 <useReference>
    80000068:	97ba                	add	a5,a5,a4
    8000006a:	4398                	lw	a4,0(a5)
    8000006c:	377d                	addiw	a4,a4,-1
    8000006e:	0007099b          	sext.w	s3,a4
    80000072:	c398                	sw	a4,0(a5)
  temp = useReference[(uint64)pa/PGSIZE];
  release(&ref_count_lock);
    80000074:	854a                	mv	a0,s2
    80000076:	00006097          	auipc	ra,0x6
    8000007a:	2c0080e7          	jalr	704(ra) # 80006336 <release>
  if (temp > 0)
    8000007e:	03305163          	blez	s3,800000a0 <kfree+0x84>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    80000082:	70a2                	ld	ra,40(sp)
    80000084:	7402                	ld	s0,32(sp)
    80000086:	64e2                	ld	s1,24(sp)
    80000088:	6942                	ld	s2,16(sp)
    8000008a:	69a2                	ld	s3,8(sp)
    8000008c:	6145                	addi	sp,sp,48
    8000008e:	8082                	ret
    panic("kfree");
    80000090:	00008517          	auipc	a0,0x8
    80000094:	f8050513          	addi	a0,a0,-128 # 80008010 <etext+0x10>
    80000098:	00006097          	auipc	ra,0x6
    8000009c:	ca0080e7          	jalr	-864(ra) # 80005d38 <panic>
  memset(pa, 1, PGSIZE);
    800000a0:	6605                	lui	a2,0x1
    800000a2:	4585                	li	a1,1
    800000a4:	8526                	mv	a0,s1
    800000a6:	00000097          	auipc	ra,0x0
    800000aa:	154080e7          	jalr	340(ra) # 800001fa <memset>
  acquire(&kmem.lock);
    800000ae:	89ca                	mv	s3,s2
    800000b0:	00009917          	auipc	s2,0x9
    800000b4:	f9890913          	addi	s2,s2,-104 # 80009048 <kmem>
    800000b8:	854a                	mv	a0,s2
    800000ba:	00006097          	auipc	ra,0x6
    800000be:	1c8080e7          	jalr	456(ra) # 80006282 <acquire>
  r->next = kmem.freelist;
    800000c2:	0309b783          	ld	a5,48(s3)
    800000c6:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000c8:	0299b823          	sd	s1,48(s3)
  release(&kmem.lock);
    800000cc:	854a                	mv	a0,s2
    800000ce:	00006097          	auipc	ra,0x6
    800000d2:	268080e7          	jalr	616(ra) # 80006336 <release>
    800000d6:	b775                	j	80000082 <kfree+0x66>

00000000800000d8 <freerange>:
{
    800000d8:	7179                	addi	sp,sp,-48
    800000da:	f406                	sd	ra,40(sp)
    800000dc:	f022                	sd	s0,32(sp)
    800000de:	ec26                	sd	s1,24(sp)
    800000e0:	e84a                	sd	s2,16(sp)
    800000e2:	e44e                	sd	s3,8(sp)
    800000e4:	e052                	sd	s4,0(sp)
    800000e6:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000e8:	6785                	lui	a5,0x1
    800000ea:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000ee:	94aa                	add	s1,s1,a0
    800000f0:	757d                	lui	a0,0xfffff
    800000f2:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f4:	94be                	add	s1,s1,a5
    800000f6:	0095ee63          	bltu	a1,s1,80000112 <freerange+0x3a>
    800000fa:	892e                	mv	s2,a1
    kfree(p);
    800000fc:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000fe:	6985                	lui	s3,0x1
    kfree(p);
    80000100:	01448533          	add	a0,s1,s4
    80000104:	00000097          	auipc	ra,0x0
    80000108:	f18080e7          	jalr	-232(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000010c:	94ce                	add	s1,s1,s3
    8000010e:	fe9979e3          	bgeu	s2,s1,80000100 <freerange+0x28>
}
    80000112:	70a2                	ld	ra,40(sp)
    80000114:	7402                	ld	s0,32(sp)
    80000116:	64e2                	ld	s1,24(sp)
    80000118:	6942                	ld	s2,16(sp)
    8000011a:	69a2                	ld	s3,8(sp)
    8000011c:	6a02                	ld	s4,0(sp)
    8000011e:	6145                	addi	sp,sp,48
    80000120:	8082                	ret

0000000080000122 <kinit>:
{
    80000122:	1141                	addi	sp,sp,-16
    80000124:	e406                	sd	ra,8(sp)
    80000126:	e022                	sd	s0,0(sp)
    80000128:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000012a:	00008597          	auipc	a1,0x8
    8000012e:	eee58593          	addi	a1,a1,-274 # 80008018 <etext+0x18>
    80000132:	00009517          	auipc	a0,0x9
    80000136:	f1650513          	addi	a0,a0,-234 # 80009048 <kmem>
    8000013a:	00006097          	auipc	ra,0x6
    8000013e:	0b8080e7          	jalr	184(ra) # 800061f2 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000142:	45c5                	li	a1,17
    80000144:	05ee                	slli	a1,a1,0x1b
    80000146:	00246517          	auipc	a0,0x246
    8000014a:	0fa50513          	addi	a0,a0,250 # 80246240 <end>
    8000014e:	00000097          	auipc	ra,0x0
    80000152:	f8a080e7          	jalr	-118(ra) # 800000d8 <freerange>
}
    80000156:	60a2                	ld	ra,8(sp)
    80000158:	6402                	ld	s0,0(sp)
    8000015a:	0141                	addi	sp,sp,16
    8000015c:	8082                	ret

000000008000015e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000015e:	1101                	addi	sp,sp,-32
    80000160:	ec06                	sd	ra,24(sp)
    80000162:	e822                	sd	s0,16(sp)
    80000164:	e426                	sd	s1,8(sp)
    80000166:	e04a                	sd	s2,0(sp)
    80000168:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000016a:	00009517          	auipc	a0,0x9
    8000016e:	ede50513          	addi	a0,a0,-290 # 80009048 <kmem>
    80000172:	00006097          	auipc	ra,0x6
    80000176:	110080e7          	jalr	272(ra) # 80006282 <acquire>
  r = kmem.freelist;
    8000017a:	00009497          	auipc	s1,0x9
    8000017e:	ee64b483          	ld	s1,-282(s1) # 80009060 <kmem+0x18>
  if(r){
    80000182:	c0bd                	beqz	s1,800001e8 <kalloc+0x8a>
    kmem.freelist = r->next;
    80000184:	609c                	ld	a5,0(s1)
    80000186:	00009917          	auipc	s2,0x9
    8000018a:	eaa90913          	addi	s2,s2,-342 # 80009030 <ref_count_lock>
    8000018e:	02f93823          	sd	a5,48(s2)
    acquire(&ref_count_lock);
    80000192:	854a                	mv	a0,s2
    80000194:	00006097          	auipc	ra,0x6
    80000198:	0ee080e7          	jalr	238(ra) # 80006282 <acquire>
    // initialization the ref count to 1
    useReference[(uint64)r / PGSIZE] = 1;
    8000019c:	00c4d793          	srli	a5,s1,0xc
    800001a0:	00279713          	slli	a4,a5,0x2
    800001a4:	00009797          	auipc	a5,0x9
    800001a8:	ec478793          	addi	a5,a5,-316 # 80009068 <useReference>
    800001ac:	97ba                	add	a5,a5,a4
    800001ae:	4705                	li	a4,1
    800001b0:	c398                	sw	a4,0(a5)
    release(&ref_count_lock);
    800001b2:	854a                	mv	a0,s2
    800001b4:	00006097          	auipc	ra,0x6
    800001b8:	182080e7          	jalr	386(ra) # 80006336 <release>
  }
  release(&kmem.lock);
    800001bc:	00009517          	auipc	a0,0x9
    800001c0:	e8c50513          	addi	a0,a0,-372 # 80009048 <kmem>
    800001c4:	00006097          	auipc	ra,0x6
    800001c8:	172080e7          	jalr	370(ra) # 80006336 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001cc:	6605                	lui	a2,0x1
    800001ce:	4595                	li	a1,5
    800001d0:	8526                	mv	a0,s1
    800001d2:	00000097          	auipc	ra,0x0
    800001d6:	028080e7          	jalr	40(ra) # 800001fa <memset>
  return (void*)r;
    800001da:	8526                	mv	a0,s1
    800001dc:	60e2                	ld	ra,24(sp)
    800001de:	6442                	ld	s0,16(sp)
    800001e0:	64a2                	ld	s1,8(sp)
    800001e2:	6902                	ld	s2,0(sp)
    800001e4:	6105                	addi	sp,sp,32
    800001e6:	8082                	ret
  release(&kmem.lock);
    800001e8:	00009517          	auipc	a0,0x9
    800001ec:	e6050513          	addi	a0,a0,-416 # 80009048 <kmem>
    800001f0:	00006097          	auipc	ra,0x6
    800001f4:	146080e7          	jalr	326(ra) # 80006336 <release>
  if(r)
    800001f8:	b7cd                	j	800001da <kalloc+0x7c>

00000000800001fa <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001fa:	1141                	addi	sp,sp,-16
    800001fc:	e422                	sd	s0,8(sp)
    800001fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000200:	ce09                	beqz	a2,8000021a <memset+0x20>
    80000202:	87aa                	mv	a5,a0
    80000204:	fff6071b          	addiw	a4,a2,-1
    80000208:	1702                	slli	a4,a4,0x20
    8000020a:	9301                	srli	a4,a4,0x20
    8000020c:	0705                	addi	a4,a4,1
    8000020e:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000210:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000214:	0785                	addi	a5,a5,1
    80000216:	fee79de3          	bne	a5,a4,80000210 <memset+0x16>
  }
  return dst;
}
    8000021a:	6422                	ld	s0,8(sp)
    8000021c:	0141                	addi	sp,sp,16
    8000021e:	8082                	ret

0000000080000220 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000220:	1141                	addi	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000226:	ca05                	beqz	a2,80000256 <memcmp+0x36>
    80000228:	fff6069b          	addiw	a3,a2,-1
    8000022c:	1682                	slli	a3,a3,0x20
    8000022e:	9281                	srli	a3,a3,0x20
    80000230:	0685                	addi	a3,a3,1
    80000232:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000234:	00054783          	lbu	a5,0(a0)
    80000238:	0005c703          	lbu	a4,0(a1)
    8000023c:	00e79863          	bne	a5,a4,8000024c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000240:	0505                	addi	a0,a0,1
    80000242:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000244:	fed518e3          	bne	a0,a3,80000234 <memcmp+0x14>
  }

  return 0;
    80000248:	4501                	li	a0,0
    8000024a:	a019                	j	80000250 <memcmp+0x30>
      return *s1 - *s2;
    8000024c:	40e7853b          	subw	a0,a5,a4
}
    80000250:	6422                	ld	s0,8(sp)
    80000252:	0141                	addi	sp,sp,16
    80000254:	8082                	ret
  return 0;
    80000256:	4501                	li	a0,0
    80000258:	bfe5                	j	80000250 <memcmp+0x30>

000000008000025a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000025a:	1141                	addi	sp,sp,-16
    8000025c:	e422                	sd	s0,8(sp)
    8000025e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000260:	ca0d                	beqz	a2,80000292 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000262:	00a5f963          	bgeu	a1,a0,80000274 <memmove+0x1a>
    80000266:	02061693          	slli	a3,a2,0x20
    8000026a:	9281                	srli	a3,a3,0x20
    8000026c:	00d58733          	add	a4,a1,a3
    80000270:	02e56463          	bltu	a0,a4,80000298 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000274:	fff6079b          	addiw	a5,a2,-1
    80000278:	1782                	slli	a5,a5,0x20
    8000027a:	9381                	srli	a5,a5,0x20
    8000027c:	0785                	addi	a5,a5,1
    8000027e:	97ae                	add	a5,a5,a1
    80000280:	872a                	mv	a4,a0
      *d++ = *s++;
    80000282:	0585                	addi	a1,a1,1
    80000284:	0705                	addi	a4,a4,1
    80000286:	fff5c683          	lbu	a3,-1(a1)
    8000028a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000028e:	fef59ae3          	bne	a1,a5,80000282 <memmove+0x28>

  return dst;
}
    80000292:	6422                	ld	s0,8(sp)
    80000294:	0141                	addi	sp,sp,16
    80000296:	8082                	ret
    d += n;
    80000298:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000029a:	fff6079b          	addiw	a5,a2,-1
    8000029e:	1782                	slli	a5,a5,0x20
    800002a0:	9381                	srli	a5,a5,0x20
    800002a2:	fff7c793          	not	a5,a5
    800002a6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800002a8:	177d                	addi	a4,a4,-1
    800002aa:	16fd                	addi	a3,a3,-1
    800002ac:	00074603          	lbu	a2,0(a4)
    800002b0:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800002b4:	fef71ae3          	bne	a4,a5,800002a8 <memmove+0x4e>
    800002b8:	bfe9                	j	80000292 <memmove+0x38>

00000000800002ba <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800002ba:	1141                	addi	sp,sp,-16
    800002bc:	e406                	sd	ra,8(sp)
    800002be:	e022                	sd	s0,0(sp)
    800002c0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	f98080e7          	jalr	-104(ra) # 8000025a <memmove>
}
    800002ca:	60a2                	ld	ra,8(sp)
    800002cc:	6402                	ld	s0,0(sp)
    800002ce:	0141                	addi	sp,sp,16
    800002d0:	8082                	ret

00000000800002d2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800002d2:	1141                	addi	sp,sp,-16
    800002d4:	e422                	sd	s0,8(sp)
    800002d6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002d8:	ce11                	beqz	a2,800002f4 <strncmp+0x22>
    800002da:	00054783          	lbu	a5,0(a0)
    800002de:	cf89                	beqz	a5,800002f8 <strncmp+0x26>
    800002e0:	0005c703          	lbu	a4,0(a1)
    800002e4:	00f71a63          	bne	a4,a5,800002f8 <strncmp+0x26>
    n--, p++, q++;
    800002e8:	367d                	addiw	a2,a2,-1
    800002ea:	0505                	addi	a0,a0,1
    800002ec:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002ee:	f675                	bnez	a2,800002da <strncmp+0x8>
  if(n == 0)
    return 0;
    800002f0:	4501                	li	a0,0
    800002f2:	a809                	j	80000304 <strncmp+0x32>
    800002f4:	4501                	li	a0,0
    800002f6:	a039                	j	80000304 <strncmp+0x32>
  if(n == 0)
    800002f8:	ca09                	beqz	a2,8000030a <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002fa:	00054503          	lbu	a0,0(a0)
    800002fe:	0005c783          	lbu	a5,0(a1)
    80000302:	9d1d                	subw	a0,a0,a5
}
    80000304:	6422                	ld	s0,8(sp)
    80000306:	0141                	addi	sp,sp,16
    80000308:	8082                	ret
    return 0;
    8000030a:	4501                	li	a0,0
    8000030c:	bfe5                	j	80000304 <strncmp+0x32>

000000008000030e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000030e:	1141                	addi	sp,sp,-16
    80000310:	e422                	sd	s0,8(sp)
    80000312:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000314:	872a                	mv	a4,a0
    80000316:	8832                	mv	a6,a2
    80000318:	367d                	addiw	a2,a2,-1
    8000031a:	01005963          	blez	a6,8000032c <strncpy+0x1e>
    8000031e:	0705                	addi	a4,a4,1
    80000320:	0005c783          	lbu	a5,0(a1)
    80000324:	fef70fa3          	sb	a5,-1(a4)
    80000328:	0585                	addi	a1,a1,1
    8000032a:	f7f5                	bnez	a5,80000316 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000032c:	00c05d63          	blez	a2,80000346 <strncpy+0x38>
    80000330:	86ba                	mv	a3,a4
    *s++ = 0;
    80000332:	0685                	addi	a3,a3,1
    80000334:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000338:	fff6c793          	not	a5,a3
    8000033c:	9fb9                	addw	a5,a5,a4
    8000033e:	010787bb          	addw	a5,a5,a6
    80000342:	fef048e3          	bgtz	a5,80000332 <strncpy+0x24>
  return os;
}
    80000346:	6422                	ld	s0,8(sp)
    80000348:	0141                	addi	sp,sp,16
    8000034a:	8082                	ret

000000008000034c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000034c:	1141                	addi	sp,sp,-16
    8000034e:	e422                	sd	s0,8(sp)
    80000350:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000352:	02c05363          	blez	a2,80000378 <safestrcpy+0x2c>
    80000356:	fff6069b          	addiw	a3,a2,-1
    8000035a:	1682                	slli	a3,a3,0x20
    8000035c:	9281                	srli	a3,a3,0x20
    8000035e:	96ae                	add	a3,a3,a1
    80000360:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000362:	00d58963          	beq	a1,a3,80000374 <safestrcpy+0x28>
    80000366:	0585                	addi	a1,a1,1
    80000368:	0785                	addi	a5,a5,1
    8000036a:	fff5c703          	lbu	a4,-1(a1)
    8000036e:	fee78fa3          	sb	a4,-1(a5)
    80000372:	fb65                	bnez	a4,80000362 <safestrcpy+0x16>
    ;
  *s = 0;
    80000374:	00078023          	sb	zero,0(a5)
  return os;
}
    80000378:	6422                	ld	s0,8(sp)
    8000037a:	0141                	addi	sp,sp,16
    8000037c:	8082                	ret

000000008000037e <strlen>:

int
strlen(const char *s)
{
    8000037e:	1141                	addi	sp,sp,-16
    80000380:	e422                	sd	s0,8(sp)
    80000382:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000384:	00054783          	lbu	a5,0(a0)
    80000388:	cf91                	beqz	a5,800003a4 <strlen+0x26>
    8000038a:	0505                	addi	a0,a0,1
    8000038c:	87aa                	mv	a5,a0
    8000038e:	4685                	li	a3,1
    80000390:	9e89                	subw	a3,a3,a0
    80000392:	00f6853b          	addw	a0,a3,a5
    80000396:	0785                	addi	a5,a5,1
    80000398:	fff7c703          	lbu	a4,-1(a5)
    8000039c:	fb7d                	bnez	a4,80000392 <strlen+0x14>
    ;
  return n;
}
    8000039e:	6422                	ld	s0,8(sp)
    800003a0:	0141                	addi	sp,sp,16
    800003a2:	8082                	ret
  for(n = 0; s[n]; n++)
    800003a4:	4501                	li	a0,0
    800003a6:	bfe5                	j	8000039e <strlen+0x20>

00000000800003a8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800003a8:	1141                	addi	sp,sp,-16
    800003aa:	e406                	sd	ra,8(sp)
    800003ac:	e022                	sd	s0,0(sp)
    800003ae:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800003b0:	00001097          	auipc	ra,0x1
    800003b4:	bca080e7          	jalr	-1078(ra) # 80000f7a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800003b8:	00009717          	auipc	a4,0x9
    800003bc:	c4870713          	addi	a4,a4,-952 # 80009000 <started>
  if(cpuid() == 0){
    800003c0:	c139                	beqz	a0,80000406 <main+0x5e>
    while(started == 0)
    800003c2:	431c                	lw	a5,0(a4)
    800003c4:	2781                	sext.w	a5,a5
    800003c6:	dff5                	beqz	a5,800003c2 <main+0x1a>
      ;
    __sync_synchronize();
    800003c8:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800003cc:	00001097          	auipc	ra,0x1
    800003d0:	bae080e7          	jalr	-1106(ra) # 80000f7a <cpuid>
    800003d4:	85aa                	mv	a1,a0
    800003d6:	00008517          	auipc	a0,0x8
    800003da:	c6250513          	addi	a0,a0,-926 # 80008038 <etext+0x38>
    800003de:	00006097          	auipc	ra,0x6
    800003e2:	9a4080e7          	jalr	-1628(ra) # 80005d82 <printf>
    kvminithart();    // turn on paging
    800003e6:	00000097          	auipc	ra,0x0
    800003ea:	0d8080e7          	jalr	216(ra) # 800004be <kvminithart>
    trapinithart();   // install kernel trap vector
    800003ee:	00002097          	auipc	ra,0x2
    800003f2:	804080e7          	jalr	-2044(ra) # 80001bf2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	e1a080e7          	jalr	-486(ra) # 80005210 <plicinithart>
  }

  scheduler();        
    800003fe:	00001097          	auipc	ra,0x1
    80000402:	0b2080e7          	jalr	178(ra) # 800014b0 <scheduler>
    consoleinit();
    80000406:	00006097          	auipc	ra,0x6
    8000040a:	844080e7          	jalr	-1980(ra) # 80005c4a <consoleinit>
    printfinit();
    8000040e:	00006097          	auipc	ra,0x6
    80000412:	b5a080e7          	jalr	-1190(ra) # 80005f68 <printfinit>
    printf("\n");
    80000416:	00008517          	auipc	a0,0x8
    8000041a:	c3250513          	addi	a0,a0,-974 # 80008048 <etext+0x48>
    8000041e:	00006097          	auipc	ra,0x6
    80000422:	964080e7          	jalr	-1692(ra) # 80005d82 <printf>
    printf("xv6 kernel is booting\n");
    80000426:	00008517          	auipc	a0,0x8
    8000042a:	bfa50513          	addi	a0,a0,-1030 # 80008020 <etext+0x20>
    8000042e:	00006097          	auipc	ra,0x6
    80000432:	954080e7          	jalr	-1708(ra) # 80005d82 <printf>
    printf("\n");
    80000436:	00008517          	auipc	a0,0x8
    8000043a:	c1250513          	addi	a0,a0,-1006 # 80008048 <etext+0x48>
    8000043e:	00006097          	auipc	ra,0x6
    80000442:	944080e7          	jalr	-1724(ra) # 80005d82 <printf>
    kinit();         // physical page allocator
    80000446:	00000097          	auipc	ra,0x0
    8000044a:	cdc080e7          	jalr	-804(ra) # 80000122 <kinit>
    kvminit();       // create kernel page table
    8000044e:	00000097          	auipc	ra,0x0
    80000452:	322080e7          	jalr	802(ra) # 80000770 <kvminit>
    kvminithart();   // turn on paging
    80000456:	00000097          	auipc	ra,0x0
    8000045a:	068080e7          	jalr	104(ra) # 800004be <kvminithart>
    procinit();      // process table
    8000045e:	00001097          	auipc	ra,0x1
    80000462:	a6c080e7          	jalr	-1428(ra) # 80000eca <procinit>
    trapinit();      // trap vectors
    80000466:	00001097          	auipc	ra,0x1
    8000046a:	764080e7          	jalr	1892(ra) # 80001bca <trapinit>
    trapinithart();  // install kernel trap vector
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	784080e7          	jalr	1924(ra) # 80001bf2 <trapinithart>
    plicinit();      // set up interrupt controller
    80000476:	00005097          	auipc	ra,0x5
    8000047a:	d84080e7          	jalr	-636(ra) # 800051fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000047e:	00005097          	auipc	ra,0x5
    80000482:	d92080e7          	jalr	-622(ra) # 80005210 <plicinithart>
    binit();         // buffer cache
    80000486:	00002097          	auipc	ra,0x2
    8000048a:	f6e080e7          	jalr	-146(ra) # 800023f4 <binit>
    iinit();         // inode table
    8000048e:	00002097          	auipc	ra,0x2
    80000492:	5fe080e7          	jalr	1534(ra) # 80002a8c <iinit>
    fileinit();      // file table
    80000496:	00003097          	auipc	ra,0x3
    8000049a:	5a8080e7          	jalr	1448(ra) # 80003a3e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000049e:	00005097          	auipc	ra,0x5
    800004a2:	e94080e7          	jalr	-364(ra) # 80005332 <virtio_disk_init>
    userinit();      // first user process
    800004a6:	00001097          	auipc	ra,0x1
    800004aa:	dd8080e7          	jalr	-552(ra) # 8000127e <userinit>
    __sync_synchronize();
    800004ae:	0ff0000f          	fence
    started = 1;
    800004b2:	4785                	li	a5,1
    800004b4:	00009717          	auipc	a4,0x9
    800004b8:	b4f72623          	sw	a5,-1204(a4) # 80009000 <started>
    800004bc:	b789                	j	800003fe <main+0x56>

00000000800004be <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800004be:	1141                	addi	sp,sp,-16
    800004c0:	e422                	sd	s0,8(sp)
    800004c2:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800004c4:	00009797          	auipc	a5,0x9
    800004c8:	b447b783          	ld	a5,-1212(a5) # 80009008 <kernel_pagetable>
    800004cc:	83b1                	srli	a5,a5,0xc
    800004ce:	577d                	li	a4,-1
    800004d0:	177e                	slli	a4,a4,0x3f
    800004d2:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800004d4:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004d8:	12000073          	sfence.vma
  sfence_vma();
}
    800004dc:	6422                	ld	s0,8(sp)
    800004de:	0141                	addi	sp,sp,16
    800004e0:	8082                	ret

00000000800004e2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004e2:	7139                	addi	sp,sp,-64
    800004e4:	fc06                	sd	ra,56(sp)
    800004e6:	f822                	sd	s0,48(sp)
    800004e8:	f426                	sd	s1,40(sp)
    800004ea:	f04a                	sd	s2,32(sp)
    800004ec:	ec4e                	sd	s3,24(sp)
    800004ee:	e852                	sd	s4,16(sp)
    800004f0:	e456                	sd	s5,8(sp)
    800004f2:	e05a                	sd	s6,0(sp)
    800004f4:	0080                	addi	s0,sp,64
    800004f6:	84aa                	mv	s1,a0
    800004f8:	89ae                	mv	s3,a1
    800004fa:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004fc:	57fd                	li	a5,-1
    800004fe:	83e9                	srli	a5,a5,0x1a
    80000500:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000502:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000504:	04b7f263          	bgeu	a5,a1,80000548 <walk+0x66>
    panic("walk");
    80000508:	00008517          	auipc	a0,0x8
    8000050c:	b4850513          	addi	a0,a0,-1208 # 80008050 <etext+0x50>
    80000510:	00006097          	auipc	ra,0x6
    80000514:	828080e7          	jalr	-2008(ra) # 80005d38 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000518:	060a8663          	beqz	s5,80000584 <walk+0xa2>
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	c42080e7          	jalr	-958(ra) # 8000015e <kalloc>
    80000524:	84aa                	mv	s1,a0
    80000526:	c529                	beqz	a0,80000570 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000528:	6605                	lui	a2,0x1
    8000052a:	4581                	li	a1,0
    8000052c:	00000097          	auipc	ra,0x0
    80000530:	cce080e7          	jalr	-818(ra) # 800001fa <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000534:	00c4d793          	srli	a5,s1,0xc
    80000538:	07aa                	slli	a5,a5,0xa
    8000053a:	0017e793          	ori	a5,a5,1
    8000053e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000542:	3a5d                	addiw	s4,s4,-9
    80000544:	036a0063          	beq	s4,s6,80000564 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000548:	0149d933          	srl	s2,s3,s4
    8000054c:	1ff97913          	andi	s2,s2,511
    80000550:	090e                	slli	s2,s2,0x3
    80000552:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000554:	00093483          	ld	s1,0(s2)
    80000558:	0014f793          	andi	a5,s1,1
    8000055c:	dfd5                	beqz	a5,80000518 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000055e:	80a9                	srli	s1,s1,0xa
    80000560:	04b2                	slli	s1,s1,0xc
    80000562:	b7c5                	j	80000542 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000564:	00c9d513          	srli	a0,s3,0xc
    80000568:	1ff57513          	andi	a0,a0,511
    8000056c:	050e                	slli	a0,a0,0x3
    8000056e:	9526                	add	a0,a0,s1
}
    80000570:	70e2                	ld	ra,56(sp)
    80000572:	7442                	ld	s0,48(sp)
    80000574:	74a2                	ld	s1,40(sp)
    80000576:	7902                	ld	s2,32(sp)
    80000578:	69e2                	ld	s3,24(sp)
    8000057a:	6a42                	ld	s4,16(sp)
    8000057c:	6aa2                	ld	s5,8(sp)
    8000057e:	6b02                	ld	s6,0(sp)
    80000580:	6121                	addi	sp,sp,64
    80000582:	8082                	ret
        return 0;
    80000584:	4501                	li	a0,0
    80000586:	b7ed                	j	80000570 <walk+0x8e>

0000000080000588 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000588:	57fd                	li	a5,-1
    8000058a:	83e9                	srli	a5,a5,0x1a
    8000058c:	00b7f463          	bgeu	a5,a1,80000594 <walkaddr+0xc>
    return 0;
    80000590:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000592:	8082                	ret
{
    80000594:	1141                	addi	sp,sp,-16
    80000596:	e406                	sd	ra,8(sp)
    80000598:	e022                	sd	s0,0(sp)
    8000059a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000059c:	4601                	li	a2,0
    8000059e:	00000097          	auipc	ra,0x0
    800005a2:	f44080e7          	jalr	-188(ra) # 800004e2 <walk>
  if(pte == 0)
    800005a6:	c105                	beqz	a0,800005c6 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800005a8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800005aa:	0117f693          	andi	a3,a5,17
    800005ae:	4745                	li	a4,17
    return 0;
    800005b0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800005b2:	00e68663          	beq	a3,a4,800005be <walkaddr+0x36>
}
    800005b6:	60a2                	ld	ra,8(sp)
    800005b8:	6402                	ld	s0,0(sp)
    800005ba:	0141                	addi	sp,sp,16
    800005bc:	8082                	ret
  pa = PTE2PA(*pte);
    800005be:	00a7d513          	srli	a0,a5,0xa
    800005c2:	0532                	slli	a0,a0,0xc
  return pa;
    800005c4:	bfcd                	j	800005b6 <walkaddr+0x2e>
    return 0;
    800005c6:	4501                	li	a0,0
    800005c8:	b7fd                	j	800005b6 <walkaddr+0x2e>

00000000800005ca <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800005ca:	715d                	addi	sp,sp,-80
    800005cc:	e486                	sd	ra,72(sp)
    800005ce:	e0a2                	sd	s0,64(sp)
    800005d0:	fc26                	sd	s1,56(sp)
    800005d2:	f84a                	sd	s2,48(sp)
    800005d4:	f44e                	sd	s3,40(sp)
    800005d6:	f052                	sd	s4,32(sp)
    800005d8:	ec56                	sd	s5,24(sp)
    800005da:	e85a                	sd	s6,16(sp)
    800005dc:	e45e                	sd	s7,8(sp)
    800005de:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005e0:	c205                	beqz	a2,80000600 <mappages+0x36>
    800005e2:	8aaa                	mv	s5,a0
    800005e4:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    800005e6:	77fd                	lui	a5,0xfffff
    800005e8:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005ec:	15fd                	addi	a1,a1,-1
    800005ee:	00c589b3          	add	s3,a1,a2
    800005f2:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005f6:	8952                	mv	s2,s4
    800005f8:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005fc:	6b85                	lui	s7,0x1
    800005fe:	a015                	j	80000622 <mappages+0x58>
    panic("mappages: size");
    80000600:	00008517          	auipc	a0,0x8
    80000604:	a5850513          	addi	a0,a0,-1448 # 80008058 <etext+0x58>
    80000608:	00005097          	auipc	ra,0x5
    8000060c:	730080e7          	jalr	1840(ra) # 80005d38 <panic>
      panic("mappages: remap");
    80000610:	00008517          	auipc	a0,0x8
    80000614:	a5850513          	addi	a0,a0,-1448 # 80008068 <etext+0x68>
    80000618:	00005097          	auipc	ra,0x5
    8000061c:	720080e7          	jalr	1824(ra) # 80005d38 <panic>
    a += PGSIZE;
    80000620:	995e                	add	s2,s2,s7
  for(;;){
    80000622:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000626:	4605                	li	a2,1
    80000628:	85ca                	mv	a1,s2
    8000062a:	8556                	mv	a0,s5
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	eb6080e7          	jalr	-330(ra) # 800004e2 <walk>
    80000634:	cd19                	beqz	a0,80000652 <mappages+0x88>
    if(*pte & PTE_V)
    80000636:	611c                	ld	a5,0(a0)
    80000638:	8b85                	andi	a5,a5,1
    8000063a:	fbf9                	bnez	a5,80000610 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000063c:	80b1                	srli	s1,s1,0xc
    8000063e:	04aa                	slli	s1,s1,0xa
    80000640:	0164e4b3          	or	s1,s1,s6
    80000644:	0014e493          	ori	s1,s1,1
    80000648:	e104                	sd	s1,0(a0)
    if(a == last)
    8000064a:	fd391be3          	bne	s2,s3,80000620 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    8000064e:	4501                	li	a0,0
    80000650:	a011                	j	80000654 <mappages+0x8a>
      return -1;
    80000652:	557d                	li	a0,-1
}
    80000654:	60a6                	ld	ra,72(sp)
    80000656:	6406                	ld	s0,64(sp)
    80000658:	74e2                	ld	s1,56(sp)
    8000065a:	7942                	ld	s2,48(sp)
    8000065c:	79a2                	ld	s3,40(sp)
    8000065e:	7a02                	ld	s4,32(sp)
    80000660:	6ae2                	ld	s5,24(sp)
    80000662:	6b42                	ld	s6,16(sp)
    80000664:	6ba2                	ld	s7,8(sp)
    80000666:	6161                	addi	sp,sp,80
    80000668:	8082                	ret

000000008000066a <kvmmap>:
{
    8000066a:	1141                	addi	sp,sp,-16
    8000066c:	e406                	sd	ra,8(sp)
    8000066e:	e022                	sd	s0,0(sp)
    80000670:	0800                	addi	s0,sp,16
    80000672:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000674:	86b2                	mv	a3,a2
    80000676:	863e                	mv	a2,a5
    80000678:	00000097          	auipc	ra,0x0
    8000067c:	f52080e7          	jalr	-174(ra) # 800005ca <mappages>
    80000680:	e509                	bnez	a0,8000068a <kvmmap+0x20>
}
    80000682:	60a2                	ld	ra,8(sp)
    80000684:	6402                	ld	s0,0(sp)
    80000686:	0141                	addi	sp,sp,16
    80000688:	8082                	ret
    panic("kvmmap");
    8000068a:	00008517          	auipc	a0,0x8
    8000068e:	9ee50513          	addi	a0,a0,-1554 # 80008078 <etext+0x78>
    80000692:	00005097          	auipc	ra,0x5
    80000696:	6a6080e7          	jalr	1702(ra) # 80005d38 <panic>

000000008000069a <kvmmake>:
{
    8000069a:	1101                	addi	sp,sp,-32
    8000069c:	ec06                	sd	ra,24(sp)
    8000069e:	e822                	sd	s0,16(sp)
    800006a0:	e426                	sd	s1,8(sp)
    800006a2:	e04a                	sd	s2,0(sp)
    800006a4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800006a6:	00000097          	auipc	ra,0x0
    800006aa:	ab8080e7          	jalr	-1352(ra) # 8000015e <kalloc>
    800006ae:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800006b0:	6605                	lui	a2,0x1
    800006b2:	4581                	li	a1,0
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	b46080e7          	jalr	-1210(ra) # 800001fa <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006bc:	4719                	li	a4,6
    800006be:	6685                	lui	a3,0x1
    800006c0:	10000637          	lui	a2,0x10000
    800006c4:	100005b7          	lui	a1,0x10000
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	fa0080e7          	jalr	-96(ra) # 8000066a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006d2:	4719                	li	a4,6
    800006d4:	6685                	lui	a3,0x1
    800006d6:	10001637          	lui	a2,0x10001
    800006da:	100015b7          	lui	a1,0x10001
    800006de:	8526                	mv	a0,s1
    800006e0:	00000097          	auipc	ra,0x0
    800006e4:	f8a080e7          	jalr	-118(ra) # 8000066a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006e8:	4719                	li	a4,6
    800006ea:	004006b7          	lui	a3,0x400
    800006ee:	0c000637          	lui	a2,0xc000
    800006f2:	0c0005b7          	lui	a1,0xc000
    800006f6:	8526                	mv	a0,s1
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	f72080e7          	jalr	-142(ra) # 8000066a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000700:	00008917          	auipc	s2,0x8
    80000704:	90090913          	addi	s2,s2,-1792 # 80008000 <etext>
    80000708:	4729                	li	a4,10
    8000070a:	80008697          	auipc	a3,0x80008
    8000070e:	8f668693          	addi	a3,a3,-1802 # 8000 <_entry-0x7fff8000>
    80000712:	4605                	li	a2,1
    80000714:	067e                	slli	a2,a2,0x1f
    80000716:	85b2                	mv	a1,a2
    80000718:	8526                	mv	a0,s1
    8000071a:	00000097          	auipc	ra,0x0
    8000071e:	f50080e7          	jalr	-176(ra) # 8000066a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000722:	4719                	li	a4,6
    80000724:	46c5                	li	a3,17
    80000726:	06ee                	slli	a3,a3,0x1b
    80000728:	412686b3          	sub	a3,a3,s2
    8000072c:	864a                	mv	a2,s2
    8000072e:	85ca                	mv	a1,s2
    80000730:	8526                	mv	a0,s1
    80000732:	00000097          	auipc	ra,0x0
    80000736:	f38080e7          	jalr	-200(ra) # 8000066a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000073a:	4729                	li	a4,10
    8000073c:	6685                	lui	a3,0x1
    8000073e:	00007617          	auipc	a2,0x7
    80000742:	8c260613          	addi	a2,a2,-1854 # 80007000 <_trampoline>
    80000746:	040005b7          	lui	a1,0x4000
    8000074a:	15fd                	addi	a1,a1,-1
    8000074c:	05b2                	slli	a1,a1,0xc
    8000074e:	8526                	mv	a0,s1
    80000750:	00000097          	auipc	ra,0x0
    80000754:	f1a080e7          	jalr	-230(ra) # 8000066a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000758:	8526                	mv	a0,s1
    8000075a:	00000097          	auipc	ra,0x0
    8000075e:	6da080e7          	jalr	1754(ra) # 80000e34 <proc_mapstacks>
}
    80000762:	8526                	mv	a0,s1
    80000764:	60e2                	ld	ra,24(sp)
    80000766:	6442                	ld	s0,16(sp)
    80000768:	64a2                	ld	s1,8(sp)
    8000076a:	6902                	ld	s2,0(sp)
    8000076c:	6105                	addi	sp,sp,32
    8000076e:	8082                	ret

0000000080000770 <kvminit>:
{
    80000770:	1141                	addi	sp,sp,-16
    80000772:	e406                	sd	ra,8(sp)
    80000774:	e022                	sd	s0,0(sp)
    80000776:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000778:	00000097          	auipc	ra,0x0
    8000077c:	f22080e7          	jalr	-222(ra) # 8000069a <kvmmake>
    80000780:	00009797          	auipc	a5,0x9
    80000784:	88a7b423          	sd	a0,-1912(a5) # 80009008 <kernel_pagetable>
}
    80000788:	60a2                	ld	ra,8(sp)
    8000078a:	6402                	ld	s0,0(sp)
    8000078c:	0141                	addi	sp,sp,16
    8000078e:	8082                	ret

0000000080000790 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000790:	715d                	addi	sp,sp,-80
    80000792:	e486                	sd	ra,72(sp)
    80000794:	e0a2                	sd	s0,64(sp)
    80000796:	fc26                	sd	s1,56(sp)
    80000798:	f84a                	sd	s2,48(sp)
    8000079a:	f44e                	sd	s3,40(sp)
    8000079c:	f052                	sd	s4,32(sp)
    8000079e:	ec56                	sd	s5,24(sp)
    800007a0:	e85a                	sd	s6,16(sp)
    800007a2:	e45e                	sd	s7,8(sp)
    800007a4:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800007a6:	03459793          	slli	a5,a1,0x34
    800007aa:	e795                	bnez	a5,800007d6 <uvmunmap+0x46>
    800007ac:	8a2a                	mv	s4,a0
    800007ae:	892e                	mv	s2,a1
    800007b0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007b2:	0632                	slli	a2,a2,0xc
    800007b4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ba:	6b05                	lui	s6,0x1
    800007bc:	0735e863          	bltu	a1,s3,8000082c <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800007c0:	60a6                	ld	ra,72(sp)
    800007c2:	6406                	ld	s0,64(sp)
    800007c4:	74e2                	ld	s1,56(sp)
    800007c6:	7942                	ld	s2,48(sp)
    800007c8:	79a2                	ld	s3,40(sp)
    800007ca:	7a02                	ld	s4,32(sp)
    800007cc:	6ae2                	ld	s5,24(sp)
    800007ce:	6b42                	ld	s6,16(sp)
    800007d0:	6ba2                	ld	s7,8(sp)
    800007d2:	6161                	addi	sp,sp,80
    800007d4:	8082                	ret
    panic("uvmunmap: not aligned");
    800007d6:	00008517          	auipc	a0,0x8
    800007da:	8aa50513          	addi	a0,a0,-1878 # 80008080 <etext+0x80>
    800007de:	00005097          	auipc	ra,0x5
    800007e2:	55a080e7          	jalr	1370(ra) # 80005d38 <panic>
      panic("uvmunmap: walk");
    800007e6:	00008517          	auipc	a0,0x8
    800007ea:	8b250513          	addi	a0,a0,-1870 # 80008098 <etext+0x98>
    800007ee:	00005097          	auipc	ra,0x5
    800007f2:	54a080e7          	jalr	1354(ra) # 80005d38 <panic>
      panic("uvmunmap: not mapped");
    800007f6:	00008517          	auipc	a0,0x8
    800007fa:	8b250513          	addi	a0,a0,-1870 # 800080a8 <etext+0xa8>
    800007fe:	00005097          	auipc	ra,0x5
    80000802:	53a080e7          	jalr	1338(ra) # 80005d38 <panic>
      panic("uvmunmap: not a leaf");
    80000806:	00008517          	auipc	a0,0x8
    8000080a:	8ba50513          	addi	a0,a0,-1862 # 800080c0 <etext+0xc0>
    8000080e:	00005097          	auipc	ra,0x5
    80000812:	52a080e7          	jalr	1322(ra) # 80005d38 <panic>
      uint64 pa = PTE2PA(*pte);
    80000816:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000818:	0532                	slli	a0,a0,0xc
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	802080e7          	jalr	-2046(ra) # 8000001c <kfree>
    *pte = 0;
    80000822:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000826:	995a                	add	s2,s2,s6
    80000828:	f9397ce3          	bgeu	s2,s3,800007c0 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000082c:	4601                	li	a2,0
    8000082e:	85ca                	mv	a1,s2
    80000830:	8552                	mv	a0,s4
    80000832:	00000097          	auipc	ra,0x0
    80000836:	cb0080e7          	jalr	-848(ra) # 800004e2 <walk>
    8000083a:	84aa                	mv	s1,a0
    8000083c:	d54d                	beqz	a0,800007e6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000083e:	6108                	ld	a0,0(a0)
    80000840:	00157793          	andi	a5,a0,1
    80000844:	dbcd                	beqz	a5,800007f6 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000846:	3ff57793          	andi	a5,a0,1023
    8000084a:	fb778ee3          	beq	a5,s7,80000806 <uvmunmap+0x76>
    if(do_free){
    8000084e:	fc0a8ae3          	beqz	s5,80000822 <uvmunmap+0x92>
    80000852:	b7d1                	j	80000816 <uvmunmap+0x86>

0000000080000854 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	900080e7          	jalr	-1792(ra) # 8000015e <kalloc>
    80000866:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000868:	c519                	beqz	a0,80000876 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000086a:	6605                	lui	a2,0x1
    8000086c:	4581                	li	a1,0
    8000086e:	00000097          	auipc	ra,0x0
    80000872:	98c080e7          	jalr	-1652(ra) # 800001fa <memset>
  return pagetable;
}
    80000876:	8526                	mv	a0,s1
    80000878:	60e2                	ld	ra,24(sp)
    8000087a:	6442                	ld	s0,16(sp)
    8000087c:	64a2                	ld	s1,8(sp)
    8000087e:	6105                	addi	sp,sp,32
    80000880:	8082                	ret

0000000080000882 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000882:	7179                	addi	sp,sp,-48
    80000884:	f406                	sd	ra,40(sp)
    80000886:	f022                	sd	s0,32(sp)
    80000888:	ec26                	sd	s1,24(sp)
    8000088a:	e84a                	sd	s2,16(sp)
    8000088c:	e44e                	sd	s3,8(sp)
    8000088e:	e052                	sd	s4,0(sp)
    80000890:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000892:	6785                	lui	a5,0x1
    80000894:	04f67863          	bgeu	a2,a5,800008e4 <uvminit+0x62>
    80000898:	8a2a                	mv	s4,a0
    8000089a:	89ae                	mv	s3,a1
    8000089c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000089e:	00000097          	auipc	ra,0x0
    800008a2:	8c0080e7          	jalr	-1856(ra) # 8000015e <kalloc>
    800008a6:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800008a8:	6605                	lui	a2,0x1
    800008aa:	4581                	li	a1,0
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	94e080e7          	jalr	-1714(ra) # 800001fa <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800008b4:	4779                	li	a4,30
    800008b6:	86ca                	mv	a3,s2
    800008b8:	6605                	lui	a2,0x1
    800008ba:	4581                	li	a1,0
    800008bc:	8552                	mv	a0,s4
    800008be:	00000097          	auipc	ra,0x0
    800008c2:	d0c080e7          	jalr	-756(ra) # 800005ca <mappages>
  memmove(mem, src, sz);
    800008c6:	8626                	mv	a2,s1
    800008c8:	85ce                	mv	a1,s3
    800008ca:	854a                	mv	a0,s2
    800008cc:	00000097          	auipc	ra,0x0
    800008d0:	98e080e7          	jalr	-1650(ra) # 8000025a <memmove>
}
    800008d4:	70a2                	ld	ra,40(sp)
    800008d6:	7402                	ld	s0,32(sp)
    800008d8:	64e2                	ld	s1,24(sp)
    800008da:	6942                	ld	s2,16(sp)
    800008dc:	69a2                	ld	s3,8(sp)
    800008de:	6a02                	ld	s4,0(sp)
    800008e0:	6145                	addi	sp,sp,48
    800008e2:	8082                	ret
    panic("inituvm: more than a page");
    800008e4:	00007517          	auipc	a0,0x7
    800008e8:	7f450513          	addi	a0,a0,2036 # 800080d8 <etext+0xd8>
    800008ec:	00005097          	auipc	ra,0x5
    800008f0:	44c080e7          	jalr	1100(ra) # 80005d38 <panic>

00000000800008f4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008f4:	1101                	addi	sp,sp,-32
    800008f6:	ec06                	sd	ra,24(sp)
    800008f8:	e822                	sd	s0,16(sp)
    800008fa:	e426                	sd	s1,8(sp)
    800008fc:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008fe:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000900:	00b67d63          	bgeu	a2,a1,8000091a <uvmdealloc+0x26>
    80000904:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000906:	6785                	lui	a5,0x1
    80000908:	17fd                	addi	a5,a5,-1
    8000090a:	00f60733          	add	a4,a2,a5
    8000090e:	767d                	lui	a2,0xfffff
    80000910:	8f71                	and	a4,a4,a2
    80000912:	97ae                	add	a5,a5,a1
    80000914:	8ff1                	and	a5,a5,a2
    80000916:	00f76863          	bltu	a4,a5,80000926 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000091a:	8526                	mv	a0,s1
    8000091c:	60e2                	ld	ra,24(sp)
    8000091e:	6442                	ld	s0,16(sp)
    80000920:	64a2                	ld	s1,8(sp)
    80000922:	6105                	addi	sp,sp,32
    80000924:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000926:	8f99                	sub	a5,a5,a4
    80000928:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000092a:	4685                	li	a3,1
    8000092c:	0007861b          	sext.w	a2,a5
    80000930:	85ba                	mv	a1,a4
    80000932:	00000097          	auipc	ra,0x0
    80000936:	e5e080e7          	jalr	-418(ra) # 80000790 <uvmunmap>
    8000093a:	b7c5                	j	8000091a <uvmdealloc+0x26>

000000008000093c <uvmalloc>:
  if(newsz < oldsz)
    8000093c:	0ab66163          	bltu	a2,a1,800009de <uvmalloc+0xa2>
{
    80000940:	7139                	addi	sp,sp,-64
    80000942:	fc06                	sd	ra,56(sp)
    80000944:	f822                	sd	s0,48(sp)
    80000946:	f426                	sd	s1,40(sp)
    80000948:	f04a                	sd	s2,32(sp)
    8000094a:	ec4e                	sd	s3,24(sp)
    8000094c:	e852                	sd	s4,16(sp)
    8000094e:	e456                	sd	s5,8(sp)
    80000950:	0080                	addi	s0,sp,64
    80000952:	8aaa                	mv	s5,a0
    80000954:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000956:	6985                	lui	s3,0x1
    80000958:	19fd                	addi	s3,s3,-1
    8000095a:	95ce                	add	a1,a1,s3
    8000095c:	79fd                	lui	s3,0xfffff
    8000095e:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000962:	08c9f063          	bgeu	s3,a2,800009e2 <uvmalloc+0xa6>
    80000966:	894e                	mv	s2,s3
    mem = kalloc();
    80000968:	fffff097          	auipc	ra,0xfffff
    8000096c:	7f6080e7          	jalr	2038(ra) # 8000015e <kalloc>
    80000970:	84aa                	mv	s1,a0
    if(mem == 0){
    80000972:	c51d                	beqz	a0,800009a0 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000974:	6605                	lui	a2,0x1
    80000976:	4581                	li	a1,0
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	882080e7          	jalr	-1918(ra) # 800001fa <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000980:	4779                	li	a4,30
    80000982:	86a6                	mv	a3,s1
    80000984:	6605                	lui	a2,0x1
    80000986:	85ca                	mv	a1,s2
    80000988:	8556                	mv	a0,s5
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	c40080e7          	jalr	-960(ra) # 800005ca <mappages>
    80000992:	e905                	bnez	a0,800009c2 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000994:	6785                	lui	a5,0x1
    80000996:	993e                	add	s2,s2,a5
    80000998:	fd4968e3          	bltu	s2,s4,80000968 <uvmalloc+0x2c>
  return newsz;
    8000099c:	8552                	mv	a0,s4
    8000099e:	a809                	j	800009b0 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800009a0:	864e                	mv	a2,s3
    800009a2:	85ca                	mv	a1,s2
    800009a4:	8556                	mv	a0,s5
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	f4e080e7          	jalr	-178(ra) # 800008f4 <uvmdealloc>
      return 0;
    800009ae:	4501                	li	a0,0
}
    800009b0:	70e2                	ld	ra,56(sp)
    800009b2:	7442                	ld	s0,48(sp)
    800009b4:	74a2                	ld	s1,40(sp)
    800009b6:	7902                	ld	s2,32(sp)
    800009b8:	69e2                	ld	s3,24(sp)
    800009ba:	6a42                	ld	s4,16(sp)
    800009bc:	6aa2                	ld	s5,8(sp)
    800009be:	6121                	addi	sp,sp,64
    800009c0:	8082                	ret
      kfree(mem);
    800009c2:	8526                	mv	a0,s1
    800009c4:	fffff097          	auipc	ra,0xfffff
    800009c8:	658080e7          	jalr	1624(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009cc:	864e                	mv	a2,s3
    800009ce:	85ca                	mv	a1,s2
    800009d0:	8556                	mv	a0,s5
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	f22080e7          	jalr	-222(ra) # 800008f4 <uvmdealloc>
      return 0;
    800009da:	4501                	li	a0,0
    800009dc:	bfd1                	j	800009b0 <uvmalloc+0x74>
    return oldsz;
    800009de:	852e                	mv	a0,a1
}
    800009e0:	8082                	ret
  return newsz;
    800009e2:	8532                	mv	a0,a2
    800009e4:	b7f1                	j	800009b0 <uvmalloc+0x74>

00000000800009e6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009e6:	7179                	addi	sp,sp,-48
    800009e8:	f406                	sd	ra,40(sp)
    800009ea:	f022                	sd	s0,32(sp)
    800009ec:	ec26                	sd	s1,24(sp)
    800009ee:	e84a                	sd	s2,16(sp)
    800009f0:	e44e                	sd	s3,8(sp)
    800009f2:	e052                	sd	s4,0(sp)
    800009f4:	1800                	addi	s0,sp,48
    800009f6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009f8:	84aa                	mv	s1,a0
    800009fa:	6905                	lui	s2,0x1
    800009fc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009fe:	4985                	li	s3,1
    80000a00:	a821                	j	80000a18 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a02:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a04:	0532                	slli	a0,a0,0xc
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	fe0080e7          	jalr	-32(ra) # 800009e6 <freewalk>
      pagetable[i] = 0;
    80000a0e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a12:	04a1                	addi	s1,s1,8
    80000a14:	03248163          	beq	s1,s2,80000a36 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a18:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a1a:	00f57793          	andi	a5,a0,15
    80000a1e:	ff3782e3          	beq	a5,s3,80000a02 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a22:	8905                	andi	a0,a0,1
    80000a24:	d57d                	beqz	a0,80000a12 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000a26:	00007517          	auipc	a0,0x7
    80000a2a:	6d250513          	addi	a0,a0,1746 # 800080f8 <etext+0xf8>
    80000a2e:	00005097          	auipc	ra,0x5
    80000a32:	30a080e7          	jalr	778(ra) # 80005d38 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a36:	8552                	mv	a0,s4
    80000a38:	fffff097          	auipc	ra,0xfffff
    80000a3c:	5e4080e7          	jalr	1508(ra) # 8000001c <kfree>
}
    80000a40:	70a2                	ld	ra,40(sp)
    80000a42:	7402                	ld	s0,32(sp)
    80000a44:	64e2                	ld	s1,24(sp)
    80000a46:	6942                	ld	s2,16(sp)
    80000a48:	69a2                	ld	s3,8(sp)
    80000a4a:	6a02                	ld	s4,0(sp)
    80000a4c:	6145                	addi	sp,sp,48
    80000a4e:	8082                	ret

0000000080000a50 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a50:	1101                	addi	sp,sp,-32
    80000a52:	ec06                	sd	ra,24(sp)
    80000a54:	e822                	sd	s0,16(sp)
    80000a56:	e426                	sd	s1,8(sp)
    80000a58:	1000                	addi	s0,sp,32
    80000a5a:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a5c:	e999                	bnez	a1,80000a72 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a5e:	8526                	mv	a0,s1
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	f86080e7          	jalr	-122(ra) # 800009e6 <freewalk>
}
    80000a68:	60e2                	ld	ra,24(sp)
    80000a6a:	6442                	ld	s0,16(sp)
    80000a6c:	64a2                	ld	s1,8(sp)
    80000a6e:	6105                	addi	sp,sp,32
    80000a70:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a72:	6605                	lui	a2,0x1
    80000a74:	167d                	addi	a2,a2,-1
    80000a76:	962e                	add	a2,a2,a1
    80000a78:	4685                	li	a3,1
    80000a7a:	8231                	srli	a2,a2,0xc
    80000a7c:	4581                	li	a1,0
    80000a7e:	00000097          	auipc	ra,0x0
    80000a82:	d12080e7          	jalr	-750(ra) # 80000790 <uvmunmap>
    80000a86:	bfe1                	j	80000a5e <uvmfree+0xe>

0000000080000a88 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;

 for(i = 0; i < sz; i += PGSIZE){
    80000a88:	ca75                	beqz	a2,80000b7c <uvmcopy+0xf4>
{
    80000a8a:	715d                	addi	sp,sp,-80
    80000a8c:	e486                	sd	ra,72(sp)
    80000a8e:	e0a2                	sd	s0,64(sp)
    80000a90:	fc26                	sd	s1,56(sp)
    80000a92:	f84a                	sd	s2,48(sp)
    80000a94:	f44e                	sd	s3,40(sp)
    80000a96:	f052                	sd	s4,32(sp)
    80000a98:	ec56                	sd	s5,24(sp)
    80000a9a:	e85a                	sd	s6,16(sp)
    80000a9c:	e45e                	sd	s7,8(sp)
    80000a9e:	e062                	sd	s8,0(sp)
    80000aa0:	0880                	addi	s0,sp,80
    80000aa2:	8baa                	mv	s7,a0
    80000aa4:	8b2e                	mv	s6,a1
    80000aa6:	8ab2                	mv	s5,a2
 for(i = 0; i < sz; i += PGSIZE){
    80000aa8:	4981                	li	s3,0
      *pte |= PTE_RSW;
    }
    pa = PTE2PA(*pte);

    // increment the ref count
    acquire(&ref_count_lock);
    80000aaa:	00008a17          	auipc	s4,0x8
    80000aae:	586a0a13          	addi	s4,s4,1414 # 80009030 <ref_count_lock>
    useReference[pa/PGSIZE] += 1;
    80000ab2:	00008c17          	auipc	s8,0x8
    80000ab6:	5b6c0c13          	addi	s8,s8,1462 # 80009068 <useReference>
    80000aba:	a0b5                	j	80000b26 <uvmcopy+0x9e>
      panic("uvmcopy: pte should exist");
    80000abc:	00007517          	auipc	a0,0x7
    80000ac0:	64c50513          	addi	a0,a0,1612 # 80008108 <etext+0x108>
    80000ac4:	00005097          	auipc	ra,0x5
    80000ac8:	274080e7          	jalr	628(ra) # 80005d38 <panic>
      panic("uvmcopy: page not present");
    80000acc:	00007517          	auipc	a0,0x7
    80000ad0:	65c50513          	addi	a0,a0,1628 # 80008128 <etext+0x128>
    80000ad4:	00005097          	auipc	ra,0x5
    80000ad8:	264080e7          	jalr	612(ra) # 80005d38 <panic>
    pa = PTE2PA(*pte);
    80000adc:	0004b903          	ld	s2,0(s1)
    80000ae0:	00a95913          	srli	s2,s2,0xa
    80000ae4:	0932                	slli	s2,s2,0xc
    acquire(&ref_count_lock);
    80000ae6:	8552                	mv	a0,s4
    80000ae8:	00005097          	auipc	ra,0x5
    80000aec:	79a080e7          	jalr	1946(ra) # 80006282 <acquire>
    useReference[pa/PGSIZE] += 1;
    80000af0:	00a95793          	srli	a5,s2,0xa
    80000af4:	97e2                	add	a5,a5,s8
    80000af6:	4398                	lw	a4,0(a5)
    80000af8:	2705                	addiw	a4,a4,1
    80000afa:	c398                	sw	a4,0(a5)
    release(&ref_count_lock);
    80000afc:	8552                	mv	a0,s4
    80000afe:	00006097          	auipc	ra,0x6
    80000b02:	838080e7          	jalr	-1992(ra) # 80006336 <release>

    flags = PTE_FLAGS(*pte);
    80000b06:	6098                	ld	a4,0(s1)
    // if((mem = kalloc()) == 0)
    //   goto err;
    // memmove(mem, (char*)pa, PGSIZE);
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000b08:	3ff77713          	andi	a4,a4,1023
    80000b0c:	86ca                	mv	a3,s2
    80000b0e:	6605                	lui	a2,0x1
    80000b10:	85ce                	mv	a1,s3
    80000b12:	855a                	mv	a0,s6
    80000b14:	00000097          	auipc	ra,0x0
    80000b18:	ab6080e7          	jalr	-1354(ra) # 800005ca <mappages>
    80000b1c:	e915                	bnez	a0,80000b50 <uvmcopy+0xc8>
 for(i = 0; i < sz; i += PGSIZE){
    80000b1e:	6785                	lui	a5,0x1
    80000b20:	99be                	add	s3,s3,a5
    80000b22:	0559f163          	bgeu	s3,s5,80000b64 <uvmcopy+0xdc>
    if((pte = walk(old, i, 0)) == 0)
    80000b26:	4601                	li	a2,0
    80000b28:	85ce                	mv	a1,s3
    80000b2a:	855e                	mv	a0,s7
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	9b6080e7          	jalr	-1610(ra) # 800004e2 <walk>
    80000b34:	84aa                	mv	s1,a0
    80000b36:	d159                	beqz	a0,80000abc <uvmcopy+0x34>
    if((*pte & PTE_V) == 0)
    80000b38:	611c                	ld	a5,0(a0)
    80000b3a:	0017f713          	andi	a4,a5,1
    80000b3e:	d759                	beqz	a4,80000acc <uvmcopy+0x44>
    if (*pte & PTE_W) {
    80000b40:	0047f713          	andi	a4,a5,4
    80000b44:	df41                	beqz	a4,80000adc <uvmcopy+0x54>
      *pte &= ~PTE_W;
    80000b46:	9bed                	andi	a5,a5,-5
      *pte |= PTE_RSW;
    80000b48:	1007e793          	ori	a5,a5,256
    80000b4c:	e11c                	sd	a5,0(a0)
    80000b4e:	b779                	j	80000adc <uvmcopy+0x54>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b50:	4685                	li	a3,1
    80000b52:	00c9d613          	srli	a2,s3,0xc
    80000b56:	4581                	li	a1,0
    80000b58:	855a                	mv	a0,s6
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	c36080e7          	jalr	-970(ra) # 80000790 <uvmunmap>
  return -1;
    80000b62:	557d                	li	a0,-1
}
    80000b64:	60a6                	ld	ra,72(sp)
    80000b66:	6406                	ld	s0,64(sp)
    80000b68:	74e2                	ld	s1,56(sp)
    80000b6a:	7942                	ld	s2,48(sp)
    80000b6c:	79a2                	ld	s3,40(sp)
    80000b6e:	7a02                	ld	s4,32(sp)
    80000b70:	6ae2                	ld	s5,24(sp)
    80000b72:	6b42                	ld	s6,16(sp)
    80000b74:	6ba2                	ld	s7,8(sp)
    80000b76:	6c02                	ld	s8,0(sp)
    80000b78:	6161                	addi	sp,sp,80
    80000b7a:	8082                	ret
  return 0;
    80000b7c:	4501                	li	a0,0
}
    80000b7e:	8082                	ret

0000000080000b80 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b80:	1141                	addi	sp,sp,-16
    80000b82:	e406                	sd	ra,8(sp)
    80000b84:	e022                	sd	s0,0(sp)
    80000b86:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000b88:	4601                	li	a2,0
    80000b8a:	00000097          	auipc	ra,0x0
    80000b8e:	958080e7          	jalr	-1704(ra) # 800004e2 <walk>
  if(pte == 0)
    80000b92:	c901                	beqz	a0,80000ba2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b94:	611c                	ld	a5,0(a0)
    80000b96:	9bbd                	andi	a5,a5,-17
    80000b98:	e11c                	sd	a5,0(a0)
}
    80000b9a:	60a2                	ld	ra,8(sp)
    80000b9c:	6402                	ld	s0,0(sp)
    80000b9e:	0141                	addi	sp,sp,16
    80000ba0:	8082                	ret
    panic("uvmclear");
    80000ba2:	00007517          	auipc	a0,0x7
    80000ba6:	5a650513          	addi	a0,a0,1446 # 80008148 <etext+0x148>
    80000baa:	00005097          	auipc	ra,0x5
    80000bae:	18e080e7          	jalr	398(ra) # 80005d38 <panic>

0000000080000bb2 <checkcowpage>:

int checkcowpage(uint64 va, pte_t *pte, struct proc* p) {
    80000bb2:	1141                	addi	sp,sp,-16
    80000bb4:	e422                	sd	s0,8(sp)
    80000bb6:	0800                	addi	s0,sp,16
  return (va < p->sz) // va should blow the size of process memory (bytes)
    && (*pte & PTE_V)
    && (*pte & PTE_RSW); // pte is COW page
    80000bb8:	663c                	ld	a5,72(a2)
    80000bba:	00f57c63          	bgeu	a0,a5,80000bd2 <checkcowpage+0x20>
    80000bbe:	6188                	ld	a0,0(a1)
    80000bc0:	10157513          	andi	a0,a0,257
    80000bc4:	eff50513          	addi	a0,a0,-257
    80000bc8:	00153513          	seqz	a0,a0
}
    80000bcc:	6422                	ld	s0,8(sp)
    80000bce:	0141                	addi	sp,sp,16
    80000bd0:	8082                	ret
    && (*pte & PTE_RSW); // pte is COW page
    80000bd2:	4501                	li	a0,0
    80000bd4:	bfe5                	j	80000bcc <checkcowpage+0x1a>

0000000080000bd6 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bd6:	ceed                	beqz	a3,80000cd0 <copyout+0xfa>
{
    80000bd8:	7159                	addi	sp,sp,-112
    80000bda:	f486                	sd	ra,104(sp)
    80000bdc:	f0a2                	sd	s0,96(sp)
    80000bde:	eca6                	sd	s1,88(sp)
    80000be0:	e8ca                	sd	s2,80(sp)
    80000be2:	e4ce                	sd	s3,72(sp)
    80000be4:	e0d2                	sd	s4,64(sp)
    80000be6:	fc56                	sd	s5,56(sp)
    80000be8:	f85a                	sd	s6,48(sp)
    80000bea:	f45e                	sd	s7,40(sp)
    80000bec:	f062                	sd	s8,32(sp)
    80000bee:	ec66                	sd	s9,24(sp)
    80000bf0:	e86a                	sd	s10,16(sp)
    80000bf2:	e46e                	sd	s11,8(sp)
    80000bf4:	1880                	addi	s0,sp,112
    80000bf6:	8baa                	mv	s7,a0
    80000bf8:	84ae                	mv	s1,a1
    80000bfa:	8b32                	mv	s6,a2
    80000bfc:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000bfe:	7c7d                	lui	s8,0xfffff
      return -1;

    struct proc *p = myproc();
    pte_t *pte = walk(pagetable, va0, 0);
    if (*pte == 0)
      p->killed = 1;
    80000c00:	4c85                	li	s9,1
    80000c02:	a089                	j	80000c44 <copyout+0x6e>
    // check
    if (checkcowpage(va0, pte, p))
    80000c04:	866a                	mv	a2,s10
    80000c06:	85ca                	mv	a1,s2
    80000c08:	854e                	mv	a0,s3
    80000c0a:	00000097          	auipc	ra,0x0
    80000c0e:	fa8080e7          	jalr	-88(ra) # 80000bb2 <checkcowpage>
    80000c12:	e52d                	bnez	a0,80000c7c <copyout+0xa6>
        // update pa0 to new physical memory address
        pa0 = (uint64)mem;
      }
    }

    n = PGSIZE - (dstva - va0);
    80000c14:	40998933          	sub	s2,s3,s1
    80000c18:	6785                	lui	a5,0x1
    80000c1a:	993e                	add	s2,s2,a5
    if(n > len)
    80000c1c:	012af363          	bgeu	s5,s2,80000c22 <copyout+0x4c>
    80000c20:	8956                	mv	s2,s5
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c22:	41348533          	sub	a0,s1,s3
    80000c26:	0009061b          	sext.w	a2,s2
    80000c2a:	85da                	mv	a1,s6
    80000c2c:	9552                	add	a0,a0,s4
    80000c2e:	fffff097          	auipc	ra,0xfffff
    80000c32:	62c080e7          	jalr	1580(ra) # 8000025a <memmove>

    len -= n;
    80000c36:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000c3a:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000c3c:	6485                	lui	s1,0x1
    80000c3e:	94ce                	add	s1,s1,s3
  while(len > 0){
    80000c40:	080a8663          	beqz	s5,80000ccc <copyout+0xf6>
    va0 = PGROUNDDOWN(dstva);
    80000c44:	0184f9b3          	and	s3,s1,s8
    pa0 = walkaddr(pagetable, va0);
    80000c48:	85ce                	mv	a1,s3
    80000c4a:	855e                	mv	a0,s7
    80000c4c:	00000097          	auipc	ra,0x0
    80000c50:	93c080e7          	jalr	-1732(ra) # 80000588 <walkaddr>
    80000c54:	8a2a                	mv	s4,a0
    if(pa0 == 0)
    80000c56:	cd3d                	beqz	a0,80000cd4 <copyout+0xfe>
    struct proc *p = myproc();
    80000c58:	00000097          	auipc	ra,0x0
    80000c5c:	34e080e7          	jalr	846(ra) # 80000fa6 <myproc>
    80000c60:	8d2a                	mv	s10,a0
    pte_t *pte = walk(pagetable, va0, 0);
    80000c62:	4601                	li	a2,0
    80000c64:	85ce                	mv	a1,s3
    80000c66:	855e                	mv	a0,s7
    80000c68:	00000097          	auipc	ra,0x0
    80000c6c:	87a080e7          	jalr	-1926(ra) # 800004e2 <walk>
    80000c70:	892a                	mv	s2,a0
    if (*pte == 0)
    80000c72:	611c                	ld	a5,0(a0)
    80000c74:	fbc1                	bnez	a5,80000c04 <copyout+0x2e>
      p->killed = 1;
    80000c76:	039d2423          	sw	s9,40(s10)
    80000c7a:	b769                	j	80000c04 <copyout+0x2e>
      if ((mem = kalloc()) == 0) {
    80000c7c:	fffff097          	auipc	ra,0xfffff
    80000c80:	4e2080e7          	jalr	1250(ra) # 8000015e <kalloc>
    80000c84:	8daa                	mv	s11,a0
    80000c86:	c121                	beqz	a0,80000cc6 <copyout+0xf0>
        memmove(mem, (char*)pa0, PGSIZE);
    80000c88:	6605                	lui	a2,0x1
    80000c8a:	85d2                	mv	a1,s4
    80000c8c:	fffff097          	auipc	ra,0xfffff
    80000c90:	5ce080e7          	jalr	1486(ra) # 8000025a <memmove>
        uint flags = PTE_FLAGS(*pte);
    80000c94:	00093d03          	ld	s10,0(s2) # 1000 <_entry-0x7ffff000>
    80000c98:	3ffd7d13          	andi	s10,s10,1023
        uvmunmap(pagetable, va0, 1, 1);
    80000c9c:	4685                	li	a3,1
    80000c9e:	4605                	li	a2,1
    80000ca0:	85ce                	mv	a1,s3
    80000ca2:	855e                	mv	a0,s7
    80000ca4:	00000097          	auipc	ra,0x0
    80000ca8:	aec080e7          	jalr	-1300(ra) # 80000790 <uvmunmap>
        *pte = (PA2PTE(mem) | flags | PTE_W);
    80000cac:	8a6e                	mv	s4,s11
    80000cae:	00cddd93          	srli	s11,s11,0xc
    80000cb2:	0daa                	slli	s11,s11,0xa
    80000cb4:	01bd6d33          	or	s10,s10,s11
        *pte &= ~PTE_RSW;
    80000cb8:	effd7d13          	andi	s10,s10,-257
    80000cbc:	004d6d13          	ori	s10,s10,4
    80000cc0:	01a93023          	sd	s10,0(s2)
        pa0 = (uint64)mem;
    80000cc4:	bf81                	j	80000c14 <copyout+0x3e>
        p->killed = 1;
    80000cc6:	039d2423          	sw	s9,40(s10)
    80000cca:	b7a9                	j	80000c14 <copyout+0x3e>
  }
  return 0;
    80000ccc:	4501                	li	a0,0
    80000cce:	a021                	j	80000cd6 <copyout+0x100>
    80000cd0:	4501                	li	a0,0
}
    80000cd2:	8082                	ret
      return -1;
    80000cd4:	557d                	li	a0,-1
}
    80000cd6:	70a6                	ld	ra,104(sp)
    80000cd8:	7406                	ld	s0,96(sp)
    80000cda:	64e6                	ld	s1,88(sp)
    80000cdc:	6946                	ld	s2,80(sp)
    80000cde:	69a6                	ld	s3,72(sp)
    80000ce0:	6a06                	ld	s4,64(sp)
    80000ce2:	7ae2                	ld	s5,56(sp)
    80000ce4:	7b42                	ld	s6,48(sp)
    80000ce6:	7ba2                	ld	s7,40(sp)
    80000ce8:	7c02                	ld	s8,32(sp)
    80000cea:	6ce2                	ld	s9,24(sp)
    80000cec:	6d42                	ld	s10,16(sp)
    80000cee:	6da2                	ld	s11,8(sp)
    80000cf0:	6165                	addi	sp,sp,112
    80000cf2:	8082                	ret

0000000080000cf4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cf4:	c6bd                	beqz	a3,80000d62 <copyin+0x6e>
{
    80000cf6:	715d                	addi	sp,sp,-80
    80000cf8:	e486                	sd	ra,72(sp)
    80000cfa:	e0a2                	sd	s0,64(sp)
    80000cfc:	fc26                	sd	s1,56(sp)
    80000cfe:	f84a                	sd	s2,48(sp)
    80000d00:	f44e                	sd	s3,40(sp)
    80000d02:	f052                	sd	s4,32(sp)
    80000d04:	ec56                	sd	s5,24(sp)
    80000d06:	e85a                	sd	s6,16(sp)
    80000d08:	e45e                	sd	s7,8(sp)
    80000d0a:	e062                	sd	s8,0(sp)
    80000d0c:	0880                	addi	s0,sp,80
    80000d0e:	8b2a                	mv	s6,a0
    80000d10:	8a2e                	mv	s4,a1
    80000d12:	8c32                	mv	s8,a2
    80000d14:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d16:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d18:	6a85                	lui	s5,0x1
    80000d1a:	a015                	j	80000d3e <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d1c:	9562                	add	a0,a0,s8
    80000d1e:	0004861b          	sext.w	a2,s1
    80000d22:	412505b3          	sub	a1,a0,s2
    80000d26:	8552                	mv	a0,s4
    80000d28:	fffff097          	auipc	ra,0xfffff
    80000d2c:	532080e7          	jalr	1330(ra) # 8000025a <memmove>

    len -= n;
    80000d30:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d34:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d36:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d3a:	02098263          	beqz	s3,80000d5e <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d3e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d42:	85ca                	mv	a1,s2
    80000d44:	855a                	mv	a0,s6
    80000d46:	00000097          	auipc	ra,0x0
    80000d4a:	842080e7          	jalr	-1982(ra) # 80000588 <walkaddr>
    if(pa0 == 0)
    80000d4e:	cd01                	beqz	a0,80000d66 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d50:	418904b3          	sub	s1,s2,s8
    80000d54:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d56:	fc99f3e3          	bgeu	s3,s1,80000d1c <copyin+0x28>
    80000d5a:	84ce                	mv	s1,s3
    80000d5c:	b7c1                	j	80000d1c <copyin+0x28>
  }
  return 0;
    80000d5e:	4501                	li	a0,0
    80000d60:	a021                	j	80000d68 <copyin+0x74>
    80000d62:	4501                	li	a0,0
}
    80000d64:	8082                	ret
      return -1;
    80000d66:	557d                	li	a0,-1
}
    80000d68:	60a6                	ld	ra,72(sp)
    80000d6a:	6406                	ld	s0,64(sp)
    80000d6c:	74e2                	ld	s1,56(sp)
    80000d6e:	7942                	ld	s2,48(sp)
    80000d70:	79a2                	ld	s3,40(sp)
    80000d72:	7a02                	ld	s4,32(sp)
    80000d74:	6ae2                	ld	s5,24(sp)
    80000d76:	6b42                	ld	s6,16(sp)
    80000d78:	6ba2                	ld	s7,8(sp)
    80000d7a:	6c02                	ld	s8,0(sp)
    80000d7c:	6161                	addi	sp,sp,80
    80000d7e:	8082                	ret

0000000080000d80 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d80:	c6c5                	beqz	a3,80000e28 <copyinstr+0xa8>
{
    80000d82:	715d                	addi	sp,sp,-80
    80000d84:	e486                	sd	ra,72(sp)
    80000d86:	e0a2                	sd	s0,64(sp)
    80000d88:	fc26                	sd	s1,56(sp)
    80000d8a:	f84a                	sd	s2,48(sp)
    80000d8c:	f44e                	sd	s3,40(sp)
    80000d8e:	f052                	sd	s4,32(sp)
    80000d90:	ec56                	sd	s5,24(sp)
    80000d92:	e85a                	sd	s6,16(sp)
    80000d94:	e45e                	sd	s7,8(sp)
    80000d96:	0880                	addi	s0,sp,80
    80000d98:	8a2a                	mv	s4,a0
    80000d9a:	8b2e                	mv	s6,a1
    80000d9c:	8bb2                	mv	s7,a2
    80000d9e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000da0:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000da2:	6985                	lui	s3,0x1
    80000da4:	a035                	j	80000dd0 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000da6:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000daa:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000dac:	0017b793          	seqz	a5,a5
    80000db0:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
    80000db4:	60a6                	ld	ra,72(sp)
    80000db6:	6406                	ld	s0,64(sp)
    80000db8:	74e2                	ld	s1,56(sp)
    80000dba:	7942                	ld	s2,48(sp)
    80000dbc:	79a2                	ld	s3,40(sp)
    80000dbe:	7a02                	ld	s4,32(sp)
    80000dc0:	6ae2                	ld	s5,24(sp)
    80000dc2:	6b42                	ld	s6,16(sp)
    80000dc4:	6ba2                	ld	s7,8(sp)
    80000dc6:	6161                	addi	sp,sp,80
    80000dc8:	8082                	ret
    srcva = va0 + PGSIZE;
    80000dca:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000dce:	c8a9                	beqz	s1,80000e20 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000dd0:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000dd4:	85ca                	mv	a1,s2
    80000dd6:	8552                	mv	a0,s4
    80000dd8:	fffff097          	auipc	ra,0xfffff
    80000ddc:	7b0080e7          	jalr	1968(ra) # 80000588 <walkaddr>
    if(pa0 == 0)
    80000de0:	c131                	beqz	a0,80000e24 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000de2:	41790833          	sub	a6,s2,s7
    80000de6:	984e                	add	a6,a6,s3
    if(n > max)
    80000de8:	0104f363          	bgeu	s1,a6,80000dee <copyinstr+0x6e>
    80000dec:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000dee:	955e                	add	a0,a0,s7
    80000df0:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000df4:	fc080be3          	beqz	a6,80000dca <copyinstr+0x4a>
    80000df8:	985a                	add	a6,a6,s6
    80000dfa:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000dfc:	41650633          	sub	a2,a0,s6
    80000e00:	14fd                	addi	s1,s1,-1
    80000e02:	9b26                	add	s6,s6,s1
    80000e04:	00f60733          	add	a4,a2,a5
    80000e08:	00074703          	lbu	a4,0(a4)
    80000e0c:	df49                	beqz	a4,80000da6 <copyinstr+0x26>
        *dst = *p;
    80000e0e:	00e78023          	sb	a4,0(a5)
      --max;
    80000e12:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e16:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e18:	ff0796e3          	bne	a5,a6,80000e04 <copyinstr+0x84>
      dst++;
    80000e1c:	8b42                	mv	s6,a6
    80000e1e:	b775                	j	80000dca <copyinstr+0x4a>
    80000e20:	4781                	li	a5,0
    80000e22:	b769                	j	80000dac <copyinstr+0x2c>
      return -1;
    80000e24:	557d                	li	a0,-1
    80000e26:	b779                	j	80000db4 <copyinstr+0x34>
  int got_null = 0;
    80000e28:	4781                	li	a5,0
  if(got_null){
    80000e2a:	0017b793          	seqz	a5,a5
    80000e2e:	40f00533          	neg	a0,a5
    80000e32:	8082                	ret

0000000080000e34 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e34:	7139                	addi	sp,sp,-64
    80000e36:	fc06                	sd	ra,56(sp)
    80000e38:	f822                	sd	s0,48(sp)
    80000e3a:	f426                	sd	s1,40(sp)
    80000e3c:	f04a                	sd	s2,32(sp)
    80000e3e:	ec4e                	sd	s3,24(sp)
    80000e40:	e852                	sd	s4,16(sp)
    80000e42:	e456                	sd	s5,8(sp)
    80000e44:	e05a                	sd	s6,0(sp)
    80000e46:	0080                	addi	s0,sp,64
    80000e48:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4a:	00228497          	auipc	s1,0x228
    80000e4e:	64e48493          	addi	s1,s1,1614 # 80229498 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e52:	8b26                	mv	s6,s1
    80000e54:	00007a97          	auipc	s5,0x7
    80000e58:	1aca8a93          	addi	s5,s5,428 # 80008000 <etext>
    80000e5c:	04000937          	lui	s2,0x4000
    80000e60:	197d                	addi	s2,s2,-1
    80000e62:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e64:	0022ea17          	auipc	s4,0x22e
    80000e68:	034a0a13          	addi	s4,s4,52 # 8022ee98 <tickslock>
    char *pa = kalloc();
    80000e6c:	fffff097          	auipc	ra,0xfffff
    80000e70:	2f2080e7          	jalr	754(ra) # 8000015e <kalloc>
    80000e74:	862a                	mv	a2,a0
    if(pa == 0)
    80000e76:	c131                	beqz	a0,80000eba <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e78:	416485b3          	sub	a1,s1,s6
    80000e7c:	858d                	srai	a1,a1,0x3
    80000e7e:	000ab783          	ld	a5,0(s5)
    80000e82:	02f585b3          	mul	a1,a1,a5
    80000e86:	2585                	addiw	a1,a1,1
    80000e88:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e8c:	4719                	li	a4,6
    80000e8e:	6685                	lui	a3,0x1
    80000e90:	40b905b3          	sub	a1,s2,a1
    80000e94:	854e                	mv	a0,s3
    80000e96:	fffff097          	auipc	ra,0xfffff
    80000e9a:	7d4080e7          	jalr	2004(ra) # 8000066a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e9e:	16848493          	addi	s1,s1,360
    80000ea2:	fd4495e3          	bne	s1,s4,80000e6c <proc_mapstacks+0x38>
  }
}
    80000ea6:	70e2                	ld	ra,56(sp)
    80000ea8:	7442                	ld	s0,48(sp)
    80000eaa:	74a2                	ld	s1,40(sp)
    80000eac:	7902                	ld	s2,32(sp)
    80000eae:	69e2                	ld	s3,24(sp)
    80000eb0:	6a42                	ld	s4,16(sp)
    80000eb2:	6aa2                	ld	s5,8(sp)
    80000eb4:	6b02                	ld	s6,0(sp)
    80000eb6:	6121                	addi	sp,sp,64
    80000eb8:	8082                	ret
      panic("kalloc");
    80000eba:	00007517          	auipc	a0,0x7
    80000ebe:	29e50513          	addi	a0,a0,670 # 80008158 <etext+0x158>
    80000ec2:	00005097          	auipc	ra,0x5
    80000ec6:	e76080e7          	jalr	-394(ra) # 80005d38 <panic>

0000000080000eca <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000eca:	7139                	addi	sp,sp,-64
    80000ecc:	fc06                	sd	ra,56(sp)
    80000ece:	f822                	sd	s0,48(sp)
    80000ed0:	f426                	sd	s1,40(sp)
    80000ed2:	f04a                	sd	s2,32(sp)
    80000ed4:	ec4e                	sd	s3,24(sp)
    80000ed6:	e852                	sd	s4,16(sp)
    80000ed8:	e456                	sd	s5,8(sp)
    80000eda:	e05a                	sd	s6,0(sp)
    80000edc:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ede:	00007597          	auipc	a1,0x7
    80000ee2:	28258593          	addi	a1,a1,642 # 80008160 <etext+0x160>
    80000ee6:	00228517          	auipc	a0,0x228
    80000eea:	18250513          	addi	a0,a0,386 # 80229068 <pid_lock>
    80000eee:	00005097          	auipc	ra,0x5
    80000ef2:	304080e7          	jalr	772(ra) # 800061f2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ef6:	00007597          	auipc	a1,0x7
    80000efa:	27258593          	addi	a1,a1,626 # 80008168 <etext+0x168>
    80000efe:	00228517          	auipc	a0,0x228
    80000f02:	18250513          	addi	a0,a0,386 # 80229080 <wait_lock>
    80000f06:	00005097          	auipc	ra,0x5
    80000f0a:	2ec080e7          	jalr	748(ra) # 800061f2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f0e:	00228497          	auipc	s1,0x228
    80000f12:	58a48493          	addi	s1,s1,1418 # 80229498 <proc>
      initlock(&p->lock, "proc");
    80000f16:	00007b17          	auipc	s6,0x7
    80000f1a:	262b0b13          	addi	s6,s6,610 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000f1e:	8aa6                	mv	s5,s1
    80000f20:	00007a17          	auipc	s4,0x7
    80000f24:	0e0a0a13          	addi	s4,s4,224 # 80008000 <etext>
    80000f28:	04000937          	lui	s2,0x4000
    80000f2c:	197d                	addi	s2,s2,-1
    80000f2e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f30:	0022e997          	auipc	s3,0x22e
    80000f34:	f6898993          	addi	s3,s3,-152 # 8022ee98 <tickslock>
      initlock(&p->lock, "proc");
    80000f38:	85da                	mv	a1,s6
    80000f3a:	8526                	mv	a0,s1
    80000f3c:	00005097          	auipc	ra,0x5
    80000f40:	2b6080e7          	jalr	694(ra) # 800061f2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f44:	415487b3          	sub	a5,s1,s5
    80000f48:	878d                	srai	a5,a5,0x3
    80000f4a:	000a3703          	ld	a4,0(s4)
    80000f4e:	02e787b3          	mul	a5,a5,a4
    80000f52:	2785                	addiw	a5,a5,1
    80000f54:	00d7979b          	slliw	a5,a5,0xd
    80000f58:	40f907b3          	sub	a5,s2,a5
    80000f5c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f5e:	16848493          	addi	s1,s1,360
    80000f62:	fd349be3          	bne	s1,s3,80000f38 <procinit+0x6e>
  }
}
    80000f66:	70e2                	ld	ra,56(sp)
    80000f68:	7442                	ld	s0,48(sp)
    80000f6a:	74a2                	ld	s1,40(sp)
    80000f6c:	7902                	ld	s2,32(sp)
    80000f6e:	69e2                	ld	s3,24(sp)
    80000f70:	6a42                	ld	s4,16(sp)
    80000f72:	6aa2                	ld	s5,8(sp)
    80000f74:	6b02                	ld	s6,0(sp)
    80000f76:	6121                	addi	sp,sp,64
    80000f78:	8082                	ret

0000000080000f7a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f7a:	1141                	addi	sp,sp,-16
    80000f7c:	e422                	sd	s0,8(sp)
    80000f7e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f80:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f82:	2501                	sext.w	a0,a0
    80000f84:	6422                	ld	s0,8(sp)
    80000f86:	0141                	addi	sp,sp,16
    80000f88:	8082                	ret

0000000080000f8a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f8a:	1141                	addi	sp,sp,-16
    80000f8c:	e422                	sd	s0,8(sp)
    80000f8e:	0800                	addi	s0,sp,16
    80000f90:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f92:	2781                	sext.w	a5,a5
    80000f94:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f96:	00228517          	auipc	a0,0x228
    80000f9a:	10250513          	addi	a0,a0,258 # 80229098 <cpus>
    80000f9e:	953e                	add	a0,a0,a5
    80000fa0:	6422                	ld	s0,8(sp)
    80000fa2:	0141                	addi	sp,sp,16
    80000fa4:	8082                	ret

0000000080000fa6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000fa6:	1101                	addi	sp,sp,-32
    80000fa8:	ec06                	sd	ra,24(sp)
    80000faa:	e822                	sd	s0,16(sp)
    80000fac:	e426                	sd	s1,8(sp)
    80000fae:	1000                	addi	s0,sp,32
  push_off();
    80000fb0:	00005097          	auipc	ra,0x5
    80000fb4:	286080e7          	jalr	646(ra) # 80006236 <push_off>
    80000fb8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fba:	2781                	sext.w	a5,a5
    80000fbc:	079e                	slli	a5,a5,0x7
    80000fbe:	00228717          	auipc	a4,0x228
    80000fc2:	0aa70713          	addi	a4,a4,170 # 80229068 <pid_lock>
    80000fc6:	97ba                	add	a5,a5,a4
    80000fc8:	7b84                	ld	s1,48(a5)
  pop_off();
    80000fca:	00005097          	auipc	ra,0x5
    80000fce:	30c080e7          	jalr	780(ra) # 800062d6 <pop_off>
  return p;
}
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	60e2                	ld	ra,24(sp)
    80000fd6:	6442                	ld	s0,16(sp)
    80000fd8:	64a2                	ld	s1,8(sp)
    80000fda:	6105                	addi	sp,sp,32
    80000fdc:	8082                	ret

0000000080000fde <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fde:	1141                	addi	sp,sp,-16
    80000fe0:	e406                	sd	ra,8(sp)
    80000fe2:	e022                	sd	s0,0(sp)
    80000fe4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	fc0080e7          	jalr	-64(ra) # 80000fa6 <myproc>
    80000fee:	00005097          	auipc	ra,0x5
    80000ff2:	348080e7          	jalr	840(ra) # 80006336 <release>

  if (first) {
    80000ff6:	00008797          	auipc	a5,0x8
    80000ffa:	81a7a783          	lw	a5,-2022(a5) # 80008810 <first.1672>
    80000ffe:	eb89                	bnez	a5,80001010 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001000:	00001097          	auipc	ra,0x1
    80001004:	c0a080e7          	jalr	-1014(ra) # 80001c0a <usertrapret>
}
    80001008:	60a2                	ld	ra,8(sp)
    8000100a:	6402                	ld	s0,0(sp)
    8000100c:	0141                	addi	sp,sp,16
    8000100e:	8082                	ret
    first = 0;
    80001010:	00008797          	auipc	a5,0x8
    80001014:	8007a023          	sw	zero,-2048(a5) # 80008810 <first.1672>
    fsinit(ROOTDEV);
    80001018:	4505                	li	a0,1
    8000101a:	00002097          	auipc	ra,0x2
    8000101e:	9f2080e7          	jalr	-1550(ra) # 80002a0c <fsinit>
    80001022:	bff9                	j	80001000 <forkret+0x22>

0000000080001024 <allocpid>:
allocpid() {
    80001024:	1101                	addi	sp,sp,-32
    80001026:	ec06                	sd	ra,24(sp)
    80001028:	e822                	sd	s0,16(sp)
    8000102a:	e426                	sd	s1,8(sp)
    8000102c:	e04a                	sd	s2,0(sp)
    8000102e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001030:	00228917          	auipc	s2,0x228
    80001034:	03890913          	addi	s2,s2,56 # 80229068 <pid_lock>
    80001038:	854a                	mv	a0,s2
    8000103a:	00005097          	auipc	ra,0x5
    8000103e:	248080e7          	jalr	584(ra) # 80006282 <acquire>
  pid = nextpid;
    80001042:	00007797          	auipc	a5,0x7
    80001046:	7d278793          	addi	a5,a5,2002 # 80008814 <nextpid>
    8000104a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000104c:	0014871b          	addiw	a4,s1,1
    80001050:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001052:	854a                	mv	a0,s2
    80001054:	00005097          	auipc	ra,0x5
    80001058:	2e2080e7          	jalr	738(ra) # 80006336 <release>
}
    8000105c:	8526                	mv	a0,s1
    8000105e:	60e2                	ld	ra,24(sp)
    80001060:	6442                	ld	s0,16(sp)
    80001062:	64a2                	ld	s1,8(sp)
    80001064:	6902                	ld	s2,0(sp)
    80001066:	6105                	addi	sp,sp,32
    80001068:	8082                	ret

000000008000106a <proc_pagetable>:
{
    8000106a:	1101                	addi	sp,sp,-32
    8000106c:	ec06                	sd	ra,24(sp)
    8000106e:	e822                	sd	s0,16(sp)
    80001070:	e426                	sd	s1,8(sp)
    80001072:	e04a                	sd	s2,0(sp)
    80001074:	1000                	addi	s0,sp,32
    80001076:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001078:	fffff097          	auipc	ra,0xfffff
    8000107c:	7dc080e7          	jalr	2012(ra) # 80000854 <uvmcreate>
    80001080:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001082:	c121                	beqz	a0,800010c2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001084:	4729                	li	a4,10
    80001086:	00006697          	auipc	a3,0x6
    8000108a:	f7a68693          	addi	a3,a3,-134 # 80007000 <_trampoline>
    8000108e:	6605                	lui	a2,0x1
    80001090:	040005b7          	lui	a1,0x4000
    80001094:	15fd                	addi	a1,a1,-1
    80001096:	05b2                	slli	a1,a1,0xc
    80001098:	fffff097          	auipc	ra,0xfffff
    8000109c:	532080e7          	jalr	1330(ra) # 800005ca <mappages>
    800010a0:	02054863          	bltz	a0,800010d0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010a4:	4719                	li	a4,6
    800010a6:	05893683          	ld	a3,88(s2)
    800010aa:	6605                	lui	a2,0x1
    800010ac:	020005b7          	lui	a1,0x2000
    800010b0:	15fd                	addi	a1,a1,-1
    800010b2:	05b6                	slli	a1,a1,0xd
    800010b4:	8526                	mv	a0,s1
    800010b6:	fffff097          	auipc	ra,0xfffff
    800010ba:	514080e7          	jalr	1300(ra) # 800005ca <mappages>
    800010be:	02054163          	bltz	a0,800010e0 <proc_pagetable+0x76>
}
    800010c2:	8526                	mv	a0,s1
    800010c4:	60e2                	ld	ra,24(sp)
    800010c6:	6442                	ld	s0,16(sp)
    800010c8:	64a2                	ld	s1,8(sp)
    800010ca:	6902                	ld	s2,0(sp)
    800010cc:	6105                	addi	sp,sp,32
    800010ce:	8082                	ret
    uvmfree(pagetable, 0);
    800010d0:	4581                	li	a1,0
    800010d2:	8526                	mv	a0,s1
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	97c080e7          	jalr	-1668(ra) # 80000a50 <uvmfree>
    return 0;
    800010dc:	4481                	li	s1,0
    800010de:	b7d5                	j	800010c2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010e0:	4681                	li	a3,0
    800010e2:	4605                	li	a2,1
    800010e4:	040005b7          	lui	a1,0x4000
    800010e8:	15fd                	addi	a1,a1,-1
    800010ea:	05b2                	slli	a1,a1,0xc
    800010ec:	8526                	mv	a0,s1
    800010ee:	fffff097          	auipc	ra,0xfffff
    800010f2:	6a2080e7          	jalr	1698(ra) # 80000790 <uvmunmap>
    uvmfree(pagetable, 0);
    800010f6:	4581                	li	a1,0
    800010f8:	8526                	mv	a0,s1
    800010fa:	00000097          	auipc	ra,0x0
    800010fe:	956080e7          	jalr	-1706(ra) # 80000a50 <uvmfree>
    return 0;
    80001102:	4481                	li	s1,0
    80001104:	bf7d                	j	800010c2 <proc_pagetable+0x58>

0000000080001106 <proc_freepagetable>:
{
    80001106:	1101                	addi	sp,sp,-32
    80001108:	ec06                	sd	ra,24(sp)
    8000110a:	e822                	sd	s0,16(sp)
    8000110c:	e426                	sd	s1,8(sp)
    8000110e:	e04a                	sd	s2,0(sp)
    80001110:	1000                	addi	s0,sp,32
    80001112:	84aa                	mv	s1,a0
    80001114:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001116:	4681                	li	a3,0
    80001118:	4605                	li	a2,1
    8000111a:	040005b7          	lui	a1,0x4000
    8000111e:	15fd                	addi	a1,a1,-1
    80001120:	05b2                	slli	a1,a1,0xc
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	66e080e7          	jalr	1646(ra) # 80000790 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000112a:	4681                	li	a3,0
    8000112c:	4605                	li	a2,1
    8000112e:	020005b7          	lui	a1,0x2000
    80001132:	15fd                	addi	a1,a1,-1
    80001134:	05b6                	slli	a1,a1,0xd
    80001136:	8526                	mv	a0,s1
    80001138:	fffff097          	auipc	ra,0xfffff
    8000113c:	658080e7          	jalr	1624(ra) # 80000790 <uvmunmap>
  uvmfree(pagetable, sz);
    80001140:	85ca                	mv	a1,s2
    80001142:	8526                	mv	a0,s1
    80001144:	00000097          	auipc	ra,0x0
    80001148:	90c080e7          	jalr	-1780(ra) # 80000a50 <uvmfree>
}
    8000114c:	60e2                	ld	ra,24(sp)
    8000114e:	6442                	ld	s0,16(sp)
    80001150:	64a2                	ld	s1,8(sp)
    80001152:	6902                	ld	s2,0(sp)
    80001154:	6105                	addi	sp,sp,32
    80001156:	8082                	ret

0000000080001158 <freeproc>:
{
    80001158:	1101                	addi	sp,sp,-32
    8000115a:	ec06                	sd	ra,24(sp)
    8000115c:	e822                	sd	s0,16(sp)
    8000115e:	e426                	sd	s1,8(sp)
    80001160:	1000                	addi	s0,sp,32
    80001162:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001164:	6d28                	ld	a0,88(a0)
    80001166:	c509                	beqz	a0,80001170 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001168:	fffff097          	auipc	ra,0xfffff
    8000116c:	eb4080e7          	jalr	-332(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001170:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001174:	68a8                	ld	a0,80(s1)
    80001176:	c511                	beqz	a0,80001182 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001178:	64ac                	ld	a1,72(s1)
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	f8c080e7          	jalr	-116(ra) # 80001106 <proc_freepagetable>
  p->pagetable = 0;
    80001182:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001186:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000118a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000118e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001192:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001196:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000119a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000119e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011a2:	0004ac23          	sw	zero,24(s1)
}
    800011a6:	60e2                	ld	ra,24(sp)
    800011a8:	6442                	ld	s0,16(sp)
    800011aa:	64a2                	ld	s1,8(sp)
    800011ac:	6105                	addi	sp,sp,32
    800011ae:	8082                	ret

00000000800011b0 <allocproc>:
{
    800011b0:	1101                	addi	sp,sp,-32
    800011b2:	ec06                	sd	ra,24(sp)
    800011b4:	e822                	sd	s0,16(sp)
    800011b6:	e426                	sd	s1,8(sp)
    800011b8:	e04a                	sd	s2,0(sp)
    800011ba:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011bc:	00228497          	auipc	s1,0x228
    800011c0:	2dc48493          	addi	s1,s1,732 # 80229498 <proc>
    800011c4:	0022e917          	auipc	s2,0x22e
    800011c8:	cd490913          	addi	s2,s2,-812 # 8022ee98 <tickslock>
    acquire(&p->lock);
    800011cc:	8526                	mv	a0,s1
    800011ce:	00005097          	auipc	ra,0x5
    800011d2:	0b4080e7          	jalr	180(ra) # 80006282 <acquire>
    if(p->state == UNUSED) {
    800011d6:	4c9c                	lw	a5,24(s1)
    800011d8:	cf81                	beqz	a5,800011f0 <allocproc+0x40>
      release(&p->lock);
    800011da:	8526                	mv	a0,s1
    800011dc:	00005097          	auipc	ra,0x5
    800011e0:	15a080e7          	jalr	346(ra) # 80006336 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011e4:	16848493          	addi	s1,s1,360
    800011e8:	ff2492e3          	bne	s1,s2,800011cc <allocproc+0x1c>
  return 0;
    800011ec:	4481                	li	s1,0
    800011ee:	a889                	j	80001240 <allocproc+0x90>
  p->pid = allocpid();
    800011f0:	00000097          	auipc	ra,0x0
    800011f4:	e34080e7          	jalr	-460(ra) # 80001024 <allocpid>
    800011f8:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011fa:	4785                	li	a5,1
    800011fc:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	f60080e7          	jalr	-160(ra) # 8000015e <kalloc>
    80001206:	892a                	mv	s2,a0
    80001208:	eca8                	sd	a0,88(s1)
    8000120a:	c131                	beqz	a0,8000124e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000120c:	8526                	mv	a0,s1
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	e5c080e7          	jalr	-420(ra) # 8000106a <proc_pagetable>
    80001216:	892a                	mv	s2,a0
    80001218:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000121a:	c531                	beqz	a0,80001266 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000121c:	07000613          	li	a2,112
    80001220:	4581                	li	a1,0
    80001222:	06048513          	addi	a0,s1,96
    80001226:	fffff097          	auipc	ra,0xfffff
    8000122a:	fd4080e7          	jalr	-44(ra) # 800001fa <memset>
  p->context.ra = (uint64)forkret;
    8000122e:	00000797          	auipc	a5,0x0
    80001232:	db078793          	addi	a5,a5,-592 # 80000fde <forkret>
    80001236:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001238:	60bc                	ld	a5,64(s1)
    8000123a:	6705                	lui	a4,0x1
    8000123c:	97ba                	add	a5,a5,a4
    8000123e:	f4bc                	sd	a5,104(s1)
}
    80001240:	8526                	mv	a0,s1
    80001242:	60e2                	ld	ra,24(sp)
    80001244:	6442                	ld	s0,16(sp)
    80001246:	64a2                	ld	s1,8(sp)
    80001248:	6902                	ld	s2,0(sp)
    8000124a:	6105                	addi	sp,sp,32
    8000124c:	8082                	ret
    freeproc(p);
    8000124e:	8526                	mv	a0,s1
    80001250:	00000097          	auipc	ra,0x0
    80001254:	f08080e7          	jalr	-248(ra) # 80001158 <freeproc>
    release(&p->lock);
    80001258:	8526                	mv	a0,s1
    8000125a:	00005097          	auipc	ra,0x5
    8000125e:	0dc080e7          	jalr	220(ra) # 80006336 <release>
    return 0;
    80001262:	84ca                	mv	s1,s2
    80001264:	bff1                	j	80001240 <allocproc+0x90>
    freeproc(p);
    80001266:	8526                	mv	a0,s1
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	ef0080e7          	jalr	-272(ra) # 80001158 <freeproc>
    release(&p->lock);
    80001270:	8526                	mv	a0,s1
    80001272:	00005097          	auipc	ra,0x5
    80001276:	0c4080e7          	jalr	196(ra) # 80006336 <release>
    return 0;
    8000127a:	84ca                	mv	s1,s2
    8000127c:	b7d1                	j	80001240 <allocproc+0x90>

000000008000127e <userinit>:
{
    8000127e:	1101                	addi	sp,sp,-32
    80001280:	ec06                	sd	ra,24(sp)
    80001282:	e822                	sd	s0,16(sp)
    80001284:	e426                	sd	s1,8(sp)
    80001286:	1000                	addi	s0,sp,32
  p = allocproc();
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	f28080e7          	jalr	-216(ra) # 800011b0 <allocproc>
    80001290:	84aa                	mv	s1,a0
  initproc = p;
    80001292:	00008797          	auipc	a5,0x8
    80001296:	d6a7bf23          	sd	a0,-642(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000129a:	03400613          	li	a2,52
    8000129e:	00007597          	auipc	a1,0x7
    800012a2:	58258593          	addi	a1,a1,1410 # 80008820 <initcode>
    800012a6:	6928                	ld	a0,80(a0)
    800012a8:	fffff097          	auipc	ra,0xfffff
    800012ac:	5da080e7          	jalr	1498(ra) # 80000882 <uvminit>
  p->sz = PGSIZE;
    800012b0:	6785                	lui	a5,0x1
    800012b2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012b4:	6cb8                	ld	a4,88(s1)
    800012b6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012ba:	6cb8                	ld	a4,88(s1)
    800012bc:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012be:	4641                	li	a2,16
    800012c0:	00007597          	auipc	a1,0x7
    800012c4:	ec058593          	addi	a1,a1,-320 # 80008180 <etext+0x180>
    800012c8:	15848513          	addi	a0,s1,344
    800012cc:	fffff097          	auipc	ra,0xfffff
    800012d0:	080080e7          	jalr	128(ra) # 8000034c <safestrcpy>
  p->cwd = namei("/");
    800012d4:	00007517          	auipc	a0,0x7
    800012d8:	ebc50513          	addi	a0,a0,-324 # 80008190 <etext+0x190>
    800012dc:	00002097          	auipc	ra,0x2
    800012e0:	15e080e7          	jalr	350(ra) # 8000343a <namei>
    800012e4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800012e8:	478d                	li	a5,3
    800012ea:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800012ec:	8526                	mv	a0,s1
    800012ee:	00005097          	auipc	ra,0x5
    800012f2:	048080e7          	jalr	72(ra) # 80006336 <release>
}
    800012f6:	60e2                	ld	ra,24(sp)
    800012f8:	6442                	ld	s0,16(sp)
    800012fa:	64a2                	ld	s1,8(sp)
    800012fc:	6105                	addi	sp,sp,32
    800012fe:	8082                	ret

0000000080001300 <growproc>:
{
    80001300:	1101                	addi	sp,sp,-32
    80001302:	ec06                	sd	ra,24(sp)
    80001304:	e822                	sd	s0,16(sp)
    80001306:	e426                	sd	s1,8(sp)
    80001308:	e04a                	sd	s2,0(sp)
    8000130a:	1000                	addi	s0,sp,32
    8000130c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000130e:	00000097          	auipc	ra,0x0
    80001312:	c98080e7          	jalr	-872(ra) # 80000fa6 <myproc>
    80001316:	892a                	mv	s2,a0
  sz = p->sz;
    80001318:	652c                	ld	a1,72(a0)
    8000131a:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000131e:	00904f63          	bgtz	s1,8000133c <growproc+0x3c>
  } else if(n < 0){
    80001322:	0204cc63          	bltz	s1,8000135a <growproc+0x5a>
  p->sz = sz;
    80001326:	1602                	slli	a2,a2,0x20
    80001328:	9201                	srli	a2,a2,0x20
    8000132a:	04c93423          	sd	a2,72(s2)
  return 0;
    8000132e:	4501                	li	a0,0
}
    80001330:	60e2                	ld	ra,24(sp)
    80001332:	6442                	ld	s0,16(sp)
    80001334:	64a2                	ld	s1,8(sp)
    80001336:	6902                	ld	s2,0(sp)
    80001338:	6105                	addi	sp,sp,32
    8000133a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000133c:	9e25                	addw	a2,a2,s1
    8000133e:	1602                	slli	a2,a2,0x20
    80001340:	9201                	srli	a2,a2,0x20
    80001342:	1582                	slli	a1,a1,0x20
    80001344:	9181                	srli	a1,a1,0x20
    80001346:	6928                	ld	a0,80(a0)
    80001348:	fffff097          	auipc	ra,0xfffff
    8000134c:	5f4080e7          	jalr	1524(ra) # 8000093c <uvmalloc>
    80001350:	0005061b          	sext.w	a2,a0
    80001354:	fa69                	bnez	a2,80001326 <growproc+0x26>
      return -1;
    80001356:	557d                	li	a0,-1
    80001358:	bfe1                	j	80001330 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000135a:	9e25                	addw	a2,a2,s1
    8000135c:	1602                	slli	a2,a2,0x20
    8000135e:	9201                	srli	a2,a2,0x20
    80001360:	1582                	slli	a1,a1,0x20
    80001362:	9181                	srli	a1,a1,0x20
    80001364:	6928                	ld	a0,80(a0)
    80001366:	fffff097          	auipc	ra,0xfffff
    8000136a:	58e080e7          	jalr	1422(ra) # 800008f4 <uvmdealloc>
    8000136e:	0005061b          	sext.w	a2,a0
    80001372:	bf55                	j	80001326 <growproc+0x26>

0000000080001374 <fork>:
{
    80001374:	7179                	addi	sp,sp,-48
    80001376:	f406                	sd	ra,40(sp)
    80001378:	f022                	sd	s0,32(sp)
    8000137a:	ec26                	sd	s1,24(sp)
    8000137c:	e84a                	sd	s2,16(sp)
    8000137e:	e44e                	sd	s3,8(sp)
    80001380:	e052                	sd	s4,0(sp)
    80001382:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001384:	00000097          	auipc	ra,0x0
    80001388:	c22080e7          	jalr	-990(ra) # 80000fa6 <myproc>
    8000138c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000138e:	00000097          	auipc	ra,0x0
    80001392:	e22080e7          	jalr	-478(ra) # 800011b0 <allocproc>
    80001396:	10050b63          	beqz	a0,800014ac <fork+0x138>
    8000139a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000139c:	04893603          	ld	a2,72(s2)
    800013a0:	692c                	ld	a1,80(a0)
    800013a2:	05093503          	ld	a0,80(s2)
    800013a6:	fffff097          	auipc	ra,0xfffff
    800013aa:	6e2080e7          	jalr	1762(ra) # 80000a88 <uvmcopy>
    800013ae:	04054663          	bltz	a0,800013fa <fork+0x86>
  np->sz = p->sz;
    800013b2:	04893783          	ld	a5,72(s2)
    800013b6:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800013ba:	05893683          	ld	a3,88(s2)
    800013be:	87b6                	mv	a5,a3
    800013c0:	0589b703          	ld	a4,88(s3)
    800013c4:	12068693          	addi	a3,a3,288
    800013c8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013cc:	6788                	ld	a0,8(a5)
    800013ce:	6b8c                	ld	a1,16(a5)
    800013d0:	6f90                	ld	a2,24(a5)
    800013d2:	01073023          	sd	a6,0(a4)
    800013d6:	e708                	sd	a0,8(a4)
    800013d8:	eb0c                	sd	a1,16(a4)
    800013da:	ef10                	sd	a2,24(a4)
    800013dc:	02078793          	addi	a5,a5,32
    800013e0:	02070713          	addi	a4,a4,32
    800013e4:	fed792e3          	bne	a5,a3,800013c8 <fork+0x54>
  np->trapframe->a0 = 0;
    800013e8:	0589b783          	ld	a5,88(s3)
    800013ec:	0607b823          	sd	zero,112(a5)
    800013f0:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800013f4:	15000a13          	li	s4,336
    800013f8:	a03d                	j	80001426 <fork+0xb2>
    freeproc(np);
    800013fa:	854e                	mv	a0,s3
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	d5c080e7          	jalr	-676(ra) # 80001158 <freeproc>
    release(&np->lock);
    80001404:	854e                	mv	a0,s3
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	f30080e7          	jalr	-208(ra) # 80006336 <release>
    return -1;
    8000140e:	5a7d                	li	s4,-1
    80001410:	a069                	j	8000149a <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001412:	00002097          	auipc	ra,0x2
    80001416:	6be080e7          	jalr	1726(ra) # 80003ad0 <filedup>
    8000141a:	009987b3          	add	a5,s3,s1
    8000141e:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001420:	04a1                	addi	s1,s1,8
    80001422:	01448763          	beq	s1,s4,80001430 <fork+0xbc>
    if(p->ofile[i])
    80001426:	009907b3          	add	a5,s2,s1
    8000142a:	6388                	ld	a0,0(a5)
    8000142c:	f17d                	bnez	a0,80001412 <fork+0x9e>
    8000142e:	bfcd                	j	80001420 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001430:	15093503          	ld	a0,336(s2)
    80001434:	00002097          	auipc	ra,0x2
    80001438:	812080e7          	jalr	-2030(ra) # 80002c46 <idup>
    8000143c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001440:	4641                	li	a2,16
    80001442:	15890593          	addi	a1,s2,344
    80001446:	15898513          	addi	a0,s3,344
    8000144a:	fffff097          	auipc	ra,0xfffff
    8000144e:	f02080e7          	jalr	-254(ra) # 8000034c <safestrcpy>
  pid = np->pid;
    80001452:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001456:	854e                	mv	a0,s3
    80001458:	00005097          	auipc	ra,0x5
    8000145c:	ede080e7          	jalr	-290(ra) # 80006336 <release>
  acquire(&wait_lock);
    80001460:	00228497          	auipc	s1,0x228
    80001464:	c2048493          	addi	s1,s1,-992 # 80229080 <wait_lock>
    80001468:	8526                	mv	a0,s1
    8000146a:	00005097          	auipc	ra,0x5
    8000146e:	e18080e7          	jalr	-488(ra) # 80006282 <acquire>
  np->parent = p;
    80001472:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001476:	8526                	mv	a0,s1
    80001478:	00005097          	auipc	ra,0x5
    8000147c:	ebe080e7          	jalr	-322(ra) # 80006336 <release>
  acquire(&np->lock);
    80001480:	854e                	mv	a0,s3
    80001482:	00005097          	auipc	ra,0x5
    80001486:	e00080e7          	jalr	-512(ra) # 80006282 <acquire>
  np->state = RUNNABLE;
    8000148a:	478d                	li	a5,3
    8000148c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001490:	854e                	mv	a0,s3
    80001492:	00005097          	auipc	ra,0x5
    80001496:	ea4080e7          	jalr	-348(ra) # 80006336 <release>
}
    8000149a:	8552                	mv	a0,s4
    8000149c:	70a2                	ld	ra,40(sp)
    8000149e:	7402                	ld	s0,32(sp)
    800014a0:	64e2                	ld	s1,24(sp)
    800014a2:	6942                	ld	s2,16(sp)
    800014a4:	69a2                	ld	s3,8(sp)
    800014a6:	6a02                	ld	s4,0(sp)
    800014a8:	6145                	addi	sp,sp,48
    800014aa:	8082                	ret
    return -1;
    800014ac:	5a7d                	li	s4,-1
    800014ae:	b7f5                	j	8000149a <fork+0x126>

00000000800014b0 <scheduler>:
{
    800014b0:	7139                	addi	sp,sp,-64
    800014b2:	fc06                	sd	ra,56(sp)
    800014b4:	f822                	sd	s0,48(sp)
    800014b6:	f426                	sd	s1,40(sp)
    800014b8:	f04a                	sd	s2,32(sp)
    800014ba:	ec4e                	sd	s3,24(sp)
    800014bc:	e852                	sd	s4,16(sp)
    800014be:	e456                	sd	s5,8(sp)
    800014c0:	e05a                	sd	s6,0(sp)
    800014c2:	0080                	addi	s0,sp,64
    800014c4:	8792                	mv	a5,tp
  int id = r_tp();
    800014c6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014c8:	00779a93          	slli	s5,a5,0x7
    800014cc:	00228717          	auipc	a4,0x228
    800014d0:	b9c70713          	addi	a4,a4,-1124 # 80229068 <pid_lock>
    800014d4:	9756                	add	a4,a4,s5
    800014d6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014da:	00228717          	auipc	a4,0x228
    800014de:	bc670713          	addi	a4,a4,-1082 # 802290a0 <cpus+0x8>
    800014e2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014e4:	498d                	li	s3,3
        p->state = RUNNING;
    800014e6:	4b11                	li	s6,4
        c->proc = p;
    800014e8:	079e                	slli	a5,a5,0x7
    800014ea:	00228a17          	auipc	s4,0x228
    800014ee:	b7ea0a13          	addi	s4,s4,-1154 # 80229068 <pid_lock>
    800014f2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014f4:	0022e917          	auipc	s2,0x22e
    800014f8:	9a490913          	addi	s2,s2,-1628 # 8022ee98 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001500:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001504:	10079073          	csrw	sstatus,a5
    80001508:	00228497          	auipc	s1,0x228
    8000150c:	f9048493          	addi	s1,s1,-112 # 80229498 <proc>
    80001510:	a03d                	j	8000153e <scheduler+0x8e>
        p->state = RUNNING;
    80001512:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001516:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000151a:	06048593          	addi	a1,s1,96
    8000151e:	8556                	mv	a0,s5
    80001520:	00000097          	auipc	ra,0x0
    80001524:	640080e7          	jalr	1600(ra) # 80001b60 <swtch>
        c->proc = 0;
    80001528:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000152c:	8526                	mv	a0,s1
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	e08080e7          	jalr	-504(ra) # 80006336 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001536:	16848493          	addi	s1,s1,360
    8000153a:	fd2481e3          	beq	s1,s2,800014fc <scheduler+0x4c>
      acquire(&p->lock);
    8000153e:	8526                	mv	a0,s1
    80001540:	00005097          	auipc	ra,0x5
    80001544:	d42080e7          	jalr	-702(ra) # 80006282 <acquire>
      if(p->state == RUNNABLE) {
    80001548:	4c9c                	lw	a5,24(s1)
    8000154a:	ff3791e3          	bne	a5,s3,8000152c <scheduler+0x7c>
    8000154e:	b7d1                	j	80001512 <scheduler+0x62>

0000000080001550 <sched>:
{
    80001550:	7179                	addi	sp,sp,-48
    80001552:	f406                	sd	ra,40(sp)
    80001554:	f022                	sd	s0,32(sp)
    80001556:	ec26                	sd	s1,24(sp)
    80001558:	e84a                	sd	s2,16(sp)
    8000155a:	e44e                	sd	s3,8(sp)
    8000155c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	a48080e7          	jalr	-1464(ra) # 80000fa6 <myproc>
    80001566:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	ca0080e7          	jalr	-864(ra) # 80006208 <holding>
    80001570:	c93d                	beqz	a0,800015e6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001572:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001574:	2781                	sext.w	a5,a5
    80001576:	079e                	slli	a5,a5,0x7
    80001578:	00228717          	auipc	a4,0x228
    8000157c:	af070713          	addi	a4,a4,-1296 # 80229068 <pid_lock>
    80001580:	97ba                	add	a5,a5,a4
    80001582:	0a87a703          	lw	a4,168(a5)
    80001586:	4785                	li	a5,1
    80001588:	06f71763          	bne	a4,a5,800015f6 <sched+0xa6>
  if(p->state == RUNNING)
    8000158c:	4c98                	lw	a4,24(s1)
    8000158e:	4791                	li	a5,4
    80001590:	06f70b63          	beq	a4,a5,80001606 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001594:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001598:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000159a:	efb5                	bnez	a5,80001616 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000159c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000159e:	00228917          	auipc	s2,0x228
    800015a2:	aca90913          	addi	s2,s2,-1334 # 80229068 <pid_lock>
    800015a6:	2781                	sext.w	a5,a5
    800015a8:	079e                	slli	a5,a5,0x7
    800015aa:	97ca                	add	a5,a5,s2
    800015ac:	0ac7a983          	lw	s3,172(a5)
    800015b0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015b2:	2781                	sext.w	a5,a5
    800015b4:	079e                	slli	a5,a5,0x7
    800015b6:	00228597          	auipc	a1,0x228
    800015ba:	aea58593          	addi	a1,a1,-1302 # 802290a0 <cpus+0x8>
    800015be:	95be                	add	a1,a1,a5
    800015c0:	06048513          	addi	a0,s1,96
    800015c4:	00000097          	auipc	ra,0x0
    800015c8:	59c080e7          	jalr	1436(ra) # 80001b60 <swtch>
    800015cc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015ce:	2781                	sext.w	a5,a5
    800015d0:	079e                	slli	a5,a5,0x7
    800015d2:	97ca                	add	a5,a5,s2
    800015d4:	0b37a623          	sw	s3,172(a5)
}
    800015d8:	70a2                	ld	ra,40(sp)
    800015da:	7402                	ld	s0,32(sp)
    800015dc:	64e2                	ld	s1,24(sp)
    800015de:	6942                	ld	s2,16(sp)
    800015e0:	69a2                	ld	s3,8(sp)
    800015e2:	6145                	addi	sp,sp,48
    800015e4:	8082                	ret
    panic("sched p->lock");
    800015e6:	00007517          	auipc	a0,0x7
    800015ea:	bb250513          	addi	a0,a0,-1102 # 80008198 <etext+0x198>
    800015ee:	00004097          	auipc	ra,0x4
    800015f2:	74a080e7          	jalr	1866(ra) # 80005d38 <panic>
    panic("sched locks");
    800015f6:	00007517          	auipc	a0,0x7
    800015fa:	bb250513          	addi	a0,a0,-1102 # 800081a8 <etext+0x1a8>
    800015fe:	00004097          	auipc	ra,0x4
    80001602:	73a080e7          	jalr	1850(ra) # 80005d38 <panic>
    panic("sched running");
    80001606:	00007517          	auipc	a0,0x7
    8000160a:	bb250513          	addi	a0,a0,-1102 # 800081b8 <etext+0x1b8>
    8000160e:	00004097          	auipc	ra,0x4
    80001612:	72a080e7          	jalr	1834(ra) # 80005d38 <panic>
    panic("sched interruptible");
    80001616:	00007517          	auipc	a0,0x7
    8000161a:	bb250513          	addi	a0,a0,-1102 # 800081c8 <etext+0x1c8>
    8000161e:	00004097          	auipc	ra,0x4
    80001622:	71a080e7          	jalr	1818(ra) # 80005d38 <panic>

0000000080001626 <yield>:
{
    80001626:	1101                	addi	sp,sp,-32
    80001628:	ec06                	sd	ra,24(sp)
    8000162a:	e822                	sd	s0,16(sp)
    8000162c:	e426                	sd	s1,8(sp)
    8000162e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001630:	00000097          	auipc	ra,0x0
    80001634:	976080e7          	jalr	-1674(ra) # 80000fa6 <myproc>
    80001638:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000163a:	00005097          	auipc	ra,0x5
    8000163e:	c48080e7          	jalr	-952(ra) # 80006282 <acquire>
  p->state = RUNNABLE;
    80001642:	478d                	li	a5,3
    80001644:	cc9c                	sw	a5,24(s1)
  sched();
    80001646:	00000097          	auipc	ra,0x0
    8000164a:	f0a080e7          	jalr	-246(ra) # 80001550 <sched>
  release(&p->lock);
    8000164e:	8526                	mv	a0,s1
    80001650:	00005097          	auipc	ra,0x5
    80001654:	ce6080e7          	jalr	-794(ra) # 80006336 <release>
}
    80001658:	60e2                	ld	ra,24(sp)
    8000165a:	6442                	ld	s0,16(sp)
    8000165c:	64a2                	ld	s1,8(sp)
    8000165e:	6105                	addi	sp,sp,32
    80001660:	8082                	ret

0000000080001662 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001662:	7179                	addi	sp,sp,-48
    80001664:	f406                	sd	ra,40(sp)
    80001666:	f022                	sd	s0,32(sp)
    80001668:	ec26                	sd	s1,24(sp)
    8000166a:	e84a                	sd	s2,16(sp)
    8000166c:	e44e                	sd	s3,8(sp)
    8000166e:	1800                	addi	s0,sp,48
    80001670:	89aa                	mv	s3,a0
    80001672:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001674:	00000097          	auipc	ra,0x0
    80001678:	932080e7          	jalr	-1742(ra) # 80000fa6 <myproc>
    8000167c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	c04080e7          	jalr	-1020(ra) # 80006282 <acquire>
  release(lk);
    80001686:	854a                	mv	a0,s2
    80001688:	00005097          	auipc	ra,0x5
    8000168c:	cae080e7          	jalr	-850(ra) # 80006336 <release>

  // Go to sleep.
  p->chan = chan;
    80001690:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001694:	4789                	li	a5,2
    80001696:	cc9c                	sw	a5,24(s1)

  sched();
    80001698:	00000097          	auipc	ra,0x0
    8000169c:	eb8080e7          	jalr	-328(ra) # 80001550 <sched>

  // Tidy up.
  p->chan = 0;
    800016a0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016a4:	8526                	mv	a0,s1
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	c90080e7          	jalr	-880(ra) # 80006336 <release>
  acquire(lk);
    800016ae:	854a                	mv	a0,s2
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	bd2080e7          	jalr	-1070(ra) # 80006282 <acquire>
}
    800016b8:	70a2                	ld	ra,40(sp)
    800016ba:	7402                	ld	s0,32(sp)
    800016bc:	64e2                	ld	s1,24(sp)
    800016be:	6942                	ld	s2,16(sp)
    800016c0:	69a2                	ld	s3,8(sp)
    800016c2:	6145                	addi	sp,sp,48
    800016c4:	8082                	ret

00000000800016c6 <wait>:
{
    800016c6:	715d                	addi	sp,sp,-80
    800016c8:	e486                	sd	ra,72(sp)
    800016ca:	e0a2                	sd	s0,64(sp)
    800016cc:	fc26                	sd	s1,56(sp)
    800016ce:	f84a                	sd	s2,48(sp)
    800016d0:	f44e                	sd	s3,40(sp)
    800016d2:	f052                	sd	s4,32(sp)
    800016d4:	ec56                	sd	s5,24(sp)
    800016d6:	e85a                	sd	s6,16(sp)
    800016d8:	e45e                	sd	s7,8(sp)
    800016da:	e062                	sd	s8,0(sp)
    800016dc:	0880                	addi	s0,sp,80
    800016de:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016e0:	00000097          	auipc	ra,0x0
    800016e4:	8c6080e7          	jalr	-1850(ra) # 80000fa6 <myproc>
    800016e8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016ea:	00228517          	auipc	a0,0x228
    800016ee:	99650513          	addi	a0,a0,-1642 # 80229080 <wait_lock>
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	b90080e7          	jalr	-1136(ra) # 80006282 <acquire>
    havekids = 0;
    800016fa:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016fc:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800016fe:	0022d997          	auipc	s3,0x22d
    80001702:	79a98993          	addi	s3,s3,1946 # 8022ee98 <tickslock>
        havekids = 1;
    80001706:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001708:	00228c17          	auipc	s8,0x228
    8000170c:	978c0c13          	addi	s8,s8,-1672 # 80229080 <wait_lock>
    havekids = 0;
    80001710:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001712:	00228497          	auipc	s1,0x228
    80001716:	d8648493          	addi	s1,s1,-634 # 80229498 <proc>
    8000171a:	a0bd                	j	80001788 <wait+0xc2>
          pid = np->pid;
    8000171c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001720:	000b0e63          	beqz	s6,8000173c <wait+0x76>
    80001724:	4691                	li	a3,4
    80001726:	02c48613          	addi	a2,s1,44
    8000172a:	85da                	mv	a1,s6
    8000172c:	05093503          	ld	a0,80(s2)
    80001730:	fffff097          	auipc	ra,0xfffff
    80001734:	4a6080e7          	jalr	1190(ra) # 80000bd6 <copyout>
    80001738:	02054563          	bltz	a0,80001762 <wait+0x9c>
          freeproc(np);
    8000173c:	8526                	mv	a0,s1
    8000173e:	00000097          	auipc	ra,0x0
    80001742:	a1a080e7          	jalr	-1510(ra) # 80001158 <freeproc>
          release(&np->lock);
    80001746:	8526                	mv	a0,s1
    80001748:	00005097          	auipc	ra,0x5
    8000174c:	bee080e7          	jalr	-1042(ra) # 80006336 <release>
          release(&wait_lock);
    80001750:	00228517          	auipc	a0,0x228
    80001754:	93050513          	addi	a0,a0,-1744 # 80229080 <wait_lock>
    80001758:	00005097          	auipc	ra,0x5
    8000175c:	bde080e7          	jalr	-1058(ra) # 80006336 <release>
          return pid;
    80001760:	a09d                	j	800017c6 <wait+0x100>
            release(&np->lock);
    80001762:	8526                	mv	a0,s1
    80001764:	00005097          	auipc	ra,0x5
    80001768:	bd2080e7          	jalr	-1070(ra) # 80006336 <release>
            release(&wait_lock);
    8000176c:	00228517          	auipc	a0,0x228
    80001770:	91450513          	addi	a0,a0,-1772 # 80229080 <wait_lock>
    80001774:	00005097          	auipc	ra,0x5
    80001778:	bc2080e7          	jalr	-1086(ra) # 80006336 <release>
            return -1;
    8000177c:	59fd                	li	s3,-1
    8000177e:	a0a1                	j	800017c6 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001780:	16848493          	addi	s1,s1,360
    80001784:	03348463          	beq	s1,s3,800017ac <wait+0xe6>
      if(np->parent == p){
    80001788:	7c9c                	ld	a5,56(s1)
    8000178a:	ff279be3          	bne	a5,s2,80001780 <wait+0xba>
        acquire(&np->lock);
    8000178e:	8526                	mv	a0,s1
    80001790:	00005097          	auipc	ra,0x5
    80001794:	af2080e7          	jalr	-1294(ra) # 80006282 <acquire>
        if(np->state == ZOMBIE){
    80001798:	4c9c                	lw	a5,24(s1)
    8000179a:	f94781e3          	beq	a5,s4,8000171c <wait+0x56>
        release(&np->lock);
    8000179e:	8526                	mv	a0,s1
    800017a0:	00005097          	auipc	ra,0x5
    800017a4:	b96080e7          	jalr	-1130(ra) # 80006336 <release>
        havekids = 1;
    800017a8:	8756                	mv	a4,s5
    800017aa:	bfd9                	j	80001780 <wait+0xba>
    if(!havekids || p->killed){
    800017ac:	c701                	beqz	a4,800017b4 <wait+0xee>
    800017ae:	02892783          	lw	a5,40(s2)
    800017b2:	c79d                	beqz	a5,800017e0 <wait+0x11a>
      release(&wait_lock);
    800017b4:	00228517          	auipc	a0,0x228
    800017b8:	8cc50513          	addi	a0,a0,-1844 # 80229080 <wait_lock>
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	b7a080e7          	jalr	-1158(ra) # 80006336 <release>
      return -1;
    800017c4:	59fd                	li	s3,-1
}
    800017c6:	854e                	mv	a0,s3
    800017c8:	60a6                	ld	ra,72(sp)
    800017ca:	6406                	ld	s0,64(sp)
    800017cc:	74e2                	ld	s1,56(sp)
    800017ce:	7942                	ld	s2,48(sp)
    800017d0:	79a2                	ld	s3,40(sp)
    800017d2:	7a02                	ld	s4,32(sp)
    800017d4:	6ae2                	ld	s5,24(sp)
    800017d6:	6b42                	ld	s6,16(sp)
    800017d8:	6ba2                	ld	s7,8(sp)
    800017da:	6c02                	ld	s8,0(sp)
    800017dc:	6161                	addi	sp,sp,80
    800017de:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017e0:	85e2                	mv	a1,s8
    800017e2:	854a                	mv	a0,s2
    800017e4:	00000097          	auipc	ra,0x0
    800017e8:	e7e080e7          	jalr	-386(ra) # 80001662 <sleep>
    havekids = 0;
    800017ec:	b715                	j	80001710 <wait+0x4a>

00000000800017ee <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017ee:	7139                	addi	sp,sp,-64
    800017f0:	fc06                	sd	ra,56(sp)
    800017f2:	f822                	sd	s0,48(sp)
    800017f4:	f426                	sd	s1,40(sp)
    800017f6:	f04a                	sd	s2,32(sp)
    800017f8:	ec4e                	sd	s3,24(sp)
    800017fa:	e852                	sd	s4,16(sp)
    800017fc:	e456                	sd	s5,8(sp)
    800017fe:	0080                	addi	s0,sp,64
    80001800:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001802:	00228497          	auipc	s1,0x228
    80001806:	c9648493          	addi	s1,s1,-874 # 80229498 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000180a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000180c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000180e:	0022d917          	auipc	s2,0x22d
    80001812:	68a90913          	addi	s2,s2,1674 # 8022ee98 <tickslock>
    80001816:	a821                	j	8000182e <wakeup+0x40>
        p->state = RUNNABLE;
    80001818:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000181c:	8526                	mv	a0,s1
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	b18080e7          	jalr	-1256(ra) # 80006336 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001826:	16848493          	addi	s1,s1,360
    8000182a:	03248463          	beq	s1,s2,80001852 <wakeup+0x64>
    if(p != myproc()){
    8000182e:	fffff097          	auipc	ra,0xfffff
    80001832:	778080e7          	jalr	1912(ra) # 80000fa6 <myproc>
    80001836:	fea488e3          	beq	s1,a0,80001826 <wakeup+0x38>
      acquire(&p->lock);
    8000183a:	8526                	mv	a0,s1
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	a46080e7          	jalr	-1466(ra) # 80006282 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001844:	4c9c                	lw	a5,24(s1)
    80001846:	fd379be3          	bne	a5,s3,8000181c <wakeup+0x2e>
    8000184a:	709c                	ld	a5,32(s1)
    8000184c:	fd4798e3          	bne	a5,s4,8000181c <wakeup+0x2e>
    80001850:	b7e1                	j	80001818 <wakeup+0x2a>
    }
  }
}
    80001852:	70e2                	ld	ra,56(sp)
    80001854:	7442                	ld	s0,48(sp)
    80001856:	74a2                	ld	s1,40(sp)
    80001858:	7902                	ld	s2,32(sp)
    8000185a:	69e2                	ld	s3,24(sp)
    8000185c:	6a42                	ld	s4,16(sp)
    8000185e:	6aa2                	ld	s5,8(sp)
    80001860:	6121                	addi	sp,sp,64
    80001862:	8082                	ret

0000000080001864 <reparent>:
{
    80001864:	7179                	addi	sp,sp,-48
    80001866:	f406                	sd	ra,40(sp)
    80001868:	f022                	sd	s0,32(sp)
    8000186a:	ec26                	sd	s1,24(sp)
    8000186c:	e84a                	sd	s2,16(sp)
    8000186e:	e44e                	sd	s3,8(sp)
    80001870:	e052                	sd	s4,0(sp)
    80001872:	1800                	addi	s0,sp,48
    80001874:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001876:	00228497          	auipc	s1,0x228
    8000187a:	c2248493          	addi	s1,s1,-990 # 80229498 <proc>
      pp->parent = initproc;
    8000187e:	00007a17          	auipc	s4,0x7
    80001882:	792a0a13          	addi	s4,s4,1938 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001886:	0022d997          	auipc	s3,0x22d
    8000188a:	61298993          	addi	s3,s3,1554 # 8022ee98 <tickslock>
    8000188e:	a029                	j	80001898 <reparent+0x34>
    80001890:	16848493          	addi	s1,s1,360
    80001894:	01348d63          	beq	s1,s3,800018ae <reparent+0x4a>
    if(pp->parent == p){
    80001898:	7c9c                	ld	a5,56(s1)
    8000189a:	ff279be3          	bne	a5,s2,80001890 <reparent+0x2c>
      pp->parent = initproc;
    8000189e:	000a3503          	ld	a0,0(s4)
    800018a2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018a4:	00000097          	auipc	ra,0x0
    800018a8:	f4a080e7          	jalr	-182(ra) # 800017ee <wakeup>
    800018ac:	b7d5                	j	80001890 <reparent+0x2c>
}
    800018ae:	70a2                	ld	ra,40(sp)
    800018b0:	7402                	ld	s0,32(sp)
    800018b2:	64e2                	ld	s1,24(sp)
    800018b4:	6942                	ld	s2,16(sp)
    800018b6:	69a2                	ld	s3,8(sp)
    800018b8:	6a02                	ld	s4,0(sp)
    800018ba:	6145                	addi	sp,sp,48
    800018bc:	8082                	ret

00000000800018be <exit>:
{
    800018be:	7179                	addi	sp,sp,-48
    800018c0:	f406                	sd	ra,40(sp)
    800018c2:	f022                	sd	s0,32(sp)
    800018c4:	ec26                	sd	s1,24(sp)
    800018c6:	e84a                	sd	s2,16(sp)
    800018c8:	e44e                	sd	s3,8(sp)
    800018ca:	e052                	sd	s4,0(sp)
    800018cc:	1800                	addi	s0,sp,48
    800018ce:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018d0:	fffff097          	auipc	ra,0xfffff
    800018d4:	6d6080e7          	jalr	1750(ra) # 80000fa6 <myproc>
    800018d8:	89aa                	mv	s3,a0
  if(p == initproc)
    800018da:	00007797          	auipc	a5,0x7
    800018de:	7367b783          	ld	a5,1846(a5) # 80009010 <initproc>
    800018e2:	0d050493          	addi	s1,a0,208
    800018e6:	15050913          	addi	s2,a0,336
    800018ea:	02a79363          	bne	a5,a0,80001910 <exit+0x52>
    panic("init exiting");
    800018ee:	00007517          	auipc	a0,0x7
    800018f2:	8f250513          	addi	a0,a0,-1806 # 800081e0 <etext+0x1e0>
    800018f6:	00004097          	auipc	ra,0x4
    800018fa:	442080e7          	jalr	1090(ra) # 80005d38 <panic>
      fileclose(f);
    800018fe:	00002097          	auipc	ra,0x2
    80001902:	224080e7          	jalr	548(ra) # 80003b22 <fileclose>
      p->ofile[fd] = 0;
    80001906:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000190a:	04a1                	addi	s1,s1,8
    8000190c:	01248563          	beq	s1,s2,80001916 <exit+0x58>
    if(p->ofile[fd]){
    80001910:	6088                	ld	a0,0(s1)
    80001912:	f575                	bnez	a0,800018fe <exit+0x40>
    80001914:	bfdd                	j	8000190a <exit+0x4c>
  begin_op();
    80001916:	00002097          	auipc	ra,0x2
    8000191a:	d40080e7          	jalr	-704(ra) # 80003656 <begin_op>
  iput(p->cwd);
    8000191e:	1509b503          	ld	a0,336(s3)
    80001922:	00001097          	auipc	ra,0x1
    80001926:	51c080e7          	jalr	1308(ra) # 80002e3e <iput>
  end_op();
    8000192a:	00002097          	auipc	ra,0x2
    8000192e:	dac080e7          	jalr	-596(ra) # 800036d6 <end_op>
  p->cwd = 0;
    80001932:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001936:	00227497          	auipc	s1,0x227
    8000193a:	74a48493          	addi	s1,s1,1866 # 80229080 <wait_lock>
    8000193e:	8526                	mv	a0,s1
    80001940:	00005097          	auipc	ra,0x5
    80001944:	942080e7          	jalr	-1726(ra) # 80006282 <acquire>
  reparent(p);
    80001948:	854e                	mv	a0,s3
    8000194a:	00000097          	auipc	ra,0x0
    8000194e:	f1a080e7          	jalr	-230(ra) # 80001864 <reparent>
  wakeup(p->parent);
    80001952:	0389b503          	ld	a0,56(s3)
    80001956:	00000097          	auipc	ra,0x0
    8000195a:	e98080e7          	jalr	-360(ra) # 800017ee <wakeup>
  acquire(&p->lock);
    8000195e:	854e                	mv	a0,s3
    80001960:	00005097          	auipc	ra,0x5
    80001964:	922080e7          	jalr	-1758(ra) # 80006282 <acquire>
  p->xstate = status;
    80001968:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000196c:	4795                	li	a5,5
    8000196e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001972:	8526                	mv	a0,s1
    80001974:	00005097          	auipc	ra,0x5
    80001978:	9c2080e7          	jalr	-1598(ra) # 80006336 <release>
  sched();
    8000197c:	00000097          	auipc	ra,0x0
    80001980:	bd4080e7          	jalr	-1068(ra) # 80001550 <sched>
  panic("zombie exit");
    80001984:	00007517          	auipc	a0,0x7
    80001988:	86c50513          	addi	a0,a0,-1940 # 800081f0 <etext+0x1f0>
    8000198c:	00004097          	auipc	ra,0x4
    80001990:	3ac080e7          	jalr	940(ra) # 80005d38 <panic>

0000000080001994 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001994:	7179                	addi	sp,sp,-48
    80001996:	f406                	sd	ra,40(sp)
    80001998:	f022                	sd	s0,32(sp)
    8000199a:	ec26                	sd	s1,24(sp)
    8000199c:	e84a                	sd	s2,16(sp)
    8000199e:	e44e                	sd	s3,8(sp)
    800019a0:	1800                	addi	s0,sp,48
    800019a2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019a4:	00228497          	auipc	s1,0x228
    800019a8:	af448493          	addi	s1,s1,-1292 # 80229498 <proc>
    800019ac:	0022d997          	auipc	s3,0x22d
    800019b0:	4ec98993          	addi	s3,s3,1260 # 8022ee98 <tickslock>
    acquire(&p->lock);
    800019b4:	8526                	mv	a0,s1
    800019b6:	00005097          	auipc	ra,0x5
    800019ba:	8cc080e7          	jalr	-1844(ra) # 80006282 <acquire>
    if(p->pid == pid){
    800019be:	589c                	lw	a5,48(s1)
    800019c0:	01278d63          	beq	a5,s2,800019da <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019c4:	8526                	mv	a0,s1
    800019c6:	00005097          	auipc	ra,0x5
    800019ca:	970080e7          	jalr	-1680(ra) # 80006336 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ce:	16848493          	addi	s1,s1,360
    800019d2:	ff3491e3          	bne	s1,s3,800019b4 <kill+0x20>
  }
  return -1;
    800019d6:	557d                	li	a0,-1
    800019d8:	a829                	j	800019f2 <kill+0x5e>
      p->killed = 1;
    800019da:	4785                	li	a5,1
    800019dc:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019de:	4c98                	lw	a4,24(s1)
    800019e0:	4789                	li	a5,2
    800019e2:	00f70f63          	beq	a4,a5,80001a00 <kill+0x6c>
      release(&p->lock);
    800019e6:	8526                	mv	a0,s1
    800019e8:	00005097          	auipc	ra,0x5
    800019ec:	94e080e7          	jalr	-1714(ra) # 80006336 <release>
      return 0;
    800019f0:	4501                	li	a0,0
}
    800019f2:	70a2                	ld	ra,40(sp)
    800019f4:	7402                	ld	s0,32(sp)
    800019f6:	64e2                	ld	s1,24(sp)
    800019f8:	6942                	ld	s2,16(sp)
    800019fa:	69a2                	ld	s3,8(sp)
    800019fc:	6145                	addi	sp,sp,48
    800019fe:	8082                	ret
        p->state = RUNNABLE;
    80001a00:	478d                	li	a5,3
    80001a02:	cc9c                	sw	a5,24(s1)
    80001a04:	b7cd                	j	800019e6 <kill+0x52>

0000000080001a06 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a06:	7179                	addi	sp,sp,-48
    80001a08:	f406                	sd	ra,40(sp)
    80001a0a:	f022                	sd	s0,32(sp)
    80001a0c:	ec26                	sd	s1,24(sp)
    80001a0e:	e84a                	sd	s2,16(sp)
    80001a10:	e44e                	sd	s3,8(sp)
    80001a12:	e052                	sd	s4,0(sp)
    80001a14:	1800                	addi	s0,sp,48
    80001a16:	84aa                	mv	s1,a0
    80001a18:	892e                	mv	s2,a1
    80001a1a:	89b2                	mv	s3,a2
    80001a1c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a1e:	fffff097          	auipc	ra,0xfffff
    80001a22:	588080e7          	jalr	1416(ra) # 80000fa6 <myproc>
  if(user_dst){
    80001a26:	c08d                	beqz	s1,80001a48 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a28:	86d2                	mv	a3,s4
    80001a2a:	864e                	mv	a2,s3
    80001a2c:	85ca                	mv	a1,s2
    80001a2e:	6928                	ld	a0,80(a0)
    80001a30:	fffff097          	auipc	ra,0xfffff
    80001a34:	1a6080e7          	jalr	422(ra) # 80000bd6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a38:	70a2                	ld	ra,40(sp)
    80001a3a:	7402                	ld	s0,32(sp)
    80001a3c:	64e2                	ld	s1,24(sp)
    80001a3e:	6942                	ld	s2,16(sp)
    80001a40:	69a2                	ld	s3,8(sp)
    80001a42:	6a02                	ld	s4,0(sp)
    80001a44:	6145                	addi	sp,sp,48
    80001a46:	8082                	ret
    memmove((char *)dst, src, len);
    80001a48:	000a061b          	sext.w	a2,s4
    80001a4c:	85ce                	mv	a1,s3
    80001a4e:	854a                	mv	a0,s2
    80001a50:	fffff097          	auipc	ra,0xfffff
    80001a54:	80a080e7          	jalr	-2038(ra) # 8000025a <memmove>
    return 0;
    80001a58:	8526                	mv	a0,s1
    80001a5a:	bff9                	j	80001a38 <either_copyout+0x32>

0000000080001a5c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a5c:	7179                	addi	sp,sp,-48
    80001a5e:	f406                	sd	ra,40(sp)
    80001a60:	f022                	sd	s0,32(sp)
    80001a62:	ec26                	sd	s1,24(sp)
    80001a64:	e84a                	sd	s2,16(sp)
    80001a66:	e44e                	sd	s3,8(sp)
    80001a68:	e052                	sd	s4,0(sp)
    80001a6a:	1800                	addi	s0,sp,48
    80001a6c:	892a                	mv	s2,a0
    80001a6e:	84ae                	mv	s1,a1
    80001a70:	89b2                	mv	s3,a2
    80001a72:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a74:	fffff097          	auipc	ra,0xfffff
    80001a78:	532080e7          	jalr	1330(ra) # 80000fa6 <myproc>
  if(user_src){
    80001a7c:	c08d                	beqz	s1,80001a9e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a7e:	86d2                	mv	a3,s4
    80001a80:	864e                	mv	a2,s3
    80001a82:	85ca                	mv	a1,s2
    80001a84:	6928                	ld	a0,80(a0)
    80001a86:	fffff097          	auipc	ra,0xfffff
    80001a8a:	26e080e7          	jalr	622(ra) # 80000cf4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a8e:	70a2                	ld	ra,40(sp)
    80001a90:	7402                	ld	s0,32(sp)
    80001a92:	64e2                	ld	s1,24(sp)
    80001a94:	6942                	ld	s2,16(sp)
    80001a96:	69a2                	ld	s3,8(sp)
    80001a98:	6a02                	ld	s4,0(sp)
    80001a9a:	6145                	addi	sp,sp,48
    80001a9c:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a9e:	000a061b          	sext.w	a2,s4
    80001aa2:	85ce                	mv	a1,s3
    80001aa4:	854a                	mv	a0,s2
    80001aa6:	ffffe097          	auipc	ra,0xffffe
    80001aaa:	7b4080e7          	jalr	1972(ra) # 8000025a <memmove>
    return 0;
    80001aae:	8526                	mv	a0,s1
    80001ab0:	bff9                	j	80001a8e <either_copyin+0x32>

0000000080001ab2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ab2:	715d                	addi	sp,sp,-80
    80001ab4:	e486                	sd	ra,72(sp)
    80001ab6:	e0a2                	sd	s0,64(sp)
    80001ab8:	fc26                	sd	s1,56(sp)
    80001aba:	f84a                	sd	s2,48(sp)
    80001abc:	f44e                	sd	s3,40(sp)
    80001abe:	f052                	sd	s4,32(sp)
    80001ac0:	ec56                	sd	s5,24(sp)
    80001ac2:	e85a                	sd	s6,16(sp)
    80001ac4:	e45e                	sd	s7,8(sp)
    80001ac6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ac8:	00006517          	auipc	a0,0x6
    80001acc:	58050513          	addi	a0,a0,1408 # 80008048 <etext+0x48>
    80001ad0:	00004097          	auipc	ra,0x4
    80001ad4:	2b2080e7          	jalr	690(ra) # 80005d82 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ad8:	00228497          	auipc	s1,0x228
    80001adc:	b1848493          	addi	s1,s1,-1256 # 802295f0 <proc+0x158>
    80001ae0:	0022d917          	auipc	s2,0x22d
    80001ae4:	51090913          	addi	s2,s2,1296 # 8022eff0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ae8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001aea:	00006997          	auipc	s3,0x6
    80001aee:	71698993          	addi	s3,s3,1814 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001af2:	00006a97          	auipc	s5,0x6
    80001af6:	716a8a93          	addi	s5,s5,1814 # 80008208 <etext+0x208>
    printf("\n");
    80001afa:	00006a17          	auipc	s4,0x6
    80001afe:	54ea0a13          	addi	s4,s4,1358 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b02:	00006b97          	auipc	s7,0x6
    80001b06:	73eb8b93          	addi	s7,s7,1854 # 80008240 <states.1709>
    80001b0a:	a00d                	j	80001b2c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b0c:	ed86a583          	lw	a1,-296(a3)
    80001b10:	8556                	mv	a0,s5
    80001b12:	00004097          	auipc	ra,0x4
    80001b16:	270080e7          	jalr	624(ra) # 80005d82 <printf>
    printf("\n");
    80001b1a:	8552                	mv	a0,s4
    80001b1c:	00004097          	auipc	ra,0x4
    80001b20:	266080e7          	jalr	614(ra) # 80005d82 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b24:	16848493          	addi	s1,s1,360
    80001b28:	03248163          	beq	s1,s2,80001b4a <procdump+0x98>
    if(p->state == UNUSED)
    80001b2c:	86a6                	mv	a3,s1
    80001b2e:	ec04a783          	lw	a5,-320(s1)
    80001b32:	dbed                	beqz	a5,80001b24 <procdump+0x72>
      state = "???";
    80001b34:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b36:	fcfb6be3          	bltu	s6,a5,80001b0c <procdump+0x5a>
    80001b3a:	1782                	slli	a5,a5,0x20
    80001b3c:	9381                	srli	a5,a5,0x20
    80001b3e:	078e                	slli	a5,a5,0x3
    80001b40:	97de                	add	a5,a5,s7
    80001b42:	6390                	ld	a2,0(a5)
    80001b44:	f661                	bnez	a2,80001b0c <procdump+0x5a>
      state = "???";
    80001b46:	864e                	mv	a2,s3
    80001b48:	b7d1                	j	80001b0c <procdump+0x5a>
  }
}
    80001b4a:	60a6                	ld	ra,72(sp)
    80001b4c:	6406                	ld	s0,64(sp)
    80001b4e:	74e2                	ld	s1,56(sp)
    80001b50:	7942                	ld	s2,48(sp)
    80001b52:	79a2                	ld	s3,40(sp)
    80001b54:	7a02                	ld	s4,32(sp)
    80001b56:	6ae2                	ld	s5,24(sp)
    80001b58:	6b42                	ld	s6,16(sp)
    80001b5a:	6ba2                	ld	s7,8(sp)
    80001b5c:	6161                	addi	sp,sp,80
    80001b5e:	8082                	ret

0000000080001b60 <swtch>:
    80001b60:	00153023          	sd	ra,0(a0)
    80001b64:	00253423          	sd	sp,8(a0)
    80001b68:	e900                	sd	s0,16(a0)
    80001b6a:	ed04                	sd	s1,24(a0)
    80001b6c:	03253023          	sd	s2,32(a0)
    80001b70:	03353423          	sd	s3,40(a0)
    80001b74:	03453823          	sd	s4,48(a0)
    80001b78:	03553c23          	sd	s5,56(a0)
    80001b7c:	05653023          	sd	s6,64(a0)
    80001b80:	05753423          	sd	s7,72(a0)
    80001b84:	05853823          	sd	s8,80(a0)
    80001b88:	05953c23          	sd	s9,88(a0)
    80001b8c:	07a53023          	sd	s10,96(a0)
    80001b90:	07b53423          	sd	s11,104(a0)
    80001b94:	0005b083          	ld	ra,0(a1)
    80001b98:	0085b103          	ld	sp,8(a1)
    80001b9c:	6980                	ld	s0,16(a1)
    80001b9e:	6d84                	ld	s1,24(a1)
    80001ba0:	0205b903          	ld	s2,32(a1)
    80001ba4:	0285b983          	ld	s3,40(a1)
    80001ba8:	0305ba03          	ld	s4,48(a1)
    80001bac:	0385ba83          	ld	s5,56(a1)
    80001bb0:	0405bb03          	ld	s6,64(a1)
    80001bb4:	0485bb83          	ld	s7,72(a1)
    80001bb8:	0505bc03          	ld	s8,80(a1)
    80001bbc:	0585bc83          	ld	s9,88(a1)
    80001bc0:	0605bd03          	ld	s10,96(a1)
    80001bc4:	0685bd83          	ld	s11,104(a1)
    80001bc8:	8082                	ret

0000000080001bca <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bca:	1141                	addi	sp,sp,-16
    80001bcc:	e406                	sd	ra,8(sp)
    80001bce:	e022                	sd	s0,0(sp)
    80001bd0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bd2:	00006597          	auipc	a1,0x6
    80001bd6:	69e58593          	addi	a1,a1,1694 # 80008270 <states.1709+0x30>
    80001bda:	0022d517          	auipc	a0,0x22d
    80001bde:	2be50513          	addi	a0,a0,702 # 8022ee98 <tickslock>
    80001be2:	00004097          	auipc	ra,0x4
    80001be6:	610080e7          	jalr	1552(ra) # 800061f2 <initlock>
}
    80001bea:	60a2                	ld	ra,8(sp)
    80001bec:	6402                	ld	s0,0(sp)
    80001bee:	0141                	addi	sp,sp,16
    80001bf0:	8082                	ret

0000000080001bf2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bf2:	1141                	addi	sp,sp,-16
    80001bf4:	e422                	sd	s0,8(sp)
    80001bf6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bf8:	00003797          	auipc	a5,0x3
    80001bfc:	54878793          	addi	a5,a5,1352 # 80005140 <kernelvec>
    80001c00:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c04:	6422                	ld	s0,8(sp)
    80001c06:	0141                	addi	sp,sp,16
    80001c08:	8082                	ret

0000000080001c0a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c0a:	1141                	addi	sp,sp,-16
    80001c0c:	e406                	sd	ra,8(sp)
    80001c0e:	e022                	sd	s0,0(sp)
    80001c10:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c12:	fffff097          	auipc	ra,0xfffff
    80001c16:	394080e7          	jalr	916(ra) # 80000fa6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c1a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c1e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c20:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c24:	00005617          	auipc	a2,0x5
    80001c28:	3dc60613          	addi	a2,a2,988 # 80007000 <_trampoline>
    80001c2c:	00005697          	auipc	a3,0x5
    80001c30:	3d468693          	addi	a3,a3,980 # 80007000 <_trampoline>
    80001c34:	8e91                	sub	a3,a3,a2
    80001c36:	040007b7          	lui	a5,0x4000
    80001c3a:	17fd                	addi	a5,a5,-1
    80001c3c:	07b2                	slli	a5,a5,0xc
    80001c3e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c40:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c44:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c46:	180026f3          	csrr	a3,satp
    80001c4a:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c4c:	6d38                	ld	a4,88(a0)
    80001c4e:	6134                	ld	a3,64(a0)
    80001c50:	6585                	lui	a1,0x1
    80001c52:	96ae                	add	a3,a3,a1
    80001c54:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c56:	6d38                	ld	a4,88(a0)
    80001c58:	00000697          	auipc	a3,0x0
    80001c5c:	29868693          	addi	a3,a3,664 # 80001ef0 <usertrap>
    80001c60:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c62:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c64:	8692                	mv	a3,tp
    80001c66:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c68:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c6c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c70:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c74:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c78:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c7a:	6f18                	ld	a4,24(a4)
    80001c7c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c80:	692c                	ld	a1,80(a0)
    80001c82:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c84:	00005717          	auipc	a4,0x5
    80001c88:	40c70713          	addi	a4,a4,1036 # 80007090 <userret>
    80001c8c:	8f11                	sub	a4,a4,a2
    80001c8e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c90:	577d                	li	a4,-1
    80001c92:	177e                	slli	a4,a4,0x3f
    80001c94:	8dd9                	or	a1,a1,a4
    80001c96:	02000537          	lui	a0,0x2000
    80001c9a:	157d                	addi	a0,a0,-1
    80001c9c:	0536                	slli	a0,a0,0xd
    80001c9e:	9782                	jalr	a5
}
    80001ca0:	60a2                	ld	ra,8(sp)
    80001ca2:	6402                	ld	s0,0(sp)
    80001ca4:	0141                	addi	sp,sp,16
    80001ca6:	8082                	ret

0000000080001ca8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ca8:	1101                	addi	sp,sp,-32
    80001caa:	ec06                	sd	ra,24(sp)
    80001cac:	e822                	sd	s0,16(sp)
    80001cae:	e426                	sd	s1,8(sp)
    80001cb0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cb2:	0022d497          	auipc	s1,0x22d
    80001cb6:	1e648493          	addi	s1,s1,486 # 8022ee98 <tickslock>
    80001cba:	8526                	mv	a0,s1
    80001cbc:	00004097          	auipc	ra,0x4
    80001cc0:	5c6080e7          	jalr	1478(ra) # 80006282 <acquire>
  ticks++;
    80001cc4:	00007517          	auipc	a0,0x7
    80001cc8:	35450513          	addi	a0,a0,852 # 80009018 <ticks>
    80001ccc:	411c                	lw	a5,0(a0)
    80001cce:	2785                	addiw	a5,a5,1
    80001cd0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	b1c080e7          	jalr	-1252(ra) # 800017ee <wakeup>
  release(&tickslock);
    80001cda:	8526                	mv	a0,s1
    80001cdc:	00004097          	auipc	ra,0x4
    80001ce0:	65a080e7          	jalr	1626(ra) # 80006336 <release>
}
    80001ce4:	60e2                	ld	ra,24(sp)
    80001ce6:	6442                	ld	s0,16(sp)
    80001ce8:	64a2                	ld	s1,8(sp)
    80001cea:	6105                	addi	sp,sp,32
    80001cec:	8082                	ret

0000000080001cee <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001cee:	1101                	addi	sp,sp,-32
    80001cf0:	ec06                	sd	ra,24(sp)
    80001cf2:	e822                	sd	s0,16(sp)
    80001cf4:	e426                	sd	s1,8(sp)
    80001cf6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cf8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cfc:	00074d63          	bltz	a4,80001d16 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d00:	57fd                	li	a5,-1
    80001d02:	17fe                	slli	a5,a5,0x3f
    80001d04:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d06:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d08:	06f70363          	beq	a4,a5,80001d6e <devintr+0x80>
  }
}
    80001d0c:	60e2                	ld	ra,24(sp)
    80001d0e:	6442                	ld	s0,16(sp)
    80001d10:	64a2                	ld	s1,8(sp)
    80001d12:	6105                	addi	sp,sp,32
    80001d14:	8082                	ret
     (scause & 0xff) == 9){
    80001d16:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d1a:	46a5                	li	a3,9
    80001d1c:	fed792e3          	bne	a5,a3,80001d00 <devintr+0x12>
    int irq = plic_claim();
    80001d20:	00003097          	auipc	ra,0x3
    80001d24:	528080e7          	jalr	1320(ra) # 80005248 <plic_claim>
    80001d28:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d2a:	47a9                	li	a5,10
    80001d2c:	02f50763          	beq	a0,a5,80001d5a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d30:	4785                	li	a5,1
    80001d32:	02f50963          	beq	a0,a5,80001d64 <devintr+0x76>
    return 1;
    80001d36:	4505                	li	a0,1
    } else if(irq){
    80001d38:	d8f1                	beqz	s1,80001d0c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d3a:	85a6                	mv	a1,s1
    80001d3c:	00006517          	auipc	a0,0x6
    80001d40:	53c50513          	addi	a0,a0,1340 # 80008278 <states.1709+0x38>
    80001d44:	00004097          	auipc	ra,0x4
    80001d48:	03e080e7          	jalr	62(ra) # 80005d82 <printf>
      plic_complete(irq);
    80001d4c:	8526                	mv	a0,s1
    80001d4e:	00003097          	auipc	ra,0x3
    80001d52:	51e080e7          	jalr	1310(ra) # 8000526c <plic_complete>
    return 1;
    80001d56:	4505                	li	a0,1
    80001d58:	bf55                	j	80001d0c <devintr+0x1e>
      uartintr();
    80001d5a:	00004097          	auipc	ra,0x4
    80001d5e:	448080e7          	jalr	1096(ra) # 800061a2 <uartintr>
    80001d62:	b7ed                	j	80001d4c <devintr+0x5e>
      virtio_disk_intr();
    80001d64:	00004097          	auipc	ra,0x4
    80001d68:	9e8080e7          	jalr	-1560(ra) # 8000574c <virtio_disk_intr>
    80001d6c:	b7c5                	j	80001d4c <devintr+0x5e>
    if(cpuid() == 0){
    80001d6e:	fffff097          	auipc	ra,0xfffff
    80001d72:	20c080e7          	jalr	524(ra) # 80000f7a <cpuid>
    80001d76:	c901                	beqz	a0,80001d86 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d78:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d7c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d7e:	14479073          	csrw	sip,a5
    return 2;
    80001d82:	4509                	li	a0,2
    80001d84:	b761                	j	80001d0c <devintr+0x1e>
      clockintr();
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	f22080e7          	jalr	-222(ra) # 80001ca8 <clockintr>
    80001d8e:	b7ed                	j	80001d78 <devintr+0x8a>

0000000080001d90 <kerneltrap>:
{
    80001d90:	7179                	addi	sp,sp,-48
    80001d92:	f406                	sd	ra,40(sp)
    80001d94:	f022                	sd	s0,32(sp)
    80001d96:	ec26                	sd	s1,24(sp)
    80001d98:	e84a                	sd	s2,16(sp)
    80001d9a:	e44e                	sd	s3,8(sp)
    80001d9c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d9e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001daa:	1004f793          	andi	a5,s1,256
    80001dae:	cb85                	beqz	a5,80001dde <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001db4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001db6:	ef85                	bnez	a5,80001dee <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001db8:	00000097          	auipc	ra,0x0
    80001dbc:	f36080e7          	jalr	-202(ra) # 80001cee <devintr>
    80001dc0:	cd1d                	beqz	a0,80001dfe <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dc2:	4789                	li	a5,2
    80001dc4:	06f50a63          	beq	a0,a5,80001e38 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dc8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dcc:	10049073          	csrw	sstatus,s1
}
    80001dd0:	70a2                	ld	ra,40(sp)
    80001dd2:	7402                	ld	s0,32(sp)
    80001dd4:	64e2                	ld	s1,24(sp)
    80001dd6:	6942                	ld	s2,16(sp)
    80001dd8:	69a2                	ld	s3,8(sp)
    80001dda:	6145                	addi	sp,sp,48
    80001ddc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dde:	00006517          	auipc	a0,0x6
    80001de2:	4ba50513          	addi	a0,a0,1210 # 80008298 <states.1709+0x58>
    80001de6:	00004097          	auipc	ra,0x4
    80001dea:	f52080e7          	jalr	-174(ra) # 80005d38 <panic>
    panic("kerneltrap: interrupts enabled");
    80001dee:	00006517          	auipc	a0,0x6
    80001df2:	4d250513          	addi	a0,a0,1234 # 800082c0 <states.1709+0x80>
    80001df6:	00004097          	auipc	ra,0x4
    80001dfa:	f42080e7          	jalr	-190(ra) # 80005d38 <panic>
    printf("scause %p\n", scause);
    80001dfe:	85ce                	mv	a1,s3
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	4e050513          	addi	a0,a0,1248 # 800082e0 <states.1709+0xa0>
    80001e08:	00004097          	auipc	ra,0x4
    80001e0c:	f7a080e7          	jalr	-134(ra) # 80005d82 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e10:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e14:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e18:	00006517          	auipc	a0,0x6
    80001e1c:	4d850513          	addi	a0,a0,1240 # 800082f0 <states.1709+0xb0>
    80001e20:	00004097          	auipc	ra,0x4
    80001e24:	f62080e7          	jalr	-158(ra) # 80005d82 <printf>
    panic("kerneltrap");
    80001e28:	00006517          	auipc	a0,0x6
    80001e2c:	4e050513          	addi	a0,a0,1248 # 80008308 <states.1709+0xc8>
    80001e30:	00004097          	auipc	ra,0x4
    80001e34:	f08080e7          	jalr	-248(ra) # 80005d38 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	16e080e7          	jalr	366(ra) # 80000fa6 <myproc>
    80001e40:	d541                	beqz	a0,80001dc8 <kerneltrap+0x38>
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	164080e7          	jalr	356(ra) # 80000fa6 <myproc>
    80001e4a:	4d18                	lw	a4,24(a0)
    80001e4c:	4791                	li	a5,4
    80001e4e:	f6f71de3          	bne	a4,a5,80001dc8 <kerneltrap+0x38>
    yield();
    80001e52:	fffff097          	auipc	ra,0xfffff
    80001e56:	7d4080e7          	jalr	2004(ra) # 80001626 <yield>
    80001e5a:	b7bd                	j	80001dc8 <kerneltrap+0x38>

0000000080001e5c <cowhandler>:

int
cowhandler(pagetable_t pagetable, uint64 va)
{
    char *mem;
    if (va >= MAXVA)
    80001e5c:	57fd                	li	a5,-1
    80001e5e:	83e9                	srli	a5,a5,0x1a
    80001e60:	08b7e063          	bltu	a5,a1,80001ee0 <cowhandler+0x84>
{
    80001e64:	7179                	addi	sp,sp,-48
    80001e66:	f406                	sd	ra,40(sp)
    80001e68:	f022                	sd	s0,32(sp)
    80001e6a:	ec26                	sd	s1,24(sp)
    80001e6c:	e84a                	sd	s2,16(sp)
    80001e6e:	e44e                	sd	s3,8(sp)
    80001e70:	1800                	addi	s0,sp,48
      return -1;
    pte_t *pte = walk(pagetable, va, 0);
    80001e72:	4601                	li	a2,0
    80001e74:	ffffe097          	auipc	ra,0xffffe
    80001e78:	66e080e7          	jalr	1646(ra) # 800004e2 <walk>
    80001e7c:	892a                	mv	s2,a0
    if (pte == 0)
    80001e7e:	c13d                	beqz	a0,80001ee4 <cowhandler+0x88>
      return -1;
    // check the PTE
    if ((*pte & PTE_RSW) == 0 || (*pte & PTE_U) == 0 || (*pte & PTE_V) == 0) {
    80001e80:	611c                	ld	a5,0(a0)
    80001e82:	1117f793          	andi	a5,a5,273
    80001e86:	11100713          	li	a4,273
    80001e8a:	04e79f63          	bne	a5,a4,80001ee8 <cowhandler+0x8c>
      return -1;
    }
    if ((mem = kalloc()) == 0) {
    80001e8e:	ffffe097          	auipc	ra,0xffffe
    80001e92:	2d0080e7          	jalr	720(ra) # 8000015e <kalloc>
    80001e96:	84aa                	mv	s1,a0
    80001e98:	c931                	beqz	a0,80001eec <cowhandler+0x90>
      return -1;
    }
    // old physical address
    uint64 pa = PTE2PA(*pte);
    80001e9a:	00093983          	ld	s3,0(s2)
    80001e9e:	00a9d993          	srli	s3,s3,0xa
    80001ea2:	09b2                	slli	s3,s3,0xc
    // copy old data to new mem
    memmove((char*)mem, (char*)pa, PGSIZE);
    80001ea4:	6605                	lui	a2,0x1
    80001ea6:	85ce                	mv	a1,s3
    80001ea8:	ffffe097          	auipc	ra,0xffffe
    80001eac:	3b2080e7          	jalr	946(ra) # 8000025a <memmove>
    // PAY ATTENTION
    // decrease the reference count of old memory page, because a new page has been allocated
    kfree((void*)pa);
    80001eb0:	854e                	mv	a0,s3
    80001eb2:	ffffe097          	auipc	ra,0xffffe
    80001eb6:	16a080e7          	jalr	362(ra) # 8000001c <kfree>
    uint flags = PTE_FLAGS(*pte);
    // set PTE_W to 1, change the address pointed to by PTE to new memory page(mem)
    *pte = (PA2PTE(mem) | flags | PTE_W);
    80001eba:	80b1                	srli	s1,s1,0xc
    80001ebc:	04aa                	slli	s1,s1,0xa
    uint flags = PTE_FLAGS(*pte);
    80001ebe:	00093783          	ld	a5,0(s2)
    *pte = (PA2PTE(mem) | flags | PTE_W);
    80001ec2:	2ff7f793          	andi	a5,a5,767
    // set PTE_RSW to 0
    *pte &= ~PTE_RSW;
    80001ec6:	8cdd                	or	s1,s1,a5
    80001ec8:	0044e493          	ori	s1,s1,4
    80001ecc:	00993023          	sd	s1,0(s2)
    return 0;
    80001ed0:	4501                	li	a0,0
    80001ed2:	70a2                	ld	ra,40(sp)
    80001ed4:	7402                	ld	s0,32(sp)
    80001ed6:	64e2                	ld	s1,24(sp)
    80001ed8:	6942                	ld	s2,16(sp)
    80001eda:	69a2                	ld	s3,8(sp)
    80001edc:	6145                	addi	sp,sp,48
    80001ede:	8082                	ret
      return -1;
    80001ee0:	557d                	li	a0,-1
    80001ee2:	8082                	ret
      return -1;
    80001ee4:	557d                	li	a0,-1
    80001ee6:	b7f5                	j	80001ed2 <cowhandler+0x76>
      return -1;
    80001ee8:	557d                	li	a0,-1
    80001eea:	b7e5                	j	80001ed2 <cowhandler+0x76>
      return -1;
    80001eec:	557d                	li	a0,-1
    80001eee:	b7d5                	j	80001ed2 <cowhandler+0x76>

0000000080001ef0 <usertrap>:
{
    80001ef0:	1101                	addi	sp,sp,-32
    80001ef2:	ec06                	sd	ra,24(sp)
    80001ef4:	e822                	sd	s0,16(sp)
    80001ef6:	e426                	sd	s1,8(sp)
    80001ef8:	e04a                	sd	s2,0(sp)
    80001efa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001efc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001f00:	1007f793          	andi	a5,a5,256
    80001f04:	e7bd                	bnez	a5,80001f72 <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f06:	00003797          	auipc	a5,0x3
    80001f0a:	23a78793          	addi	a5,a5,570 # 80005140 <kernelvec>
    80001f0e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	094080e7          	jalr	148(ra) # 80000fa6 <myproc>
    80001f1a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f1c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f1e:	14102773          	csrr	a4,sepc
    80001f22:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f24:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f28:	47a1                	li	a5,8
    80001f2a:	04f70c63          	beq	a4,a5,80001f82 <usertrap+0x92>
    80001f2e:	14202773          	csrr	a4,scause
  } else if(r_scause() == 15){
    80001f32:	47bd                	li	a5,15
    80001f34:	08f71963          	bne	a4,a5,80001fc6 <usertrap+0xd6>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f38:	143025f3          	csrr	a1,stval
    if (va >= p->sz)
    80001f3c:	653c                	ld	a5,72(a0)
    80001f3e:	00f5e463          	bltu	a1,a5,80001f46 <usertrap+0x56>
      p->killed = 1;
    80001f42:	4785                	li	a5,1
    80001f44:	d51c                	sw	a5,40(a0)
    int ret = cowhandler(p->pagetable, va);
    80001f46:	68a8                	ld	a0,80(s1)
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	f14080e7          	jalr	-236(ra) # 80001e5c <cowhandler>
    if (ret != 0)
    80001f50:	c929                	beqz	a0,80001fa2 <usertrap+0xb2>
      p->killed = 1;
    80001f52:	4785                	li	a5,1
    80001f54:	d49c                	sw	a5,40(s1)
{
    80001f56:	4901                	li	s2,0
    exit(-1);
    80001f58:	557d                	li	a0,-1
    80001f5a:	00000097          	auipc	ra,0x0
    80001f5e:	964080e7          	jalr	-1692(ra) # 800018be <exit>
  if(which_dev == 2)
    80001f62:	4789                	li	a5,2
    80001f64:	04f91163          	bne	s2,a5,80001fa6 <usertrap+0xb6>
    yield();
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	6be080e7          	jalr	1726(ra) # 80001626 <yield>
    80001f70:	a81d                	j	80001fa6 <usertrap+0xb6>
    panic("usertrap: not from user mode");
    80001f72:	00006517          	auipc	a0,0x6
    80001f76:	3a650513          	addi	a0,a0,934 # 80008318 <states.1709+0xd8>
    80001f7a:	00004097          	auipc	ra,0x4
    80001f7e:	dbe080e7          	jalr	-578(ra) # 80005d38 <panic>
    if(p->killed)
    80001f82:	551c                	lw	a5,40(a0)
    80001f84:	eb9d                	bnez	a5,80001fba <usertrap+0xca>
    p->trapframe->epc += 4;
    80001f86:	6cb8                	ld	a4,88(s1)
    80001f88:	6f1c                	ld	a5,24(a4)
    80001f8a:	0791                	addi	a5,a5,4
    80001f8c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f8e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f92:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f96:	10079073          	csrw	sstatus,a5
    syscall();
    80001f9a:	00000097          	auipc	ra,0x0
    80001f9e:	1ec080e7          	jalr	492(ra) # 80002186 <syscall>
  if(p->killed)
    80001fa2:	549c                	lw	a5,40(s1)
    80001fa4:	e7a5                	bnez	a5,8000200c <usertrap+0x11c>
  usertrapret();
    80001fa6:	00000097          	auipc	ra,0x0
    80001faa:	c64080e7          	jalr	-924(ra) # 80001c0a <usertrapret>
}
    80001fae:	60e2                	ld	ra,24(sp)
    80001fb0:	6442                	ld	s0,16(sp)
    80001fb2:	64a2                	ld	s1,8(sp)
    80001fb4:	6902                	ld	s2,0(sp)
    80001fb6:	6105                	addi	sp,sp,32
    80001fb8:	8082                	ret
      exit(-1);
    80001fba:	557d                	li	a0,-1
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	902080e7          	jalr	-1790(ra) # 800018be <exit>
    80001fc4:	b7c9                	j	80001f86 <usertrap+0x96>
  } else if((which_dev = devintr()) != 0){
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	d28080e7          	jalr	-728(ra) # 80001cee <devintr>
    80001fce:	892a                	mv	s2,a0
    80001fd0:	c501                	beqz	a0,80001fd8 <usertrap+0xe8>
  if(p->killed)
    80001fd2:	549c                	lw	a5,40(s1)
    80001fd4:	d7d9                	beqz	a5,80001f62 <usertrap+0x72>
    80001fd6:	b749                	j	80001f58 <usertrap+0x68>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fd8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001fdc:	5890                	lw	a2,48(s1)
    80001fde:	00006517          	auipc	a0,0x6
    80001fe2:	35a50513          	addi	a0,a0,858 # 80008338 <states.1709+0xf8>
    80001fe6:	00004097          	auipc	ra,0x4
    80001fea:	d9c080e7          	jalr	-612(ra) # 80005d82 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fee:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ff2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ff6:	00006517          	auipc	a0,0x6
    80001ffa:	37250513          	addi	a0,a0,882 # 80008368 <states.1709+0x128>
    80001ffe:	00004097          	auipc	ra,0x4
    80002002:	d84080e7          	jalr	-636(ra) # 80005d82 <printf>
    p->killed = 1;
    80002006:	4785                	li	a5,1
    80002008:	d49c                	sw	a5,40(s1)
    8000200a:	b7b1                	j	80001f56 <usertrap+0x66>
  if(p->killed)
    8000200c:	4901                	li	s2,0
    8000200e:	b7a9                	j	80001f58 <usertrap+0x68>

0000000080002010 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002010:	1101                	addi	sp,sp,-32
    80002012:	ec06                	sd	ra,24(sp)
    80002014:	e822                	sd	s0,16(sp)
    80002016:	e426                	sd	s1,8(sp)
    80002018:	1000                	addi	s0,sp,32
    8000201a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	f8a080e7          	jalr	-118(ra) # 80000fa6 <myproc>
  switch (n) {
    80002024:	4795                	li	a5,5
    80002026:	0497e163          	bltu	a5,s1,80002068 <argraw+0x58>
    8000202a:	048a                	slli	s1,s1,0x2
    8000202c:	00006717          	auipc	a4,0x6
    80002030:	38470713          	addi	a4,a4,900 # 800083b0 <states.1709+0x170>
    80002034:	94ba                	add	s1,s1,a4
    80002036:	409c                	lw	a5,0(s1)
    80002038:	97ba                	add	a5,a5,a4
    8000203a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000203c:	6d3c                	ld	a5,88(a0)
    8000203e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	64a2                	ld	s1,8(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret
    return p->trapframe->a1;
    8000204a:	6d3c                	ld	a5,88(a0)
    8000204c:	7fa8                	ld	a0,120(a5)
    8000204e:	bfcd                	j	80002040 <argraw+0x30>
    return p->trapframe->a2;
    80002050:	6d3c                	ld	a5,88(a0)
    80002052:	63c8                	ld	a0,128(a5)
    80002054:	b7f5                	j	80002040 <argraw+0x30>
    return p->trapframe->a3;
    80002056:	6d3c                	ld	a5,88(a0)
    80002058:	67c8                	ld	a0,136(a5)
    8000205a:	b7dd                	j	80002040 <argraw+0x30>
    return p->trapframe->a4;
    8000205c:	6d3c                	ld	a5,88(a0)
    8000205e:	6bc8                	ld	a0,144(a5)
    80002060:	b7c5                	j	80002040 <argraw+0x30>
    return p->trapframe->a5;
    80002062:	6d3c                	ld	a5,88(a0)
    80002064:	6fc8                	ld	a0,152(a5)
    80002066:	bfe9                	j	80002040 <argraw+0x30>
  panic("argraw");
    80002068:	00006517          	auipc	a0,0x6
    8000206c:	32050513          	addi	a0,a0,800 # 80008388 <states.1709+0x148>
    80002070:	00004097          	auipc	ra,0x4
    80002074:	cc8080e7          	jalr	-824(ra) # 80005d38 <panic>

0000000080002078 <fetchaddr>:
{
    80002078:	1101                	addi	sp,sp,-32
    8000207a:	ec06                	sd	ra,24(sp)
    8000207c:	e822                	sd	s0,16(sp)
    8000207e:	e426                	sd	s1,8(sp)
    80002080:	e04a                	sd	s2,0(sp)
    80002082:	1000                	addi	s0,sp,32
    80002084:	84aa                	mv	s1,a0
    80002086:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	f1e080e7          	jalr	-226(ra) # 80000fa6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002090:	653c                	ld	a5,72(a0)
    80002092:	02f4f863          	bgeu	s1,a5,800020c2 <fetchaddr+0x4a>
    80002096:	00848713          	addi	a4,s1,8
    8000209a:	02e7e663          	bltu	a5,a4,800020c6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000209e:	46a1                	li	a3,8
    800020a0:	8626                	mv	a2,s1
    800020a2:	85ca                	mv	a1,s2
    800020a4:	6928                	ld	a0,80(a0)
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	c4e080e7          	jalr	-946(ra) # 80000cf4 <copyin>
    800020ae:	00a03533          	snez	a0,a0
    800020b2:	40a00533          	neg	a0,a0
}
    800020b6:	60e2                	ld	ra,24(sp)
    800020b8:	6442                	ld	s0,16(sp)
    800020ba:	64a2                	ld	s1,8(sp)
    800020bc:	6902                	ld	s2,0(sp)
    800020be:	6105                	addi	sp,sp,32
    800020c0:	8082                	ret
    return -1;
    800020c2:	557d                	li	a0,-1
    800020c4:	bfcd                	j	800020b6 <fetchaddr+0x3e>
    800020c6:	557d                	li	a0,-1
    800020c8:	b7fd                	j	800020b6 <fetchaddr+0x3e>

00000000800020ca <fetchstr>:
{
    800020ca:	7179                	addi	sp,sp,-48
    800020cc:	f406                	sd	ra,40(sp)
    800020ce:	f022                	sd	s0,32(sp)
    800020d0:	ec26                	sd	s1,24(sp)
    800020d2:	e84a                	sd	s2,16(sp)
    800020d4:	e44e                	sd	s3,8(sp)
    800020d6:	1800                	addi	s0,sp,48
    800020d8:	892a                	mv	s2,a0
    800020da:	84ae                	mv	s1,a1
    800020dc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020de:	fffff097          	auipc	ra,0xfffff
    800020e2:	ec8080e7          	jalr	-312(ra) # 80000fa6 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020e6:	86ce                	mv	a3,s3
    800020e8:	864a                	mv	a2,s2
    800020ea:	85a6                	mv	a1,s1
    800020ec:	6928                	ld	a0,80(a0)
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	c92080e7          	jalr	-878(ra) # 80000d80 <copyinstr>
  if(err < 0)
    800020f6:	00054763          	bltz	a0,80002104 <fetchstr+0x3a>
  return strlen(buf);
    800020fa:	8526                	mv	a0,s1
    800020fc:	ffffe097          	auipc	ra,0xffffe
    80002100:	282080e7          	jalr	642(ra) # 8000037e <strlen>
}
    80002104:	70a2                	ld	ra,40(sp)
    80002106:	7402                	ld	s0,32(sp)
    80002108:	64e2                	ld	s1,24(sp)
    8000210a:	6942                	ld	s2,16(sp)
    8000210c:	69a2                	ld	s3,8(sp)
    8000210e:	6145                	addi	sp,sp,48
    80002110:	8082                	ret

0000000080002112 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002112:	1101                	addi	sp,sp,-32
    80002114:	ec06                	sd	ra,24(sp)
    80002116:	e822                	sd	s0,16(sp)
    80002118:	e426                	sd	s1,8(sp)
    8000211a:	1000                	addi	s0,sp,32
    8000211c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000211e:	00000097          	auipc	ra,0x0
    80002122:	ef2080e7          	jalr	-270(ra) # 80002010 <argraw>
    80002126:	c088                	sw	a0,0(s1)
  return 0;
}
    80002128:	4501                	li	a0,0
    8000212a:	60e2                	ld	ra,24(sp)
    8000212c:	6442                	ld	s0,16(sp)
    8000212e:	64a2                	ld	s1,8(sp)
    80002130:	6105                	addi	sp,sp,32
    80002132:	8082                	ret

0000000080002134 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002134:	1101                	addi	sp,sp,-32
    80002136:	ec06                	sd	ra,24(sp)
    80002138:	e822                	sd	s0,16(sp)
    8000213a:	e426                	sd	s1,8(sp)
    8000213c:	1000                	addi	s0,sp,32
    8000213e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002140:	00000097          	auipc	ra,0x0
    80002144:	ed0080e7          	jalr	-304(ra) # 80002010 <argraw>
    80002148:	e088                	sd	a0,0(s1)
  return 0;
}
    8000214a:	4501                	li	a0,0
    8000214c:	60e2                	ld	ra,24(sp)
    8000214e:	6442                	ld	s0,16(sp)
    80002150:	64a2                	ld	s1,8(sp)
    80002152:	6105                	addi	sp,sp,32
    80002154:	8082                	ret

0000000080002156 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002156:	1101                	addi	sp,sp,-32
    80002158:	ec06                	sd	ra,24(sp)
    8000215a:	e822                	sd	s0,16(sp)
    8000215c:	e426                	sd	s1,8(sp)
    8000215e:	e04a                	sd	s2,0(sp)
    80002160:	1000                	addi	s0,sp,32
    80002162:	84ae                	mv	s1,a1
    80002164:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	eaa080e7          	jalr	-342(ra) # 80002010 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000216e:	864a                	mv	a2,s2
    80002170:	85a6                	mv	a1,s1
    80002172:	00000097          	auipc	ra,0x0
    80002176:	f58080e7          	jalr	-168(ra) # 800020ca <fetchstr>
}
    8000217a:	60e2                	ld	ra,24(sp)
    8000217c:	6442                	ld	s0,16(sp)
    8000217e:	64a2                	ld	s1,8(sp)
    80002180:	6902                	ld	s2,0(sp)
    80002182:	6105                	addi	sp,sp,32
    80002184:	8082                	ret

0000000080002186 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002186:	1101                	addi	sp,sp,-32
    80002188:	ec06                	sd	ra,24(sp)
    8000218a:	e822                	sd	s0,16(sp)
    8000218c:	e426                	sd	s1,8(sp)
    8000218e:	e04a                	sd	s2,0(sp)
    80002190:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	e14080e7          	jalr	-492(ra) # 80000fa6 <myproc>
    8000219a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000219c:	05853903          	ld	s2,88(a0)
    800021a0:	0a893783          	ld	a5,168(s2)
    800021a4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021a8:	37fd                	addiw	a5,a5,-1
    800021aa:	4751                	li	a4,20
    800021ac:	00f76f63          	bltu	a4,a5,800021ca <syscall+0x44>
    800021b0:	00369713          	slli	a4,a3,0x3
    800021b4:	00006797          	auipc	a5,0x6
    800021b8:	21478793          	addi	a5,a5,532 # 800083c8 <syscalls>
    800021bc:	97ba                	add	a5,a5,a4
    800021be:	639c                	ld	a5,0(a5)
    800021c0:	c789                	beqz	a5,800021ca <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021c2:	9782                	jalr	a5
    800021c4:	06a93823          	sd	a0,112(s2)
    800021c8:	a839                	j	800021e6 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021ca:	15848613          	addi	a2,s1,344
    800021ce:	588c                	lw	a1,48(s1)
    800021d0:	00006517          	auipc	a0,0x6
    800021d4:	1c050513          	addi	a0,a0,448 # 80008390 <states.1709+0x150>
    800021d8:	00004097          	auipc	ra,0x4
    800021dc:	baa080e7          	jalr	-1110(ra) # 80005d82 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021e0:	6cbc                	ld	a5,88(s1)
    800021e2:	577d                	li	a4,-1
    800021e4:	fbb8                	sd	a4,112(a5)
  }
}
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	64a2                	ld	s1,8(sp)
    800021ec:	6902                	ld	s2,0(sp)
    800021ee:	6105                	addi	sp,sp,32
    800021f0:	8082                	ret

00000000800021f2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021f2:	1101                	addi	sp,sp,-32
    800021f4:	ec06                	sd	ra,24(sp)
    800021f6:	e822                	sd	s0,16(sp)
    800021f8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021fa:	fec40593          	addi	a1,s0,-20
    800021fe:	4501                	li	a0,0
    80002200:	00000097          	auipc	ra,0x0
    80002204:	f12080e7          	jalr	-238(ra) # 80002112 <argint>
    return -1;
    80002208:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000220a:	00054963          	bltz	a0,8000221c <sys_exit+0x2a>
  exit(n);
    8000220e:	fec42503          	lw	a0,-20(s0)
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	6ac080e7          	jalr	1708(ra) # 800018be <exit>
  return 0;  // not reached
    8000221a:	4781                	li	a5,0
}
    8000221c:	853e                	mv	a0,a5
    8000221e:	60e2                	ld	ra,24(sp)
    80002220:	6442                	ld	s0,16(sp)
    80002222:	6105                	addi	sp,sp,32
    80002224:	8082                	ret

0000000080002226 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002226:	1141                	addi	sp,sp,-16
    80002228:	e406                	sd	ra,8(sp)
    8000222a:	e022                	sd	s0,0(sp)
    8000222c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	d78080e7          	jalr	-648(ra) # 80000fa6 <myproc>
}
    80002236:	5908                	lw	a0,48(a0)
    80002238:	60a2                	ld	ra,8(sp)
    8000223a:	6402                	ld	s0,0(sp)
    8000223c:	0141                	addi	sp,sp,16
    8000223e:	8082                	ret

0000000080002240 <sys_fork>:

uint64
sys_fork(void)
{
    80002240:	1141                	addi	sp,sp,-16
    80002242:	e406                	sd	ra,8(sp)
    80002244:	e022                	sd	s0,0(sp)
    80002246:	0800                	addi	s0,sp,16
  return fork();
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	12c080e7          	jalr	300(ra) # 80001374 <fork>
}
    80002250:	60a2                	ld	ra,8(sp)
    80002252:	6402                	ld	s0,0(sp)
    80002254:	0141                	addi	sp,sp,16
    80002256:	8082                	ret

0000000080002258 <sys_wait>:

uint64
sys_wait(void)
{
    80002258:	1101                	addi	sp,sp,-32
    8000225a:	ec06                	sd	ra,24(sp)
    8000225c:	e822                	sd	s0,16(sp)
    8000225e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002260:	fe840593          	addi	a1,s0,-24
    80002264:	4501                	li	a0,0
    80002266:	00000097          	auipc	ra,0x0
    8000226a:	ece080e7          	jalr	-306(ra) # 80002134 <argaddr>
    8000226e:	87aa                	mv	a5,a0
    return -1;
    80002270:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002272:	0007c863          	bltz	a5,80002282 <sys_wait+0x2a>
  return wait(p);
    80002276:	fe843503          	ld	a0,-24(s0)
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	44c080e7          	jalr	1100(ra) # 800016c6 <wait>
}
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	6105                	addi	sp,sp,32
    80002288:	8082                	ret

000000008000228a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000228a:	7179                	addi	sp,sp,-48
    8000228c:	f406                	sd	ra,40(sp)
    8000228e:	f022                	sd	s0,32(sp)
    80002290:	ec26                	sd	s1,24(sp)
    80002292:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002294:	fdc40593          	addi	a1,s0,-36
    80002298:	4501                	li	a0,0
    8000229a:	00000097          	auipc	ra,0x0
    8000229e:	e78080e7          	jalr	-392(ra) # 80002112 <argint>
    800022a2:	87aa                	mv	a5,a0
    return -1;
    800022a4:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022a6:	0207c063          	bltz	a5,800022c6 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800022aa:	fffff097          	auipc	ra,0xfffff
    800022ae:	cfc080e7          	jalr	-772(ra) # 80000fa6 <myproc>
    800022b2:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800022b4:	fdc42503          	lw	a0,-36(s0)
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	048080e7          	jalr	72(ra) # 80001300 <growproc>
    800022c0:	00054863          	bltz	a0,800022d0 <sys_sbrk+0x46>
    return -1;
  return addr;
    800022c4:	8526                	mv	a0,s1
}
    800022c6:	70a2                	ld	ra,40(sp)
    800022c8:	7402                	ld	s0,32(sp)
    800022ca:	64e2                	ld	s1,24(sp)
    800022cc:	6145                	addi	sp,sp,48
    800022ce:	8082                	ret
    return -1;
    800022d0:	557d                	li	a0,-1
    800022d2:	bfd5                	j	800022c6 <sys_sbrk+0x3c>

00000000800022d4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022d4:	7139                	addi	sp,sp,-64
    800022d6:	fc06                	sd	ra,56(sp)
    800022d8:	f822                	sd	s0,48(sp)
    800022da:	f426                	sd	s1,40(sp)
    800022dc:	f04a                	sd	s2,32(sp)
    800022de:	ec4e                	sd	s3,24(sp)
    800022e0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800022e2:	fcc40593          	addi	a1,s0,-52
    800022e6:	4501                	li	a0,0
    800022e8:	00000097          	auipc	ra,0x0
    800022ec:	e2a080e7          	jalr	-470(ra) # 80002112 <argint>
    return -1;
    800022f0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022f2:	06054563          	bltz	a0,8000235c <sys_sleep+0x88>
  acquire(&tickslock);
    800022f6:	0022d517          	auipc	a0,0x22d
    800022fa:	ba250513          	addi	a0,a0,-1118 # 8022ee98 <tickslock>
    800022fe:	00004097          	auipc	ra,0x4
    80002302:	f84080e7          	jalr	-124(ra) # 80006282 <acquire>
  ticks0 = ticks;
    80002306:	00007917          	auipc	s2,0x7
    8000230a:	d1292903          	lw	s2,-750(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000230e:	fcc42783          	lw	a5,-52(s0)
    80002312:	cf85                	beqz	a5,8000234a <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002314:	0022d997          	auipc	s3,0x22d
    80002318:	b8498993          	addi	s3,s3,-1148 # 8022ee98 <tickslock>
    8000231c:	00007497          	auipc	s1,0x7
    80002320:	cfc48493          	addi	s1,s1,-772 # 80009018 <ticks>
    if(myproc()->killed){
    80002324:	fffff097          	auipc	ra,0xfffff
    80002328:	c82080e7          	jalr	-894(ra) # 80000fa6 <myproc>
    8000232c:	551c                	lw	a5,40(a0)
    8000232e:	ef9d                	bnez	a5,8000236c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002330:	85ce                	mv	a1,s3
    80002332:	8526                	mv	a0,s1
    80002334:	fffff097          	auipc	ra,0xfffff
    80002338:	32e080e7          	jalr	814(ra) # 80001662 <sleep>
  while(ticks - ticks0 < n){
    8000233c:	409c                	lw	a5,0(s1)
    8000233e:	412787bb          	subw	a5,a5,s2
    80002342:	fcc42703          	lw	a4,-52(s0)
    80002346:	fce7efe3          	bltu	a5,a4,80002324 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000234a:	0022d517          	auipc	a0,0x22d
    8000234e:	b4e50513          	addi	a0,a0,-1202 # 8022ee98 <tickslock>
    80002352:	00004097          	auipc	ra,0x4
    80002356:	fe4080e7          	jalr	-28(ra) # 80006336 <release>
  return 0;
    8000235a:	4781                	li	a5,0
}
    8000235c:	853e                	mv	a0,a5
    8000235e:	70e2                	ld	ra,56(sp)
    80002360:	7442                	ld	s0,48(sp)
    80002362:	74a2                	ld	s1,40(sp)
    80002364:	7902                	ld	s2,32(sp)
    80002366:	69e2                	ld	s3,24(sp)
    80002368:	6121                	addi	sp,sp,64
    8000236a:	8082                	ret
      release(&tickslock);
    8000236c:	0022d517          	auipc	a0,0x22d
    80002370:	b2c50513          	addi	a0,a0,-1236 # 8022ee98 <tickslock>
    80002374:	00004097          	auipc	ra,0x4
    80002378:	fc2080e7          	jalr	-62(ra) # 80006336 <release>
      return -1;
    8000237c:	57fd                	li	a5,-1
    8000237e:	bff9                	j	8000235c <sys_sleep+0x88>

0000000080002380 <sys_kill>:

uint64
sys_kill(void)
{
    80002380:	1101                	addi	sp,sp,-32
    80002382:	ec06                	sd	ra,24(sp)
    80002384:	e822                	sd	s0,16(sp)
    80002386:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002388:	fec40593          	addi	a1,s0,-20
    8000238c:	4501                	li	a0,0
    8000238e:	00000097          	auipc	ra,0x0
    80002392:	d84080e7          	jalr	-636(ra) # 80002112 <argint>
    80002396:	87aa                	mv	a5,a0
    return -1;
    80002398:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000239a:	0007c863          	bltz	a5,800023aa <sys_kill+0x2a>
  return kill(pid);
    8000239e:	fec42503          	lw	a0,-20(s0)
    800023a2:	fffff097          	auipc	ra,0xfffff
    800023a6:	5f2080e7          	jalr	1522(ra) # 80001994 <kill>
}
    800023aa:	60e2                	ld	ra,24(sp)
    800023ac:	6442                	ld	s0,16(sp)
    800023ae:	6105                	addi	sp,sp,32
    800023b0:	8082                	ret

00000000800023b2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023b2:	1101                	addi	sp,sp,-32
    800023b4:	ec06                	sd	ra,24(sp)
    800023b6:	e822                	sd	s0,16(sp)
    800023b8:	e426                	sd	s1,8(sp)
    800023ba:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023bc:	0022d517          	auipc	a0,0x22d
    800023c0:	adc50513          	addi	a0,a0,-1316 # 8022ee98 <tickslock>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	ebe080e7          	jalr	-322(ra) # 80006282 <acquire>
  xticks = ticks;
    800023cc:	00007497          	auipc	s1,0x7
    800023d0:	c4c4a483          	lw	s1,-948(s1) # 80009018 <ticks>
  release(&tickslock);
    800023d4:	0022d517          	auipc	a0,0x22d
    800023d8:	ac450513          	addi	a0,a0,-1340 # 8022ee98 <tickslock>
    800023dc:	00004097          	auipc	ra,0x4
    800023e0:	f5a080e7          	jalr	-166(ra) # 80006336 <release>
  return xticks;
}
    800023e4:	02049513          	slli	a0,s1,0x20
    800023e8:	9101                	srli	a0,a0,0x20
    800023ea:	60e2                	ld	ra,24(sp)
    800023ec:	6442                	ld	s0,16(sp)
    800023ee:	64a2                	ld	s1,8(sp)
    800023f0:	6105                	addi	sp,sp,32
    800023f2:	8082                	ret

00000000800023f4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023f4:	7179                	addi	sp,sp,-48
    800023f6:	f406                	sd	ra,40(sp)
    800023f8:	f022                	sd	s0,32(sp)
    800023fa:	ec26                	sd	s1,24(sp)
    800023fc:	e84a                	sd	s2,16(sp)
    800023fe:	e44e                	sd	s3,8(sp)
    80002400:	e052                	sd	s4,0(sp)
    80002402:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002404:	00006597          	auipc	a1,0x6
    80002408:	07458593          	addi	a1,a1,116 # 80008478 <syscalls+0xb0>
    8000240c:	0022d517          	auipc	a0,0x22d
    80002410:	aa450513          	addi	a0,a0,-1372 # 8022eeb0 <bcache>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	dde080e7          	jalr	-546(ra) # 800061f2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000241c:	00235797          	auipc	a5,0x235
    80002420:	a9478793          	addi	a5,a5,-1388 # 80236eb0 <bcache+0x8000>
    80002424:	00235717          	auipc	a4,0x235
    80002428:	cf470713          	addi	a4,a4,-780 # 80237118 <bcache+0x8268>
    8000242c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002430:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002434:	0022d497          	auipc	s1,0x22d
    80002438:	a9448493          	addi	s1,s1,-1388 # 8022eec8 <bcache+0x18>
    b->next = bcache.head.next;
    8000243c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000243e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002440:	00006a17          	auipc	s4,0x6
    80002444:	040a0a13          	addi	s4,s4,64 # 80008480 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002448:	2b893783          	ld	a5,696(s2)
    8000244c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000244e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002452:	85d2                	mv	a1,s4
    80002454:	01048513          	addi	a0,s1,16
    80002458:	00001097          	auipc	ra,0x1
    8000245c:	4bc080e7          	jalr	1212(ra) # 80003914 <initsleeplock>
    bcache.head.next->prev = b;
    80002460:	2b893783          	ld	a5,696(s2)
    80002464:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002466:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000246a:	45848493          	addi	s1,s1,1112
    8000246e:	fd349de3          	bne	s1,s3,80002448 <binit+0x54>
  }
}
    80002472:	70a2                	ld	ra,40(sp)
    80002474:	7402                	ld	s0,32(sp)
    80002476:	64e2                	ld	s1,24(sp)
    80002478:	6942                	ld	s2,16(sp)
    8000247a:	69a2                	ld	s3,8(sp)
    8000247c:	6a02                	ld	s4,0(sp)
    8000247e:	6145                	addi	sp,sp,48
    80002480:	8082                	ret

0000000080002482 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002482:	7179                	addi	sp,sp,-48
    80002484:	f406                	sd	ra,40(sp)
    80002486:	f022                	sd	s0,32(sp)
    80002488:	ec26                	sd	s1,24(sp)
    8000248a:	e84a                	sd	s2,16(sp)
    8000248c:	e44e                	sd	s3,8(sp)
    8000248e:	1800                	addi	s0,sp,48
    80002490:	89aa                	mv	s3,a0
    80002492:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002494:	0022d517          	auipc	a0,0x22d
    80002498:	a1c50513          	addi	a0,a0,-1508 # 8022eeb0 <bcache>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	de6080e7          	jalr	-538(ra) # 80006282 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024a4:	00235497          	auipc	s1,0x235
    800024a8:	cc44b483          	ld	s1,-828(s1) # 80237168 <bcache+0x82b8>
    800024ac:	00235797          	auipc	a5,0x235
    800024b0:	c6c78793          	addi	a5,a5,-916 # 80237118 <bcache+0x8268>
    800024b4:	02f48f63          	beq	s1,a5,800024f2 <bread+0x70>
    800024b8:	873e                	mv	a4,a5
    800024ba:	a021                	j	800024c2 <bread+0x40>
    800024bc:	68a4                	ld	s1,80(s1)
    800024be:	02e48a63          	beq	s1,a4,800024f2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024c2:	449c                	lw	a5,8(s1)
    800024c4:	ff379ce3          	bne	a5,s3,800024bc <bread+0x3a>
    800024c8:	44dc                	lw	a5,12(s1)
    800024ca:	ff2799e3          	bne	a5,s2,800024bc <bread+0x3a>
      b->refcnt++;
    800024ce:	40bc                	lw	a5,64(s1)
    800024d0:	2785                	addiw	a5,a5,1
    800024d2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024d4:	0022d517          	auipc	a0,0x22d
    800024d8:	9dc50513          	addi	a0,a0,-1572 # 8022eeb0 <bcache>
    800024dc:	00004097          	auipc	ra,0x4
    800024e0:	e5a080e7          	jalr	-422(ra) # 80006336 <release>
      acquiresleep(&b->lock);
    800024e4:	01048513          	addi	a0,s1,16
    800024e8:	00001097          	auipc	ra,0x1
    800024ec:	466080e7          	jalr	1126(ra) # 8000394e <acquiresleep>
      return b;
    800024f0:	a8b9                	j	8000254e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024f2:	00235497          	auipc	s1,0x235
    800024f6:	c6e4b483          	ld	s1,-914(s1) # 80237160 <bcache+0x82b0>
    800024fa:	00235797          	auipc	a5,0x235
    800024fe:	c1e78793          	addi	a5,a5,-994 # 80237118 <bcache+0x8268>
    80002502:	00f48863          	beq	s1,a5,80002512 <bread+0x90>
    80002506:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002508:	40bc                	lw	a5,64(s1)
    8000250a:	cf81                	beqz	a5,80002522 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000250c:	64a4                	ld	s1,72(s1)
    8000250e:	fee49de3          	bne	s1,a4,80002508 <bread+0x86>
  panic("bget: no buffers");
    80002512:	00006517          	auipc	a0,0x6
    80002516:	f7650513          	addi	a0,a0,-138 # 80008488 <syscalls+0xc0>
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	81e080e7          	jalr	-2018(ra) # 80005d38 <panic>
      b->dev = dev;
    80002522:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002526:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000252a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000252e:	4785                	li	a5,1
    80002530:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002532:	0022d517          	auipc	a0,0x22d
    80002536:	97e50513          	addi	a0,a0,-1666 # 8022eeb0 <bcache>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	dfc080e7          	jalr	-516(ra) # 80006336 <release>
      acquiresleep(&b->lock);
    80002542:	01048513          	addi	a0,s1,16
    80002546:	00001097          	auipc	ra,0x1
    8000254a:	408080e7          	jalr	1032(ra) # 8000394e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000254e:	409c                	lw	a5,0(s1)
    80002550:	cb89                	beqz	a5,80002562 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002552:	8526                	mv	a0,s1
    80002554:	70a2                	ld	ra,40(sp)
    80002556:	7402                	ld	s0,32(sp)
    80002558:	64e2                	ld	s1,24(sp)
    8000255a:	6942                	ld	s2,16(sp)
    8000255c:	69a2                	ld	s3,8(sp)
    8000255e:	6145                	addi	sp,sp,48
    80002560:	8082                	ret
    virtio_disk_rw(b, 0);
    80002562:	4581                	li	a1,0
    80002564:	8526                	mv	a0,s1
    80002566:	00003097          	auipc	ra,0x3
    8000256a:	f10080e7          	jalr	-240(ra) # 80005476 <virtio_disk_rw>
    b->valid = 1;
    8000256e:	4785                	li	a5,1
    80002570:	c09c                	sw	a5,0(s1)
  return b;
    80002572:	b7c5                	j	80002552 <bread+0xd0>

0000000080002574 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002574:	1101                	addi	sp,sp,-32
    80002576:	ec06                	sd	ra,24(sp)
    80002578:	e822                	sd	s0,16(sp)
    8000257a:	e426                	sd	s1,8(sp)
    8000257c:	1000                	addi	s0,sp,32
    8000257e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002580:	0541                	addi	a0,a0,16
    80002582:	00001097          	auipc	ra,0x1
    80002586:	466080e7          	jalr	1126(ra) # 800039e8 <holdingsleep>
    8000258a:	cd01                	beqz	a0,800025a2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000258c:	4585                	li	a1,1
    8000258e:	8526                	mv	a0,s1
    80002590:	00003097          	auipc	ra,0x3
    80002594:	ee6080e7          	jalr	-282(ra) # 80005476 <virtio_disk_rw>
}
    80002598:	60e2                	ld	ra,24(sp)
    8000259a:	6442                	ld	s0,16(sp)
    8000259c:	64a2                	ld	s1,8(sp)
    8000259e:	6105                	addi	sp,sp,32
    800025a0:	8082                	ret
    panic("bwrite");
    800025a2:	00006517          	auipc	a0,0x6
    800025a6:	efe50513          	addi	a0,a0,-258 # 800084a0 <syscalls+0xd8>
    800025aa:	00003097          	auipc	ra,0x3
    800025ae:	78e080e7          	jalr	1934(ra) # 80005d38 <panic>

00000000800025b2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025b2:	1101                	addi	sp,sp,-32
    800025b4:	ec06                	sd	ra,24(sp)
    800025b6:	e822                	sd	s0,16(sp)
    800025b8:	e426                	sd	s1,8(sp)
    800025ba:	e04a                	sd	s2,0(sp)
    800025bc:	1000                	addi	s0,sp,32
    800025be:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025c0:	01050913          	addi	s2,a0,16
    800025c4:	854a                	mv	a0,s2
    800025c6:	00001097          	auipc	ra,0x1
    800025ca:	422080e7          	jalr	1058(ra) # 800039e8 <holdingsleep>
    800025ce:	c92d                	beqz	a0,80002640 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025d0:	854a                	mv	a0,s2
    800025d2:	00001097          	auipc	ra,0x1
    800025d6:	3d2080e7          	jalr	978(ra) # 800039a4 <releasesleep>

  acquire(&bcache.lock);
    800025da:	0022d517          	auipc	a0,0x22d
    800025de:	8d650513          	addi	a0,a0,-1834 # 8022eeb0 <bcache>
    800025e2:	00004097          	auipc	ra,0x4
    800025e6:	ca0080e7          	jalr	-864(ra) # 80006282 <acquire>
  b->refcnt--;
    800025ea:	40bc                	lw	a5,64(s1)
    800025ec:	37fd                	addiw	a5,a5,-1
    800025ee:	0007871b          	sext.w	a4,a5
    800025f2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025f4:	eb05                	bnez	a4,80002624 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025f6:	68bc                	ld	a5,80(s1)
    800025f8:	64b8                	ld	a4,72(s1)
    800025fa:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025fc:	64bc                	ld	a5,72(s1)
    800025fe:	68b8                	ld	a4,80(s1)
    80002600:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002602:	00235797          	auipc	a5,0x235
    80002606:	8ae78793          	addi	a5,a5,-1874 # 80236eb0 <bcache+0x8000>
    8000260a:	2b87b703          	ld	a4,696(a5)
    8000260e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002610:	00235717          	auipc	a4,0x235
    80002614:	b0870713          	addi	a4,a4,-1272 # 80237118 <bcache+0x8268>
    80002618:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000261a:	2b87b703          	ld	a4,696(a5)
    8000261e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002620:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002624:	0022d517          	auipc	a0,0x22d
    80002628:	88c50513          	addi	a0,a0,-1908 # 8022eeb0 <bcache>
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	d0a080e7          	jalr	-758(ra) # 80006336 <release>
}
    80002634:	60e2                	ld	ra,24(sp)
    80002636:	6442                	ld	s0,16(sp)
    80002638:	64a2                	ld	s1,8(sp)
    8000263a:	6902                	ld	s2,0(sp)
    8000263c:	6105                	addi	sp,sp,32
    8000263e:	8082                	ret
    panic("brelse");
    80002640:	00006517          	auipc	a0,0x6
    80002644:	e6850513          	addi	a0,a0,-408 # 800084a8 <syscalls+0xe0>
    80002648:	00003097          	auipc	ra,0x3
    8000264c:	6f0080e7          	jalr	1776(ra) # 80005d38 <panic>

0000000080002650 <bpin>:

void
bpin(struct buf *b) {
    80002650:	1101                	addi	sp,sp,-32
    80002652:	ec06                	sd	ra,24(sp)
    80002654:	e822                	sd	s0,16(sp)
    80002656:	e426                	sd	s1,8(sp)
    80002658:	1000                	addi	s0,sp,32
    8000265a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000265c:	0022d517          	auipc	a0,0x22d
    80002660:	85450513          	addi	a0,a0,-1964 # 8022eeb0 <bcache>
    80002664:	00004097          	auipc	ra,0x4
    80002668:	c1e080e7          	jalr	-994(ra) # 80006282 <acquire>
  b->refcnt++;
    8000266c:	40bc                	lw	a5,64(s1)
    8000266e:	2785                	addiw	a5,a5,1
    80002670:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002672:	0022d517          	auipc	a0,0x22d
    80002676:	83e50513          	addi	a0,a0,-1986 # 8022eeb0 <bcache>
    8000267a:	00004097          	auipc	ra,0x4
    8000267e:	cbc080e7          	jalr	-836(ra) # 80006336 <release>
}
    80002682:	60e2                	ld	ra,24(sp)
    80002684:	6442                	ld	s0,16(sp)
    80002686:	64a2                	ld	s1,8(sp)
    80002688:	6105                	addi	sp,sp,32
    8000268a:	8082                	ret

000000008000268c <bunpin>:

void
bunpin(struct buf *b) {
    8000268c:	1101                	addi	sp,sp,-32
    8000268e:	ec06                	sd	ra,24(sp)
    80002690:	e822                	sd	s0,16(sp)
    80002692:	e426                	sd	s1,8(sp)
    80002694:	1000                	addi	s0,sp,32
    80002696:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002698:	0022d517          	auipc	a0,0x22d
    8000269c:	81850513          	addi	a0,a0,-2024 # 8022eeb0 <bcache>
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	be2080e7          	jalr	-1054(ra) # 80006282 <acquire>
  b->refcnt--;
    800026a8:	40bc                	lw	a5,64(s1)
    800026aa:	37fd                	addiw	a5,a5,-1
    800026ac:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026ae:	0022d517          	auipc	a0,0x22d
    800026b2:	80250513          	addi	a0,a0,-2046 # 8022eeb0 <bcache>
    800026b6:	00004097          	auipc	ra,0x4
    800026ba:	c80080e7          	jalr	-896(ra) # 80006336 <release>
}
    800026be:	60e2                	ld	ra,24(sp)
    800026c0:	6442                	ld	s0,16(sp)
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret

00000000800026c8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026c8:	1101                	addi	sp,sp,-32
    800026ca:	ec06                	sd	ra,24(sp)
    800026cc:	e822                	sd	s0,16(sp)
    800026ce:	e426                	sd	s1,8(sp)
    800026d0:	e04a                	sd	s2,0(sp)
    800026d2:	1000                	addi	s0,sp,32
    800026d4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026d6:	00d5d59b          	srliw	a1,a1,0xd
    800026da:	00235797          	auipc	a5,0x235
    800026de:	eb27a783          	lw	a5,-334(a5) # 8023758c <sb+0x1c>
    800026e2:	9dbd                	addw	a1,a1,a5
    800026e4:	00000097          	auipc	ra,0x0
    800026e8:	d9e080e7          	jalr	-610(ra) # 80002482 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026ec:	0074f713          	andi	a4,s1,7
    800026f0:	4785                	li	a5,1
    800026f2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026f6:	14ce                	slli	s1,s1,0x33
    800026f8:	90d9                	srli	s1,s1,0x36
    800026fa:	00950733          	add	a4,a0,s1
    800026fe:	05874703          	lbu	a4,88(a4)
    80002702:	00e7f6b3          	and	a3,a5,a4
    80002706:	c69d                	beqz	a3,80002734 <bfree+0x6c>
    80002708:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000270a:	94aa                	add	s1,s1,a0
    8000270c:	fff7c793          	not	a5,a5
    80002710:	8ff9                	and	a5,a5,a4
    80002712:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002716:	00001097          	auipc	ra,0x1
    8000271a:	118080e7          	jalr	280(ra) # 8000382e <log_write>
  brelse(bp);
    8000271e:	854a                	mv	a0,s2
    80002720:	00000097          	auipc	ra,0x0
    80002724:	e92080e7          	jalr	-366(ra) # 800025b2 <brelse>
}
    80002728:	60e2                	ld	ra,24(sp)
    8000272a:	6442                	ld	s0,16(sp)
    8000272c:	64a2                	ld	s1,8(sp)
    8000272e:	6902                	ld	s2,0(sp)
    80002730:	6105                	addi	sp,sp,32
    80002732:	8082                	ret
    panic("freeing free block");
    80002734:	00006517          	auipc	a0,0x6
    80002738:	d7c50513          	addi	a0,a0,-644 # 800084b0 <syscalls+0xe8>
    8000273c:	00003097          	auipc	ra,0x3
    80002740:	5fc080e7          	jalr	1532(ra) # 80005d38 <panic>

0000000080002744 <balloc>:
{
    80002744:	711d                	addi	sp,sp,-96
    80002746:	ec86                	sd	ra,88(sp)
    80002748:	e8a2                	sd	s0,80(sp)
    8000274a:	e4a6                	sd	s1,72(sp)
    8000274c:	e0ca                	sd	s2,64(sp)
    8000274e:	fc4e                	sd	s3,56(sp)
    80002750:	f852                	sd	s4,48(sp)
    80002752:	f456                	sd	s5,40(sp)
    80002754:	f05a                	sd	s6,32(sp)
    80002756:	ec5e                	sd	s7,24(sp)
    80002758:	e862                	sd	s8,16(sp)
    8000275a:	e466                	sd	s9,8(sp)
    8000275c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000275e:	00235797          	auipc	a5,0x235
    80002762:	e167a783          	lw	a5,-490(a5) # 80237574 <sb+0x4>
    80002766:	cbd1                	beqz	a5,800027fa <balloc+0xb6>
    80002768:	8baa                	mv	s7,a0
    8000276a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000276c:	00235b17          	auipc	s6,0x235
    80002770:	e04b0b13          	addi	s6,s6,-508 # 80237570 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002774:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002776:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002778:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000277a:	6c89                	lui	s9,0x2
    8000277c:	a831                	j	80002798 <balloc+0x54>
    brelse(bp);
    8000277e:	854a                	mv	a0,s2
    80002780:	00000097          	auipc	ra,0x0
    80002784:	e32080e7          	jalr	-462(ra) # 800025b2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002788:	015c87bb          	addw	a5,s9,s5
    8000278c:	00078a9b          	sext.w	s5,a5
    80002790:	004b2703          	lw	a4,4(s6)
    80002794:	06eaf363          	bgeu	s5,a4,800027fa <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002798:	41fad79b          	sraiw	a5,s5,0x1f
    8000279c:	0137d79b          	srliw	a5,a5,0x13
    800027a0:	015787bb          	addw	a5,a5,s5
    800027a4:	40d7d79b          	sraiw	a5,a5,0xd
    800027a8:	01cb2583          	lw	a1,28(s6)
    800027ac:	9dbd                	addw	a1,a1,a5
    800027ae:	855e                	mv	a0,s7
    800027b0:	00000097          	auipc	ra,0x0
    800027b4:	cd2080e7          	jalr	-814(ra) # 80002482 <bread>
    800027b8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ba:	004b2503          	lw	a0,4(s6)
    800027be:	000a849b          	sext.w	s1,s5
    800027c2:	8662                	mv	a2,s8
    800027c4:	faa4fde3          	bgeu	s1,a0,8000277e <balloc+0x3a>
      m = 1 << (bi % 8);
    800027c8:	41f6579b          	sraiw	a5,a2,0x1f
    800027cc:	01d7d69b          	srliw	a3,a5,0x1d
    800027d0:	00c6873b          	addw	a4,a3,a2
    800027d4:	00777793          	andi	a5,a4,7
    800027d8:	9f95                	subw	a5,a5,a3
    800027da:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027de:	4037571b          	sraiw	a4,a4,0x3
    800027e2:	00e906b3          	add	a3,s2,a4
    800027e6:	0586c683          	lbu	a3,88(a3)
    800027ea:	00d7f5b3          	and	a1,a5,a3
    800027ee:	cd91                	beqz	a1,8000280a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027f0:	2605                	addiw	a2,a2,1
    800027f2:	2485                	addiw	s1,s1,1
    800027f4:	fd4618e3          	bne	a2,s4,800027c4 <balloc+0x80>
    800027f8:	b759                	j	8000277e <balloc+0x3a>
  panic("balloc: out of blocks");
    800027fa:	00006517          	auipc	a0,0x6
    800027fe:	cce50513          	addi	a0,a0,-818 # 800084c8 <syscalls+0x100>
    80002802:	00003097          	auipc	ra,0x3
    80002806:	536080e7          	jalr	1334(ra) # 80005d38 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000280a:	974a                	add	a4,a4,s2
    8000280c:	8fd5                	or	a5,a5,a3
    8000280e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002812:	854a                	mv	a0,s2
    80002814:	00001097          	auipc	ra,0x1
    80002818:	01a080e7          	jalr	26(ra) # 8000382e <log_write>
        brelse(bp);
    8000281c:	854a                	mv	a0,s2
    8000281e:	00000097          	auipc	ra,0x0
    80002822:	d94080e7          	jalr	-620(ra) # 800025b2 <brelse>
  bp = bread(dev, bno);
    80002826:	85a6                	mv	a1,s1
    80002828:	855e                	mv	a0,s7
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	c58080e7          	jalr	-936(ra) # 80002482 <bread>
    80002832:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002834:	40000613          	li	a2,1024
    80002838:	4581                	li	a1,0
    8000283a:	05850513          	addi	a0,a0,88
    8000283e:	ffffe097          	auipc	ra,0xffffe
    80002842:	9bc080e7          	jalr	-1604(ra) # 800001fa <memset>
  log_write(bp);
    80002846:	854a                	mv	a0,s2
    80002848:	00001097          	auipc	ra,0x1
    8000284c:	fe6080e7          	jalr	-26(ra) # 8000382e <log_write>
  brelse(bp);
    80002850:	854a                	mv	a0,s2
    80002852:	00000097          	auipc	ra,0x0
    80002856:	d60080e7          	jalr	-672(ra) # 800025b2 <brelse>
}
    8000285a:	8526                	mv	a0,s1
    8000285c:	60e6                	ld	ra,88(sp)
    8000285e:	6446                	ld	s0,80(sp)
    80002860:	64a6                	ld	s1,72(sp)
    80002862:	6906                	ld	s2,64(sp)
    80002864:	79e2                	ld	s3,56(sp)
    80002866:	7a42                	ld	s4,48(sp)
    80002868:	7aa2                	ld	s5,40(sp)
    8000286a:	7b02                	ld	s6,32(sp)
    8000286c:	6be2                	ld	s7,24(sp)
    8000286e:	6c42                	ld	s8,16(sp)
    80002870:	6ca2                	ld	s9,8(sp)
    80002872:	6125                	addi	sp,sp,96
    80002874:	8082                	ret

0000000080002876 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002876:	7179                	addi	sp,sp,-48
    80002878:	f406                	sd	ra,40(sp)
    8000287a:	f022                	sd	s0,32(sp)
    8000287c:	ec26                	sd	s1,24(sp)
    8000287e:	e84a                	sd	s2,16(sp)
    80002880:	e44e                	sd	s3,8(sp)
    80002882:	e052                	sd	s4,0(sp)
    80002884:	1800                	addi	s0,sp,48
    80002886:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002888:	47ad                	li	a5,11
    8000288a:	04b7fe63          	bgeu	a5,a1,800028e6 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000288e:	ff45849b          	addiw	s1,a1,-12
    80002892:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002896:	0ff00793          	li	a5,255
    8000289a:	0ae7e363          	bltu	a5,a4,80002940 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000289e:	08052583          	lw	a1,128(a0)
    800028a2:	c5ad                	beqz	a1,8000290c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028a4:	00092503          	lw	a0,0(s2)
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	bda080e7          	jalr	-1062(ra) # 80002482 <bread>
    800028b0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028b2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028b6:	02049593          	slli	a1,s1,0x20
    800028ba:	9181                	srli	a1,a1,0x20
    800028bc:	058a                	slli	a1,a1,0x2
    800028be:	00b784b3          	add	s1,a5,a1
    800028c2:	0004a983          	lw	s3,0(s1)
    800028c6:	04098d63          	beqz	s3,80002920 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028ca:	8552                	mv	a0,s4
    800028cc:	00000097          	auipc	ra,0x0
    800028d0:	ce6080e7          	jalr	-794(ra) # 800025b2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028d4:	854e                	mv	a0,s3
    800028d6:	70a2                	ld	ra,40(sp)
    800028d8:	7402                	ld	s0,32(sp)
    800028da:	64e2                	ld	s1,24(sp)
    800028dc:	6942                	ld	s2,16(sp)
    800028de:	69a2                	ld	s3,8(sp)
    800028e0:	6a02                	ld	s4,0(sp)
    800028e2:	6145                	addi	sp,sp,48
    800028e4:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800028e6:	02059493          	slli	s1,a1,0x20
    800028ea:	9081                	srli	s1,s1,0x20
    800028ec:	048a                	slli	s1,s1,0x2
    800028ee:	94aa                	add	s1,s1,a0
    800028f0:	0504a983          	lw	s3,80(s1)
    800028f4:	fe0990e3          	bnez	s3,800028d4 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800028f8:	4108                	lw	a0,0(a0)
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	e4a080e7          	jalr	-438(ra) # 80002744 <balloc>
    80002902:	0005099b          	sext.w	s3,a0
    80002906:	0534a823          	sw	s3,80(s1)
    8000290a:	b7e9                	j	800028d4 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000290c:	4108                	lw	a0,0(a0)
    8000290e:	00000097          	auipc	ra,0x0
    80002912:	e36080e7          	jalr	-458(ra) # 80002744 <balloc>
    80002916:	0005059b          	sext.w	a1,a0
    8000291a:	08b92023          	sw	a1,128(s2)
    8000291e:	b759                	j	800028a4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002920:	00092503          	lw	a0,0(s2)
    80002924:	00000097          	auipc	ra,0x0
    80002928:	e20080e7          	jalr	-480(ra) # 80002744 <balloc>
    8000292c:	0005099b          	sext.w	s3,a0
    80002930:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002934:	8552                	mv	a0,s4
    80002936:	00001097          	auipc	ra,0x1
    8000293a:	ef8080e7          	jalr	-264(ra) # 8000382e <log_write>
    8000293e:	b771                	j	800028ca <bmap+0x54>
  panic("bmap: out of range");
    80002940:	00006517          	auipc	a0,0x6
    80002944:	ba050513          	addi	a0,a0,-1120 # 800084e0 <syscalls+0x118>
    80002948:	00003097          	auipc	ra,0x3
    8000294c:	3f0080e7          	jalr	1008(ra) # 80005d38 <panic>

0000000080002950 <iget>:
{
    80002950:	7179                	addi	sp,sp,-48
    80002952:	f406                	sd	ra,40(sp)
    80002954:	f022                	sd	s0,32(sp)
    80002956:	ec26                	sd	s1,24(sp)
    80002958:	e84a                	sd	s2,16(sp)
    8000295a:	e44e                	sd	s3,8(sp)
    8000295c:	e052                	sd	s4,0(sp)
    8000295e:	1800                	addi	s0,sp,48
    80002960:	89aa                	mv	s3,a0
    80002962:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002964:	00235517          	auipc	a0,0x235
    80002968:	c2c50513          	addi	a0,a0,-980 # 80237590 <itable>
    8000296c:	00004097          	auipc	ra,0x4
    80002970:	916080e7          	jalr	-1770(ra) # 80006282 <acquire>
  empty = 0;
    80002974:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002976:	00235497          	auipc	s1,0x235
    8000297a:	c3248493          	addi	s1,s1,-974 # 802375a8 <itable+0x18>
    8000297e:	00236697          	auipc	a3,0x236
    80002982:	6ba68693          	addi	a3,a3,1722 # 80239038 <log>
    80002986:	a039                	j	80002994 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002988:	02090b63          	beqz	s2,800029be <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000298c:	08848493          	addi	s1,s1,136
    80002990:	02d48a63          	beq	s1,a3,800029c4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002994:	449c                	lw	a5,8(s1)
    80002996:	fef059e3          	blez	a5,80002988 <iget+0x38>
    8000299a:	4098                	lw	a4,0(s1)
    8000299c:	ff3716e3          	bne	a4,s3,80002988 <iget+0x38>
    800029a0:	40d8                	lw	a4,4(s1)
    800029a2:	ff4713e3          	bne	a4,s4,80002988 <iget+0x38>
      ip->ref++;
    800029a6:	2785                	addiw	a5,a5,1
    800029a8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029aa:	00235517          	auipc	a0,0x235
    800029ae:	be650513          	addi	a0,a0,-1050 # 80237590 <itable>
    800029b2:	00004097          	auipc	ra,0x4
    800029b6:	984080e7          	jalr	-1660(ra) # 80006336 <release>
      return ip;
    800029ba:	8926                	mv	s2,s1
    800029bc:	a03d                	j	800029ea <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029be:	f7f9                	bnez	a5,8000298c <iget+0x3c>
    800029c0:	8926                	mv	s2,s1
    800029c2:	b7e9                	j	8000298c <iget+0x3c>
  if(empty == 0)
    800029c4:	02090c63          	beqz	s2,800029fc <iget+0xac>
  ip->dev = dev;
    800029c8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029cc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029d0:	4785                	li	a5,1
    800029d2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029d6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029da:	00235517          	auipc	a0,0x235
    800029de:	bb650513          	addi	a0,a0,-1098 # 80237590 <itable>
    800029e2:	00004097          	auipc	ra,0x4
    800029e6:	954080e7          	jalr	-1708(ra) # 80006336 <release>
}
    800029ea:	854a                	mv	a0,s2
    800029ec:	70a2                	ld	ra,40(sp)
    800029ee:	7402                	ld	s0,32(sp)
    800029f0:	64e2                	ld	s1,24(sp)
    800029f2:	6942                	ld	s2,16(sp)
    800029f4:	69a2                	ld	s3,8(sp)
    800029f6:	6a02                	ld	s4,0(sp)
    800029f8:	6145                	addi	sp,sp,48
    800029fa:	8082                	ret
    panic("iget: no inodes");
    800029fc:	00006517          	auipc	a0,0x6
    80002a00:	afc50513          	addi	a0,a0,-1284 # 800084f8 <syscalls+0x130>
    80002a04:	00003097          	auipc	ra,0x3
    80002a08:	334080e7          	jalr	820(ra) # 80005d38 <panic>

0000000080002a0c <fsinit>:
fsinit(int dev) {
    80002a0c:	7179                	addi	sp,sp,-48
    80002a0e:	f406                	sd	ra,40(sp)
    80002a10:	f022                	sd	s0,32(sp)
    80002a12:	ec26                	sd	s1,24(sp)
    80002a14:	e84a                	sd	s2,16(sp)
    80002a16:	e44e                	sd	s3,8(sp)
    80002a18:	1800                	addi	s0,sp,48
    80002a1a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a1c:	4585                	li	a1,1
    80002a1e:	00000097          	auipc	ra,0x0
    80002a22:	a64080e7          	jalr	-1436(ra) # 80002482 <bread>
    80002a26:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a28:	00235997          	auipc	s3,0x235
    80002a2c:	b4898993          	addi	s3,s3,-1208 # 80237570 <sb>
    80002a30:	02000613          	li	a2,32
    80002a34:	05850593          	addi	a1,a0,88
    80002a38:	854e                	mv	a0,s3
    80002a3a:	ffffe097          	auipc	ra,0xffffe
    80002a3e:	820080e7          	jalr	-2016(ra) # 8000025a <memmove>
  brelse(bp);
    80002a42:	8526                	mv	a0,s1
    80002a44:	00000097          	auipc	ra,0x0
    80002a48:	b6e080e7          	jalr	-1170(ra) # 800025b2 <brelse>
  if(sb.magic != FSMAGIC)
    80002a4c:	0009a703          	lw	a4,0(s3)
    80002a50:	102037b7          	lui	a5,0x10203
    80002a54:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a58:	02f71263          	bne	a4,a5,80002a7c <fsinit+0x70>
  initlog(dev, &sb);
    80002a5c:	00235597          	auipc	a1,0x235
    80002a60:	b1458593          	addi	a1,a1,-1260 # 80237570 <sb>
    80002a64:	854a                	mv	a0,s2
    80002a66:	00001097          	auipc	ra,0x1
    80002a6a:	b4c080e7          	jalr	-1204(ra) # 800035b2 <initlog>
}
    80002a6e:	70a2                	ld	ra,40(sp)
    80002a70:	7402                	ld	s0,32(sp)
    80002a72:	64e2                	ld	s1,24(sp)
    80002a74:	6942                	ld	s2,16(sp)
    80002a76:	69a2                	ld	s3,8(sp)
    80002a78:	6145                	addi	sp,sp,48
    80002a7a:	8082                	ret
    panic("invalid file system");
    80002a7c:	00006517          	auipc	a0,0x6
    80002a80:	a8c50513          	addi	a0,a0,-1396 # 80008508 <syscalls+0x140>
    80002a84:	00003097          	auipc	ra,0x3
    80002a88:	2b4080e7          	jalr	692(ra) # 80005d38 <panic>

0000000080002a8c <iinit>:
{
    80002a8c:	7179                	addi	sp,sp,-48
    80002a8e:	f406                	sd	ra,40(sp)
    80002a90:	f022                	sd	s0,32(sp)
    80002a92:	ec26                	sd	s1,24(sp)
    80002a94:	e84a                	sd	s2,16(sp)
    80002a96:	e44e                	sd	s3,8(sp)
    80002a98:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a9a:	00006597          	auipc	a1,0x6
    80002a9e:	a8658593          	addi	a1,a1,-1402 # 80008520 <syscalls+0x158>
    80002aa2:	00235517          	auipc	a0,0x235
    80002aa6:	aee50513          	addi	a0,a0,-1298 # 80237590 <itable>
    80002aaa:	00003097          	auipc	ra,0x3
    80002aae:	748080e7          	jalr	1864(ra) # 800061f2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ab2:	00235497          	auipc	s1,0x235
    80002ab6:	b0648493          	addi	s1,s1,-1274 # 802375b8 <itable+0x28>
    80002aba:	00236997          	auipc	s3,0x236
    80002abe:	58e98993          	addi	s3,s3,1422 # 80239048 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ac2:	00006917          	auipc	s2,0x6
    80002ac6:	a6690913          	addi	s2,s2,-1434 # 80008528 <syscalls+0x160>
    80002aca:	85ca                	mv	a1,s2
    80002acc:	8526                	mv	a0,s1
    80002ace:	00001097          	auipc	ra,0x1
    80002ad2:	e46080e7          	jalr	-442(ra) # 80003914 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ad6:	08848493          	addi	s1,s1,136
    80002ada:	ff3498e3          	bne	s1,s3,80002aca <iinit+0x3e>
}
    80002ade:	70a2                	ld	ra,40(sp)
    80002ae0:	7402                	ld	s0,32(sp)
    80002ae2:	64e2                	ld	s1,24(sp)
    80002ae4:	6942                	ld	s2,16(sp)
    80002ae6:	69a2                	ld	s3,8(sp)
    80002ae8:	6145                	addi	sp,sp,48
    80002aea:	8082                	ret

0000000080002aec <ialloc>:
{
    80002aec:	715d                	addi	sp,sp,-80
    80002aee:	e486                	sd	ra,72(sp)
    80002af0:	e0a2                	sd	s0,64(sp)
    80002af2:	fc26                	sd	s1,56(sp)
    80002af4:	f84a                	sd	s2,48(sp)
    80002af6:	f44e                	sd	s3,40(sp)
    80002af8:	f052                	sd	s4,32(sp)
    80002afa:	ec56                	sd	s5,24(sp)
    80002afc:	e85a                	sd	s6,16(sp)
    80002afe:	e45e                	sd	s7,8(sp)
    80002b00:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b02:	00235717          	auipc	a4,0x235
    80002b06:	a7a72703          	lw	a4,-1414(a4) # 8023757c <sb+0xc>
    80002b0a:	4785                	li	a5,1
    80002b0c:	04e7fa63          	bgeu	a5,a4,80002b60 <ialloc+0x74>
    80002b10:	8aaa                	mv	s5,a0
    80002b12:	8bae                	mv	s7,a1
    80002b14:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b16:	00235a17          	auipc	s4,0x235
    80002b1a:	a5aa0a13          	addi	s4,s4,-1446 # 80237570 <sb>
    80002b1e:	00048b1b          	sext.w	s6,s1
    80002b22:	0044d593          	srli	a1,s1,0x4
    80002b26:	018a2783          	lw	a5,24(s4)
    80002b2a:	9dbd                	addw	a1,a1,a5
    80002b2c:	8556                	mv	a0,s5
    80002b2e:	00000097          	auipc	ra,0x0
    80002b32:	954080e7          	jalr	-1708(ra) # 80002482 <bread>
    80002b36:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b38:	05850993          	addi	s3,a0,88
    80002b3c:	00f4f793          	andi	a5,s1,15
    80002b40:	079a                	slli	a5,a5,0x6
    80002b42:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b44:	00099783          	lh	a5,0(s3)
    80002b48:	c785                	beqz	a5,80002b70 <ialloc+0x84>
    brelse(bp);
    80002b4a:	00000097          	auipc	ra,0x0
    80002b4e:	a68080e7          	jalr	-1432(ra) # 800025b2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b52:	0485                	addi	s1,s1,1
    80002b54:	00ca2703          	lw	a4,12(s4)
    80002b58:	0004879b          	sext.w	a5,s1
    80002b5c:	fce7e1e3          	bltu	a5,a4,80002b1e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b60:	00006517          	auipc	a0,0x6
    80002b64:	9d050513          	addi	a0,a0,-1584 # 80008530 <syscalls+0x168>
    80002b68:	00003097          	auipc	ra,0x3
    80002b6c:	1d0080e7          	jalr	464(ra) # 80005d38 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b70:	04000613          	li	a2,64
    80002b74:	4581                	li	a1,0
    80002b76:	854e                	mv	a0,s3
    80002b78:	ffffd097          	auipc	ra,0xffffd
    80002b7c:	682080e7          	jalr	1666(ra) # 800001fa <memset>
      dip->type = type;
    80002b80:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b84:	854a                	mv	a0,s2
    80002b86:	00001097          	auipc	ra,0x1
    80002b8a:	ca8080e7          	jalr	-856(ra) # 8000382e <log_write>
      brelse(bp);
    80002b8e:	854a                	mv	a0,s2
    80002b90:	00000097          	auipc	ra,0x0
    80002b94:	a22080e7          	jalr	-1502(ra) # 800025b2 <brelse>
      return iget(dev, inum);
    80002b98:	85da                	mv	a1,s6
    80002b9a:	8556                	mv	a0,s5
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	db4080e7          	jalr	-588(ra) # 80002950 <iget>
}
    80002ba4:	60a6                	ld	ra,72(sp)
    80002ba6:	6406                	ld	s0,64(sp)
    80002ba8:	74e2                	ld	s1,56(sp)
    80002baa:	7942                	ld	s2,48(sp)
    80002bac:	79a2                	ld	s3,40(sp)
    80002bae:	7a02                	ld	s4,32(sp)
    80002bb0:	6ae2                	ld	s5,24(sp)
    80002bb2:	6b42                	ld	s6,16(sp)
    80002bb4:	6ba2                	ld	s7,8(sp)
    80002bb6:	6161                	addi	sp,sp,80
    80002bb8:	8082                	ret

0000000080002bba <iupdate>:
{
    80002bba:	1101                	addi	sp,sp,-32
    80002bbc:	ec06                	sd	ra,24(sp)
    80002bbe:	e822                	sd	s0,16(sp)
    80002bc0:	e426                	sd	s1,8(sp)
    80002bc2:	e04a                	sd	s2,0(sp)
    80002bc4:	1000                	addi	s0,sp,32
    80002bc6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bc8:	415c                	lw	a5,4(a0)
    80002bca:	0047d79b          	srliw	a5,a5,0x4
    80002bce:	00235597          	auipc	a1,0x235
    80002bd2:	9ba5a583          	lw	a1,-1606(a1) # 80237588 <sb+0x18>
    80002bd6:	9dbd                	addw	a1,a1,a5
    80002bd8:	4108                	lw	a0,0(a0)
    80002bda:	00000097          	auipc	ra,0x0
    80002bde:	8a8080e7          	jalr	-1880(ra) # 80002482 <bread>
    80002be2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002be4:	05850793          	addi	a5,a0,88
    80002be8:	40c8                	lw	a0,4(s1)
    80002bea:	893d                	andi	a0,a0,15
    80002bec:	051a                	slli	a0,a0,0x6
    80002bee:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002bf0:	04449703          	lh	a4,68(s1)
    80002bf4:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002bf8:	04649703          	lh	a4,70(s1)
    80002bfc:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c00:	04849703          	lh	a4,72(s1)
    80002c04:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c08:	04a49703          	lh	a4,74(s1)
    80002c0c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c10:	44f8                	lw	a4,76(s1)
    80002c12:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c14:	03400613          	li	a2,52
    80002c18:	05048593          	addi	a1,s1,80
    80002c1c:	0531                	addi	a0,a0,12
    80002c1e:	ffffd097          	auipc	ra,0xffffd
    80002c22:	63c080e7          	jalr	1596(ra) # 8000025a <memmove>
  log_write(bp);
    80002c26:	854a                	mv	a0,s2
    80002c28:	00001097          	auipc	ra,0x1
    80002c2c:	c06080e7          	jalr	-1018(ra) # 8000382e <log_write>
  brelse(bp);
    80002c30:	854a                	mv	a0,s2
    80002c32:	00000097          	auipc	ra,0x0
    80002c36:	980080e7          	jalr	-1664(ra) # 800025b2 <brelse>
}
    80002c3a:	60e2                	ld	ra,24(sp)
    80002c3c:	6442                	ld	s0,16(sp)
    80002c3e:	64a2                	ld	s1,8(sp)
    80002c40:	6902                	ld	s2,0(sp)
    80002c42:	6105                	addi	sp,sp,32
    80002c44:	8082                	ret

0000000080002c46 <idup>:
{
    80002c46:	1101                	addi	sp,sp,-32
    80002c48:	ec06                	sd	ra,24(sp)
    80002c4a:	e822                	sd	s0,16(sp)
    80002c4c:	e426                	sd	s1,8(sp)
    80002c4e:	1000                	addi	s0,sp,32
    80002c50:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c52:	00235517          	auipc	a0,0x235
    80002c56:	93e50513          	addi	a0,a0,-1730 # 80237590 <itable>
    80002c5a:	00003097          	auipc	ra,0x3
    80002c5e:	628080e7          	jalr	1576(ra) # 80006282 <acquire>
  ip->ref++;
    80002c62:	449c                	lw	a5,8(s1)
    80002c64:	2785                	addiw	a5,a5,1
    80002c66:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c68:	00235517          	auipc	a0,0x235
    80002c6c:	92850513          	addi	a0,a0,-1752 # 80237590 <itable>
    80002c70:	00003097          	auipc	ra,0x3
    80002c74:	6c6080e7          	jalr	1734(ra) # 80006336 <release>
}
    80002c78:	8526                	mv	a0,s1
    80002c7a:	60e2                	ld	ra,24(sp)
    80002c7c:	6442                	ld	s0,16(sp)
    80002c7e:	64a2                	ld	s1,8(sp)
    80002c80:	6105                	addi	sp,sp,32
    80002c82:	8082                	ret

0000000080002c84 <ilock>:
{
    80002c84:	1101                	addi	sp,sp,-32
    80002c86:	ec06                	sd	ra,24(sp)
    80002c88:	e822                	sd	s0,16(sp)
    80002c8a:	e426                	sd	s1,8(sp)
    80002c8c:	e04a                	sd	s2,0(sp)
    80002c8e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c90:	c115                	beqz	a0,80002cb4 <ilock+0x30>
    80002c92:	84aa                	mv	s1,a0
    80002c94:	451c                	lw	a5,8(a0)
    80002c96:	00f05f63          	blez	a5,80002cb4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c9a:	0541                	addi	a0,a0,16
    80002c9c:	00001097          	auipc	ra,0x1
    80002ca0:	cb2080e7          	jalr	-846(ra) # 8000394e <acquiresleep>
  if(ip->valid == 0){
    80002ca4:	40bc                	lw	a5,64(s1)
    80002ca6:	cf99                	beqz	a5,80002cc4 <ilock+0x40>
}
    80002ca8:	60e2                	ld	ra,24(sp)
    80002caa:	6442                	ld	s0,16(sp)
    80002cac:	64a2                	ld	s1,8(sp)
    80002cae:	6902                	ld	s2,0(sp)
    80002cb0:	6105                	addi	sp,sp,32
    80002cb2:	8082                	ret
    panic("ilock");
    80002cb4:	00006517          	auipc	a0,0x6
    80002cb8:	89450513          	addi	a0,a0,-1900 # 80008548 <syscalls+0x180>
    80002cbc:	00003097          	auipc	ra,0x3
    80002cc0:	07c080e7          	jalr	124(ra) # 80005d38 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cc4:	40dc                	lw	a5,4(s1)
    80002cc6:	0047d79b          	srliw	a5,a5,0x4
    80002cca:	00235597          	auipc	a1,0x235
    80002cce:	8be5a583          	lw	a1,-1858(a1) # 80237588 <sb+0x18>
    80002cd2:	9dbd                	addw	a1,a1,a5
    80002cd4:	4088                	lw	a0,0(s1)
    80002cd6:	fffff097          	auipc	ra,0xfffff
    80002cda:	7ac080e7          	jalr	1964(ra) # 80002482 <bread>
    80002cde:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ce0:	05850593          	addi	a1,a0,88
    80002ce4:	40dc                	lw	a5,4(s1)
    80002ce6:	8bbd                	andi	a5,a5,15
    80002ce8:	079a                	slli	a5,a5,0x6
    80002cea:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cec:	00059783          	lh	a5,0(a1)
    80002cf0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cf4:	00259783          	lh	a5,2(a1)
    80002cf8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cfc:	00459783          	lh	a5,4(a1)
    80002d00:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d04:	00659783          	lh	a5,6(a1)
    80002d08:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d0c:	459c                	lw	a5,8(a1)
    80002d0e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d10:	03400613          	li	a2,52
    80002d14:	05b1                	addi	a1,a1,12
    80002d16:	05048513          	addi	a0,s1,80
    80002d1a:	ffffd097          	auipc	ra,0xffffd
    80002d1e:	540080e7          	jalr	1344(ra) # 8000025a <memmove>
    brelse(bp);
    80002d22:	854a                	mv	a0,s2
    80002d24:	00000097          	auipc	ra,0x0
    80002d28:	88e080e7          	jalr	-1906(ra) # 800025b2 <brelse>
    ip->valid = 1;
    80002d2c:	4785                	li	a5,1
    80002d2e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d30:	04449783          	lh	a5,68(s1)
    80002d34:	fbb5                	bnez	a5,80002ca8 <ilock+0x24>
      panic("ilock: no type");
    80002d36:	00006517          	auipc	a0,0x6
    80002d3a:	81a50513          	addi	a0,a0,-2022 # 80008550 <syscalls+0x188>
    80002d3e:	00003097          	auipc	ra,0x3
    80002d42:	ffa080e7          	jalr	-6(ra) # 80005d38 <panic>

0000000080002d46 <iunlock>:
{
    80002d46:	1101                	addi	sp,sp,-32
    80002d48:	ec06                	sd	ra,24(sp)
    80002d4a:	e822                	sd	s0,16(sp)
    80002d4c:	e426                	sd	s1,8(sp)
    80002d4e:	e04a                	sd	s2,0(sp)
    80002d50:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d52:	c905                	beqz	a0,80002d82 <iunlock+0x3c>
    80002d54:	84aa                	mv	s1,a0
    80002d56:	01050913          	addi	s2,a0,16
    80002d5a:	854a                	mv	a0,s2
    80002d5c:	00001097          	auipc	ra,0x1
    80002d60:	c8c080e7          	jalr	-884(ra) # 800039e8 <holdingsleep>
    80002d64:	cd19                	beqz	a0,80002d82 <iunlock+0x3c>
    80002d66:	449c                	lw	a5,8(s1)
    80002d68:	00f05d63          	blez	a5,80002d82 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d6c:	854a                	mv	a0,s2
    80002d6e:	00001097          	auipc	ra,0x1
    80002d72:	c36080e7          	jalr	-970(ra) # 800039a4 <releasesleep>
}
    80002d76:	60e2                	ld	ra,24(sp)
    80002d78:	6442                	ld	s0,16(sp)
    80002d7a:	64a2                	ld	s1,8(sp)
    80002d7c:	6902                	ld	s2,0(sp)
    80002d7e:	6105                	addi	sp,sp,32
    80002d80:	8082                	ret
    panic("iunlock");
    80002d82:	00005517          	auipc	a0,0x5
    80002d86:	7de50513          	addi	a0,a0,2014 # 80008560 <syscalls+0x198>
    80002d8a:	00003097          	auipc	ra,0x3
    80002d8e:	fae080e7          	jalr	-82(ra) # 80005d38 <panic>

0000000080002d92 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d92:	7179                	addi	sp,sp,-48
    80002d94:	f406                	sd	ra,40(sp)
    80002d96:	f022                	sd	s0,32(sp)
    80002d98:	ec26                	sd	s1,24(sp)
    80002d9a:	e84a                	sd	s2,16(sp)
    80002d9c:	e44e                	sd	s3,8(sp)
    80002d9e:	e052                	sd	s4,0(sp)
    80002da0:	1800                	addi	s0,sp,48
    80002da2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002da4:	05050493          	addi	s1,a0,80
    80002da8:	08050913          	addi	s2,a0,128
    80002dac:	a021                	j	80002db4 <itrunc+0x22>
    80002dae:	0491                	addi	s1,s1,4
    80002db0:	01248d63          	beq	s1,s2,80002dca <itrunc+0x38>
    if(ip->addrs[i]){
    80002db4:	408c                	lw	a1,0(s1)
    80002db6:	dde5                	beqz	a1,80002dae <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002db8:	0009a503          	lw	a0,0(s3)
    80002dbc:	00000097          	auipc	ra,0x0
    80002dc0:	90c080e7          	jalr	-1780(ra) # 800026c8 <bfree>
      ip->addrs[i] = 0;
    80002dc4:	0004a023          	sw	zero,0(s1)
    80002dc8:	b7dd                	j	80002dae <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dca:	0809a583          	lw	a1,128(s3)
    80002dce:	e185                	bnez	a1,80002dee <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dd0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dd4:	854e                	mv	a0,s3
    80002dd6:	00000097          	auipc	ra,0x0
    80002dda:	de4080e7          	jalr	-540(ra) # 80002bba <iupdate>
}
    80002dde:	70a2                	ld	ra,40(sp)
    80002de0:	7402                	ld	s0,32(sp)
    80002de2:	64e2                	ld	s1,24(sp)
    80002de4:	6942                	ld	s2,16(sp)
    80002de6:	69a2                	ld	s3,8(sp)
    80002de8:	6a02                	ld	s4,0(sp)
    80002dea:	6145                	addi	sp,sp,48
    80002dec:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dee:	0009a503          	lw	a0,0(s3)
    80002df2:	fffff097          	auipc	ra,0xfffff
    80002df6:	690080e7          	jalr	1680(ra) # 80002482 <bread>
    80002dfa:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dfc:	05850493          	addi	s1,a0,88
    80002e00:	45850913          	addi	s2,a0,1112
    80002e04:	a811                	j	80002e18 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e06:	0009a503          	lw	a0,0(s3)
    80002e0a:	00000097          	auipc	ra,0x0
    80002e0e:	8be080e7          	jalr	-1858(ra) # 800026c8 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e12:	0491                	addi	s1,s1,4
    80002e14:	01248563          	beq	s1,s2,80002e1e <itrunc+0x8c>
      if(a[j])
    80002e18:	408c                	lw	a1,0(s1)
    80002e1a:	dde5                	beqz	a1,80002e12 <itrunc+0x80>
    80002e1c:	b7ed                	j	80002e06 <itrunc+0x74>
    brelse(bp);
    80002e1e:	8552                	mv	a0,s4
    80002e20:	fffff097          	auipc	ra,0xfffff
    80002e24:	792080e7          	jalr	1938(ra) # 800025b2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e28:	0809a583          	lw	a1,128(s3)
    80002e2c:	0009a503          	lw	a0,0(s3)
    80002e30:	00000097          	auipc	ra,0x0
    80002e34:	898080e7          	jalr	-1896(ra) # 800026c8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e38:	0809a023          	sw	zero,128(s3)
    80002e3c:	bf51                	j	80002dd0 <itrunc+0x3e>

0000000080002e3e <iput>:
{
    80002e3e:	1101                	addi	sp,sp,-32
    80002e40:	ec06                	sd	ra,24(sp)
    80002e42:	e822                	sd	s0,16(sp)
    80002e44:	e426                	sd	s1,8(sp)
    80002e46:	e04a                	sd	s2,0(sp)
    80002e48:	1000                	addi	s0,sp,32
    80002e4a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e4c:	00234517          	auipc	a0,0x234
    80002e50:	74450513          	addi	a0,a0,1860 # 80237590 <itable>
    80002e54:	00003097          	auipc	ra,0x3
    80002e58:	42e080e7          	jalr	1070(ra) # 80006282 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e5c:	4498                	lw	a4,8(s1)
    80002e5e:	4785                	li	a5,1
    80002e60:	02f70363          	beq	a4,a5,80002e86 <iput+0x48>
  ip->ref--;
    80002e64:	449c                	lw	a5,8(s1)
    80002e66:	37fd                	addiw	a5,a5,-1
    80002e68:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e6a:	00234517          	auipc	a0,0x234
    80002e6e:	72650513          	addi	a0,a0,1830 # 80237590 <itable>
    80002e72:	00003097          	auipc	ra,0x3
    80002e76:	4c4080e7          	jalr	1220(ra) # 80006336 <release>
}
    80002e7a:	60e2                	ld	ra,24(sp)
    80002e7c:	6442                	ld	s0,16(sp)
    80002e7e:	64a2                	ld	s1,8(sp)
    80002e80:	6902                	ld	s2,0(sp)
    80002e82:	6105                	addi	sp,sp,32
    80002e84:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e86:	40bc                	lw	a5,64(s1)
    80002e88:	dff1                	beqz	a5,80002e64 <iput+0x26>
    80002e8a:	04a49783          	lh	a5,74(s1)
    80002e8e:	fbf9                	bnez	a5,80002e64 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e90:	01048913          	addi	s2,s1,16
    80002e94:	854a                	mv	a0,s2
    80002e96:	00001097          	auipc	ra,0x1
    80002e9a:	ab8080e7          	jalr	-1352(ra) # 8000394e <acquiresleep>
    release(&itable.lock);
    80002e9e:	00234517          	auipc	a0,0x234
    80002ea2:	6f250513          	addi	a0,a0,1778 # 80237590 <itable>
    80002ea6:	00003097          	auipc	ra,0x3
    80002eaa:	490080e7          	jalr	1168(ra) # 80006336 <release>
    itrunc(ip);
    80002eae:	8526                	mv	a0,s1
    80002eb0:	00000097          	auipc	ra,0x0
    80002eb4:	ee2080e7          	jalr	-286(ra) # 80002d92 <itrunc>
    ip->type = 0;
    80002eb8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ebc:	8526                	mv	a0,s1
    80002ebe:	00000097          	auipc	ra,0x0
    80002ec2:	cfc080e7          	jalr	-772(ra) # 80002bba <iupdate>
    ip->valid = 0;
    80002ec6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002eca:	854a                	mv	a0,s2
    80002ecc:	00001097          	auipc	ra,0x1
    80002ed0:	ad8080e7          	jalr	-1320(ra) # 800039a4 <releasesleep>
    acquire(&itable.lock);
    80002ed4:	00234517          	auipc	a0,0x234
    80002ed8:	6bc50513          	addi	a0,a0,1724 # 80237590 <itable>
    80002edc:	00003097          	auipc	ra,0x3
    80002ee0:	3a6080e7          	jalr	934(ra) # 80006282 <acquire>
    80002ee4:	b741                	j	80002e64 <iput+0x26>

0000000080002ee6 <iunlockput>:
{
    80002ee6:	1101                	addi	sp,sp,-32
    80002ee8:	ec06                	sd	ra,24(sp)
    80002eea:	e822                	sd	s0,16(sp)
    80002eec:	e426                	sd	s1,8(sp)
    80002eee:	1000                	addi	s0,sp,32
    80002ef0:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ef2:	00000097          	auipc	ra,0x0
    80002ef6:	e54080e7          	jalr	-428(ra) # 80002d46 <iunlock>
  iput(ip);
    80002efa:	8526                	mv	a0,s1
    80002efc:	00000097          	auipc	ra,0x0
    80002f00:	f42080e7          	jalr	-190(ra) # 80002e3e <iput>
}
    80002f04:	60e2                	ld	ra,24(sp)
    80002f06:	6442                	ld	s0,16(sp)
    80002f08:	64a2                	ld	s1,8(sp)
    80002f0a:	6105                	addi	sp,sp,32
    80002f0c:	8082                	ret

0000000080002f0e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f0e:	1141                	addi	sp,sp,-16
    80002f10:	e422                	sd	s0,8(sp)
    80002f12:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f14:	411c                	lw	a5,0(a0)
    80002f16:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f18:	415c                	lw	a5,4(a0)
    80002f1a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f1c:	04451783          	lh	a5,68(a0)
    80002f20:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f24:	04a51783          	lh	a5,74(a0)
    80002f28:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f2c:	04c56783          	lwu	a5,76(a0)
    80002f30:	e99c                	sd	a5,16(a1)
}
    80002f32:	6422                	ld	s0,8(sp)
    80002f34:	0141                	addi	sp,sp,16
    80002f36:	8082                	ret

0000000080002f38 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f38:	457c                	lw	a5,76(a0)
    80002f3a:	0ed7e963          	bltu	a5,a3,8000302c <readi+0xf4>
{
    80002f3e:	7159                	addi	sp,sp,-112
    80002f40:	f486                	sd	ra,104(sp)
    80002f42:	f0a2                	sd	s0,96(sp)
    80002f44:	eca6                	sd	s1,88(sp)
    80002f46:	e8ca                	sd	s2,80(sp)
    80002f48:	e4ce                	sd	s3,72(sp)
    80002f4a:	e0d2                	sd	s4,64(sp)
    80002f4c:	fc56                	sd	s5,56(sp)
    80002f4e:	f85a                	sd	s6,48(sp)
    80002f50:	f45e                	sd	s7,40(sp)
    80002f52:	f062                	sd	s8,32(sp)
    80002f54:	ec66                	sd	s9,24(sp)
    80002f56:	e86a                	sd	s10,16(sp)
    80002f58:	e46e                	sd	s11,8(sp)
    80002f5a:	1880                	addi	s0,sp,112
    80002f5c:	8baa                	mv	s7,a0
    80002f5e:	8c2e                	mv	s8,a1
    80002f60:	8ab2                	mv	s5,a2
    80002f62:	84b6                	mv	s1,a3
    80002f64:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f66:	9f35                	addw	a4,a4,a3
    return 0;
    80002f68:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f6a:	0ad76063          	bltu	a4,a3,8000300a <readi+0xd2>
  if(off + n > ip->size)
    80002f6e:	00e7f463          	bgeu	a5,a4,80002f76 <readi+0x3e>
    n = ip->size - off;
    80002f72:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f76:	0a0b0963          	beqz	s6,80003028 <readi+0xf0>
    80002f7a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f7c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f80:	5cfd                	li	s9,-1
    80002f82:	a82d                	j	80002fbc <readi+0x84>
    80002f84:	020a1d93          	slli	s11,s4,0x20
    80002f88:	020ddd93          	srli	s11,s11,0x20
    80002f8c:	05890613          	addi	a2,s2,88
    80002f90:	86ee                	mv	a3,s11
    80002f92:	963a                	add	a2,a2,a4
    80002f94:	85d6                	mv	a1,s5
    80002f96:	8562                	mv	a0,s8
    80002f98:	fffff097          	auipc	ra,0xfffff
    80002f9c:	a6e080e7          	jalr	-1426(ra) # 80001a06 <either_copyout>
    80002fa0:	05950d63          	beq	a0,s9,80002ffa <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fa4:	854a                	mv	a0,s2
    80002fa6:	fffff097          	auipc	ra,0xfffff
    80002faa:	60c080e7          	jalr	1548(ra) # 800025b2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fae:	013a09bb          	addw	s3,s4,s3
    80002fb2:	009a04bb          	addw	s1,s4,s1
    80002fb6:	9aee                	add	s5,s5,s11
    80002fb8:	0569f763          	bgeu	s3,s6,80003006 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fbc:	000ba903          	lw	s2,0(s7)
    80002fc0:	00a4d59b          	srliw	a1,s1,0xa
    80002fc4:	855e                	mv	a0,s7
    80002fc6:	00000097          	auipc	ra,0x0
    80002fca:	8b0080e7          	jalr	-1872(ra) # 80002876 <bmap>
    80002fce:	0005059b          	sext.w	a1,a0
    80002fd2:	854a                	mv	a0,s2
    80002fd4:	fffff097          	auipc	ra,0xfffff
    80002fd8:	4ae080e7          	jalr	1198(ra) # 80002482 <bread>
    80002fdc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fde:	3ff4f713          	andi	a4,s1,1023
    80002fe2:	40ed07bb          	subw	a5,s10,a4
    80002fe6:	413b06bb          	subw	a3,s6,s3
    80002fea:	8a3e                	mv	s4,a5
    80002fec:	2781                	sext.w	a5,a5
    80002fee:	0006861b          	sext.w	a2,a3
    80002ff2:	f8f679e3          	bgeu	a2,a5,80002f84 <readi+0x4c>
    80002ff6:	8a36                	mv	s4,a3
    80002ff8:	b771                	j	80002f84 <readi+0x4c>
      brelse(bp);
    80002ffa:	854a                	mv	a0,s2
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	5b6080e7          	jalr	1462(ra) # 800025b2 <brelse>
      tot = -1;
    80003004:	59fd                	li	s3,-1
  }
  return tot;
    80003006:	0009851b          	sext.w	a0,s3
}
    8000300a:	70a6                	ld	ra,104(sp)
    8000300c:	7406                	ld	s0,96(sp)
    8000300e:	64e6                	ld	s1,88(sp)
    80003010:	6946                	ld	s2,80(sp)
    80003012:	69a6                	ld	s3,72(sp)
    80003014:	6a06                	ld	s4,64(sp)
    80003016:	7ae2                	ld	s5,56(sp)
    80003018:	7b42                	ld	s6,48(sp)
    8000301a:	7ba2                	ld	s7,40(sp)
    8000301c:	7c02                	ld	s8,32(sp)
    8000301e:	6ce2                	ld	s9,24(sp)
    80003020:	6d42                	ld	s10,16(sp)
    80003022:	6da2                	ld	s11,8(sp)
    80003024:	6165                	addi	sp,sp,112
    80003026:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003028:	89da                	mv	s3,s6
    8000302a:	bff1                	j	80003006 <readi+0xce>
    return 0;
    8000302c:	4501                	li	a0,0
}
    8000302e:	8082                	ret

0000000080003030 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003030:	457c                	lw	a5,76(a0)
    80003032:	10d7e863          	bltu	a5,a3,80003142 <writei+0x112>
{
    80003036:	7159                	addi	sp,sp,-112
    80003038:	f486                	sd	ra,104(sp)
    8000303a:	f0a2                	sd	s0,96(sp)
    8000303c:	eca6                	sd	s1,88(sp)
    8000303e:	e8ca                	sd	s2,80(sp)
    80003040:	e4ce                	sd	s3,72(sp)
    80003042:	e0d2                	sd	s4,64(sp)
    80003044:	fc56                	sd	s5,56(sp)
    80003046:	f85a                	sd	s6,48(sp)
    80003048:	f45e                	sd	s7,40(sp)
    8000304a:	f062                	sd	s8,32(sp)
    8000304c:	ec66                	sd	s9,24(sp)
    8000304e:	e86a                	sd	s10,16(sp)
    80003050:	e46e                	sd	s11,8(sp)
    80003052:	1880                	addi	s0,sp,112
    80003054:	8b2a                	mv	s6,a0
    80003056:	8c2e                	mv	s8,a1
    80003058:	8ab2                	mv	s5,a2
    8000305a:	8936                	mv	s2,a3
    8000305c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000305e:	00e687bb          	addw	a5,a3,a4
    80003062:	0ed7e263          	bltu	a5,a3,80003146 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003066:	00043737          	lui	a4,0x43
    8000306a:	0ef76063          	bltu	a4,a5,8000314a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000306e:	0c0b8863          	beqz	s7,8000313e <writei+0x10e>
    80003072:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003074:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003078:	5cfd                	li	s9,-1
    8000307a:	a091                	j	800030be <writei+0x8e>
    8000307c:	02099d93          	slli	s11,s3,0x20
    80003080:	020ddd93          	srli	s11,s11,0x20
    80003084:	05848513          	addi	a0,s1,88
    80003088:	86ee                	mv	a3,s11
    8000308a:	8656                	mv	a2,s5
    8000308c:	85e2                	mv	a1,s8
    8000308e:	953a                	add	a0,a0,a4
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	9cc080e7          	jalr	-1588(ra) # 80001a5c <either_copyin>
    80003098:	07950263          	beq	a0,s9,800030fc <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000309c:	8526                	mv	a0,s1
    8000309e:	00000097          	auipc	ra,0x0
    800030a2:	790080e7          	jalr	1936(ra) # 8000382e <log_write>
    brelse(bp);
    800030a6:	8526                	mv	a0,s1
    800030a8:	fffff097          	auipc	ra,0xfffff
    800030ac:	50a080e7          	jalr	1290(ra) # 800025b2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b0:	01498a3b          	addw	s4,s3,s4
    800030b4:	0129893b          	addw	s2,s3,s2
    800030b8:	9aee                	add	s5,s5,s11
    800030ba:	057a7663          	bgeu	s4,s7,80003106 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030be:	000b2483          	lw	s1,0(s6)
    800030c2:	00a9559b          	srliw	a1,s2,0xa
    800030c6:	855a                	mv	a0,s6
    800030c8:	fffff097          	auipc	ra,0xfffff
    800030cc:	7ae080e7          	jalr	1966(ra) # 80002876 <bmap>
    800030d0:	0005059b          	sext.w	a1,a0
    800030d4:	8526                	mv	a0,s1
    800030d6:	fffff097          	auipc	ra,0xfffff
    800030da:	3ac080e7          	jalr	940(ra) # 80002482 <bread>
    800030de:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030e0:	3ff97713          	andi	a4,s2,1023
    800030e4:	40ed07bb          	subw	a5,s10,a4
    800030e8:	414b86bb          	subw	a3,s7,s4
    800030ec:	89be                	mv	s3,a5
    800030ee:	2781                	sext.w	a5,a5
    800030f0:	0006861b          	sext.w	a2,a3
    800030f4:	f8f674e3          	bgeu	a2,a5,8000307c <writei+0x4c>
    800030f8:	89b6                	mv	s3,a3
    800030fa:	b749                	j	8000307c <writei+0x4c>
      brelse(bp);
    800030fc:	8526                	mv	a0,s1
    800030fe:	fffff097          	auipc	ra,0xfffff
    80003102:	4b4080e7          	jalr	1204(ra) # 800025b2 <brelse>
  }

  if(off > ip->size)
    80003106:	04cb2783          	lw	a5,76(s6)
    8000310a:	0127f463          	bgeu	a5,s2,80003112 <writei+0xe2>
    ip->size = off;
    8000310e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003112:	855a                	mv	a0,s6
    80003114:	00000097          	auipc	ra,0x0
    80003118:	aa6080e7          	jalr	-1370(ra) # 80002bba <iupdate>

  return tot;
    8000311c:	000a051b          	sext.w	a0,s4
}
    80003120:	70a6                	ld	ra,104(sp)
    80003122:	7406                	ld	s0,96(sp)
    80003124:	64e6                	ld	s1,88(sp)
    80003126:	6946                	ld	s2,80(sp)
    80003128:	69a6                	ld	s3,72(sp)
    8000312a:	6a06                	ld	s4,64(sp)
    8000312c:	7ae2                	ld	s5,56(sp)
    8000312e:	7b42                	ld	s6,48(sp)
    80003130:	7ba2                	ld	s7,40(sp)
    80003132:	7c02                	ld	s8,32(sp)
    80003134:	6ce2                	ld	s9,24(sp)
    80003136:	6d42                	ld	s10,16(sp)
    80003138:	6da2                	ld	s11,8(sp)
    8000313a:	6165                	addi	sp,sp,112
    8000313c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000313e:	8a5e                	mv	s4,s7
    80003140:	bfc9                	j	80003112 <writei+0xe2>
    return -1;
    80003142:	557d                	li	a0,-1
}
    80003144:	8082                	ret
    return -1;
    80003146:	557d                	li	a0,-1
    80003148:	bfe1                	j	80003120 <writei+0xf0>
    return -1;
    8000314a:	557d                	li	a0,-1
    8000314c:	bfd1                	j	80003120 <writei+0xf0>

000000008000314e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000314e:	1141                	addi	sp,sp,-16
    80003150:	e406                	sd	ra,8(sp)
    80003152:	e022                	sd	s0,0(sp)
    80003154:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003156:	4639                	li	a2,14
    80003158:	ffffd097          	auipc	ra,0xffffd
    8000315c:	17a080e7          	jalr	378(ra) # 800002d2 <strncmp>
}
    80003160:	60a2                	ld	ra,8(sp)
    80003162:	6402                	ld	s0,0(sp)
    80003164:	0141                	addi	sp,sp,16
    80003166:	8082                	ret

0000000080003168 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003168:	7139                	addi	sp,sp,-64
    8000316a:	fc06                	sd	ra,56(sp)
    8000316c:	f822                	sd	s0,48(sp)
    8000316e:	f426                	sd	s1,40(sp)
    80003170:	f04a                	sd	s2,32(sp)
    80003172:	ec4e                	sd	s3,24(sp)
    80003174:	e852                	sd	s4,16(sp)
    80003176:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003178:	04451703          	lh	a4,68(a0)
    8000317c:	4785                	li	a5,1
    8000317e:	00f71a63          	bne	a4,a5,80003192 <dirlookup+0x2a>
    80003182:	892a                	mv	s2,a0
    80003184:	89ae                	mv	s3,a1
    80003186:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003188:	457c                	lw	a5,76(a0)
    8000318a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000318c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000318e:	e79d                	bnez	a5,800031bc <dirlookup+0x54>
    80003190:	a8a5                	j	80003208 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003192:	00005517          	auipc	a0,0x5
    80003196:	3d650513          	addi	a0,a0,982 # 80008568 <syscalls+0x1a0>
    8000319a:	00003097          	auipc	ra,0x3
    8000319e:	b9e080e7          	jalr	-1122(ra) # 80005d38 <panic>
      panic("dirlookup read");
    800031a2:	00005517          	auipc	a0,0x5
    800031a6:	3de50513          	addi	a0,a0,990 # 80008580 <syscalls+0x1b8>
    800031aa:	00003097          	auipc	ra,0x3
    800031ae:	b8e080e7          	jalr	-1138(ra) # 80005d38 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031b2:	24c1                	addiw	s1,s1,16
    800031b4:	04c92783          	lw	a5,76(s2)
    800031b8:	04f4f763          	bgeu	s1,a5,80003206 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031bc:	4741                	li	a4,16
    800031be:	86a6                	mv	a3,s1
    800031c0:	fc040613          	addi	a2,s0,-64
    800031c4:	4581                	li	a1,0
    800031c6:	854a                	mv	a0,s2
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	d70080e7          	jalr	-656(ra) # 80002f38 <readi>
    800031d0:	47c1                	li	a5,16
    800031d2:	fcf518e3          	bne	a0,a5,800031a2 <dirlookup+0x3a>
    if(de.inum == 0)
    800031d6:	fc045783          	lhu	a5,-64(s0)
    800031da:	dfe1                	beqz	a5,800031b2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031dc:	fc240593          	addi	a1,s0,-62
    800031e0:	854e                	mv	a0,s3
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	f6c080e7          	jalr	-148(ra) # 8000314e <namecmp>
    800031ea:	f561                	bnez	a0,800031b2 <dirlookup+0x4a>
      if(poff)
    800031ec:	000a0463          	beqz	s4,800031f4 <dirlookup+0x8c>
        *poff = off;
    800031f0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031f4:	fc045583          	lhu	a1,-64(s0)
    800031f8:	00092503          	lw	a0,0(s2)
    800031fc:	fffff097          	auipc	ra,0xfffff
    80003200:	754080e7          	jalr	1876(ra) # 80002950 <iget>
    80003204:	a011                	j	80003208 <dirlookup+0xa0>
  return 0;
    80003206:	4501                	li	a0,0
}
    80003208:	70e2                	ld	ra,56(sp)
    8000320a:	7442                	ld	s0,48(sp)
    8000320c:	74a2                	ld	s1,40(sp)
    8000320e:	7902                	ld	s2,32(sp)
    80003210:	69e2                	ld	s3,24(sp)
    80003212:	6a42                	ld	s4,16(sp)
    80003214:	6121                	addi	sp,sp,64
    80003216:	8082                	ret

0000000080003218 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003218:	711d                	addi	sp,sp,-96
    8000321a:	ec86                	sd	ra,88(sp)
    8000321c:	e8a2                	sd	s0,80(sp)
    8000321e:	e4a6                	sd	s1,72(sp)
    80003220:	e0ca                	sd	s2,64(sp)
    80003222:	fc4e                	sd	s3,56(sp)
    80003224:	f852                	sd	s4,48(sp)
    80003226:	f456                	sd	s5,40(sp)
    80003228:	f05a                	sd	s6,32(sp)
    8000322a:	ec5e                	sd	s7,24(sp)
    8000322c:	e862                	sd	s8,16(sp)
    8000322e:	e466                	sd	s9,8(sp)
    80003230:	1080                	addi	s0,sp,96
    80003232:	84aa                	mv	s1,a0
    80003234:	8b2e                	mv	s6,a1
    80003236:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003238:	00054703          	lbu	a4,0(a0)
    8000323c:	02f00793          	li	a5,47
    80003240:	02f70363          	beq	a4,a5,80003266 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003244:	ffffe097          	auipc	ra,0xffffe
    80003248:	d62080e7          	jalr	-670(ra) # 80000fa6 <myproc>
    8000324c:	15053503          	ld	a0,336(a0)
    80003250:	00000097          	auipc	ra,0x0
    80003254:	9f6080e7          	jalr	-1546(ra) # 80002c46 <idup>
    80003258:	89aa                	mv	s3,a0
  while(*path == '/')
    8000325a:	02f00913          	li	s2,47
  len = path - s;
    8000325e:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003260:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003262:	4c05                	li	s8,1
    80003264:	a865                	j	8000331c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003266:	4585                	li	a1,1
    80003268:	4505                	li	a0,1
    8000326a:	fffff097          	auipc	ra,0xfffff
    8000326e:	6e6080e7          	jalr	1766(ra) # 80002950 <iget>
    80003272:	89aa                	mv	s3,a0
    80003274:	b7dd                	j	8000325a <namex+0x42>
      iunlockput(ip);
    80003276:	854e                	mv	a0,s3
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	c6e080e7          	jalr	-914(ra) # 80002ee6 <iunlockput>
      return 0;
    80003280:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003282:	854e                	mv	a0,s3
    80003284:	60e6                	ld	ra,88(sp)
    80003286:	6446                	ld	s0,80(sp)
    80003288:	64a6                	ld	s1,72(sp)
    8000328a:	6906                	ld	s2,64(sp)
    8000328c:	79e2                	ld	s3,56(sp)
    8000328e:	7a42                	ld	s4,48(sp)
    80003290:	7aa2                	ld	s5,40(sp)
    80003292:	7b02                	ld	s6,32(sp)
    80003294:	6be2                	ld	s7,24(sp)
    80003296:	6c42                	ld	s8,16(sp)
    80003298:	6ca2                	ld	s9,8(sp)
    8000329a:	6125                	addi	sp,sp,96
    8000329c:	8082                	ret
      iunlock(ip);
    8000329e:	854e                	mv	a0,s3
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	aa6080e7          	jalr	-1370(ra) # 80002d46 <iunlock>
      return ip;
    800032a8:	bfe9                	j	80003282 <namex+0x6a>
      iunlockput(ip);
    800032aa:	854e                	mv	a0,s3
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	c3a080e7          	jalr	-966(ra) # 80002ee6 <iunlockput>
      return 0;
    800032b4:	89d2                	mv	s3,s4
    800032b6:	b7f1                	j	80003282 <namex+0x6a>
  len = path - s;
    800032b8:	40b48633          	sub	a2,s1,a1
    800032bc:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032c0:	094cd463          	bge	s9,s4,80003348 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032c4:	4639                	li	a2,14
    800032c6:	8556                	mv	a0,s5
    800032c8:	ffffd097          	auipc	ra,0xffffd
    800032cc:	f92080e7          	jalr	-110(ra) # 8000025a <memmove>
  while(*path == '/')
    800032d0:	0004c783          	lbu	a5,0(s1)
    800032d4:	01279763          	bne	a5,s2,800032e2 <namex+0xca>
    path++;
    800032d8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032da:	0004c783          	lbu	a5,0(s1)
    800032de:	ff278de3          	beq	a5,s2,800032d8 <namex+0xc0>
    ilock(ip);
    800032e2:	854e                	mv	a0,s3
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	9a0080e7          	jalr	-1632(ra) # 80002c84 <ilock>
    if(ip->type != T_DIR){
    800032ec:	04499783          	lh	a5,68(s3)
    800032f0:	f98793e3          	bne	a5,s8,80003276 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032f4:	000b0563          	beqz	s6,800032fe <namex+0xe6>
    800032f8:	0004c783          	lbu	a5,0(s1)
    800032fc:	d3cd                	beqz	a5,8000329e <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032fe:	865e                	mv	a2,s7
    80003300:	85d6                	mv	a1,s5
    80003302:	854e                	mv	a0,s3
    80003304:	00000097          	auipc	ra,0x0
    80003308:	e64080e7          	jalr	-412(ra) # 80003168 <dirlookup>
    8000330c:	8a2a                	mv	s4,a0
    8000330e:	dd51                	beqz	a0,800032aa <namex+0x92>
    iunlockput(ip);
    80003310:	854e                	mv	a0,s3
    80003312:	00000097          	auipc	ra,0x0
    80003316:	bd4080e7          	jalr	-1068(ra) # 80002ee6 <iunlockput>
    ip = next;
    8000331a:	89d2                	mv	s3,s4
  while(*path == '/')
    8000331c:	0004c783          	lbu	a5,0(s1)
    80003320:	05279763          	bne	a5,s2,8000336e <namex+0x156>
    path++;
    80003324:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003326:	0004c783          	lbu	a5,0(s1)
    8000332a:	ff278de3          	beq	a5,s2,80003324 <namex+0x10c>
  if(*path == 0)
    8000332e:	c79d                	beqz	a5,8000335c <namex+0x144>
    path++;
    80003330:	85a6                	mv	a1,s1
  len = path - s;
    80003332:	8a5e                	mv	s4,s7
    80003334:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003336:	01278963          	beq	a5,s2,80003348 <namex+0x130>
    8000333a:	dfbd                	beqz	a5,800032b8 <namex+0xa0>
    path++;
    8000333c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000333e:	0004c783          	lbu	a5,0(s1)
    80003342:	ff279ce3          	bne	a5,s2,8000333a <namex+0x122>
    80003346:	bf8d                	j	800032b8 <namex+0xa0>
    memmove(name, s, len);
    80003348:	2601                	sext.w	a2,a2
    8000334a:	8556                	mv	a0,s5
    8000334c:	ffffd097          	auipc	ra,0xffffd
    80003350:	f0e080e7          	jalr	-242(ra) # 8000025a <memmove>
    name[len] = 0;
    80003354:	9a56                	add	s4,s4,s5
    80003356:	000a0023          	sb	zero,0(s4)
    8000335a:	bf9d                	j	800032d0 <namex+0xb8>
  if(nameiparent){
    8000335c:	f20b03e3          	beqz	s6,80003282 <namex+0x6a>
    iput(ip);
    80003360:	854e                	mv	a0,s3
    80003362:	00000097          	auipc	ra,0x0
    80003366:	adc080e7          	jalr	-1316(ra) # 80002e3e <iput>
    return 0;
    8000336a:	4981                	li	s3,0
    8000336c:	bf19                	j	80003282 <namex+0x6a>
  if(*path == 0)
    8000336e:	d7fd                	beqz	a5,8000335c <namex+0x144>
  while(*path != '/' && *path != 0)
    80003370:	0004c783          	lbu	a5,0(s1)
    80003374:	85a6                	mv	a1,s1
    80003376:	b7d1                	j	8000333a <namex+0x122>

0000000080003378 <dirlink>:
{
    80003378:	7139                	addi	sp,sp,-64
    8000337a:	fc06                	sd	ra,56(sp)
    8000337c:	f822                	sd	s0,48(sp)
    8000337e:	f426                	sd	s1,40(sp)
    80003380:	f04a                	sd	s2,32(sp)
    80003382:	ec4e                	sd	s3,24(sp)
    80003384:	e852                	sd	s4,16(sp)
    80003386:	0080                	addi	s0,sp,64
    80003388:	892a                	mv	s2,a0
    8000338a:	8a2e                	mv	s4,a1
    8000338c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000338e:	4601                	li	a2,0
    80003390:	00000097          	auipc	ra,0x0
    80003394:	dd8080e7          	jalr	-552(ra) # 80003168 <dirlookup>
    80003398:	e93d                	bnez	a0,8000340e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000339a:	04c92483          	lw	s1,76(s2)
    8000339e:	c49d                	beqz	s1,800033cc <dirlink+0x54>
    800033a0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033a2:	4741                	li	a4,16
    800033a4:	86a6                	mv	a3,s1
    800033a6:	fc040613          	addi	a2,s0,-64
    800033aa:	4581                	li	a1,0
    800033ac:	854a                	mv	a0,s2
    800033ae:	00000097          	auipc	ra,0x0
    800033b2:	b8a080e7          	jalr	-1142(ra) # 80002f38 <readi>
    800033b6:	47c1                	li	a5,16
    800033b8:	06f51163          	bne	a0,a5,8000341a <dirlink+0xa2>
    if(de.inum == 0)
    800033bc:	fc045783          	lhu	a5,-64(s0)
    800033c0:	c791                	beqz	a5,800033cc <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033c2:	24c1                	addiw	s1,s1,16
    800033c4:	04c92783          	lw	a5,76(s2)
    800033c8:	fcf4ede3          	bltu	s1,a5,800033a2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033cc:	4639                	li	a2,14
    800033ce:	85d2                	mv	a1,s4
    800033d0:	fc240513          	addi	a0,s0,-62
    800033d4:	ffffd097          	auipc	ra,0xffffd
    800033d8:	f3a080e7          	jalr	-198(ra) # 8000030e <strncpy>
  de.inum = inum;
    800033dc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033e0:	4741                	li	a4,16
    800033e2:	86a6                	mv	a3,s1
    800033e4:	fc040613          	addi	a2,s0,-64
    800033e8:	4581                	li	a1,0
    800033ea:	854a                	mv	a0,s2
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	c44080e7          	jalr	-956(ra) # 80003030 <writei>
    800033f4:	872a                	mv	a4,a0
    800033f6:	47c1                	li	a5,16
  return 0;
    800033f8:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033fa:	02f71863          	bne	a4,a5,8000342a <dirlink+0xb2>
}
    800033fe:	70e2                	ld	ra,56(sp)
    80003400:	7442                	ld	s0,48(sp)
    80003402:	74a2                	ld	s1,40(sp)
    80003404:	7902                	ld	s2,32(sp)
    80003406:	69e2                	ld	s3,24(sp)
    80003408:	6a42                	ld	s4,16(sp)
    8000340a:	6121                	addi	sp,sp,64
    8000340c:	8082                	ret
    iput(ip);
    8000340e:	00000097          	auipc	ra,0x0
    80003412:	a30080e7          	jalr	-1488(ra) # 80002e3e <iput>
    return -1;
    80003416:	557d                	li	a0,-1
    80003418:	b7dd                	j	800033fe <dirlink+0x86>
      panic("dirlink read");
    8000341a:	00005517          	auipc	a0,0x5
    8000341e:	17650513          	addi	a0,a0,374 # 80008590 <syscalls+0x1c8>
    80003422:	00003097          	auipc	ra,0x3
    80003426:	916080e7          	jalr	-1770(ra) # 80005d38 <panic>
    panic("dirlink");
    8000342a:	00005517          	auipc	a0,0x5
    8000342e:	27650513          	addi	a0,a0,630 # 800086a0 <syscalls+0x2d8>
    80003432:	00003097          	auipc	ra,0x3
    80003436:	906080e7          	jalr	-1786(ra) # 80005d38 <panic>

000000008000343a <namei>:

struct inode*
namei(char *path)
{
    8000343a:	1101                	addi	sp,sp,-32
    8000343c:	ec06                	sd	ra,24(sp)
    8000343e:	e822                	sd	s0,16(sp)
    80003440:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003442:	fe040613          	addi	a2,s0,-32
    80003446:	4581                	li	a1,0
    80003448:	00000097          	auipc	ra,0x0
    8000344c:	dd0080e7          	jalr	-560(ra) # 80003218 <namex>
}
    80003450:	60e2                	ld	ra,24(sp)
    80003452:	6442                	ld	s0,16(sp)
    80003454:	6105                	addi	sp,sp,32
    80003456:	8082                	ret

0000000080003458 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003458:	1141                	addi	sp,sp,-16
    8000345a:	e406                	sd	ra,8(sp)
    8000345c:	e022                	sd	s0,0(sp)
    8000345e:	0800                	addi	s0,sp,16
    80003460:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003462:	4585                	li	a1,1
    80003464:	00000097          	auipc	ra,0x0
    80003468:	db4080e7          	jalr	-588(ra) # 80003218 <namex>
}
    8000346c:	60a2                	ld	ra,8(sp)
    8000346e:	6402                	ld	s0,0(sp)
    80003470:	0141                	addi	sp,sp,16
    80003472:	8082                	ret

0000000080003474 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003474:	1101                	addi	sp,sp,-32
    80003476:	ec06                	sd	ra,24(sp)
    80003478:	e822                	sd	s0,16(sp)
    8000347a:	e426                	sd	s1,8(sp)
    8000347c:	e04a                	sd	s2,0(sp)
    8000347e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003480:	00236917          	auipc	s2,0x236
    80003484:	bb890913          	addi	s2,s2,-1096 # 80239038 <log>
    80003488:	01892583          	lw	a1,24(s2)
    8000348c:	02892503          	lw	a0,40(s2)
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	ff2080e7          	jalr	-14(ra) # 80002482 <bread>
    80003498:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000349a:	02c92683          	lw	a3,44(s2)
    8000349e:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034a0:	02d05763          	blez	a3,800034ce <write_head+0x5a>
    800034a4:	00236797          	auipc	a5,0x236
    800034a8:	bc478793          	addi	a5,a5,-1084 # 80239068 <log+0x30>
    800034ac:	05c50713          	addi	a4,a0,92
    800034b0:	36fd                	addiw	a3,a3,-1
    800034b2:	1682                	slli	a3,a3,0x20
    800034b4:	9281                	srli	a3,a3,0x20
    800034b6:	068a                	slli	a3,a3,0x2
    800034b8:	00236617          	auipc	a2,0x236
    800034bc:	bb460613          	addi	a2,a2,-1100 # 8023906c <log+0x34>
    800034c0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034c2:	4390                	lw	a2,0(a5)
    800034c4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034c6:	0791                	addi	a5,a5,4
    800034c8:	0711                	addi	a4,a4,4
    800034ca:	fed79ce3          	bne	a5,a3,800034c2 <write_head+0x4e>
  }
  bwrite(buf);
    800034ce:	8526                	mv	a0,s1
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	0a4080e7          	jalr	164(ra) # 80002574 <bwrite>
  brelse(buf);
    800034d8:	8526                	mv	a0,s1
    800034da:	fffff097          	auipc	ra,0xfffff
    800034de:	0d8080e7          	jalr	216(ra) # 800025b2 <brelse>
}
    800034e2:	60e2                	ld	ra,24(sp)
    800034e4:	6442                	ld	s0,16(sp)
    800034e6:	64a2                	ld	s1,8(sp)
    800034e8:	6902                	ld	s2,0(sp)
    800034ea:	6105                	addi	sp,sp,32
    800034ec:	8082                	ret

00000000800034ee <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ee:	00236797          	auipc	a5,0x236
    800034f2:	b767a783          	lw	a5,-1162(a5) # 80239064 <log+0x2c>
    800034f6:	0af05d63          	blez	a5,800035b0 <install_trans+0xc2>
{
    800034fa:	7139                	addi	sp,sp,-64
    800034fc:	fc06                	sd	ra,56(sp)
    800034fe:	f822                	sd	s0,48(sp)
    80003500:	f426                	sd	s1,40(sp)
    80003502:	f04a                	sd	s2,32(sp)
    80003504:	ec4e                	sd	s3,24(sp)
    80003506:	e852                	sd	s4,16(sp)
    80003508:	e456                	sd	s5,8(sp)
    8000350a:	e05a                	sd	s6,0(sp)
    8000350c:	0080                	addi	s0,sp,64
    8000350e:	8b2a                	mv	s6,a0
    80003510:	00236a97          	auipc	s5,0x236
    80003514:	b58a8a93          	addi	s5,s5,-1192 # 80239068 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003518:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000351a:	00236997          	auipc	s3,0x236
    8000351e:	b1e98993          	addi	s3,s3,-1250 # 80239038 <log>
    80003522:	a035                	j	8000354e <install_trans+0x60>
      bunpin(dbuf);
    80003524:	8526                	mv	a0,s1
    80003526:	fffff097          	auipc	ra,0xfffff
    8000352a:	166080e7          	jalr	358(ra) # 8000268c <bunpin>
    brelse(lbuf);
    8000352e:	854a                	mv	a0,s2
    80003530:	fffff097          	auipc	ra,0xfffff
    80003534:	082080e7          	jalr	130(ra) # 800025b2 <brelse>
    brelse(dbuf);
    80003538:	8526                	mv	a0,s1
    8000353a:	fffff097          	auipc	ra,0xfffff
    8000353e:	078080e7          	jalr	120(ra) # 800025b2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003542:	2a05                	addiw	s4,s4,1
    80003544:	0a91                	addi	s5,s5,4
    80003546:	02c9a783          	lw	a5,44(s3)
    8000354a:	04fa5963          	bge	s4,a5,8000359c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000354e:	0189a583          	lw	a1,24(s3)
    80003552:	014585bb          	addw	a1,a1,s4
    80003556:	2585                	addiw	a1,a1,1
    80003558:	0289a503          	lw	a0,40(s3)
    8000355c:	fffff097          	auipc	ra,0xfffff
    80003560:	f26080e7          	jalr	-218(ra) # 80002482 <bread>
    80003564:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003566:	000aa583          	lw	a1,0(s5)
    8000356a:	0289a503          	lw	a0,40(s3)
    8000356e:	fffff097          	auipc	ra,0xfffff
    80003572:	f14080e7          	jalr	-236(ra) # 80002482 <bread>
    80003576:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003578:	40000613          	li	a2,1024
    8000357c:	05890593          	addi	a1,s2,88
    80003580:	05850513          	addi	a0,a0,88
    80003584:	ffffd097          	auipc	ra,0xffffd
    80003588:	cd6080e7          	jalr	-810(ra) # 8000025a <memmove>
    bwrite(dbuf);  // write dst to disk
    8000358c:	8526                	mv	a0,s1
    8000358e:	fffff097          	auipc	ra,0xfffff
    80003592:	fe6080e7          	jalr	-26(ra) # 80002574 <bwrite>
    if(recovering == 0)
    80003596:	f80b1ce3          	bnez	s6,8000352e <install_trans+0x40>
    8000359a:	b769                	j	80003524 <install_trans+0x36>
}
    8000359c:	70e2                	ld	ra,56(sp)
    8000359e:	7442                	ld	s0,48(sp)
    800035a0:	74a2                	ld	s1,40(sp)
    800035a2:	7902                	ld	s2,32(sp)
    800035a4:	69e2                	ld	s3,24(sp)
    800035a6:	6a42                	ld	s4,16(sp)
    800035a8:	6aa2                	ld	s5,8(sp)
    800035aa:	6b02                	ld	s6,0(sp)
    800035ac:	6121                	addi	sp,sp,64
    800035ae:	8082                	ret
    800035b0:	8082                	ret

00000000800035b2 <initlog>:
{
    800035b2:	7179                	addi	sp,sp,-48
    800035b4:	f406                	sd	ra,40(sp)
    800035b6:	f022                	sd	s0,32(sp)
    800035b8:	ec26                	sd	s1,24(sp)
    800035ba:	e84a                	sd	s2,16(sp)
    800035bc:	e44e                	sd	s3,8(sp)
    800035be:	1800                	addi	s0,sp,48
    800035c0:	892a                	mv	s2,a0
    800035c2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035c4:	00236497          	auipc	s1,0x236
    800035c8:	a7448493          	addi	s1,s1,-1420 # 80239038 <log>
    800035cc:	00005597          	auipc	a1,0x5
    800035d0:	fd458593          	addi	a1,a1,-44 # 800085a0 <syscalls+0x1d8>
    800035d4:	8526                	mv	a0,s1
    800035d6:	00003097          	auipc	ra,0x3
    800035da:	c1c080e7          	jalr	-996(ra) # 800061f2 <initlock>
  log.start = sb->logstart;
    800035de:	0149a583          	lw	a1,20(s3)
    800035e2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035e4:	0109a783          	lw	a5,16(s3)
    800035e8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035ea:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035ee:	854a                	mv	a0,s2
    800035f0:	fffff097          	auipc	ra,0xfffff
    800035f4:	e92080e7          	jalr	-366(ra) # 80002482 <bread>
  log.lh.n = lh->n;
    800035f8:	4d3c                	lw	a5,88(a0)
    800035fa:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035fc:	02f05563          	blez	a5,80003626 <initlog+0x74>
    80003600:	05c50713          	addi	a4,a0,92
    80003604:	00236697          	auipc	a3,0x236
    80003608:	a6468693          	addi	a3,a3,-1436 # 80239068 <log+0x30>
    8000360c:	37fd                	addiw	a5,a5,-1
    8000360e:	1782                	slli	a5,a5,0x20
    80003610:	9381                	srli	a5,a5,0x20
    80003612:	078a                	slli	a5,a5,0x2
    80003614:	06050613          	addi	a2,a0,96
    80003618:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000361a:	4310                	lw	a2,0(a4)
    8000361c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000361e:	0711                	addi	a4,a4,4
    80003620:	0691                	addi	a3,a3,4
    80003622:	fef71ce3          	bne	a4,a5,8000361a <initlog+0x68>
  brelse(buf);
    80003626:	fffff097          	auipc	ra,0xfffff
    8000362a:	f8c080e7          	jalr	-116(ra) # 800025b2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000362e:	4505                	li	a0,1
    80003630:	00000097          	auipc	ra,0x0
    80003634:	ebe080e7          	jalr	-322(ra) # 800034ee <install_trans>
  log.lh.n = 0;
    80003638:	00236797          	auipc	a5,0x236
    8000363c:	a207a623          	sw	zero,-1492(a5) # 80239064 <log+0x2c>
  write_head(); // clear the log
    80003640:	00000097          	auipc	ra,0x0
    80003644:	e34080e7          	jalr	-460(ra) # 80003474 <write_head>
}
    80003648:	70a2                	ld	ra,40(sp)
    8000364a:	7402                	ld	s0,32(sp)
    8000364c:	64e2                	ld	s1,24(sp)
    8000364e:	6942                	ld	s2,16(sp)
    80003650:	69a2                	ld	s3,8(sp)
    80003652:	6145                	addi	sp,sp,48
    80003654:	8082                	ret

0000000080003656 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003656:	1101                	addi	sp,sp,-32
    80003658:	ec06                	sd	ra,24(sp)
    8000365a:	e822                	sd	s0,16(sp)
    8000365c:	e426                	sd	s1,8(sp)
    8000365e:	e04a                	sd	s2,0(sp)
    80003660:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003662:	00236517          	auipc	a0,0x236
    80003666:	9d650513          	addi	a0,a0,-1578 # 80239038 <log>
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	c18080e7          	jalr	-1000(ra) # 80006282 <acquire>
  while(1){
    if(log.committing){
    80003672:	00236497          	auipc	s1,0x236
    80003676:	9c648493          	addi	s1,s1,-1594 # 80239038 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000367a:	4979                	li	s2,30
    8000367c:	a039                	j	8000368a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000367e:	85a6                	mv	a1,s1
    80003680:	8526                	mv	a0,s1
    80003682:	ffffe097          	auipc	ra,0xffffe
    80003686:	fe0080e7          	jalr	-32(ra) # 80001662 <sleep>
    if(log.committing){
    8000368a:	50dc                	lw	a5,36(s1)
    8000368c:	fbed                	bnez	a5,8000367e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000368e:	509c                	lw	a5,32(s1)
    80003690:	0017871b          	addiw	a4,a5,1
    80003694:	0007069b          	sext.w	a3,a4
    80003698:	0027179b          	slliw	a5,a4,0x2
    8000369c:	9fb9                	addw	a5,a5,a4
    8000369e:	0017979b          	slliw	a5,a5,0x1
    800036a2:	54d8                	lw	a4,44(s1)
    800036a4:	9fb9                	addw	a5,a5,a4
    800036a6:	00f95963          	bge	s2,a5,800036b8 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036aa:	85a6                	mv	a1,s1
    800036ac:	8526                	mv	a0,s1
    800036ae:	ffffe097          	auipc	ra,0xffffe
    800036b2:	fb4080e7          	jalr	-76(ra) # 80001662 <sleep>
    800036b6:	bfd1                	j	8000368a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036b8:	00236517          	auipc	a0,0x236
    800036bc:	98050513          	addi	a0,a0,-1664 # 80239038 <log>
    800036c0:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036c2:	00003097          	auipc	ra,0x3
    800036c6:	c74080e7          	jalr	-908(ra) # 80006336 <release>
      break;
    }
  }
}
    800036ca:	60e2                	ld	ra,24(sp)
    800036cc:	6442                	ld	s0,16(sp)
    800036ce:	64a2                	ld	s1,8(sp)
    800036d0:	6902                	ld	s2,0(sp)
    800036d2:	6105                	addi	sp,sp,32
    800036d4:	8082                	ret

00000000800036d6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036d6:	7139                	addi	sp,sp,-64
    800036d8:	fc06                	sd	ra,56(sp)
    800036da:	f822                	sd	s0,48(sp)
    800036dc:	f426                	sd	s1,40(sp)
    800036de:	f04a                	sd	s2,32(sp)
    800036e0:	ec4e                	sd	s3,24(sp)
    800036e2:	e852                	sd	s4,16(sp)
    800036e4:	e456                	sd	s5,8(sp)
    800036e6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036e8:	00236497          	auipc	s1,0x236
    800036ec:	95048493          	addi	s1,s1,-1712 # 80239038 <log>
    800036f0:	8526                	mv	a0,s1
    800036f2:	00003097          	auipc	ra,0x3
    800036f6:	b90080e7          	jalr	-1136(ra) # 80006282 <acquire>
  log.outstanding -= 1;
    800036fa:	509c                	lw	a5,32(s1)
    800036fc:	37fd                	addiw	a5,a5,-1
    800036fe:	0007891b          	sext.w	s2,a5
    80003702:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003704:	50dc                	lw	a5,36(s1)
    80003706:	efb9                	bnez	a5,80003764 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003708:	06091663          	bnez	s2,80003774 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000370c:	00236497          	auipc	s1,0x236
    80003710:	92c48493          	addi	s1,s1,-1748 # 80239038 <log>
    80003714:	4785                	li	a5,1
    80003716:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003718:	8526                	mv	a0,s1
    8000371a:	00003097          	auipc	ra,0x3
    8000371e:	c1c080e7          	jalr	-996(ra) # 80006336 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003722:	54dc                	lw	a5,44(s1)
    80003724:	06f04763          	bgtz	a5,80003792 <end_op+0xbc>
    acquire(&log.lock);
    80003728:	00236497          	auipc	s1,0x236
    8000372c:	91048493          	addi	s1,s1,-1776 # 80239038 <log>
    80003730:	8526                	mv	a0,s1
    80003732:	00003097          	auipc	ra,0x3
    80003736:	b50080e7          	jalr	-1200(ra) # 80006282 <acquire>
    log.committing = 0;
    8000373a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000373e:	8526                	mv	a0,s1
    80003740:	ffffe097          	auipc	ra,0xffffe
    80003744:	0ae080e7          	jalr	174(ra) # 800017ee <wakeup>
    release(&log.lock);
    80003748:	8526                	mv	a0,s1
    8000374a:	00003097          	auipc	ra,0x3
    8000374e:	bec080e7          	jalr	-1044(ra) # 80006336 <release>
}
    80003752:	70e2                	ld	ra,56(sp)
    80003754:	7442                	ld	s0,48(sp)
    80003756:	74a2                	ld	s1,40(sp)
    80003758:	7902                	ld	s2,32(sp)
    8000375a:	69e2                	ld	s3,24(sp)
    8000375c:	6a42                	ld	s4,16(sp)
    8000375e:	6aa2                	ld	s5,8(sp)
    80003760:	6121                	addi	sp,sp,64
    80003762:	8082                	ret
    panic("log.committing");
    80003764:	00005517          	auipc	a0,0x5
    80003768:	e4450513          	addi	a0,a0,-444 # 800085a8 <syscalls+0x1e0>
    8000376c:	00002097          	auipc	ra,0x2
    80003770:	5cc080e7          	jalr	1484(ra) # 80005d38 <panic>
    wakeup(&log);
    80003774:	00236497          	auipc	s1,0x236
    80003778:	8c448493          	addi	s1,s1,-1852 # 80239038 <log>
    8000377c:	8526                	mv	a0,s1
    8000377e:	ffffe097          	auipc	ra,0xffffe
    80003782:	070080e7          	jalr	112(ra) # 800017ee <wakeup>
  release(&log.lock);
    80003786:	8526                	mv	a0,s1
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	bae080e7          	jalr	-1106(ra) # 80006336 <release>
  if(do_commit){
    80003790:	b7c9                	j	80003752 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003792:	00236a97          	auipc	s5,0x236
    80003796:	8d6a8a93          	addi	s5,s5,-1834 # 80239068 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000379a:	00236a17          	auipc	s4,0x236
    8000379e:	89ea0a13          	addi	s4,s4,-1890 # 80239038 <log>
    800037a2:	018a2583          	lw	a1,24(s4)
    800037a6:	012585bb          	addw	a1,a1,s2
    800037aa:	2585                	addiw	a1,a1,1
    800037ac:	028a2503          	lw	a0,40(s4)
    800037b0:	fffff097          	auipc	ra,0xfffff
    800037b4:	cd2080e7          	jalr	-814(ra) # 80002482 <bread>
    800037b8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037ba:	000aa583          	lw	a1,0(s5)
    800037be:	028a2503          	lw	a0,40(s4)
    800037c2:	fffff097          	auipc	ra,0xfffff
    800037c6:	cc0080e7          	jalr	-832(ra) # 80002482 <bread>
    800037ca:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037cc:	40000613          	li	a2,1024
    800037d0:	05850593          	addi	a1,a0,88
    800037d4:	05848513          	addi	a0,s1,88
    800037d8:	ffffd097          	auipc	ra,0xffffd
    800037dc:	a82080e7          	jalr	-1406(ra) # 8000025a <memmove>
    bwrite(to);  // write the log
    800037e0:	8526                	mv	a0,s1
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	d92080e7          	jalr	-622(ra) # 80002574 <bwrite>
    brelse(from);
    800037ea:	854e                	mv	a0,s3
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	dc6080e7          	jalr	-570(ra) # 800025b2 <brelse>
    brelse(to);
    800037f4:	8526                	mv	a0,s1
    800037f6:	fffff097          	auipc	ra,0xfffff
    800037fa:	dbc080e7          	jalr	-580(ra) # 800025b2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037fe:	2905                	addiw	s2,s2,1
    80003800:	0a91                	addi	s5,s5,4
    80003802:	02ca2783          	lw	a5,44(s4)
    80003806:	f8f94ee3          	blt	s2,a5,800037a2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000380a:	00000097          	auipc	ra,0x0
    8000380e:	c6a080e7          	jalr	-918(ra) # 80003474 <write_head>
    install_trans(0); // Now install writes to home locations
    80003812:	4501                	li	a0,0
    80003814:	00000097          	auipc	ra,0x0
    80003818:	cda080e7          	jalr	-806(ra) # 800034ee <install_trans>
    log.lh.n = 0;
    8000381c:	00236797          	auipc	a5,0x236
    80003820:	8407a423          	sw	zero,-1976(a5) # 80239064 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003824:	00000097          	auipc	ra,0x0
    80003828:	c50080e7          	jalr	-944(ra) # 80003474 <write_head>
    8000382c:	bdf5                	j	80003728 <end_op+0x52>

000000008000382e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000382e:	1101                	addi	sp,sp,-32
    80003830:	ec06                	sd	ra,24(sp)
    80003832:	e822                	sd	s0,16(sp)
    80003834:	e426                	sd	s1,8(sp)
    80003836:	e04a                	sd	s2,0(sp)
    80003838:	1000                	addi	s0,sp,32
    8000383a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000383c:	00235917          	auipc	s2,0x235
    80003840:	7fc90913          	addi	s2,s2,2044 # 80239038 <log>
    80003844:	854a                	mv	a0,s2
    80003846:	00003097          	auipc	ra,0x3
    8000384a:	a3c080e7          	jalr	-1476(ra) # 80006282 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000384e:	02c92603          	lw	a2,44(s2)
    80003852:	47f5                	li	a5,29
    80003854:	06c7c563          	blt	a5,a2,800038be <log_write+0x90>
    80003858:	00235797          	auipc	a5,0x235
    8000385c:	7fc7a783          	lw	a5,2044(a5) # 80239054 <log+0x1c>
    80003860:	37fd                	addiw	a5,a5,-1
    80003862:	04f65e63          	bge	a2,a5,800038be <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003866:	00235797          	auipc	a5,0x235
    8000386a:	7f27a783          	lw	a5,2034(a5) # 80239058 <log+0x20>
    8000386e:	06f05063          	blez	a5,800038ce <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003872:	4781                	li	a5,0
    80003874:	06c05563          	blez	a2,800038de <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003878:	44cc                	lw	a1,12(s1)
    8000387a:	00235717          	auipc	a4,0x235
    8000387e:	7ee70713          	addi	a4,a4,2030 # 80239068 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003882:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003884:	4314                	lw	a3,0(a4)
    80003886:	04b68c63          	beq	a3,a1,800038de <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000388a:	2785                	addiw	a5,a5,1
    8000388c:	0711                	addi	a4,a4,4
    8000388e:	fef61be3          	bne	a2,a5,80003884 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003892:	0621                	addi	a2,a2,8
    80003894:	060a                	slli	a2,a2,0x2
    80003896:	00235797          	auipc	a5,0x235
    8000389a:	7a278793          	addi	a5,a5,1954 # 80239038 <log>
    8000389e:	963e                	add	a2,a2,a5
    800038a0:	44dc                	lw	a5,12(s1)
    800038a2:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038a4:	8526                	mv	a0,s1
    800038a6:	fffff097          	auipc	ra,0xfffff
    800038aa:	daa080e7          	jalr	-598(ra) # 80002650 <bpin>
    log.lh.n++;
    800038ae:	00235717          	auipc	a4,0x235
    800038b2:	78a70713          	addi	a4,a4,1930 # 80239038 <log>
    800038b6:	575c                	lw	a5,44(a4)
    800038b8:	2785                	addiw	a5,a5,1
    800038ba:	d75c                	sw	a5,44(a4)
    800038bc:	a835                	j	800038f8 <log_write+0xca>
    panic("too big a transaction");
    800038be:	00005517          	auipc	a0,0x5
    800038c2:	cfa50513          	addi	a0,a0,-774 # 800085b8 <syscalls+0x1f0>
    800038c6:	00002097          	auipc	ra,0x2
    800038ca:	472080e7          	jalr	1138(ra) # 80005d38 <panic>
    panic("log_write outside of trans");
    800038ce:	00005517          	auipc	a0,0x5
    800038d2:	d0250513          	addi	a0,a0,-766 # 800085d0 <syscalls+0x208>
    800038d6:	00002097          	auipc	ra,0x2
    800038da:	462080e7          	jalr	1122(ra) # 80005d38 <panic>
  log.lh.block[i] = b->blockno;
    800038de:	00878713          	addi	a4,a5,8
    800038e2:	00271693          	slli	a3,a4,0x2
    800038e6:	00235717          	auipc	a4,0x235
    800038ea:	75270713          	addi	a4,a4,1874 # 80239038 <log>
    800038ee:	9736                	add	a4,a4,a3
    800038f0:	44d4                	lw	a3,12(s1)
    800038f2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038f4:	faf608e3          	beq	a2,a5,800038a4 <log_write+0x76>
  }
  release(&log.lock);
    800038f8:	00235517          	auipc	a0,0x235
    800038fc:	74050513          	addi	a0,a0,1856 # 80239038 <log>
    80003900:	00003097          	auipc	ra,0x3
    80003904:	a36080e7          	jalr	-1482(ra) # 80006336 <release>
}
    80003908:	60e2                	ld	ra,24(sp)
    8000390a:	6442                	ld	s0,16(sp)
    8000390c:	64a2                	ld	s1,8(sp)
    8000390e:	6902                	ld	s2,0(sp)
    80003910:	6105                	addi	sp,sp,32
    80003912:	8082                	ret

0000000080003914 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003914:	1101                	addi	sp,sp,-32
    80003916:	ec06                	sd	ra,24(sp)
    80003918:	e822                	sd	s0,16(sp)
    8000391a:	e426                	sd	s1,8(sp)
    8000391c:	e04a                	sd	s2,0(sp)
    8000391e:	1000                	addi	s0,sp,32
    80003920:	84aa                	mv	s1,a0
    80003922:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003924:	00005597          	auipc	a1,0x5
    80003928:	ccc58593          	addi	a1,a1,-820 # 800085f0 <syscalls+0x228>
    8000392c:	0521                	addi	a0,a0,8
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	8c4080e7          	jalr	-1852(ra) # 800061f2 <initlock>
  lk->name = name;
    80003936:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000393a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000393e:	0204a423          	sw	zero,40(s1)
}
    80003942:	60e2                	ld	ra,24(sp)
    80003944:	6442                	ld	s0,16(sp)
    80003946:	64a2                	ld	s1,8(sp)
    80003948:	6902                	ld	s2,0(sp)
    8000394a:	6105                	addi	sp,sp,32
    8000394c:	8082                	ret

000000008000394e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000394e:	1101                	addi	sp,sp,-32
    80003950:	ec06                	sd	ra,24(sp)
    80003952:	e822                	sd	s0,16(sp)
    80003954:	e426                	sd	s1,8(sp)
    80003956:	e04a                	sd	s2,0(sp)
    80003958:	1000                	addi	s0,sp,32
    8000395a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000395c:	00850913          	addi	s2,a0,8
    80003960:	854a                	mv	a0,s2
    80003962:	00003097          	auipc	ra,0x3
    80003966:	920080e7          	jalr	-1760(ra) # 80006282 <acquire>
  while (lk->locked) {
    8000396a:	409c                	lw	a5,0(s1)
    8000396c:	cb89                	beqz	a5,8000397e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000396e:	85ca                	mv	a1,s2
    80003970:	8526                	mv	a0,s1
    80003972:	ffffe097          	auipc	ra,0xffffe
    80003976:	cf0080e7          	jalr	-784(ra) # 80001662 <sleep>
  while (lk->locked) {
    8000397a:	409c                	lw	a5,0(s1)
    8000397c:	fbed                	bnez	a5,8000396e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000397e:	4785                	li	a5,1
    80003980:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003982:	ffffd097          	auipc	ra,0xffffd
    80003986:	624080e7          	jalr	1572(ra) # 80000fa6 <myproc>
    8000398a:	591c                	lw	a5,48(a0)
    8000398c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000398e:	854a                	mv	a0,s2
    80003990:	00003097          	auipc	ra,0x3
    80003994:	9a6080e7          	jalr	-1626(ra) # 80006336 <release>
}
    80003998:	60e2                	ld	ra,24(sp)
    8000399a:	6442                	ld	s0,16(sp)
    8000399c:	64a2                	ld	s1,8(sp)
    8000399e:	6902                	ld	s2,0(sp)
    800039a0:	6105                	addi	sp,sp,32
    800039a2:	8082                	ret

00000000800039a4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039a4:	1101                	addi	sp,sp,-32
    800039a6:	ec06                	sd	ra,24(sp)
    800039a8:	e822                	sd	s0,16(sp)
    800039aa:	e426                	sd	s1,8(sp)
    800039ac:	e04a                	sd	s2,0(sp)
    800039ae:	1000                	addi	s0,sp,32
    800039b0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039b2:	00850913          	addi	s2,a0,8
    800039b6:	854a                	mv	a0,s2
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	8ca080e7          	jalr	-1846(ra) # 80006282 <acquire>
  lk->locked = 0;
    800039c0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039c4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039c8:	8526                	mv	a0,s1
    800039ca:	ffffe097          	auipc	ra,0xffffe
    800039ce:	e24080e7          	jalr	-476(ra) # 800017ee <wakeup>
  release(&lk->lk);
    800039d2:	854a                	mv	a0,s2
    800039d4:	00003097          	auipc	ra,0x3
    800039d8:	962080e7          	jalr	-1694(ra) # 80006336 <release>
}
    800039dc:	60e2                	ld	ra,24(sp)
    800039de:	6442                	ld	s0,16(sp)
    800039e0:	64a2                	ld	s1,8(sp)
    800039e2:	6902                	ld	s2,0(sp)
    800039e4:	6105                	addi	sp,sp,32
    800039e6:	8082                	ret

00000000800039e8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039e8:	7179                	addi	sp,sp,-48
    800039ea:	f406                	sd	ra,40(sp)
    800039ec:	f022                	sd	s0,32(sp)
    800039ee:	ec26                	sd	s1,24(sp)
    800039f0:	e84a                	sd	s2,16(sp)
    800039f2:	e44e                	sd	s3,8(sp)
    800039f4:	1800                	addi	s0,sp,48
    800039f6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039f8:	00850913          	addi	s2,a0,8
    800039fc:	854a                	mv	a0,s2
    800039fe:	00003097          	auipc	ra,0x3
    80003a02:	884080e7          	jalr	-1916(ra) # 80006282 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a06:	409c                	lw	a5,0(s1)
    80003a08:	ef99                	bnez	a5,80003a26 <holdingsleep+0x3e>
    80003a0a:	4481                	li	s1,0
  release(&lk->lk);
    80003a0c:	854a                	mv	a0,s2
    80003a0e:	00003097          	auipc	ra,0x3
    80003a12:	928080e7          	jalr	-1752(ra) # 80006336 <release>
  return r;
}
    80003a16:	8526                	mv	a0,s1
    80003a18:	70a2                	ld	ra,40(sp)
    80003a1a:	7402                	ld	s0,32(sp)
    80003a1c:	64e2                	ld	s1,24(sp)
    80003a1e:	6942                	ld	s2,16(sp)
    80003a20:	69a2                	ld	s3,8(sp)
    80003a22:	6145                	addi	sp,sp,48
    80003a24:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a26:	0284a983          	lw	s3,40(s1)
    80003a2a:	ffffd097          	auipc	ra,0xffffd
    80003a2e:	57c080e7          	jalr	1404(ra) # 80000fa6 <myproc>
    80003a32:	5904                	lw	s1,48(a0)
    80003a34:	413484b3          	sub	s1,s1,s3
    80003a38:	0014b493          	seqz	s1,s1
    80003a3c:	bfc1                	j	80003a0c <holdingsleep+0x24>

0000000080003a3e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a3e:	1141                	addi	sp,sp,-16
    80003a40:	e406                	sd	ra,8(sp)
    80003a42:	e022                	sd	s0,0(sp)
    80003a44:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a46:	00005597          	auipc	a1,0x5
    80003a4a:	bba58593          	addi	a1,a1,-1094 # 80008600 <syscalls+0x238>
    80003a4e:	00235517          	auipc	a0,0x235
    80003a52:	73250513          	addi	a0,a0,1842 # 80239180 <ftable>
    80003a56:	00002097          	auipc	ra,0x2
    80003a5a:	79c080e7          	jalr	1948(ra) # 800061f2 <initlock>
}
    80003a5e:	60a2                	ld	ra,8(sp)
    80003a60:	6402                	ld	s0,0(sp)
    80003a62:	0141                	addi	sp,sp,16
    80003a64:	8082                	ret

0000000080003a66 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a66:	1101                	addi	sp,sp,-32
    80003a68:	ec06                	sd	ra,24(sp)
    80003a6a:	e822                	sd	s0,16(sp)
    80003a6c:	e426                	sd	s1,8(sp)
    80003a6e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a70:	00235517          	auipc	a0,0x235
    80003a74:	71050513          	addi	a0,a0,1808 # 80239180 <ftable>
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	80a080e7          	jalr	-2038(ra) # 80006282 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a80:	00235497          	auipc	s1,0x235
    80003a84:	71848493          	addi	s1,s1,1816 # 80239198 <ftable+0x18>
    80003a88:	00236717          	auipc	a4,0x236
    80003a8c:	6b070713          	addi	a4,a4,1712 # 8023a138 <ftable+0xfb8>
    if(f->ref == 0){
    80003a90:	40dc                	lw	a5,4(s1)
    80003a92:	cf99                	beqz	a5,80003ab0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a94:	02848493          	addi	s1,s1,40
    80003a98:	fee49ce3          	bne	s1,a4,80003a90 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a9c:	00235517          	auipc	a0,0x235
    80003aa0:	6e450513          	addi	a0,a0,1764 # 80239180 <ftable>
    80003aa4:	00003097          	auipc	ra,0x3
    80003aa8:	892080e7          	jalr	-1902(ra) # 80006336 <release>
  return 0;
    80003aac:	4481                	li	s1,0
    80003aae:	a819                	j	80003ac4 <filealloc+0x5e>
      f->ref = 1;
    80003ab0:	4785                	li	a5,1
    80003ab2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ab4:	00235517          	auipc	a0,0x235
    80003ab8:	6cc50513          	addi	a0,a0,1740 # 80239180 <ftable>
    80003abc:	00003097          	auipc	ra,0x3
    80003ac0:	87a080e7          	jalr	-1926(ra) # 80006336 <release>
}
    80003ac4:	8526                	mv	a0,s1
    80003ac6:	60e2                	ld	ra,24(sp)
    80003ac8:	6442                	ld	s0,16(sp)
    80003aca:	64a2                	ld	s1,8(sp)
    80003acc:	6105                	addi	sp,sp,32
    80003ace:	8082                	ret

0000000080003ad0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ad0:	1101                	addi	sp,sp,-32
    80003ad2:	ec06                	sd	ra,24(sp)
    80003ad4:	e822                	sd	s0,16(sp)
    80003ad6:	e426                	sd	s1,8(sp)
    80003ad8:	1000                	addi	s0,sp,32
    80003ada:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003adc:	00235517          	auipc	a0,0x235
    80003ae0:	6a450513          	addi	a0,a0,1700 # 80239180 <ftable>
    80003ae4:	00002097          	auipc	ra,0x2
    80003ae8:	79e080e7          	jalr	1950(ra) # 80006282 <acquire>
  if(f->ref < 1)
    80003aec:	40dc                	lw	a5,4(s1)
    80003aee:	02f05263          	blez	a5,80003b12 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003af2:	2785                	addiw	a5,a5,1
    80003af4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003af6:	00235517          	auipc	a0,0x235
    80003afa:	68a50513          	addi	a0,a0,1674 # 80239180 <ftable>
    80003afe:	00003097          	auipc	ra,0x3
    80003b02:	838080e7          	jalr	-1992(ra) # 80006336 <release>
  return f;
}
    80003b06:	8526                	mv	a0,s1
    80003b08:	60e2                	ld	ra,24(sp)
    80003b0a:	6442                	ld	s0,16(sp)
    80003b0c:	64a2                	ld	s1,8(sp)
    80003b0e:	6105                	addi	sp,sp,32
    80003b10:	8082                	ret
    panic("filedup");
    80003b12:	00005517          	auipc	a0,0x5
    80003b16:	af650513          	addi	a0,a0,-1290 # 80008608 <syscalls+0x240>
    80003b1a:	00002097          	auipc	ra,0x2
    80003b1e:	21e080e7          	jalr	542(ra) # 80005d38 <panic>

0000000080003b22 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b22:	7139                	addi	sp,sp,-64
    80003b24:	fc06                	sd	ra,56(sp)
    80003b26:	f822                	sd	s0,48(sp)
    80003b28:	f426                	sd	s1,40(sp)
    80003b2a:	f04a                	sd	s2,32(sp)
    80003b2c:	ec4e                	sd	s3,24(sp)
    80003b2e:	e852                	sd	s4,16(sp)
    80003b30:	e456                	sd	s5,8(sp)
    80003b32:	0080                	addi	s0,sp,64
    80003b34:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b36:	00235517          	auipc	a0,0x235
    80003b3a:	64a50513          	addi	a0,a0,1610 # 80239180 <ftable>
    80003b3e:	00002097          	auipc	ra,0x2
    80003b42:	744080e7          	jalr	1860(ra) # 80006282 <acquire>
  if(f->ref < 1)
    80003b46:	40dc                	lw	a5,4(s1)
    80003b48:	06f05163          	blez	a5,80003baa <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b4c:	37fd                	addiw	a5,a5,-1
    80003b4e:	0007871b          	sext.w	a4,a5
    80003b52:	c0dc                	sw	a5,4(s1)
    80003b54:	06e04363          	bgtz	a4,80003bba <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b58:	0004a903          	lw	s2,0(s1)
    80003b5c:	0094ca83          	lbu	s5,9(s1)
    80003b60:	0104ba03          	ld	s4,16(s1)
    80003b64:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b68:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b6c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b70:	00235517          	auipc	a0,0x235
    80003b74:	61050513          	addi	a0,a0,1552 # 80239180 <ftable>
    80003b78:	00002097          	auipc	ra,0x2
    80003b7c:	7be080e7          	jalr	1982(ra) # 80006336 <release>

  if(ff.type == FD_PIPE){
    80003b80:	4785                	li	a5,1
    80003b82:	04f90d63          	beq	s2,a5,80003bdc <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b86:	3979                	addiw	s2,s2,-2
    80003b88:	4785                	li	a5,1
    80003b8a:	0527e063          	bltu	a5,s2,80003bca <fileclose+0xa8>
    begin_op();
    80003b8e:	00000097          	auipc	ra,0x0
    80003b92:	ac8080e7          	jalr	-1336(ra) # 80003656 <begin_op>
    iput(ff.ip);
    80003b96:	854e                	mv	a0,s3
    80003b98:	fffff097          	auipc	ra,0xfffff
    80003b9c:	2a6080e7          	jalr	678(ra) # 80002e3e <iput>
    end_op();
    80003ba0:	00000097          	auipc	ra,0x0
    80003ba4:	b36080e7          	jalr	-1226(ra) # 800036d6 <end_op>
    80003ba8:	a00d                	j	80003bca <fileclose+0xa8>
    panic("fileclose");
    80003baa:	00005517          	auipc	a0,0x5
    80003bae:	a6650513          	addi	a0,a0,-1434 # 80008610 <syscalls+0x248>
    80003bb2:	00002097          	auipc	ra,0x2
    80003bb6:	186080e7          	jalr	390(ra) # 80005d38 <panic>
    release(&ftable.lock);
    80003bba:	00235517          	auipc	a0,0x235
    80003bbe:	5c650513          	addi	a0,a0,1478 # 80239180 <ftable>
    80003bc2:	00002097          	auipc	ra,0x2
    80003bc6:	774080e7          	jalr	1908(ra) # 80006336 <release>
  }
}
    80003bca:	70e2                	ld	ra,56(sp)
    80003bcc:	7442                	ld	s0,48(sp)
    80003bce:	74a2                	ld	s1,40(sp)
    80003bd0:	7902                	ld	s2,32(sp)
    80003bd2:	69e2                	ld	s3,24(sp)
    80003bd4:	6a42                	ld	s4,16(sp)
    80003bd6:	6aa2                	ld	s5,8(sp)
    80003bd8:	6121                	addi	sp,sp,64
    80003bda:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bdc:	85d6                	mv	a1,s5
    80003bde:	8552                	mv	a0,s4
    80003be0:	00000097          	auipc	ra,0x0
    80003be4:	34c080e7          	jalr	844(ra) # 80003f2c <pipeclose>
    80003be8:	b7cd                	j	80003bca <fileclose+0xa8>

0000000080003bea <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bea:	715d                	addi	sp,sp,-80
    80003bec:	e486                	sd	ra,72(sp)
    80003bee:	e0a2                	sd	s0,64(sp)
    80003bf0:	fc26                	sd	s1,56(sp)
    80003bf2:	f84a                	sd	s2,48(sp)
    80003bf4:	f44e                	sd	s3,40(sp)
    80003bf6:	0880                	addi	s0,sp,80
    80003bf8:	84aa                	mv	s1,a0
    80003bfa:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bfc:	ffffd097          	auipc	ra,0xffffd
    80003c00:	3aa080e7          	jalr	938(ra) # 80000fa6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c04:	409c                	lw	a5,0(s1)
    80003c06:	37f9                	addiw	a5,a5,-2
    80003c08:	4705                	li	a4,1
    80003c0a:	04f76763          	bltu	a4,a5,80003c58 <filestat+0x6e>
    80003c0e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c10:	6c88                	ld	a0,24(s1)
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	072080e7          	jalr	114(ra) # 80002c84 <ilock>
    stati(f->ip, &st);
    80003c1a:	fb840593          	addi	a1,s0,-72
    80003c1e:	6c88                	ld	a0,24(s1)
    80003c20:	fffff097          	auipc	ra,0xfffff
    80003c24:	2ee080e7          	jalr	750(ra) # 80002f0e <stati>
    iunlock(f->ip);
    80003c28:	6c88                	ld	a0,24(s1)
    80003c2a:	fffff097          	auipc	ra,0xfffff
    80003c2e:	11c080e7          	jalr	284(ra) # 80002d46 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c32:	46e1                	li	a3,24
    80003c34:	fb840613          	addi	a2,s0,-72
    80003c38:	85ce                	mv	a1,s3
    80003c3a:	05093503          	ld	a0,80(s2)
    80003c3e:	ffffd097          	auipc	ra,0xffffd
    80003c42:	f98080e7          	jalr	-104(ra) # 80000bd6 <copyout>
    80003c46:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c4a:	60a6                	ld	ra,72(sp)
    80003c4c:	6406                	ld	s0,64(sp)
    80003c4e:	74e2                	ld	s1,56(sp)
    80003c50:	7942                	ld	s2,48(sp)
    80003c52:	79a2                	ld	s3,40(sp)
    80003c54:	6161                	addi	sp,sp,80
    80003c56:	8082                	ret
  return -1;
    80003c58:	557d                	li	a0,-1
    80003c5a:	bfc5                	j	80003c4a <filestat+0x60>

0000000080003c5c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c5c:	7179                	addi	sp,sp,-48
    80003c5e:	f406                	sd	ra,40(sp)
    80003c60:	f022                	sd	s0,32(sp)
    80003c62:	ec26                	sd	s1,24(sp)
    80003c64:	e84a                	sd	s2,16(sp)
    80003c66:	e44e                	sd	s3,8(sp)
    80003c68:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c6a:	00854783          	lbu	a5,8(a0)
    80003c6e:	c3d5                	beqz	a5,80003d12 <fileread+0xb6>
    80003c70:	84aa                	mv	s1,a0
    80003c72:	89ae                	mv	s3,a1
    80003c74:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c76:	411c                	lw	a5,0(a0)
    80003c78:	4705                	li	a4,1
    80003c7a:	04e78963          	beq	a5,a4,80003ccc <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c7e:	470d                	li	a4,3
    80003c80:	04e78d63          	beq	a5,a4,80003cda <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c84:	4709                	li	a4,2
    80003c86:	06e79e63          	bne	a5,a4,80003d02 <fileread+0xa6>
    ilock(f->ip);
    80003c8a:	6d08                	ld	a0,24(a0)
    80003c8c:	fffff097          	auipc	ra,0xfffff
    80003c90:	ff8080e7          	jalr	-8(ra) # 80002c84 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c94:	874a                	mv	a4,s2
    80003c96:	5094                	lw	a3,32(s1)
    80003c98:	864e                	mv	a2,s3
    80003c9a:	4585                	li	a1,1
    80003c9c:	6c88                	ld	a0,24(s1)
    80003c9e:	fffff097          	auipc	ra,0xfffff
    80003ca2:	29a080e7          	jalr	666(ra) # 80002f38 <readi>
    80003ca6:	892a                	mv	s2,a0
    80003ca8:	00a05563          	blez	a0,80003cb2 <fileread+0x56>
      f->off += r;
    80003cac:	509c                	lw	a5,32(s1)
    80003cae:	9fa9                	addw	a5,a5,a0
    80003cb0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cb2:	6c88                	ld	a0,24(s1)
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	092080e7          	jalr	146(ra) # 80002d46 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cbc:	854a                	mv	a0,s2
    80003cbe:	70a2                	ld	ra,40(sp)
    80003cc0:	7402                	ld	s0,32(sp)
    80003cc2:	64e2                	ld	s1,24(sp)
    80003cc4:	6942                	ld	s2,16(sp)
    80003cc6:	69a2                	ld	s3,8(sp)
    80003cc8:	6145                	addi	sp,sp,48
    80003cca:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ccc:	6908                	ld	a0,16(a0)
    80003cce:	00000097          	auipc	ra,0x0
    80003cd2:	3c8080e7          	jalr	968(ra) # 80004096 <piperead>
    80003cd6:	892a                	mv	s2,a0
    80003cd8:	b7d5                	j	80003cbc <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cda:	02451783          	lh	a5,36(a0)
    80003cde:	03079693          	slli	a3,a5,0x30
    80003ce2:	92c1                	srli	a3,a3,0x30
    80003ce4:	4725                	li	a4,9
    80003ce6:	02d76863          	bltu	a4,a3,80003d16 <fileread+0xba>
    80003cea:	0792                	slli	a5,a5,0x4
    80003cec:	00235717          	auipc	a4,0x235
    80003cf0:	3f470713          	addi	a4,a4,1012 # 802390e0 <devsw>
    80003cf4:	97ba                	add	a5,a5,a4
    80003cf6:	639c                	ld	a5,0(a5)
    80003cf8:	c38d                	beqz	a5,80003d1a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cfa:	4505                	li	a0,1
    80003cfc:	9782                	jalr	a5
    80003cfe:	892a                	mv	s2,a0
    80003d00:	bf75                	j	80003cbc <fileread+0x60>
    panic("fileread");
    80003d02:	00005517          	auipc	a0,0x5
    80003d06:	91e50513          	addi	a0,a0,-1762 # 80008620 <syscalls+0x258>
    80003d0a:	00002097          	auipc	ra,0x2
    80003d0e:	02e080e7          	jalr	46(ra) # 80005d38 <panic>
    return -1;
    80003d12:	597d                	li	s2,-1
    80003d14:	b765                	j	80003cbc <fileread+0x60>
      return -1;
    80003d16:	597d                	li	s2,-1
    80003d18:	b755                	j	80003cbc <fileread+0x60>
    80003d1a:	597d                	li	s2,-1
    80003d1c:	b745                	j	80003cbc <fileread+0x60>

0000000080003d1e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d1e:	715d                	addi	sp,sp,-80
    80003d20:	e486                	sd	ra,72(sp)
    80003d22:	e0a2                	sd	s0,64(sp)
    80003d24:	fc26                	sd	s1,56(sp)
    80003d26:	f84a                	sd	s2,48(sp)
    80003d28:	f44e                	sd	s3,40(sp)
    80003d2a:	f052                	sd	s4,32(sp)
    80003d2c:	ec56                	sd	s5,24(sp)
    80003d2e:	e85a                	sd	s6,16(sp)
    80003d30:	e45e                	sd	s7,8(sp)
    80003d32:	e062                	sd	s8,0(sp)
    80003d34:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d36:	00954783          	lbu	a5,9(a0)
    80003d3a:	10078663          	beqz	a5,80003e46 <filewrite+0x128>
    80003d3e:	892a                	mv	s2,a0
    80003d40:	8aae                	mv	s5,a1
    80003d42:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d44:	411c                	lw	a5,0(a0)
    80003d46:	4705                	li	a4,1
    80003d48:	02e78263          	beq	a5,a4,80003d6c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d4c:	470d                	li	a4,3
    80003d4e:	02e78663          	beq	a5,a4,80003d7a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d52:	4709                	li	a4,2
    80003d54:	0ee79163          	bne	a5,a4,80003e36 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d58:	0ac05d63          	blez	a2,80003e12 <filewrite+0xf4>
    int i = 0;
    80003d5c:	4981                	li	s3,0
    80003d5e:	6b05                	lui	s6,0x1
    80003d60:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d64:	6b85                	lui	s7,0x1
    80003d66:	c00b8b9b          	addiw	s7,s7,-1024
    80003d6a:	a861                	j	80003e02 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d6c:	6908                	ld	a0,16(a0)
    80003d6e:	00000097          	auipc	ra,0x0
    80003d72:	22e080e7          	jalr	558(ra) # 80003f9c <pipewrite>
    80003d76:	8a2a                	mv	s4,a0
    80003d78:	a045                	j	80003e18 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d7a:	02451783          	lh	a5,36(a0)
    80003d7e:	03079693          	slli	a3,a5,0x30
    80003d82:	92c1                	srli	a3,a3,0x30
    80003d84:	4725                	li	a4,9
    80003d86:	0cd76263          	bltu	a4,a3,80003e4a <filewrite+0x12c>
    80003d8a:	0792                	slli	a5,a5,0x4
    80003d8c:	00235717          	auipc	a4,0x235
    80003d90:	35470713          	addi	a4,a4,852 # 802390e0 <devsw>
    80003d94:	97ba                	add	a5,a5,a4
    80003d96:	679c                	ld	a5,8(a5)
    80003d98:	cbdd                	beqz	a5,80003e4e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d9a:	4505                	li	a0,1
    80003d9c:	9782                	jalr	a5
    80003d9e:	8a2a                	mv	s4,a0
    80003da0:	a8a5                	j	80003e18 <filewrite+0xfa>
    80003da2:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	8b0080e7          	jalr	-1872(ra) # 80003656 <begin_op>
      ilock(f->ip);
    80003dae:	01893503          	ld	a0,24(s2)
    80003db2:	fffff097          	auipc	ra,0xfffff
    80003db6:	ed2080e7          	jalr	-302(ra) # 80002c84 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dba:	8762                	mv	a4,s8
    80003dbc:	02092683          	lw	a3,32(s2)
    80003dc0:	01598633          	add	a2,s3,s5
    80003dc4:	4585                	li	a1,1
    80003dc6:	01893503          	ld	a0,24(s2)
    80003dca:	fffff097          	auipc	ra,0xfffff
    80003dce:	266080e7          	jalr	614(ra) # 80003030 <writei>
    80003dd2:	84aa                	mv	s1,a0
    80003dd4:	00a05763          	blez	a0,80003de2 <filewrite+0xc4>
        f->off += r;
    80003dd8:	02092783          	lw	a5,32(s2)
    80003ddc:	9fa9                	addw	a5,a5,a0
    80003dde:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003de2:	01893503          	ld	a0,24(s2)
    80003de6:	fffff097          	auipc	ra,0xfffff
    80003dea:	f60080e7          	jalr	-160(ra) # 80002d46 <iunlock>
      end_op();
    80003dee:	00000097          	auipc	ra,0x0
    80003df2:	8e8080e7          	jalr	-1816(ra) # 800036d6 <end_op>

      if(r != n1){
    80003df6:	009c1f63          	bne	s8,s1,80003e14 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003dfa:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dfe:	0149db63          	bge	s3,s4,80003e14 <filewrite+0xf6>
      int n1 = n - i;
    80003e02:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e06:	84be                	mv	s1,a5
    80003e08:	2781                	sext.w	a5,a5
    80003e0a:	f8fb5ce3          	bge	s6,a5,80003da2 <filewrite+0x84>
    80003e0e:	84de                	mv	s1,s7
    80003e10:	bf49                	j	80003da2 <filewrite+0x84>
    int i = 0;
    80003e12:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e14:	013a1f63          	bne	s4,s3,80003e32 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e18:	8552                	mv	a0,s4
    80003e1a:	60a6                	ld	ra,72(sp)
    80003e1c:	6406                	ld	s0,64(sp)
    80003e1e:	74e2                	ld	s1,56(sp)
    80003e20:	7942                	ld	s2,48(sp)
    80003e22:	79a2                	ld	s3,40(sp)
    80003e24:	7a02                	ld	s4,32(sp)
    80003e26:	6ae2                	ld	s5,24(sp)
    80003e28:	6b42                	ld	s6,16(sp)
    80003e2a:	6ba2                	ld	s7,8(sp)
    80003e2c:	6c02                	ld	s8,0(sp)
    80003e2e:	6161                	addi	sp,sp,80
    80003e30:	8082                	ret
    ret = (i == n ? n : -1);
    80003e32:	5a7d                	li	s4,-1
    80003e34:	b7d5                	j	80003e18 <filewrite+0xfa>
    panic("filewrite");
    80003e36:	00004517          	auipc	a0,0x4
    80003e3a:	7fa50513          	addi	a0,a0,2042 # 80008630 <syscalls+0x268>
    80003e3e:	00002097          	auipc	ra,0x2
    80003e42:	efa080e7          	jalr	-262(ra) # 80005d38 <panic>
    return -1;
    80003e46:	5a7d                	li	s4,-1
    80003e48:	bfc1                	j	80003e18 <filewrite+0xfa>
      return -1;
    80003e4a:	5a7d                	li	s4,-1
    80003e4c:	b7f1                	j	80003e18 <filewrite+0xfa>
    80003e4e:	5a7d                	li	s4,-1
    80003e50:	b7e1                	j	80003e18 <filewrite+0xfa>

0000000080003e52 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e52:	7179                	addi	sp,sp,-48
    80003e54:	f406                	sd	ra,40(sp)
    80003e56:	f022                	sd	s0,32(sp)
    80003e58:	ec26                	sd	s1,24(sp)
    80003e5a:	e84a                	sd	s2,16(sp)
    80003e5c:	e44e                	sd	s3,8(sp)
    80003e5e:	e052                	sd	s4,0(sp)
    80003e60:	1800                	addi	s0,sp,48
    80003e62:	84aa                	mv	s1,a0
    80003e64:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e66:	0005b023          	sd	zero,0(a1)
    80003e6a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e6e:	00000097          	auipc	ra,0x0
    80003e72:	bf8080e7          	jalr	-1032(ra) # 80003a66 <filealloc>
    80003e76:	e088                	sd	a0,0(s1)
    80003e78:	c551                	beqz	a0,80003f04 <pipealloc+0xb2>
    80003e7a:	00000097          	auipc	ra,0x0
    80003e7e:	bec080e7          	jalr	-1044(ra) # 80003a66 <filealloc>
    80003e82:	00aa3023          	sd	a0,0(s4)
    80003e86:	c92d                	beqz	a0,80003ef8 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e88:	ffffc097          	auipc	ra,0xffffc
    80003e8c:	2d6080e7          	jalr	726(ra) # 8000015e <kalloc>
    80003e90:	892a                	mv	s2,a0
    80003e92:	c125                	beqz	a0,80003ef2 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e94:	4985                	li	s3,1
    80003e96:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e9a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e9e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ea2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ea6:	00004597          	auipc	a1,0x4
    80003eaa:	79a58593          	addi	a1,a1,1946 # 80008640 <syscalls+0x278>
    80003eae:	00002097          	auipc	ra,0x2
    80003eb2:	344080e7          	jalr	836(ra) # 800061f2 <initlock>
  (*f0)->type = FD_PIPE;
    80003eb6:	609c                	ld	a5,0(s1)
    80003eb8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ebc:	609c                	ld	a5,0(s1)
    80003ebe:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ec2:	609c                	ld	a5,0(s1)
    80003ec4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ec8:	609c                	ld	a5,0(s1)
    80003eca:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ece:	000a3783          	ld	a5,0(s4)
    80003ed2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ed6:	000a3783          	ld	a5,0(s4)
    80003eda:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ede:	000a3783          	ld	a5,0(s4)
    80003ee2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ee6:	000a3783          	ld	a5,0(s4)
    80003eea:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eee:	4501                	li	a0,0
    80003ef0:	a025                	j	80003f18 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ef2:	6088                	ld	a0,0(s1)
    80003ef4:	e501                	bnez	a0,80003efc <pipealloc+0xaa>
    80003ef6:	a039                	j	80003f04 <pipealloc+0xb2>
    80003ef8:	6088                	ld	a0,0(s1)
    80003efa:	c51d                	beqz	a0,80003f28 <pipealloc+0xd6>
    fileclose(*f0);
    80003efc:	00000097          	auipc	ra,0x0
    80003f00:	c26080e7          	jalr	-986(ra) # 80003b22 <fileclose>
  if(*f1)
    80003f04:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f08:	557d                	li	a0,-1
  if(*f1)
    80003f0a:	c799                	beqz	a5,80003f18 <pipealloc+0xc6>
    fileclose(*f1);
    80003f0c:	853e                	mv	a0,a5
    80003f0e:	00000097          	auipc	ra,0x0
    80003f12:	c14080e7          	jalr	-1004(ra) # 80003b22 <fileclose>
  return -1;
    80003f16:	557d                	li	a0,-1
}
    80003f18:	70a2                	ld	ra,40(sp)
    80003f1a:	7402                	ld	s0,32(sp)
    80003f1c:	64e2                	ld	s1,24(sp)
    80003f1e:	6942                	ld	s2,16(sp)
    80003f20:	69a2                	ld	s3,8(sp)
    80003f22:	6a02                	ld	s4,0(sp)
    80003f24:	6145                	addi	sp,sp,48
    80003f26:	8082                	ret
  return -1;
    80003f28:	557d                	li	a0,-1
    80003f2a:	b7fd                	j	80003f18 <pipealloc+0xc6>

0000000080003f2c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f2c:	1101                	addi	sp,sp,-32
    80003f2e:	ec06                	sd	ra,24(sp)
    80003f30:	e822                	sd	s0,16(sp)
    80003f32:	e426                	sd	s1,8(sp)
    80003f34:	e04a                	sd	s2,0(sp)
    80003f36:	1000                	addi	s0,sp,32
    80003f38:	84aa                	mv	s1,a0
    80003f3a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f3c:	00002097          	auipc	ra,0x2
    80003f40:	346080e7          	jalr	838(ra) # 80006282 <acquire>
  if(writable){
    80003f44:	02090d63          	beqz	s2,80003f7e <pipeclose+0x52>
    pi->writeopen = 0;
    80003f48:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f4c:	21848513          	addi	a0,s1,536
    80003f50:	ffffe097          	auipc	ra,0xffffe
    80003f54:	89e080e7          	jalr	-1890(ra) # 800017ee <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f58:	2204b783          	ld	a5,544(s1)
    80003f5c:	eb95                	bnez	a5,80003f90 <pipeclose+0x64>
    release(&pi->lock);
    80003f5e:	8526                	mv	a0,s1
    80003f60:	00002097          	auipc	ra,0x2
    80003f64:	3d6080e7          	jalr	982(ra) # 80006336 <release>
    kfree((char*)pi);
    80003f68:	8526                	mv	a0,s1
    80003f6a:	ffffc097          	auipc	ra,0xffffc
    80003f6e:	0b2080e7          	jalr	178(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f72:	60e2                	ld	ra,24(sp)
    80003f74:	6442                	ld	s0,16(sp)
    80003f76:	64a2                	ld	s1,8(sp)
    80003f78:	6902                	ld	s2,0(sp)
    80003f7a:	6105                	addi	sp,sp,32
    80003f7c:	8082                	ret
    pi->readopen = 0;
    80003f7e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f82:	21c48513          	addi	a0,s1,540
    80003f86:	ffffe097          	auipc	ra,0xffffe
    80003f8a:	868080e7          	jalr	-1944(ra) # 800017ee <wakeup>
    80003f8e:	b7e9                	j	80003f58 <pipeclose+0x2c>
    release(&pi->lock);
    80003f90:	8526                	mv	a0,s1
    80003f92:	00002097          	auipc	ra,0x2
    80003f96:	3a4080e7          	jalr	932(ra) # 80006336 <release>
}
    80003f9a:	bfe1                	j	80003f72 <pipeclose+0x46>

0000000080003f9c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f9c:	7159                	addi	sp,sp,-112
    80003f9e:	f486                	sd	ra,104(sp)
    80003fa0:	f0a2                	sd	s0,96(sp)
    80003fa2:	eca6                	sd	s1,88(sp)
    80003fa4:	e8ca                	sd	s2,80(sp)
    80003fa6:	e4ce                	sd	s3,72(sp)
    80003fa8:	e0d2                	sd	s4,64(sp)
    80003faa:	fc56                	sd	s5,56(sp)
    80003fac:	f85a                	sd	s6,48(sp)
    80003fae:	f45e                	sd	s7,40(sp)
    80003fb0:	f062                	sd	s8,32(sp)
    80003fb2:	ec66                	sd	s9,24(sp)
    80003fb4:	1880                	addi	s0,sp,112
    80003fb6:	84aa                	mv	s1,a0
    80003fb8:	8aae                	mv	s5,a1
    80003fba:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fbc:	ffffd097          	auipc	ra,0xffffd
    80003fc0:	fea080e7          	jalr	-22(ra) # 80000fa6 <myproc>
    80003fc4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	00002097          	auipc	ra,0x2
    80003fcc:	2ba080e7          	jalr	698(ra) # 80006282 <acquire>
  while(i < n){
    80003fd0:	0d405163          	blez	s4,80004092 <pipewrite+0xf6>
    80003fd4:	8ba6                	mv	s7,s1
  int i = 0;
    80003fd6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fd8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fda:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fde:	21c48c13          	addi	s8,s1,540
    80003fe2:	a08d                	j	80004044 <pipewrite+0xa8>
      release(&pi->lock);
    80003fe4:	8526                	mv	a0,s1
    80003fe6:	00002097          	auipc	ra,0x2
    80003fea:	350080e7          	jalr	848(ra) # 80006336 <release>
      return -1;
    80003fee:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ff0:	854a                	mv	a0,s2
    80003ff2:	70a6                	ld	ra,104(sp)
    80003ff4:	7406                	ld	s0,96(sp)
    80003ff6:	64e6                	ld	s1,88(sp)
    80003ff8:	6946                	ld	s2,80(sp)
    80003ffa:	69a6                	ld	s3,72(sp)
    80003ffc:	6a06                	ld	s4,64(sp)
    80003ffe:	7ae2                	ld	s5,56(sp)
    80004000:	7b42                	ld	s6,48(sp)
    80004002:	7ba2                	ld	s7,40(sp)
    80004004:	7c02                	ld	s8,32(sp)
    80004006:	6ce2                	ld	s9,24(sp)
    80004008:	6165                	addi	sp,sp,112
    8000400a:	8082                	ret
      wakeup(&pi->nread);
    8000400c:	8566                	mv	a0,s9
    8000400e:	ffffd097          	auipc	ra,0xffffd
    80004012:	7e0080e7          	jalr	2016(ra) # 800017ee <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004016:	85de                	mv	a1,s7
    80004018:	8562                	mv	a0,s8
    8000401a:	ffffd097          	auipc	ra,0xffffd
    8000401e:	648080e7          	jalr	1608(ra) # 80001662 <sleep>
    80004022:	a839                	j	80004040 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004024:	21c4a783          	lw	a5,540(s1)
    80004028:	0017871b          	addiw	a4,a5,1
    8000402c:	20e4ae23          	sw	a4,540(s1)
    80004030:	1ff7f793          	andi	a5,a5,511
    80004034:	97a6                	add	a5,a5,s1
    80004036:	f9f44703          	lbu	a4,-97(s0)
    8000403a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000403e:	2905                	addiw	s2,s2,1
  while(i < n){
    80004040:	03495d63          	bge	s2,s4,8000407a <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004044:	2204a783          	lw	a5,544(s1)
    80004048:	dfd1                	beqz	a5,80003fe4 <pipewrite+0x48>
    8000404a:	0289a783          	lw	a5,40(s3)
    8000404e:	fbd9                	bnez	a5,80003fe4 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004050:	2184a783          	lw	a5,536(s1)
    80004054:	21c4a703          	lw	a4,540(s1)
    80004058:	2007879b          	addiw	a5,a5,512
    8000405c:	faf708e3          	beq	a4,a5,8000400c <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004060:	4685                	li	a3,1
    80004062:	01590633          	add	a2,s2,s5
    80004066:	f9f40593          	addi	a1,s0,-97
    8000406a:	0509b503          	ld	a0,80(s3)
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	c86080e7          	jalr	-890(ra) # 80000cf4 <copyin>
    80004076:	fb6517e3          	bne	a0,s6,80004024 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000407a:	21848513          	addi	a0,s1,536
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	770080e7          	jalr	1904(ra) # 800017ee <wakeup>
  release(&pi->lock);
    80004086:	8526                	mv	a0,s1
    80004088:	00002097          	auipc	ra,0x2
    8000408c:	2ae080e7          	jalr	686(ra) # 80006336 <release>
  return i;
    80004090:	b785                	j	80003ff0 <pipewrite+0x54>
  int i = 0;
    80004092:	4901                	li	s2,0
    80004094:	b7dd                	j	8000407a <pipewrite+0xde>

0000000080004096 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004096:	715d                	addi	sp,sp,-80
    80004098:	e486                	sd	ra,72(sp)
    8000409a:	e0a2                	sd	s0,64(sp)
    8000409c:	fc26                	sd	s1,56(sp)
    8000409e:	f84a                	sd	s2,48(sp)
    800040a0:	f44e                	sd	s3,40(sp)
    800040a2:	f052                	sd	s4,32(sp)
    800040a4:	ec56                	sd	s5,24(sp)
    800040a6:	e85a                	sd	s6,16(sp)
    800040a8:	0880                	addi	s0,sp,80
    800040aa:	84aa                	mv	s1,a0
    800040ac:	892e                	mv	s2,a1
    800040ae:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040b0:	ffffd097          	auipc	ra,0xffffd
    800040b4:	ef6080e7          	jalr	-266(ra) # 80000fa6 <myproc>
    800040b8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040ba:	8b26                	mv	s6,s1
    800040bc:	8526                	mv	a0,s1
    800040be:	00002097          	auipc	ra,0x2
    800040c2:	1c4080e7          	jalr	452(ra) # 80006282 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040c6:	2184a703          	lw	a4,536(s1)
    800040ca:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040ce:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040d2:	02f71463          	bne	a4,a5,800040fa <piperead+0x64>
    800040d6:	2244a783          	lw	a5,548(s1)
    800040da:	c385                	beqz	a5,800040fa <piperead+0x64>
    if(pr->killed){
    800040dc:	028a2783          	lw	a5,40(s4)
    800040e0:	ebc1                	bnez	a5,80004170 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040e2:	85da                	mv	a1,s6
    800040e4:	854e                	mv	a0,s3
    800040e6:	ffffd097          	auipc	ra,0xffffd
    800040ea:	57c080e7          	jalr	1404(ra) # 80001662 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ee:	2184a703          	lw	a4,536(s1)
    800040f2:	21c4a783          	lw	a5,540(s1)
    800040f6:	fef700e3          	beq	a4,a5,800040d6 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040fa:	09505263          	blez	s5,8000417e <piperead+0xe8>
    800040fe:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004100:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004102:	2184a783          	lw	a5,536(s1)
    80004106:	21c4a703          	lw	a4,540(s1)
    8000410a:	02f70d63          	beq	a4,a5,80004144 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000410e:	0017871b          	addiw	a4,a5,1
    80004112:	20e4ac23          	sw	a4,536(s1)
    80004116:	1ff7f793          	andi	a5,a5,511
    8000411a:	97a6                	add	a5,a5,s1
    8000411c:	0187c783          	lbu	a5,24(a5)
    80004120:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004124:	4685                	li	a3,1
    80004126:	fbf40613          	addi	a2,s0,-65
    8000412a:	85ca                	mv	a1,s2
    8000412c:	050a3503          	ld	a0,80(s4)
    80004130:	ffffd097          	auipc	ra,0xffffd
    80004134:	aa6080e7          	jalr	-1370(ra) # 80000bd6 <copyout>
    80004138:	01650663          	beq	a0,s6,80004144 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000413c:	2985                	addiw	s3,s3,1
    8000413e:	0905                	addi	s2,s2,1
    80004140:	fd3a91e3          	bne	s5,s3,80004102 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004144:	21c48513          	addi	a0,s1,540
    80004148:	ffffd097          	auipc	ra,0xffffd
    8000414c:	6a6080e7          	jalr	1702(ra) # 800017ee <wakeup>
  release(&pi->lock);
    80004150:	8526                	mv	a0,s1
    80004152:	00002097          	auipc	ra,0x2
    80004156:	1e4080e7          	jalr	484(ra) # 80006336 <release>
  return i;
}
    8000415a:	854e                	mv	a0,s3
    8000415c:	60a6                	ld	ra,72(sp)
    8000415e:	6406                	ld	s0,64(sp)
    80004160:	74e2                	ld	s1,56(sp)
    80004162:	7942                	ld	s2,48(sp)
    80004164:	79a2                	ld	s3,40(sp)
    80004166:	7a02                	ld	s4,32(sp)
    80004168:	6ae2                	ld	s5,24(sp)
    8000416a:	6b42                	ld	s6,16(sp)
    8000416c:	6161                	addi	sp,sp,80
    8000416e:	8082                	ret
      release(&pi->lock);
    80004170:	8526                	mv	a0,s1
    80004172:	00002097          	auipc	ra,0x2
    80004176:	1c4080e7          	jalr	452(ra) # 80006336 <release>
      return -1;
    8000417a:	59fd                	li	s3,-1
    8000417c:	bff9                	j	8000415a <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000417e:	4981                	li	s3,0
    80004180:	b7d1                	j	80004144 <piperead+0xae>

0000000080004182 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004182:	df010113          	addi	sp,sp,-528
    80004186:	20113423          	sd	ra,520(sp)
    8000418a:	20813023          	sd	s0,512(sp)
    8000418e:	ffa6                	sd	s1,504(sp)
    80004190:	fbca                	sd	s2,496(sp)
    80004192:	f7ce                	sd	s3,488(sp)
    80004194:	f3d2                	sd	s4,480(sp)
    80004196:	efd6                	sd	s5,472(sp)
    80004198:	ebda                	sd	s6,464(sp)
    8000419a:	e7de                	sd	s7,456(sp)
    8000419c:	e3e2                	sd	s8,448(sp)
    8000419e:	ff66                	sd	s9,440(sp)
    800041a0:	fb6a                	sd	s10,432(sp)
    800041a2:	f76e                	sd	s11,424(sp)
    800041a4:	0c00                	addi	s0,sp,528
    800041a6:	84aa                	mv	s1,a0
    800041a8:	dea43c23          	sd	a0,-520(s0)
    800041ac:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041b0:	ffffd097          	auipc	ra,0xffffd
    800041b4:	df6080e7          	jalr	-522(ra) # 80000fa6 <myproc>
    800041b8:	892a                	mv	s2,a0

  begin_op();
    800041ba:	fffff097          	auipc	ra,0xfffff
    800041be:	49c080e7          	jalr	1180(ra) # 80003656 <begin_op>

  if((ip = namei(path)) == 0){
    800041c2:	8526                	mv	a0,s1
    800041c4:	fffff097          	auipc	ra,0xfffff
    800041c8:	276080e7          	jalr	630(ra) # 8000343a <namei>
    800041cc:	c92d                	beqz	a0,8000423e <exec+0xbc>
    800041ce:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041d0:	fffff097          	auipc	ra,0xfffff
    800041d4:	ab4080e7          	jalr	-1356(ra) # 80002c84 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041d8:	04000713          	li	a4,64
    800041dc:	4681                	li	a3,0
    800041de:	e5040613          	addi	a2,s0,-432
    800041e2:	4581                	li	a1,0
    800041e4:	8526                	mv	a0,s1
    800041e6:	fffff097          	auipc	ra,0xfffff
    800041ea:	d52080e7          	jalr	-686(ra) # 80002f38 <readi>
    800041ee:	04000793          	li	a5,64
    800041f2:	00f51a63          	bne	a0,a5,80004206 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041f6:	e5042703          	lw	a4,-432(s0)
    800041fa:	464c47b7          	lui	a5,0x464c4
    800041fe:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004202:	04f70463          	beq	a4,a5,8000424a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004206:	8526                	mv	a0,s1
    80004208:	fffff097          	auipc	ra,0xfffff
    8000420c:	cde080e7          	jalr	-802(ra) # 80002ee6 <iunlockput>
    end_op();
    80004210:	fffff097          	auipc	ra,0xfffff
    80004214:	4c6080e7          	jalr	1222(ra) # 800036d6 <end_op>
  }
  return -1;
    80004218:	557d                	li	a0,-1
}
    8000421a:	20813083          	ld	ra,520(sp)
    8000421e:	20013403          	ld	s0,512(sp)
    80004222:	74fe                	ld	s1,504(sp)
    80004224:	795e                	ld	s2,496(sp)
    80004226:	79be                	ld	s3,488(sp)
    80004228:	7a1e                	ld	s4,480(sp)
    8000422a:	6afe                	ld	s5,472(sp)
    8000422c:	6b5e                	ld	s6,464(sp)
    8000422e:	6bbe                	ld	s7,456(sp)
    80004230:	6c1e                	ld	s8,448(sp)
    80004232:	7cfa                	ld	s9,440(sp)
    80004234:	7d5a                	ld	s10,432(sp)
    80004236:	7dba                	ld	s11,424(sp)
    80004238:	21010113          	addi	sp,sp,528
    8000423c:	8082                	ret
    end_op();
    8000423e:	fffff097          	auipc	ra,0xfffff
    80004242:	498080e7          	jalr	1176(ra) # 800036d6 <end_op>
    return -1;
    80004246:	557d                	li	a0,-1
    80004248:	bfc9                	j	8000421a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000424a:	854a                	mv	a0,s2
    8000424c:	ffffd097          	auipc	ra,0xffffd
    80004250:	e1e080e7          	jalr	-482(ra) # 8000106a <proc_pagetable>
    80004254:	8baa                	mv	s7,a0
    80004256:	d945                	beqz	a0,80004206 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004258:	e7042983          	lw	s3,-400(s0)
    8000425c:	e8845783          	lhu	a5,-376(s0)
    80004260:	c7ad                	beqz	a5,800042ca <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004262:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004264:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004266:	6c85                	lui	s9,0x1
    80004268:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000426c:	def43823          	sd	a5,-528(s0)
    80004270:	a42d                	j	8000449a <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004272:	00004517          	auipc	a0,0x4
    80004276:	3d650513          	addi	a0,a0,982 # 80008648 <syscalls+0x280>
    8000427a:	00002097          	auipc	ra,0x2
    8000427e:	abe080e7          	jalr	-1346(ra) # 80005d38 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004282:	8756                	mv	a4,s5
    80004284:	012d86bb          	addw	a3,s11,s2
    80004288:	4581                	li	a1,0
    8000428a:	8526                	mv	a0,s1
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	cac080e7          	jalr	-852(ra) # 80002f38 <readi>
    80004294:	2501                	sext.w	a0,a0
    80004296:	1aaa9963          	bne	s5,a0,80004448 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    8000429a:	6785                	lui	a5,0x1
    8000429c:	0127893b          	addw	s2,a5,s2
    800042a0:	77fd                	lui	a5,0xfffff
    800042a2:	01478a3b          	addw	s4,a5,s4
    800042a6:	1f897163          	bgeu	s2,s8,80004488 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800042aa:	02091593          	slli	a1,s2,0x20
    800042ae:	9181                	srli	a1,a1,0x20
    800042b0:	95ea                	add	a1,a1,s10
    800042b2:	855e                	mv	a0,s7
    800042b4:	ffffc097          	auipc	ra,0xffffc
    800042b8:	2d4080e7          	jalr	724(ra) # 80000588 <walkaddr>
    800042bc:	862a                	mv	a2,a0
    if(pa == 0)
    800042be:	d955                	beqz	a0,80004272 <exec+0xf0>
      n = PGSIZE;
    800042c0:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042c2:	fd9a70e3          	bgeu	s4,s9,80004282 <exec+0x100>
      n = sz - i;
    800042c6:	8ad2                	mv	s5,s4
    800042c8:	bf6d                	j	80004282 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ca:	4901                	li	s2,0
  iunlockput(ip);
    800042cc:	8526                	mv	a0,s1
    800042ce:	fffff097          	auipc	ra,0xfffff
    800042d2:	c18080e7          	jalr	-1000(ra) # 80002ee6 <iunlockput>
  end_op();
    800042d6:	fffff097          	auipc	ra,0xfffff
    800042da:	400080e7          	jalr	1024(ra) # 800036d6 <end_op>
  p = myproc();
    800042de:	ffffd097          	auipc	ra,0xffffd
    800042e2:	cc8080e7          	jalr	-824(ra) # 80000fa6 <myproc>
    800042e6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042e8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042ec:	6785                	lui	a5,0x1
    800042ee:	17fd                	addi	a5,a5,-1
    800042f0:	993e                	add	s2,s2,a5
    800042f2:	757d                	lui	a0,0xfffff
    800042f4:	00a977b3          	and	a5,s2,a0
    800042f8:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042fc:	6609                	lui	a2,0x2
    800042fe:	963e                	add	a2,a2,a5
    80004300:	85be                	mv	a1,a5
    80004302:	855e                	mv	a0,s7
    80004304:	ffffc097          	auipc	ra,0xffffc
    80004308:	638080e7          	jalr	1592(ra) # 8000093c <uvmalloc>
    8000430c:	8b2a                	mv	s6,a0
  ip = 0;
    8000430e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004310:	12050c63          	beqz	a0,80004448 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004314:	75f9                	lui	a1,0xffffe
    80004316:	95aa                	add	a1,a1,a0
    80004318:	855e                	mv	a0,s7
    8000431a:	ffffd097          	auipc	ra,0xffffd
    8000431e:	866080e7          	jalr	-1946(ra) # 80000b80 <uvmclear>
  stackbase = sp - PGSIZE;
    80004322:	7c7d                	lui	s8,0xfffff
    80004324:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004326:	e0043783          	ld	a5,-512(s0)
    8000432a:	6388                	ld	a0,0(a5)
    8000432c:	c535                	beqz	a0,80004398 <exec+0x216>
    8000432e:	e9040993          	addi	s3,s0,-368
    80004332:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004336:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004338:	ffffc097          	auipc	ra,0xffffc
    8000433c:	046080e7          	jalr	70(ra) # 8000037e <strlen>
    80004340:	2505                	addiw	a0,a0,1
    80004342:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004346:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000434a:	13896363          	bltu	s2,s8,80004470 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000434e:	e0043d83          	ld	s11,-512(s0)
    80004352:	000dba03          	ld	s4,0(s11)
    80004356:	8552                	mv	a0,s4
    80004358:	ffffc097          	auipc	ra,0xffffc
    8000435c:	026080e7          	jalr	38(ra) # 8000037e <strlen>
    80004360:	0015069b          	addiw	a3,a0,1
    80004364:	8652                	mv	a2,s4
    80004366:	85ca                	mv	a1,s2
    80004368:	855e                	mv	a0,s7
    8000436a:	ffffd097          	auipc	ra,0xffffd
    8000436e:	86c080e7          	jalr	-1940(ra) # 80000bd6 <copyout>
    80004372:	10054363          	bltz	a0,80004478 <exec+0x2f6>
    ustack[argc] = sp;
    80004376:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000437a:	0485                	addi	s1,s1,1
    8000437c:	008d8793          	addi	a5,s11,8
    80004380:	e0f43023          	sd	a5,-512(s0)
    80004384:	008db503          	ld	a0,8(s11)
    80004388:	c911                	beqz	a0,8000439c <exec+0x21a>
    if(argc >= MAXARG)
    8000438a:	09a1                	addi	s3,s3,8
    8000438c:	fb3c96e3          	bne	s9,s3,80004338 <exec+0x1b6>
  sz = sz1;
    80004390:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004394:	4481                	li	s1,0
    80004396:	a84d                	j	80004448 <exec+0x2c6>
  sp = sz;
    80004398:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000439a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000439c:	00349793          	slli	a5,s1,0x3
    800043a0:	f9040713          	addi	a4,s0,-112
    800043a4:	97ba                	add	a5,a5,a4
    800043a6:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043aa:	00148693          	addi	a3,s1,1
    800043ae:	068e                	slli	a3,a3,0x3
    800043b0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043b4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043b8:	01897663          	bgeu	s2,s8,800043c4 <exec+0x242>
  sz = sz1;
    800043bc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043c0:	4481                	li	s1,0
    800043c2:	a059                	j	80004448 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043c4:	e9040613          	addi	a2,s0,-368
    800043c8:	85ca                	mv	a1,s2
    800043ca:	855e                	mv	a0,s7
    800043cc:	ffffd097          	auipc	ra,0xffffd
    800043d0:	80a080e7          	jalr	-2038(ra) # 80000bd6 <copyout>
    800043d4:	0a054663          	bltz	a0,80004480 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800043d8:	058ab783          	ld	a5,88(s5)
    800043dc:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043e0:	df843783          	ld	a5,-520(s0)
    800043e4:	0007c703          	lbu	a4,0(a5)
    800043e8:	cf11                	beqz	a4,80004404 <exec+0x282>
    800043ea:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043ec:	02f00693          	li	a3,47
    800043f0:	a039                	j	800043fe <exec+0x27c>
      last = s+1;
    800043f2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043f6:	0785                	addi	a5,a5,1
    800043f8:	fff7c703          	lbu	a4,-1(a5)
    800043fc:	c701                	beqz	a4,80004404 <exec+0x282>
    if(*s == '/')
    800043fe:	fed71ce3          	bne	a4,a3,800043f6 <exec+0x274>
    80004402:	bfc5                	j	800043f2 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004404:	4641                	li	a2,16
    80004406:	df843583          	ld	a1,-520(s0)
    8000440a:	158a8513          	addi	a0,s5,344
    8000440e:	ffffc097          	auipc	ra,0xffffc
    80004412:	f3e080e7          	jalr	-194(ra) # 8000034c <safestrcpy>
  oldpagetable = p->pagetable;
    80004416:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000441a:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000441e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004422:	058ab783          	ld	a5,88(s5)
    80004426:	e6843703          	ld	a4,-408(s0)
    8000442a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000442c:	058ab783          	ld	a5,88(s5)
    80004430:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004434:	85ea                	mv	a1,s10
    80004436:	ffffd097          	auipc	ra,0xffffd
    8000443a:	cd0080e7          	jalr	-816(ra) # 80001106 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000443e:	0004851b          	sext.w	a0,s1
    80004442:	bbe1                	j	8000421a <exec+0x98>
    80004444:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004448:	e0843583          	ld	a1,-504(s0)
    8000444c:	855e                	mv	a0,s7
    8000444e:	ffffd097          	auipc	ra,0xffffd
    80004452:	cb8080e7          	jalr	-840(ra) # 80001106 <proc_freepagetable>
  if(ip){
    80004456:	da0498e3          	bnez	s1,80004206 <exec+0x84>
  return -1;
    8000445a:	557d                	li	a0,-1
    8000445c:	bb7d                	j	8000421a <exec+0x98>
    8000445e:	e1243423          	sd	s2,-504(s0)
    80004462:	b7dd                	j	80004448 <exec+0x2c6>
    80004464:	e1243423          	sd	s2,-504(s0)
    80004468:	b7c5                	j	80004448 <exec+0x2c6>
    8000446a:	e1243423          	sd	s2,-504(s0)
    8000446e:	bfe9                	j	80004448 <exec+0x2c6>
  sz = sz1;
    80004470:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004474:	4481                	li	s1,0
    80004476:	bfc9                	j	80004448 <exec+0x2c6>
  sz = sz1;
    80004478:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000447c:	4481                	li	s1,0
    8000447e:	b7e9                	j	80004448 <exec+0x2c6>
  sz = sz1;
    80004480:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004484:	4481                	li	s1,0
    80004486:	b7c9                	j	80004448 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004488:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000448c:	2b05                	addiw	s6,s6,1
    8000448e:	0389899b          	addiw	s3,s3,56
    80004492:	e8845783          	lhu	a5,-376(s0)
    80004496:	e2fb5be3          	bge	s6,a5,800042cc <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000449a:	2981                	sext.w	s3,s3
    8000449c:	03800713          	li	a4,56
    800044a0:	86ce                	mv	a3,s3
    800044a2:	e1840613          	addi	a2,s0,-488
    800044a6:	4581                	li	a1,0
    800044a8:	8526                	mv	a0,s1
    800044aa:	fffff097          	auipc	ra,0xfffff
    800044ae:	a8e080e7          	jalr	-1394(ra) # 80002f38 <readi>
    800044b2:	03800793          	li	a5,56
    800044b6:	f8f517e3          	bne	a0,a5,80004444 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800044ba:	e1842783          	lw	a5,-488(s0)
    800044be:	4705                	li	a4,1
    800044c0:	fce796e3          	bne	a5,a4,8000448c <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800044c4:	e4043603          	ld	a2,-448(s0)
    800044c8:	e3843783          	ld	a5,-456(s0)
    800044cc:	f8f669e3          	bltu	a2,a5,8000445e <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044d0:	e2843783          	ld	a5,-472(s0)
    800044d4:	963e                	add	a2,a2,a5
    800044d6:	f8f667e3          	bltu	a2,a5,80004464 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044da:	85ca                	mv	a1,s2
    800044dc:	855e                	mv	a0,s7
    800044de:	ffffc097          	auipc	ra,0xffffc
    800044e2:	45e080e7          	jalr	1118(ra) # 8000093c <uvmalloc>
    800044e6:	e0a43423          	sd	a0,-504(s0)
    800044ea:	d141                	beqz	a0,8000446a <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800044ec:	e2843d03          	ld	s10,-472(s0)
    800044f0:	df043783          	ld	a5,-528(s0)
    800044f4:	00fd77b3          	and	a5,s10,a5
    800044f8:	fba1                	bnez	a5,80004448 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044fa:	e2042d83          	lw	s11,-480(s0)
    800044fe:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004502:	f80c03e3          	beqz	s8,80004488 <exec+0x306>
    80004506:	8a62                	mv	s4,s8
    80004508:	4901                	li	s2,0
    8000450a:	b345                	j	800042aa <exec+0x128>

000000008000450c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000450c:	7179                	addi	sp,sp,-48
    8000450e:	f406                	sd	ra,40(sp)
    80004510:	f022                	sd	s0,32(sp)
    80004512:	ec26                	sd	s1,24(sp)
    80004514:	e84a                	sd	s2,16(sp)
    80004516:	1800                	addi	s0,sp,48
    80004518:	892e                	mv	s2,a1
    8000451a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000451c:	fdc40593          	addi	a1,s0,-36
    80004520:	ffffe097          	auipc	ra,0xffffe
    80004524:	bf2080e7          	jalr	-1038(ra) # 80002112 <argint>
    80004528:	04054063          	bltz	a0,80004568 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000452c:	fdc42703          	lw	a4,-36(s0)
    80004530:	47bd                	li	a5,15
    80004532:	02e7ed63          	bltu	a5,a4,8000456c <argfd+0x60>
    80004536:	ffffd097          	auipc	ra,0xffffd
    8000453a:	a70080e7          	jalr	-1424(ra) # 80000fa6 <myproc>
    8000453e:	fdc42703          	lw	a4,-36(s0)
    80004542:	01a70793          	addi	a5,a4,26
    80004546:	078e                	slli	a5,a5,0x3
    80004548:	953e                	add	a0,a0,a5
    8000454a:	611c                	ld	a5,0(a0)
    8000454c:	c395                	beqz	a5,80004570 <argfd+0x64>
    return -1;
  if(pfd)
    8000454e:	00090463          	beqz	s2,80004556 <argfd+0x4a>
    *pfd = fd;
    80004552:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004556:	4501                	li	a0,0
  if(pf)
    80004558:	c091                	beqz	s1,8000455c <argfd+0x50>
    *pf = f;
    8000455a:	e09c                	sd	a5,0(s1)
}
    8000455c:	70a2                	ld	ra,40(sp)
    8000455e:	7402                	ld	s0,32(sp)
    80004560:	64e2                	ld	s1,24(sp)
    80004562:	6942                	ld	s2,16(sp)
    80004564:	6145                	addi	sp,sp,48
    80004566:	8082                	ret
    return -1;
    80004568:	557d                	li	a0,-1
    8000456a:	bfcd                	j	8000455c <argfd+0x50>
    return -1;
    8000456c:	557d                	li	a0,-1
    8000456e:	b7fd                	j	8000455c <argfd+0x50>
    80004570:	557d                	li	a0,-1
    80004572:	b7ed                	j	8000455c <argfd+0x50>

0000000080004574 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004574:	1101                	addi	sp,sp,-32
    80004576:	ec06                	sd	ra,24(sp)
    80004578:	e822                	sd	s0,16(sp)
    8000457a:	e426                	sd	s1,8(sp)
    8000457c:	1000                	addi	s0,sp,32
    8000457e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004580:	ffffd097          	auipc	ra,0xffffd
    80004584:	a26080e7          	jalr	-1498(ra) # 80000fa6 <myproc>
    80004588:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000458a:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7fdb8e90>
    8000458e:	4501                	li	a0,0
    80004590:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004592:	6398                	ld	a4,0(a5)
    80004594:	cb19                	beqz	a4,800045aa <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004596:	2505                	addiw	a0,a0,1
    80004598:	07a1                	addi	a5,a5,8
    8000459a:	fed51ce3          	bne	a0,a3,80004592 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000459e:	557d                	li	a0,-1
}
    800045a0:	60e2                	ld	ra,24(sp)
    800045a2:	6442                	ld	s0,16(sp)
    800045a4:	64a2                	ld	s1,8(sp)
    800045a6:	6105                	addi	sp,sp,32
    800045a8:	8082                	ret
      p->ofile[fd] = f;
    800045aa:	01a50793          	addi	a5,a0,26
    800045ae:	078e                	slli	a5,a5,0x3
    800045b0:	963e                	add	a2,a2,a5
    800045b2:	e204                	sd	s1,0(a2)
      return fd;
    800045b4:	b7f5                	j	800045a0 <fdalloc+0x2c>

00000000800045b6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045b6:	715d                	addi	sp,sp,-80
    800045b8:	e486                	sd	ra,72(sp)
    800045ba:	e0a2                	sd	s0,64(sp)
    800045bc:	fc26                	sd	s1,56(sp)
    800045be:	f84a                	sd	s2,48(sp)
    800045c0:	f44e                	sd	s3,40(sp)
    800045c2:	f052                	sd	s4,32(sp)
    800045c4:	ec56                	sd	s5,24(sp)
    800045c6:	0880                	addi	s0,sp,80
    800045c8:	89ae                	mv	s3,a1
    800045ca:	8ab2                	mv	s5,a2
    800045cc:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045ce:	fb040593          	addi	a1,s0,-80
    800045d2:	fffff097          	auipc	ra,0xfffff
    800045d6:	e86080e7          	jalr	-378(ra) # 80003458 <nameiparent>
    800045da:	892a                	mv	s2,a0
    800045dc:	12050f63          	beqz	a0,8000471a <create+0x164>
    return 0;

  ilock(dp);
    800045e0:	ffffe097          	auipc	ra,0xffffe
    800045e4:	6a4080e7          	jalr	1700(ra) # 80002c84 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045e8:	4601                	li	a2,0
    800045ea:	fb040593          	addi	a1,s0,-80
    800045ee:	854a                	mv	a0,s2
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	b78080e7          	jalr	-1160(ra) # 80003168 <dirlookup>
    800045f8:	84aa                	mv	s1,a0
    800045fa:	c921                	beqz	a0,8000464a <create+0x94>
    iunlockput(dp);
    800045fc:	854a                	mv	a0,s2
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	8e8080e7          	jalr	-1816(ra) # 80002ee6 <iunlockput>
    ilock(ip);
    80004606:	8526                	mv	a0,s1
    80004608:	ffffe097          	auipc	ra,0xffffe
    8000460c:	67c080e7          	jalr	1660(ra) # 80002c84 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004610:	2981                	sext.w	s3,s3
    80004612:	4789                	li	a5,2
    80004614:	02f99463          	bne	s3,a5,8000463c <create+0x86>
    80004618:	0444d783          	lhu	a5,68(s1)
    8000461c:	37f9                	addiw	a5,a5,-2
    8000461e:	17c2                	slli	a5,a5,0x30
    80004620:	93c1                	srli	a5,a5,0x30
    80004622:	4705                	li	a4,1
    80004624:	00f76c63          	bltu	a4,a5,8000463c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004628:	8526                	mv	a0,s1
    8000462a:	60a6                	ld	ra,72(sp)
    8000462c:	6406                	ld	s0,64(sp)
    8000462e:	74e2                	ld	s1,56(sp)
    80004630:	7942                	ld	s2,48(sp)
    80004632:	79a2                	ld	s3,40(sp)
    80004634:	7a02                	ld	s4,32(sp)
    80004636:	6ae2                	ld	s5,24(sp)
    80004638:	6161                	addi	sp,sp,80
    8000463a:	8082                	ret
    iunlockput(ip);
    8000463c:	8526                	mv	a0,s1
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	8a8080e7          	jalr	-1880(ra) # 80002ee6 <iunlockput>
    return 0;
    80004646:	4481                	li	s1,0
    80004648:	b7c5                	j	80004628 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000464a:	85ce                	mv	a1,s3
    8000464c:	00092503          	lw	a0,0(s2)
    80004650:	ffffe097          	auipc	ra,0xffffe
    80004654:	49c080e7          	jalr	1180(ra) # 80002aec <ialloc>
    80004658:	84aa                	mv	s1,a0
    8000465a:	c529                	beqz	a0,800046a4 <create+0xee>
  ilock(ip);
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	628080e7          	jalr	1576(ra) # 80002c84 <ilock>
  ip->major = major;
    80004664:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004668:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000466c:	4785                	li	a5,1
    8000466e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004672:	8526                	mv	a0,s1
    80004674:	ffffe097          	auipc	ra,0xffffe
    80004678:	546080e7          	jalr	1350(ra) # 80002bba <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000467c:	2981                	sext.w	s3,s3
    8000467e:	4785                	li	a5,1
    80004680:	02f98a63          	beq	s3,a5,800046b4 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004684:	40d0                	lw	a2,4(s1)
    80004686:	fb040593          	addi	a1,s0,-80
    8000468a:	854a                	mv	a0,s2
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	cec080e7          	jalr	-788(ra) # 80003378 <dirlink>
    80004694:	06054b63          	bltz	a0,8000470a <create+0x154>
  iunlockput(dp);
    80004698:	854a                	mv	a0,s2
    8000469a:	fffff097          	auipc	ra,0xfffff
    8000469e:	84c080e7          	jalr	-1972(ra) # 80002ee6 <iunlockput>
  return ip;
    800046a2:	b759                	j	80004628 <create+0x72>
    panic("create: ialloc");
    800046a4:	00004517          	auipc	a0,0x4
    800046a8:	fc450513          	addi	a0,a0,-60 # 80008668 <syscalls+0x2a0>
    800046ac:	00001097          	auipc	ra,0x1
    800046b0:	68c080e7          	jalr	1676(ra) # 80005d38 <panic>
    dp->nlink++;  // for ".."
    800046b4:	04a95783          	lhu	a5,74(s2)
    800046b8:	2785                	addiw	a5,a5,1
    800046ba:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046be:	854a                	mv	a0,s2
    800046c0:	ffffe097          	auipc	ra,0xffffe
    800046c4:	4fa080e7          	jalr	1274(ra) # 80002bba <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046c8:	40d0                	lw	a2,4(s1)
    800046ca:	00004597          	auipc	a1,0x4
    800046ce:	fae58593          	addi	a1,a1,-82 # 80008678 <syscalls+0x2b0>
    800046d2:	8526                	mv	a0,s1
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	ca4080e7          	jalr	-860(ra) # 80003378 <dirlink>
    800046dc:	00054f63          	bltz	a0,800046fa <create+0x144>
    800046e0:	00492603          	lw	a2,4(s2)
    800046e4:	00004597          	auipc	a1,0x4
    800046e8:	f9c58593          	addi	a1,a1,-100 # 80008680 <syscalls+0x2b8>
    800046ec:	8526                	mv	a0,s1
    800046ee:	fffff097          	auipc	ra,0xfffff
    800046f2:	c8a080e7          	jalr	-886(ra) # 80003378 <dirlink>
    800046f6:	f80557e3          	bgez	a0,80004684 <create+0xce>
      panic("create dots");
    800046fa:	00004517          	auipc	a0,0x4
    800046fe:	f8e50513          	addi	a0,a0,-114 # 80008688 <syscalls+0x2c0>
    80004702:	00001097          	auipc	ra,0x1
    80004706:	636080e7          	jalr	1590(ra) # 80005d38 <panic>
    panic("create: dirlink");
    8000470a:	00004517          	auipc	a0,0x4
    8000470e:	f8e50513          	addi	a0,a0,-114 # 80008698 <syscalls+0x2d0>
    80004712:	00001097          	auipc	ra,0x1
    80004716:	626080e7          	jalr	1574(ra) # 80005d38 <panic>
    return 0;
    8000471a:	84aa                	mv	s1,a0
    8000471c:	b731                	j	80004628 <create+0x72>

000000008000471e <sys_dup>:
{
    8000471e:	7179                	addi	sp,sp,-48
    80004720:	f406                	sd	ra,40(sp)
    80004722:	f022                	sd	s0,32(sp)
    80004724:	ec26                	sd	s1,24(sp)
    80004726:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004728:	fd840613          	addi	a2,s0,-40
    8000472c:	4581                	li	a1,0
    8000472e:	4501                	li	a0,0
    80004730:	00000097          	auipc	ra,0x0
    80004734:	ddc080e7          	jalr	-548(ra) # 8000450c <argfd>
    return -1;
    80004738:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000473a:	02054363          	bltz	a0,80004760 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000473e:	fd843503          	ld	a0,-40(s0)
    80004742:	00000097          	auipc	ra,0x0
    80004746:	e32080e7          	jalr	-462(ra) # 80004574 <fdalloc>
    8000474a:	84aa                	mv	s1,a0
    return -1;
    8000474c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000474e:	00054963          	bltz	a0,80004760 <sys_dup+0x42>
  filedup(f);
    80004752:	fd843503          	ld	a0,-40(s0)
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	37a080e7          	jalr	890(ra) # 80003ad0 <filedup>
  return fd;
    8000475e:	87a6                	mv	a5,s1
}
    80004760:	853e                	mv	a0,a5
    80004762:	70a2                	ld	ra,40(sp)
    80004764:	7402                	ld	s0,32(sp)
    80004766:	64e2                	ld	s1,24(sp)
    80004768:	6145                	addi	sp,sp,48
    8000476a:	8082                	ret

000000008000476c <sys_read>:
{
    8000476c:	7179                	addi	sp,sp,-48
    8000476e:	f406                	sd	ra,40(sp)
    80004770:	f022                	sd	s0,32(sp)
    80004772:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004774:	fe840613          	addi	a2,s0,-24
    80004778:	4581                	li	a1,0
    8000477a:	4501                	li	a0,0
    8000477c:	00000097          	auipc	ra,0x0
    80004780:	d90080e7          	jalr	-624(ra) # 8000450c <argfd>
    return -1;
    80004784:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004786:	04054163          	bltz	a0,800047c8 <sys_read+0x5c>
    8000478a:	fe440593          	addi	a1,s0,-28
    8000478e:	4509                	li	a0,2
    80004790:	ffffe097          	auipc	ra,0xffffe
    80004794:	982080e7          	jalr	-1662(ra) # 80002112 <argint>
    return -1;
    80004798:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000479a:	02054763          	bltz	a0,800047c8 <sys_read+0x5c>
    8000479e:	fd840593          	addi	a1,s0,-40
    800047a2:	4505                	li	a0,1
    800047a4:	ffffe097          	auipc	ra,0xffffe
    800047a8:	990080e7          	jalr	-1648(ra) # 80002134 <argaddr>
    return -1;
    800047ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ae:	00054d63          	bltz	a0,800047c8 <sys_read+0x5c>
  return fileread(f, p, n);
    800047b2:	fe442603          	lw	a2,-28(s0)
    800047b6:	fd843583          	ld	a1,-40(s0)
    800047ba:	fe843503          	ld	a0,-24(s0)
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	49e080e7          	jalr	1182(ra) # 80003c5c <fileread>
    800047c6:	87aa                	mv	a5,a0
}
    800047c8:	853e                	mv	a0,a5
    800047ca:	70a2                	ld	ra,40(sp)
    800047cc:	7402                	ld	s0,32(sp)
    800047ce:	6145                	addi	sp,sp,48
    800047d0:	8082                	ret

00000000800047d2 <sys_write>:
{
    800047d2:	7179                	addi	sp,sp,-48
    800047d4:	f406                	sd	ra,40(sp)
    800047d6:	f022                	sd	s0,32(sp)
    800047d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047da:	fe840613          	addi	a2,s0,-24
    800047de:	4581                	li	a1,0
    800047e0:	4501                	li	a0,0
    800047e2:	00000097          	auipc	ra,0x0
    800047e6:	d2a080e7          	jalr	-726(ra) # 8000450c <argfd>
    return -1;
    800047ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ec:	04054163          	bltz	a0,8000482e <sys_write+0x5c>
    800047f0:	fe440593          	addi	a1,s0,-28
    800047f4:	4509                	li	a0,2
    800047f6:	ffffe097          	auipc	ra,0xffffe
    800047fa:	91c080e7          	jalr	-1764(ra) # 80002112 <argint>
    return -1;
    800047fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004800:	02054763          	bltz	a0,8000482e <sys_write+0x5c>
    80004804:	fd840593          	addi	a1,s0,-40
    80004808:	4505                	li	a0,1
    8000480a:	ffffe097          	auipc	ra,0xffffe
    8000480e:	92a080e7          	jalr	-1750(ra) # 80002134 <argaddr>
    return -1;
    80004812:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004814:	00054d63          	bltz	a0,8000482e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004818:	fe442603          	lw	a2,-28(s0)
    8000481c:	fd843583          	ld	a1,-40(s0)
    80004820:	fe843503          	ld	a0,-24(s0)
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	4fa080e7          	jalr	1274(ra) # 80003d1e <filewrite>
    8000482c:	87aa                	mv	a5,a0
}
    8000482e:	853e                	mv	a0,a5
    80004830:	70a2                	ld	ra,40(sp)
    80004832:	7402                	ld	s0,32(sp)
    80004834:	6145                	addi	sp,sp,48
    80004836:	8082                	ret

0000000080004838 <sys_close>:
{
    80004838:	1101                	addi	sp,sp,-32
    8000483a:	ec06                	sd	ra,24(sp)
    8000483c:	e822                	sd	s0,16(sp)
    8000483e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004840:	fe040613          	addi	a2,s0,-32
    80004844:	fec40593          	addi	a1,s0,-20
    80004848:	4501                	li	a0,0
    8000484a:	00000097          	auipc	ra,0x0
    8000484e:	cc2080e7          	jalr	-830(ra) # 8000450c <argfd>
    return -1;
    80004852:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004854:	02054463          	bltz	a0,8000487c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004858:	ffffc097          	auipc	ra,0xffffc
    8000485c:	74e080e7          	jalr	1870(ra) # 80000fa6 <myproc>
    80004860:	fec42783          	lw	a5,-20(s0)
    80004864:	07e9                	addi	a5,a5,26
    80004866:	078e                	slli	a5,a5,0x3
    80004868:	97aa                	add	a5,a5,a0
    8000486a:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000486e:	fe043503          	ld	a0,-32(s0)
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	2b0080e7          	jalr	688(ra) # 80003b22 <fileclose>
  return 0;
    8000487a:	4781                	li	a5,0
}
    8000487c:	853e                	mv	a0,a5
    8000487e:	60e2                	ld	ra,24(sp)
    80004880:	6442                	ld	s0,16(sp)
    80004882:	6105                	addi	sp,sp,32
    80004884:	8082                	ret

0000000080004886 <sys_fstat>:
{
    80004886:	1101                	addi	sp,sp,-32
    80004888:	ec06                	sd	ra,24(sp)
    8000488a:	e822                	sd	s0,16(sp)
    8000488c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000488e:	fe840613          	addi	a2,s0,-24
    80004892:	4581                	li	a1,0
    80004894:	4501                	li	a0,0
    80004896:	00000097          	auipc	ra,0x0
    8000489a:	c76080e7          	jalr	-906(ra) # 8000450c <argfd>
    return -1;
    8000489e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048a0:	02054563          	bltz	a0,800048ca <sys_fstat+0x44>
    800048a4:	fe040593          	addi	a1,s0,-32
    800048a8:	4505                	li	a0,1
    800048aa:	ffffe097          	auipc	ra,0xffffe
    800048ae:	88a080e7          	jalr	-1910(ra) # 80002134 <argaddr>
    return -1;
    800048b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048b4:	00054b63          	bltz	a0,800048ca <sys_fstat+0x44>
  return filestat(f, st);
    800048b8:	fe043583          	ld	a1,-32(s0)
    800048bc:	fe843503          	ld	a0,-24(s0)
    800048c0:	fffff097          	auipc	ra,0xfffff
    800048c4:	32a080e7          	jalr	810(ra) # 80003bea <filestat>
    800048c8:	87aa                	mv	a5,a0
}
    800048ca:	853e                	mv	a0,a5
    800048cc:	60e2                	ld	ra,24(sp)
    800048ce:	6442                	ld	s0,16(sp)
    800048d0:	6105                	addi	sp,sp,32
    800048d2:	8082                	ret

00000000800048d4 <sys_link>:
{
    800048d4:	7169                	addi	sp,sp,-304
    800048d6:	f606                	sd	ra,296(sp)
    800048d8:	f222                	sd	s0,288(sp)
    800048da:	ee26                	sd	s1,280(sp)
    800048dc:	ea4a                	sd	s2,272(sp)
    800048de:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048e0:	08000613          	li	a2,128
    800048e4:	ed040593          	addi	a1,s0,-304
    800048e8:	4501                	li	a0,0
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	86c080e7          	jalr	-1940(ra) # 80002156 <argstr>
    return -1;
    800048f2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048f4:	10054e63          	bltz	a0,80004a10 <sys_link+0x13c>
    800048f8:	08000613          	li	a2,128
    800048fc:	f5040593          	addi	a1,s0,-176
    80004900:	4505                	li	a0,1
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	854080e7          	jalr	-1964(ra) # 80002156 <argstr>
    return -1;
    8000490a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000490c:	10054263          	bltz	a0,80004a10 <sys_link+0x13c>
  begin_op();
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	d46080e7          	jalr	-698(ra) # 80003656 <begin_op>
  if((ip = namei(old)) == 0){
    80004918:	ed040513          	addi	a0,s0,-304
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	b1e080e7          	jalr	-1250(ra) # 8000343a <namei>
    80004924:	84aa                	mv	s1,a0
    80004926:	c551                	beqz	a0,800049b2 <sys_link+0xde>
  ilock(ip);
    80004928:	ffffe097          	auipc	ra,0xffffe
    8000492c:	35c080e7          	jalr	860(ra) # 80002c84 <ilock>
  if(ip->type == T_DIR){
    80004930:	04449703          	lh	a4,68(s1)
    80004934:	4785                	li	a5,1
    80004936:	08f70463          	beq	a4,a5,800049be <sys_link+0xea>
  ip->nlink++;
    8000493a:	04a4d783          	lhu	a5,74(s1)
    8000493e:	2785                	addiw	a5,a5,1
    80004940:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004944:	8526                	mv	a0,s1
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	274080e7          	jalr	628(ra) # 80002bba <iupdate>
  iunlock(ip);
    8000494e:	8526                	mv	a0,s1
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	3f6080e7          	jalr	1014(ra) # 80002d46 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004958:	fd040593          	addi	a1,s0,-48
    8000495c:	f5040513          	addi	a0,s0,-176
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	af8080e7          	jalr	-1288(ra) # 80003458 <nameiparent>
    80004968:	892a                	mv	s2,a0
    8000496a:	c935                	beqz	a0,800049de <sys_link+0x10a>
  ilock(dp);
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	318080e7          	jalr	792(ra) # 80002c84 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004974:	00092703          	lw	a4,0(s2)
    80004978:	409c                	lw	a5,0(s1)
    8000497a:	04f71d63          	bne	a4,a5,800049d4 <sys_link+0x100>
    8000497e:	40d0                	lw	a2,4(s1)
    80004980:	fd040593          	addi	a1,s0,-48
    80004984:	854a                	mv	a0,s2
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	9f2080e7          	jalr	-1550(ra) # 80003378 <dirlink>
    8000498e:	04054363          	bltz	a0,800049d4 <sys_link+0x100>
  iunlockput(dp);
    80004992:	854a                	mv	a0,s2
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	552080e7          	jalr	1362(ra) # 80002ee6 <iunlockput>
  iput(ip);
    8000499c:	8526                	mv	a0,s1
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	4a0080e7          	jalr	1184(ra) # 80002e3e <iput>
  end_op();
    800049a6:	fffff097          	auipc	ra,0xfffff
    800049aa:	d30080e7          	jalr	-720(ra) # 800036d6 <end_op>
  return 0;
    800049ae:	4781                	li	a5,0
    800049b0:	a085                	j	80004a10 <sys_link+0x13c>
    end_op();
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	d24080e7          	jalr	-732(ra) # 800036d6 <end_op>
    return -1;
    800049ba:	57fd                	li	a5,-1
    800049bc:	a891                	j	80004a10 <sys_link+0x13c>
    iunlockput(ip);
    800049be:	8526                	mv	a0,s1
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	526080e7          	jalr	1318(ra) # 80002ee6 <iunlockput>
    end_op();
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	d0e080e7          	jalr	-754(ra) # 800036d6 <end_op>
    return -1;
    800049d0:	57fd                	li	a5,-1
    800049d2:	a83d                	j	80004a10 <sys_link+0x13c>
    iunlockput(dp);
    800049d4:	854a                	mv	a0,s2
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	510080e7          	jalr	1296(ra) # 80002ee6 <iunlockput>
  ilock(ip);
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	2a4080e7          	jalr	676(ra) # 80002c84 <ilock>
  ip->nlink--;
    800049e8:	04a4d783          	lhu	a5,74(s1)
    800049ec:	37fd                	addiw	a5,a5,-1
    800049ee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049f2:	8526                	mv	a0,s1
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	1c6080e7          	jalr	454(ra) # 80002bba <iupdate>
  iunlockput(ip);
    800049fc:	8526                	mv	a0,s1
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	4e8080e7          	jalr	1256(ra) # 80002ee6 <iunlockput>
  end_op();
    80004a06:	fffff097          	auipc	ra,0xfffff
    80004a0a:	cd0080e7          	jalr	-816(ra) # 800036d6 <end_op>
  return -1;
    80004a0e:	57fd                	li	a5,-1
}
    80004a10:	853e                	mv	a0,a5
    80004a12:	70b2                	ld	ra,296(sp)
    80004a14:	7412                	ld	s0,288(sp)
    80004a16:	64f2                	ld	s1,280(sp)
    80004a18:	6952                	ld	s2,272(sp)
    80004a1a:	6155                	addi	sp,sp,304
    80004a1c:	8082                	ret

0000000080004a1e <sys_unlink>:
{
    80004a1e:	7151                	addi	sp,sp,-240
    80004a20:	f586                	sd	ra,232(sp)
    80004a22:	f1a2                	sd	s0,224(sp)
    80004a24:	eda6                	sd	s1,216(sp)
    80004a26:	e9ca                	sd	s2,208(sp)
    80004a28:	e5ce                	sd	s3,200(sp)
    80004a2a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a2c:	08000613          	li	a2,128
    80004a30:	f3040593          	addi	a1,s0,-208
    80004a34:	4501                	li	a0,0
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	720080e7          	jalr	1824(ra) # 80002156 <argstr>
    80004a3e:	18054163          	bltz	a0,80004bc0 <sys_unlink+0x1a2>
  begin_op();
    80004a42:	fffff097          	auipc	ra,0xfffff
    80004a46:	c14080e7          	jalr	-1004(ra) # 80003656 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a4a:	fb040593          	addi	a1,s0,-80
    80004a4e:	f3040513          	addi	a0,s0,-208
    80004a52:	fffff097          	auipc	ra,0xfffff
    80004a56:	a06080e7          	jalr	-1530(ra) # 80003458 <nameiparent>
    80004a5a:	84aa                	mv	s1,a0
    80004a5c:	c979                	beqz	a0,80004b32 <sys_unlink+0x114>
  ilock(dp);
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	226080e7          	jalr	550(ra) # 80002c84 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a66:	00004597          	auipc	a1,0x4
    80004a6a:	c1258593          	addi	a1,a1,-1006 # 80008678 <syscalls+0x2b0>
    80004a6e:	fb040513          	addi	a0,s0,-80
    80004a72:	ffffe097          	auipc	ra,0xffffe
    80004a76:	6dc080e7          	jalr	1756(ra) # 8000314e <namecmp>
    80004a7a:	14050a63          	beqz	a0,80004bce <sys_unlink+0x1b0>
    80004a7e:	00004597          	auipc	a1,0x4
    80004a82:	c0258593          	addi	a1,a1,-1022 # 80008680 <syscalls+0x2b8>
    80004a86:	fb040513          	addi	a0,s0,-80
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	6c4080e7          	jalr	1732(ra) # 8000314e <namecmp>
    80004a92:	12050e63          	beqz	a0,80004bce <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a96:	f2c40613          	addi	a2,s0,-212
    80004a9a:	fb040593          	addi	a1,s0,-80
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	6c8080e7          	jalr	1736(ra) # 80003168 <dirlookup>
    80004aa8:	892a                	mv	s2,a0
    80004aaa:	12050263          	beqz	a0,80004bce <sys_unlink+0x1b0>
  ilock(ip);
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	1d6080e7          	jalr	470(ra) # 80002c84 <ilock>
  if(ip->nlink < 1)
    80004ab6:	04a91783          	lh	a5,74(s2)
    80004aba:	08f05263          	blez	a5,80004b3e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004abe:	04491703          	lh	a4,68(s2)
    80004ac2:	4785                	li	a5,1
    80004ac4:	08f70563          	beq	a4,a5,80004b4e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ac8:	4641                	li	a2,16
    80004aca:	4581                	li	a1,0
    80004acc:	fc040513          	addi	a0,s0,-64
    80004ad0:	ffffb097          	auipc	ra,0xffffb
    80004ad4:	72a080e7          	jalr	1834(ra) # 800001fa <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ad8:	4741                	li	a4,16
    80004ada:	f2c42683          	lw	a3,-212(s0)
    80004ade:	fc040613          	addi	a2,s0,-64
    80004ae2:	4581                	li	a1,0
    80004ae4:	8526                	mv	a0,s1
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	54a080e7          	jalr	1354(ra) # 80003030 <writei>
    80004aee:	47c1                	li	a5,16
    80004af0:	0af51563          	bne	a0,a5,80004b9a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004af4:	04491703          	lh	a4,68(s2)
    80004af8:	4785                	li	a5,1
    80004afa:	0af70863          	beq	a4,a5,80004baa <sys_unlink+0x18c>
  iunlockput(dp);
    80004afe:	8526                	mv	a0,s1
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	3e6080e7          	jalr	998(ra) # 80002ee6 <iunlockput>
  ip->nlink--;
    80004b08:	04a95783          	lhu	a5,74(s2)
    80004b0c:	37fd                	addiw	a5,a5,-1
    80004b0e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b12:	854a                	mv	a0,s2
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	0a6080e7          	jalr	166(ra) # 80002bba <iupdate>
  iunlockput(ip);
    80004b1c:	854a                	mv	a0,s2
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	3c8080e7          	jalr	968(ra) # 80002ee6 <iunlockput>
  end_op();
    80004b26:	fffff097          	auipc	ra,0xfffff
    80004b2a:	bb0080e7          	jalr	-1104(ra) # 800036d6 <end_op>
  return 0;
    80004b2e:	4501                	li	a0,0
    80004b30:	a84d                	j	80004be2 <sys_unlink+0x1c4>
    end_op();
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	ba4080e7          	jalr	-1116(ra) # 800036d6 <end_op>
    return -1;
    80004b3a:	557d                	li	a0,-1
    80004b3c:	a05d                	j	80004be2 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b3e:	00004517          	auipc	a0,0x4
    80004b42:	b6a50513          	addi	a0,a0,-1174 # 800086a8 <syscalls+0x2e0>
    80004b46:	00001097          	auipc	ra,0x1
    80004b4a:	1f2080e7          	jalr	498(ra) # 80005d38 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b4e:	04c92703          	lw	a4,76(s2)
    80004b52:	02000793          	li	a5,32
    80004b56:	f6e7f9e3          	bgeu	a5,a4,80004ac8 <sys_unlink+0xaa>
    80004b5a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b5e:	4741                	li	a4,16
    80004b60:	86ce                	mv	a3,s3
    80004b62:	f1840613          	addi	a2,s0,-232
    80004b66:	4581                	li	a1,0
    80004b68:	854a                	mv	a0,s2
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	3ce080e7          	jalr	974(ra) # 80002f38 <readi>
    80004b72:	47c1                	li	a5,16
    80004b74:	00f51b63          	bne	a0,a5,80004b8a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b78:	f1845783          	lhu	a5,-232(s0)
    80004b7c:	e7a1                	bnez	a5,80004bc4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b7e:	29c1                	addiw	s3,s3,16
    80004b80:	04c92783          	lw	a5,76(s2)
    80004b84:	fcf9ede3          	bltu	s3,a5,80004b5e <sys_unlink+0x140>
    80004b88:	b781                	j	80004ac8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b8a:	00004517          	auipc	a0,0x4
    80004b8e:	b3650513          	addi	a0,a0,-1226 # 800086c0 <syscalls+0x2f8>
    80004b92:	00001097          	auipc	ra,0x1
    80004b96:	1a6080e7          	jalr	422(ra) # 80005d38 <panic>
    panic("unlink: writei");
    80004b9a:	00004517          	auipc	a0,0x4
    80004b9e:	b3e50513          	addi	a0,a0,-1218 # 800086d8 <syscalls+0x310>
    80004ba2:	00001097          	auipc	ra,0x1
    80004ba6:	196080e7          	jalr	406(ra) # 80005d38 <panic>
    dp->nlink--;
    80004baa:	04a4d783          	lhu	a5,74(s1)
    80004bae:	37fd                	addiw	a5,a5,-1
    80004bb0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bb4:	8526                	mv	a0,s1
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	004080e7          	jalr	4(ra) # 80002bba <iupdate>
    80004bbe:	b781                	j	80004afe <sys_unlink+0xe0>
    return -1;
    80004bc0:	557d                	li	a0,-1
    80004bc2:	a005                	j	80004be2 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bc4:	854a                	mv	a0,s2
    80004bc6:	ffffe097          	auipc	ra,0xffffe
    80004bca:	320080e7          	jalr	800(ra) # 80002ee6 <iunlockput>
  iunlockput(dp);
    80004bce:	8526                	mv	a0,s1
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	316080e7          	jalr	790(ra) # 80002ee6 <iunlockput>
  end_op();
    80004bd8:	fffff097          	auipc	ra,0xfffff
    80004bdc:	afe080e7          	jalr	-1282(ra) # 800036d6 <end_op>
  return -1;
    80004be0:	557d                	li	a0,-1
}
    80004be2:	70ae                	ld	ra,232(sp)
    80004be4:	740e                	ld	s0,224(sp)
    80004be6:	64ee                	ld	s1,216(sp)
    80004be8:	694e                	ld	s2,208(sp)
    80004bea:	69ae                	ld	s3,200(sp)
    80004bec:	616d                	addi	sp,sp,240
    80004bee:	8082                	ret

0000000080004bf0 <sys_open>:

uint64
sys_open(void)
{
    80004bf0:	7131                	addi	sp,sp,-192
    80004bf2:	fd06                	sd	ra,184(sp)
    80004bf4:	f922                	sd	s0,176(sp)
    80004bf6:	f526                	sd	s1,168(sp)
    80004bf8:	f14a                	sd	s2,160(sp)
    80004bfa:	ed4e                	sd	s3,152(sp)
    80004bfc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004bfe:	08000613          	li	a2,128
    80004c02:	f5040593          	addi	a1,s0,-176
    80004c06:	4501                	li	a0,0
    80004c08:	ffffd097          	auipc	ra,0xffffd
    80004c0c:	54e080e7          	jalr	1358(ra) # 80002156 <argstr>
    return -1;
    80004c10:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c12:	0c054163          	bltz	a0,80004cd4 <sys_open+0xe4>
    80004c16:	f4c40593          	addi	a1,s0,-180
    80004c1a:	4505                	li	a0,1
    80004c1c:	ffffd097          	auipc	ra,0xffffd
    80004c20:	4f6080e7          	jalr	1270(ra) # 80002112 <argint>
    80004c24:	0a054863          	bltz	a0,80004cd4 <sys_open+0xe4>

  begin_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	a2e080e7          	jalr	-1490(ra) # 80003656 <begin_op>

  if(omode & O_CREATE){
    80004c30:	f4c42783          	lw	a5,-180(s0)
    80004c34:	2007f793          	andi	a5,a5,512
    80004c38:	cbdd                	beqz	a5,80004cee <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c3a:	4681                	li	a3,0
    80004c3c:	4601                	li	a2,0
    80004c3e:	4589                	li	a1,2
    80004c40:	f5040513          	addi	a0,s0,-176
    80004c44:	00000097          	auipc	ra,0x0
    80004c48:	972080e7          	jalr	-1678(ra) # 800045b6 <create>
    80004c4c:	892a                	mv	s2,a0
    if(ip == 0){
    80004c4e:	c959                	beqz	a0,80004ce4 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c50:	04491703          	lh	a4,68(s2)
    80004c54:	478d                	li	a5,3
    80004c56:	00f71763          	bne	a4,a5,80004c64 <sys_open+0x74>
    80004c5a:	04695703          	lhu	a4,70(s2)
    80004c5e:	47a5                	li	a5,9
    80004c60:	0ce7ec63          	bltu	a5,a4,80004d38 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c64:	fffff097          	auipc	ra,0xfffff
    80004c68:	e02080e7          	jalr	-510(ra) # 80003a66 <filealloc>
    80004c6c:	89aa                	mv	s3,a0
    80004c6e:	10050263          	beqz	a0,80004d72 <sys_open+0x182>
    80004c72:	00000097          	auipc	ra,0x0
    80004c76:	902080e7          	jalr	-1790(ra) # 80004574 <fdalloc>
    80004c7a:	84aa                	mv	s1,a0
    80004c7c:	0e054663          	bltz	a0,80004d68 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c80:	04491703          	lh	a4,68(s2)
    80004c84:	478d                	li	a5,3
    80004c86:	0cf70463          	beq	a4,a5,80004d4e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c8a:	4789                	li	a5,2
    80004c8c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c90:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c94:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c98:	f4c42783          	lw	a5,-180(s0)
    80004c9c:	0017c713          	xori	a4,a5,1
    80004ca0:	8b05                	andi	a4,a4,1
    80004ca2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ca6:	0037f713          	andi	a4,a5,3
    80004caa:	00e03733          	snez	a4,a4
    80004cae:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cb2:	4007f793          	andi	a5,a5,1024
    80004cb6:	c791                	beqz	a5,80004cc2 <sys_open+0xd2>
    80004cb8:	04491703          	lh	a4,68(s2)
    80004cbc:	4789                	li	a5,2
    80004cbe:	08f70f63          	beq	a4,a5,80004d5c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cc2:	854a                	mv	a0,s2
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	082080e7          	jalr	130(ra) # 80002d46 <iunlock>
  end_op();
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	a0a080e7          	jalr	-1526(ra) # 800036d6 <end_op>

  return fd;
}
    80004cd4:	8526                	mv	a0,s1
    80004cd6:	70ea                	ld	ra,184(sp)
    80004cd8:	744a                	ld	s0,176(sp)
    80004cda:	74aa                	ld	s1,168(sp)
    80004cdc:	790a                	ld	s2,160(sp)
    80004cde:	69ea                	ld	s3,152(sp)
    80004ce0:	6129                	addi	sp,sp,192
    80004ce2:	8082                	ret
      end_op();
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	9f2080e7          	jalr	-1550(ra) # 800036d6 <end_op>
      return -1;
    80004cec:	b7e5                	j	80004cd4 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004cee:	f5040513          	addi	a0,s0,-176
    80004cf2:	ffffe097          	auipc	ra,0xffffe
    80004cf6:	748080e7          	jalr	1864(ra) # 8000343a <namei>
    80004cfa:	892a                	mv	s2,a0
    80004cfc:	c905                	beqz	a0,80004d2c <sys_open+0x13c>
    ilock(ip);
    80004cfe:	ffffe097          	auipc	ra,0xffffe
    80004d02:	f86080e7          	jalr	-122(ra) # 80002c84 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d06:	04491703          	lh	a4,68(s2)
    80004d0a:	4785                	li	a5,1
    80004d0c:	f4f712e3          	bne	a4,a5,80004c50 <sys_open+0x60>
    80004d10:	f4c42783          	lw	a5,-180(s0)
    80004d14:	dba1                	beqz	a5,80004c64 <sys_open+0x74>
      iunlockput(ip);
    80004d16:	854a                	mv	a0,s2
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	1ce080e7          	jalr	462(ra) # 80002ee6 <iunlockput>
      end_op();
    80004d20:	fffff097          	auipc	ra,0xfffff
    80004d24:	9b6080e7          	jalr	-1610(ra) # 800036d6 <end_op>
      return -1;
    80004d28:	54fd                	li	s1,-1
    80004d2a:	b76d                	j	80004cd4 <sys_open+0xe4>
      end_op();
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	9aa080e7          	jalr	-1622(ra) # 800036d6 <end_op>
      return -1;
    80004d34:	54fd                	li	s1,-1
    80004d36:	bf79                	j	80004cd4 <sys_open+0xe4>
    iunlockput(ip);
    80004d38:	854a                	mv	a0,s2
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	1ac080e7          	jalr	428(ra) # 80002ee6 <iunlockput>
    end_op();
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	994080e7          	jalr	-1644(ra) # 800036d6 <end_op>
    return -1;
    80004d4a:	54fd                	li	s1,-1
    80004d4c:	b761                	j	80004cd4 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d4e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d52:	04691783          	lh	a5,70(s2)
    80004d56:	02f99223          	sh	a5,36(s3)
    80004d5a:	bf2d                	j	80004c94 <sys_open+0xa4>
    itrunc(ip);
    80004d5c:	854a                	mv	a0,s2
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	034080e7          	jalr	52(ra) # 80002d92 <itrunc>
    80004d66:	bfb1                	j	80004cc2 <sys_open+0xd2>
      fileclose(f);
    80004d68:	854e                	mv	a0,s3
    80004d6a:	fffff097          	auipc	ra,0xfffff
    80004d6e:	db8080e7          	jalr	-584(ra) # 80003b22 <fileclose>
    iunlockput(ip);
    80004d72:	854a                	mv	a0,s2
    80004d74:	ffffe097          	auipc	ra,0xffffe
    80004d78:	172080e7          	jalr	370(ra) # 80002ee6 <iunlockput>
    end_op();
    80004d7c:	fffff097          	auipc	ra,0xfffff
    80004d80:	95a080e7          	jalr	-1702(ra) # 800036d6 <end_op>
    return -1;
    80004d84:	54fd                	li	s1,-1
    80004d86:	b7b9                	j	80004cd4 <sys_open+0xe4>

0000000080004d88 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d88:	7175                	addi	sp,sp,-144
    80004d8a:	e506                	sd	ra,136(sp)
    80004d8c:	e122                	sd	s0,128(sp)
    80004d8e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	8c6080e7          	jalr	-1850(ra) # 80003656 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d98:	08000613          	li	a2,128
    80004d9c:	f7040593          	addi	a1,s0,-144
    80004da0:	4501                	li	a0,0
    80004da2:	ffffd097          	auipc	ra,0xffffd
    80004da6:	3b4080e7          	jalr	948(ra) # 80002156 <argstr>
    80004daa:	02054963          	bltz	a0,80004ddc <sys_mkdir+0x54>
    80004dae:	4681                	li	a3,0
    80004db0:	4601                	li	a2,0
    80004db2:	4585                	li	a1,1
    80004db4:	f7040513          	addi	a0,s0,-144
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	7fe080e7          	jalr	2046(ra) # 800045b6 <create>
    80004dc0:	cd11                	beqz	a0,80004ddc <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dc2:	ffffe097          	auipc	ra,0xffffe
    80004dc6:	124080e7          	jalr	292(ra) # 80002ee6 <iunlockput>
  end_op();
    80004dca:	fffff097          	auipc	ra,0xfffff
    80004dce:	90c080e7          	jalr	-1780(ra) # 800036d6 <end_op>
  return 0;
    80004dd2:	4501                	li	a0,0
}
    80004dd4:	60aa                	ld	ra,136(sp)
    80004dd6:	640a                	ld	s0,128(sp)
    80004dd8:	6149                	addi	sp,sp,144
    80004dda:	8082                	ret
    end_op();
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	8fa080e7          	jalr	-1798(ra) # 800036d6 <end_op>
    return -1;
    80004de4:	557d                	li	a0,-1
    80004de6:	b7fd                	j	80004dd4 <sys_mkdir+0x4c>

0000000080004de8 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004de8:	7135                	addi	sp,sp,-160
    80004dea:	ed06                	sd	ra,152(sp)
    80004dec:	e922                	sd	s0,144(sp)
    80004dee:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004df0:	fffff097          	auipc	ra,0xfffff
    80004df4:	866080e7          	jalr	-1946(ra) # 80003656 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004df8:	08000613          	li	a2,128
    80004dfc:	f7040593          	addi	a1,s0,-144
    80004e00:	4501                	li	a0,0
    80004e02:	ffffd097          	auipc	ra,0xffffd
    80004e06:	354080e7          	jalr	852(ra) # 80002156 <argstr>
    80004e0a:	04054a63          	bltz	a0,80004e5e <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e0e:	f6c40593          	addi	a1,s0,-148
    80004e12:	4505                	li	a0,1
    80004e14:	ffffd097          	auipc	ra,0xffffd
    80004e18:	2fe080e7          	jalr	766(ra) # 80002112 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e1c:	04054163          	bltz	a0,80004e5e <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e20:	f6840593          	addi	a1,s0,-152
    80004e24:	4509                	li	a0,2
    80004e26:	ffffd097          	auipc	ra,0xffffd
    80004e2a:	2ec080e7          	jalr	748(ra) # 80002112 <argint>
     argint(1, &major) < 0 ||
    80004e2e:	02054863          	bltz	a0,80004e5e <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e32:	f6841683          	lh	a3,-152(s0)
    80004e36:	f6c41603          	lh	a2,-148(s0)
    80004e3a:	458d                	li	a1,3
    80004e3c:	f7040513          	addi	a0,s0,-144
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	776080e7          	jalr	1910(ra) # 800045b6 <create>
     argint(2, &minor) < 0 ||
    80004e48:	c919                	beqz	a0,80004e5e <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e4a:	ffffe097          	auipc	ra,0xffffe
    80004e4e:	09c080e7          	jalr	156(ra) # 80002ee6 <iunlockput>
  end_op();
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	884080e7          	jalr	-1916(ra) # 800036d6 <end_op>
  return 0;
    80004e5a:	4501                	li	a0,0
    80004e5c:	a031                	j	80004e68 <sys_mknod+0x80>
    end_op();
    80004e5e:	fffff097          	auipc	ra,0xfffff
    80004e62:	878080e7          	jalr	-1928(ra) # 800036d6 <end_op>
    return -1;
    80004e66:	557d                	li	a0,-1
}
    80004e68:	60ea                	ld	ra,152(sp)
    80004e6a:	644a                	ld	s0,144(sp)
    80004e6c:	610d                	addi	sp,sp,160
    80004e6e:	8082                	ret

0000000080004e70 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e70:	7135                	addi	sp,sp,-160
    80004e72:	ed06                	sd	ra,152(sp)
    80004e74:	e922                	sd	s0,144(sp)
    80004e76:	e526                	sd	s1,136(sp)
    80004e78:	e14a                	sd	s2,128(sp)
    80004e7a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e7c:	ffffc097          	auipc	ra,0xffffc
    80004e80:	12a080e7          	jalr	298(ra) # 80000fa6 <myproc>
    80004e84:	892a                	mv	s2,a0
  
  begin_op();
    80004e86:	ffffe097          	auipc	ra,0xffffe
    80004e8a:	7d0080e7          	jalr	2000(ra) # 80003656 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e8e:	08000613          	li	a2,128
    80004e92:	f6040593          	addi	a1,s0,-160
    80004e96:	4501                	li	a0,0
    80004e98:	ffffd097          	auipc	ra,0xffffd
    80004e9c:	2be080e7          	jalr	702(ra) # 80002156 <argstr>
    80004ea0:	04054b63          	bltz	a0,80004ef6 <sys_chdir+0x86>
    80004ea4:	f6040513          	addi	a0,s0,-160
    80004ea8:	ffffe097          	auipc	ra,0xffffe
    80004eac:	592080e7          	jalr	1426(ra) # 8000343a <namei>
    80004eb0:	84aa                	mv	s1,a0
    80004eb2:	c131                	beqz	a0,80004ef6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	dd0080e7          	jalr	-560(ra) # 80002c84 <ilock>
  if(ip->type != T_DIR){
    80004ebc:	04449703          	lh	a4,68(s1)
    80004ec0:	4785                	li	a5,1
    80004ec2:	04f71063          	bne	a4,a5,80004f02 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ec6:	8526                	mv	a0,s1
    80004ec8:	ffffe097          	auipc	ra,0xffffe
    80004ecc:	e7e080e7          	jalr	-386(ra) # 80002d46 <iunlock>
  iput(p->cwd);
    80004ed0:	15093503          	ld	a0,336(s2)
    80004ed4:	ffffe097          	auipc	ra,0xffffe
    80004ed8:	f6a080e7          	jalr	-150(ra) # 80002e3e <iput>
  end_op();
    80004edc:	ffffe097          	auipc	ra,0xffffe
    80004ee0:	7fa080e7          	jalr	2042(ra) # 800036d6 <end_op>
  p->cwd = ip;
    80004ee4:	14993823          	sd	s1,336(s2)
  return 0;
    80004ee8:	4501                	li	a0,0
}
    80004eea:	60ea                	ld	ra,152(sp)
    80004eec:	644a                	ld	s0,144(sp)
    80004eee:	64aa                	ld	s1,136(sp)
    80004ef0:	690a                	ld	s2,128(sp)
    80004ef2:	610d                	addi	sp,sp,160
    80004ef4:	8082                	ret
    end_op();
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	7e0080e7          	jalr	2016(ra) # 800036d6 <end_op>
    return -1;
    80004efe:	557d                	li	a0,-1
    80004f00:	b7ed                	j	80004eea <sys_chdir+0x7a>
    iunlockput(ip);
    80004f02:	8526                	mv	a0,s1
    80004f04:	ffffe097          	auipc	ra,0xffffe
    80004f08:	fe2080e7          	jalr	-30(ra) # 80002ee6 <iunlockput>
    end_op();
    80004f0c:	ffffe097          	auipc	ra,0xffffe
    80004f10:	7ca080e7          	jalr	1994(ra) # 800036d6 <end_op>
    return -1;
    80004f14:	557d                	li	a0,-1
    80004f16:	bfd1                	j	80004eea <sys_chdir+0x7a>

0000000080004f18 <sys_exec>:

uint64
sys_exec(void)
{
    80004f18:	7145                	addi	sp,sp,-464
    80004f1a:	e786                	sd	ra,456(sp)
    80004f1c:	e3a2                	sd	s0,448(sp)
    80004f1e:	ff26                	sd	s1,440(sp)
    80004f20:	fb4a                	sd	s2,432(sp)
    80004f22:	f74e                	sd	s3,424(sp)
    80004f24:	f352                	sd	s4,416(sp)
    80004f26:	ef56                	sd	s5,408(sp)
    80004f28:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f2a:	08000613          	li	a2,128
    80004f2e:	f4040593          	addi	a1,s0,-192
    80004f32:	4501                	li	a0,0
    80004f34:	ffffd097          	auipc	ra,0xffffd
    80004f38:	222080e7          	jalr	546(ra) # 80002156 <argstr>
    return -1;
    80004f3c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f3e:	0c054a63          	bltz	a0,80005012 <sys_exec+0xfa>
    80004f42:	e3840593          	addi	a1,s0,-456
    80004f46:	4505                	li	a0,1
    80004f48:	ffffd097          	auipc	ra,0xffffd
    80004f4c:	1ec080e7          	jalr	492(ra) # 80002134 <argaddr>
    80004f50:	0c054163          	bltz	a0,80005012 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f54:	10000613          	li	a2,256
    80004f58:	4581                	li	a1,0
    80004f5a:	e4040513          	addi	a0,s0,-448
    80004f5e:	ffffb097          	auipc	ra,0xffffb
    80004f62:	29c080e7          	jalr	668(ra) # 800001fa <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f66:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f6a:	89a6                	mv	s3,s1
    80004f6c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f6e:	02000a13          	li	s4,32
    80004f72:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f76:	00391513          	slli	a0,s2,0x3
    80004f7a:	e3040593          	addi	a1,s0,-464
    80004f7e:	e3843783          	ld	a5,-456(s0)
    80004f82:	953e                	add	a0,a0,a5
    80004f84:	ffffd097          	auipc	ra,0xffffd
    80004f88:	0f4080e7          	jalr	244(ra) # 80002078 <fetchaddr>
    80004f8c:	02054a63          	bltz	a0,80004fc0 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f90:	e3043783          	ld	a5,-464(s0)
    80004f94:	c3b9                	beqz	a5,80004fda <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f96:	ffffb097          	auipc	ra,0xffffb
    80004f9a:	1c8080e7          	jalr	456(ra) # 8000015e <kalloc>
    80004f9e:	85aa                	mv	a1,a0
    80004fa0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fa4:	cd11                	beqz	a0,80004fc0 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fa6:	6605                	lui	a2,0x1
    80004fa8:	e3043503          	ld	a0,-464(s0)
    80004fac:	ffffd097          	auipc	ra,0xffffd
    80004fb0:	11e080e7          	jalr	286(ra) # 800020ca <fetchstr>
    80004fb4:	00054663          	bltz	a0,80004fc0 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004fb8:	0905                	addi	s2,s2,1
    80004fba:	09a1                	addi	s3,s3,8
    80004fbc:	fb491be3          	bne	s2,s4,80004f72 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fc0:	10048913          	addi	s2,s1,256
    80004fc4:	6088                	ld	a0,0(s1)
    80004fc6:	c529                	beqz	a0,80005010 <sys_exec+0xf8>
    kfree(argv[i]);
    80004fc8:	ffffb097          	auipc	ra,0xffffb
    80004fcc:	054080e7          	jalr	84(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fd0:	04a1                	addi	s1,s1,8
    80004fd2:	ff2499e3          	bne	s1,s2,80004fc4 <sys_exec+0xac>
  return -1;
    80004fd6:	597d                	li	s2,-1
    80004fd8:	a82d                	j	80005012 <sys_exec+0xfa>
      argv[i] = 0;
    80004fda:	0a8e                	slli	s5,s5,0x3
    80004fdc:	fc040793          	addi	a5,s0,-64
    80004fe0:	9abe                	add	s5,s5,a5
    80004fe2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fe6:	e4040593          	addi	a1,s0,-448
    80004fea:	f4040513          	addi	a0,s0,-192
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	194080e7          	jalr	404(ra) # 80004182 <exec>
    80004ff6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff8:	10048993          	addi	s3,s1,256
    80004ffc:	6088                	ld	a0,0(s1)
    80004ffe:	c911                	beqz	a0,80005012 <sys_exec+0xfa>
    kfree(argv[i]);
    80005000:	ffffb097          	auipc	ra,0xffffb
    80005004:	01c080e7          	jalr	28(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005008:	04a1                	addi	s1,s1,8
    8000500a:	ff3499e3          	bne	s1,s3,80004ffc <sys_exec+0xe4>
    8000500e:	a011                	j	80005012 <sys_exec+0xfa>
  return -1;
    80005010:	597d                	li	s2,-1
}
    80005012:	854a                	mv	a0,s2
    80005014:	60be                	ld	ra,456(sp)
    80005016:	641e                	ld	s0,448(sp)
    80005018:	74fa                	ld	s1,440(sp)
    8000501a:	795a                	ld	s2,432(sp)
    8000501c:	79ba                	ld	s3,424(sp)
    8000501e:	7a1a                	ld	s4,416(sp)
    80005020:	6afa                	ld	s5,408(sp)
    80005022:	6179                	addi	sp,sp,464
    80005024:	8082                	ret

0000000080005026 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005026:	7139                	addi	sp,sp,-64
    80005028:	fc06                	sd	ra,56(sp)
    8000502a:	f822                	sd	s0,48(sp)
    8000502c:	f426                	sd	s1,40(sp)
    8000502e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005030:	ffffc097          	auipc	ra,0xffffc
    80005034:	f76080e7          	jalr	-138(ra) # 80000fa6 <myproc>
    80005038:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000503a:	fd840593          	addi	a1,s0,-40
    8000503e:	4501                	li	a0,0
    80005040:	ffffd097          	auipc	ra,0xffffd
    80005044:	0f4080e7          	jalr	244(ra) # 80002134 <argaddr>
    return -1;
    80005048:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000504a:	0e054063          	bltz	a0,8000512a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000504e:	fc840593          	addi	a1,s0,-56
    80005052:	fd040513          	addi	a0,s0,-48
    80005056:	fffff097          	auipc	ra,0xfffff
    8000505a:	dfc080e7          	jalr	-516(ra) # 80003e52 <pipealloc>
    return -1;
    8000505e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005060:	0c054563          	bltz	a0,8000512a <sys_pipe+0x104>
  fd0 = -1;
    80005064:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005068:	fd043503          	ld	a0,-48(s0)
    8000506c:	fffff097          	auipc	ra,0xfffff
    80005070:	508080e7          	jalr	1288(ra) # 80004574 <fdalloc>
    80005074:	fca42223          	sw	a0,-60(s0)
    80005078:	08054c63          	bltz	a0,80005110 <sys_pipe+0xea>
    8000507c:	fc843503          	ld	a0,-56(s0)
    80005080:	fffff097          	auipc	ra,0xfffff
    80005084:	4f4080e7          	jalr	1268(ra) # 80004574 <fdalloc>
    80005088:	fca42023          	sw	a0,-64(s0)
    8000508c:	06054863          	bltz	a0,800050fc <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005090:	4691                	li	a3,4
    80005092:	fc440613          	addi	a2,s0,-60
    80005096:	fd843583          	ld	a1,-40(s0)
    8000509a:	68a8                	ld	a0,80(s1)
    8000509c:	ffffc097          	auipc	ra,0xffffc
    800050a0:	b3a080e7          	jalr	-1222(ra) # 80000bd6 <copyout>
    800050a4:	02054063          	bltz	a0,800050c4 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050a8:	4691                	li	a3,4
    800050aa:	fc040613          	addi	a2,s0,-64
    800050ae:	fd843583          	ld	a1,-40(s0)
    800050b2:	0591                	addi	a1,a1,4
    800050b4:	68a8                	ld	a0,80(s1)
    800050b6:	ffffc097          	auipc	ra,0xffffc
    800050ba:	b20080e7          	jalr	-1248(ra) # 80000bd6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050be:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050c0:	06055563          	bgez	a0,8000512a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050c4:	fc442783          	lw	a5,-60(s0)
    800050c8:	07e9                	addi	a5,a5,26
    800050ca:	078e                	slli	a5,a5,0x3
    800050cc:	97a6                	add	a5,a5,s1
    800050ce:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050d2:	fc042503          	lw	a0,-64(s0)
    800050d6:	0569                	addi	a0,a0,26
    800050d8:	050e                	slli	a0,a0,0x3
    800050da:	9526                	add	a0,a0,s1
    800050dc:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050e0:	fd043503          	ld	a0,-48(s0)
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	a3e080e7          	jalr	-1474(ra) # 80003b22 <fileclose>
    fileclose(wf);
    800050ec:	fc843503          	ld	a0,-56(s0)
    800050f0:	fffff097          	auipc	ra,0xfffff
    800050f4:	a32080e7          	jalr	-1486(ra) # 80003b22 <fileclose>
    return -1;
    800050f8:	57fd                	li	a5,-1
    800050fa:	a805                	j	8000512a <sys_pipe+0x104>
    if(fd0 >= 0)
    800050fc:	fc442783          	lw	a5,-60(s0)
    80005100:	0007c863          	bltz	a5,80005110 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005104:	01a78513          	addi	a0,a5,26
    80005108:	050e                	slli	a0,a0,0x3
    8000510a:	9526                	add	a0,a0,s1
    8000510c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005110:	fd043503          	ld	a0,-48(s0)
    80005114:	fffff097          	auipc	ra,0xfffff
    80005118:	a0e080e7          	jalr	-1522(ra) # 80003b22 <fileclose>
    fileclose(wf);
    8000511c:	fc843503          	ld	a0,-56(s0)
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	a02080e7          	jalr	-1534(ra) # 80003b22 <fileclose>
    return -1;
    80005128:	57fd                	li	a5,-1
}
    8000512a:	853e                	mv	a0,a5
    8000512c:	70e2                	ld	ra,56(sp)
    8000512e:	7442                	ld	s0,48(sp)
    80005130:	74a2                	ld	s1,40(sp)
    80005132:	6121                	addi	sp,sp,64
    80005134:	8082                	ret
	...

0000000080005140 <kernelvec>:
    80005140:	7111                	addi	sp,sp,-256
    80005142:	e006                	sd	ra,0(sp)
    80005144:	e40a                	sd	sp,8(sp)
    80005146:	e80e                	sd	gp,16(sp)
    80005148:	ec12                	sd	tp,24(sp)
    8000514a:	f016                	sd	t0,32(sp)
    8000514c:	f41a                	sd	t1,40(sp)
    8000514e:	f81e                	sd	t2,48(sp)
    80005150:	fc22                	sd	s0,56(sp)
    80005152:	e0a6                	sd	s1,64(sp)
    80005154:	e4aa                	sd	a0,72(sp)
    80005156:	e8ae                	sd	a1,80(sp)
    80005158:	ecb2                	sd	a2,88(sp)
    8000515a:	f0b6                	sd	a3,96(sp)
    8000515c:	f4ba                	sd	a4,104(sp)
    8000515e:	f8be                	sd	a5,112(sp)
    80005160:	fcc2                	sd	a6,120(sp)
    80005162:	e146                	sd	a7,128(sp)
    80005164:	e54a                	sd	s2,136(sp)
    80005166:	e94e                	sd	s3,144(sp)
    80005168:	ed52                	sd	s4,152(sp)
    8000516a:	f156                	sd	s5,160(sp)
    8000516c:	f55a                	sd	s6,168(sp)
    8000516e:	f95e                	sd	s7,176(sp)
    80005170:	fd62                	sd	s8,184(sp)
    80005172:	e1e6                	sd	s9,192(sp)
    80005174:	e5ea                	sd	s10,200(sp)
    80005176:	e9ee                	sd	s11,208(sp)
    80005178:	edf2                	sd	t3,216(sp)
    8000517a:	f1f6                	sd	t4,224(sp)
    8000517c:	f5fa                	sd	t5,232(sp)
    8000517e:	f9fe                	sd	t6,240(sp)
    80005180:	c11fc0ef          	jal	ra,80001d90 <kerneltrap>
    80005184:	6082                	ld	ra,0(sp)
    80005186:	6122                	ld	sp,8(sp)
    80005188:	61c2                	ld	gp,16(sp)
    8000518a:	7282                	ld	t0,32(sp)
    8000518c:	7322                	ld	t1,40(sp)
    8000518e:	73c2                	ld	t2,48(sp)
    80005190:	7462                	ld	s0,56(sp)
    80005192:	6486                	ld	s1,64(sp)
    80005194:	6526                	ld	a0,72(sp)
    80005196:	65c6                	ld	a1,80(sp)
    80005198:	6666                	ld	a2,88(sp)
    8000519a:	7686                	ld	a3,96(sp)
    8000519c:	7726                	ld	a4,104(sp)
    8000519e:	77c6                	ld	a5,112(sp)
    800051a0:	7866                	ld	a6,120(sp)
    800051a2:	688a                	ld	a7,128(sp)
    800051a4:	692a                	ld	s2,136(sp)
    800051a6:	69ca                	ld	s3,144(sp)
    800051a8:	6a6a                	ld	s4,152(sp)
    800051aa:	7a8a                	ld	s5,160(sp)
    800051ac:	7b2a                	ld	s6,168(sp)
    800051ae:	7bca                	ld	s7,176(sp)
    800051b0:	7c6a                	ld	s8,184(sp)
    800051b2:	6c8e                	ld	s9,192(sp)
    800051b4:	6d2e                	ld	s10,200(sp)
    800051b6:	6dce                	ld	s11,208(sp)
    800051b8:	6e6e                	ld	t3,216(sp)
    800051ba:	7e8e                	ld	t4,224(sp)
    800051bc:	7f2e                	ld	t5,232(sp)
    800051be:	7fce                	ld	t6,240(sp)
    800051c0:	6111                	addi	sp,sp,256
    800051c2:	10200073          	sret
    800051c6:	00000013          	nop
    800051ca:	00000013          	nop
    800051ce:	0001                	nop

00000000800051d0 <timervec>:
    800051d0:	34051573          	csrrw	a0,mscratch,a0
    800051d4:	e10c                	sd	a1,0(a0)
    800051d6:	e510                	sd	a2,8(a0)
    800051d8:	e914                	sd	a3,16(a0)
    800051da:	6d0c                	ld	a1,24(a0)
    800051dc:	7110                	ld	a2,32(a0)
    800051de:	6194                	ld	a3,0(a1)
    800051e0:	96b2                	add	a3,a3,a2
    800051e2:	e194                	sd	a3,0(a1)
    800051e4:	4589                	li	a1,2
    800051e6:	14459073          	csrw	sip,a1
    800051ea:	6914                	ld	a3,16(a0)
    800051ec:	6510                	ld	a2,8(a0)
    800051ee:	610c                	ld	a1,0(a0)
    800051f0:	34051573          	csrrw	a0,mscratch,a0
    800051f4:	30200073          	mret
	...

00000000800051fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051fa:	1141                	addi	sp,sp,-16
    800051fc:	e422                	sd	s0,8(sp)
    800051fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005200:	0c0007b7          	lui	a5,0xc000
    80005204:	4705                	li	a4,1
    80005206:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005208:	c3d8                	sw	a4,4(a5)
}
    8000520a:	6422                	ld	s0,8(sp)
    8000520c:	0141                	addi	sp,sp,16
    8000520e:	8082                	ret

0000000080005210 <plicinithart>:

void
plicinithart(void)
{
    80005210:	1141                	addi	sp,sp,-16
    80005212:	e406                	sd	ra,8(sp)
    80005214:	e022                	sd	s0,0(sp)
    80005216:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005218:	ffffc097          	auipc	ra,0xffffc
    8000521c:	d62080e7          	jalr	-670(ra) # 80000f7a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005220:	0085171b          	slliw	a4,a0,0x8
    80005224:	0c0027b7          	lui	a5,0xc002
    80005228:	97ba                	add	a5,a5,a4
    8000522a:	40200713          	li	a4,1026
    8000522e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005232:	00d5151b          	slliw	a0,a0,0xd
    80005236:	0c2017b7          	lui	a5,0xc201
    8000523a:	953e                	add	a0,a0,a5
    8000523c:	00052023          	sw	zero,0(a0)
}
    80005240:	60a2                	ld	ra,8(sp)
    80005242:	6402                	ld	s0,0(sp)
    80005244:	0141                	addi	sp,sp,16
    80005246:	8082                	ret

0000000080005248 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005248:	1141                	addi	sp,sp,-16
    8000524a:	e406                	sd	ra,8(sp)
    8000524c:	e022                	sd	s0,0(sp)
    8000524e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005250:	ffffc097          	auipc	ra,0xffffc
    80005254:	d2a080e7          	jalr	-726(ra) # 80000f7a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005258:	00d5179b          	slliw	a5,a0,0xd
    8000525c:	0c201537          	lui	a0,0xc201
    80005260:	953e                	add	a0,a0,a5
  return irq;
}
    80005262:	4148                	lw	a0,4(a0)
    80005264:	60a2                	ld	ra,8(sp)
    80005266:	6402                	ld	s0,0(sp)
    80005268:	0141                	addi	sp,sp,16
    8000526a:	8082                	ret

000000008000526c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000526c:	1101                	addi	sp,sp,-32
    8000526e:	ec06                	sd	ra,24(sp)
    80005270:	e822                	sd	s0,16(sp)
    80005272:	e426                	sd	s1,8(sp)
    80005274:	1000                	addi	s0,sp,32
    80005276:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	d02080e7          	jalr	-766(ra) # 80000f7a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005280:	00d5151b          	slliw	a0,a0,0xd
    80005284:	0c2017b7          	lui	a5,0xc201
    80005288:	97aa                	add	a5,a5,a0
    8000528a:	c3c4                	sw	s1,4(a5)
}
    8000528c:	60e2                	ld	ra,24(sp)
    8000528e:	6442                	ld	s0,16(sp)
    80005290:	64a2                	ld	s1,8(sp)
    80005292:	6105                	addi	sp,sp,32
    80005294:	8082                	ret

0000000080005296 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005296:	1141                	addi	sp,sp,-16
    80005298:	e406                	sd	ra,8(sp)
    8000529a:	e022                	sd	s0,0(sp)
    8000529c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000529e:	479d                	li	a5,7
    800052a0:	06a7c963          	blt	a5,a0,80005312 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800052a4:	00236797          	auipc	a5,0x236
    800052a8:	d5c78793          	addi	a5,a5,-676 # 8023b000 <disk>
    800052ac:	00a78733          	add	a4,a5,a0
    800052b0:	6789                	lui	a5,0x2
    800052b2:	97ba                	add	a5,a5,a4
    800052b4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052b8:	e7ad                	bnez	a5,80005322 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052ba:	00451793          	slli	a5,a0,0x4
    800052be:	00238717          	auipc	a4,0x238
    800052c2:	d4270713          	addi	a4,a4,-702 # 8023d000 <disk+0x2000>
    800052c6:	6314                	ld	a3,0(a4)
    800052c8:	96be                	add	a3,a3,a5
    800052ca:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052ce:	6314                	ld	a3,0(a4)
    800052d0:	96be                	add	a3,a3,a5
    800052d2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800052d6:	6314                	ld	a3,0(a4)
    800052d8:	96be                	add	a3,a3,a5
    800052da:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800052de:	6318                	ld	a4,0(a4)
    800052e0:	97ba                	add	a5,a5,a4
    800052e2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800052e6:	00236797          	auipc	a5,0x236
    800052ea:	d1a78793          	addi	a5,a5,-742 # 8023b000 <disk>
    800052ee:	97aa                	add	a5,a5,a0
    800052f0:	6509                	lui	a0,0x2
    800052f2:	953e                	add	a0,a0,a5
    800052f4:	4785                	li	a5,1
    800052f6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800052fa:	00238517          	auipc	a0,0x238
    800052fe:	d1e50513          	addi	a0,a0,-738 # 8023d018 <disk+0x2018>
    80005302:	ffffc097          	auipc	ra,0xffffc
    80005306:	4ec080e7          	jalr	1260(ra) # 800017ee <wakeup>
}
    8000530a:	60a2                	ld	ra,8(sp)
    8000530c:	6402                	ld	s0,0(sp)
    8000530e:	0141                	addi	sp,sp,16
    80005310:	8082                	ret
    panic("free_desc 1");
    80005312:	00003517          	auipc	a0,0x3
    80005316:	3d650513          	addi	a0,a0,982 # 800086e8 <syscalls+0x320>
    8000531a:	00001097          	auipc	ra,0x1
    8000531e:	a1e080e7          	jalr	-1506(ra) # 80005d38 <panic>
    panic("free_desc 2");
    80005322:	00003517          	auipc	a0,0x3
    80005326:	3d650513          	addi	a0,a0,982 # 800086f8 <syscalls+0x330>
    8000532a:	00001097          	auipc	ra,0x1
    8000532e:	a0e080e7          	jalr	-1522(ra) # 80005d38 <panic>

0000000080005332 <virtio_disk_init>:
{
    80005332:	1101                	addi	sp,sp,-32
    80005334:	ec06                	sd	ra,24(sp)
    80005336:	e822                	sd	s0,16(sp)
    80005338:	e426                	sd	s1,8(sp)
    8000533a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000533c:	00003597          	auipc	a1,0x3
    80005340:	3cc58593          	addi	a1,a1,972 # 80008708 <syscalls+0x340>
    80005344:	00238517          	auipc	a0,0x238
    80005348:	de450513          	addi	a0,a0,-540 # 8023d128 <disk+0x2128>
    8000534c:	00001097          	auipc	ra,0x1
    80005350:	ea6080e7          	jalr	-346(ra) # 800061f2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005354:	100017b7          	lui	a5,0x10001
    80005358:	4398                	lw	a4,0(a5)
    8000535a:	2701                	sext.w	a4,a4
    8000535c:	747277b7          	lui	a5,0x74727
    80005360:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005364:	0ef71163          	bne	a4,a5,80005446 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005368:	100017b7          	lui	a5,0x10001
    8000536c:	43dc                	lw	a5,4(a5)
    8000536e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005370:	4705                	li	a4,1
    80005372:	0ce79a63          	bne	a5,a4,80005446 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005376:	100017b7          	lui	a5,0x10001
    8000537a:	479c                	lw	a5,8(a5)
    8000537c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000537e:	4709                	li	a4,2
    80005380:	0ce79363          	bne	a5,a4,80005446 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005384:	100017b7          	lui	a5,0x10001
    80005388:	47d8                	lw	a4,12(a5)
    8000538a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000538c:	554d47b7          	lui	a5,0x554d4
    80005390:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005394:	0af71963          	bne	a4,a5,80005446 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005398:	100017b7          	lui	a5,0x10001
    8000539c:	4705                	li	a4,1
    8000539e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053a0:	470d                	li	a4,3
    800053a2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053a4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053a6:	c7ffe737          	lui	a4,0xc7ffe
    800053aa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47db851f>
    800053ae:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053b0:	2701                	sext.w	a4,a4
    800053b2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b4:	472d                	li	a4,11
    800053b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b8:	473d                	li	a4,15
    800053ba:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800053bc:	6705                	lui	a4,0x1
    800053be:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053c0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053c4:	5bdc                	lw	a5,52(a5)
    800053c6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053c8:	c7d9                	beqz	a5,80005456 <virtio_disk_init+0x124>
  if(max < NUM)
    800053ca:	471d                	li	a4,7
    800053cc:	08f77d63          	bgeu	a4,a5,80005466 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053d0:	100014b7          	lui	s1,0x10001
    800053d4:	47a1                	li	a5,8
    800053d6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800053d8:	6609                	lui	a2,0x2
    800053da:	4581                	li	a1,0
    800053dc:	00236517          	auipc	a0,0x236
    800053e0:	c2450513          	addi	a0,a0,-988 # 8023b000 <disk>
    800053e4:	ffffb097          	auipc	ra,0xffffb
    800053e8:	e16080e7          	jalr	-490(ra) # 800001fa <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800053ec:	00236717          	auipc	a4,0x236
    800053f0:	c1470713          	addi	a4,a4,-1004 # 8023b000 <disk>
    800053f4:	00c75793          	srli	a5,a4,0xc
    800053f8:	2781                	sext.w	a5,a5
    800053fa:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800053fc:	00238797          	auipc	a5,0x238
    80005400:	c0478793          	addi	a5,a5,-1020 # 8023d000 <disk+0x2000>
    80005404:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005406:	00236717          	auipc	a4,0x236
    8000540a:	c7a70713          	addi	a4,a4,-902 # 8023b080 <disk+0x80>
    8000540e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005410:	00237717          	auipc	a4,0x237
    80005414:	bf070713          	addi	a4,a4,-1040 # 8023c000 <disk+0x1000>
    80005418:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000541a:	4705                	li	a4,1
    8000541c:	00e78c23          	sb	a4,24(a5)
    80005420:	00e78ca3          	sb	a4,25(a5)
    80005424:	00e78d23          	sb	a4,26(a5)
    80005428:	00e78da3          	sb	a4,27(a5)
    8000542c:	00e78e23          	sb	a4,28(a5)
    80005430:	00e78ea3          	sb	a4,29(a5)
    80005434:	00e78f23          	sb	a4,30(a5)
    80005438:	00e78fa3          	sb	a4,31(a5)
}
    8000543c:	60e2                	ld	ra,24(sp)
    8000543e:	6442                	ld	s0,16(sp)
    80005440:	64a2                	ld	s1,8(sp)
    80005442:	6105                	addi	sp,sp,32
    80005444:	8082                	ret
    panic("could not find virtio disk");
    80005446:	00003517          	auipc	a0,0x3
    8000544a:	2d250513          	addi	a0,a0,722 # 80008718 <syscalls+0x350>
    8000544e:	00001097          	auipc	ra,0x1
    80005452:	8ea080e7          	jalr	-1814(ra) # 80005d38 <panic>
    panic("virtio disk has no queue 0");
    80005456:	00003517          	auipc	a0,0x3
    8000545a:	2e250513          	addi	a0,a0,738 # 80008738 <syscalls+0x370>
    8000545e:	00001097          	auipc	ra,0x1
    80005462:	8da080e7          	jalr	-1830(ra) # 80005d38 <panic>
    panic("virtio disk max queue too short");
    80005466:	00003517          	auipc	a0,0x3
    8000546a:	2f250513          	addi	a0,a0,754 # 80008758 <syscalls+0x390>
    8000546e:	00001097          	auipc	ra,0x1
    80005472:	8ca080e7          	jalr	-1846(ra) # 80005d38 <panic>

0000000080005476 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005476:	7159                	addi	sp,sp,-112
    80005478:	f486                	sd	ra,104(sp)
    8000547a:	f0a2                	sd	s0,96(sp)
    8000547c:	eca6                	sd	s1,88(sp)
    8000547e:	e8ca                	sd	s2,80(sp)
    80005480:	e4ce                	sd	s3,72(sp)
    80005482:	e0d2                	sd	s4,64(sp)
    80005484:	fc56                	sd	s5,56(sp)
    80005486:	f85a                	sd	s6,48(sp)
    80005488:	f45e                	sd	s7,40(sp)
    8000548a:	f062                	sd	s8,32(sp)
    8000548c:	ec66                	sd	s9,24(sp)
    8000548e:	e86a                	sd	s10,16(sp)
    80005490:	1880                	addi	s0,sp,112
    80005492:	892a                	mv	s2,a0
    80005494:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005496:	00c52c83          	lw	s9,12(a0)
    8000549a:	001c9c9b          	slliw	s9,s9,0x1
    8000549e:	1c82                	slli	s9,s9,0x20
    800054a0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054a4:	00238517          	auipc	a0,0x238
    800054a8:	c8450513          	addi	a0,a0,-892 # 8023d128 <disk+0x2128>
    800054ac:	00001097          	auipc	ra,0x1
    800054b0:	dd6080e7          	jalr	-554(ra) # 80006282 <acquire>
  for(int i = 0; i < 3; i++){
    800054b4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054b6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800054b8:	00236b97          	auipc	s7,0x236
    800054bc:	b48b8b93          	addi	s7,s7,-1208 # 8023b000 <disk>
    800054c0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800054c2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054c4:	8a4e                	mv	s4,s3
    800054c6:	a051                	j	8000554a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800054c8:	00fb86b3          	add	a3,s7,a5
    800054cc:	96da                	add	a3,a3,s6
    800054ce:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054d2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054d4:	0207c563          	bltz	a5,800054fe <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800054d8:	2485                	addiw	s1,s1,1
    800054da:	0711                	addi	a4,a4,4
    800054dc:	25548063          	beq	s1,s5,8000571c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800054e0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800054e2:	00238697          	auipc	a3,0x238
    800054e6:	b3668693          	addi	a3,a3,-1226 # 8023d018 <disk+0x2018>
    800054ea:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800054ec:	0006c583          	lbu	a1,0(a3)
    800054f0:	fde1                	bnez	a1,800054c8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800054f2:	2785                	addiw	a5,a5,1
    800054f4:	0685                	addi	a3,a3,1
    800054f6:	ff879be3          	bne	a5,s8,800054ec <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800054fa:	57fd                	li	a5,-1
    800054fc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800054fe:	02905a63          	blez	s1,80005532 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005502:	f9042503          	lw	a0,-112(s0)
    80005506:	00000097          	auipc	ra,0x0
    8000550a:	d90080e7          	jalr	-624(ra) # 80005296 <free_desc>
      for(int j = 0; j < i; j++)
    8000550e:	4785                	li	a5,1
    80005510:	0297d163          	bge	a5,s1,80005532 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005514:	f9442503          	lw	a0,-108(s0)
    80005518:	00000097          	auipc	ra,0x0
    8000551c:	d7e080e7          	jalr	-642(ra) # 80005296 <free_desc>
      for(int j = 0; j < i; j++)
    80005520:	4789                	li	a5,2
    80005522:	0097d863          	bge	a5,s1,80005532 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005526:	f9842503          	lw	a0,-104(s0)
    8000552a:	00000097          	auipc	ra,0x0
    8000552e:	d6c080e7          	jalr	-660(ra) # 80005296 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005532:	00238597          	auipc	a1,0x238
    80005536:	bf658593          	addi	a1,a1,-1034 # 8023d128 <disk+0x2128>
    8000553a:	00238517          	auipc	a0,0x238
    8000553e:	ade50513          	addi	a0,a0,-1314 # 8023d018 <disk+0x2018>
    80005542:	ffffc097          	auipc	ra,0xffffc
    80005546:	120080e7          	jalr	288(ra) # 80001662 <sleep>
  for(int i = 0; i < 3; i++){
    8000554a:	f9040713          	addi	a4,s0,-112
    8000554e:	84ce                	mv	s1,s3
    80005550:	bf41                	j	800054e0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005552:	20058713          	addi	a4,a1,512
    80005556:	00471693          	slli	a3,a4,0x4
    8000555a:	00236717          	auipc	a4,0x236
    8000555e:	aa670713          	addi	a4,a4,-1370 # 8023b000 <disk>
    80005562:	9736                	add	a4,a4,a3
    80005564:	4685                	li	a3,1
    80005566:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000556a:	20058713          	addi	a4,a1,512
    8000556e:	00471693          	slli	a3,a4,0x4
    80005572:	00236717          	auipc	a4,0x236
    80005576:	a8e70713          	addi	a4,a4,-1394 # 8023b000 <disk>
    8000557a:	9736                	add	a4,a4,a3
    8000557c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005580:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005584:	7679                	lui	a2,0xffffe
    80005586:	963e                	add	a2,a2,a5
    80005588:	00238697          	auipc	a3,0x238
    8000558c:	a7868693          	addi	a3,a3,-1416 # 8023d000 <disk+0x2000>
    80005590:	6298                	ld	a4,0(a3)
    80005592:	9732                	add	a4,a4,a2
    80005594:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005596:	6298                	ld	a4,0(a3)
    80005598:	9732                	add	a4,a4,a2
    8000559a:	4541                	li	a0,16
    8000559c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000559e:	6298                	ld	a4,0(a3)
    800055a0:	9732                	add	a4,a4,a2
    800055a2:	4505                	li	a0,1
    800055a4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055a8:	f9442703          	lw	a4,-108(s0)
    800055ac:	6288                	ld	a0,0(a3)
    800055ae:	962a                	add	a2,a2,a0
    800055b0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7fdb7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055b4:	0712                	slli	a4,a4,0x4
    800055b6:	6290                	ld	a2,0(a3)
    800055b8:	963a                	add	a2,a2,a4
    800055ba:	05890513          	addi	a0,s2,88
    800055be:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055c0:	6294                	ld	a3,0(a3)
    800055c2:	96ba                	add	a3,a3,a4
    800055c4:	40000613          	li	a2,1024
    800055c8:	c690                	sw	a2,8(a3)
  if(write)
    800055ca:	140d0063          	beqz	s10,8000570a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055ce:	00238697          	auipc	a3,0x238
    800055d2:	a326b683          	ld	a3,-1486(a3) # 8023d000 <disk+0x2000>
    800055d6:	96ba                	add	a3,a3,a4
    800055d8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055dc:	00236817          	auipc	a6,0x236
    800055e0:	a2480813          	addi	a6,a6,-1500 # 8023b000 <disk>
    800055e4:	00238517          	auipc	a0,0x238
    800055e8:	a1c50513          	addi	a0,a0,-1508 # 8023d000 <disk+0x2000>
    800055ec:	6114                	ld	a3,0(a0)
    800055ee:	96ba                	add	a3,a3,a4
    800055f0:	00c6d603          	lhu	a2,12(a3)
    800055f4:	00166613          	ori	a2,a2,1
    800055f8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055fc:	f9842683          	lw	a3,-104(s0)
    80005600:	6110                	ld	a2,0(a0)
    80005602:	9732                	add	a4,a4,a2
    80005604:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005608:	20058613          	addi	a2,a1,512
    8000560c:	0612                	slli	a2,a2,0x4
    8000560e:	9642                	add	a2,a2,a6
    80005610:	577d                	li	a4,-1
    80005612:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005616:	00469713          	slli	a4,a3,0x4
    8000561a:	6114                	ld	a3,0(a0)
    8000561c:	96ba                	add	a3,a3,a4
    8000561e:	03078793          	addi	a5,a5,48
    80005622:	97c2                	add	a5,a5,a6
    80005624:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005626:	611c                	ld	a5,0(a0)
    80005628:	97ba                	add	a5,a5,a4
    8000562a:	4685                	li	a3,1
    8000562c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000562e:	611c                	ld	a5,0(a0)
    80005630:	97ba                	add	a5,a5,a4
    80005632:	4809                	li	a6,2
    80005634:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005638:	611c                	ld	a5,0(a0)
    8000563a:	973e                	add	a4,a4,a5
    8000563c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005640:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005644:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005648:	6518                	ld	a4,8(a0)
    8000564a:	00275783          	lhu	a5,2(a4)
    8000564e:	8b9d                	andi	a5,a5,7
    80005650:	0786                	slli	a5,a5,0x1
    80005652:	97ba                	add	a5,a5,a4
    80005654:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005658:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000565c:	6518                	ld	a4,8(a0)
    8000565e:	00275783          	lhu	a5,2(a4)
    80005662:	2785                	addiw	a5,a5,1
    80005664:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005668:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000566c:	100017b7          	lui	a5,0x10001
    80005670:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005674:	00492703          	lw	a4,4(s2)
    80005678:	4785                	li	a5,1
    8000567a:	02f71163          	bne	a4,a5,8000569c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000567e:	00238997          	auipc	s3,0x238
    80005682:	aaa98993          	addi	s3,s3,-1366 # 8023d128 <disk+0x2128>
  while(b->disk == 1) {
    80005686:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005688:	85ce                	mv	a1,s3
    8000568a:	854a                	mv	a0,s2
    8000568c:	ffffc097          	auipc	ra,0xffffc
    80005690:	fd6080e7          	jalr	-42(ra) # 80001662 <sleep>
  while(b->disk == 1) {
    80005694:	00492783          	lw	a5,4(s2)
    80005698:	fe9788e3          	beq	a5,s1,80005688 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000569c:	f9042903          	lw	s2,-112(s0)
    800056a0:	20090793          	addi	a5,s2,512
    800056a4:	00479713          	slli	a4,a5,0x4
    800056a8:	00236797          	auipc	a5,0x236
    800056ac:	95878793          	addi	a5,a5,-1704 # 8023b000 <disk>
    800056b0:	97ba                	add	a5,a5,a4
    800056b2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056b6:	00238997          	auipc	s3,0x238
    800056ba:	94a98993          	addi	s3,s3,-1718 # 8023d000 <disk+0x2000>
    800056be:	00491713          	slli	a4,s2,0x4
    800056c2:	0009b783          	ld	a5,0(s3)
    800056c6:	97ba                	add	a5,a5,a4
    800056c8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056cc:	854a                	mv	a0,s2
    800056ce:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056d2:	00000097          	auipc	ra,0x0
    800056d6:	bc4080e7          	jalr	-1084(ra) # 80005296 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056da:	8885                	andi	s1,s1,1
    800056dc:	f0ed                	bnez	s1,800056be <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056de:	00238517          	auipc	a0,0x238
    800056e2:	a4a50513          	addi	a0,a0,-1462 # 8023d128 <disk+0x2128>
    800056e6:	00001097          	auipc	ra,0x1
    800056ea:	c50080e7          	jalr	-944(ra) # 80006336 <release>
}
    800056ee:	70a6                	ld	ra,104(sp)
    800056f0:	7406                	ld	s0,96(sp)
    800056f2:	64e6                	ld	s1,88(sp)
    800056f4:	6946                	ld	s2,80(sp)
    800056f6:	69a6                	ld	s3,72(sp)
    800056f8:	6a06                	ld	s4,64(sp)
    800056fa:	7ae2                	ld	s5,56(sp)
    800056fc:	7b42                	ld	s6,48(sp)
    800056fe:	7ba2                	ld	s7,40(sp)
    80005700:	7c02                	ld	s8,32(sp)
    80005702:	6ce2                	ld	s9,24(sp)
    80005704:	6d42                	ld	s10,16(sp)
    80005706:	6165                	addi	sp,sp,112
    80005708:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000570a:	00238697          	auipc	a3,0x238
    8000570e:	8f66b683          	ld	a3,-1802(a3) # 8023d000 <disk+0x2000>
    80005712:	96ba                	add	a3,a3,a4
    80005714:	4609                	li	a2,2
    80005716:	00c69623          	sh	a2,12(a3)
    8000571a:	b5c9                	j	800055dc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000571c:	f9042583          	lw	a1,-112(s0)
    80005720:	20058793          	addi	a5,a1,512
    80005724:	0792                	slli	a5,a5,0x4
    80005726:	00236517          	auipc	a0,0x236
    8000572a:	98250513          	addi	a0,a0,-1662 # 8023b0a8 <disk+0xa8>
    8000572e:	953e                	add	a0,a0,a5
  if(write)
    80005730:	e20d11e3          	bnez	s10,80005552 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005734:	20058713          	addi	a4,a1,512
    80005738:	00471693          	slli	a3,a4,0x4
    8000573c:	00236717          	auipc	a4,0x236
    80005740:	8c470713          	addi	a4,a4,-1852 # 8023b000 <disk>
    80005744:	9736                	add	a4,a4,a3
    80005746:	0a072423          	sw	zero,168(a4)
    8000574a:	b505                	j	8000556a <virtio_disk_rw+0xf4>

000000008000574c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000574c:	1101                	addi	sp,sp,-32
    8000574e:	ec06                	sd	ra,24(sp)
    80005750:	e822                	sd	s0,16(sp)
    80005752:	e426                	sd	s1,8(sp)
    80005754:	e04a                	sd	s2,0(sp)
    80005756:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005758:	00238517          	auipc	a0,0x238
    8000575c:	9d050513          	addi	a0,a0,-1584 # 8023d128 <disk+0x2128>
    80005760:	00001097          	auipc	ra,0x1
    80005764:	b22080e7          	jalr	-1246(ra) # 80006282 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005768:	10001737          	lui	a4,0x10001
    8000576c:	533c                	lw	a5,96(a4)
    8000576e:	8b8d                	andi	a5,a5,3
    80005770:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005772:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005776:	00238797          	auipc	a5,0x238
    8000577a:	88a78793          	addi	a5,a5,-1910 # 8023d000 <disk+0x2000>
    8000577e:	6b94                	ld	a3,16(a5)
    80005780:	0207d703          	lhu	a4,32(a5)
    80005784:	0026d783          	lhu	a5,2(a3)
    80005788:	06f70163          	beq	a4,a5,800057ea <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000578c:	00236917          	auipc	s2,0x236
    80005790:	87490913          	addi	s2,s2,-1932 # 8023b000 <disk>
    80005794:	00238497          	auipc	s1,0x238
    80005798:	86c48493          	addi	s1,s1,-1940 # 8023d000 <disk+0x2000>
    __sync_synchronize();
    8000579c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057a0:	6898                	ld	a4,16(s1)
    800057a2:	0204d783          	lhu	a5,32(s1)
    800057a6:	8b9d                	andi	a5,a5,7
    800057a8:	078e                	slli	a5,a5,0x3
    800057aa:	97ba                	add	a5,a5,a4
    800057ac:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057ae:	20078713          	addi	a4,a5,512
    800057b2:	0712                	slli	a4,a4,0x4
    800057b4:	974a                	add	a4,a4,s2
    800057b6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800057ba:	e731                	bnez	a4,80005806 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057bc:	20078793          	addi	a5,a5,512
    800057c0:	0792                	slli	a5,a5,0x4
    800057c2:	97ca                	add	a5,a5,s2
    800057c4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057c6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057ca:	ffffc097          	auipc	ra,0xffffc
    800057ce:	024080e7          	jalr	36(ra) # 800017ee <wakeup>

    disk.used_idx += 1;
    800057d2:	0204d783          	lhu	a5,32(s1)
    800057d6:	2785                	addiw	a5,a5,1
    800057d8:	17c2                	slli	a5,a5,0x30
    800057da:	93c1                	srli	a5,a5,0x30
    800057dc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057e0:	6898                	ld	a4,16(s1)
    800057e2:	00275703          	lhu	a4,2(a4)
    800057e6:	faf71be3          	bne	a4,a5,8000579c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800057ea:	00238517          	auipc	a0,0x238
    800057ee:	93e50513          	addi	a0,a0,-1730 # 8023d128 <disk+0x2128>
    800057f2:	00001097          	auipc	ra,0x1
    800057f6:	b44080e7          	jalr	-1212(ra) # 80006336 <release>
}
    800057fa:	60e2                	ld	ra,24(sp)
    800057fc:	6442                	ld	s0,16(sp)
    800057fe:	64a2                	ld	s1,8(sp)
    80005800:	6902                	ld	s2,0(sp)
    80005802:	6105                	addi	sp,sp,32
    80005804:	8082                	ret
      panic("virtio_disk_intr status");
    80005806:	00003517          	auipc	a0,0x3
    8000580a:	f7250513          	addi	a0,a0,-142 # 80008778 <syscalls+0x3b0>
    8000580e:	00000097          	auipc	ra,0x0
    80005812:	52a080e7          	jalr	1322(ra) # 80005d38 <panic>

0000000080005816 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005816:	1141                	addi	sp,sp,-16
    80005818:	e422                	sd	s0,8(sp)
    8000581a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000581c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005820:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005824:	0037979b          	slliw	a5,a5,0x3
    80005828:	02004737          	lui	a4,0x2004
    8000582c:	97ba                	add	a5,a5,a4
    8000582e:	0200c737          	lui	a4,0x200c
    80005832:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005836:	000f4637          	lui	a2,0xf4
    8000583a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000583e:	95b2                	add	a1,a1,a2
    80005840:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005842:	00269713          	slli	a4,a3,0x2
    80005846:	9736                	add	a4,a4,a3
    80005848:	00371693          	slli	a3,a4,0x3
    8000584c:	00238717          	auipc	a4,0x238
    80005850:	7b470713          	addi	a4,a4,1972 # 8023e000 <timer_scratch>
    80005854:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005856:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005858:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000585a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000585e:	00000797          	auipc	a5,0x0
    80005862:	97278793          	addi	a5,a5,-1678 # 800051d0 <timervec>
    80005866:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000586a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000586e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005872:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005876:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000587a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000587e:	30479073          	csrw	mie,a5
}
    80005882:	6422                	ld	s0,8(sp)
    80005884:	0141                	addi	sp,sp,16
    80005886:	8082                	ret

0000000080005888 <start>:
{
    80005888:	1141                	addi	sp,sp,-16
    8000588a:	e406                	sd	ra,8(sp)
    8000588c:	e022                	sd	s0,0(sp)
    8000588e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005890:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005894:	7779                	lui	a4,0xffffe
    80005896:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb85bf>
    8000589a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000589c:	6705                	lui	a4,0x1
    8000589e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058a2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058a4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058a8:	ffffb797          	auipc	a5,0xffffb
    800058ac:	b0078793          	addi	a5,a5,-1280 # 800003a8 <main>
    800058b0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058b4:	4781                	li	a5,0
    800058b6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058ba:	67c1                	lui	a5,0x10
    800058bc:	17fd                	addi	a5,a5,-1
    800058be:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058c2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058c6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058ca:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058ce:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058d2:	57fd                	li	a5,-1
    800058d4:	83a9                	srli	a5,a5,0xa
    800058d6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058da:	47bd                	li	a5,15
    800058dc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058e0:	00000097          	auipc	ra,0x0
    800058e4:	f36080e7          	jalr	-202(ra) # 80005816 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058e8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058ec:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058ee:	823e                	mv	tp,a5
  asm volatile("mret");
    800058f0:	30200073          	mret
}
    800058f4:	60a2                	ld	ra,8(sp)
    800058f6:	6402                	ld	s0,0(sp)
    800058f8:	0141                	addi	sp,sp,16
    800058fa:	8082                	ret

00000000800058fc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058fc:	715d                	addi	sp,sp,-80
    800058fe:	e486                	sd	ra,72(sp)
    80005900:	e0a2                	sd	s0,64(sp)
    80005902:	fc26                	sd	s1,56(sp)
    80005904:	f84a                	sd	s2,48(sp)
    80005906:	f44e                	sd	s3,40(sp)
    80005908:	f052                	sd	s4,32(sp)
    8000590a:	ec56                	sd	s5,24(sp)
    8000590c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000590e:	04c05663          	blez	a2,8000595a <consolewrite+0x5e>
    80005912:	8a2a                	mv	s4,a0
    80005914:	84ae                	mv	s1,a1
    80005916:	89b2                	mv	s3,a2
    80005918:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000591a:	5afd                	li	s5,-1
    8000591c:	4685                	li	a3,1
    8000591e:	8626                	mv	a2,s1
    80005920:	85d2                	mv	a1,s4
    80005922:	fbf40513          	addi	a0,s0,-65
    80005926:	ffffc097          	auipc	ra,0xffffc
    8000592a:	136080e7          	jalr	310(ra) # 80001a5c <either_copyin>
    8000592e:	01550c63          	beq	a0,s5,80005946 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005932:	fbf44503          	lbu	a0,-65(s0)
    80005936:	00000097          	auipc	ra,0x0
    8000593a:	78e080e7          	jalr	1934(ra) # 800060c4 <uartputc>
  for(i = 0; i < n; i++){
    8000593e:	2905                	addiw	s2,s2,1
    80005940:	0485                	addi	s1,s1,1
    80005942:	fd299de3          	bne	s3,s2,8000591c <consolewrite+0x20>
  }

  return i;
}
    80005946:	854a                	mv	a0,s2
    80005948:	60a6                	ld	ra,72(sp)
    8000594a:	6406                	ld	s0,64(sp)
    8000594c:	74e2                	ld	s1,56(sp)
    8000594e:	7942                	ld	s2,48(sp)
    80005950:	79a2                	ld	s3,40(sp)
    80005952:	7a02                	ld	s4,32(sp)
    80005954:	6ae2                	ld	s5,24(sp)
    80005956:	6161                	addi	sp,sp,80
    80005958:	8082                	ret
  for(i = 0; i < n; i++){
    8000595a:	4901                	li	s2,0
    8000595c:	b7ed                	j	80005946 <consolewrite+0x4a>

000000008000595e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000595e:	7119                	addi	sp,sp,-128
    80005960:	fc86                	sd	ra,120(sp)
    80005962:	f8a2                	sd	s0,112(sp)
    80005964:	f4a6                	sd	s1,104(sp)
    80005966:	f0ca                	sd	s2,96(sp)
    80005968:	ecce                	sd	s3,88(sp)
    8000596a:	e8d2                	sd	s4,80(sp)
    8000596c:	e4d6                	sd	s5,72(sp)
    8000596e:	e0da                	sd	s6,64(sp)
    80005970:	fc5e                	sd	s7,56(sp)
    80005972:	f862                	sd	s8,48(sp)
    80005974:	f466                	sd	s9,40(sp)
    80005976:	f06a                	sd	s10,32(sp)
    80005978:	ec6e                	sd	s11,24(sp)
    8000597a:	0100                	addi	s0,sp,128
    8000597c:	8b2a                	mv	s6,a0
    8000597e:	8aae                	mv	s5,a1
    80005980:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005982:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005986:	00240517          	auipc	a0,0x240
    8000598a:	7ba50513          	addi	a0,a0,1978 # 80246140 <cons>
    8000598e:	00001097          	auipc	ra,0x1
    80005992:	8f4080e7          	jalr	-1804(ra) # 80006282 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005996:	00240497          	auipc	s1,0x240
    8000599a:	7aa48493          	addi	s1,s1,1962 # 80246140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000599e:	89a6                	mv	s3,s1
    800059a0:	00241917          	auipc	s2,0x241
    800059a4:	83890913          	addi	s2,s2,-1992 # 802461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800059a8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059aa:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059ac:	4da9                	li	s11,10
  while(n > 0){
    800059ae:	07405863          	blez	s4,80005a1e <consoleread+0xc0>
    while(cons.r == cons.w){
    800059b2:	0984a783          	lw	a5,152(s1)
    800059b6:	09c4a703          	lw	a4,156(s1)
    800059ba:	02f71463          	bne	a4,a5,800059e2 <consoleread+0x84>
      if(myproc()->killed){
    800059be:	ffffb097          	auipc	ra,0xffffb
    800059c2:	5e8080e7          	jalr	1512(ra) # 80000fa6 <myproc>
    800059c6:	551c                	lw	a5,40(a0)
    800059c8:	e7b5                	bnez	a5,80005a34 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800059ca:	85ce                	mv	a1,s3
    800059cc:	854a                	mv	a0,s2
    800059ce:	ffffc097          	auipc	ra,0xffffc
    800059d2:	c94080e7          	jalr	-876(ra) # 80001662 <sleep>
    while(cons.r == cons.w){
    800059d6:	0984a783          	lw	a5,152(s1)
    800059da:	09c4a703          	lw	a4,156(s1)
    800059de:	fef700e3          	beq	a4,a5,800059be <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800059e2:	0017871b          	addiw	a4,a5,1
    800059e6:	08e4ac23          	sw	a4,152(s1)
    800059ea:	07f7f713          	andi	a4,a5,127
    800059ee:	9726                	add	a4,a4,s1
    800059f0:	01874703          	lbu	a4,24(a4)
    800059f4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800059f8:	079c0663          	beq	s8,s9,80005a64 <consoleread+0x106>
    cbuf = c;
    800059fc:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a00:	4685                	li	a3,1
    80005a02:	f8f40613          	addi	a2,s0,-113
    80005a06:	85d6                	mv	a1,s5
    80005a08:	855a                	mv	a0,s6
    80005a0a:	ffffc097          	auipc	ra,0xffffc
    80005a0e:	ffc080e7          	jalr	-4(ra) # 80001a06 <either_copyout>
    80005a12:	01a50663          	beq	a0,s10,80005a1e <consoleread+0xc0>
    dst++;
    80005a16:	0a85                	addi	s5,s5,1
    --n;
    80005a18:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a1a:	f9bc1ae3          	bne	s8,s11,800059ae <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a1e:	00240517          	auipc	a0,0x240
    80005a22:	72250513          	addi	a0,a0,1826 # 80246140 <cons>
    80005a26:	00001097          	auipc	ra,0x1
    80005a2a:	910080e7          	jalr	-1776(ra) # 80006336 <release>

  return target - n;
    80005a2e:	414b853b          	subw	a0,s7,s4
    80005a32:	a811                	j	80005a46 <consoleread+0xe8>
        release(&cons.lock);
    80005a34:	00240517          	auipc	a0,0x240
    80005a38:	70c50513          	addi	a0,a0,1804 # 80246140 <cons>
    80005a3c:	00001097          	auipc	ra,0x1
    80005a40:	8fa080e7          	jalr	-1798(ra) # 80006336 <release>
        return -1;
    80005a44:	557d                	li	a0,-1
}
    80005a46:	70e6                	ld	ra,120(sp)
    80005a48:	7446                	ld	s0,112(sp)
    80005a4a:	74a6                	ld	s1,104(sp)
    80005a4c:	7906                	ld	s2,96(sp)
    80005a4e:	69e6                	ld	s3,88(sp)
    80005a50:	6a46                	ld	s4,80(sp)
    80005a52:	6aa6                	ld	s5,72(sp)
    80005a54:	6b06                	ld	s6,64(sp)
    80005a56:	7be2                	ld	s7,56(sp)
    80005a58:	7c42                	ld	s8,48(sp)
    80005a5a:	7ca2                	ld	s9,40(sp)
    80005a5c:	7d02                	ld	s10,32(sp)
    80005a5e:	6de2                	ld	s11,24(sp)
    80005a60:	6109                	addi	sp,sp,128
    80005a62:	8082                	ret
      if(n < target){
    80005a64:	000a071b          	sext.w	a4,s4
    80005a68:	fb777be3          	bgeu	a4,s7,80005a1e <consoleread+0xc0>
        cons.r--;
    80005a6c:	00240717          	auipc	a4,0x240
    80005a70:	76f72623          	sw	a5,1900(a4) # 802461d8 <cons+0x98>
    80005a74:	b76d                	j	80005a1e <consoleread+0xc0>

0000000080005a76 <consputc>:
{
    80005a76:	1141                	addi	sp,sp,-16
    80005a78:	e406                	sd	ra,8(sp)
    80005a7a:	e022                	sd	s0,0(sp)
    80005a7c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a7e:	10000793          	li	a5,256
    80005a82:	00f50a63          	beq	a0,a5,80005a96 <consputc+0x20>
    uartputc_sync(c);
    80005a86:	00000097          	auipc	ra,0x0
    80005a8a:	564080e7          	jalr	1380(ra) # 80005fea <uartputc_sync>
}
    80005a8e:	60a2                	ld	ra,8(sp)
    80005a90:	6402                	ld	s0,0(sp)
    80005a92:	0141                	addi	sp,sp,16
    80005a94:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a96:	4521                	li	a0,8
    80005a98:	00000097          	auipc	ra,0x0
    80005a9c:	552080e7          	jalr	1362(ra) # 80005fea <uartputc_sync>
    80005aa0:	02000513          	li	a0,32
    80005aa4:	00000097          	auipc	ra,0x0
    80005aa8:	546080e7          	jalr	1350(ra) # 80005fea <uartputc_sync>
    80005aac:	4521                	li	a0,8
    80005aae:	00000097          	auipc	ra,0x0
    80005ab2:	53c080e7          	jalr	1340(ra) # 80005fea <uartputc_sync>
    80005ab6:	bfe1                	j	80005a8e <consputc+0x18>

0000000080005ab8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ab8:	1101                	addi	sp,sp,-32
    80005aba:	ec06                	sd	ra,24(sp)
    80005abc:	e822                	sd	s0,16(sp)
    80005abe:	e426                	sd	s1,8(sp)
    80005ac0:	e04a                	sd	s2,0(sp)
    80005ac2:	1000                	addi	s0,sp,32
    80005ac4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ac6:	00240517          	auipc	a0,0x240
    80005aca:	67a50513          	addi	a0,a0,1658 # 80246140 <cons>
    80005ace:	00000097          	auipc	ra,0x0
    80005ad2:	7b4080e7          	jalr	1972(ra) # 80006282 <acquire>

  switch(c){
    80005ad6:	47d5                	li	a5,21
    80005ad8:	0af48663          	beq	s1,a5,80005b84 <consoleintr+0xcc>
    80005adc:	0297ca63          	blt	a5,s1,80005b10 <consoleintr+0x58>
    80005ae0:	47a1                	li	a5,8
    80005ae2:	0ef48763          	beq	s1,a5,80005bd0 <consoleintr+0x118>
    80005ae6:	47c1                	li	a5,16
    80005ae8:	10f49a63          	bne	s1,a5,80005bfc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005aec:	ffffc097          	auipc	ra,0xffffc
    80005af0:	fc6080e7          	jalr	-58(ra) # 80001ab2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005af4:	00240517          	auipc	a0,0x240
    80005af8:	64c50513          	addi	a0,a0,1612 # 80246140 <cons>
    80005afc:	00001097          	auipc	ra,0x1
    80005b00:	83a080e7          	jalr	-1990(ra) # 80006336 <release>
}
    80005b04:	60e2                	ld	ra,24(sp)
    80005b06:	6442                	ld	s0,16(sp)
    80005b08:	64a2                	ld	s1,8(sp)
    80005b0a:	6902                	ld	s2,0(sp)
    80005b0c:	6105                	addi	sp,sp,32
    80005b0e:	8082                	ret
  switch(c){
    80005b10:	07f00793          	li	a5,127
    80005b14:	0af48e63          	beq	s1,a5,80005bd0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b18:	00240717          	auipc	a4,0x240
    80005b1c:	62870713          	addi	a4,a4,1576 # 80246140 <cons>
    80005b20:	0a072783          	lw	a5,160(a4)
    80005b24:	09872703          	lw	a4,152(a4)
    80005b28:	9f99                	subw	a5,a5,a4
    80005b2a:	07f00713          	li	a4,127
    80005b2e:	fcf763e3          	bltu	a4,a5,80005af4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b32:	47b5                	li	a5,13
    80005b34:	0cf48763          	beq	s1,a5,80005c02 <consoleintr+0x14a>
      consputc(c);
    80005b38:	8526                	mv	a0,s1
    80005b3a:	00000097          	auipc	ra,0x0
    80005b3e:	f3c080e7          	jalr	-196(ra) # 80005a76 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b42:	00240797          	auipc	a5,0x240
    80005b46:	5fe78793          	addi	a5,a5,1534 # 80246140 <cons>
    80005b4a:	0a07a703          	lw	a4,160(a5)
    80005b4e:	0017069b          	addiw	a3,a4,1
    80005b52:	0006861b          	sext.w	a2,a3
    80005b56:	0ad7a023          	sw	a3,160(a5)
    80005b5a:	07f77713          	andi	a4,a4,127
    80005b5e:	97ba                	add	a5,a5,a4
    80005b60:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b64:	47a9                	li	a5,10
    80005b66:	0cf48563          	beq	s1,a5,80005c30 <consoleintr+0x178>
    80005b6a:	4791                	li	a5,4
    80005b6c:	0cf48263          	beq	s1,a5,80005c30 <consoleintr+0x178>
    80005b70:	00240797          	auipc	a5,0x240
    80005b74:	6687a783          	lw	a5,1640(a5) # 802461d8 <cons+0x98>
    80005b78:	0807879b          	addiw	a5,a5,128
    80005b7c:	f6f61ce3          	bne	a2,a5,80005af4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b80:	863e                	mv	a2,a5
    80005b82:	a07d                	j	80005c30 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b84:	00240717          	auipc	a4,0x240
    80005b88:	5bc70713          	addi	a4,a4,1468 # 80246140 <cons>
    80005b8c:	0a072783          	lw	a5,160(a4)
    80005b90:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b94:	00240497          	auipc	s1,0x240
    80005b98:	5ac48493          	addi	s1,s1,1452 # 80246140 <cons>
    while(cons.e != cons.w &&
    80005b9c:	4929                	li	s2,10
    80005b9e:	f4f70be3          	beq	a4,a5,80005af4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ba2:	37fd                	addiw	a5,a5,-1
    80005ba4:	07f7f713          	andi	a4,a5,127
    80005ba8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005baa:	01874703          	lbu	a4,24(a4)
    80005bae:	f52703e3          	beq	a4,s2,80005af4 <consoleintr+0x3c>
      cons.e--;
    80005bb2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bb6:	10000513          	li	a0,256
    80005bba:	00000097          	auipc	ra,0x0
    80005bbe:	ebc080e7          	jalr	-324(ra) # 80005a76 <consputc>
    while(cons.e != cons.w &&
    80005bc2:	0a04a783          	lw	a5,160(s1)
    80005bc6:	09c4a703          	lw	a4,156(s1)
    80005bca:	fcf71ce3          	bne	a4,a5,80005ba2 <consoleintr+0xea>
    80005bce:	b71d                	j	80005af4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bd0:	00240717          	auipc	a4,0x240
    80005bd4:	57070713          	addi	a4,a4,1392 # 80246140 <cons>
    80005bd8:	0a072783          	lw	a5,160(a4)
    80005bdc:	09c72703          	lw	a4,156(a4)
    80005be0:	f0f70ae3          	beq	a4,a5,80005af4 <consoleintr+0x3c>
      cons.e--;
    80005be4:	37fd                	addiw	a5,a5,-1
    80005be6:	00240717          	auipc	a4,0x240
    80005bea:	5ef72d23          	sw	a5,1530(a4) # 802461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005bee:	10000513          	li	a0,256
    80005bf2:	00000097          	auipc	ra,0x0
    80005bf6:	e84080e7          	jalr	-380(ra) # 80005a76 <consputc>
    80005bfa:	bded                	j	80005af4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bfc:	ee048ce3          	beqz	s1,80005af4 <consoleintr+0x3c>
    80005c00:	bf21                	j	80005b18 <consoleintr+0x60>
      consputc(c);
    80005c02:	4529                	li	a0,10
    80005c04:	00000097          	auipc	ra,0x0
    80005c08:	e72080e7          	jalr	-398(ra) # 80005a76 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c0c:	00240797          	auipc	a5,0x240
    80005c10:	53478793          	addi	a5,a5,1332 # 80246140 <cons>
    80005c14:	0a07a703          	lw	a4,160(a5)
    80005c18:	0017069b          	addiw	a3,a4,1
    80005c1c:	0006861b          	sext.w	a2,a3
    80005c20:	0ad7a023          	sw	a3,160(a5)
    80005c24:	07f77713          	andi	a4,a4,127
    80005c28:	97ba                	add	a5,a5,a4
    80005c2a:	4729                	li	a4,10
    80005c2c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c30:	00240797          	auipc	a5,0x240
    80005c34:	5ac7a623          	sw	a2,1452(a5) # 802461dc <cons+0x9c>
        wakeup(&cons.r);
    80005c38:	00240517          	auipc	a0,0x240
    80005c3c:	5a050513          	addi	a0,a0,1440 # 802461d8 <cons+0x98>
    80005c40:	ffffc097          	auipc	ra,0xffffc
    80005c44:	bae080e7          	jalr	-1106(ra) # 800017ee <wakeup>
    80005c48:	b575                	j	80005af4 <consoleintr+0x3c>

0000000080005c4a <consoleinit>:

void
consoleinit(void)
{
    80005c4a:	1141                	addi	sp,sp,-16
    80005c4c:	e406                	sd	ra,8(sp)
    80005c4e:	e022                	sd	s0,0(sp)
    80005c50:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c52:	00003597          	auipc	a1,0x3
    80005c56:	b3e58593          	addi	a1,a1,-1218 # 80008790 <syscalls+0x3c8>
    80005c5a:	00240517          	auipc	a0,0x240
    80005c5e:	4e650513          	addi	a0,a0,1254 # 80246140 <cons>
    80005c62:	00000097          	auipc	ra,0x0
    80005c66:	590080e7          	jalr	1424(ra) # 800061f2 <initlock>

  uartinit();
    80005c6a:	00000097          	auipc	ra,0x0
    80005c6e:	330080e7          	jalr	816(ra) # 80005f9a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c72:	00233797          	auipc	a5,0x233
    80005c76:	46e78793          	addi	a5,a5,1134 # 802390e0 <devsw>
    80005c7a:	00000717          	auipc	a4,0x0
    80005c7e:	ce470713          	addi	a4,a4,-796 # 8000595e <consoleread>
    80005c82:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c84:	00000717          	auipc	a4,0x0
    80005c88:	c7870713          	addi	a4,a4,-904 # 800058fc <consolewrite>
    80005c8c:	ef98                	sd	a4,24(a5)
}
    80005c8e:	60a2                	ld	ra,8(sp)
    80005c90:	6402                	ld	s0,0(sp)
    80005c92:	0141                	addi	sp,sp,16
    80005c94:	8082                	ret

0000000080005c96 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c96:	7179                	addi	sp,sp,-48
    80005c98:	f406                	sd	ra,40(sp)
    80005c9a:	f022                	sd	s0,32(sp)
    80005c9c:	ec26                	sd	s1,24(sp)
    80005c9e:	e84a                	sd	s2,16(sp)
    80005ca0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ca2:	c219                	beqz	a2,80005ca8 <printint+0x12>
    80005ca4:	08054663          	bltz	a0,80005d30 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005ca8:	2501                	sext.w	a0,a0
    80005caa:	4881                	li	a7,0
    80005cac:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cb0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cb2:	2581                	sext.w	a1,a1
    80005cb4:	00003617          	auipc	a2,0x3
    80005cb8:	b0c60613          	addi	a2,a2,-1268 # 800087c0 <digits>
    80005cbc:	883a                	mv	a6,a4
    80005cbe:	2705                	addiw	a4,a4,1
    80005cc0:	02b577bb          	remuw	a5,a0,a1
    80005cc4:	1782                	slli	a5,a5,0x20
    80005cc6:	9381                	srli	a5,a5,0x20
    80005cc8:	97b2                	add	a5,a5,a2
    80005cca:	0007c783          	lbu	a5,0(a5)
    80005cce:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cd2:	0005079b          	sext.w	a5,a0
    80005cd6:	02b5553b          	divuw	a0,a0,a1
    80005cda:	0685                	addi	a3,a3,1
    80005cdc:	feb7f0e3          	bgeu	a5,a1,80005cbc <printint+0x26>

  if(sign)
    80005ce0:	00088b63          	beqz	a7,80005cf6 <printint+0x60>
    buf[i++] = '-';
    80005ce4:	fe040793          	addi	a5,s0,-32
    80005ce8:	973e                	add	a4,a4,a5
    80005cea:	02d00793          	li	a5,45
    80005cee:	fef70823          	sb	a5,-16(a4)
    80005cf2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cf6:	02e05763          	blez	a4,80005d24 <printint+0x8e>
    80005cfa:	fd040793          	addi	a5,s0,-48
    80005cfe:	00e784b3          	add	s1,a5,a4
    80005d02:	fff78913          	addi	s2,a5,-1
    80005d06:	993a                	add	s2,s2,a4
    80005d08:	377d                	addiw	a4,a4,-1
    80005d0a:	1702                	slli	a4,a4,0x20
    80005d0c:	9301                	srli	a4,a4,0x20
    80005d0e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d12:	fff4c503          	lbu	a0,-1(s1)
    80005d16:	00000097          	auipc	ra,0x0
    80005d1a:	d60080e7          	jalr	-672(ra) # 80005a76 <consputc>
  while(--i >= 0)
    80005d1e:	14fd                	addi	s1,s1,-1
    80005d20:	ff2499e3          	bne	s1,s2,80005d12 <printint+0x7c>
}
    80005d24:	70a2                	ld	ra,40(sp)
    80005d26:	7402                	ld	s0,32(sp)
    80005d28:	64e2                	ld	s1,24(sp)
    80005d2a:	6942                	ld	s2,16(sp)
    80005d2c:	6145                	addi	sp,sp,48
    80005d2e:	8082                	ret
    x = -xx;
    80005d30:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d34:	4885                	li	a7,1
    x = -xx;
    80005d36:	bf9d                	j	80005cac <printint+0x16>

0000000080005d38 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d38:	1101                	addi	sp,sp,-32
    80005d3a:	ec06                	sd	ra,24(sp)
    80005d3c:	e822                	sd	s0,16(sp)
    80005d3e:	e426                	sd	s1,8(sp)
    80005d40:	1000                	addi	s0,sp,32
    80005d42:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d44:	00240797          	auipc	a5,0x240
    80005d48:	4a07ae23          	sw	zero,1212(a5) # 80246200 <pr+0x18>
  printf("panic: ");
    80005d4c:	00003517          	auipc	a0,0x3
    80005d50:	a4c50513          	addi	a0,a0,-1460 # 80008798 <syscalls+0x3d0>
    80005d54:	00000097          	auipc	ra,0x0
    80005d58:	02e080e7          	jalr	46(ra) # 80005d82 <printf>
  printf(s);
    80005d5c:	8526                	mv	a0,s1
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	024080e7          	jalr	36(ra) # 80005d82 <printf>
  printf("\n");
    80005d66:	00002517          	auipc	a0,0x2
    80005d6a:	2e250513          	addi	a0,a0,738 # 80008048 <etext+0x48>
    80005d6e:	00000097          	auipc	ra,0x0
    80005d72:	014080e7          	jalr	20(ra) # 80005d82 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d76:	4785                	li	a5,1
    80005d78:	00003717          	auipc	a4,0x3
    80005d7c:	2af72223          	sw	a5,676(a4) # 8000901c <panicked>
  for(;;)
    80005d80:	a001                	j	80005d80 <panic+0x48>

0000000080005d82 <printf>:
{
    80005d82:	7131                	addi	sp,sp,-192
    80005d84:	fc86                	sd	ra,120(sp)
    80005d86:	f8a2                	sd	s0,112(sp)
    80005d88:	f4a6                	sd	s1,104(sp)
    80005d8a:	f0ca                	sd	s2,96(sp)
    80005d8c:	ecce                	sd	s3,88(sp)
    80005d8e:	e8d2                	sd	s4,80(sp)
    80005d90:	e4d6                	sd	s5,72(sp)
    80005d92:	e0da                	sd	s6,64(sp)
    80005d94:	fc5e                	sd	s7,56(sp)
    80005d96:	f862                	sd	s8,48(sp)
    80005d98:	f466                	sd	s9,40(sp)
    80005d9a:	f06a                	sd	s10,32(sp)
    80005d9c:	ec6e                	sd	s11,24(sp)
    80005d9e:	0100                	addi	s0,sp,128
    80005da0:	8a2a                	mv	s4,a0
    80005da2:	e40c                	sd	a1,8(s0)
    80005da4:	e810                	sd	a2,16(s0)
    80005da6:	ec14                	sd	a3,24(s0)
    80005da8:	f018                	sd	a4,32(s0)
    80005daa:	f41c                	sd	a5,40(s0)
    80005dac:	03043823          	sd	a6,48(s0)
    80005db0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005db4:	00240d97          	auipc	s11,0x240
    80005db8:	44cdad83          	lw	s11,1100(s11) # 80246200 <pr+0x18>
  if(locking)
    80005dbc:	020d9b63          	bnez	s11,80005df2 <printf+0x70>
  if (fmt == 0)
    80005dc0:	040a0263          	beqz	s4,80005e04 <printf+0x82>
  va_start(ap, fmt);
    80005dc4:	00840793          	addi	a5,s0,8
    80005dc8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dcc:	000a4503          	lbu	a0,0(s4)
    80005dd0:	16050263          	beqz	a0,80005f34 <printf+0x1b2>
    80005dd4:	4481                	li	s1,0
    if(c != '%'){
    80005dd6:	02500a93          	li	s5,37
    switch(c){
    80005dda:	07000b13          	li	s6,112
  consputc('x');
    80005dde:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005de0:	00003b97          	auipc	s7,0x3
    80005de4:	9e0b8b93          	addi	s7,s7,-1568 # 800087c0 <digits>
    switch(c){
    80005de8:	07300c93          	li	s9,115
    80005dec:	06400c13          	li	s8,100
    80005df0:	a82d                	j	80005e2a <printf+0xa8>
    acquire(&pr.lock);
    80005df2:	00240517          	auipc	a0,0x240
    80005df6:	3f650513          	addi	a0,a0,1014 # 802461e8 <pr>
    80005dfa:	00000097          	auipc	ra,0x0
    80005dfe:	488080e7          	jalr	1160(ra) # 80006282 <acquire>
    80005e02:	bf7d                	j	80005dc0 <printf+0x3e>
    panic("null fmt");
    80005e04:	00003517          	auipc	a0,0x3
    80005e08:	9a450513          	addi	a0,a0,-1628 # 800087a8 <syscalls+0x3e0>
    80005e0c:	00000097          	auipc	ra,0x0
    80005e10:	f2c080e7          	jalr	-212(ra) # 80005d38 <panic>
      consputc(c);
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	c62080e7          	jalr	-926(ra) # 80005a76 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e1c:	2485                	addiw	s1,s1,1
    80005e1e:	009a07b3          	add	a5,s4,s1
    80005e22:	0007c503          	lbu	a0,0(a5)
    80005e26:	10050763          	beqz	a0,80005f34 <printf+0x1b2>
    if(c != '%'){
    80005e2a:	ff5515e3          	bne	a0,s5,80005e14 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e2e:	2485                	addiw	s1,s1,1
    80005e30:	009a07b3          	add	a5,s4,s1
    80005e34:	0007c783          	lbu	a5,0(a5)
    80005e38:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e3c:	cfe5                	beqz	a5,80005f34 <printf+0x1b2>
    switch(c){
    80005e3e:	05678a63          	beq	a5,s6,80005e92 <printf+0x110>
    80005e42:	02fb7663          	bgeu	s6,a5,80005e6e <printf+0xec>
    80005e46:	09978963          	beq	a5,s9,80005ed8 <printf+0x156>
    80005e4a:	07800713          	li	a4,120
    80005e4e:	0ce79863          	bne	a5,a4,80005f1e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e52:	f8843783          	ld	a5,-120(s0)
    80005e56:	00878713          	addi	a4,a5,8
    80005e5a:	f8e43423          	sd	a4,-120(s0)
    80005e5e:	4605                	li	a2,1
    80005e60:	85ea                	mv	a1,s10
    80005e62:	4388                	lw	a0,0(a5)
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	e32080e7          	jalr	-462(ra) # 80005c96 <printint>
      break;
    80005e6c:	bf45                	j	80005e1c <printf+0x9a>
    switch(c){
    80005e6e:	0b578263          	beq	a5,s5,80005f12 <printf+0x190>
    80005e72:	0b879663          	bne	a5,s8,80005f1e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e76:	f8843783          	ld	a5,-120(s0)
    80005e7a:	00878713          	addi	a4,a5,8
    80005e7e:	f8e43423          	sd	a4,-120(s0)
    80005e82:	4605                	li	a2,1
    80005e84:	45a9                	li	a1,10
    80005e86:	4388                	lw	a0,0(a5)
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	e0e080e7          	jalr	-498(ra) # 80005c96 <printint>
      break;
    80005e90:	b771                	j	80005e1c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e92:	f8843783          	ld	a5,-120(s0)
    80005e96:	00878713          	addi	a4,a5,8
    80005e9a:	f8e43423          	sd	a4,-120(s0)
    80005e9e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005ea2:	03000513          	li	a0,48
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	bd0080e7          	jalr	-1072(ra) # 80005a76 <consputc>
  consputc('x');
    80005eae:	07800513          	li	a0,120
    80005eb2:	00000097          	auipc	ra,0x0
    80005eb6:	bc4080e7          	jalr	-1084(ra) # 80005a76 <consputc>
    80005eba:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ebc:	03c9d793          	srli	a5,s3,0x3c
    80005ec0:	97de                	add	a5,a5,s7
    80005ec2:	0007c503          	lbu	a0,0(a5)
    80005ec6:	00000097          	auipc	ra,0x0
    80005eca:	bb0080e7          	jalr	-1104(ra) # 80005a76 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ece:	0992                	slli	s3,s3,0x4
    80005ed0:	397d                	addiw	s2,s2,-1
    80005ed2:	fe0915e3          	bnez	s2,80005ebc <printf+0x13a>
    80005ed6:	b799                	j	80005e1c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005ed8:	f8843783          	ld	a5,-120(s0)
    80005edc:	00878713          	addi	a4,a5,8
    80005ee0:	f8e43423          	sd	a4,-120(s0)
    80005ee4:	0007b903          	ld	s2,0(a5)
    80005ee8:	00090e63          	beqz	s2,80005f04 <printf+0x182>
      for(; *s; s++)
    80005eec:	00094503          	lbu	a0,0(s2)
    80005ef0:	d515                	beqz	a0,80005e1c <printf+0x9a>
        consputc(*s);
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	b84080e7          	jalr	-1148(ra) # 80005a76 <consputc>
      for(; *s; s++)
    80005efa:	0905                	addi	s2,s2,1
    80005efc:	00094503          	lbu	a0,0(s2)
    80005f00:	f96d                	bnez	a0,80005ef2 <printf+0x170>
    80005f02:	bf29                	j	80005e1c <printf+0x9a>
        s = "(null)";
    80005f04:	00003917          	auipc	s2,0x3
    80005f08:	89c90913          	addi	s2,s2,-1892 # 800087a0 <syscalls+0x3d8>
      for(; *s; s++)
    80005f0c:	02800513          	li	a0,40
    80005f10:	b7cd                	j	80005ef2 <printf+0x170>
      consputc('%');
    80005f12:	8556                	mv	a0,s5
    80005f14:	00000097          	auipc	ra,0x0
    80005f18:	b62080e7          	jalr	-1182(ra) # 80005a76 <consputc>
      break;
    80005f1c:	b701                	j	80005e1c <printf+0x9a>
      consputc('%');
    80005f1e:	8556                	mv	a0,s5
    80005f20:	00000097          	auipc	ra,0x0
    80005f24:	b56080e7          	jalr	-1194(ra) # 80005a76 <consputc>
      consputc(c);
    80005f28:	854a                	mv	a0,s2
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	b4c080e7          	jalr	-1204(ra) # 80005a76 <consputc>
      break;
    80005f32:	b5ed                	j	80005e1c <printf+0x9a>
  if(locking)
    80005f34:	020d9163          	bnez	s11,80005f56 <printf+0x1d4>
}
    80005f38:	70e6                	ld	ra,120(sp)
    80005f3a:	7446                	ld	s0,112(sp)
    80005f3c:	74a6                	ld	s1,104(sp)
    80005f3e:	7906                	ld	s2,96(sp)
    80005f40:	69e6                	ld	s3,88(sp)
    80005f42:	6a46                	ld	s4,80(sp)
    80005f44:	6aa6                	ld	s5,72(sp)
    80005f46:	6b06                	ld	s6,64(sp)
    80005f48:	7be2                	ld	s7,56(sp)
    80005f4a:	7c42                	ld	s8,48(sp)
    80005f4c:	7ca2                	ld	s9,40(sp)
    80005f4e:	7d02                	ld	s10,32(sp)
    80005f50:	6de2                	ld	s11,24(sp)
    80005f52:	6129                	addi	sp,sp,192
    80005f54:	8082                	ret
    release(&pr.lock);
    80005f56:	00240517          	auipc	a0,0x240
    80005f5a:	29250513          	addi	a0,a0,658 # 802461e8 <pr>
    80005f5e:	00000097          	auipc	ra,0x0
    80005f62:	3d8080e7          	jalr	984(ra) # 80006336 <release>
}
    80005f66:	bfc9                	j	80005f38 <printf+0x1b6>

0000000080005f68 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f68:	1101                	addi	sp,sp,-32
    80005f6a:	ec06                	sd	ra,24(sp)
    80005f6c:	e822                	sd	s0,16(sp)
    80005f6e:	e426                	sd	s1,8(sp)
    80005f70:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f72:	00240497          	auipc	s1,0x240
    80005f76:	27648493          	addi	s1,s1,630 # 802461e8 <pr>
    80005f7a:	00003597          	auipc	a1,0x3
    80005f7e:	83e58593          	addi	a1,a1,-1986 # 800087b8 <syscalls+0x3f0>
    80005f82:	8526                	mv	a0,s1
    80005f84:	00000097          	auipc	ra,0x0
    80005f88:	26e080e7          	jalr	622(ra) # 800061f2 <initlock>
  pr.locking = 1;
    80005f8c:	4785                	li	a5,1
    80005f8e:	cc9c                	sw	a5,24(s1)
}
    80005f90:	60e2                	ld	ra,24(sp)
    80005f92:	6442                	ld	s0,16(sp)
    80005f94:	64a2                	ld	s1,8(sp)
    80005f96:	6105                	addi	sp,sp,32
    80005f98:	8082                	ret

0000000080005f9a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f9a:	1141                	addi	sp,sp,-16
    80005f9c:	e406                	sd	ra,8(sp)
    80005f9e:	e022                	sd	s0,0(sp)
    80005fa0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fa2:	100007b7          	lui	a5,0x10000
    80005fa6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005faa:	f8000713          	li	a4,-128
    80005fae:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fb2:	470d                	li	a4,3
    80005fb4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fb8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fbc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fc0:	469d                	li	a3,7
    80005fc2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fc6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fca:	00003597          	auipc	a1,0x3
    80005fce:	80e58593          	addi	a1,a1,-2034 # 800087d8 <digits+0x18>
    80005fd2:	00240517          	auipc	a0,0x240
    80005fd6:	23650513          	addi	a0,a0,566 # 80246208 <uart_tx_lock>
    80005fda:	00000097          	auipc	ra,0x0
    80005fde:	218080e7          	jalr	536(ra) # 800061f2 <initlock>
}
    80005fe2:	60a2                	ld	ra,8(sp)
    80005fe4:	6402                	ld	s0,0(sp)
    80005fe6:	0141                	addi	sp,sp,16
    80005fe8:	8082                	ret

0000000080005fea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fea:	1101                	addi	sp,sp,-32
    80005fec:	ec06                	sd	ra,24(sp)
    80005fee:	e822                	sd	s0,16(sp)
    80005ff0:	e426                	sd	s1,8(sp)
    80005ff2:	1000                	addi	s0,sp,32
    80005ff4:	84aa                	mv	s1,a0
  push_off();
    80005ff6:	00000097          	auipc	ra,0x0
    80005ffa:	240080e7          	jalr	576(ra) # 80006236 <push_off>

  if(panicked){
    80005ffe:	00003797          	auipc	a5,0x3
    80006002:	01e7a783          	lw	a5,30(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006006:	10000737          	lui	a4,0x10000
  if(panicked){
    8000600a:	c391                	beqz	a5,8000600e <uartputc_sync+0x24>
    for(;;)
    8000600c:	a001                	j	8000600c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000600e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006012:	0ff7f793          	andi	a5,a5,255
    80006016:	0207f793          	andi	a5,a5,32
    8000601a:	dbf5                	beqz	a5,8000600e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000601c:	0ff4f793          	andi	a5,s1,255
    80006020:	10000737          	lui	a4,0x10000
    80006024:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006028:	00000097          	auipc	ra,0x0
    8000602c:	2ae080e7          	jalr	686(ra) # 800062d6 <pop_off>
}
    80006030:	60e2                	ld	ra,24(sp)
    80006032:	6442                	ld	s0,16(sp)
    80006034:	64a2                	ld	s1,8(sp)
    80006036:	6105                	addi	sp,sp,32
    80006038:	8082                	ret

000000008000603a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000603a:	00003717          	auipc	a4,0x3
    8000603e:	fe673703          	ld	a4,-26(a4) # 80009020 <uart_tx_r>
    80006042:	00003797          	auipc	a5,0x3
    80006046:	fe67b783          	ld	a5,-26(a5) # 80009028 <uart_tx_w>
    8000604a:	06e78c63          	beq	a5,a4,800060c2 <uartstart+0x88>
{
    8000604e:	7139                	addi	sp,sp,-64
    80006050:	fc06                	sd	ra,56(sp)
    80006052:	f822                	sd	s0,48(sp)
    80006054:	f426                	sd	s1,40(sp)
    80006056:	f04a                	sd	s2,32(sp)
    80006058:	ec4e                	sd	s3,24(sp)
    8000605a:	e852                	sd	s4,16(sp)
    8000605c:	e456                	sd	s5,8(sp)
    8000605e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006060:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006064:	00240a17          	auipc	s4,0x240
    80006068:	1a4a0a13          	addi	s4,s4,420 # 80246208 <uart_tx_lock>
    uart_tx_r += 1;
    8000606c:	00003497          	auipc	s1,0x3
    80006070:	fb448493          	addi	s1,s1,-76 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006074:	00003997          	auipc	s3,0x3
    80006078:	fb498993          	addi	s3,s3,-76 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000607c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006080:	0ff7f793          	andi	a5,a5,255
    80006084:	0207f793          	andi	a5,a5,32
    80006088:	c785                	beqz	a5,800060b0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000608a:	01f77793          	andi	a5,a4,31
    8000608e:	97d2                	add	a5,a5,s4
    80006090:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006094:	0705                	addi	a4,a4,1
    80006096:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006098:	8526                	mv	a0,s1
    8000609a:	ffffb097          	auipc	ra,0xffffb
    8000609e:	754080e7          	jalr	1876(ra) # 800017ee <wakeup>
    
    WriteReg(THR, c);
    800060a2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060a6:	6098                	ld	a4,0(s1)
    800060a8:	0009b783          	ld	a5,0(s3)
    800060ac:	fce798e3          	bne	a5,a4,8000607c <uartstart+0x42>
  }
}
    800060b0:	70e2                	ld	ra,56(sp)
    800060b2:	7442                	ld	s0,48(sp)
    800060b4:	74a2                	ld	s1,40(sp)
    800060b6:	7902                	ld	s2,32(sp)
    800060b8:	69e2                	ld	s3,24(sp)
    800060ba:	6a42                	ld	s4,16(sp)
    800060bc:	6aa2                	ld	s5,8(sp)
    800060be:	6121                	addi	sp,sp,64
    800060c0:	8082                	ret
    800060c2:	8082                	ret

00000000800060c4 <uartputc>:
{
    800060c4:	7179                	addi	sp,sp,-48
    800060c6:	f406                	sd	ra,40(sp)
    800060c8:	f022                	sd	s0,32(sp)
    800060ca:	ec26                	sd	s1,24(sp)
    800060cc:	e84a                	sd	s2,16(sp)
    800060ce:	e44e                	sd	s3,8(sp)
    800060d0:	e052                	sd	s4,0(sp)
    800060d2:	1800                	addi	s0,sp,48
    800060d4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800060d6:	00240517          	auipc	a0,0x240
    800060da:	13250513          	addi	a0,a0,306 # 80246208 <uart_tx_lock>
    800060de:	00000097          	auipc	ra,0x0
    800060e2:	1a4080e7          	jalr	420(ra) # 80006282 <acquire>
  if(panicked){
    800060e6:	00003797          	auipc	a5,0x3
    800060ea:	f367a783          	lw	a5,-202(a5) # 8000901c <panicked>
    800060ee:	c391                	beqz	a5,800060f2 <uartputc+0x2e>
    for(;;)
    800060f0:	a001                	j	800060f0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060f2:	00003797          	auipc	a5,0x3
    800060f6:	f367b783          	ld	a5,-202(a5) # 80009028 <uart_tx_w>
    800060fa:	00003717          	auipc	a4,0x3
    800060fe:	f2673703          	ld	a4,-218(a4) # 80009020 <uart_tx_r>
    80006102:	02070713          	addi	a4,a4,32
    80006106:	02f71b63          	bne	a4,a5,8000613c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000610a:	00240a17          	auipc	s4,0x240
    8000610e:	0fea0a13          	addi	s4,s4,254 # 80246208 <uart_tx_lock>
    80006112:	00003497          	auipc	s1,0x3
    80006116:	f0e48493          	addi	s1,s1,-242 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000611a:	00003917          	auipc	s2,0x3
    8000611e:	f0e90913          	addi	s2,s2,-242 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006122:	85d2                	mv	a1,s4
    80006124:	8526                	mv	a0,s1
    80006126:	ffffb097          	auipc	ra,0xffffb
    8000612a:	53c080e7          	jalr	1340(ra) # 80001662 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000612e:	00093783          	ld	a5,0(s2)
    80006132:	6098                	ld	a4,0(s1)
    80006134:	02070713          	addi	a4,a4,32
    80006138:	fef705e3          	beq	a4,a5,80006122 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000613c:	00240497          	auipc	s1,0x240
    80006140:	0cc48493          	addi	s1,s1,204 # 80246208 <uart_tx_lock>
    80006144:	01f7f713          	andi	a4,a5,31
    80006148:	9726                	add	a4,a4,s1
    8000614a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000614e:	0785                	addi	a5,a5,1
    80006150:	00003717          	auipc	a4,0x3
    80006154:	ecf73c23          	sd	a5,-296(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	ee2080e7          	jalr	-286(ra) # 8000603a <uartstart>
      release(&uart_tx_lock);
    80006160:	8526                	mv	a0,s1
    80006162:	00000097          	auipc	ra,0x0
    80006166:	1d4080e7          	jalr	468(ra) # 80006336 <release>
}
    8000616a:	70a2                	ld	ra,40(sp)
    8000616c:	7402                	ld	s0,32(sp)
    8000616e:	64e2                	ld	s1,24(sp)
    80006170:	6942                	ld	s2,16(sp)
    80006172:	69a2                	ld	s3,8(sp)
    80006174:	6a02                	ld	s4,0(sp)
    80006176:	6145                	addi	sp,sp,48
    80006178:	8082                	ret

000000008000617a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000617a:	1141                	addi	sp,sp,-16
    8000617c:	e422                	sd	s0,8(sp)
    8000617e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006180:	100007b7          	lui	a5,0x10000
    80006184:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006188:	8b85                	andi	a5,a5,1
    8000618a:	cb91                	beqz	a5,8000619e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000618c:	100007b7          	lui	a5,0x10000
    80006190:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006194:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006198:	6422                	ld	s0,8(sp)
    8000619a:	0141                	addi	sp,sp,16
    8000619c:	8082                	ret
    return -1;
    8000619e:	557d                	li	a0,-1
    800061a0:	bfe5                	j	80006198 <uartgetc+0x1e>

00000000800061a2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061a2:	1101                	addi	sp,sp,-32
    800061a4:	ec06                	sd	ra,24(sp)
    800061a6:	e822                	sd	s0,16(sp)
    800061a8:	e426                	sd	s1,8(sp)
    800061aa:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061ac:	54fd                	li	s1,-1
    int c = uartgetc();
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	fcc080e7          	jalr	-52(ra) # 8000617a <uartgetc>
    if(c == -1)
    800061b6:	00950763          	beq	a0,s1,800061c4 <uartintr+0x22>
      break;
    consoleintr(c);
    800061ba:	00000097          	auipc	ra,0x0
    800061be:	8fe080e7          	jalr	-1794(ra) # 80005ab8 <consoleintr>
  while(1){
    800061c2:	b7f5                	j	800061ae <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061c4:	00240497          	auipc	s1,0x240
    800061c8:	04448493          	addi	s1,s1,68 # 80246208 <uart_tx_lock>
    800061cc:	8526                	mv	a0,s1
    800061ce:	00000097          	auipc	ra,0x0
    800061d2:	0b4080e7          	jalr	180(ra) # 80006282 <acquire>
  uartstart();
    800061d6:	00000097          	auipc	ra,0x0
    800061da:	e64080e7          	jalr	-412(ra) # 8000603a <uartstart>
  release(&uart_tx_lock);
    800061de:	8526                	mv	a0,s1
    800061e0:	00000097          	auipc	ra,0x0
    800061e4:	156080e7          	jalr	342(ra) # 80006336 <release>
}
    800061e8:	60e2                	ld	ra,24(sp)
    800061ea:	6442                	ld	s0,16(sp)
    800061ec:	64a2                	ld	s1,8(sp)
    800061ee:	6105                	addi	sp,sp,32
    800061f0:	8082                	ret

00000000800061f2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061f2:	1141                	addi	sp,sp,-16
    800061f4:	e422                	sd	s0,8(sp)
    800061f6:	0800                	addi	s0,sp,16
  lk->name = name;
    800061f8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061fa:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061fe:	00053823          	sd	zero,16(a0)
}
    80006202:	6422                	ld	s0,8(sp)
    80006204:	0141                	addi	sp,sp,16
    80006206:	8082                	ret

0000000080006208 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006208:	411c                	lw	a5,0(a0)
    8000620a:	e399                	bnez	a5,80006210 <holding+0x8>
    8000620c:	4501                	li	a0,0
  return r;
}
    8000620e:	8082                	ret
{
    80006210:	1101                	addi	sp,sp,-32
    80006212:	ec06                	sd	ra,24(sp)
    80006214:	e822                	sd	s0,16(sp)
    80006216:	e426                	sd	s1,8(sp)
    80006218:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000621a:	6904                	ld	s1,16(a0)
    8000621c:	ffffb097          	auipc	ra,0xffffb
    80006220:	d6e080e7          	jalr	-658(ra) # 80000f8a <mycpu>
    80006224:	40a48533          	sub	a0,s1,a0
    80006228:	00153513          	seqz	a0,a0
}
    8000622c:	60e2                	ld	ra,24(sp)
    8000622e:	6442                	ld	s0,16(sp)
    80006230:	64a2                	ld	s1,8(sp)
    80006232:	6105                	addi	sp,sp,32
    80006234:	8082                	ret

0000000080006236 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006236:	1101                	addi	sp,sp,-32
    80006238:	ec06                	sd	ra,24(sp)
    8000623a:	e822                	sd	s0,16(sp)
    8000623c:	e426                	sd	s1,8(sp)
    8000623e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006240:	100024f3          	csrr	s1,sstatus
    80006244:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006248:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000624a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000624e:	ffffb097          	auipc	ra,0xffffb
    80006252:	d3c080e7          	jalr	-708(ra) # 80000f8a <mycpu>
    80006256:	5d3c                	lw	a5,120(a0)
    80006258:	cf89                	beqz	a5,80006272 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000625a:	ffffb097          	auipc	ra,0xffffb
    8000625e:	d30080e7          	jalr	-720(ra) # 80000f8a <mycpu>
    80006262:	5d3c                	lw	a5,120(a0)
    80006264:	2785                	addiw	a5,a5,1
    80006266:	dd3c                	sw	a5,120(a0)
}
    80006268:	60e2                	ld	ra,24(sp)
    8000626a:	6442                	ld	s0,16(sp)
    8000626c:	64a2                	ld	s1,8(sp)
    8000626e:	6105                	addi	sp,sp,32
    80006270:	8082                	ret
    mycpu()->intena = old;
    80006272:	ffffb097          	auipc	ra,0xffffb
    80006276:	d18080e7          	jalr	-744(ra) # 80000f8a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000627a:	8085                	srli	s1,s1,0x1
    8000627c:	8885                	andi	s1,s1,1
    8000627e:	dd64                	sw	s1,124(a0)
    80006280:	bfe9                	j	8000625a <push_off+0x24>

0000000080006282 <acquire>:
{
    80006282:	1101                	addi	sp,sp,-32
    80006284:	ec06                	sd	ra,24(sp)
    80006286:	e822                	sd	s0,16(sp)
    80006288:	e426                	sd	s1,8(sp)
    8000628a:	1000                	addi	s0,sp,32
    8000628c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	fa8080e7          	jalr	-88(ra) # 80006236 <push_off>
  if(holding(lk))
    80006296:	8526                	mv	a0,s1
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	f70080e7          	jalr	-144(ra) # 80006208 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062a0:	4705                	li	a4,1
  if(holding(lk))
    800062a2:	e115                	bnez	a0,800062c6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062a4:	87ba                	mv	a5,a4
    800062a6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062aa:	2781                	sext.w	a5,a5
    800062ac:	ffe5                	bnez	a5,800062a4 <acquire+0x22>
  __sync_synchronize();
    800062ae:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062b2:	ffffb097          	auipc	ra,0xffffb
    800062b6:	cd8080e7          	jalr	-808(ra) # 80000f8a <mycpu>
    800062ba:	e888                	sd	a0,16(s1)
}
    800062bc:	60e2                	ld	ra,24(sp)
    800062be:	6442                	ld	s0,16(sp)
    800062c0:	64a2                	ld	s1,8(sp)
    800062c2:	6105                	addi	sp,sp,32
    800062c4:	8082                	ret
    panic("acquire");
    800062c6:	00002517          	auipc	a0,0x2
    800062ca:	51a50513          	addi	a0,a0,1306 # 800087e0 <digits+0x20>
    800062ce:	00000097          	auipc	ra,0x0
    800062d2:	a6a080e7          	jalr	-1430(ra) # 80005d38 <panic>

00000000800062d6 <pop_off>:

void
pop_off(void)
{
    800062d6:	1141                	addi	sp,sp,-16
    800062d8:	e406                	sd	ra,8(sp)
    800062da:	e022                	sd	s0,0(sp)
    800062dc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	cac080e7          	jalr	-852(ra) # 80000f8a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062e6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062ea:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062ec:	e78d                	bnez	a5,80006316 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062ee:	5d3c                	lw	a5,120(a0)
    800062f0:	02f05b63          	blez	a5,80006326 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062f4:	37fd                	addiw	a5,a5,-1
    800062f6:	0007871b          	sext.w	a4,a5
    800062fa:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062fc:	eb09                	bnez	a4,8000630e <pop_off+0x38>
    800062fe:	5d7c                	lw	a5,124(a0)
    80006300:	c799                	beqz	a5,8000630e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006302:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006306:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000630a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000630e:	60a2                	ld	ra,8(sp)
    80006310:	6402                	ld	s0,0(sp)
    80006312:	0141                	addi	sp,sp,16
    80006314:	8082                	ret
    panic("pop_off - interruptible");
    80006316:	00002517          	auipc	a0,0x2
    8000631a:	4d250513          	addi	a0,a0,1234 # 800087e8 <digits+0x28>
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	a1a080e7          	jalr	-1510(ra) # 80005d38 <panic>
    panic("pop_off");
    80006326:	00002517          	auipc	a0,0x2
    8000632a:	4da50513          	addi	a0,a0,1242 # 80008800 <digits+0x40>
    8000632e:	00000097          	auipc	ra,0x0
    80006332:	a0a080e7          	jalr	-1526(ra) # 80005d38 <panic>

0000000080006336 <release>:
{
    80006336:	1101                	addi	sp,sp,-32
    80006338:	ec06                	sd	ra,24(sp)
    8000633a:	e822                	sd	s0,16(sp)
    8000633c:	e426                	sd	s1,8(sp)
    8000633e:	1000                	addi	s0,sp,32
    80006340:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006342:	00000097          	auipc	ra,0x0
    80006346:	ec6080e7          	jalr	-314(ra) # 80006208 <holding>
    8000634a:	c115                	beqz	a0,8000636e <release+0x38>
  lk->cpu = 0;
    8000634c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006350:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006354:	0f50000f          	fence	iorw,ow
    80006358:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000635c:	00000097          	auipc	ra,0x0
    80006360:	f7a080e7          	jalr	-134(ra) # 800062d6 <pop_off>
}
    80006364:	60e2                	ld	ra,24(sp)
    80006366:	6442                	ld	s0,16(sp)
    80006368:	64a2                	ld	s1,8(sp)
    8000636a:	6105                	addi	sp,sp,32
    8000636c:	8082                	ret
    panic("release");
    8000636e:	00002517          	auipc	a0,0x2
    80006372:	49a50513          	addi	a0,a0,1178 # 80008808 <digits+0x48>
    80006376:	00000097          	auipc	ra,0x0
    8000637a:	9c2080e7          	jalr	-1598(ra) # 80005d38 <panic>
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
