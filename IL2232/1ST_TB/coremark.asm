
./coremark.exe:     file format elf32-littleriscv


Disassembly of section .text._start:

80000000 <_start>:
extern void main(void);

void _start(void) __attribute__((naked, section(".text._start")));
void _start(void)
{
    asm volatile (
80000000:	00100117          	auipc	sp,0x100
80000004:	00010113          	mv	sp,sp
        "la sp, _stack_top\n" 
    );
    extern unsigned int _sbss, _ebss;
    for (unsigned int *p = &_sbss; p < &_ebss; p++)
80000008:	800057b7          	lui	a5,0x80005
8000000c:	1a478493          	addi	s1,a5,420 # 800051a4 <start_time_val>
80000010:	00c0006f          	j	8000001c <_start+0x1c>
        *p = 0;
80000014:	0004a023          	sw	zero,0(s1)
    for (unsigned int *p = &_sbss; p < &_ebss; p++)
80000018:	00448493          	addi	s1,s1,4
8000001c:	800057b7          	lui	a5,0x80005
80000020:	1ac78793          	addi	a5,a5,428 # 800051ac <seed5_volatile>
80000024:	fef4e8e3          	bltu	s1,a5,80000014 <_start+0x14>
    main();
80000028:	7a1000ef          	jal	80000fc8 <main>
    asm volatile (
8000002c:	77777fb7          	lui	t6,0x77777
80000030:	777f8f93          	addi	t6,t6,1911 # 77777777 <_start-0x8888889>
        "la t6, 0x77777777\n" 
    );
    asm volatile (
80000034:	00100073          	ebreak
        "ebreak\n" 
    );
    for(;;);
80000038:	0000006f          	j	80000038 <_start+0x38>

Disassembly of section .text:

8000003c <calc_func>:
                               list_cmp      cmp,
                               core_results *res);

ee_s16
calc_func(ee_s16 *pdata, core_results *res)
{
8000003c:	fd010113          	addi	sp,sp,-48 # 800fffd0 <seed5_volatile+0xfae24>
80000040:	02112623          	sw	ra,44(sp)
80000044:	02812423          	sw	s0,40(sp)
80000048:	03010413          	addi	s0,sp,48
8000004c:	fca42e23          	sw	a0,-36(s0)
80000050:	fcb42c23          	sw	a1,-40(s0)
    ee_s16 data = *pdata;
80000054:	fdc42783          	lw	a5,-36(s0)
80000058:	0007d783          	lhu	a5,0(a5)
8000005c:	fef41523          	sh	a5,-22(s0)
    ee_s16 retval;
    ee_u8  optype
        = (data >> 7)
          & 1;  /* bit 7 indicates if the function result has been cached */
80000060:	fea41783          	lh	a5,-22(s0)
80000064:	4077d793          	srai	a5,a5,0x7
80000068:	01079793          	slli	a5,a5,0x10
8000006c:	4107d793          	srai	a5,a5,0x10
80000070:	0ff7f793          	zext.b	a5,a5
    ee_u8  optype
80000074:	0017f793          	andi	a5,a5,1
80000078:	fef404a3          	sb	a5,-23(s0)
    if (optype) /* if cached, use cache */
8000007c:	fe944783          	lbu	a5,-23(s0)
80000080:	00078c63          	beqz	a5,80000098 <calc_func+0x5c>
        return (data & 0x007f);
80000084:	fea45783          	lhu	a5,-22(s0)
80000088:	07f7f793          	andi	a5,a5,127
8000008c:	01079793          	slli	a5,a5,0x10
80000090:	4107d793          	srai	a5,a5,0x10
80000094:	18c0006f          	j	80000220 <calc_func+0x1e4>
    else
    {                             /* otherwise calculate and cache the result */
        ee_s16 flag = data & 0x7; /* bits 0-2 is type of function to perform */
80000098:	fea45783          	lhu	a5,-22(s0)
8000009c:	0077f793          	andi	a5,a5,7
800000a0:	fef41323          	sh	a5,-26(s0)
        ee_s16 dtype
            = ((data >> 3)
               & 0xf);       /* bits 3-6 is specific data for the operation */
800000a4:	fea41783          	lh	a5,-22(s0)
800000a8:	4037d793          	srai	a5,a5,0x3
800000ac:	01079793          	slli	a5,a5,0x10
800000b0:	4107d793          	srai	a5,a5,0x10
        ee_s16 dtype
800000b4:	00f7f793          	andi	a5,a5,15
800000b8:	fef41623          	sh	a5,-20(s0)
        dtype |= dtype << 4; /* replicate the lower 4 bits to get an 8b value */
800000bc:	fec45783          	lhu	a5,-20(s0)
800000c0:	00479793          	slli	a5,a5,0x4
800000c4:	01079793          	slli	a5,a5,0x10
800000c8:	4107d793          	srai	a5,a5,0x10
800000cc:	fec45703          	lhu	a4,-20(s0)
800000d0:	00e7e7b3          	or	a5,a5,a4
800000d4:	fef41623          	sh	a5,-20(s0)
        switch (flag)
800000d8:	fe641783          	lh	a5,-26(s0)
800000dc:	00078863          	beqz	a5,800000ec <calc_func+0xb0>
800000e0:	00100713          	li	a4,1
800000e4:	06e78863          	beq	a5,a4,80000154 <calc_func+0x118>
800000e8:	0b40006f          	j	8000019c <calc_func+0x160>
        {
            case 0:
                if (dtype < 0x22) /* set min period for bit corruption */
800000ec:	fec41703          	lh	a4,-20(s0)
800000f0:	02100793          	li	a5,33
800000f4:	00e7c663          	blt	a5,a4,80000100 <calc_func+0xc4>
                    dtype = 0x22;
800000f8:	02200793          	li	a5,34
800000fc:	fef41623          	sh	a5,-20(s0)
                retval = core_bench_state(res->size,
80000100:	fd842783          	lw	a5,-40(s0)
80000104:	0187a503          	lw	a0,24(a5)
                                          res->memblock[3],
80000108:	fd842783          	lw	a5,-40(s0)
8000010c:	0147a583          	lw	a1,20(a5)
                retval = core_bench_state(res->size,
80000110:	fd842783          	lw	a5,-40(s0)
80000114:	00079603          	lh	a2,0(a5)
80000118:	fd842783          	lw	a5,-40(s0)
8000011c:	00279683          	lh	a3,2(a5)
80000120:	fd842783          	lw	a5,-40(s0)
80000124:	0387d783          	lhu	a5,56(a5)
80000128:	fec41703          	lh	a4,-20(s0)
8000012c:	261020ef          	jal	80002b8c <core_bench_state>
80000130:	00050793          	mv	a5,a0
80000134:	fef41723          	sh	a5,-18(s0)
                                          res->seed1,
                                          res->seed2,
                                          dtype,
                                          res->crc);
                if (res->crcstate == 0)
80000138:	fd842783          	lw	a5,-40(s0)
8000013c:	03e7d783          	lhu	a5,62(a5)
80000140:	06079463          	bnez	a5,800001a8 <calc_func+0x16c>
                    res->crcstate = retval;
80000144:	fee45703          	lhu	a4,-18(s0)
80000148:	fd842783          	lw	a5,-40(s0)
8000014c:	02e79f23          	sh	a4,62(a5)
                break;
80000150:	0580006f          	j	800001a8 <calc_func+0x16c>
            case 1:
                retval = core_bench_matrix(&(res->mat), dtype, res->crc);
80000154:	fd842783          	lw	a5,-40(s0)
80000158:	02878713          	addi	a4,a5,40
8000015c:	fd842783          	lw	a5,-40(s0)
80000160:	0387d683          	lhu	a3,56(a5)
80000164:	fec41783          	lh	a5,-20(s0)
80000168:	00068613          	mv	a2,a3
8000016c:	00078593          	mv	a1,a5
80000170:	00070513          	mv	a0,a4
80000174:	5b9010ef          	jal	80001f2c <core_bench_matrix>
80000178:	00050793          	mv	a5,a0
8000017c:	fef41723          	sh	a5,-18(s0)
                if (res->crcmatrix == 0)
80000180:	fd842783          	lw	a5,-40(s0)
80000184:	03c7d783          	lhu	a5,60(a5)
80000188:	02079463          	bnez	a5,800001b0 <calc_func+0x174>
                    res->crcmatrix = retval;
8000018c:	fee45703          	lhu	a4,-18(s0)
80000190:	fd842783          	lw	a5,-40(s0)
80000194:	02e79e23          	sh	a4,60(a5)
                break;
80000198:	0180006f          	j	800001b0 <calc_func+0x174>
            default:
                retval = data;
8000019c:	fea45783          	lhu	a5,-22(s0)
800001a0:	fef41723          	sh	a5,-18(s0)
                break;
800001a4:	0100006f          	j	800001b4 <calc_func+0x178>
                break;
800001a8:	00000013          	nop
800001ac:	0080006f          	j	800001b4 <calc_func+0x178>
                break;
800001b0:	00000013          	nop
        }
        res->crc = crcu16(retval, res->crc);
800001b4:	fee45703          	lhu	a4,-18(s0)
800001b8:	fd842783          	lw	a5,-40(s0)
800001bc:	0387d783          	lhu	a5,56(a5)
800001c0:	00078593          	mv	a1,a5
800001c4:	00070513          	mv	a0,a4
800001c8:	558030ef          	jal	80003720 <crcu16>
800001cc:	00050793          	mv	a5,a0
800001d0:	00078713          	mv	a4,a5
800001d4:	fd842783          	lw	a5,-40(s0)
800001d8:	02e79c23          	sh	a4,56(a5)
        retval &= 0x007f;
800001dc:	fee45783          	lhu	a5,-18(s0)
800001e0:	07f7f793          	andi	a5,a5,127
800001e4:	fef41723          	sh	a5,-18(s0)
        *pdata = (data & 0xff00) | 0x0080 | retval; /* cache the result */
800001e8:	fea45783          	lhu	a5,-22(s0)
800001ec:	f007f793          	andi	a5,a5,-256
800001f0:	01079793          	slli	a5,a5,0x10
800001f4:	4107d793          	srai	a5,a5,0x10
800001f8:	0807e793          	ori	a5,a5,128
800001fc:	01079793          	slli	a5,a5,0x10
80000200:	4107d793          	srai	a5,a5,0x10
80000204:	fee45703          	lhu	a4,-18(s0)
80000208:	00e7e7b3          	or	a5,a5,a4
8000020c:	01079713          	slli	a4,a5,0x10
80000210:	41075713          	srai	a4,a4,0x10
80000214:	fdc42783          	lw	a5,-36(s0)
80000218:	00e79023          	sh	a4,0(a5)
        return retval;
8000021c:	fee41783          	lh	a5,-18(s0)
    }
}
80000220:	00078513          	mv	a0,a5
80000224:	02c12083          	lw	ra,44(sp)
80000228:	02812403          	lw	s0,40(sp)
8000022c:	03010113          	addi	sp,sp,48
80000230:	00008067          	ret

80000234 <cmp_complex>:

        Can be used by mergesort.
*/
ee_s32
cmp_complex(list_data *a, list_data *b, core_results *res)
{
80000234:	fd010113          	addi	sp,sp,-48
80000238:	02112623          	sw	ra,44(sp)
8000023c:	02812423          	sw	s0,40(sp)
80000240:	03010413          	addi	s0,sp,48
80000244:	fca42e23          	sw	a0,-36(s0)
80000248:	fcb42c23          	sw	a1,-40(s0)
8000024c:	fcc42a23          	sw	a2,-44(s0)
    ee_s16 val1 = calc_func(&(a->data16), res);
80000250:	fdc42783          	lw	a5,-36(s0)
80000254:	fd442583          	lw	a1,-44(s0)
80000258:	00078513          	mv	a0,a5
8000025c:	de1ff0ef          	jal	8000003c <calc_func>
80000260:	00050793          	mv	a5,a0
80000264:	fef41723          	sh	a5,-18(s0)
    ee_s16 val2 = calc_func(&(b->data16), res);
80000268:	fd842783          	lw	a5,-40(s0)
8000026c:	fd442583          	lw	a1,-44(s0)
80000270:	00078513          	mv	a0,a5
80000274:	dc9ff0ef          	jal	8000003c <calc_func>
80000278:	00050793          	mv	a5,a0
8000027c:	fef41623          	sh	a5,-20(s0)
    return val1 - val2;
80000280:	fee41703          	lh	a4,-18(s0)
80000284:	fec41783          	lh	a5,-20(s0)
80000288:	40f707b3          	sub	a5,a4,a5
}
8000028c:	00078513          	mv	a0,a5
80000290:	02c12083          	lw	ra,44(sp)
80000294:	02812403          	lw	s0,40(sp)
80000298:	03010113          	addi	sp,sp,48
8000029c:	00008067          	ret

800002a0 <cmp_idx>:

        Can be used by mergesort.
*/
ee_s32
cmp_idx(list_data *a, list_data *b, core_results *res)
{
800002a0:	fe010113          	addi	sp,sp,-32
800002a4:	00112e23          	sw	ra,28(sp)
800002a8:	00812c23          	sw	s0,24(sp)
800002ac:	02010413          	addi	s0,sp,32
800002b0:	fea42623          	sw	a0,-20(s0)
800002b4:	feb42423          	sw	a1,-24(s0)
800002b8:	fec42223          	sw	a2,-28(s0)
    if (res == NULL)
800002bc:	fe442783          	lw	a5,-28(s0)
800002c0:	08079e63          	bnez	a5,8000035c <cmp_idx+0xbc>
    {
        a->data16 = (a->data16 & 0xff00) | (0x00ff & (a->data16 >> 8));
800002c4:	fec42783          	lw	a5,-20(s0)
800002c8:	00079783          	lh	a5,0(a5)
800002cc:	f007f793          	andi	a5,a5,-256
800002d0:	01079713          	slli	a4,a5,0x10
800002d4:	41075713          	srai	a4,a4,0x10
800002d8:	fec42783          	lw	a5,-20(s0)
800002dc:	00079783          	lh	a5,0(a5)
800002e0:	01079793          	slli	a5,a5,0x10
800002e4:	0107d793          	srli	a5,a5,0x10
800002e8:	0087d793          	srli	a5,a5,0x8
800002ec:	01079793          	slli	a5,a5,0x10
800002f0:	0107d793          	srli	a5,a5,0x10
800002f4:	01079793          	slli	a5,a5,0x10
800002f8:	4107d793          	srai	a5,a5,0x10
800002fc:	00f767b3          	or	a5,a4,a5
80000300:	01079713          	slli	a4,a5,0x10
80000304:	41075713          	srai	a4,a4,0x10
80000308:	fec42783          	lw	a5,-20(s0)
8000030c:	00e79023          	sh	a4,0(a5)
        b->data16 = (b->data16 & 0xff00) | (0x00ff & (b->data16 >> 8));
80000310:	fe842783          	lw	a5,-24(s0)
80000314:	00079783          	lh	a5,0(a5)
80000318:	f007f793          	andi	a5,a5,-256
8000031c:	01079713          	slli	a4,a5,0x10
80000320:	41075713          	srai	a4,a4,0x10
80000324:	fe842783          	lw	a5,-24(s0)
80000328:	00079783          	lh	a5,0(a5)
8000032c:	01079793          	slli	a5,a5,0x10
80000330:	0107d793          	srli	a5,a5,0x10
80000334:	0087d793          	srli	a5,a5,0x8
80000338:	01079793          	slli	a5,a5,0x10
8000033c:	0107d793          	srli	a5,a5,0x10
80000340:	01079793          	slli	a5,a5,0x10
80000344:	4107d793          	srai	a5,a5,0x10
80000348:	00f767b3          	or	a5,a4,a5
8000034c:	01079713          	slli	a4,a5,0x10
80000350:	41075713          	srai	a4,a4,0x10
80000354:	fe842783          	lw	a5,-24(s0)
80000358:	00e79023          	sh	a4,0(a5)
    }
    return a->idx - b->idx;
8000035c:	fec42783          	lw	a5,-20(s0)
80000360:	00279783          	lh	a5,2(a5)
80000364:	00078713          	mv	a4,a5
80000368:	fe842783          	lw	a5,-24(s0)
8000036c:	00279783          	lh	a5,2(a5)
80000370:	40f707b3          	sub	a5,a4,a5
}
80000374:	00078513          	mv	a0,a5
80000378:	01c12083          	lw	ra,28(sp)
8000037c:	01812403          	lw	s0,24(sp)
80000380:	02010113          	addi	sp,sp,32
80000384:	00008067          	ret

80000388 <copy_info>:

void
copy_info(list_data *to, list_data *from)
{
80000388:	fe010113          	addi	sp,sp,-32
8000038c:	00112e23          	sw	ra,28(sp)
80000390:	00812c23          	sw	s0,24(sp)
80000394:	02010413          	addi	s0,sp,32
80000398:	fea42623          	sw	a0,-20(s0)
8000039c:	feb42423          	sw	a1,-24(s0)
    to->data16 = from->data16;
800003a0:	fe842783          	lw	a5,-24(s0)
800003a4:	00079703          	lh	a4,0(a5)
800003a8:	fec42783          	lw	a5,-20(s0)
800003ac:	00e79023          	sh	a4,0(a5)
    to->idx    = from->idx;
800003b0:	fe842783          	lw	a5,-24(s0)
800003b4:	00279703          	lh	a4,2(a5)
800003b8:	fec42783          	lw	a5,-20(s0)
800003bc:	00e79123          	sh	a4,2(a5)
}
800003c0:	00000013          	nop
800003c4:	01c12083          	lw	ra,28(sp)
800003c8:	01812403          	lw	s0,24(sp)
800003cc:	02010113          	addi	sp,sp,32
800003d0:	00008067          	ret

800003d4 <core_bench_list>:
        - Single remove/reinsert
        * At the end of this function, the list is back to original state
*/
ee_u16
core_bench_list(core_results *res, ee_s16 finder_idx)
{
800003d4:	fc010113          	addi	sp,sp,-64
800003d8:	02112e23          	sw	ra,60(sp)
800003dc:	02812c23          	sw	s0,56(sp)
800003e0:	04010413          	addi	s0,sp,64
800003e4:	fca42623          	sw	a0,-52(s0)
800003e8:	00058793          	mv	a5,a1
800003ec:	fcf41523          	sh	a5,-54(s0)
    ee_u16     retval = 0;
800003f0:	fe041723          	sh	zero,-18(s0)
    ee_u16     found = 0, missed = 0;
800003f4:	fe041623          	sh	zero,-20(s0)
800003f8:	fe041523          	sh	zero,-22(s0)
    list_head *list     = res->list;
800003fc:	fcc42783          	lw	a5,-52(s0)
80000400:	0247a783          	lw	a5,36(a5)
80000404:	fef42223          	sw	a5,-28(s0)
    ee_s16     find_num = res->seed3;
80000408:	fcc42783          	lw	a5,-52(s0)
8000040c:	0047d783          	lhu	a5,4(a5)
80000410:	fcf41e23          	sh	a5,-36(s0)
    list_head *this_find;
    list_head *finder, *remover;
    list_data  info = {0};
80000414:	fc042823          	sw	zero,-48(s0)
    ee_s16     i;

    info.idx = finder_idx;
80000418:	fca45783          	lhu	a5,-54(s0)
8000041c:	fcf41923          	sh	a5,-46(s0)
    /* find <find_num> values in the list, and change the list each time
     * (reverse and cache if value found) */
    for (i = 0; i < find_num; i++)
80000420:	fc041f23          	sh	zero,-34(s0)
80000424:	1780006f          	j	8000059c <core_bench_list+0x1c8>
    {
        info.data16 = (i & 0xff);
80000428:	fde45783          	lhu	a5,-34(s0)
8000042c:	0ff7f793          	zext.b	a5,a5
80000430:	01079793          	slli	a5,a5,0x10
80000434:	4107d793          	srai	a5,a5,0x10
80000438:	fcf41823          	sh	a5,-48(s0)
        this_find   = core_list_find(list, &info);
8000043c:	fd040793          	addi	a5,s0,-48
80000440:	00078593          	mv	a1,a5
80000444:	fe442503          	lw	a0,-28(s0)
80000448:	758000ef          	jal	80000ba0 <core_list_find>
8000044c:	fca42a23          	sw	a0,-44(s0)
        list        = core_list_reverse(list);
80000450:	fe442503          	lw	a0,-28(s0)
80000454:	7f8000ef          	jal	80000c4c <core_list_reverse>
80000458:	fea42223          	sw	a0,-28(s0)
        if (this_find == NULL)
8000045c:	fd442783          	lw	a5,-44(s0)
80000460:	04079863          	bnez	a5,800004b0 <core_bench_list+0xdc>
        {
            missed++;
80000464:	fea45783          	lhu	a5,-22(s0)
80000468:	00178793          	addi	a5,a5,1
8000046c:	fef41523          	sh	a5,-22(s0)
            retval += (list->next->info->data16 >> 8) & 1;
80000470:	fe442783          	lw	a5,-28(s0)
80000474:	0007a783          	lw	a5,0(a5)
80000478:	0047a783          	lw	a5,4(a5)
8000047c:	00079783          	lh	a5,0(a5)
80000480:	4087d793          	srai	a5,a5,0x8
80000484:	01079793          	slli	a5,a5,0x10
80000488:	4107d793          	srai	a5,a5,0x10
8000048c:	01079793          	slli	a5,a5,0x10
80000490:	0107d793          	srli	a5,a5,0x10
80000494:	0017f793          	andi	a5,a5,1
80000498:	01079793          	slli	a5,a5,0x10
8000049c:	0107d793          	srli	a5,a5,0x10
800004a0:	fee45703          	lhu	a4,-18(s0)
800004a4:	00e787b3          	add	a5,a5,a4
800004a8:	fef41723          	sh	a5,-18(s0)
800004ac:	0a80006f          	j	80000554 <core_bench_list+0x180>
        }
        else
        {
            found++;
800004b0:	fec45783          	lhu	a5,-20(s0)
800004b4:	00178793          	addi	a5,a5,1
800004b8:	fef41623          	sh	a5,-20(s0)
            if (this_find->info->data16 & 0x1) /* use found value */
800004bc:	fd442783          	lw	a5,-44(s0)
800004c0:	0047a783          	lw	a5,4(a5)
800004c4:	00079783          	lh	a5,0(a5)
800004c8:	01079793          	slli	a5,a5,0x10
800004cc:	0107d793          	srli	a5,a5,0x10
800004d0:	0017f793          	andi	a5,a5,1
800004d4:	02078e63          	beqz	a5,80000510 <core_bench_list+0x13c>
                retval += (this_find->info->data16 >> 9) & 1;
800004d8:	fd442783          	lw	a5,-44(s0)
800004dc:	0047a783          	lw	a5,4(a5)
800004e0:	00079783          	lh	a5,0(a5)
800004e4:	4097d793          	srai	a5,a5,0x9
800004e8:	01079793          	slli	a5,a5,0x10
800004ec:	4107d793          	srai	a5,a5,0x10
800004f0:	01079793          	slli	a5,a5,0x10
800004f4:	0107d793          	srli	a5,a5,0x10
800004f8:	0017f793          	andi	a5,a5,1
800004fc:	01079793          	slli	a5,a5,0x10
80000500:	0107d793          	srli	a5,a5,0x10
80000504:	fee45703          	lhu	a4,-18(s0)
80000508:	00e787b3          	add	a5,a5,a4
8000050c:	fef41723          	sh	a5,-18(s0)
            /* and cache next item at the head of the list (if any) */
            if (this_find->next != NULL)
80000510:	fd442783          	lw	a5,-44(s0)
80000514:	0007a783          	lw	a5,0(a5)
80000518:	02078e63          	beqz	a5,80000554 <core_bench_list+0x180>
            {
                finder          = this_find->next;
8000051c:	fd442783          	lw	a5,-44(s0)
80000520:	0007a783          	lw	a5,0(a5)
80000524:	fef42023          	sw	a5,-32(s0)
                this_find->next = finder->next;
80000528:	fe042783          	lw	a5,-32(s0)
8000052c:	0007a703          	lw	a4,0(a5)
80000530:	fd442783          	lw	a5,-44(s0)
80000534:	00e7a023          	sw	a4,0(a5)
                finder->next    = list->next;
80000538:	fe442783          	lw	a5,-28(s0)
8000053c:	0007a703          	lw	a4,0(a5)
80000540:	fe042783          	lw	a5,-32(s0)
80000544:	00e7a023          	sw	a4,0(a5)
                list->next      = finder;
80000548:	fe442783          	lw	a5,-28(s0)
8000054c:	fe042703          	lw	a4,-32(s0)
80000550:	00e7a023          	sw	a4,0(a5)
            }
        }
        if (info.idx >= 0)
80000554:	fd241783          	lh	a5,-46(s0)
80000558:	0207c463          	bltz	a5,80000580 <core_bench_list+0x1ac>
            info.idx++;
8000055c:	fd241783          	lh	a5,-46(s0)
80000560:	01079793          	slli	a5,a5,0x10
80000564:	0107d793          	srli	a5,a5,0x10
80000568:	00178793          	addi	a5,a5,1
8000056c:	01079793          	slli	a5,a5,0x10
80000570:	0107d793          	srli	a5,a5,0x10
80000574:	01079793          	slli	a5,a5,0x10
80000578:	4107d793          	srai	a5,a5,0x10
8000057c:	fcf41923          	sh	a5,-46(s0)
    for (i = 0; i < find_num; i++)
80000580:	fde41783          	lh	a5,-34(s0)
80000584:	01079793          	slli	a5,a5,0x10
80000588:	0107d793          	srli	a5,a5,0x10
8000058c:	00178793          	addi	a5,a5,1
80000590:	01079793          	slli	a5,a5,0x10
80000594:	0107d793          	srli	a5,a5,0x10
80000598:	fcf41f23          	sh	a5,-34(s0)
8000059c:	fde41703          	lh	a4,-34(s0)
800005a0:	fdc41783          	lh	a5,-36(s0)
800005a4:	e8f742e3          	blt	a4,a5,80000428 <core_bench_list+0x54>
#if CORE_DEBUG
        ee_printf("List find %d: [%d,%d,%d]\n", i, retval, missed, found);
#endif
    }
    retval += found * 4 - missed;
800005a8:	fec45783          	lhu	a5,-20(s0)
800005ac:	00279793          	slli	a5,a5,0x2
800005b0:	01079793          	slli	a5,a5,0x10
800005b4:	0107d793          	srli	a5,a5,0x10
800005b8:	fea45703          	lhu	a4,-22(s0)
800005bc:	40e787b3          	sub	a5,a5,a4
800005c0:	01079793          	slli	a5,a5,0x10
800005c4:	0107d793          	srli	a5,a5,0x10
800005c8:	fee45703          	lhu	a4,-18(s0)
800005cc:	00e787b3          	add	a5,a5,a4
800005d0:	fef41723          	sh	a5,-18(s0)
    /* sort the list by data content and remove one item*/
    if (finder_idx > 0)
800005d4:	fca41783          	lh	a5,-54(s0)
800005d8:	00f05e63          	blez	a5,800005f4 <core_bench_list+0x220>
        list = core_list_mergesort(list, cmp_complex, res);
800005dc:	fcc42603          	lw	a2,-52(s0)
800005e0:	800007b7          	lui	a5,0x80000
800005e4:	23478593          	addi	a1,a5,564 # 80000234 <cmp_complex>
800005e8:	fe442503          	lw	a0,-28(s0)
800005ec:	6c4000ef          	jal	80000cb0 <core_list_mergesort>
800005f0:	fea42223          	sw	a0,-28(s0)
    remover = core_list_remove(list->next);
800005f4:	fe442783          	lw	a5,-28(s0)
800005f8:	0007a783          	lw	a5,0(a5)
800005fc:	00078513          	mv	a0,a5
80000600:	4b0000ef          	jal	80000ab0 <core_list_remove>
80000604:	fca42c23          	sw	a0,-40(s0)
    /* CRC data content of list from location of index N forward, and then undo
     * remove */
    finder = core_list_find(list, &info);
80000608:	fd040793          	addi	a5,s0,-48
8000060c:	00078593          	mv	a1,a5
80000610:	fe442503          	lw	a0,-28(s0)
80000614:	58c000ef          	jal	80000ba0 <core_list_find>
80000618:	fea42023          	sw	a0,-32(s0)
    if (!finder)
8000061c:	fe042783          	lw	a5,-32(s0)
80000620:	04079263          	bnez	a5,80000664 <core_bench_list+0x290>
        finder = list->next;
80000624:	fe442783          	lw	a5,-28(s0)
80000628:	0007a783          	lw	a5,0(a5)
8000062c:	fef42023          	sw	a5,-32(s0)
    while (finder)
80000630:	0340006f          	j	80000664 <core_bench_list+0x290>
    {
        retval = crc16(list->info->data16, retval);
80000634:	fe442783          	lw	a5,-28(s0)
80000638:	0047a783          	lw	a5,4(a5)
8000063c:	00079783          	lh	a5,0(a5)
80000640:	fee45703          	lhu	a4,-18(s0)
80000644:	00070593          	mv	a1,a4
80000648:	00078513          	mv	a0,a5
8000064c:	1dc030ef          	jal	80003828 <crc16>
80000650:	00050793          	mv	a5,a0
80000654:	fef41723          	sh	a5,-18(s0)
        finder = finder->next;
80000658:	fe042783          	lw	a5,-32(s0)
8000065c:	0007a783          	lw	a5,0(a5)
80000660:	fef42023          	sw	a5,-32(s0)
    while (finder)
80000664:	fe042783          	lw	a5,-32(s0)
80000668:	fc0796e3          	bnez	a5,80000634 <core_bench_list+0x260>
    }
#if CORE_DEBUG
    ee_printf("List sort 1: %04x\n", retval);
#endif
    remover = core_list_undo_remove(remover, list->next);
8000066c:	fe442783          	lw	a5,-28(s0)
80000670:	0007a783          	lw	a5,0(a5)
80000674:	00078593          	mv	a1,a5
80000678:	fd842503          	lw	a0,-40(s0)
8000067c:	4b0000ef          	jal	80000b2c <core_list_undo_remove>
80000680:	fca42c23          	sw	a0,-40(s0)
    /* sort the list by index, in effect returning the list to original state */
    list = core_list_mergesort(list, cmp_idx, NULL);
80000684:	00000613          	li	a2,0
80000688:	800007b7          	lui	a5,0x80000
8000068c:	2a078593          	addi	a1,a5,672 # 800002a0 <cmp_idx>
80000690:	fe442503          	lw	a0,-28(s0)
80000694:	61c000ef          	jal	80000cb0 <core_list_mergesort>
80000698:	fea42223          	sw	a0,-28(s0)
    /* CRC data content of list */
    finder = list->next;
8000069c:	fe442783          	lw	a5,-28(s0)
800006a0:	0007a783          	lw	a5,0(a5)
800006a4:	fef42023          	sw	a5,-32(s0)
    while (finder)
800006a8:	0340006f          	j	800006dc <core_bench_list+0x308>
    {
        retval = crc16(list->info->data16, retval);
800006ac:	fe442783          	lw	a5,-28(s0)
800006b0:	0047a783          	lw	a5,4(a5)
800006b4:	00079783          	lh	a5,0(a5)
800006b8:	fee45703          	lhu	a4,-18(s0)
800006bc:	00070593          	mv	a1,a4
800006c0:	00078513          	mv	a0,a5
800006c4:	164030ef          	jal	80003828 <crc16>
800006c8:	00050793          	mv	a5,a0
800006cc:	fef41723          	sh	a5,-18(s0)
        finder = finder->next;
800006d0:	fe042783          	lw	a5,-32(s0)
800006d4:	0007a783          	lw	a5,0(a5)
800006d8:	fef42023          	sw	a5,-32(s0)
    while (finder)
800006dc:	fe042783          	lw	a5,-32(s0)
800006e0:	fc0796e3          	bnez	a5,800006ac <core_bench_list+0x2d8>
    }
#if CORE_DEBUG
    ee_printf("List sort 2: %04x\n", retval);
#endif
    return retval;
800006e4:	fee45783          	lhu	a5,-18(s0)
}
800006e8:	00078513          	mv	a0,a5
800006ec:	03c12083          	lw	ra,60(sp)
800006f0:	03812403          	lw	s0,56(sp)
800006f4:	04010113          	addi	sp,sp,64
800006f8:	00008067          	ret

800006fc <core_list_init>:
        Pointer to the head of the list.

*/
list_head *
core_list_init(ee_u32 blksize, list_head *memblock, ee_s16 seed)
{
800006fc:	fb010113          	addi	sp,sp,-80
80000700:	04112623          	sw	ra,76(sp)
80000704:	04812423          	sw	s0,72(sp)
80000708:	05010413          	addi	s0,sp,80
8000070c:	faa42e23          	sw	a0,-68(s0)
80000710:	fab42c23          	sw	a1,-72(s0)
80000714:	00060793          	mv	a5,a2
80000718:	faf41b23          	sh	a5,-74(s0)
    /* calculated pointers for the list */
    ee_u32 per_item = 16 + sizeof(struct list_data_s);
8000071c:	01400793          	li	a5,20
80000720:	fef42223          	sw	a5,-28(s0)
    ee_u32 size     = (blksize / per_item)
80000724:	fe442583          	lw	a1,-28(s0)
80000728:	fbc42503          	lw	a0,-68(s0)
8000072c:	3ac040ef          	jal	80004ad8 <__hidden___udivsi3>
80000730:	00050793          	mv	a5,a0
80000734:	ffe78793          	addi	a5,a5,-2
80000738:	fef42023          	sw	a5,-32(s0)
                  - 2; /* to accommodate systems with 64b pointers, and make sure
                          same code is executed, set max list elements */
    list_head *memblock_end  = memblock + size;
8000073c:	fb842703          	lw	a4,-72(s0)
80000740:	fe042783          	lw	a5,-32(s0)
80000744:	00379793          	slli	a5,a5,0x3
80000748:	00f707b3          	add	a5,a4,a5
8000074c:	fcf42e23          	sw	a5,-36(s0)
    list_data *datablock     = (list_data *)(memblock_end);
80000750:	fdc42783          	lw	a5,-36(s0)
80000754:	fcf42423          	sw	a5,-56(s0)
    list_data *datablock_end = datablock + size;
80000758:	fc842703          	lw	a4,-56(s0)
8000075c:	fe042783          	lw	a5,-32(s0)
80000760:	00279793          	slli	a5,a5,0x2
80000764:	00f707b3          	add	a5,a4,a5
80000768:	fcf42c23          	sw	a5,-40(s0)
    /* some useful variables */
    ee_u32     i;
    list_head *finder, *list = memblock;
8000076c:	fb842783          	lw	a5,-72(s0)
80000770:	fcf42a23          	sw	a5,-44(s0)
    list_data  info;

    /* create a fake items for the list head and tail */
    list->next         = NULL;
80000774:	fd442783          	lw	a5,-44(s0)
80000778:	0007a023          	sw	zero,0(a5)
    list->info         = datablock;
8000077c:	fc842703          	lw	a4,-56(s0)
80000780:	fd442783          	lw	a5,-44(s0)
80000784:	00e7a223          	sw	a4,4(a5)
    list->info->idx    = 0x0000;
80000788:	fd442783          	lw	a5,-44(s0)
8000078c:	0047a783          	lw	a5,4(a5)
80000790:	00079123          	sh	zero,2(a5)
    list->info->data16 = (ee_s16)0x8080;
80000794:	fd442783          	lw	a5,-44(s0)
80000798:	0047a783          	lw	a5,4(a5)
8000079c:	ffff8737          	lui	a4,0xffff8
800007a0:	08070713          	addi	a4,a4,128 # ffff8080 <_estack+0x7fef8080>
800007a4:	00e79023          	sh	a4,0(a5)
    memblock++;
800007a8:	fb842783          	lw	a5,-72(s0)
800007ac:	00878793          	addi	a5,a5,8
800007b0:	faf42c23          	sw	a5,-72(s0)
    datablock++;
800007b4:	fc842783          	lw	a5,-56(s0)
800007b8:	00478793          	addi	a5,a5,4
800007bc:	fcf42423          	sw	a5,-56(s0)
    info.idx    = 0x7fff;
800007c0:	ffff87b7          	lui	a5,0xffff8
800007c4:	fff7c793          	not	a5,a5
800007c8:	fcf41323          	sh	a5,-58(s0)
    info.data16 = (ee_s16)0xffff;
800007cc:	fff00793          	li	a5,-1
800007d0:	fcf41223          	sh	a5,-60(s0)
    core_list_insert_new(
800007d4:	fc840693          	addi	a3,s0,-56
800007d8:	fb840613          	addi	a2,s0,-72
800007dc:	fc440593          	addi	a1,s0,-60
800007e0:	fd842783          	lw	a5,-40(s0)
800007e4:	fdc42703          	lw	a4,-36(s0)
800007e8:	fd442503          	lw	a0,-44(s0)
800007ec:	1d8000ef          	jal	800009c4 <core_list_insert_new>
        list, &info, &memblock, &datablock, memblock_end, datablock_end);

    /* then insert size items */
    for (i = 0; i < size; i++)
800007f0:	fe042623          	sw	zero,-20(s0)
800007f4:	0a40006f          	j	80000898 <core_list_init+0x19c>
    {
        ee_u16 datpat = ((ee_u16)(seed ^ i) & 0xf);
800007f8:	fec42783          	lw	a5,-20(s0)
800007fc:	01079713          	slli	a4,a5,0x10
80000800:	01075713          	srli	a4,a4,0x10
80000804:	fb645783          	lhu	a5,-74(s0)
80000808:	00f747b3          	xor	a5,a4,a5
8000080c:	01079793          	slli	a5,a5,0x10
80000810:	0107d793          	srli	a5,a5,0x10
80000814:	00f7f793          	andi	a5,a5,15
80000818:	fcf41823          	sh	a5,-48(s0)
        ee_u16 dat
            = (datpat << 3) | (i & 0x7); /* alternate between algorithms */
8000081c:	fd045783          	lhu	a5,-48(s0)
80000820:	00379793          	slli	a5,a5,0x3
80000824:	01079713          	slli	a4,a5,0x10
80000828:	01075713          	srli	a4,a4,0x10
8000082c:	fec42783          	lw	a5,-20(s0)
80000830:	01079793          	slli	a5,a5,0x10
80000834:	0107d793          	srli	a5,a5,0x10
80000838:	0077f793          	andi	a5,a5,7
8000083c:	01079793          	slli	a5,a5,0x10
80000840:	0107d793          	srli	a5,a5,0x10
        ee_u16 dat
80000844:	00f767b3          	or	a5,a4,a5
80000848:	fcf41723          	sh	a5,-50(s0)
        info.data16 = (dat << 8) | dat;  /* fill the data with actual data and
8000084c:	fce41783          	lh	a5,-50(s0)
80000850:	00879793          	slli	a5,a5,0x8
80000854:	01079713          	slli	a4,a5,0x10
80000858:	41075713          	srai	a4,a4,0x10
8000085c:	fce41783          	lh	a5,-50(s0)
80000860:	00f767b3          	or	a5,a4,a5
80000864:	01079793          	slli	a5,a5,0x10
80000868:	4107d793          	srai	a5,a5,0x10
8000086c:	fcf41223          	sh	a5,-60(s0)
                                            upper bits with rebuild value */
        core_list_insert_new(
80000870:	fc840693          	addi	a3,s0,-56
80000874:	fb840613          	addi	a2,s0,-72
80000878:	fc440593          	addi	a1,s0,-60
8000087c:	fd842783          	lw	a5,-40(s0)
80000880:	fdc42703          	lw	a4,-36(s0)
80000884:	fd442503          	lw	a0,-44(s0)
80000888:	13c000ef          	jal	800009c4 <core_list_insert_new>
    for (i = 0; i < size; i++)
8000088c:	fec42783          	lw	a5,-20(s0)
80000890:	00178793          	addi	a5,a5,1 # ffff8001 <_estack+0x7fef8001>
80000894:	fef42623          	sw	a5,-20(s0)
80000898:	fec42703          	lw	a4,-20(s0)
8000089c:	fe042783          	lw	a5,-32(s0)
800008a0:	f4f76ce3          	bltu	a4,a5,800007f8 <core_list_init+0xfc>
            list, &info, &memblock, &datablock, memblock_end, datablock_end);
    }
    /* and now index the list so we know initial seed order of the list */
    finder = list->next;
800008a4:	fd442783          	lw	a5,-44(s0)
800008a8:	0007a783          	lw	a5,0(a5)
800008ac:	fef42423          	sw	a5,-24(s0)
    i      = 1;
800008b0:	00100793          	li	a5,1
800008b4:	fef42623          	sw	a5,-20(s0)
    while (finder->next != NULL)
800008b8:	0d00006f          	j	80000988 <core_list_init+0x28c>
    {
        if (i < size / 5) /* first 20% of the list in order */
800008bc:	fe042783          	lw	a5,-32(s0)
800008c0:	00500593          	li	a1,5
800008c4:	00078513          	mv	a0,a5
800008c8:	210040ef          	jal	80004ad8 <__hidden___udivsi3>
800008cc:	00050793          	mv	a5,a0
800008d0:	00078713          	mv	a4,a5
800008d4:	fec42783          	lw	a5,-20(s0)
800008d8:	02e7f463          	bgeu	a5,a4,80000900 <core_list_init+0x204>
            finder->info->idx = i++;
800008dc:	fec42783          	lw	a5,-20(s0)
800008e0:	00178713          	addi	a4,a5,1
800008e4:	fee42623          	sw	a4,-20(s0)
800008e8:	fe842703          	lw	a4,-24(s0)
800008ec:	00472703          	lw	a4,4(a4)
800008f0:	01079793          	slli	a5,a5,0x10
800008f4:	4107d793          	srai	a5,a5,0x10
800008f8:	00f71123          	sh	a5,2(a4)
800008fc:	0800006f          	j	8000097c <core_list_init+0x280>
        else
        {
            ee_u16 pat = (ee_u16)(i++ ^ seed); /* get a pseudo random number */
80000900:	fec42783          	lw	a5,-20(s0)
80000904:	00178713          	addi	a4,a5,1
80000908:	fee42623          	sw	a4,-20(s0)
8000090c:	01079713          	slli	a4,a5,0x10
80000910:	01075713          	srli	a4,a4,0x10
80000914:	fb645783          	lhu	a5,-74(s0)
80000918:	00f747b3          	xor	a5,a4,a5
8000091c:	fcf41923          	sh	a5,-46(s0)
            finder->info->idx = 0x3fff
                                & (((i & 0x07) << 8)
80000920:	fec42783          	lw	a5,-20(s0)
80000924:	01079793          	slli	a5,a5,0x10
80000928:	0107d793          	srli	a5,a5,0x10
8000092c:	00879793          	slli	a5,a5,0x8
80000930:	01079793          	slli	a5,a5,0x10
80000934:	0107d793          	srli	a5,a5,0x10
80000938:	7007f793          	andi	a5,a5,1792
8000093c:	01079793          	slli	a5,a5,0x10
80000940:	0107d793          	srli	a5,a5,0x10
                                   | pat); /* make sure the mixed items end up
80000944:	fd245703          	lhu	a4,-46(s0)
80000948:	00e7e7b3          	or	a5,a5,a4
8000094c:	01079793          	slli	a5,a5,0x10
80000950:	0107d793          	srli	a5,a5,0x10
                                & (((i & 0x07) << 8)
80000954:	01079693          	slli	a3,a5,0x10
80000958:	4106d693          	srai	a3,a3,0x10
            finder->info->idx = 0x3fff
8000095c:	fe842783          	lw	a5,-24(s0)
80000960:	0047a783          	lw	a5,4(a5)
                                & (((i & 0x07) << 8)
80000964:	00004737          	lui	a4,0x4
80000968:	fff70713          	addi	a4,a4,-1 # 3fff <_start-0x7fffc001>
8000096c:	00e6f733          	and	a4,a3,a4
80000970:	01071713          	slli	a4,a4,0x10
80000974:	41075713          	srai	a4,a4,0x10
            finder->info->idx = 0x3fff
80000978:	00e79123          	sh	a4,2(a5)
                                              after the ones in sequence */
        }
        finder = finder->next;
8000097c:	fe842783          	lw	a5,-24(s0)
80000980:	0007a783          	lw	a5,0(a5)
80000984:	fef42423          	sw	a5,-24(s0)
    while (finder->next != NULL)
80000988:	fe842783          	lw	a5,-24(s0)
8000098c:	0007a783          	lw	a5,0(a5)
80000990:	f20796e3          	bnez	a5,800008bc <core_list_init+0x1c0>
    }
    list = core_list_mergesort(list, cmp_idx, NULL);
80000994:	00000613          	li	a2,0
80000998:	800007b7          	lui	a5,0x80000
8000099c:	2a078593          	addi	a1,a5,672 # 800002a0 <cmp_idx>
800009a0:	fd442503          	lw	a0,-44(s0)
800009a4:	30c000ef          	jal	80000cb0 <core_list_mergesort>
800009a8:	fca42a23          	sw	a0,-44(s0)
            "[%04x,%04x]", finder->info->idx, (ee_u16)finder->info->data16);
        finder = finder->next;
    }
    ee_printf("\n");
#endif
    return list;
800009ac:	fd442783          	lw	a5,-44(s0)
}
800009b0:	00078513          	mv	a0,a5
800009b4:	04c12083          	lw	ra,76(sp)
800009b8:	04812403          	lw	s0,72(sp)
800009bc:	05010113          	addi	sp,sp,80
800009c0:	00008067          	ret

800009c4 <core_list_insert_new>:
                     list_data * info,
                     list_head **memblock,
                     list_data **datablock,
                     list_head * memblock_end,
                     list_data * datablock_end)
{
800009c4:	fc010113          	addi	sp,sp,-64
800009c8:	02112e23          	sw	ra,60(sp)
800009cc:	02812c23          	sw	s0,56(sp)
800009d0:	04010413          	addi	s0,sp,64
800009d4:	fca42e23          	sw	a0,-36(s0)
800009d8:	fcb42c23          	sw	a1,-40(s0)
800009dc:	fcc42a23          	sw	a2,-44(s0)
800009e0:	fcd42823          	sw	a3,-48(s0)
800009e4:	fce42623          	sw	a4,-52(s0)
800009e8:	fcf42423          	sw	a5,-56(s0)
    list_head *newitem;

    if ((*memblock + 1) >= memblock_end)
800009ec:	fd442783          	lw	a5,-44(s0)
800009f0:	0007a783          	lw	a5,0(a5)
800009f4:	00878793          	addi	a5,a5,8
800009f8:	fcc42703          	lw	a4,-52(s0)
800009fc:	00e7e663          	bltu	a5,a4,80000a08 <core_list_insert_new+0x44>
        return NULL;
80000a00:	00000793          	li	a5,0
80000a04:	0980006f          	j	80000a9c <core_list_insert_new+0xd8>
    if ((*datablock + 1) >= datablock_end)
80000a08:	fd042783          	lw	a5,-48(s0)
80000a0c:	0007a783          	lw	a5,0(a5)
80000a10:	00478793          	addi	a5,a5,4
80000a14:	fc842703          	lw	a4,-56(s0)
80000a18:	00e7e663          	bltu	a5,a4,80000a24 <core_list_insert_new+0x60>
        return NULL;
80000a1c:	00000793          	li	a5,0
80000a20:	07c0006f          	j	80000a9c <core_list_insert_new+0xd8>

    newitem = *memblock;
80000a24:	fd442783          	lw	a5,-44(s0)
80000a28:	0007a783          	lw	a5,0(a5)
80000a2c:	fef42623          	sw	a5,-20(s0)
    (*memblock)++;
80000a30:	fd442783          	lw	a5,-44(s0)
80000a34:	0007a783          	lw	a5,0(a5)
80000a38:	00878713          	addi	a4,a5,8
80000a3c:	fd442783          	lw	a5,-44(s0)
80000a40:	00e7a023          	sw	a4,0(a5)
    newitem->next      = insert_point->next;
80000a44:	fdc42783          	lw	a5,-36(s0)
80000a48:	0007a703          	lw	a4,0(a5)
80000a4c:	fec42783          	lw	a5,-20(s0)
80000a50:	00e7a023          	sw	a4,0(a5)
    insert_point->next = newitem;
80000a54:	fdc42783          	lw	a5,-36(s0)
80000a58:	fec42703          	lw	a4,-20(s0)
80000a5c:	00e7a023          	sw	a4,0(a5)

    newitem->info = *datablock;
80000a60:	fd042783          	lw	a5,-48(s0)
80000a64:	0007a703          	lw	a4,0(a5)
80000a68:	fec42783          	lw	a5,-20(s0)
80000a6c:	00e7a223          	sw	a4,4(a5)
    (*datablock)++;
80000a70:	fd042783          	lw	a5,-48(s0)
80000a74:	0007a783          	lw	a5,0(a5)
80000a78:	00478713          	addi	a4,a5,4
80000a7c:	fd042783          	lw	a5,-48(s0)
80000a80:	00e7a023          	sw	a4,0(a5)
    copy_info(newitem->info, info);
80000a84:	fec42783          	lw	a5,-20(s0)
80000a88:	0047a783          	lw	a5,4(a5)
80000a8c:	fd842583          	lw	a1,-40(s0)
80000a90:	00078513          	mv	a0,a5
80000a94:	8f5ff0ef          	jal	80000388 <copy_info>

    return newitem;
80000a98:	fec42783          	lw	a5,-20(s0)
}
80000a9c:	00078513          	mv	a0,a5
80000aa0:	03c12083          	lw	ra,60(sp)
80000aa4:	03812403          	lw	s0,56(sp)
80000aa8:	04010113          	addi	sp,sp,64
80000aac:	00008067          	ret

80000ab0 <core_list_remove>:
        Returns:
        Removed item.
*/
list_head *
core_list_remove(list_head *item)
{
80000ab0:	fd010113          	addi	sp,sp,-48
80000ab4:	02112623          	sw	ra,44(sp)
80000ab8:	02812423          	sw	s0,40(sp)
80000abc:	03010413          	addi	s0,sp,48
80000ac0:	fca42e23          	sw	a0,-36(s0)
    list_data *tmp;
    list_head *ret = item->next;
80000ac4:	fdc42783          	lw	a5,-36(s0)
80000ac8:	0007a783          	lw	a5,0(a5)
80000acc:	fef42623          	sw	a5,-20(s0)
    /* swap data pointers */
    tmp        = item->info;
80000ad0:	fdc42783          	lw	a5,-36(s0)
80000ad4:	0047a783          	lw	a5,4(a5)
80000ad8:	fef42423          	sw	a5,-24(s0)
    item->info = ret->info;
80000adc:	fec42783          	lw	a5,-20(s0)
80000ae0:	0047a703          	lw	a4,4(a5)
80000ae4:	fdc42783          	lw	a5,-36(s0)
80000ae8:	00e7a223          	sw	a4,4(a5)
    ret->info  = tmp;
80000aec:	fec42783          	lw	a5,-20(s0)
80000af0:	fe842703          	lw	a4,-24(s0)
80000af4:	00e7a223          	sw	a4,4(a5)
    /* and eliminate item */
    item->next = item->next->next;
80000af8:	fdc42783          	lw	a5,-36(s0)
80000afc:	0007a783          	lw	a5,0(a5)
80000b00:	0007a703          	lw	a4,0(a5)
80000b04:	fdc42783          	lw	a5,-36(s0)
80000b08:	00e7a023          	sw	a4,0(a5)
    ret->next  = NULL;
80000b0c:	fec42783          	lw	a5,-20(s0)
80000b10:	0007a023          	sw	zero,0(a5)
    return ret;
80000b14:	fec42783          	lw	a5,-20(s0)
}
80000b18:	00078513          	mv	a0,a5
80000b1c:	02c12083          	lw	ra,44(sp)
80000b20:	02812403          	lw	s0,40(sp)
80000b24:	03010113          	addi	sp,sp,48
80000b28:	00008067          	ret

80000b2c <core_list_undo_remove>:
        The item that was linked back to the list.

*/
list_head *
core_list_undo_remove(list_head *item_removed, list_head *item_modified)
{
80000b2c:	fd010113          	addi	sp,sp,-48
80000b30:	02112623          	sw	ra,44(sp)
80000b34:	02812423          	sw	s0,40(sp)
80000b38:	03010413          	addi	s0,sp,48
80000b3c:	fca42e23          	sw	a0,-36(s0)
80000b40:	fcb42c23          	sw	a1,-40(s0)
    list_data *tmp;
    /* swap data pointers */
    tmp                 = item_removed->info;
80000b44:	fdc42783          	lw	a5,-36(s0)
80000b48:	0047a783          	lw	a5,4(a5)
80000b4c:	fef42623          	sw	a5,-20(s0)
    item_removed->info  = item_modified->info;
80000b50:	fd842783          	lw	a5,-40(s0)
80000b54:	0047a703          	lw	a4,4(a5)
80000b58:	fdc42783          	lw	a5,-36(s0)
80000b5c:	00e7a223          	sw	a4,4(a5)
    item_modified->info = tmp;
80000b60:	fd842783          	lw	a5,-40(s0)
80000b64:	fec42703          	lw	a4,-20(s0)
80000b68:	00e7a223          	sw	a4,4(a5)
    /* and insert item */
    item_removed->next  = item_modified->next;
80000b6c:	fd842783          	lw	a5,-40(s0)
80000b70:	0007a703          	lw	a4,0(a5)
80000b74:	fdc42783          	lw	a5,-36(s0)
80000b78:	00e7a023          	sw	a4,0(a5)
    item_modified->next = item_removed;
80000b7c:	fd842783          	lw	a5,-40(s0)
80000b80:	fdc42703          	lw	a4,-36(s0)
80000b84:	00e7a023          	sw	a4,0(a5)
    return item_removed;
80000b88:	fdc42783          	lw	a5,-36(s0)
}
80000b8c:	00078513          	mv	a0,a5
80000b90:	02c12083          	lw	ra,44(sp)
80000b94:	02812403          	lw	s0,40(sp)
80000b98:	03010113          	addi	sp,sp,48
80000b9c:	00008067          	ret

80000ba0 <core_list_find>:
        Returns:
        Found item, or NULL if not found.
*/
list_head *
core_list_find(list_head *list, list_data *info)
{
80000ba0:	fe010113          	addi	sp,sp,-32
80000ba4:	00112e23          	sw	ra,28(sp)
80000ba8:	00812c23          	sw	s0,24(sp)
80000bac:	02010413          	addi	s0,sp,32
80000bb0:	fea42623          	sw	a0,-20(s0)
80000bb4:	feb42423          	sw	a1,-24(s0)
    if (info->idx >= 0)
80000bb8:	fe842783          	lw	a5,-24(s0)
80000bbc:	00279783          	lh	a5,2(a5)
80000bc0:	0407c463          	bltz	a5,80000c08 <core_list_find+0x68>
    {
        while (list && (list->info->idx != info->idx))
80000bc4:	0100006f          	j	80000bd4 <core_list_find+0x34>
            list = list->next;
80000bc8:	fec42783          	lw	a5,-20(s0)
80000bcc:	0007a783          	lw	a5,0(a5)
80000bd0:	fef42623          	sw	a5,-20(s0)
        while (list && (list->info->idx != info->idx))
80000bd4:	fec42783          	lw	a5,-20(s0)
80000bd8:	00078e63          	beqz	a5,80000bf4 <core_list_find+0x54>
80000bdc:	fec42783          	lw	a5,-20(s0)
80000be0:	0047a783          	lw	a5,4(a5)
80000be4:	00279703          	lh	a4,2(a5)
80000be8:	fe842783          	lw	a5,-24(s0)
80000bec:	00279783          	lh	a5,2(a5)
80000bf0:	fcf71ce3          	bne	a4,a5,80000bc8 <core_list_find+0x28>
        return list;
80000bf4:	fec42783          	lw	a5,-20(s0)
80000bf8:	0400006f          	j	80000c38 <core_list_find+0x98>
    }
    else
    {
        while (list && ((list->info->data16 & 0xff) != info->data16))
            list = list->next;
80000bfc:	fec42783          	lw	a5,-20(s0)
80000c00:	0007a783          	lw	a5,0(a5)
80000c04:	fef42623          	sw	a5,-20(s0)
        while (list && ((list->info->data16 & 0xff) != info->data16))
80000c08:	fec42783          	lw	a5,-20(s0)
80000c0c:	02078463          	beqz	a5,80000c34 <core_list_find+0x94>
80000c10:	fec42783          	lw	a5,-20(s0)
80000c14:	0047a783          	lw	a5,4(a5)
80000c18:	00079783          	lh	a5,0(a5)
80000c1c:	01079793          	slli	a5,a5,0x10
80000c20:	0107d793          	srli	a5,a5,0x10
80000c24:	0ff7f793          	zext.b	a5,a5
80000c28:	fe842703          	lw	a4,-24(s0)
80000c2c:	00071703          	lh	a4,0(a4)
80000c30:	fce796e3          	bne	a5,a4,80000bfc <core_list_find+0x5c>
        return list;
80000c34:	fec42783          	lw	a5,-20(s0)
    }
}
80000c38:	00078513          	mv	a0,a5
80000c3c:	01c12083          	lw	ra,28(sp)
80000c40:	01812403          	lw	s0,24(sp)
80000c44:	02010113          	addi	sp,sp,32
80000c48:	00008067          	ret

80000c4c <core_list_reverse>:
        Found item, or NULL if not found.
*/

list_head *
core_list_reverse(list_head *list)
{
80000c4c:	fd010113          	addi	sp,sp,-48
80000c50:	02112623          	sw	ra,44(sp)
80000c54:	02812423          	sw	s0,40(sp)
80000c58:	03010413          	addi	s0,sp,48
80000c5c:	fca42e23          	sw	a0,-36(s0)
    list_head *next = NULL, *tmp;
80000c60:	fe042623          	sw	zero,-20(s0)
    while (list)
80000c64:	02c0006f          	j	80000c90 <core_list_reverse+0x44>
    {
        tmp        = list->next;
80000c68:	fdc42783          	lw	a5,-36(s0)
80000c6c:	0007a783          	lw	a5,0(a5)
80000c70:	fef42423          	sw	a5,-24(s0)
        list->next = next;
80000c74:	fdc42783          	lw	a5,-36(s0)
80000c78:	fec42703          	lw	a4,-20(s0)
80000c7c:	00e7a023          	sw	a4,0(a5)
        next       = list;
80000c80:	fdc42783          	lw	a5,-36(s0)
80000c84:	fef42623          	sw	a5,-20(s0)
        list       = tmp;
80000c88:	fe842783          	lw	a5,-24(s0)
80000c8c:	fcf42e23          	sw	a5,-36(s0)
    while (list)
80000c90:	fdc42783          	lw	a5,-36(s0)
80000c94:	fc079ae3          	bnez	a5,80000c68 <core_list_reverse+0x1c>
    }
    return next;
80000c98:	fec42783          	lw	a5,-20(s0)
}
80000c9c:	00078513          	mv	a0,a5
80000ca0:	02c12083          	lw	ra,44(sp)
80000ca4:	02812403          	lw	s0,40(sp)
80000ca8:	03010113          	addi	sp,sp,48
80000cac:	00008067          	ret

80000cb0 <core_list_mergesort>:
        but the algorithm could theoretically modify where the list starts.

 */
list_head *
core_list_mergesort(list_head *list, list_cmp cmp, core_results *res)
{
80000cb0:	fb010113          	addi	sp,sp,-80
80000cb4:	04112623          	sw	ra,76(sp)
80000cb8:	04812423          	sw	s0,72(sp)
80000cbc:	05010413          	addi	s0,sp,80
80000cc0:	faa42e23          	sw	a0,-68(s0)
80000cc4:	fab42c23          	sw	a1,-72(s0)
80000cc8:	fac42a23          	sw	a2,-76(s0)
    list_head *p, *q, *e, *tail;
    ee_s32     insize, nmerges, psize, qsize, i;

    insize = 1;
80000ccc:	00100793          	li	a5,1
80000cd0:	fcf42e23          	sw	a5,-36(s0)

    while (1)
    {
        p    = list;
80000cd4:	fbc42783          	lw	a5,-68(s0)
80000cd8:	fef42623          	sw	a5,-20(s0)
        list = NULL;
80000cdc:	fa042e23          	sw	zero,-68(s0)
        tail = NULL;
80000ce0:	fe042023          	sw	zero,-32(s0)

        nmerges = 0; /* count number of merges we do in this pass */
80000ce4:	fc042c23          	sw	zero,-40(s0)

        while (p)
80000ce8:	1880006f          	j	80000e70 <core_list_mergesort+0x1c0>
        {
            nmerges++; /* there exists a merge to be done */
80000cec:	fd842783          	lw	a5,-40(s0)
80000cf0:	00178793          	addi	a5,a5,1
80000cf4:	fcf42c23          	sw	a5,-40(s0)
            /* step `insize' places along from p */
            q     = p;
80000cf8:	fec42783          	lw	a5,-20(s0)
80000cfc:	fef42423          	sw	a5,-24(s0)
            psize = 0;
80000d00:	fc042a23          	sw	zero,-44(s0)
            for (i = 0; i < insize; i++)
80000d04:	fc042623          	sw	zero,-52(s0)
80000d08:	0300006f          	j	80000d38 <core_list_mergesort+0x88>
            {
                psize++;
80000d0c:	fd442783          	lw	a5,-44(s0)
80000d10:	00178793          	addi	a5,a5,1
80000d14:	fcf42a23          	sw	a5,-44(s0)
                q = q->next;
80000d18:	fe842783          	lw	a5,-24(s0)
80000d1c:	0007a783          	lw	a5,0(a5)
80000d20:	fef42423          	sw	a5,-24(s0)
                if (!q)
80000d24:	fe842783          	lw	a5,-24(s0)
80000d28:	02078063          	beqz	a5,80000d48 <core_list_mergesort+0x98>
            for (i = 0; i < insize; i++)
80000d2c:	fcc42783          	lw	a5,-52(s0)
80000d30:	00178793          	addi	a5,a5,1
80000d34:	fcf42623          	sw	a5,-52(s0)
80000d38:	fcc42703          	lw	a4,-52(s0)
80000d3c:	fdc42783          	lw	a5,-36(s0)
80000d40:	fcf746e3          	blt	a4,a5,80000d0c <core_list_mergesort+0x5c>
80000d44:	0080006f          	j	80000d4c <core_list_mergesort+0x9c>
                    break;
80000d48:	00000013          	nop
            }

            /* if q hasn't fallen off end, we have two lists to merge */
            qsize = insize;
80000d4c:	fdc42783          	lw	a5,-36(s0)
80000d50:	fcf42823          	sw	a5,-48(s0)

            /* now we have two lists; merge them */
            while (psize > 0 || (qsize > 0 && q))
80000d54:	0fc0006f          	j	80000e50 <core_list_mergesort+0x1a0>
            {

                /* decide whether next element of merge comes from p or q */
                if (psize == 0)
80000d58:	fd442783          	lw	a5,-44(s0)
80000d5c:	02079463          	bnez	a5,80000d84 <core_list_mergesort+0xd4>
                {
                    /* p is empty; e must come from q. */
                    e = q;
80000d60:	fe842783          	lw	a5,-24(s0)
80000d64:	fef42223          	sw	a5,-28(s0)
                    q = q->next;
80000d68:	fe842783          	lw	a5,-24(s0)
80000d6c:	0007a783          	lw	a5,0(a5)
80000d70:	fef42423          	sw	a5,-24(s0)
                    qsize--;
80000d74:	fd042783          	lw	a5,-48(s0)
80000d78:	fff78793          	addi	a5,a5,-1
80000d7c:	fcf42823          	sw	a5,-48(s0)
80000d80:	0a80006f          	j	80000e28 <core_list_mergesort+0x178>
                }
                else if (qsize == 0 || !q)
80000d84:	fd042783          	lw	a5,-48(s0)
80000d88:	00078663          	beqz	a5,80000d94 <core_list_mergesort+0xe4>
80000d8c:	fe842783          	lw	a5,-24(s0)
80000d90:	02079463          	bnez	a5,80000db8 <core_list_mergesort+0x108>
                {
                    /* q is empty; e must come from p. */
                    e = p;
80000d94:	fec42783          	lw	a5,-20(s0)
80000d98:	fef42223          	sw	a5,-28(s0)
                    p = p->next;
80000d9c:	fec42783          	lw	a5,-20(s0)
80000da0:	0007a783          	lw	a5,0(a5)
80000da4:	fef42623          	sw	a5,-20(s0)
                    psize--;
80000da8:	fd442783          	lw	a5,-44(s0)
80000dac:	fff78793          	addi	a5,a5,-1
80000db0:	fcf42a23          	sw	a5,-44(s0)
80000db4:	0740006f          	j	80000e28 <core_list_mergesort+0x178>
                }
                else if (cmp(p->info, q->info, res) <= 0)
80000db8:	fec42783          	lw	a5,-20(s0)
80000dbc:	0047a703          	lw	a4,4(a5)
80000dc0:	fe842783          	lw	a5,-24(s0)
80000dc4:	0047a683          	lw	a3,4(a5)
80000dc8:	fb842783          	lw	a5,-72(s0)
80000dcc:	fb442603          	lw	a2,-76(s0)
80000dd0:	00068593          	mv	a1,a3
80000dd4:	00070513          	mv	a0,a4
80000dd8:	000780e7          	jalr	a5
80000ddc:	00050793          	mv	a5,a0
80000de0:	02f04463          	bgtz	a5,80000e08 <core_list_mergesort+0x158>
                {
                    /* First element of p is lower (or same); e must come from
                     * p. */
                    e = p;
80000de4:	fec42783          	lw	a5,-20(s0)
80000de8:	fef42223          	sw	a5,-28(s0)
                    p = p->next;
80000dec:	fec42783          	lw	a5,-20(s0)
80000df0:	0007a783          	lw	a5,0(a5)
80000df4:	fef42623          	sw	a5,-20(s0)
                    psize--;
80000df8:	fd442783          	lw	a5,-44(s0)
80000dfc:	fff78793          	addi	a5,a5,-1
80000e00:	fcf42a23          	sw	a5,-44(s0)
80000e04:	0240006f          	j	80000e28 <core_list_mergesort+0x178>
                }
                else
                {
                    /* First element of q is lower; e must come from q. */
                    e = q;
80000e08:	fe842783          	lw	a5,-24(s0)
80000e0c:	fef42223          	sw	a5,-28(s0)
                    q = q->next;
80000e10:	fe842783          	lw	a5,-24(s0)
80000e14:	0007a783          	lw	a5,0(a5)
80000e18:	fef42423          	sw	a5,-24(s0)
                    qsize--;
80000e1c:	fd042783          	lw	a5,-48(s0)
80000e20:	fff78793          	addi	a5,a5,-1
80000e24:	fcf42823          	sw	a5,-48(s0)
                }

                /* add the next element to the merged list */
                if (tail)
80000e28:	fe042783          	lw	a5,-32(s0)
80000e2c:	00078a63          	beqz	a5,80000e40 <core_list_mergesort+0x190>
                {
                    tail->next = e;
80000e30:	fe042783          	lw	a5,-32(s0)
80000e34:	fe442703          	lw	a4,-28(s0)
80000e38:	00e7a023          	sw	a4,0(a5)
80000e3c:	00c0006f          	j	80000e48 <core_list_mergesort+0x198>
                }
                else
                {
                    list = e;
80000e40:	fe442783          	lw	a5,-28(s0)
80000e44:	faf42e23          	sw	a5,-68(s0)
                }
                tail = e;
80000e48:	fe442783          	lw	a5,-28(s0)
80000e4c:	fef42023          	sw	a5,-32(s0)
            while (psize > 0 || (qsize > 0 && q))
80000e50:	fd442783          	lw	a5,-44(s0)
80000e54:	f0f042e3          	bgtz	a5,80000d58 <core_list_mergesort+0xa8>
80000e58:	fd042783          	lw	a5,-48(s0)
80000e5c:	00f05663          	blez	a5,80000e68 <core_list_mergesort+0x1b8>
80000e60:	fe842783          	lw	a5,-24(s0)
80000e64:	ee079ae3          	bnez	a5,80000d58 <core_list_mergesort+0xa8>
            }

            /* now p has stepped `insize' places along, and q has too */
            p = q;
80000e68:	fe842783          	lw	a5,-24(s0)
80000e6c:	fef42623          	sw	a5,-20(s0)
        while (p)
80000e70:	fec42783          	lw	a5,-20(s0)
80000e74:	e6079ce3          	bnez	a5,80000cec <core_list_mergesort+0x3c>
        }

        tail->next = NULL;
80000e78:	fe042783          	lw	a5,-32(s0)
80000e7c:	0007a023          	sw	zero,0(a5)

        /* If we have done only one merge, we're finished. */
        if (nmerges <= 1) /* allow for nmerges==0, the empty list case */
80000e80:	fd842703          	lw	a4,-40(s0)
80000e84:	00100793          	li	a5,1
80000e88:	00e7c663          	blt	a5,a4,80000e94 <core_list_mergesort+0x1e4>
            return list;
80000e8c:	fbc42783          	lw	a5,-68(s0)
80000e90:	0140006f          	j	80000ea4 <core_list_mergesort+0x1f4>

        /* Otherwise repeat, merging lists twice the size */
        insize *= 2;
80000e94:	fdc42783          	lw	a5,-36(s0)
80000e98:	00179793          	slli	a5,a5,0x1
80000e9c:	fcf42e23          	sw	a5,-36(s0)
        p    = list;
80000ea0:	e35ff06f          	j	80000cd4 <core_list_mergesort+0x24>
    }
#if COMPILER_REQUIRES_SORT_RETURN
    return list;
#endif
}
80000ea4:	00078513          	mv	a0,a5
80000ea8:	04c12083          	lw	ra,76(sp)
80000eac:	04812403          	lw	s0,72(sp)
80000eb0:	05010113          	addi	sp,sp,80
80000eb4:	00008067          	ret

80000eb8 <iterate>:
                                    (ee_u16)0xe5a4,
                                    (ee_u16)0x8e3a,
                                    (ee_u16)0x8d84 };
void *
iterate(void *pres)
{
80000eb8:	fd010113          	addi	sp,sp,-48
80000ebc:	02112623          	sw	ra,44(sp)
80000ec0:	02812423          	sw	s0,40(sp)
80000ec4:	03010413          	addi	s0,sp,48
80000ec8:	fca42e23          	sw	a0,-36(s0)
    ee_u32        i;
    ee_u16        crc;
    core_results *res        = (core_results *)pres;
80000ecc:	fdc42783          	lw	a5,-36(s0)
80000ed0:	fef42423          	sw	a5,-24(s0)
    ee_u32        iterations = res->iterations;
80000ed4:	fe842783          	lw	a5,-24(s0)
80000ed8:	01c7a783          	lw	a5,28(a5)
80000edc:	fef42223          	sw	a5,-28(s0)
    res->crc                 = 0;
80000ee0:	fe842783          	lw	a5,-24(s0)
80000ee4:	02079c23          	sh	zero,56(a5)
    res->crclist             = 0;
80000ee8:	fe842783          	lw	a5,-24(s0)
80000eec:	02079d23          	sh	zero,58(a5)
    res->crcmatrix           = 0;
80000ef0:	fe842783          	lw	a5,-24(s0)
80000ef4:	02079e23          	sh	zero,60(a5)
    res->crcstate            = 0;
80000ef8:	fe842783          	lw	a5,-24(s0)
80000efc:	02079f23          	sh	zero,62(a5)
    for (i = 0; i < iterations; i++)
80000f00:	fe042623          	sw	zero,-20(s0)
80000f04:	0a00006f          	j	80000fa4 <iterate+0xec>
    {
        crc      = core_bench_list(res, 1);
80000f08:	00100593          	li	a1,1
80000f0c:	fe842503          	lw	a0,-24(s0)
80000f10:	cc4ff0ef          	jal	800003d4 <core_bench_list>
80000f14:	00050793          	mv	a5,a0
80000f18:	fef41123          	sh	a5,-30(s0)
        res->crc = crcu16(crc, res->crc);
80000f1c:	fe842783          	lw	a5,-24(s0)
80000f20:	0387d703          	lhu	a4,56(a5)
80000f24:	fe245783          	lhu	a5,-30(s0)
80000f28:	00070593          	mv	a1,a4
80000f2c:	00078513          	mv	a0,a5
80000f30:	7f0020ef          	jal	80003720 <crcu16>
80000f34:	00050793          	mv	a5,a0
80000f38:	00078713          	mv	a4,a5
80000f3c:	fe842783          	lw	a5,-24(s0)
80000f40:	02e79c23          	sh	a4,56(a5)
        crc      = core_bench_list(res, -1);
80000f44:	fff00593          	li	a1,-1
80000f48:	fe842503          	lw	a0,-24(s0)
80000f4c:	c88ff0ef          	jal	800003d4 <core_bench_list>
80000f50:	00050793          	mv	a5,a0
80000f54:	fef41123          	sh	a5,-30(s0)
        res->crc = crcu16(crc, res->crc);
80000f58:	fe842783          	lw	a5,-24(s0)
80000f5c:	0387d703          	lhu	a4,56(a5)
80000f60:	fe245783          	lhu	a5,-30(s0)
80000f64:	00070593          	mv	a1,a4
80000f68:	00078513          	mv	a0,a5
80000f6c:	7b4020ef          	jal	80003720 <crcu16>
80000f70:	00050793          	mv	a5,a0
80000f74:	00078713          	mv	a4,a5
80000f78:	fe842783          	lw	a5,-24(s0)
80000f7c:	02e79c23          	sh	a4,56(a5)
        if (i == 0)
80000f80:	fec42783          	lw	a5,-20(s0)
80000f84:	00079a63          	bnez	a5,80000f98 <iterate+0xe0>
            res->crclist = res->crc;
80000f88:	fe842783          	lw	a5,-24(s0)
80000f8c:	0387d703          	lhu	a4,56(a5)
80000f90:	fe842783          	lw	a5,-24(s0)
80000f94:	02e79d23          	sh	a4,58(a5)
    for (i = 0; i < iterations; i++)
80000f98:	fec42783          	lw	a5,-20(s0)
80000f9c:	00178793          	addi	a5,a5,1
80000fa0:	fef42623          	sw	a5,-20(s0)
80000fa4:	fec42703          	lw	a4,-20(s0)
80000fa8:	fe442783          	lw	a5,-28(s0)
80000fac:	f4f76ee3          	bltu	a4,a5,80000f08 <iterate+0x50>
    }
    return NULL;
80000fb0:	00000793          	li	a5,0
}
80000fb4:	00078513          	mv	a0,a5
80000fb8:	02c12083          	lw	ra,44(sp)
80000fbc:	02812403          	lw	s0,40(sp)
80000fc0:	03010113          	addi	sp,sp,48
80000fc4:	00008067          	ret

80000fc8 <main>:
    int   argc = 0;
    char *argv[1];
#else
MAIN_RETURN_TYPE
main(int argc, char *argv[])
{
80000fc8:	81010113          	addi	sp,sp,-2032
80000fcc:	7e112623          	sw	ra,2028(sp)
80000fd0:	7e812423          	sw	s0,2024(sp)
80000fd4:	7e912223          	sw	s1,2020(sp)
80000fd8:	7f010413          	addi	s0,sp,2032
80000fdc:	f9010113          	addi	sp,sp,-112
80000fe0:	fffff7b7          	lui	a5,0xfffff
80000fe4:	ff078793          	addi	a5,a5,-16 # ffffeff0 <_estack+0x7fefeff0>
80000fe8:	008787b3          	add	a5,a5,s0
80000fec:	7aa7ae23          	sw	a0,1980(a5)
80000ff0:	fffff7b7          	lui	a5,0xfffff
80000ff4:	ff078793          	addi	a5,a5,-16 # ffffeff0 <_estack+0x7fefeff0>
80000ff8:	008787b3          	add	a5,a5,s0
80000ffc:	7ab7ac23          	sw	a1,1976(a5)
#endif
    ee_u16       i, j = 0, num_algorithms = 0;
80001000:	fe041623          	sh	zero,-20(s0)
80001004:	fe041523          	sh	zero,-22(s0)
    ee_s16       known_id = -1, total_errors = 0;
80001008:	fff00793          	li	a5,-1
8000100c:	fef41423          	sh	a5,-24(s0)
80001010:	fe041323          	sh	zero,-26(s0)
    ee_u16       seedcrc = 0;
80001014:	fc041b23          	sh	zero,-42(s0)
    core_results results[MULTITHREAD];
#if (MEM_METHOD == MEM_STACK)
    ee_u8 stack_memblock[TOTAL_DATA_SIZE * MULTITHREAD];
#endif
    /* first call any initializations needed */
    portable_init(&(results[0].port), &argc, argv);
80001018:	fffff7b7          	lui	a5,0xfffff
8000101c:	ff078793          	addi	a5,a5,-16 # ffffeff0 <_estack+0x7fefeff0>
80001020:	008787b3          	add	a5,a5,s0
80001024:	fffff737          	lui	a4,0xfffff
80001028:	7bc70713          	addi	a4,a4,1980 # fffff7bc <_estack+0x7feff7bc>
8000102c:	ff070713          	addi	a4,a4,-16
80001030:	008706b3          	add	a3,a4,s0
80001034:	f8c40713          	addi	a4,s0,-116
80001038:	04270713          	addi	a4,a4,66
8000103c:	7b87a603          	lw	a2,1976(a5)
80001040:	00068593          	mv	a1,a3
80001044:	00070513          	mv	a0,a4
80001048:	155020ef          	jal	8000399c <portable_init>
    if (sizeof(struct list_head_s) > 128)
    {
        ee_printf("list_head structure too big for comparable data!\n");
        return MAIN_RETURN_VAL;
    }
    results[0].seed1      = get_seed(1);
8000104c:	00100513          	li	a0,1
80001050:	4d4020ef          	jal	80003524 <get_seed_32>
80001054:	00050793          	mv	a5,a0
80001058:	01079793          	slli	a5,a5,0x10
8000105c:	4107d793          	srai	a5,a5,0x10
80001060:	f8f41623          	sh	a5,-116(s0)
    results[0].seed2      = get_seed(2);
80001064:	00200513          	li	a0,2
80001068:	4bc020ef          	jal	80003524 <get_seed_32>
8000106c:	00050793          	mv	a5,a0
80001070:	01079793          	slli	a5,a5,0x10
80001074:	4107d793          	srai	a5,a5,0x10
80001078:	f8f41723          	sh	a5,-114(s0)
    results[0].seed3      = get_seed(3);
8000107c:	00300513          	li	a0,3
80001080:	4a4020ef          	jal	80003524 <get_seed_32>
80001084:	00050793          	mv	a5,a0
80001088:	01079793          	slli	a5,a5,0x10
8000108c:	4107d793          	srai	a5,a5,0x10
80001090:	f8f41823          	sh	a5,-112(s0)
    results[0].iterations = get_seed_32(4);
80001094:	00400513          	li	a0,4
80001098:	48c020ef          	jal	80003524 <get_seed_32>
8000109c:	00050793          	mv	a5,a0
800010a0:	faf42423          	sw	a5,-88(s0)
#if CORE_DEBUG
    results[0].iterations = 1;
#endif
    results[0].execs = get_seed_32(5);
800010a4:	00500513          	li	a0,5
800010a8:	47c020ef          	jal	80003524 <get_seed_32>
800010ac:	00050793          	mv	a5,a0
800010b0:	faf42623          	sw	a5,-84(s0)
    if (results[0].execs == 0)
800010b4:	fac42783          	lw	a5,-84(s0)
800010b8:	00079663          	bnez	a5,800010c4 <main+0xfc>
    { /* if not supplied, execute all algorithms */
        results[0].execs = ALL_ALGORITHMS_MASK;
800010bc:	00700793          	li	a5,7
800010c0:	faf42623          	sw	a5,-84(s0)
    }
    /* put in some default values based on one seed only for easy testing */
    if ((results[0].seed1 == 0) && (results[0].seed2 == 0)
800010c4:	f8c41783          	lh	a5,-116(s0)
800010c8:	02079263          	bnez	a5,800010ec <main+0x124>
800010cc:	f8e41783          	lh	a5,-114(s0)
800010d0:	00079e63          	bnez	a5,800010ec <main+0x124>
        && (results[0].seed3 == 0))
800010d4:	f9041783          	lh	a5,-112(s0)
800010d8:	00079a63          	bnez	a5,800010ec <main+0x124>
    { /* performance run */
        results[0].seed1 = 0;
800010dc:	f8041623          	sh	zero,-116(s0)
        results[0].seed2 = 0;
800010e0:	f8041723          	sh	zero,-114(s0)
        results[0].seed3 = 0x66;
800010e4:	06600793          	li	a5,102
800010e8:	f8f41823          	sh	a5,-112(s0)
    }
    if ((results[0].seed1 == 1) && (results[0].seed2 == 0)
800010ec:	f8c41703          	lh	a4,-116(s0)
800010f0:	00100793          	li	a5,1
800010f4:	02f71a63          	bne	a4,a5,80001128 <main+0x160>
800010f8:	f8e41783          	lh	a5,-114(s0)
800010fc:	02079663          	bnez	a5,80001128 <main+0x160>
        && (results[0].seed3 == 0))
80001100:	f9041783          	lh	a5,-112(s0)
80001104:	02079263          	bnez	a5,80001128 <main+0x160>
    { /* validation run */
        results[0].seed1 = 0x3415;
80001108:	000037b7          	lui	a5,0x3
8000110c:	41578793          	addi	a5,a5,1045 # 3415 <_start-0x7fffcbeb>
80001110:	f8f41623          	sh	a5,-116(s0)
        results[0].seed2 = 0x3415;
80001114:	000037b7          	lui	a5,0x3
80001118:	41578793          	addi	a5,a5,1045 # 3415 <_start-0x7fffcbeb>
8000111c:	f8f41723          	sh	a5,-114(s0)
        results[0].seed3 = 0x66;
80001120:	06600793          	li	a5,102
80001124:	f8f41823          	sh	a5,-112(s0)
        results[i].seed3       = results[0].seed3;
        results[i].err         = 0;
        results[i].execs       = results[0].execs;
    }
#elif (MEM_METHOD == MEM_STACK)
for (i = 0; i < MULTITHREAD; i++)
80001128:	fe041723          	sh	zero,-18(s0)
8000112c:	1380006f          	j	80001264 <main+0x29c>
{
    results[i].memblock[0] = stack_memblock + i * TOTAL_DATA_SIZE;
80001130:	fee45703          	lhu	a4,-18(s0)
80001134:	00070793          	mv	a5,a4
80001138:	00579793          	slli	a5,a5,0x5
8000113c:	40e787b3          	sub	a5,a5,a4
80001140:	00279793          	slli	a5,a5,0x2
80001144:	00e787b3          	add	a5,a5,a4
80001148:	00479793          	slli	a5,a5,0x4
8000114c:	00078693          	mv	a3,a5
80001150:	fee45703          	lhu	a4,-18(s0)
80001154:	fffff7b7          	lui	a5,0xfffff
80001158:	7cc78793          	addi	a5,a5,1996 # fffff7cc <_estack+0x7feff7cc>
8000115c:	ff078793          	addi	a5,a5,-16
80001160:	008787b3          	add	a5,a5,s0
80001164:	00d786b3          	add	a3,a5,a3
80001168:	00070793          	mv	a5,a4
8000116c:	00479793          	slli	a5,a5,0x4
80001170:	00e787b3          	add	a5,a5,a4
80001174:	00279793          	slli	a5,a5,0x2
80001178:	ff078793          	addi	a5,a5,-16
8000117c:	008787b3          	add	a5,a5,s0
80001180:	fad7a223          	sw	a3,-92(a5)
    results[i].size        = TOTAL_DATA_SIZE;
80001184:	fee45703          	lhu	a4,-18(s0)
80001188:	00070793          	mv	a5,a4
8000118c:	00479793          	slli	a5,a5,0x4
80001190:	00e787b3          	add	a5,a5,a4
80001194:	00279793          	slli	a5,a5,0x2
80001198:	ff078793          	addi	a5,a5,-16
8000119c:	008787b3          	add	a5,a5,s0
800011a0:	7d000713          	li	a4,2000
800011a4:	fae7aa23          	sw	a4,-76(a5)
    results[i].seed1       = results[0].seed1;
800011a8:	fee45703          	lhu	a4,-18(s0)
800011ac:	f8c41683          	lh	a3,-116(s0)
800011b0:	00070793          	mv	a5,a4
800011b4:	00479793          	slli	a5,a5,0x4
800011b8:	00e787b3          	add	a5,a5,a4
800011bc:	00279793          	slli	a5,a5,0x2
800011c0:	ff078793          	addi	a5,a5,-16
800011c4:	008787b3          	add	a5,a5,s0
800011c8:	f8d79e23          	sh	a3,-100(a5)
    results[i].seed2       = results[0].seed2;
800011cc:	fee45703          	lhu	a4,-18(s0)
800011d0:	f8e41683          	lh	a3,-114(s0)
800011d4:	00070793          	mv	a5,a4
800011d8:	00479793          	slli	a5,a5,0x4
800011dc:	00e787b3          	add	a5,a5,a4
800011e0:	00279793          	slli	a5,a5,0x2
800011e4:	ff078793          	addi	a5,a5,-16
800011e8:	008787b3          	add	a5,a5,s0
800011ec:	f8d79f23          	sh	a3,-98(a5)
    results[i].seed3       = results[0].seed3;
800011f0:	fee45703          	lhu	a4,-18(s0)
800011f4:	f9041683          	lh	a3,-112(s0)
800011f8:	00070793          	mv	a5,a4
800011fc:	00479793          	slli	a5,a5,0x4
80001200:	00e787b3          	add	a5,a5,a4
80001204:	00279793          	slli	a5,a5,0x2
80001208:	ff078793          	addi	a5,a5,-16
8000120c:	008787b3          	add	a5,a5,s0
80001210:	fad79023          	sh	a3,-96(a5)
    results[i].err         = 0;
80001214:	fee45703          	lhu	a4,-18(s0)
80001218:	00070793          	mv	a5,a4
8000121c:	00479793          	slli	a5,a5,0x4
80001220:	00e787b3          	add	a5,a5,a4
80001224:	00279793          	slli	a5,a5,0x2
80001228:	ff078793          	addi	a5,a5,-16
8000122c:	008787b3          	add	a5,a5,s0
80001230:	fc079e23          	sh	zero,-36(a5)
    results[i].execs       = results[0].execs;
80001234:	fee45703          	lhu	a4,-18(s0)
80001238:	fac42683          	lw	a3,-84(s0)
8000123c:	00070793          	mv	a5,a4
80001240:	00479793          	slli	a5,a5,0x4
80001244:	00e787b3          	add	a5,a5,a4
80001248:	00279793          	slli	a5,a5,0x2
8000124c:	ff078793          	addi	a5,a5,-16
80001250:	008787b3          	add	a5,a5,s0
80001254:	fad7ae23          	sw	a3,-68(a5)
for (i = 0; i < MULTITHREAD; i++)
80001258:	fee45783          	lhu	a5,-18(s0)
8000125c:	00178793          	addi	a5,a5,1
80001260:	fef41723          	sh	a5,-18(s0)
80001264:	fee45783          	lhu	a5,-18(s0)
80001268:	ec0784e3          	beqz	a5,80001130 <main+0x168>
#else
#error "Please define a way to initialize a memory block."
#endif
    /* Data init */
    /* Find out how space much we have based on number of algorithms */
    for (i = 0; i < NUM_ALGORITHMS; i++)
8000126c:	fe041723          	sh	zero,-18(s0)
80001270:	0380006f          	j	800012a8 <main+0x2e0>
    {
        if ((1 << (ee_u32)i) & results[0].execs)
80001274:	fee45783          	lhu	a5,-18(s0)
80001278:	00100713          	li	a4,1
8000127c:	00f717b3          	sll	a5,a4,a5
80001280:	00078713          	mv	a4,a5
80001284:	fac42783          	lw	a5,-84(s0)
80001288:	00f777b3          	and	a5,a4,a5
8000128c:	00078863          	beqz	a5,8000129c <main+0x2d4>
            num_algorithms++;
80001290:	fea45783          	lhu	a5,-22(s0)
80001294:	00178793          	addi	a5,a5,1
80001298:	fef41523          	sh	a5,-22(s0)
    for (i = 0; i < NUM_ALGORITHMS; i++)
8000129c:	fee45783          	lhu	a5,-18(s0)
800012a0:	00178793          	addi	a5,a5,1
800012a4:	fef41723          	sh	a5,-18(s0)
800012a8:	fee45703          	lhu	a4,-18(s0)
800012ac:	00200793          	li	a5,2
800012b0:	fce7f2e3          	bgeu	a5,a4,80001274 <main+0x2ac>
    }
    for (i = 0; i < MULTITHREAD; i++)
800012b4:	fe041723          	sh	zero,-18(s0)
800012b8:	0680006f          	j	80001320 <main+0x358>
        results[i].size = results[i].size / num_algorithms;
800012bc:	fee45703          	lhu	a4,-18(s0)
800012c0:	00070793          	mv	a5,a4
800012c4:	00479793          	slli	a5,a5,0x4
800012c8:	00e787b3          	add	a5,a5,a4
800012cc:	00279793          	slli	a5,a5,0x2
800012d0:	ff078793          	addi	a5,a5,-16
800012d4:	008787b3          	add	a5,a5,s0
800012d8:	fb47a783          	lw	a5,-76(a5)
800012dc:	fea45703          	lhu	a4,-22(s0)
800012e0:	fee45483          	lhu	s1,-18(s0)
800012e4:	00070593          	mv	a1,a4
800012e8:	00078513          	mv	a0,a5
800012ec:	7ec030ef          	jal	80004ad8 <__hidden___udivsi3>
800012f0:	00050793          	mv	a5,a0
800012f4:	00078713          	mv	a4,a5
800012f8:	00048793          	mv	a5,s1
800012fc:	00479793          	slli	a5,a5,0x4
80001300:	009787b3          	add	a5,a5,s1
80001304:	00279793          	slli	a5,a5,0x2
80001308:	ff078793          	addi	a5,a5,-16
8000130c:	008787b3          	add	a5,a5,s0
80001310:	fae7aa23          	sw	a4,-76(a5)
    for (i = 0; i < MULTITHREAD; i++)
80001314:	fee45783          	lhu	a5,-18(s0)
80001318:	00178793          	addi	a5,a5,1
8000131c:	fef41723          	sh	a5,-18(s0)
80001320:	fee45783          	lhu	a5,-18(s0)
80001324:	f8078ce3          	beqz	a5,800012bc <main+0x2f4>
    /* Assign pointers */
    for (i = 0; i < NUM_ALGORITHMS; i++)
80001328:	fe041723          	sh	zero,-18(s0)
8000132c:	0c00006f          	j	800013ec <main+0x424>
    {
        ee_u32 ctx;
        if ((1 << (ee_u32)i) & results[0].execs)
80001330:	fee45783          	lhu	a5,-18(s0)
80001334:	00100713          	li	a4,1
80001338:	00f717b3          	sll	a5,a4,a5
8000133c:	00078713          	mv	a4,a5
80001340:	fac42783          	lw	a5,-84(s0)
80001344:	00f777b3          	and	a5,a4,a5
80001348:	08078c63          	beqz	a5,800013e0 <main+0x418>
        {
            for (ctx = 0; ctx < MULTITHREAD; ctx++)
8000134c:	fe042023          	sw	zero,-32(s0)
80001350:	07c0006f          	j	800013cc <main+0x404>
                results[ctx].memblock[i + 1]
                    = (char *)(results[ctx].memblock[0]) + results[0].size * j;
80001354:	fe042703          	lw	a4,-32(s0)
80001358:	00070793          	mv	a5,a4
8000135c:	00479793          	slli	a5,a5,0x4
80001360:	00e787b3          	add	a5,a5,a4
80001364:	00279793          	slli	a5,a5,0x2
80001368:	ff078793          	addi	a5,a5,-16
8000136c:	008787b3          	add	a5,a5,s0
80001370:	fa47a483          	lw	s1,-92(a5)
80001374:	fa442783          	lw	a5,-92(s0)
80001378:	fec45703          	lhu	a4,-20(s0)
8000137c:	00070593          	mv	a1,a4
80001380:	00078513          	mv	a0,a5
80001384:	728030ef          	jal	80004aac <__mulsi3>
80001388:	00050793          	mv	a5,a0
8000138c:	00078713          	mv	a4,a5
                results[ctx].memblock[i + 1]
80001390:	fee45783          	lhu	a5,-18(s0)
80001394:	00178613          	addi	a2,a5,1
                    = (char *)(results[ctx].memblock[0]) + results[0].size * j;
80001398:	00e486b3          	add	a3,s1,a4
8000139c:	fe042703          	lw	a4,-32(s0)
800013a0:	00070793          	mv	a5,a4
800013a4:	00479793          	slli	a5,a5,0x4
800013a8:	00e787b3          	add	a5,a5,a4
800013ac:	00c78733          	add	a4,a5,a2
800013b0:	f9440793          	addi	a5,s0,-108
800013b4:	00271713          	slli	a4,a4,0x2
800013b8:	00f707b3          	add	a5,a4,a5
800013bc:	00d7a023          	sw	a3,0(a5)
            for (ctx = 0; ctx < MULTITHREAD; ctx++)
800013c0:	fe042783          	lw	a5,-32(s0)
800013c4:	00178793          	addi	a5,a5,1
800013c8:	fef42023          	sw	a5,-32(s0)
800013cc:	fe042783          	lw	a5,-32(s0)
800013d0:	f80782e3          	beqz	a5,80001354 <main+0x38c>
            j++;
800013d4:	fec45783          	lhu	a5,-20(s0)
800013d8:	00178793          	addi	a5,a5,1
800013dc:	fef41623          	sh	a5,-20(s0)
    for (i = 0; i < NUM_ALGORITHMS; i++)
800013e0:	fee45783          	lhu	a5,-18(s0)
800013e4:	00178793          	addi	a5,a5,1
800013e8:	fef41723          	sh	a5,-18(s0)
800013ec:	fee45703          	lhu	a4,-18(s0)
800013f0:	00200793          	li	a5,2
800013f4:	f2e7fee3          	bgeu	a5,a4,80001330 <main+0x368>
        }
    }
    /* call inits */
    for (i = 0; i < MULTITHREAD; i++)
800013f8:	fe041723          	sh	zero,-18(s0)
800013fc:	1e80006f          	j	800015e4 <main+0x61c>
    {
        if (results[i].execs & ID_LIST)
80001400:	fee45703          	lhu	a4,-18(s0)
80001404:	00070793          	mv	a5,a4
80001408:	00479793          	slli	a5,a5,0x4
8000140c:	00e787b3          	add	a5,a5,a4
80001410:	00279793          	slli	a5,a5,0x2
80001414:	ff078793          	addi	a5,a5,-16
80001418:	008787b3          	add	a5,a5,s0
8000141c:	fbc7a783          	lw	a5,-68(a5)
80001420:	0017f793          	andi	a5,a5,1
80001424:	06078c63          	beqz	a5,8000149c <main+0x4d4>
        {
            results[i].list = core_list_init(
80001428:	fa442683          	lw	a3,-92(s0)
8000142c:	fee45703          	lhu	a4,-18(s0)
                results[0].size, results[i].memblock[1], results[i].seed1);
80001430:	00070793          	mv	a5,a4
80001434:	00479793          	slli	a5,a5,0x4
80001438:	00e787b3          	add	a5,a5,a4
8000143c:	00279793          	slli	a5,a5,0x2
80001440:	ff078793          	addi	a5,a5,-16
80001444:	008787b3          	add	a5,a5,s0
80001448:	fa87a583          	lw	a1,-88(a5)
            results[i].list = core_list_init(
8000144c:	fee45703          	lhu	a4,-18(s0)
80001450:	00070793          	mv	a5,a4
80001454:	00479793          	slli	a5,a5,0x4
80001458:	00e787b3          	add	a5,a5,a4
8000145c:	00279793          	slli	a5,a5,0x2
80001460:	ff078793          	addi	a5,a5,-16
80001464:	008787b3          	add	a5,a5,s0
80001468:	f9c79783          	lh	a5,-100(a5)
8000146c:	fee45483          	lhu	s1,-18(s0)
80001470:	00078613          	mv	a2,a5
80001474:	00068513          	mv	a0,a3
80001478:	a84ff0ef          	jal	800006fc <core_list_init>
8000147c:	00050713          	mv	a4,a0
80001480:	00048793          	mv	a5,s1
80001484:	00479793          	slli	a5,a5,0x4
80001488:	009787b3          	add	a5,a5,s1
8000148c:	00279793          	slli	a5,a5,0x2
80001490:	ff078793          	addi	a5,a5,-16
80001494:	008787b3          	add	a5,a5,s0
80001498:	fce7a023          	sw	a4,-64(a5)
        }
        if (results[i].execs & ID_MATRIX)
8000149c:	fee45703          	lhu	a4,-18(s0)
800014a0:	00070793          	mv	a5,a4
800014a4:	00479793          	slli	a5,a5,0x4
800014a8:	00e787b3          	add	a5,a5,a4
800014ac:	00279793          	slli	a5,a5,0x2
800014b0:	ff078793          	addi	a5,a5,-16
800014b4:	008787b3          	add	a5,a5,s0
800014b8:	fbc7a783          	lw	a5,-68(a5)
800014bc:	0027f793          	andi	a5,a5,2
800014c0:	0a078063          	beqz	a5,80001560 <main+0x598>
        {
            core_init_matrix(results[0].size,
800014c4:	fa442503          	lw	a0,-92(s0)
800014c8:	fee45703          	lhu	a4,-18(s0)
800014cc:	00070793          	mv	a5,a4
800014d0:	00479793          	slli	a5,a5,0x4
800014d4:	00e787b3          	add	a5,a5,a4
800014d8:	00279793          	slli	a5,a5,0x2
800014dc:	ff078793          	addi	a5,a5,-16
800014e0:	008787b3          	add	a5,a5,s0
800014e4:	fac7a583          	lw	a1,-84(a5)
                             results[i].memblock[2],
                             (ee_s32)results[i].seed1
800014e8:	fee45703          	lhu	a4,-18(s0)
800014ec:	00070793          	mv	a5,a4
800014f0:	00479793          	slli	a5,a5,0x4
800014f4:	00e787b3          	add	a5,a5,a4
800014f8:	00279793          	slli	a5,a5,0x2
800014fc:	ff078793          	addi	a5,a5,-16
80001500:	008787b3          	add	a5,a5,s0
80001504:	f9c79783          	lh	a5,-100(a5)
80001508:	00078693          	mv	a3,a5
                                 | (((ee_s32)results[i].seed2) << 16),
8000150c:	fee45703          	lhu	a4,-18(s0)
80001510:	00070793          	mv	a5,a4
80001514:	00479793          	slli	a5,a5,0x4
80001518:	00e787b3          	add	a5,a5,a4
8000151c:	00279793          	slli	a5,a5,0x2
80001520:	ff078793          	addi	a5,a5,-16
80001524:	008787b3          	add	a5,a5,s0
80001528:	f9e79783          	lh	a5,-98(a5)
8000152c:	01079793          	slli	a5,a5,0x10
80001530:	00f6e633          	or	a2,a3,a5
                             &(results[i].mat));
80001534:	fee45703          	lhu	a4,-18(s0)
            core_init_matrix(results[0].size,
80001538:	f8c40693          	addi	a3,s0,-116
8000153c:	00070793          	mv	a5,a4
80001540:	00479793          	slli	a5,a5,0x4
80001544:	00e787b3          	add	a5,a5,a4
80001548:	00279793          	slli	a5,a5,0x2
8000154c:	02078793          	addi	a5,a5,32
80001550:	00f687b3          	add	a5,a3,a5
80001554:	00878793          	addi	a5,a5,8
80001558:	00078693          	mv	a3,a5
8000155c:	43d000ef          	jal	80002198 <core_init_matrix>
        }
        if (results[i].execs & ID_STATE)
80001560:	fee45703          	lhu	a4,-18(s0)
80001564:	00070793          	mv	a5,a4
80001568:	00479793          	slli	a5,a5,0x4
8000156c:	00e787b3          	add	a5,a5,a4
80001570:	00279793          	slli	a5,a5,0x2
80001574:	ff078793          	addi	a5,a5,-16
80001578:	008787b3          	add	a5,a5,s0
8000157c:	fbc7a783          	lw	a5,-68(a5)
80001580:	0047f793          	andi	a5,a5,4
80001584:	04078a63          	beqz	a5,800015d8 <main+0x610>
        {
            core_init_state(
80001588:	fa442683          	lw	a3,-92(s0)
8000158c:	fee45703          	lhu	a4,-18(s0)
80001590:	00070793          	mv	a5,a4
80001594:	00479793          	slli	a5,a5,0x4
80001598:	00e787b3          	add	a5,a5,a4
8000159c:	00279793          	slli	a5,a5,0x2
800015a0:	ff078793          	addi	a5,a5,-16
800015a4:	008787b3          	add	a5,a5,s0
800015a8:	f9c79583          	lh	a1,-100(a5)
800015ac:	fee45703          	lhu	a4,-18(s0)
                results[0].size, results[i].seed1, results[i].memblock[3]);
800015b0:	00070793          	mv	a5,a4
800015b4:	00479793          	slli	a5,a5,0x4
800015b8:	00e787b3          	add	a5,a5,a4
800015bc:	00279793          	slli	a5,a5,0x2
800015c0:	ff078793          	addi	a5,a5,-16
800015c4:	008787b3          	add	a5,a5,s0
800015c8:	fb07a783          	lw	a5,-80(a5)
            core_init_state(
800015cc:	00078613          	mv	a2,a5
800015d0:	00068513          	mv	a0,a3
800015d4:	065010ef          	jal	80002e38 <core_init_state>
    for (i = 0; i < MULTITHREAD; i++)
800015d8:	fee45783          	lhu	a5,-18(s0)
800015dc:	00178793          	addi	a5,a5,1
800015e0:	fef41723          	sh	a5,-18(s0)
800015e4:	fee45783          	lhu	a5,-18(s0)
800015e8:	e0078ce3          	beqz	a5,80001400 <main+0x438>
        }
    }

    /* automatically determine number of iterations if not set */
    if (results[0].iterations == 0)
800015ec:	fa842783          	lw	a5,-88(s0)
800015f0:	0a079063          	bnez	a5,80001690 <main+0x6c8>
    {
        secs_ret secs_passed = 0;
800015f4:	fc042e23          	sw	zero,-36(s0)
        ee_u32   divisor;
        results[0].iterations = 1;
800015f8:	00100793          	li	a5,1
800015fc:	faf42423          	sw	a5,-88(s0)
        while (secs_passed < (secs_ret)1)
80001600:	0440006f          	j	80001644 <main+0x67c>
        {
            results[0].iterations *= 10;
80001604:	fa842703          	lw	a4,-88(s0)
80001608:	00070793          	mv	a5,a4
8000160c:	00279793          	slli	a5,a5,0x2
80001610:	00e787b3          	add	a5,a5,a4
80001614:	00179793          	slli	a5,a5,0x1
80001618:	faf42423          	sw	a5,-88(s0)
            start_time();
8000161c:	2c4020ef          	jal	800038e0 <start_time>
            iterate(&results[0]);
80001620:	f8c40793          	addi	a5,s0,-116
80001624:	00078513          	mv	a0,a5
80001628:	891ff0ef          	jal	80000eb8 <iterate>
            stop_time();
8000162c:	2e8020ef          	jal	80003914 <stop_time>
            secs_passed = time_in_secs(get_time());
80001630:	318020ef          	jal	80003948 <get_time>
80001634:	00050793          	mv	a5,a0
80001638:	00078513          	mv	a0,a5
8000163c:	334020ef          	jal	80003970 <time_in_secs>
80001640:	fca42e23          	sw	a0,-36(s0)
        while (secs_passed < (secs_ret)1)
80001644:	fdc42783          	lw	a5,-36(s0)
80001648:	fa078ee3          	beqz	a5,80001604 <main+0x63c>
        }
        /* now we know it executes for at least 1 sec, set actual run time at
         * about 10 secs */
        divisor = (ee_u32)secs_passed;
8000164c:	fdc42783          	lw	a5,-36(s0)
80001650:	fcf42c23          	sw	a5,-40(s0)
        if (divisor == 0) /* some machines cast float to int as 0 since this
80001654:	fd842783          	lw	a5,-40(s0)
80001658:	00079663          	bnez	a5,80001664 <main+0x69c>
                             conversion is not defined by ANSI, but we know at
                             least one second passed */
            divisor = 1;
8000165c:	00100793          	li	a5,1
80001660:	fcf42c23          	sw	a5,-40(s0)
        results[0].iterations *= 1 + 10 / divisor;
80001664:	fa842483          	lw	s1,-88(s0)
80001668:	fd842583          	lw	a1,-40(s0)
8000166c:	00a00513          	li	a0,10
80001670:	468030ef          	jal	80004ad8 <__hidden___udivsi3>
80001674:	00050793          	mv	a5,a0
80001678:	00178793          	addi	a5,a5,1
8000167c:	00078593          	mv	a1,a5
80001680:	00048513          	mv	a0,s1
80001684:	428030ef          	jal	80004aac <__mulsi3>
80001688:	00050793          	mv	a5,a0
8000168c:	faf42423          	sw	a5,-88(s0)
    }
    /* perform actual benchmark */
    start_time();
80001690:	250020ef          	jal	800038e0 <start_time>
    for (i = 0; i < default_num_contexts; i++)
    {
        core_stop_parallel(&results[i]);
    }
#else
    iterate(&results[0]);
80001694:	f8c40793          	addi	a5,s0,-116
80001698:	00078513          	mv	a0,a5
8000169c:	81dff0ef          	jal	80000eb8 <iterate>
#endif
    stop_time();
800016a0:	274020ef          	jal	80003914 <stop_time>
    total_time = get_time();
800016a4:	2a4020ef          	jal	80003948 <get_time>
800016a8:	fca42823          	sw	a0,-48(s0)
    /* get a function of the input to report */
    seedcrc = crc16(results[0].seed1, seedcrc);
800016ac:	f8c41783          	lh	a5,-116(s0)
800016b0:	fd645703          	lhu	a4,-42(s0)
800016b4:	00070593          	mv	a1,a4
800016b8:	00078513          	mv	a0,a5
800016bc:	16c020ef          	jal	80003828 <crc16>
800016c0:	00050793          	mv	a5,a0
800016c4:	fcf41b23          	sh	a5,-42(s0)
    seedcrc = crc16(results[0].seed2, seedcrc);
800016c8:	f8e41783          	lh	a5,-114(s0)
800016cc:	fd645703          	lhu	a4,-42(s0)
800016d0:	00070593          	mv	a1,a4
800016d4:	00078513          	mv	a0,a5
800016d8:	150020ef          	jal	80003828 <crc16>
800016dc:	00050793          	mv	a5,a0
800016e0:	fcf41b23          	sh	a5,-42(s0)
    seedcrc = crc16(results[0].seed3, seedcrc);
800016e4:	f9041783          	lh	a5,-112(s0)
800016e8:	fd645703          	lhu	a4,-42(s0)
800016ec:	00070593          	mv	a1,a4
800016f0:	00078513          	mv	a0,a5
800016f4:	134020ef          	jal	80003828 <crc16>
800016f8:	00050793          	mv	a5,a0
800016fc:	fcf41b23          	sh	a5,-42(s0)
    seedcrc = crc16(results[0].size, seedcrc);
80001700:	fa442783          	lw	a5,-92(s0)
80001704:	01079793          	slli	a5,a5,0x10
80001708:	4107d793          	srai	a5,a5,0x10
8000170c:	fd645703          	lhu	a4,-42(s0)
80001710:	00070593          	mv	a1,a4
80001714:	00078513          	mv	a0,a5
80001718:	110020ef          	jal	80003828 <crc16>
8000171c:	00050793          	mv	a5,a0
80001720:	fcf41b23          	sh	a5,-42(s0)

    switch (seedcrc)
80001724:	fd645783          	lhu	a5,-42(s0)
80001728:	0000f737          	lui	a4,0xf
8000172c:	9f570713          	addi	a4,a4,-1547 # e9f5 <_start-0x7fff160b>
80001730:	0ae78063          	beq	a5,a4,800017d0 <main+0x808>
80001734:	0000f737          	lui	a4,0xf
80001738:	9f570713          	addi	a4,a4,-1547 # e9f5 <_start-0x7fff160b>
8000173c:	0cf74263          	blt	a4,a5,80001800 <main+0x838>
80001740:	00009737          	lui	a4,0x9
80001744:	a0270713          	addi	a4,a4,-1534 # 8a02 <_start-0x7fff75fe>
80001748:	04e78263          	beq	a5,a4,8000178c <main+0x7c4>
8000174c:	00009737          	lui	a4,0x9
80001750:	a0270713          	addi	a4,a4,-1534 # 8a02 <_start-0x7fff75fe>
80001754:	0af74663          	blt	a4,a5,80001800 <main+0x838>
80001758:	00008737          	lui	a4,0x8
8000175c:	b0570713          	addi	a4,a4,-1275 # 7b05 <_start-0x7fff84fb>
80001760:	04e78063          	beq	a5,a4,800017a0 <main+0x7d8>
80001764:	00008737          	lui	a4,0x8
80001768:	b0570713          	addi	a4,a4,-1275 # 7b05 <_start-0x7fff84fb>
8000176c:	08f74a63          	blt	a4,a5,80001800 <main+0x838>
80001770:	00002737          	lui	a4,0x2
80001774:	8f270713          	addi	a4,a4,-1806 # 18f2 <_start-0x7fffe70e>
80001778:	06e78863          	beq	a5,a4,800017e8 <main+0x820>
8000177c:	00005737          	lui	a4,0x5
80001780:	eaf70713          	addi	a4,a4,-337 # 4eaf <_start-0x7fffb151>
80001784:	02e78a63          	beq	a5,a4,800017b8 <main+0x7f0>
80001788:	0780006f          	j	80001800 <main+0x838>
    {                /* test known output for common seeds */
        case 0x8a02: /* seed1=0, seed2=0, seed3=0x66, size 2000 per algorithm */
            known_id = 0;
8000178c:	fe041423          	sh	zero,-24(s0)
            ee_printf("6k performance run parameters for coremark.\n");
80001790:	800057b7          	lui	a5,0x80005
80001794:	b9c78513          	addi	a0,a5,-1124 # 80004b9c <__modsi3+0x48>
80001798:	25c030ef          	jal	800049f4 <ee_printf>
            break;
8000179c:	0700006f          	j	8000180c <main+0x844>
        case 0x7b05: /*  seed1=0x3415, seed2=0x3415, seed3=0x66, size 2000 per
                        algorithm */
            known_id = 1;
800017a0:	00100793          	li	a5,1
800017a4:	fef41423          	sh	a5,-24(s0)
            ee_printf("6k validation run parameters for coremark.\n");
800017a8:	800057b7          	lui	a5,0x80005
800017ac:	bcc78513          	addi	a0,a5,-1076 # 80004bcc <__modsi3+0x78>
800017b0:	244030ef          	jal	800049f4 <ee_printf>
            break;
800017b4:	0580006f          	j	8000180c <main+0x844>
        case 0x4eaf: /* seed1=0x8, seed2=0x8, seed3=0x8, size 400 per algorithm
                      */
            known_id = 2;
800017b8:	00200793          	li	a5,2
800017bc:	fef41423          	sh	a5,-24(s0)
            ee_printf("Profile generation run parameters for coremark.\n");
800017c0:	800057b7          	lui	a5,0x80005
800017c4:	bf878513          	addi	a0,a5,-1032 # 80004bf8 <__modsi3+0xa4>
800017c8:	22c030ef          	jal	800049f4 <ee_printf>
            break;
800017cc:	0400006f          	j	8000180c <main+0x844>
        case 0xe9f5: /* seed1=0, seed2=0, seed3=0x66, size 666 per algorithm */
            known_id = 3;
800017d0:	00300793          	li	a5,3
800017d4:	fef41423          	sh	a5,-24(s0)
            ee_printf("2K performance run parameters for coremark.\n");
800017d8:	800057b7          	lui	a5,0x80005
800017dc:	c2c78513          	addi	a0,a5,-980 # 80004c2c <__modsi3+0xd8>
800017e0:	214030ef          	jal	800049f4 <ee_printf>
            break;
800017e4:	0280006f          	j	8000180c <main+0x844>
        case 0x18f2: /*  seed1=0x3415, seed2=0x3415, seed3=0x66, size 666 per
                        algorithm */
            known_id = 4;
800017e8:	00400793          	li	a5,4
800017ec:	fef41423          	sh	a5,-24(s0)
            ee_printf("2K validation run parameters for coremark.\n");
800017f0:	800057b7          	lui	a5,0x80005
800017f4:	c5c78513          	addi	a0,a5,-932 # 80004c5c <__modsi3+0x108>
800017f8:	1fc030ef          	jal	800049f4 <ee_printf>
            break;
800017fc:	0100006f          	j	8000180c <main+0x844>
        default:
            total_errors = -1;
80001800:	fff00793          	li	a5,-1
80001804:	fef41323          	sh	a5,-26(s0)
            break;
80001808:	00000013          	nop
    }
    if (known_id >= 0)
8000180c:	fe841783          	lh	a5,-24(s0)
80001810:	3a07c463          	bltz	a5,80001bb8 <main+0xbf0>
    {
        for (i = 0; i < default_num_contexts; i++)
80001814:	fe041723          	sh	zero,-18(s0)
80001818:	3900006f          	j	80001ba8 <main+0xbe0>
        {
            results[i].err = 0;
8000181c:	fee45703          	lhu	a4,-18(s0)
80001820:	00070793          	mv	a5,a4
80001824:	00479793          	slli	a5,a5,0x4
80001828:	00e787b3          	add	a5,a5,a4
8000182c:	00279793          	slli	a5,a5,0x2
80001830:	ff078793          	addi	a5,a5,-16
80001834:	008787b3          	add	a5,a5,s0
80001838:	fc079e23          	sh	zero,-36(a5)
            if ((results[i].execs & ID_LIST)
8000183c:	fee45703          	lhu	a4,-18(s0)
80001840:	00070793          	mv	a5,a4
80001844:	00479793          	slli	a5,a5,0x4
80001848:	00e787b3          	add	a5,a5,a4
8000184c:	00279793          	slli	a5,a5,0x2
80001850:	ff078793          	addi	a5,a5,-16
80001854:	008787b3          	add	a5,a5,s0
80001858:	fbc7a783          	lw	a5,-68(a5)
8000185c:	0017f793          	andi	a5,a5,1
80001860:	0e078463          	beqz	a5,80001948 <main+0x980>
                && (results[i].crclist != list_known_crc[known_id]))
80001864:	fee45703          	lhu	a4,-18(s0)
80001868:	00070793          	mv	a5,a4
8000186c:	00479793          	slli	a5,a5,0x4
80001870:	00e787b3          	add	a5,a5,a4
80001874:	00279793          	slli	a5,a5,0x2
80001878:	ff078793          	addi	a5,a5,-16
8000187c:	008787b3          	add	a5,a5,s0
80001880:	fd67d703          	lhu	a4,-42(a5)
80001884:	fe841783          	lh	a5,-24(s0)
80001888:	800056b7          	lui	a3,0x80005
8000188c:	11868693          	addi	a3,a3,280 # 80005118 <list_known_crc>
80001890:	00179793          	slli	a5,a5,0x1
80001894:	00f687b3          	add	a5,a3,a5
80001898:	0007d783          	lhu	a5,0(a5)
8000189c:	0af70663          	beq	a4,a5,80001948 <main+0x980>
            {
                ee_printf("[%u]ERROR! list crc 0x%04x - should be 0x%04x\n",
800018a0:	fee45583          	lhu	a1,-18(s0)
                          i,
                          results[i].crclist,
800018a4:	fee45703          	lhu	a4,-18(s0)
800018a8:	00070793          	mv	a5,a4
800018ac:	00479793          	slli	a5,a5,0x4
800018b0:	00e787b3          	add	a5,a5,a4
800018b4:	00279793          	slli	a5,a5,0x2
800018b8:	ff078793          	addi	a5,a5,-16
800018bc:	008787b3          	add	a5,a5,s0
800018c0:	fd67d783          	lhu	a5,-42(a5)
                ee_printf("[%u]ERROR! list crc 0x%04x - should be 0x%04x\n",
800018c4:	00078613          	mv	a2,a5
                          list_known_crc[known_id]);
800018c8:	fe841783          	lh	a5,-24(s0)
800018cc:	80005737          	lui	a4,0x80005
800018d0:	11870713          	addi	a4,a4,280 # 80005118 <list_known_crc>
800018d4:	00179793          	slli	a5,a5,0x1
800018d8:	00f707b3          	add	a5,a4,a5
800018dc:	0007d783          	lhu	a5,0(a5)
                ee_printf("[%u]ERROR! list crc 0x%04x - should be 0x%04x\n",
800018e0:	00078693          	mv	a3,a5
800018e4:	800057b7          	lui	a5,0x80005
800018e8:	c8878513          	addi	a0,a5,-888 # 80004c88 <__modsi3+0x134>
800018ec:	108030ef          	jal	800049f4 <ee_printf>
                results[i].err++;
800018f0:	fee45703          	lhu	a4,-18(s0)
800018f4:	00070793          	mv	a5,a4
800018f8:	00479793          	slli	a5,a5,0x4
800018fc:	00e787b3          	add	a5,a5,a4
80001900:	00279793          	slli	a5,a5,0x2
80001904:	ff078793          	addi	a5,a5,-16
80001908:	008787b3          	add	a5,a5,s0
8000190c:	fdc79783          	lh	a5,-36(a5)
80001910:	01079793          	slli	a5,a5,0x10
80001914:	0107d793          	srli	a5,a5,0x10
80001918:	00178793          	addi	a5,a5,1
8000191c:	01079793          	slli	a5,a5,0x10
80001920:	0107d793          	srli	a5,a5,0x10
80001924:	01079693          	slli	a3,a5,0x10
80001928:	4106d693          	srai	a3,a3,0x10
8000192c:	00070793          	mv	a5,a4
80001930:	00479793          	slli	a5,a5,0x4
80001934:	00e787b3          	add	a5,a5,a4
80001938:	00279793          	slli	a5,a5,0x2
8000193c:	ff078793          	addi	a5,a5,-16
80001940:	008787b3          	add	a5,a5,s0
80001944:	fcd79e23          	sh	a3,-36(a5)
            }
            if ((results[i].execs & ID_MATRIX)
80001948:	fee45703          	lhu	a4,-18(s0)
8000194c:	00070793          	mv	a5,a4
80001950:	00479793          	slli	a5,a5,0x4
80001954:	00e787b3          	add	a5,a5,a4
80001958:	00279793          	slli	a5,a5,0x2
8000195c:	ff078793          	addi	a5,a5,-16
80001960:	008787b3          	add	a5,a5,s0
80001964:	fbc7a783          	lw	a5,-68(a5)
80001968:	0027f793          	andi	a5,a5,2
8000196c:	0e078463          	beqz	a5,80001a54 <main+0xa8c>
                && (results[i].crcmatrix != matrix_known_crc[known_id]))
80001970:	fee45703          	lhu	a4,-18(s0)
80001974:	00070793          	mv	a5,a4
80001978:	00479793          	slli	a5,a5,0x4
8000197c:	00e787b3          	add	a5,a5,a4
80001980:	00279793          	slli	a5,a5,0x2
80001984:	ff078793          	addi	a5,a5,-16
80001988:	008787b3          	add	a5,a5,s0
8000198c:	fd87d703          	lhu	a4,-40(a5)
80001990:	fe841783          	lh	a5,-24(s0)
80001994:	800056b7          	lui	a3,0x80005
80001998:	12468693          	addi	a3,a3,292 # 80005124 <matrix_known_crc>
8000199c:	00179793          	slli	a5,a5,0x1
800019a0:	00f687b3          	add	a5,a3,a5
800019a4:	0007d783          	lhu	a5,0(a5)
800019a8:	0af70663          	beq	a4,a5,80001a54 <main+0xa8c>
            {
                ee_printf("[%u]ERROR! matrix crc 0x%04x - should be 0x%04x\n",
800019ac:	fee45583          	lhu	a1,-18(s0)
                          i,
                          results[i].crcmatrix,
800019b0:	fee45703          	lhu	a4,-18(s0)
800019b4:	00070793          	mv	a5,a4
800019b8:	00479793          	slli	a5,a5,0x4
800019bc:	00e787b3          	add	a5,a5,a4
800019c0:	00279793          	slli	a5,a5,0x2
800019c4:	ff078793          	addi	a5,a5,-16
800019c8:	008787b3          	add	a5,a5,s0
800019cc:	fd87d783          	lhu	a5,-40(a5)
                ee_printf("[%u]ERROR! matrix crc 0x%04x - should be 0x%04x\n",
800019d0:	00078613          	mv	a2,a5
                          matrix_known_crc[known_id]);
800019d4:	fe841783          	lh	a5,-24(s0)
800019d8:	80005737          	lui	a4,0x80005
800019dc:	12470713          	addi	a4,a4,292 # 80005124 <matrix_known_crc>
800019e0:	00179793          	slli	a5,a5,0x1
800019e4:	00f707b3          	add	a5,a4,a5
800019e8:	0007d783          	lhu	a5,0(a5)
                ee_printf("[%u]ERROR! matrix crc 0x%04x - should be 0x%04x\n",
800019ec:	00078693          	mv	a3,a5
800019f0:	800057b7          	lui	a5,0x80005
800019f4:	cb878513          	addi	a0,a5,-840 # 80004cb8 <__modsi3+0x164>
800019f8:	7fd020ef          	jal	800049f4 <ee_printf>
                results[i].err++;
800019fc:	fee45703          	lhu	a4,-18(s0)
80001a00:	00070793          	mv	a5,a4
80001a04:	00479793          	slli	a5,a5,0x4
80001a08:	00e787b3          	add	a5,a5,a4
80001a0c:	00279793          	slli	a5,a5,0x2
80001a10:	ff078793          	addi	a5,a5,-16
80001a14:	008787b3          	add	a5,a5,s0
80001a18:	fdc79783          	lh	a5,-36(a5)
80001a1c:	01079793          	slli	a5,a5,0x10
80001a20:	0107d793          	srli	a5,a5,0x10
80001a24:	00178793          	addi	a5,a5,1
80001a28:	01079793          	slli	a5,a5,0x10
80001a2c:	0107d793          	srli	a5,a5,0x10
80001a30:	01079693          	slli	a3,a5,0x10
80001a34:	4106d693          	srai	a3,a3,0x10
80001a38:	00070793          	mv	a5,a4
80001a3c:	00479793          	slli	a5,a5,0x4
80001a40:	00e787b3          	add	a5,a5,a4
80001a44:	00279793          	slli	a5,a5,0x2
80001a48:	ff078793          	addi	a5,a5,-16
80001a4c:	008787b3          	add	a5,a5,s0
80001a50:	fcd79e23          	sh	a3,-36(a5)
            }
            if ((results[i].execs & ID_STATE)
80001a54:	fee45703          	lhu	a4,-18(s0)
80001a58:	00070793          	mv	a5,a4
80001a5c:	00479793          	slli	a5,a5,0x4
80001a60:	00e787b3          	add	a5,a5,a4
80001a64:	00279793          	slli	a5,a5,0x2
80001a68:	ff078793          	addi	a5,a5,-16
80001a6c:	008787b3          	add	a5,a5,s0
80001a70:	fbc7a783          	lw	a5,-68(a5)
80001a74:	0047f793          	andi	a5,a5,4
80001a78:	0e078463          	beqz	a5,80001b60 <main+0xb98>
                && (results[i].crcstate != state_known_crc[known_id]))
80001a7c:	fee45703          	lhu	a4,-18(s0)
80001a80:	00070793          	mv	a5,a4
80001a84:	00479793          	slli	a5,a5,0x4
80001a88:	00e787b3          	add	a5,a5,a4
80001a8c:	00279793          	slli	a5,a5,0x2
80001a90:	ff078793          	addi	a5,a5,-16
80001a94:	008787b3          	add	a5,a5,s0
80001a98:	fda7d703          	lhu	a4,-38(a5)
80001a9c:	fe841783          	lh	a5,-24(s0)
80001aa0:	800056b7          	lui	a3,0x80005
80001aa4:	13068693          	addi	a3,a3,304 # 80005130 <state_known_crc>
80001aa8:	00179793          	slli	a5,a5,0x1
80001aac:	00f687b3          	add	a5,a3,a5
80001ab0:	0007d783          	lhu	a5,0(a5)
80001ab4:	0af70663          	beq	a4,a5,80001b60 <main+0xb98>
            {
                ee_printf("[%u]ERROR! state crc 0x%04x - should be 0x%04x\n",
80001ab8:	fee45583          	lhu	a1,-18(s0)
                          i,
                          results[i].crcstate,
80001abc:	fee45703          	lhu	a4,-18(s0)
80001ac0:	00070793          	mv	a5,a4
80001ac4:	00479793          	slli	a5,a5,0x4
80001ac8:	00e787b3          	add	a5,a5,a4
80001acc:	00279793          	slli	a5,a5,0x2
80001ad0:	ff078793          	addi	a5,a5,-16
80001ad4:	008787b3          	add	a5,a5,s0
80001ad8:	fda7d783          	lhu	a5,-38(a5)
                ee_printf("[%u]ERROR! state crc 0x%04x - should be 0x%04x\n",
80001adc:	00078613          	mv	a2,a5
                          state_known_crc[known_id]);
80001ae0:	fe841783          	lh	a5,-24(s0)
80001ae4:	80005737          	lui	a4,0x80005
80001ae8:	13070713          	addi	a4,a4,304 # 80005130 <state_known_crc>
80001aec:	00179793          	slli	a5,a5,0x1
80001af0:	00f707b3          	add	a5,a4,a5
80001af4:	0007d783          	lhu	a5,0(a5)
                ee_printf("[%u]ERROR! state crc 0x%04x - should be 0x%04x\n",
80001af8:	00078693          	mv	a3,a5
80001afc:	800057b7          	lui	a5,0x80005
80001b00:	cec78513          	addi	a0,a5,-788 # 80004cec <__modsi3+0x198>
80001b04:	6f1020ef          	jal	800049f4 <ee_printf>
                results[i].err++;
80001b08:	fee45703          	lhu	a4,-18(s0)
80001b0c:	00070793          	mv	a5,a4
80001b10:	00479793          	slli	a5,a5,0x4
80001b14:	00e787b3          	add	a5,a5,a4
80001b18:	00279793          	slli	a5,a5,0x2
80001b1c:	ff078793          	addi	a5,a5,-16
80001b20:	008787b3          	add	a5,a5,s0
80001b24:	fdc79783          	lh	a5,-36(a5)
80001b28:	01079793          	slli	a5,a5,0x10
80001b2c:	0107d793          	srli	a5,a5,0x10
80001b30:	00178793          	addi	a5,a5,1
80001b34:	01079793          	slli	a5,a5,0x10
80001b38:	0107d793          	srli	a5,a5,0x10
80001b3c:	01079693          	slli	a3,a5,0x10
80001b40:	4106d693          	srai	a3,a3,0x10
80001b44:	00070793          	mv	a5,a4
80001b48:	00479793          	slli	a5,a5,0x4
80001b4c:	00e787b3          	add	a5,a5,a4
80001b50:	00279793          	slli	a5,a5,0x2
80001b54:	ff078793          	addi	a5,a5,-16
80001b58:	008787b3          	add	a5,a5,s0
80001b5c:	fcd79e23          	sh	a3,-36(a5)
            }
            total_errors += results[i].err;
80001b60:	fee45703          	lhu	a4,-18(s0)
80001b64:	00070793          	mv	a5,a4
80001b68:	00479793          	slli	a5,a5,0x4
80001b6c:	00e787b3          	add	a5,a5,a4
80001b70:	00279793          	slli	a5,a5,0x2
80001b74:	ff078793          	addi	a5,a5,-16
80001b78:	008787b3          	add	a5,a5,s0
80001b7c:	fdc79783          	lh	a5,-36(a5)
80001b80:	01079713          	slli	a4,a5,0x10
80001b84:	01075713          	srli	a4,a4,0x10
80001b88:	fe645783          	lhu	a5,-26(s0)
80001b8c:	00f707b3          	add	a5,a4,a5
80001b90:	01079793          	slli	a5,a5,0x10
80001b94:	0107d793          	srli	a5,a5,0x10
80001b98:	fef41323          	sh	a5,-26(s0)
        for (i = 0; i < default_num_contexts; i++)
80001b9c:	fee45783          	lhu	a5,-18(s0)
80001ba0:	00178793          	addi	a5,a5,1
80001ba4:	fef41723          	sh	a5,-18(s0)
80001ba8:	fee45703          	lhu	a4,-18(s0)
80001bac:	800057b7          	lui	a5,0x80005
80001bb0:	1987a783          	lw	a5,408(a5) # 80005198 <default_num_contexts>
80001bb4:	c6f764e3          	bltu	a4,a5,8000181c <main+0x854>
        }
    }
    total_errors += check_data_types();
80001bb8:	4c1010ef          	jal	80003878 <check_data_types>
80001bbc:	00050793          	mv	a5,a0
80001bc0:	00078713          	mv	a4,a5
80001bc4:	fe645783          	lhu	a5,-26(s0)
80001bc8:	00f707b3          	add	a5,a4,a5
80001bcc:	01079793          	slli	a5,a5,0x10
80001bd0:	0107d793          	srli	a5,a5,0x10
80001bd4:	fef41323          	sh	a5,-26(s0)
    /* and report results */
    ee_printf("CoreMark Size    : %lu\n", (long unsigned)results[0].size);
80001bd8:	fa442783          	lw	a5,-92(s0)
80001bdc:	00078593          	mv	a1,a5
80001be0:	800057b7          	lui	a5,0x80005
80001be4:	d1c78513          	addi	a0,a5,-740 # 80004d1c <__modsi3+0x1c8>
80001be8:	60d020ef          	jal	800049f4 <ee_printf>
    ee_printf("Total ticks      : %lu\n", (long unsigned)total_time);
80001bec:	fd042583          	lw	a1,-48(s0)
80001bf0:	800057b7          	lui	a5,0x80005
80001bf4:	d3478513          	addi	a0,a5,-716 # 80004d34 <__modsi3+0x1e0>
80001bf8:	5fd020ef          	jal	800049f4 <ee_printf>
    if (time_in_secs(total_time) > 0)
        ee_printf("Iterations/Sec   : %f\n",
                  default_num_contexts * results[0].iterations
                      / time_in_secs(total_time));
#else
    ee_printf("Total time (secs): %d\n", time_in_secs(total_time));
80001bfc:	fd042503          	lw	a0,-48(s0)
80001c00:	571010ef          	jal	80003970 <time_in_secs>
80001c04:	00050793          	mv	a5,a0
80001c08:	00078593          	mv	a1,a5
80001c0c:	800057b7          	lui	a5,0x80005
80001c10:	d4c78513          	addi	a0,a5,-692 # 80004d4c <__modsi3+0x1f8>
80001c14:	5e1020ef          	jal	800049f4 <ee_printf>
    if (time_in_secs(total_time) > 0)
80001c18:	fd042503          	lw	a0,-48(s0)
80001c1c:	555010ef          	jal	80003970 <time_in_secs>
80001c20:	00050793          	mv	a5,a0
80001c24:	04078863          	beqz	a5,80001c74 <main+0xcac>
        ee_printf("Iterations/Sec   : %d\n",
                  default_num_contexts * results[0].iterations
80001c28:	fa842703          	lw	a4,-88(s0)
80001c2c:	800057b7          	lui	a5,0x80005
80001c30:	1987a783          	lw	a5,408(a5) # 80005198 <default_num_contexts>
80001c34:	00078593          	mv	a1,a5
80001c38:	00070513          	mv	a0,a4
80001c3c:	671020ef          	jal	80004aac <__mulsi3>
80001c40:	00050793          	mv	a5,a0
80001c44:	00078493          	mv	s1,a5
                      / time_in_secs(total_time));
80001c48:	fd042503          	lw	a0,-48(s0)
80001c4c:	525010ef          	jal	80003970 <time_in_secs>
80001c50:	00050793          	mv	a5,a0
        ee_printf("Iterations/Sec   : %d\n",
80001c54:	00078593          	mv	a1,a5
80001c58:	00048513          	mv	a0,s1
80001c5c:	67d020ef          	jal	80004ad8 <__hidden___udivsi3>
80001c60:	00050793          	mv	a5,a0
80001c64:	00078593          	mv	a1,a5
80001c68:	800057b7          	lui	a5,0x80005
80001c6c:	d6478513          	addi	a0,a5,-668 # 80004d64 <__modsi3+0x210>
80001c70:	585020ef          	jal	800049f4 <ee_printf>
#endif
    if (time_in_secs(total_time) < 10)
80001c74:	fd042503          	lw	a0,-48(s0)
80001c78:	4f9010ef          	jal	80003970 <time_in_secs>
80001c7c:	00050713          	mv	a4,a0
80001c80:	00900793          	li	a5,9
80001c84:	02e7e663          	bltu	a5,a4,80001cb0 <main+0xce8>
    {
        ee_printf(
80001c88:	800057b7          	lui	a5,0x80005
80001c8c:	d7c78513          	addi	a0,a5,-644 # 80004d7c <__modsi3+0x228>
80001c90:	565020ef          	jal	800049f4 <ee_printf>
            "ERROR! Must execute for at least 10 secs for a valid result!\n");
        total_errors++;
80001c94:	fe641783          	lh	a5,-26(s0)
80001c98:	01079793          	slli	a5,a5,0x10
80001c9c:	0107d793          	srli	a5,a5,0x10
80001ca0:	00178793          	addi	a5,a5,1
80001ca4:	01079793          	slli	a5,a5,0x10
80001ca8:	0107d793          	srli	a5,a5,0x10
80001cac:	fef41323          	sh	a5,-26(s0)
    }

    ee_printf("Iterations       : %lu\n",
              (long unsigned)default_num_contexts * results[0].iterations);
80001cb0:	fa842703          	lw	a4,-88(s0)
80001cb4:	800057b7          	lui	a5,0x80005
80001cb8:	1987a783          	lw	a5,408(a5) # 80005198 <default_num_contexts>
    ee_printf("Iterations       : %lu\n",
80001cbc:	00078593          	mv	a1,a5
80001cc0:	00070513          	mv	a0,a4
80001cc4:	5e9020ef          	jal	80004aac <__mulsi3>
80001cc8:	00050793          	mv	a5,a0
80001ccc:	00078593          	mv	a1,a5
80001cd0:	800057b7          	lui	a5,0x80005
80001cd4:	dbc78513          	addi	a0,a5,-580 # 80004dbc <__modsi3+0x268>
80001cd8:	51d020ef          	jal	800049f4 <ee_printf>
    ee_printf("Compiler version : %s\n", COMPILER_VERSION);
80001cdc:	800057b7          	lui	a5,0x80005
80001ce0:	dd478593          	addi	a1,a5,-556 # 80004dd4 <__modsi3+0x280>
80001ce4:	800057b7          	lui	a5,0x80005
80001ce8:	de078513          	addi	a0,a5,-544 # 80004de0 <__modsi3+0x28c>
80001cec:	509020ef          	jal	800049f4 <ee_printf>
    ee_printf("Compiler flags   : %s\n", COMPILER_FLAGS);
80001cf0:	800057b7          	lui	a5,0x80005
80001cf4:	df878593          	addi	a1,a5,-520 # 80004df8 <__modsi3+0x2a4>
80001cf8:	800057b7          	lui	a5,0x80005
80001cfc:	e5078513          	addi	a0,a5,-432 # 80004e50 <__modsi3+0x2fc>
80001d00:	4f5020ef          	jal	800049f4 <ee_printf>
#if (MULTITHREAD > 1)
    ee_printf("Parallel %s : %d\n", PARALLEL_METHOD, default_num_contexts);
#endif
    ee_printf("Memory location  : %s\n", MEM_LOCATION);
80001d04:	800057b7          	lui	a5,0x80005
80001d08:	e6878593          	addi	a1,a5,-408 # 80004e68 <__modsi3+0x314>
80001d0c:	800057b7          	lui	a5,0x80005
80001d10:	e7078513          	addi	a0,a5,-400 # 80004e70 <__modsi3+0x31c>
80001d14:	4e1020ef          	jal	800049f4 <ee_printf>
    /* output for verification */
    ee_printf("seedcrc          : 0x%04x\n", seedcrc);
80001d18:	fd645783          	lhu	a5,-42(s0)
80001d1c:	00078593          	mv	a1,a5
80001d20:	800057b7          	lui	a5,0x80005
80001d24:	e8878513          	addi	a0,a5,-376 # 80004e88 <__modsi3+0x334>
80001d28:	4cd020ef          	jal	800049f4 <ee_printf>
    if (results[0].execs & ID_LIST)
80001d2c:	fac42783          	lw	a5,-84(s0)
80001d30:	0017f793          	andi	a5,a5,1
80001d34:	06078063          	beqz	a5,80001d94 <main+0xdcc>
        for (i = 0; i < default_num_contexts; i++)
80001d38:	fe041723          	sh	zero,-18(s0)
80001d3c:	0480006f          	j	80001d84 <main+0xdbc>
            ee_printf("[%d]crclist       : 0x%04x\n", i, results[i].crclist);
80001d40:	fee45683          	lhu	a3,-18(s0)
80001d44:	fee45703          	lhu	a4,-18(s0)
80001d48:	00070793          	mv	a5,a4
80001d4c:	00479793          	slli	a5,a5,0x4
80001d50:	00e787b3          	add	a5,a5,a4
80001d54:	00279793          	slli	a5,a5,0x2
80001d58:	ff078793          	addi	a5,a5,-16
80001d5c:	008787b3          	add	a5,a5,s0
80001d60:	fd67d783          	lhu	a5,-42(a5)
80001d64:	00078613          	mv	a2,a5
80001d68:	00068593          	mv	a1,a3
80001d6c:	800057b7          	lui	a5,0x80005
80001d70:	ea478513          	addi	a0,a5,-348 # 80004ea4 <__modsi3+0x350>
80001d74:	481020ef          	jal	800049f4 <ee_printf>
        for (i = 0; i < default_num_contexts; i++)
80001d78:	fee45783          	lhu	a5,-18(s0)
80001d7c:	00178793          	addi	a5,a5,1
80001d80:	fef41723          	sh	a5,-18(s0)
80001d84:	fee45703          	lhu	a4,-18(s0)
80001d88:	800057b7          	lui	a5,0x80005
80001d8c:	1987a783          	lw	a5,408(a5) # 80005198 <default_num_contexts>
80001d90:	faf768e3          	bltu	a4,a5,80001d40 <main+0xd78>
    if (results[0].execs & ID_MATRIX)
80001d94:	fac42783          	lw	a5,-84(s0)
80001d98:	0027f793          	andi	a5,a5,2
80001d9c:	06078063          	beqz	a5,80001dfc <main+0xe34>
        for (i = 0; i < default_num_contexts; i++)
80001da0:	fe041723          	sh	zero,-18(s0)
80001da4:	0480006f          	j	80001dec <main+0xe24>
            ee_printf("[%d]crcmatrix     : 0x%04x\n", i, results[i].crcmatrix);
80001da8:	fee45683          	lhu	a3,-18(s0)
80001dac:	fee45703          	lhu	a4,-18(s0)
80001db0:	00070793          	mv	a5,a4
80001db4:	00479793          	slli	a5,a5,0x4
80001db8:	00e787b3          	add	a5,a5,a4
80001dbc:	00279793          	slli	a5,a5,0x2
80001dc0:	ff078793          	addi	a5,a5,-16
80001dc4:	008787b3          	add	a5,a5,s0
80001dc8:	fd87d783          	lhu	a5,-40(a5)
80001dcc:	00078613          	mv	a2,a5
80001dd0:	00068593          	mv	a1,a3
80001dd4:	800057b7          	lui	a5,0x80005
80001dd8:	ec078513          	addi	a0,a5,-320 # 80004ec0 <__modsi3+0x36c>
80001ddc:	419020ef          	jal	800049f4 <ee_printf>
        for (i = 0; i < default_num_contexts; i++)
80001de0:	fee45783          	lhu	a5,-18(s0)
80001de4:	00178793          	addi	a5,a5,1
80001de8:	fef41723          	sh	a5,-18(s0)
80001dec:	fee45703          	lhu	a4,-18(s0)
80001df0:	800057b7          	lui	a5,0x80005
80001df4:	1987a783          	lw	a5,408(a5) # 80005198 <default_num_contexts>
80001df8:	faf768e3          	bltu	a4,a5,80001da8 <main+0xde0>
    if (results[0].execs & ID_STATE)
80001dfc:	fac42783          	lw	a5,-84(s0)
80001e00:	0047f793          	andi	a5,a5,4
80001e04:	06078063          	beqz	a5,80001e64 <main+0xe9c>
        for (i = 0; i < default_num_contexts; i++)
80001e08:	fe041723          	sh	zero,-18(s0)
80001e0c:	0480006f          	j	80001e54 <main+0xe8c>
            ee_printf("[%d]crcstate      : 0x%04x\n", i, results[i].crcstate);
80001e10:	fee45683          	lhu	a3,-18(s0)
80001e14:	fee45703          	lhu	a4,-18(s0)
80001e18:	00070793          	mv	a5,a4
80001e1c:	00479793          	slli	a5,a5,0x4
80001e20:	00e787b3          	add	a5,a5,a4
80001e24:	00279793          	slli	a5,a5,0x2
80001e28:	ff078793          	addi	a5,a5,-16
80001e2c:	008787b3          	add	a5,a5,s0
80001e30:	fda7d783          	lhu	a5,-38(a5)
80001e34:	00078613          	mv	a2,a5
80001e38:	00068593          	mv	a1,a3
80001e3c:	800057b7          	lui	a5,0x80005
80001e40:	edc78513          	addi	a0,a5,-292 # 80004edc <__modsi3+0x388>
80001e44:	3b1020ef          	jal	800049f4 <ee_printf>
        for (i = 0; i < default_num_contexts; i++)
80001e48:	fee45783          	lhu	a5,-18(s0)
80001e4c:	00178793          	addi	a5,a5,1
80001e50:	fef41723          	sh	a5,-18(s0)
80001e54:	fee45703          	lhu	a4,-18(s0)
80001e58:	800057b7          	lui	a5,0x80005
80001e5c:	1987a783          	lw	a5,408(a5) # 80005198 <default_num_contexts>
80001e60:	faf768e3          	bltu	a4,a5,80001e10 <main+0xe48>
    for (i = 0; i < default_num_contexts; i++)
80001e64:	fe041723          	sh	zero,-18(s0)
80001e68:	0480006f          	j	80001eb0 <main+0xee8>
        ee_printf("[%d]crcfinal      : 0x%04x\n", i, results[i].crc);
80001e6c:	fee45683          	lhu	a3,-18(s0)
80001e70:	fee45703          	lhu	a4,-18(s0)
80001e74:	00070793          	mv	a5,a4
80001e78:	00479793          	slli	a5,a5,0x4
80001e7c:	00e787b3          	add	a5,a5,a4
80001e80:	00279793          	slli	a5,a5,0x2
80001e84:	ff078793          	addi	a5,a5,-16
80001e88:	008787b3          	add	a5,a5,s0
80001e8c:	fd47d783          	lhu	a5,-44(a5)
80001e90:	00078613          	mv	a2,a5
80001e94:	00068593          	mv	a1,a3
80001e98:	800057b7          	lui	a5,0x80005
80001e9c:	ef878513          	addi	a0,a5,-264 # 80004ef8 <__modsi3+0x3a4>
80001ea0:	355020ef          	jal	800049f4 <ee_printf>
    for (i = 0; i < default_num_contexts; i++)
80001ea4:	fee45783          	lhu	a5,-18(s0)
80001ea8:	00178793          	addi	a5,a5,1
80001eac:	fef41723          	sh	a5,-18(s0)
80001eb0:	fee45703          	lhu	a4,-18(s0)
80001eb4:	800057b7          	lui	a5,0x80005
80001eb8:	1987a783          	lw	a5,408(a5) # 80005198 <default_num_contexts>
80001ebc:	faf768e3          	bltu	a4,a5,80001e6c <main+0xea4>
    if (total_errors == 0)
80001ec0:	fe641783          	lh	a5,-26(s0)
80001ec4:	00079863          	bnez	a5,80001ed4 <main+0xf0c>
    {
        ee_printf(
80001ec8:	800057b7          	lui	a5,0x80005
80001ecc:	f1478513          	addi	a0,a5,-236 # 80004f14 <__modsi3+0x3c0>
80001ed0:	325020ef          	jal	800049f4 <ee_printf>
#endif
            ee_printf("\n");
        }
#endif
    }
    if (total_errors > 0)
80001ed4:	fe641783          	lh	a5,-26(s0)
80001ed8:	00f05863          	blez	a5,80001ee8 <main+0xf20>
        ee_printf("Errors detected\n");
80001edc:	800057b7          	lui	a5,0x80005
80001ee0:	f6078513          	addi	a0,a5,-160 # 80004f60 <__modsi3+0x40c>
80001ee4:	311020ef          	jal	800049f4 <ee_printf>
    if (total_errors < 0)
80001ee8:	fe641783          	lh	a5,-26(s0)
80001eec:	0007d863          	bgez	a5,80001efc <main+0xf34>
        ee_printf(
80001ef0:	800057b7          	lui	a5,0x80005
80001ef4:	f7478513          	addi	a0,a5,-140 # 80004f74 <__modsi3+0x420>
80001ef8:	2fd020ef          	jal	800049f4 <ee_printf>
#if (MEM_METHOD == MEM_MALLOC)
    for (i = 0; i < MULTITHREAD; i++)
        portable_free(results[i].memblock[0]);
#endif
    /* And last call any target specific code for finalizing */
    portable_fini(&(results[0].port));
80001efc:	f8c40793          	addi	a5,s0,-116
80001f00:	04278793          	addi	a5,a5,66
80001f04:	00078513          	mv	a0,a5
80001f08:	2c5010ef          	jal	800039cc <portable_fini>

    return MAIN_RETURN_VAL;
80001f0c:	00000793          	li	a5,0
}
80001f10:	00078513          	mv	a0,a5
80001f14:	07010113          	addi	sp,sp,112
80001f18:	7ec12083          	lw	ra,2028(sp)
80001f1c:	7e812403          	lw	s0,2024(sp)
80001f20:	7e412483          	lw	s1,2020(sp)
80001f24:	7f010113          	addi	sp,sp,2032
80001f28:	00008067          	ret

80001f2c <core_bench_matrix>:
        Iterate <matrix_test> N times,
        changing the matrix values slightly by a constant amount each time.
*/
ee_u16
core_bench_matrix(mat_params *p, ee_s16 seed, ee_u16 crc)
{
80001f2c:	fc010113          	addi	sp,sp,-64
80001f30:	02112e23          	sw	ra,60(sp)
80001f34:	02812c23          	sw	s0,56(sp)
80001f38:	04010413          	addi	s0,sp,64
80001f3c:	fca42623          	sw	a0,-52(s0)
80001f40:	00058793          	mv	a5,a1
80001f44:	00060713          	mv	a4,a2
80001f48:	fcf41523          	sh	a5,-54(s0)
80001f4c:	00070793          	mv	a5,a4
80001f50:	fcf41423          	sh	a5,-56(s0)
    ee_u32  N   = p->N;
80001f54:	fcc42783          	lw	a5,-52(s0)
80001f58:	0007a783          	lw	a5,0(a5)
80001f5c:	fef42623          	sw	a5,-20(s0)
    MATRES *C   = p->C;
80001f60:	fcc42783          	lw	a5,-52(s0)
80001f64:	00c7a783          	lw	a5,12(a5)
80001f68:	fef42423          	sw	a5,-24(s0)
    MATDAT *A   = p->A;
80001f6c:	fcc42783          	lw	a5,-52(s0)
80001f70:	0047a783          	lw	a5,4(a5)
80001f74:	fef42223          	sw	a5,-28(s0)
    MATDAT *B   = p->B;
80001f78:	fcc42783          	lw	a5,-52(s0)
80001f7c:	0087a783          	lw	a5,8(a5)
80001f80:	fef42023          	sw	a5,-32(s0)
    MATDAT  val = (MATDAT)seed;
80001f84:	fca45783          	lhu	a5,-54(s0)
80001f88:	fcf41f23          	sh	a5,-34(s0)

    crc = crc16(matrix_test(N, C, A, B, val), crc);
80001f8c:	fde41783          	lh	a5,-34(s0)
80001f90:	00078713          	mv	a4,a5
80001f94:	fe042683          	lw	a3,-32(s0)
80001f98:	fe442603          	lw	a2,-28(s0)
80001f9c:	fe842583          	lw	a1,-24(s0)
80001fa0:	fec42503          	lw	a0,-20(s0)
80001fa4:	03c000ef          	jal	80001fe0 <matrix_test>
80001fa8:	00050793          	mv	a5,a0
80001fac:	00078713          	mv	a4,a5
80001fb0:	fc845783          	lhu	a5,-56(s0)
80001fb4:	00078593          	mv	a1,a5
80001fb8:	00070513          	mv	a0,a4
80001fbc:	06d010ef          	jal	80003828 <crc16>
80001fc0:	00050793          	mv	a5,a0
80001fc4:	fcf41423          	sh	a5,-56(s0)

    return crc;
80001fc8:	fc845783          	lhu	a5,-56(s0)
}
80001fcc:	00078513          	mv	a0,a5
80001fd0:	03c12083          	lw	ra,60(sp)
80001fd4:	03812403          	lw	s0,56(sp)
80001fd8:	04010113          	addi	sp,sp,64
80001fdc:	00008067          	ret

80001fe0 <matrix_test>:

        After the last step, matrix A is back to original contents.
*/
ee_s16
matrix_test(ee_u32 N, MATRES *C, MATDAT *A, MATDAT *B, MATDAT val)
{
80001fe0:	fc010113          	addi	sp,sp,-64
80001fe4:	02112e23          	sw	ra,60(sp)
80001fe8:	02812c23          	sw	s0,56(sp)
80001fec:	04010413          	addi	s0,sp,64
80001ff0:	fca42e23          	sw	a0,-36(s0)
80001ff4:	fcb42c23          	sw	a1,-40(s0)
80001ff8:	fcc42a23          	sw	a2,-44(s0)
80001ffc:	fcd42823          	sw	a3,-48(s0)
80002000:	00070793          	mv	a5,a4
80002004:	fcf41723          	sh	a5,-50(s0)
    ee_u16 crc     = 0;
80002008:	fe041723          	sh	zero,-18(s0)
    MATDAT clipval = matrix_big(val);
8000200c:	fce45783          	lhu	a5,-50(s0)
80002010:	00078713          	mv	a4,a5
80002014:	fffff7b7          	lui	a5,0xfffff
80002018:	00f767b3          	or	a5,a4,a5
8000201c:	fef41623          	sh	a5,-20(s0)

    matrix_add_const(N, A, val); /* make sure data changes  */
80002020:	fce41783          	lh	a5,-50(s0)
80002024:	00078613          	mv	a2,a5
80002028:	fd442583          	lw	a1,-44(s0)
8000202c:	fdc42503          	lw	a0,-36(s0)
80002030:	5e4000ef          	jal	80002614 <matrix_add_const>
#if CORE_DEBUG
    printmat(A, N, "matrix_add_const");
#endif
    matrix_mul_const(N, C, A, val);
80002034:	fce41783          	lh	a5,-50(s0)
80002038:	00078693          	mv	a3,a5
8000203c:	fd442603          	lw	a2,-44(s0)
80002040:	fd842583          	lw	a1,-40(s0)
80002044:	fdc42503          	lw	a0,-36(s0)
80002048:	4c8000ef          	jal	80002510 <matrix_mul_const>
    crc = crc16(matrix_sum(N, C, clipval), crc);
8000204c:	fec41783          	lh	a5,-20(s0)
80002050:	00078613          	mv	a2,a5
80002054:	fd842583          	lw	a1,-40(s0)
80002058:	fdc42503          	lw	a0,-36(s0)
8000205c:	394000ef          	jal	800023f0 <matrix_sum>
80002060:	00050793          	mv	a5,a0
80002064:	00078713          	mv	a4,a5
80002068:	fee45783          	lhu	a5,-18(s0)
8000206c:	00078593          	mv	a1,a5
80002070:	00070513          	mv	a0,a4
80002074:	7b4010ef          	jal	80003828 <crc16>
80002078:	00050793          	mv	a5,a0
8000207c:	fef41723          	sh	a5,-18(s0)
#if CORE_DEBUG
    printmatC(C, N, "matrix_mul_const");
#endif
    matrix_mul_vect(N, C, A, B);
80002080:	fd042683          	lw	a3,-48(s0)
80002084:	fd442603          	lw	a2,-44(s0)
80002088:	fd842583          	lw	a1,-40(s0)
8000208c:	fdc42503          	lw	a0,-36(s0)
80002090:	67c000ef          	jal	8000270c <matrix_mul_vect>
    crc = crc16(matrix_sum(N, C, clipval), crc);
80002094:	fec41783          	lh	a5,-20(s0)
80002098:	00078613          	mv	a2,a5
8000209c:	fd842583          	lw	a1,-40(s0)
800020a0:	fdc42503          	lw	a0,-36(s0)
800020a4:	34c000ef          	jal	800023f0 <matrix_sum>
800020a8:	00050793          	mv	a5,a0
800020ac:	00078713          	mv	a4,a5
800020b0:	fee45783          	lhu	a5,-18(s0)
800020b4:	00078593          	mv	a1,a5
800020b8:	00070513          	mv	a0,a4
800020bc:	76c010ef          	jal	80003828 <crc16>
800020c0:	00050793          	mv	a5,a0
800020c4:	fef41723          	sh	a5,-18(s0)
#if CORE_DEBUG
    printmatC(C, N, "matrix_mul_vect");
#endif
    matrix_mul_matrix(N, C, A, B);
800020c8:	fd042683          	lw	a3,-48(s0)
800020cc:	fd442603          	lw	a2,-44(s0)
800020d0:	fd842583          	lw	a1,-40(s0)
800020d4:	fdc42503          	lw	a0,-36(s0)
800020d8:	74c000ef          	jal	80002824 <matrix_mul_matrix>
    crc = crc16(matrix_sum(N, C, clipval), crc);
800020dc:	fec41783          	lh	a5,-20(s0)
800020e0:	00078613          	mv	a2,a5
800020e4:	fd842583          	lw	a1,-40(s0)
800020e8:	fdc42503          	lw	a0,-36(s0)
800020ec:	304000ef          	jal	800023f0 <matrix_sum>
800020f0:	00050793          	mv	a5,a0
800020f4:	00078713          	mv	a4,a5
800020f8:	fee45783          	lhu	a5,-18(s0)
800020fc:	00078593          	mv	a1,a5
80002100:	00070513          	mv	a0,a4
80002104:	724010ef          	jal	80003828 <crc16>
80002108:	00050793          	mv	a5,a0
8000210c:	fef41723          	sh	a5,-18(s0)
#if CORE_DEBUG
    printmatC(C, N, "matrix_mul_matrix");
#endif
    matrix_mul_matrix_bitextract(N, C, A, B);
80002110:	fd042683          	lw	a3,-48(s0)
80002114:	fd442603          	lw	a2,-44(s0)
80002118:	fd842583          	lw	a1,-40(s0)
8000211c:	fdc42503          	lw	a0,-36(s0)
80002120:	0a5000ef          	jal	800029c4 <matrix_mul_matrix_bitextract>
    crc = crc16(matrix_sum(N, C, clipval), crc);
80002124:	fec41783          	lh	a5,-20(s0)
80002128:	00078613          	mv	a2,a5
8000212c:	fd842583          	lw	a1,-40(s0)
80002130:	fdc42503          	lw	a0,-36(s0)
80002134:	2bc000ef          	jal	800023f0 <matrix_sum>
80002138:	00050793          	mv	a5,a0
8000213c:	00078713          	mv	a4,a5
80002140:	fee45783          	lhu	a5,-18(s0)
80002144:	00078593          	mv	a1,a5
80002148:	00070513          	mv	a0,a4
8000214c:	6dc010ef          	jal	80003828 <crc16>
80002150:	00050793          	mv	a5,a0
80002154:	fef41723          	sh	a5,-18(s0)
#if CORE_DEBUG
    printmatC(C, N, "matrix_mul_matrix_bitextract");
#endif

    matrix_add_const(N, A, -val); /* return matrix to initial value */
80002158:	fce45783          	lhu	a5,-50(s0)
8000215c:	40f007b3          	neg	a5,a5
80002160:	01079793          	slli	a5,a5,0x10
80002164:	0107d793          	srli	a5,a5,0x10
80002168:	01079793          	slli	a5,a5,0x10
8000216c:	4107d793          	srai	a5,a5,0x10
80002170:	00078613          	mv	a2,a5
80002174:	fd442583          	lw	a1,-44(s0)
80002178:	fdc42503          	lw	a0,-36(s0)
8000217c:	498000ef          	jal	80002614 <matrix_add_const>
    return crc;
80002180:	fee41783          	lh	a5,-18(s0)
}
80002184:	00078513          	mv	a0,a5
80002188:	03c12083          	lw	ra,60(sp)
8000218c:	03812403          	lw	s0,56(sp)
80002190:	04010113          	addi	sp,sp,64
80002194:	00008067          	ret

80002198 <core_init_matrix>:
        The seed parameter MUST be supplied from a source that cannot be
   determined at compile time
*/
ee_u32
core_init_matrix(ee_u32 blksize, void *memblk, ee_s32 seed, mat_params *p)
{
80002198:	fc010113          	addi	sp,sp,-64
8000219c:	02112e23          	sw	ra,60(sp)
800021a0:	02812c23          	sw	s0,56(sp)
800021a4:	04010413          	addi	s0,sp,64
800021a8:	fca42623          	sw	a0,-52(s0)
800021ac:	fcb42423          	sw	a1,-56(s0)
800021b0:	fcc42223          	sw	a2,-60(s0)
800021b4:	fcd42023          	sw	a3,-64(s0)
    ee_u32  N = 0;
800021b8:	fe042023          	sw	zero,-32(s0)
    MATDAT *A;
    MATDAT *B;
    ee_s32  order = 1;
800021bc:	00100793          	li	a5,1
800021c0:	fef42623          	sw	a5,-20(s0)
    MATDAT  val;
    ee_u32  i = 0, j = 0;
800021c4:	fe042423          	sw	zero,-24(s0)
800021c8:	fe042223          	sw	zero,-28(s0)
    if (seed == 0)
800021cc:	fc442783          	lw	a5,-60(s0)
800021d0:	02079a63          	bnez	a5,80002204 <core_init_matrix+0x6c>
        seed = 1;
800021d4:	00100793          	li	a5,1
800021d8:	fcf42223          	sw	a5,-60(s0)
    while (j < blksize)
800021dc:	0280006f          	j	80002204 <core_init_matrix+0x6c>
    {
        i++;
800021e0:	fe842783          	lw	a5,-24(s0)
800021e4:	00178793          	addi	a5,a5,1 # fffff001 <_estack+0x7feff001>
800021e8:	fef42423          	sw	a5,-24(s0)
        j = i * i * 2 * 4;
800021ec:	fe842583          	lw	a1,-24(s0)
800021f0:	fe842503          	lw	a0,-24(s0)
800021f4:	0b9020ef          	jal	80004aac <__mulsi3>
800021f8:	00050793          	mv	a5,a0
800021fc:	00379793          	slli	a5,a5,0x3
80002200:	fef42223          	sw	a5,-28(s0)
    while (j < blksize)
80002204:	fe442703          	lw	a4,-28(s0)
80002208:	fcc42783          	lw	a5,-52(s0)
8000220c:	fcf76ae3          	bltu	a4,a5,800021e0 <core_init_matrix+0x48>
    }
    N = i - 1;
80002210:	fe842783          	lw	a5,-24(s0)
80002214:	fff78793          	addi	a5,a5,-1
80002218:	fef42023          	sw	a5,-32(s0)
    A = (MATDAT *)align_mem(memblk);
8000221c:	fc842783          	lw	a5,-56(s0)
80002220:	fff78793          	addi	a5,a5,-1
80002224:	ffc7f793          	andi	a5,a5,-4
80002228:	00478793          	addi	a5,a5,4
8000222c:	fcf42e23          	sw	a5,-36(s0)
    B = A + N * N;
80002230:	fe042583          	lw	a1,-32(s0)
80002234:	fe042503          	lw	a0,-32(s0)
80002238:	075020ef          	jal	80004aac <__mulsi3>
8000223c:	00050793          	mv	a5,a0
80002240:	00179793          	slli	a5,a5,0x1
80002244:	fdc42703          	lw	a4,-36(s0)
80002248:	00f707b3          	add	a5,a4,a5
8000224c:	fcf42c23          	sw	a5,-40(s0)

    for (i = 0; i < N; i++)
80002250:	fe042423          	sw	zero,-24(s0)
80002254:	1200006f          	j	80002374 <core_init_matrix+0x1dc>
    {
        for (j = 0; j < N; j++)
80002258:	fe042223          	sw	zero,-28(s0)
8000225c:	1000006f          	j	8000235c <core_init_matrix+0x1c4>
        {
            seed         = ((order * seed) % 65536);
80002260:	fc442583          	lw	a1,-60(s0)
80002264:	fec42503          	lw	a0,-20(s0)
80002268:	045020ef          	jal	80004aac <__mulsi3>
8000226c:	00050793          	mv	a5,a0
80002270:	00078713          	mv	a4,a5
80002274:	41f75793          	srai	a5,a4,0x1f
80002278:	0107d793          	srli	a5,a5,0x10
8000227c:	00f70733          	add	a4,a4,a5
80002280:	01071713          	slli	a4,a4,0x10
80002284:	01075713          	srli	a4,a4,0x10
80002288:	40f707b3          	sub	a5,a4,a5
8000228c:	fcf42223          	sw	a5,-60(s0)
            val          = (seed + order);
80002290:	fc442783          	lw	a5,-60(s0)
80002294:	01079713          	slli	a4,a5,0x10
80002298:	01075713          	srli	a4,a4,0x10
8000229c:	fec42783          	lw	a5,-20(s0)
800022a0:	01079793          	slli	a5,a5,0x10
800022a4:	0107d793          	srli	a5,a5,0x10
800022a8:	00f707b3          	add	a5,a4,a5
800022ac:	01079793          	slli	a5,a5,0x10
800022b0:	0107d793          	srli	a5,a5,0x10
800022b4:	fcf41b23          	sh	a5,-42(s0)
            val          = matrix_clip(val, 0);
            B[i * N + j] = val;
800022b8:	fe042583          	lw	a1,-32(s0)
800022bc:	fe842503          	lw	a0,-24(s0)
800022c0:	7ec020ef          	jal	80004aac <__mulsi3>
800022c4:	00050793          	mv	a5,a0
800022c8:	00078713          	mv	a4,a5
800022cc:	fe442783          	lw	a5,-28(s0)
800022d0:	00f707b3          	add	a5,a4,a5
800022d4:	00179793          	slli	a5,a5,0x1
800022d8:	fd842703          	lw	a4,-40(s0)
800022dc:	00f707b3          	add	a5,a4,a5
800022e0:	fd645703          	lhu	a4,-42(s0)
800022e4:	00e79023          	sh	a4,0(a5)
            val          = (val + order);
800022e8:	fec42783          	lw	a5,-20(s0)
800022ec:	01079713          	slli	a4,a5,0x10
800022f0:	01075713          	srli	a4,a4,0x10
800022f4:	fd645783          	lhu	a5,-42(s0)
800022f8:	00f707b3          	add	a5,a4,a5
800022fc:	01079793          	slli	a5,a5,0x10
80002300:	0107d793          	srli	a5,a5,0x10
80002304:	fcf41b23          	sh	a5,-42(s0)
            val          = matrix_clip(val, 1);
80002308:	fd645783          	lhu	a5,-42(s0)
8000230c:	0ff7f793          	zext.b	a5,a5
80002310:	fcf41b23          	sh	a5,-42(s0)
            A[i * N + j] = val;
80002314:	fe042583          	lw	a1,-32(s0)
80002318:	fe842503          	lw	a0,-24(s0)
8000231c:	790020ef          	jal	80004aac <__mulsi3>
80002320:	00050793          	mv	a5,a0
80002324:	00078713          	mv	a4,a5
80002328:	fe442783          	lw	a5,-28(s0)
8000232c:	00f707b3          	add	a5,a4,a5
80002330:	00179793          	slli	a5,a5,0x1
80002334:	fdc42703          	lw	a4,-36(s0)
80002338:	00f707b3          	add	a5,a4,a5
8000233c:	fd645703          	lhu	a4,-42(s0)
80002340:	00e79023          	sh	a4,0(a5)
            order++;
80002344:	fec42783          	lw	a5,-20(s0)
80002348:	00178793          	addi	a5,a5,1
8000234c:	fef42623          	sw	a5,-20(s0)
        for (j = 0; j < N; j++)
80002350:	fe442783          	lw	a5,-28(s0)
80002354:	00178793          	addi	a5,a5,1
80002358:	fef42223          	sw	a5,-28(s0)
8000235c:	fe442703          	lw	a4,-28(s0)
80002360:	fe042783          	lw	a5,-32(s0)
80002364:	eef76ee3          	bltu	a4,a5,80002260 <core_init_matrix+0xc8>
    for (i = 0; i < N; i++)
80002368:	fe842783          	lw	a5,-24(s0)
8000236c:	00178793          	addi	a5,a5,1
80002370:	fef42423          	sw	a5,-24(s0)
80002374:	fe842703          	lw	a4,-24(s0)
80002378:	fe042783          	lw	a5,-32(s0)
8000237c:	ecf76ee3          	bltu	a4,a5,80002258 <core_init_matrix+0xc0>
        }
    }

    p->A = A;
80002380:	fc042783          	lw	a5,-64(s0)
80002384:	fdc42703          	lw	a4,-36(s0)
80002388:	00e7a223          	sw	a4,4(a5)
    p->B = B;
8000238c:	fc042783          	lw	a5,-64(s0)
80002390:	fd842703          	lw	a4,-40(s0)
80002394:	00e7a423          	sw	a4,8(a5)
    p->C = (MATRES *)align_mem(B + N * N);
80002398:	fe042583          	lw	a1,-32(s0)
8000239c:	fe042503          	lw	a0,-32(s0)
800023a0:	70c020ef          	jal	80004aac <__mulsi3>
800023a4:	00050793          	mv	a5,a0
800023a8:	00179793          	slli	a5,a5,0x1
800023ac:	fd842703          	lw	a4,-40(s0)
800023b0:	00f707b3          	add	a5,a4,a5
800023b4:	fff78793          	addi	a5,a5,-1
800023b8:	ffc7f793          	andi	a5,a5,-4
800023bc:	00478793          	addi	a5,a5,4
800023c0:	00078713          	mv	a4,a5
800023c4:	fc042783          	lw	a5,-64(s0)
800023c8:	00e7a623          	sw	a4,12(a5)
    p->N = N;
800023cc:	fe042703          	lw	a4,-32(s0)
800023d0:	fc042783          	lw	a5,-64(s0)
800023d4:	00e7a023          	sw	a4,0(a5)
#if CORE_DEBUG
    printmat(A, N, "A");
    printmat(B, N, "B");
#endif
    return N;
800023d8:	fe042783          	lw	a5,-32(s0)
}
800023dc:	00078513          	mv	a0,a5
800023e0:	03c12083          	lw	ra,60(sp)
800023e4:	03812403          	lw	s0,56(sp)
800023e8:	04010113          	addi	sp,sp,64
800023ec:	00008067          	ret

800023f0 <matrix_sum>:

        Otherwise, reset the accumulator and add 10 to the result.
*/
ee_s16
matrix_sum(ee_u32 N, MATRES *C, MATDAT clipval)
{
800023f0:	fc010113          	addi	sp,sp,-64
800023f4:	02112e23          	sw	ra,60(sp)
800023f8:	02812c23          	sw	s0,56(sp)
800023fc:	04010413          	addi	s0,sp,64
80002400:	fca42623          	sw	a0,-52(s0)
80002404:	fcb42423          	sw	a1,-56(s0)
80002408:	00060793          	mv	a5,a2
8000240c:	fcf41323          	sh	a5,-58(s0)
    MATRES tmp = 0, prev = 0, cur = 0;
80002410:	fe042623          	sw	zero,-20(s0)
80002414:	fe042423          	sw	zero,-24(s0)
80002418:	fc042c23          	sw	zero,-40(s0)
    ee_s16 ret = 0;
8000241c:	fe041323          	sh	zero,-26(s0)
    ee_u32 i, j;
    for (i = 0; i < N; i++)
80002420:	fe042023          	sw	zero,-32(s0)
80002424:	0c80006f          	j	800024ec <matrix_sum+0xfc>
    {
        for (j = 0; j < N; j++)
80002428:	fc042e23          	sw	zero,-36(s0)
8000242c:	0a80006f          	j	800024d4 <matrix_sum+0xe4>
        {
            cur = C[i * N + j];
80002430:	fcc42583          	lw	a1,-52(s0)
80002434:	fe042503          	lw	a0,-32(s0)
80002438:	674020ef          	jal	80004aac <__mulsi3>
8000243c:	00050793          	mv	a5,a0
80002440:	00078713          	mv	a4,a5
80002444:	fdc42783          	lw	a5,-36(s0)
80002448:	00f707b3          	add	a5,a4,a5
8000244c:	00279793          	slli	a5,a5,0x2
80002450:	fc842703          	lw	a4,-56(s0)
80002454:	00f707b3          	add	a5,a4,a5
80002458:	0007a783          	lw	a5,0(a5)
8000245c:	fcf42c23          	sw	a5,-40(s0)
            tmp += cur;
80002460:	fec42703          	lw	a4,-20(s0)
80002464:	fd842783          	lw	a5,-40(s0)
80002468:	00f707b3          	add	a5,a4,a5
8000246c:	fef42623          	sw	a5,-20(s0)
            if (tmp > clipval)
80002470:	fc641783          	lh	a5,-58(s0)
80002474:	fec42703          	lw	a4,-20(s0)
80002478:	02e7d063          	bge	a5,a4,80002498 <matrix_sum+0xa8>
            {
                ret += 10;
8000247c:	fe645783          	lhu	a5,-26(s0)
80002480:	00a78793          	addi	a5,a5,10
80002484:	01079793          	slli	a5,a5,0x10
80002488:	0107d793          	srli	a5,a5,0x10
8000248c:	fef41323          	sh	a5,-26(s0)
                tmp = 0;
80002490:	fe042623          	sw	zero,-20(s0)
80002494:	02c0006f          	j	800024c0 <matrix_sum+0xd0>
            }
            else
            {
                ret += (cur > prev) ? 1 : 0;
80002498:	fd842703          	lw	a4,-40(s0)
8000249c:	fe842783          	lw	a5,-24(s0)
800024a0:	00e7a7b3          	slt	a5,a5,a4
800024a4:	0ff7f793          	zext.b	a5,a5
800024a8:	00078713          	mv	a4,a5
800024ac:	fe645783          	lhu	a5,-26(s0)
800024b0:	00f707b3          	add	a5,a4,a5
800024b4:	01079793          	slli	a5,a5,0x10
800024b8:	0107d793          	srli	a5,a5,0x10
800024bc:	fef41323          	sh	a5,-26(s0)
            }
            prev = cur;
800024c0:	fd842783          	lw	a5,-40(s0)
800024c4:	fef42423          	sw	a5,-24(s0)
        for (j = 0; j < N; j++)
800024c8:	fdc42783          	lw	a5,-36(s0)
800024cc:	00178793          	addi	a5,a5,1
800024d0:	fcf42e23          	sw	a5,-36(s0)
800024d4:	fdc42703          	lw	a4,-36(s0)
800024d8:	fcc42783          	lw	a5,-52(s0)
800024dc:	f4f76ae3          	bltu	a4,a5,80002430 <matrix_sum+0x40>
    for (i = 0; i < N; i++)
800024e0:	fe042783          	lw	a5,-32(s0)
800024e4:	00178793          	addi	a5,a5,1
800024e8:	fef42023          	sw	a5,-32(s0)
800024ec:	fe042703          	lw	a4,-32(s0)
800024f0:	fcc42783          	lw	a5,-52(s0)
800024f4:	f2f76ae3          	bltu	a4,a5,80002428 <matrix_sum+0x38>
        }
    }
    return ret;
800024f8:	fe641783          	lh	a5,-26(s0)
}
800024fc:	00078513          	mv	a0,a5
80002500:	03c12083          	lw	ra,60(sp)
80002504:	03812403          	lw	s0,56(sp)
80002508:	04010113          	addi	sp,sp,64
8000250c:	00008067          	ret

80002510 <matrix_mul_const>:
        Multiply a matrix by a constant.
        This could be used as a scaler for instance.
*/
void
matrix_mul_const(ee_u32 N, MATRES *C, MATDAT *A, MATDAT val)
{
80002510:	fc010113          	addi	sp,sp,-64
80002514:	02112e23          	sw	ra,60(sp)
80002518:	02812c23          	sw	s0,56(sp)
8000251c:	02912a23          	sw	s1,52(sp)
80002520:	03212823          	sw	s2,48(sp)
80002524:	03312623          	sw	s3,44(sp)
80002528:	04010413          	addi	s0,sp,64
8000252c:	fca42623          	sw	a0,-52(s0)
80002530:	fcb42423          	sw	a1,-56(s0)
80002534:	fcc42223          	sw	a2,-60(s0)
80002538:	00068793          	mv	a5,a3
8000253c:	fcf41123          	sh	a5,-62(s0)
    ee_u32 i, j;
    for (i = 0; i < N; i++)
80002540:	fc042e23          	sw	zero,-36(s0)
80002544:	0a00006f          	j	800025e4 <matrix_mul_const+0xd4>
    {
        for (j = 0; j < N; j++)
80002548:	fc042c23          	sw	zero,-40(s0)
8000254c:	0800006f          	j	800025cc <matrix_mul_const+0xbc>
        {
            C[i * N + j] = (MATRES)A[i * N + j] * (MATRES)val;
80002550:	fcc42583          	lw	a1,-52(s0)
80002554:	fdc42503          	lw	a0,-36(s0)
80002558:	554020ef          	jal	80004aac <__mulsi3>
8000255c:	00050793          	mv	a5,a0
80002560:	00078713          	mv	a4,a5
80002564:	fd842783          	lw	a5,-40(s0)
80002568:	00f707b3          	add	a5,a4,a5
8000256c:	00179793          	slli	a5,a5,0x1
80002570:	fc442703          	lw	a4,-60(s0)
80002574:	00f707b3          	add	a5,a4,a5
80002578:	00079783          	lh	a5,0(a5)
8000257c:	00078993          	mv	s3,a5
80002580:	fc241903          	lh	s2,-62(s0)
80002584:	fcc42583          	lw	a1,-52(s0)
80002588:	fdc42503          	lw	a0,-36(s0)
8000258c:	520020ef          	jal	80004aac <__mulsi3>
80002590:	00050793          	mv	a5,a0
80002594:	00078713          	mv	a4,a5
80002598:	fd842783          	lw	a5,-40(s0)
8000259c:	00f707b3          	add	a5,a4,a5
800025a0:	00279793          	slli	a5,a5,0x2
800025a4:	fc842703          	lw	a4,-56(s0)
800025a8:	00f704b3          	add	s1,a4,a5
800025ac:	00090593          	mv	a1,s2
800025b0:	00098513          	mv	a0,s3
800025b4:	4f8020ef          	jal	80004aac <__mulsi3>
800025b8:	00050793          	mv	a5,a0
800025bc:	00f4a023          	sw	a5,0(s1)
        for (j = 0; j < N; j++)
800025c0:	fd842783          	lw	a5,-40(s0)
800025c4:	00178793          	addi	a5,a5,1
800025c8:	fcf42c23          	sw	a5,-40(s0)
800025cc:	fd842703          	lw	a4,-40(s0)
800025d0:	fcc42783          	lw	a5,-52(s0)
800025d4:	f6f76ee3          	bltu	a4,a5,80002550 <matrix_mul_const+0x40>
    for (i = 0; i < N; i++)
800025d8:	fdc42783          	lw	a5,-36(s0)
800025dc:	00178793          	addi	a5,a5,1
800025e0:	fcf42e23          	sw	a5,-36(s0)
800025e4:	fdc42703          	lw	a4,-36(s0)
800025e8:	fcc42783          	lw	a5,-52(s0)
800025ec:	f4f76ee3          	bltu	a4,a5,80002548 <matrix_mul_const+0x38>
        }
    }
}
800025f0:	00000013          	nop
800025f4:	00000013          	nop
800025f8:	03c12083          	lw	ra,60(sp)
800025fc:	03812403          	lw	s0,56(sp)
80002600:	03412483          	lw	s1,52(sp)
80002604:	03012903          	lw	s2,48(sp)
80002608:	02c12983          	lw	s3,44(sp)
8000260c:	04010113          	addi	sp,sp,64
80002610:	00008067          	ret

80002614 <matrix_add_const>:
/* Function: matrix_add_const
        Add a constant value to all elements of a matrix.
*/
void
matrix_add_const(ee_u32 N, MATDAT *A, MATDAT val)
{
80002614:	fd010113          	addi	sp,sp,-48
80002618:	02112623          	sw	ra,44(sp)
8000261c:	02812423          	sw	s0,40(sp)
80002620:	02912223          	sw	s1,36(sp)
80002624:	03010413          	addi	s0,sp,48
80002628:	fca42e23          	sw	a0,-36(s0)
8000262c:	fcb42c23          	sw	a1,-40(s0)
80002630:	00060793          	mv	a5,a2
80002634:	fcf41b23          	sh	a5,-42(s0)
    ee_u32 i, j;
    for (i = 0; i < N; i++)
80002638:	fe042623          	sw	zero,-20(s0)
8000263c:	0a80006f          	j	800026e4 <matrix_add_const+0xd0>
    {
        for (j = 0; j < N; j++)
80002640:	fe042423          	sw	zero,-24(s0)
80002644:	0880006f          	j	800026cc <matrix_add_const+0xb8>
        {
            A[i * N + j] += val;
80002648:	fdc42583          	lw	a1,-36(s0)
8000264c:	fec42503          	lw	a0,-20(s0)
80002650:	45c020ef          	jal	80004aac <__mulsi3>
80002654:	00050793          	mv	a5,a0
80002658:	00078713          	mv	a4,a5
8000265c:	fe842783          	lw	a5,-24(s0)
80002660:	00f707b3          	add	a5,a4,a5
80002664:	00179793          	slli	a5,a5,0x1
80002668:	fd842703          	lw	a4,-40(s0)
8000266c:	00f707b3          	add	a5,a4,a5
80002670:	00079783          	lh	a5,0(a5)
80002674:	01079713          	slli	a4,a5,0x10
80002678:	01075713          	srli	a4,a4,0x10
8000267c:	fd645783          	lhu	a5,-42(s0)
80002680:	00f707b3          	add	a5,a4,a5
80002684:	01079493          	slli	s1,a5,0x10
80002688:	0104d493          	srli	s1,s1,0x10
8000268c:	fdc42583          	lw	a1,-36(s0)
80002690:	fec42503          	lw	a0,-20(s0)
80002694:	418020ef          	jal	80004aac <__mulsi3>
80002698:	00050793          	mv	a5,a0
8000269c:	00078713          	mv	a4,a5
800026a0:	fe842783          	lw	a5,-24(s0)
800026a4:	00f707b3          	add	a5,a4,a5
800026a8:	00179793          	slli	a5,a5,0x1
800026ac:	fd842703          	lw	a4,-40(s0)
800026b0:	00f707b3          	add	a5,a4,a5
800026b4:	01049713          	slli	a4,s1,0x10
800026b8:	41075713          	srai	a4,a4,0x10
800026bc:	00e79023          	sh	a4,0(a5)
        for (j = 0; j < N; j++)
800026c0:	fe842783          	lw	a5,-24(s0)
800026c4:	00178793          	addi	a5,a5,1
800026c8:	fef42423          	sw	a5,-24(s0)
800026cc:	fe842703          	lw	a4,-24(s0)
800026d0:	fdc42783          	lw	a5,-36(s0)
800026d4:	f6f76ae3          	bltu	a4,a5,80002648 <matrix_add_const+0x34>
    for (i = 0; i < N; i++)
800026d8:	fec42783          	lw	a5,-20(s0)
800026dc:	00178793          	addi	a5,a5,1
800026e0:	fef42623          	sw	a5,-20(s0)
800026e4:	fec42703          	lw	a4,-20(s0)
800026e8:	fdc42783          	lw	a5,-36(s0)
800026ec:	f4f76ae3          	bltu	a4,a5,80002640 <matrix_add_const+0x2c>
        }
    }
}
800026f0:	00000013          	nop
800026f4:	00000013          	nop
800026f8:	02c12083          	lw	ra,44(sp)
800026fc:	02812403          	lw	s0,40(sp)
80002700:	02412483          	lw	s1,36(sp)
80002704:	03010113          	addi	sp,sp,48
80002708:	00008067          	ret

8000270c <matrix_mul_vect>:
        This is common in many simple filters (e.g. fir where a vector of
   coefficients is applied to the matrix.)
*/
void
matrix_mul_vect(ee_u32 N, MATRES *C, MATDAT *A, MATDAT *B)
{
8000270c:	fd010113          	addi	sp,sp,-48
80002710:	02112623          	sw	ra,44(sp)
80002714:	02812423          	sw	s0,40(sp)
80002718:	02912223          	sw	s1,36(sp)
8000271c:	03010413          	addi	s0,sp,48
80002720:	fca42e23          	sw	a0,-36(s0)
80002724:	fcb42c23          	sw	a1,-40(s0)
80002728:	fcc42a23          	sw	a2,-44(s0)
8000272c:	fcd42823          	sw	a3,-48(s0)
    ee_u32 i, j;
    for (i = 0; i < N; i++)
80002730:	fe042623          	sw	zero,-20(s0)
80002734:	0c80006f          	j	800027fc <matrix_mul_vect+0xf0>
    {
        C[i] = 0;
80002738:	fec42783          	lw	a5,-20(s0)
8000273c:	00279793          	slli	a5,a5,0x2
80002740:	fd842703          	lw	a4,-40(s0)
80002744:	00f707b3          	add	a5,a4,a5
80002748:	0007a023          	sw	zero,0(a5)
        for (j = 0; j < N; j++)
8000274c:	fe042423          	sw	zero,-24(s0)
80002750:	0940006f          	j	800027e4 <matrix_mul_vect+0xd8>
        {
            C[i] += (MATRES)A[i * N + j] * (MATRES)B[j];
80002754:	fec42783          	lw	a5,-20(s0)
80002758:	00279793          	slli	a5,a5,0x2
8000275c:	fd842703          	lw	a4,-40(s0)
80002760:	00f707b3          	add	a5,a4,a5
80002764:	0007a483          	lw	s1,0(a5)
80002768:	fdc42583          	lw	a1,-36(s0)
8000276c:	fec42503          	lw	a0,-20(s0)
80002770:	33c020ef          	jal	80004aac <__mulsi3>
80002774:	00050793          	mv	a5,a0
80002778:	00078713          	mv	a4,a5
8000277c:	fe842783          	lw	a5,-24(s0)
80002780:	00f707b3          	add	a5,a4,a5
80002784:	00179793          	slli	a5,a5,0x1
80002788:	fd442703          	lw	a4,-44(s0)
8000278c:	00f707b3          	add	a5,a4,a5
80002790:	00079783          	lh	a5,0(a5)
80002794:	00078693          	mv	a3,a5
80002798:	fe842783          	lw	a5,-24(s0)
8000279c:	00179793          	slli	a5,a5,0x1
800027a0:	fd042703          	lw	a4,-48(s0)
800027a4:	00f707b3          	add	a5,a4,a5
800027a8:	00079783          	lh	a5,0(a5)
800027ac:	00078593          	mv	a1,a5
800027b0:	00068513          	mv	a0,a3
800027b4:	2f8020ef          	jal	80004aac <__mulsi3>
800027b8:	00050793          	mv	a5,a0
800027bc:	00078693          	mv	a3,a5
800027c0:	fec42783          	lw	a5,-20(s0)
800027c4:	00279793          	slli	a5,a5,0x2
800027c8:	fd842703          	lw	a4,-40(s0)
800027cc:	00f707b3          	add	a5,a4,a5
800027d0:	00d48733          	add	a4,s1,a3
800027d4:	00e7a023          	sw	a4,0(a5)
        for (j = 0; j < N; j++)
800027d8:	fe842783          	lw	a5,-24(s0)
800027dc:	00178793          	addi	a5,a5,1
800027e0:	fef42423          	sw	a5,-24(s0)
800027e4:	fe842703          	lw	a4,-24(s0)
800027e8:	fdc42783          	lw	a5,-36(s0)
800027ec:	f6f764e3          	bltu	a4,a5,80002754 <matrix_mul_vect+0x48>
    for (i = 0; i < N; i++)
800027f0:	fec42783          	lw	a5,-20(s0)
800027f4:	00178793          	addi	a5,a5,1
800027f8:	fef42623          	sw	a5,-20(s0)
800027fc:	fec42703          	lw	a4,-20(s0)
80002800:	fdc42783          	lw	a5,-36(s0)
80002804:	f2f76ae3          	bltu	a4,a5,80002738 <matrix_mul_vect+0x2c>
        }
    }
}
80002808:	00000013          	nop
8000280c:	00000013          	nop
80002810:	02c12083          	lw	ra,44(sp)
80002814:	02812403          	lw	s0,40(sp)
80002818:	02412483          	lw	s1,36(sp)
8000281c:	03010113          	addi	sp,sp,48
80002820:	00008067          	ret

80002824 <matrix_mul_matrix>:
        Basic code is used in many algorithms, mostly with minor changes such as
   scaling.
*/
void
matrix_mul_matrix(ee_u32 N, MATRES *C, MATDAT *A, MATDAT *B)
{
80002824:	fd010113          	addi	sp,sp,-48
80002828:	02112623          	sw	ra,44(sp)
8000282c:	02812423          	sw	s0,40(sp)
80002830:	02912223          	sw	s1,36(sp)
80002834:	03212023          	sw	s2,32(sp)
80002838:	03010413          	addi	s0,sp,48
8000283c:	fca42e23          	sw	a0,-36(s0)
80002840:	fcb42c23          	sw	a1,-40(s0)
80002844:	fcc42a23          	sw	a2,-44(s0)
80002848:	fcd42823          	sw	a3,-48(s0)
    ee_u32 i, j, k;
    for (i = 0; i < N; i++)
8000284c:	fe042623          	sw	zero,-20(s0)
80002850:	1480006f          	j	80002998 <matrix_mul_matrix+0x174>
    {
        for (j = 0; j < N; j++)
80002854:	fe042423          	sw	zero,-24(s0)
80002858:	1280006f          	j	80002980 <matrix_mul_matrix+0x15c>
        {
            C[i * N + j] = 0;
8000285c:	fdc42583          	lw	a1,-36(s0)
80002860:	fec42503          	lw	a0,-20(s0)
80002864:	248020ef          	jal	80004aac <__mulsi3>
80002868:	00050793          	mv	a5,a0
8000286c:	00078713          	mv	a4,a5
80002870:	fe842783          	lw	a5,-24(s0)
80002874:	00f707b3          	add	a5,a4,a5
80002878:	00279793          	slli	a5,a5,0x2
8000287c:	fd842703          	lw	a4,-40(s0)
80002880:	00f707b3          	add	a5,a4,a5
80002884:	0007a023          	sw	zero,0(a5)
            for (k = 0; k < N; k++)
80002888:	fe042223          	sw	zero,-28(s0)
8000288c:	0dc0006f          	j	80002968 <matrix_mul_matrix+0x144>
            {
                C[i * N + j] += (MATRES)A[i * N + k] * (MATRES)B[k * N + j];
80002890:	fdc42583          	lw	a1,-36(s0)
80002894:	fec42503          	lw	a0,-20(s0)
80002898:	214020ef          	jal	80004aac <__mulsi3>
8000289c:	00050793          	mv	a5,a0
800028a0:	00078713          	mv	a4,a5
800028a4:	fe842783          	lw	a5,-24(s0)
800028a8:	00f707b3          	add	a5,a4,a5
800028ac:	00279793          	slli	a5,a5,0x2
800028b0:	fd842703          	lw	a4,-40(s0)
800028b4:	00f707b3          	add	a5,a4,a5
800028b8:	0007a483          	lw	s1,0(a5)
800028bc:	fdc42583          	lw	a1,-36(s0)
800028c0:	fec42503          	lw	a0,-20(s0)
800028c4:	1e8020ef          	jal	80004aac <__mulsi3>
800028c8:	00050793          	mv	a5,a0
800028cc:	00078713          	mv	a4,a5
800028d0:	fe442783          	lw	a5,-28(s0)
800028d4:	00f707b3          	add	a5,a4,a5
800028d8:	00179793          	slli	a5,a5,0x1
800028dc:	fd442703          	lw	a4,-44(s0)
800028e0:	00f707b3          	add	a5,a4,a5
800028e4:	00079783          	lh	a5,0(a5)
800028e8:	00078913          	mv	s2,a5
800028ec:	fdc42583          	lw	a1,-36(s0)
800028f0:	fe442503          	lw	a0,-28(s0)
800028f4:	1b8020ef          	jal	80004aac <__mulsi3>
800028f8:	00050793          	mv	a5,a0
800028fc:	00078713          	mv	a4,a5
80002900:	fe842783          	lw	a5,-24(s0)
80002904:	00f707b3          	add	a5,a4,a5
80002908:	00179793          	slli	a5,a5,0x1
8000290c:	fd042703          	lw	a4,-48(s0)
80002910:	00f707b3          	add	a5,a4,a5
80002914:	00079783          	lh	a5,0(a5)
80002918:	00078593          	mv	a1,a5
8000291c:	00090513          	mv	a0,s2
80002920:	18c020ef          	jal	80004aac <__mulsi3>
80002924:	00050793          	mv	a5,a0
80002928:	00078913          	mv	s2,a5
8000292c:	fdc42583          	lw	a1,-36(s0)
80002930:	fec42503          	lw	a0,-20(s0)
80002934:	178020ef          	jal	80004aac <__mulsi3>
80002938:	00050793          	mv	a5,a0
8000293c:	00078713          	mv	a4,a5
80002940:	fe842783          	lw	a5,-24(s0)
80002944:	00f707b3          	add	a5,a4,a5
80002948:	00279793          	slli	a5,a5,0x2
8000294c:	fd842703          	lw	a4,-40(s0)
80002950:	00f707b3          	add	a5,a4,a5
80002954:	01248733          	add	a4,s1,s2
80002958:	00e7a023          	sw	a4,0(a5)
            for (k = 0; k < N; k++)
8000295c:	fe442783          	lw	a5,-28(s0)
80002960:	00178793          	addi	a5,a5,1
80002964:	fef42223          	sw	a5,-28(s0)
80002968:	fe442703          	lw	a4,-28(s0)
8000296c:	fdc42783          	lw	a5,-36(s0)
80002970:	f2f760e3          	bltu	a4,a5,80002890 <matrix_mul_matrix+0x6c>
        for (j = 0; j < N; j++)
80002974:	fe842783          	lw	a5,-24(s0)
80002978:	00178793          	addi	a5,a5,1
8000297c:	fef42423          	sw	a5,-24(s0)
80002980:	fe842703          	lw	a4,-24(s0)
80002984:	fdc42783          	lw	a5,-36(s0)
80002988:	ecf76ae3          	bltu	a4,a5,8000285c <matrix_mul_matrix+0x38>
    for (i = 0; i < N; i++)
8000298c:	fec42783          	lw	a5,-20(s0)
80002990:	00178793          	addi	a5,a5,1
80002994:	fef42623          	sw	a5,-20(s0)
80002998:	fec42703          	lw	a4,-20(s0)
8000299c:	fdc42783          	lw	a5,-36(s0)
800029a0:	eaf76ae3          	bltu	a4,a5,80002854 <matrix_mul_matrix+0x30>
            }
        }
    }
}
800029a4:	00000013          	nop
800029a8:	00000013          	nop
800029ac:	02c12083          	lw	ra,44(sp)
800029b0:	02812403          	lw	s0,40(sp)
800029b4:	02412483          	lw	s1,36(sp)
800029b8:	02012903          	lw	s2,32(sp)
800029bc:	03010113          	addi	sp,sp,48
800029c0:	00008067          	ret

800029c4 <matrix_mul_matrix_bitextract>:
        Basic code is used in many algorithms, mostly with minor changes such as
   scaling.
*/
void
matrix_mul_matrix_bitextract(ee_u32 N, MATRES *C, MATDAT *A, MATDAT *B)
{
800029c4:	fd010113          	addi	sp,sp,-48
800029c8:	02112623          	sw	ra,44(sp)
800029cc:	02812423          	sw	s0,40(sp)
800029d0:	02912223          	sw	s1,36(sp)
800029d4:	03010413          	addi	s0,sp,48
800029d8:	fca42e23          	sw	a0,-36(s0)
800029dc:	fcb42c23          	sw	a1,-40(s0)
800029e0:	fcc42a23          	sw	a2,-44(s0)
800029e4:	fcd42823          	sw	a3,-48(s0)
    ee_u32 i, j, k;
    for (i = 0; i < N; i++)
800029e8:	fe042623          	sw	zero,-20(s0)
800029ec:	1780006f          	j	80002b64 <matrix_mul_matrix_bitextract+0x1a0>
    {
        for (j = 0; j < N; j++)
800029f0:	fe042423          	sw	zero,-24(s0)
800029f4:	1580006f          	j	80002b4c <matrix_mul_matrix_bitextract+0x188>
        {
            C[i * N + j] = 0;
800029f8:	fdc42583          	lw	a1,-36(s0)
800029fc:	fec42503          	lw	a0,-20(s0)
80002a00:	0ac020ef          	jal	80004aac <__mulsi3>
80002a04:	00050793          	mv	a5,a0
80002a08:	00078713          	mv	a4,a5
80002a0c:	fe842783          	lw	a5,-24(s0)
80002a10:	00f707b3          	add	a5,a4,a5
80002a14:	00279793          	slli	a5,a5,0x2
80002a18:	fd842703          	lw	a4,-40(s0)
80002a1c:	00f707b3          	add	a5,a4,a5
80002a20:	0007a023          	sw	zero,0(a5)
            for (k = 0; k < N; k++)
80002a24:	fe042223          	sw	zero,-28(s0)
80002a28:	10c0006f          	j	80002b34 <matrix_mul_matrix_bitextract+0x170>
            {
                MATRES tmp = (MATRES)A[i * N + k] * (MATRES)B[k * N + j];
80002a2c:	fdc42583          	lw	a1,-36(s0)
80002a30:	fec42503          	lw	a0,-20(s0)
80002a34:	078020ef          	jal	80004aac <__mulsi3>
80002a38:	00050793          	mv	a5,a0
80002a3c:	00078713          	mv	a4,a5
80002a40:	fe442783          	lw	a5,-28(s0)
80002a44:	00f707b3          	add	a5,a4,a5
80002a48:	00179793          	slli	a5,a5,0x1
80002a4c:	fd442703          	lw	a4,-44(s0)
80002a50:	00f707b3          	add	a5,a4,a5
80002a54:	00079783          	lh	a5,0(a5)
80002a58:	00078493          	mv	s1,a5
80002a5c:	fdc42583          	lw	a1,-36(s0)
80002a60:	fe442503          	lw	a0,-28(s0)
80002a64:	048020ef          	jal	80004aac <__mulsi3>
80002a68:	00050793          	mv	a5,a0
80002a6c:	00078713          	mv	a4,a5
80002a70:	fe842783          	lw	a5,-24(s0)
80002a74:	00f707b3          	add	a5,a4,a5
80002a78:	00179793          	slli	a5,a5,0x1
80002a7c:	fd042703          	lw	a4,-48(s0)
80002a80:	00f707b3          	add	a5,a4,a5
80002a84:	00079783          	lh	a5,0(a5)
80002a88:	00078593          	mv	a1,a5
80002a8c:	00048513          	mv	a0,s1
80002a90:	01c020ef          	jal	80004aac <__mulsi3>
80002a94:	00050793          	mv	a5,a0
80002a98:	fef42023          	sw	a5,-32(s0)
                C[i * N + j] += bit_extract(tmp, 2, 4) * bit_extract(tmp, 5, 7);
80002a9c:	fdc42583          	lw	a1,-36(s0)
80002aa0:	fec42503          	lw	a0,-20(s0)
80002aa4:	008020ef          	jal	80004aac <__mulsi3>
80002aa8:	00050793          	mv	a5,a0
80002aac:	00078713          	mv	a4,a5
80002ab0:	fe842783          	lw	a5,-24(s0)
80002ab4:	00f707b3          	add	a5,a4,a5
80002ab8:	00279793          	slli	a5,a5,0x2
80002abc:	fd842703          	lw	a4,-40(s0)
80002ac0:	00f707b3          	add	a5,a4,a5
80002ac4:	0007a783          	lw	a5,0(a5)
80002ac8:	00078493          	mv	s1,a5
80002acc:	fe042783          	lw	a5,-32(s0)
80002ad0:	4027d793          	srai	a5,a5,0x2
80002ad4:	00f7f713          	andi	a4,a5,15
80002ad8:	fe042783          	lw	a5,-32(s0)
80002adc:	4057d793          	srai	a5,a5,0x5
80002ae0:	07f7f793          	andi	a5,a5,127
80002ae4:	00078593          	mv	a1,a5
80002ae8:	00070513          	mv	a0,a4
80002aec:	7c1010ef          	jal	80004aac <__mulsi3>
80002af0:	00050793          	mv	a5,a0
80002af4:	00f484b3          	add	s1,s1,a5
80002af8:	fdc42583          	lw	a1,-36(s0)
80002afc:	fec42503          	lw	a0,-20(s0)
80002b00:	7ad010ef          	jal	80004aac <__mulsi3>
80002b04:	00050793          	mv	a5,a0
80002b08:	00078713          	mv	a4,a5
80002b0c:	fe842783          	lw	a5,-24(s0)
80002b10:	00f707b3          	add	a5,a4,a5
80002b14:	00279793          	slli	a5,a5,0x2
80002b18:	fd842703          	lw	a4,-40(s0)
80002b1c:	00f707b3          	add	a5,a4,a5
80002b20:	00048713          	mv	a4,s1
80002b24:	00e7a023          	sw	a4,0(a5)
            for (k = 0; k < N; k++)
80002b28:	fe442783          	lw	a5,-28(s0)
80002b2c:	00178793          	addi	a5,a5,1
80002b30:	fef42223          	sw	a5,-28(s0)
80002b34:	fe442703          	lw	a4,-28(s0)
80002b38:	fdc42783          	lw	a5,-36(s0)
80002b3c:	eef768e3          	bltu	a4,a5,80002a2c <matrix_mul_matrix_bitextract+0x68>
        for (j = 0; j < N; j++)
80002b40:	fe842783          	lw	a5,-24(s0)
80002b44:	00178793          	addi	a5,a5,1
80002b48:	fef42423          	sw	a5,-24(s0)
80002b4c:	fe842703          	lw	a4,-24(s0)
80002b50:	fdc42783          	lw	a5,-36(s0)
80002b54:	eaf762e3          	bltu	a4,a5,800029f8 <matrix_mul_matrix_bitextract+0x34>
    for (i = 0; i < N; i++)
80002b58:	fec42783          	lw	a5,-20(s0)
80002b5c:	00178793          	addi	a5,a5,1
80002b60:	fef42623          	sw	a5,-20(s0)
80002b64:	fec42703          	lw	a4,-20(s0)
80002b68:	fdc42783          	lw	a5,-36(s0)
80002b6c:	e8f762e3          	bltu	a4,a5,800029f0 <matrix_mul_matrix_bitextract+0x2c>
            }
        }
    }
}
80002b70:	00000013          	nop
80002b74:	00000013          	nop
80002b78:	02c12083          	lw	ra,44(sp)
80002b7c:	02812403          	lw	s0,40(sp)
80002b80:	02412483          	lw	s1,36(sp)
80002b84:	03010113          	addi	sp,sp,48
80002b88:	00008067          	ret

80002b8c <core_bench_state>:
                 ee_u8 *memblock,
                 ee_s16 seed1,
                 ee_s16 seed2,
                 ee_s16 step,
                 ee_u16 crc)
{
80002b8c:	f9010113          	addi	sp,sp,-112
80002b90:	06112623          	sw	ra,108(sp)
80002b94:	06812423          	sw	s0,104(sp)
80002b98:	07010413          	addi	s0,sp,112
80002b9c:	f8a42e23          	sw	a0,-100(s0)
80002ba0:	f8b42c23          	sw	a1,-104(s0)
80002ba4:	00060593          	mv	a1,a2
80002ba8:	00068613          	mv	a2,a3
80002bac:	00070693          	mv	a3,a4
80002bb0:	00078713          	mv	a4,a5
80002bb4:	00058793          	mv	a5,a1
80002bb8:	f8f41b23          	sh	a5,-106(s0)
80002bbc:	00060793          	mv	a5,a2
80002bc0:	f8f41a23          	sh	a5,-108(s0)
80002bc4:	00068793          	mv	a5,a3
80002bc8:	f8f41923          	sh	a5,-110(s0)
80002bcc:	00070793          	mv	a5,a4
80002bd0:	f8f41823          	sh	a5,-112(s0)
    ee_u32 final_counts[NUM_CORE_STATES];
    ee_u32 track_counts[NUM_CORE_STATES];
    ee_u8 *p = memblock;
80002bd4:	f9842783          	lw	a5,-104(s0)
80002bd8:	faf42023          	sw	a5,-96(s0)
    ee_u32 i;

#if CORE_DEBUG
    ee_printf("State Bench: %d,%d,%d,%04x\n", seed1, seed2, step, crc);
#endif
    for (i = 0; i < NUM_CORE_STATES; i++)
80002bdc:	fe042623          	sw	zero,-20(s0)
80002be0:	04c0006f          	j	80002c2c <core_bench_state+0xa0>
    {
        final_counts[i] = track_counts[i] = 0;
80002be4:	fec42703          	lw	a4,-20(s0)
80002be8:	fa440793          	addi	a5,s0,-92
80002bec:	00271713          	slli	a4,a4,0x2
80002bf0:	00f707b3          	add	a5,a4,a5
80002bf4:	0007a023          	sw	zero,0(a5)
80002bf8:	fec42703          	lw	a4,-20(s0)
80002bfc:	fa440793          	addi	a5,s0,-92
80002c00:	00271713          	slli	a4,a4,0x2
80002c04:	00f707b3          	add	a5,a4,a5
80002c08:	0007a703          	lw	a4,0(a5)
80002c0c:	fec42683          	lw	a3,-20(s0)
80002c10:	fc440793          	addi	a5,s0,-60
80002c14:	00269693          	slli	a3,a3,0x2
80002c18:	00f687b3          	add	a5,a3,a5
80002c1c:	00e7a023          	sw	a4,0(a5)
    for (i = 0; i < NUM_CORE_STATES; i++)
80002c20:	fec42783          	lw	a5,-20(s0)
80002c24:	00178793          	addi	a5,a5,1
80002c28:	fef42623          	sw	a5,-20(s0)
80002c2c:	fec42703          	lw	a4,-20(s0)
80002c30:	00700793          	li	a5,7
80002c34:	fae7f8e3          	bgeu	a5,a4,80002be4 <core_bench_state+0x58>
    }
    /* run the state machine over the input */
    while (*p != 0)
80002c38:	0480006f          	j	80002c80 <core_bench_state+0xf4>
    {
        enum CORE_STATE fstate = core_state_transition(&p, track_counts);
80002c3c:	fa440713          	addi	a4,s0,-92
80002c40:	fa040793          	addi	a5,s0,-96
80002c44:	00070593          	mv	a1,a4
80002c48:	00078513          	mv	a0,a5
80002c4c:	4d4000ef          	jal	80003120 <core_state_transition>
80002c50:	fea42223          	sw	a0,-28(s0)
        final_counts[fstate]++;
80002c54:	fe442703          	lw	a4,-28(s0)
80002c58:	fc440793          	addi	a5,s0,-60
80002c5c:	00271713          	slli	a4,a4,0x2
80002c60:	00f707b3          	add	a5,a4,a5
80002c64:	0007a783          	lw	a5,0(a5)
80002c68:	00178713          	addi	a4,a5,1
80002c6c:	fe442683          	lw	a3,-28(s0)
80002c70:	fc440793          	addi	a5,s0,-60
80002c74:	00269693          	slli	a3,a3,0x2
80002c78:	00f687b3          	add	a5,a3,a5
80002c7c:	00e7a023          	sw	a4,0(a5)
    while (*p != 0)
80002c80:	fa042783          	lw	a5,-96(s0)
80002c84:	0007c783          	lbu	a5,0(a5)
80002c88:	fa079ae3          	bnez	a5,80002c3c <core_bench_state+0xb0>
    }
    ee_printf("\n");
#else
    }
#endif
    p = memblock;
80002c8c:	f9842783          	lw	a5,-104(s0)
80002c90:	faf42023          	sw	a5,-96(s0)
    while (p < (memblock + blksize))
80002c94:	0440006f          	j	80002cd8 <core_bench_state+0x14c>
    { /* insert some corruption */
        if (*p != ',')
80002c98:	fa042783          	lw	a5,-96(s0)
80002c9c:	0007c703          	lbu	a4,0(a5)
80002ca0:	02c00793          	li	a5,44
80002ca4:	02f70263          	beq	a4,a5,80002cc8 <core_bench_state+0x13c>
            *p ^= (ee_u8)seed1;
80002ca8:	fa042783          	lw	a5,-96(s0)
80002cac:	0007c683          	lbu	a3,0(a5)
80002cb0:	f9645783          	lhu	a5,-106(s0)
80002cb4:	0ff7f713          	zext.b	a4,a5
80002cb8:	fa042783          	lw	a5,-96(s0)
80002cbc:	00e6c733          	xor	a4,a3,a4
80002cc0:	0ff77713          	zext.b	a4,a4
80002cc4:	00e78023          	sb	a4,0(a5)
        p += step;
80002cc8:	fa042703          	lw	a4,-96(s0)
80002ccc:	f9241783          	lh	a5,-110(s0)
80002cd0:	00f707b3          	add	a5,a4,a5
80002cd4:	faf42023          	sw	a5,-96(s0)
    while (p < (memblock + blksize))
80002cd8:	f9842703          	lw	a4,-104(s0)
80002cdc:	f9c42783          	lw	a5,-100(s0)
80002ce0:	00f70733          	add	a4,a4,a5
80002ce4:	fa042783          	lw	a5,-96(s0)
80002ce8:	fae7e8e3          	bltu	a5,a4,80002c98 <core_bench_state+0x10c>
    }
    p = memblock;
80002cec:	f9842783          	lw	a5,-104(s0)
80002cf0:	faf42023          	sw	a5,-96(s0)
    /* run the state machine over the input again */
    while (*p != 0)
80002cf4:	0480006f          	j	80002d3c <core_bench_state+0x1b0>
    {
        enum CORE_STATE fstate = core_state_transition(&p, track_counts);
80002cf8:	fa440713          	addi	a4,s0,-92
80002cfc:	fa040793          	addi	a5,s0,-96
80002d00:	00070593          	mv	a1,a4
80002d04:	00078513          	mv	a0,a5
80002d08:	418000ef          	jal	80003120 <core_state_transition>
80002d0c:	fea42423          	sw	a0,-24(s0)
        final_counts[fstate]++;
80002d10:	fe842703          	lw	a4,-24(s0)
80002d14:	fc440793          	addi	a5,s0,-60
80002d18:	00271713          	slli	a4,a4,0x2
80002d1c:	00f707b3          	add	a5,a4,a5
80002d20:	0007a783          	lw	a5,0(a5)
80002d24:	00178713          	addi	a4,a5,1
80002d28:	fe842683          	lw	a3,-24(s0)
80002d2c:	fc440793          	addi	a5,s0,-60
80002d30:	00269693          	slli	a3,a3,0x2
80002d34:	00f687b3          	add	a5,a3,a5
80002d38:	00e7a023          	sw	a4,0(a5)
    while (*p != 0)
80002d3c:	fa042783          	lw	a5,-96(s0)
80002d40:	0007c783          	lbu	a5,0(a5)
80002d44:	fa079ae3          	bnez	a5,80002cf8 <core_bench_state+0x16c>
    }
    ee_printf("\n");
#else
    }
#endif
    p = memblock;
80002d48:	f9842783          	lw	a5,-104(s0)
80002d4c:	faf42023          	sw	a5,-96(s0)
    while (p < (memblock + blksize))
80002d50:	0440006f          	j	80002d94 <core_bench_state+0x208>
    { /* undo corruption is seed1 and seed2 are equal */
        if (*p != ',')
80002d54:	fa042783          	lw	a5,-96(s0)
80002d58:	0007c703          	lbu	a4,0(a5)
80002d5c:	02c00793          	li	a5,44
80002d60:	02f70263          	beq	a4,a5,80002d84 <core_bench_state+0x1f8>
            *p ^= (ee_u8)seed2;
80002d64:	fa042783          	lw	a5,-96(s0)
80002d68:	0007c683          	lbu	a3,0(a5)
80002d6c:	f9445783          	lhu	a5,-108(s0)
80002d70:	0ff7f713          	zext.b	a4,a5
80002d74:	fa042783          	lw	a5,-96(s0)
80002d78:	00e6c733          	xor	a4,a3,a4
80002d7c:	0ff77713          	zext.b	a4,a4
80002d80:	00e78023          	sb	a4,0(a5)
        p += step;
80002d84:	fa042703          	lw	a4,-96(s0)
80002d88:	f9241783          	lh	a5,-110(s0)
80002d8c:	00f707b3          	add	a5,a4,a5
80002d90:	faf42023          	sw	a5,-96(s0)
    while (p < (memblock + blksize))
80002d94:	f9842703          	lw	a4,-104(s0)
80002d98:	f9c42783          	lw	a5,-100(s0)
80002d9c:	00f70733          	add	a4,a4,a5
80002da0:	fa042783          	lw	a5,-96(s0)
80002da4:	fae7e8e3          	bltu	a5,a4,80002d54 <core_bench_state+0x1c8>
    }
    /* end timing */
    for (i = 0; i < NUM_CORE_STATES; i++)
80002da8:	fe042623          	sw	zero,-20(s0)
80002dac:	0680006f          	j	80002e14 <core_bench_state+0x288>
    {
        crc = crcu32(final_counts[i], crc);
80002db0:	fec42703          	lw	a4,-20(s0)
80002db4:	fc440793          	addi	a5,s0,-60
80002db8:	00271713          	slli	a4,a4,0x2
80002dbc:	00f707b3          	add	a5,a4,a5
80002dc0:	0007a783          	lw	a5,0(a5)
80002dc4:	f9045703          	lhu	a4,-112(s0)
80002dc8:	00070593          	mv	a1,a4
80002dcc:	00078513          	mv	a0,a5
80002dd0:	1d9000ef          	jal	800037a8 <crcu32>
80002dd4:	00050793          	mv	a5,a0
80002dd8:	f8f41823          	sh	a5,-112(s0)
        crc = crcu32(track_counts[i], crc);
80002ddc:	fec42703          	lw	a4,-20(s0)
80002de0:	fa440793          	addi	a5,s0,-92
80002de4:	00271713          	slli	a4,a4,0x2
80002de8:	00f707b3          	add	a5,a4,a5
80002dec:	0007a783          	lw	a5,0(a5)
80002df0:	f9045703          	lhu	a4,-112(s0)
80002df4:	00070593          	mv	a1,a4
80002df8:	00078513          	mv	a0,a5
80002dfc:	1ad000ef          	jal	800037a8 <crcu32>
80002e00:	00050793          	mv	a5,a0
80002e04:	f8f41823          	sh	a5,-112(s0)
    for (i = 0; i < NUM_CORE_STATES; i++)
80002e08:	fec42783          	lw	a5,-20(s0)
80002e0c:	00178793          	addi	a5,a5,1
80002e10:	fef42623          	sw	a5,-20(s0)
80002e14:	fec42703          	lw	a4,-20(s0)
80002e18:	00700793          	li	a5,7
80002e1c:	f8e7fae3          	bgeu	a5,a4,80002db0 <core_bench_state+0x224>
    }
    return crc;
80002e20:	f9045783          	lhu	a5,-112(s0)
}
80002e24:	00078513          	mv	a0,a5
80002e28:	06c12083          	lw	ra,108(sp)
80002e2c:	06812403          	lw	s0,104(sp)
80002e30:	07010113          	addi	sp,sp,112
80002e34:	00008067          	ret

80002e38 <core_init_state>:
        The seed parameter MUST be supplied from a source that cannot be
   determined at compile time
*/
void
core_init_state(ee_u32 size, ee_s16 seed, ee_u8 *p)
{
80002e38:	fd010113          	addi	sp,sp,-48
80002e3c:	02112623          	sw	ra,44(sp)
80002e40:	02812423          	sw	s0,40(sp)
80002e44:	03010413          	addi	s0,sp,48
80002e48:	fca42e23          	sw	a0,-36(s0)
80002e4c:	00058793          	mv	a5,a1
80002e50:	fcc42a23          	sw	a2,-44(s0)
80002e54:	fcf41d23          	sh	a5,-38(s0)
    ee_u32 total = 0, next = 0, i;
80002e58:	fe042623          	sw	zero,-20(s0)
80002e5c:	fe042423          	sw	zero,-24(s0)
    ee_u8 *buf = 0;
80002e60:	fe042023          	sw	zero,-32(s0)
#if CORE_DEBUG
    ee_u8 *start = p;
    ee_printf("State: %d,%d\n", size, seed);
#endif
    size--;
80002e64:	fdc42783          	lw	a5,-36(s0)
80002e68:	fff78793          	addi	a5,a5,-1
80002e6c:	fcf42e23          	sw	a5,-36(s0)
    next = 0;
80002e70:	fe042423          	sw	zero,-24(s0)
    while ((total + next + 1) < size)
80002e74:	1ec0006f          	j	80003060 <core_init_state+0x228>
    {
        if (next > 0)
80002e78:	fe842783          	lw	a5,-24(s0)
80002e7c:	06078e63          	beqz	a5,80002ef8 <core_init_state+0xc0>
        {
            for (i = 0; i < next; i++)
80002e80:	fe042223          	sw	zero,-28(s0)
80002e84:	0380006f          	j	80002ebc <core_init_state+0x84>
                *(p + total + i) = buf[i];
80002e88:	fe042703          	lw	a4,-32(s0)
80002e8c:	fe442783          	lw	a5,-28(s0)
80002e90:	00f70733          	add	a4,a4,a5
80002e94:	fec42683          	lw	a3,-20(s0)
80002e98:	fe442783          	lw	a5,-28(s0)
80002e9c:	00f687b3          	add	a5,a3,a5
80002ea0:	fd442683          	lw	a3,-44(s0)
80002ea4:	00f687b3          	add	a5,a3,a5
80002ea8:	00074703          	lbu	a4,0(a4)
80002eac:	00e78023          	sb	a4,0(a5)
            for (i = 0; i < next; i++)
80002eb0:	fe442783          	lw	a5,-28(s0)
80002eb4:	00178793          	addi	a5,a5,1
80002eb8:	fef42223          	sw	a5,-28(s0)
80002ebc:	fe442703          	lw	a4,-28(s0)
80002ec0:	fe842783          	lw	a5,-24(s0)
80002ec4:	fcf762e3          	bltu	a4,a5,80002e88 <core_init_state+0x50>
            *(p + total + i) = ',';
80002ec8:	fec42703          	lw	a4,-20(s0)
80002ecc:	fe442783          	lw	a5,-28(s0)
80002ed0:	00f707b3          	add	a5,a4,a5
80002ed4:	fd442703          	lw	a4,-44(s0)
80002ed8:	00f707b3          	add	a5,a4,a5
80002edc:	02c00713          	li	a4,44
80002ee0:	00e78023          	sb	a4,0(a5)
            total += next + 1;
80002ee4:	fe842703          	lw	a4,-24(s0)
80002ee8:	fec42783          	lw	a5,-20(s0)
80002eec:	00f707b3          	add	a5,a4,a5
80002ef0:	00178793          	addi	a5,a5,1
80002ef4:	fef42623          	sw	a5,-20(s0)
        }
        seed++;
80002ef8:	fda41783          	lh	a5,-38(s0)
80002efc:	01079793          	slli	a5,a5,0x10
80002f00:	0107d793          	srli	a5,a5,0x10
80002f04:	00178793          	addi	a5,a5,1
80002f08:	01079793          	slli	a5,a5,0x10
80002f0c:	0107d793          	srli	a5,a5,0x10
80002f10:	fcf41d23          	sh	a5,-38(s0)
        switch (seed & 0x7)
80002f14:	fda45783          	lhu	a5,-38(s0)
80002f18:	0077f793          	andi	a5,a5,7
80002f1c:	00700713          	li	a4,7
80002f20:	0ee78e63          	beq	a5,a4,8000301c <core_init_state+0x1e4>
80002f24:	00700713          	li	a4,7
80002f28:	12f74a63          	blt	a4,a5,8000305c <core_init_state+0x224>
80002f2c:	00600713          	li	a4,6
80002f30:	12f74663          	blt	a4,a5,8000305c <core_init_state+0x224>
80002f34:	00500713          	li	a4,5
80002f38:	0ae7d263          	bge	a5,a4,80002fdc <core_init_state+0x1a4>
80002f3c:	00200713          	li	a4,2
80002f40:	00f74663          	blt	a4,a5,80002f4c <core_init_state+0x114>
80002f44:	0007dc63          	bgez	a5,80002f5c <core_init_state+0x124>
80002f48:	1140006f          	j	8000305c <core_init_state+0x224>
80002f4c:	ffd78713          	addi	a4,a5,-3
80002f50:	00100793          	li	a5,1
80002f54:	10e7e463          	bltu	a5,a4,8000305c <core_init_state+0x224>
80002f58:	0440006f          	j	80002f9c <core_init_state+0x164>
        {
            case 0: /* int */
            case 1: /* int */
            case 2: /* int */
                buf  = intpat[(seed >> 3) & 0x3];
80002f5c:	fda41783          	lh	a5,-38(s0)
80002f60:	4037d793          	srai	a5,a5,0x3
80002f64:	01079793          	slli	a5,a5,0x10
80002f68:	4107d793          	srai	a5,a5,0x10
80002f6c:	01079793          	slli	a5,a5,0x10
80002f70:	0107d793          	srli	a5,a5,0x10
80002f74:	0037f793          	andi	a5,a5,3
80002f78:	80005737          	lui	a4,0x80005
80002f7c:	14870713          	addi	a4,a4,328 # 80005148 <intpat>
80002f80:	00279793          	slli	a5,a5,0x2
80002f84:	00f707b3          	add	a5,a4,a5
80002f88:	0007a783          	lw	a5,0(a5)
80002f8c:	fef42023          	sw	a5,-32(s0)
                next = 4;
80002f90:	00400793          	li	a5,4
80002f94:	fef42423          	sw	a5,-24(s0)
                break;
80002f98:	0c80006f          	j	80003060 <core_init_state+0x228>
            case 3: /* float */
            case 4: /* float */
                buf  = floatpat[(seed >> 3) & 0x3];
80002f9c:	fda41783          	lh	a5,-38(s0)
80002fa0:	4037d793          	srai	a5,a5,0x3
80002fa4:	01079793          	slli	a5,a5,0x10
80002fa8:	4107d793          	srai	a5,a5,0x10
80002fac:	01079793          	slli	a5,a5,0x10
80002fb0:	0107d793          	srli	a5,a5,0x10
80002fb4:	0037f793          	andi	a5,a5,3
80002fb8:	80005737          	lui	a4,0x80005
80002fbc:	15870713          	addi	a4,a4,344 # 80005158 <floatpat>
80002fc0:	00279793          	slli	a5,a5,0x2
80002fc4:	00f707b3          	add	a5,a4,a5
80002fc8:	0007a783          	lw	a5,0(a5)
80002fcc:	fef42023          	sw	a5,-32(s0)
                next = 8;
80002fd0:	00800793          	li	a5,8
80002fd4:	fef42423          	sw	a5,-24(s0)
                break;
80002fd8:	0880006f          	j	80003060 <core_init_state+0x228>
            case 5: /* scientific */
            case 6: /* scientific */
                buf  = scipat[(seed >> 3) & 0x3];
80002fdc:	fda41783          	lh	a5,-38(s0)
80002fe0:	4037d793          	srai	a5,a5,0x3
80002fe4:	01079793          	slli	a5,a5,0x10
80002fe8:	4107d793          	srai	a5,a5,0x10
80002fec:	01079793          	slli	a5,a5,0x10
80002ff0:	0107d793          	srli	a5,a5,0x10
80002ff4:	0037f793          	andi	a5,a5,3
80002ff8:	80005737          	lui	a4,0x80005
80002ffc:	16870713          	addi	a4,a4,360 # 80005168 <scipat>
80003000:	00279793          	slli	a5,a5,0x2
80003004:	00f707b3          	add	a5,a4,a5
80003008:	0007a783          	lw	a5,0(a5)
8000300c:	fef42023          	sw	a5,-32(s0)
                next = 8;
80003010:	00800793          	li	a5,8
80003014:	fef42423          	sw	a5,-24(s0)
                break;
80003018:	0480006f          	j	80003060 <core_init_state+0x228>
            case 7: /* invalid */
                buf  = errpat[(seed >> 3) & 0x3];
8000301c:	fda41783          	lh	a5,-38(s0)
80003020:	4037d793          	srai	a5,a5,0x3
80003024:	01079793          	slli	a5,a5,0x10
80003028:	4107d793          	srai	a5,a5,0x10
8000302c:	01079793          	slli	a5,a5,0x10
80003030:	0107d793          	srli	a5,a5,0x10
80003034:	0037f793          	andi	a5,a5,3
80003038:	80005737          	lui	a4,0x80005
8000303c:	17870713          	addi	a4,a4,376 # 80005178 <errpat>
80003040:	00279793          	slli	a5,a5,0x2
80003044:	00f707b3          	add	a5,a4,a5
80003048:	0007a783          	lw	a5,0(a5)
8000304c:	fef42023          	sw	a5,-32(s0)
                next = 8;
80003050:	00800793          	li	a5,8
80003054:	fef42423          	sw	a5,-24(s0)
                break;
80003058:	0080006f          	j	80003060 <core_init_state+0x228>
            default: /* Never happen, just to make some compilers happy */
                break;
8000305c:	00000013          	nop
    while ((total + next + 1) < size)
80003060:	fec42703          	lw	a4,-20(s0)
80003064:	fe842783          	lw	a5,-24(s0)
80003068:	00f707b3          	add	a5,a4,a5
8000306c:	00178793          	addi	a5,a5,1
80003070:	fdc42703          	lw	a4,-36(s0)
80003074:	e0e7e2e3          	bltu	a5,a4,80002e78 <core_init_state+0x40>
        }
    }
    size++;
80003078:	fdc42783          	lw	a5,-36(s0)
8000307c:	00178793          	addi	a5,a5,1
80003080:	fcf42e23          	sw	a5,-36(s0)
    while (total < size)
80003084:	0200006f          	j	800030a4 <core_init_state+0x26c>
    { /* fill the rest with 0 */
        *(p + total) = 0;
80003088:	fd442703          	lw	a4,-44(s0)
8000308c:	fec42783          	lw	a5,-20(s0)
80003090:	00f707b3          	add	a5,a4,a5
80003094:	00078023          	sb	zero,0(a5)
        total++;
80003098:	fec42783          	lw	a5,-20(s0)
8000309c:	00178793          	addi	a5,a5,1
800030a0:	fef42623          	sw	a5,-20(s0)
    while (total < size)
800030a4:	fec42703          	lw	a4,-20(s0)
800030a8:	fdc42783          	lw	a5,-36(s0)
800030ac:	fcf76ee3          	bltu	a4,a5,80003088 <core_init_state+0x250>
    }
#if CORE_DEBUG
    ee_printf("State Input: %s\n", start);
#endif
}
800030b0:	00000013          	nop
800030b4:	00000013          	nop
800030b8:	02c12083          	lw	ra,44(sp)
800030bc:	02812403          	lw	s0,40(sp)
800030c0:	03010113          	addi	sp,sp,48
800030c4:	00008067          	ret

800030c8 <ee_isdigit>:

static ee_u8
ee_isdigit(ee_u8 c)
{
800030c8:	fd010113          	addi	sp,sp,-48
800030cc:	02112623          	sw	ra,44(sp)
800030d0:	02812423          	sw	s0,40(sp)
800030d4:	03010413          	addi	s0,sp,48
800030d8:	00050793          	mv	a5,a0
800030dc:	fcf40fa3          	sb	a5,-33(s0)
    ee_u8 retval;
    retval = ((c >= '0') & (c <= '9')) ? 1 : 0;
800030e0:	fdf44783          	lbu	a5,-33(s0)
800030e4:	0307b793          	sltiu	a5,a5,48
800030e8:	0017b793          	seqz	a5,a5
800030ec:	0ff7f713          	zext.b	a4,a5
800030f0:	fdf44783          	lbu	a5,-33(s0)
800030f4:	03a7b793          	sltiu	a5,a5,58
800030f8:	0ff7f793          	zext.b	a5,a5
800030fc:	00f777b3          	and	a5,a4,a5
80003100:	0ff7f793          	zext.b	a5,a5
80003104:	fef407a3          	sb	a5,-17(s0)
    return retval;
80003108:	fef44783          	lbu	a5,-17(s0)
}
8000310c:	00078513          	mv	a0,a5
80003110:	02c12083          	lw	ra,44(sp)
80003114:	02812403          	lw	s0,40(sp)
80003118:	03010113          	addi	sp,sp,48
8000311c:	00008067          	ret

80003120 <core_state_transition>:
   end state is returned (either specific format determined or invalid).
*/

enum CORE_STATE
core_state_transition(ee_u8 **instr, ee_u32 *transition_count)
{
80003120:	fd010113          	addi	sp,sp,-48
80003124:	02112623          	sw	ra,44(sp)
80003128:	02812423          	sw	s0,40(sp)
8000312c:	03010413          	addi	s0,sp,48
80003130:	fca42e23          	sw	a0,-36(s0)
80003134:	fcb42c23          	sw	a1,-40(s0)
    ee_u8 *         str = *instr;
80003138:	fdc42783          	lw	a5,-36(s0)
8000313c:	0007a783          	lw	a5,0(a5)
80003140:	fef42623          	sw	a5,-20(s0)
    ee_u8           NEXT_SYMBOL;
    enum CORE_STATE state = CORE_START;
80003144:	fe042423          	sw	zero,-24(s0)
    for (; *str && state != CORE_INVALID; str++)
80003148:	3a00006f          	j	800034e8 <core_state_transition+0x3c8>
    {
        NEXT_SYMBOL = *str;
8000314c:	fec42783          	lw	a5,-20(s0)
80003150:	0007c783          	lbu	a5,0(a5)
80003154:	fef403a3          	sb	a5,-25(s0)
        if (NEXT_SYMBOL == ',') /* end of this input */
80003158:	fe744703          	lbu	a4,-25(s0)
8000315c:	02c00793          	li	a5,44
80003160:	00f71a63          	bne	a4,a5,80003174 <core_state_transition+0x54>
        {
            str++;
80003164:	fec42783          	lw	a5,-20(s0)
80003168:	00178793          	addi	a5,a5,1
8000316c:	fef42623          	sw	a5,-20(s0)
            break;
80003170:	3900006f          	j	80003500 <core_state_transition+0x3e0>
        }
        switch (state)
80003174:	fe842703          	lw	a4,-24(s0)
80003178:	00700793          	li	a5,7
8000317c:	30f70863          	beq	a4,a5,8000348c <core_state_transition+0x36c>
80003180:	fe842703          	lw	a4,-24(s0)
80003184:	00700793          	li	a5,7
80003188:	32e7ec63          	bltu	a5,a4,800034c0 <core_state_transition+0x3a0>
8000318c:	fe842703          	lw	a4,-24(s0)
80003190:	00600793          	li	a5,6
80003194:	2af70263          	beq	a4,a5,80003438 <core_state_transition+0x318>
80003198:	fe842703          	lw	a4,-24(s0)
8000319c:	00600793          	li	a5,6
800031a0:	32e7e063          	bltu	a5,a4,800034c0 <core_state_transition+0x3a0>
800031a4:	fe842703          	lw	a4,-24(s0)
800031a8:	00500793          	li	a5,5
800031ac:	1cf70463          	beq	a4,a5,80003374 <core_state_transition+0x254>
800031b0:	fe842703          	lw	a4,-24(s0)
800031b4:	00500793          	li	a5,5
800031b8:	30e7e463          	bltu	a5,a4,800034c0 <core_state_transition+0x3a0>
800031bc:	fe842703          	lw	a4,-24(s0)
800031c0:	00400793          	li	a5,4
800031c4:	14f70863          	beq	a4,a5,80003314 <core_state_transition+0x1f4>
800031c8:	fe842703          	lw	a4,-24(s0)
800031cc:	00400793          	li	a5,4
800031d0:	2ee7e863          	bltu	a5,a4,800034c0 <core_state_transition+0x3a0>
800031d4:	fe842703          	lw	a4,-24(s0)
800031d8:	00300793          	li	a5,3
800031dc:	20f70263          	beq	a4,a5,800033e0 <core_state_transition+0x2c0>
800031e0:	fe842703          	lw	a4,-24(s0)
800031e4:	00300793          	li	a5,3
800031e8:	2ce7ec63          	bltu	a5,a4,800034c0 <core_state_transition+0x3a0>
800031ec:	fe842783          	lw	a5,-24(s0)
800031f0:	00078a63          	beqz	a5,80003204 <core_state_transition+0xe4>
800031f4:	fe842703          	lw	a4,-24(s0)
800031f8:	00200793          	li	a5,2
800031fc:	08f70c63          	beq	a4,a5,80003294 <core_state_transition+0x174>
                    state = CORE_INVALID;
                    transition_count[CORE_INVALID]++;
                }
                break;
            default:
                break;
80003200:	2c00006f          	j	800034c0 <core_state_transition+0x3a0>
                if (ee_isdigit(NEXT_SYMBOL))
80003204:	fe744783          	lbu	a5,-25(s0)
80003208:	00078513          	mv	a0,a5
8000320c:	ebdff0ef          	jal	800030c8 <ee_isdigit>
80003210:	00050793          	mv	a5,a0
80003214:	00078863          	beqz	a5,80003224 <core_state_transition+0x104>
                    state = CORE_INT;
80003218:	00400793          	li	a5,4
8000321c:	fef42423          	sw	a5,-24(s0)
80003220:	05c0006f          	j	8000327c <core_state_transition+0x15c>
                else if (NEXT_SYMBOL == '+' || NEXT_SYMBOL == '-')
80003224:	fe744703          	lbu	a4,-25(s0)
80003228:	02b00793          	li	a5,43
8000322c:	00f70863          	beq	a4,a5,8000323c <core_state_transition+0x11c>
80003230:	fe744703          	lbu	a4,-25(s0)
80003234:	02d00793          	li	a5,45
80003238:	00f71863          	bne	a4,a5,80003248 <core_state_transition+0x128>
                    state = CORE_S1;
8000323c:	00200793          	li	a5,2
80003240:	fef42423          	sw	a5,-24(s0)
80003244:	0380006f          	j	8000327c <core_state_transition+0x15c>
                else if (NEXT_SYMBOL == '.')
80003248:	fe744703          	lbu	a4,-25(s0)
8000324c:	02e00793          	li	a5,46
80003250:	00f71863          	bne	a4,a5,80003260 <core_state_transition+0x140>
                    state = CORE_FLOAT;
80003254:	00500793          	li	a5,5
80003258:	fef42423          	sw	a5,-24(s0)
8000325c:	0200006f          	j	8000327c <core_state_transition+0x15c>
                    state = CORE_INVALID;
80003260:	00100793          	li	a5,1
80003264:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_INVALID]++;
80003268:	fd842783          	lw	a5,-40(s0)
8000326c:	00478793          	addi	a5,a5,4
80003270:	0007a703          	lw	a4,0(a5)
80003274:	00170713          	addi	a4,a4,1
80003278:	00e7a023          	sw	a4,0(a5)
                transition_count[CORE_START]++;
8000327c:	fd842783          	lw	a5,-40(s0)
80003280:	0007a783          	lw	a5,0(a5)
80003284:	00178713          	addi	a4,a5,1
80003288:	fd842783          	lw	a5,-40(s0)
8000328c:	00e7a023          	sw	a4,0(a5)
                break;
80003290:	24c0006f          	j	800034dc <core_state_transition+0x3bc>
                if (ee_isdigit(NEXT_SYMBOL))
80003294:	fe744783          	lbu	a5,-25(s0)
80003298:	00078513          	mv	a0,a5
8000329c:	e2dff0ef          	jal	800030c8 <ee_isdigit>
800032a0:	00050793          	mv	a5,a0
800032a4:	02078263          	beqz	a5,800032c8 <core_state_transition+0x1a8>
                    state = CORE_INT;
800032a8:	00400793          	li	a5,4
800032ac:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_S1]++;
800032b0:	fd842783          	lw	a5,-40(s0)
800032b4:	00878793          	addi	a5,a5,8
800032b8:	0007a703          	lw	a4,0(a5)
800032bc:	00170713          	addi	a4,a4,1
800032c0:	00e7a023          	sw	a4,0(a5)
                break;
800032c4:	2180006f          	j	800034dc <core_state_transition+0x3bc>
                else if (NEXT_SYMBOL == '.')
800032c8:	fe744703          	lbu	a4,-25(s0)
800032cc:	02e00793          	li	a5,46
800032d0:	02f71263          	bne	a4,a5,800032f4 <core_state_transition+0x1d4>
                    state = CORE_FLOAT;
800032d4:	00500793          	li	a5,5
800032d8:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_S1]++;
800032dc:	fd842783          	lw	a5,-40(s0)
800032e0:	00878793          	addi	a5,a5,8
800032e4:	0007a703          	lw	a4,0(a5)
800032e8:	00170713          	addi	a4,a4,1
800032ec:	00e7a023          	sw	a4,0(a5)
                break;
800032f0:	1ec0006f          	j	800034dc <core_state_transition+0x3bc>
                    state = CORE_INVALID;
800032f4:	00100793          	li	a5,1
800032f8:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_S1]++;
800032fc:	fd842783          	lw	a5,-40(s0)
80003300:	00878793          	addi	a5,a5,8
80003304:	0007a703          	lw	a4,0(a5)
80003308:	00170713          	addi	a4,a4,1
8000330c:	00e7a023          	sw	a4,0(a5)
                break;
80003310:	1cc0006f          	j	800034dc <core_state_transition+0x3bc>
                if (NEXT_SYMBOL == '.')
80003314:	fe744703          	lbu	a4,-25(s0)
80003318:	02e00793          	li	a5,46
8000331c:	02f71263          	bne	a4,a5,80003340 <core_state_transition+0x220>
                    state = CORE_FLOAT;
80003320:	00500793          	li	a5,5
80003324:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_INT]++;
80003328:	fd842783          	lw	a5,-40(s0)
8000332c:	01078793          	addi	a5,a5,16
80003330:	0007a703          	lw	a4,0(a5)
80003334:	00170713          	addi	a4,a4,1
80003338:	00e7a023          	sw	a4,0(a5)
                break;
8000333c:	18c0006f          	j	800034c8 <core_state_transition+0x3a8>
                else if (!ee_isdigit(NEXT_SYMBOL))
80003340:	fe744783          	lbu	a5,-25(s0)
80003344:	00078513          	mv	a0,a5
80003348:	d81ff0ef          	jal	800030c8 <ee_isdigit>
8000334c:	00050793          	mv	a5,a0
80003350:	16079c63          	bnez	a5,800034c8 <core_state_transition+0x3a8>
                    state = CORE_INVALID;
80003354:	00100793          	li	a5,1
80003358:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_INT]++;
8000335c:	fd842783          	lw	a5,-40(s0)
80003360:	01078793          	addi	a5,a5,16
80003364:	0007a703          	lw	a4,0(a5)
80003368:	00170713          	addi	a4,a4,1
8000336c:	00e7a023          	sw	a4,0(a5)
                break;
80003370:	1580006f          	j	800034c8 <core_state_transition+0x3a8>
                if (NEXT_SYMBOL == 'E' || NEXT_SYMBOL == 'e')
80003374:	fe744703          	lbu	a4,-25(s0)
80003378:	04500793          	li	a5,69
8000337c:	00f70863          	beq	a4,a5,8000338c <core_state_transition+0x26c>
80003380:	fe744703          	lbu	a4,-25(s0)
80003384:	06500793          	li	a5,101
80003388:	02f71263          	bne	a4,a5,800033ac <core_state_transition+0x28c>
                    state = CORE_S2;
8000338c:	00300793          	li	a5,3
80003390:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_FLOAT]++;
80003394:	fd842783          	lw	a5,-40(s0)
80003398:	01478793          	addi	a5,a5,20
8000339c:	0007a703          	lw	a4,0(a5)
800033a0:	00170713          	addi	a4,a4,1
800033a4:	00e7a023          	sw	a4,0(a5)
                break;
800033a8:	1280006f          	j	800034d0 <core_state_transition+0x3b0>
                else if (!ee_isdigit(NEXT_SYMBOL))
800033ac:	fe744783          	lbu	a5,-25(s0)
800033b0:	00078513          	mv	a0,a5
800033b4:	d15ff0ef          	jal	800030c8 <ee_isdigit>
800033b8:	00050793          	mv	a5,a0
800033bc:	10079a63          	bnez	a5,800034d0 <core_state_transition+0x3b0>
                    state = CORE_INVALID;
800033c0:	00100793          	li	a5,1
800033c4:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_FLOAT]++;
800033c8:	fd842783          	lw	a5,-40(s0)
800033cc:	01478793          	addi	a5,a5,20
800033d0:	0007a703          	lw	a4,0(a5)
800033d4:	00170713          	addi	a4,a4,1
800033d8:	00e7a023          	sw	a4,0(a5)
                break;
800033dc:	0f40006f          	j	800034d0 <core_state_transition+0x3b0>
                if (NEXT_SYMBOL == '+' || NEXT_SYMBOL == '-')
800033e0:	fe744703          	lbu	a4,-25(s0)
800033e4:	02b00793          	li	a5,43
800033e8:	00f70863          	beq	a4,a5,800033f8 <core_state_transition+0x2d8>
800033ec:	fe744703          	lbu	a4,-25(s0)
800033f0:	02d00793          	li	a5,45
800033f4:	02f71263          	bne	a4,a5,80003418 <core_state_transition+0x2f8>
                    state = CORE_EXPONENT;
800033f8:	00600793          	li	a5,6
800033fc:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_S2]++;
80003400:	fd842783          	lw	a5,-40(s0)
80003404:	00c78793          	addi	a5,a5,12
80003408:	0007a703          	lw	a4,0(a5)
8000340c:	00170713          	addi	a4,a4,1
80003410:	00e7a023          	sw	a4,0(a5)
                break;
80003414:	0c80006f          	j	800034dc <core_state_transition+0x3bc>
                    state = CORE_INVALID;
80003418:	00100793          	li	a5,1
8000341c:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_S2]++;
80003420:	fd842783          	lw	a5,-40(s0)
80003424:	00c78793          	addi	a5,a5,12
80003428:	0007a703          	lw	a4,0(a5)
8000342c:	00170713          	addi	a4,a4,1
80003430:	00e7a023          	sw	a4,0(a5)
                break;
80003434:	0a80006f          	j	800034dc <core_state_transition+0x3bc>
                if (ee_isdigit(NEXT_SYMBOL))
80003438:	fe744783          	lbu	a5,-25(s0)
8000343c:	00078513          	mv	a0,a5
80003440:	c89ff0ef          	jal	800030c8 <ee_isdigit>
80003444:	00050793          	mv	a5,a0
80003448:	02078263          	beqz	a5,8000346c <core_state_transition+0x34c>
                    state = CORE_SCIENTIFIC;
8000344c:	00700793          	li	a5,7
80003450:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_EXPONENT]++;
80003454:	fd842783          	lw	a5,-40(s0)
80003458:	01878793          	addi	a5,a5,24
8000345c:	0007a703          	lw	a4,0(a5)
80003460:	00170713          	addi	a4,a4,1
80003464:	00e7a023          	sw	a4,0(a5)
                break;
80003468:	0740006f          	j	800034dc <core_state_transition+0x3bc>
                    state = CORE_INVALID;
8000346c:	00100793          	li	a5,1
80003470:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_EXPONENT]++;
80003474:	fd842783          	lw	a5,-40(s0)
80003478:	01878793          	addi	a5,a5,24
8000347c:	0007a703          	lw	a4,0(a5)
80003480:	00170713          	addi	a4,a4,1
80003484:	00e7a023          	sw	a4,0(a5)
                break;
80003488:	0540006f          	j	800034dc <core_state_transition+0x3bc>
                if (!ee_isdigit(NEXT_SYMBOL))
8000348c:	fe744783          	lbu	a5,-25(s0)
80003490:	00078513          	mv	a0,a5
80003494:	c35ff0ef          	jal	800030c8 <ee_isdigit>
80003498:	00050793          	mv	a5,a0
8000349c:	02079e63          	bnez	a5,800034d8 <core_state_transition+0x3b8>
                    state = CORE_INVALID;
800034a0:	00100793          	li	a5,1
800034a4:	fef42423          	sw	a5,-24(s0)
                    transition_count[CORE_INVALID]++;
800034a8:	fd842783          	lw	a5,-40(s0)
800034ac:	00478793          	addi	a5,a5,4
800034b0:	0007a703          	lw	a4,0(a5)
800034b4:	00170713          	addi	a4,a4,1
800034b8:	00e7a023          	sw	a4,0(a5)
                break;
800034bc:	01c0006f          	j	800034d8 <core_state_transition+0x3b8>
                break;
800034c0:	00000013          	nop
800034c4:	0180006f          	j	800034dc <core_state_transition+0x3bc>
                break;
800034c8:	00000013          	nop
800034cc:	0100006f          	j	800034dc <core_state_transition+0x3bc>
                break;
800034d0:	00000013          	nop
800034d4:	0080006f          	j	800034dc <core_state_transition+0x3bc>
                break;
800034d8:	00000013          	nop
    for (; *str && state != CORE_INVALID; str++)
800034dc:	fec42783          	lw	a5,-20(s0)
800034e0:	00178793          	addi	a5,a5,1
800034e4:	fef42623          	sw	a5,-20(s0)
800034e8:	fec42783          	lw	a5,-20(s0)
800034ec:	0007c783          	lbu	a5,0(a5)
800034f0:	00078863          	beqz	a5,80003500 <core_state_transition+0x3e0>
800034f4:	fe842703          	lw	a4,-24(s0)
800034f8:	00100793          	li	a5,1
800034fc:	c4f718e3          	bne	a4,a5,8000314c <core_state_transition+0x2c>
        }
    }
    *instr = str;
80003500:	fdc42783          	lw	a5,-36(s0)
80003504:	fec42703          	lw	a4,-20(s0)
80003508:	00e7a023          	sw	a4,0(a5)
    return state;
8000350c:	fe842783          	lw	a5,-24(s0)
}
80003510:	00078513          	mv	a0,a5
80003514:	02c12083          	lw	ra,44(sp)
80003518:	02812403          	lw	s0,40(sp)
8000351c:	03010113          	addi	sp,sp,48
80003520:	00008067          	ret

80003524 <get_seed_32>:
extern volatile ee_s32 seed3_volatile;
extern volatile ee_s32 seed4_volatile;
extern volatile ee_s32 seed5_volatile;
ee_s32
get_seed_32(int i)
{
80003524:	fd010113          	addi	sp,sp,-48
80003528:	02112623          	sw	ra,44(sp)
8000352c:	02812423          	sw	s0,40(sp)
80003530:	03010413          	addi	s0,sp,48
80003534:	fca42e23          	sw	a0,-36(s0)
    ee_s32 retval;
    switch (i)
80003538:	fdc42703          	lw	a4,-36(s0)
8000353c:	00500793          	li	a5,5
80003540:	08f70e63          	beq	a4,a5,800035dc <get_seed_32+0xb8>
80003544:	fdc42703          	lw	a4,-36(s0)
80003548:	00500793          	li	a5,5
8000354c:	0ae7c063          	blt	a5,a4,800035ec <get_seed_32+0xc8>
80003550:	fdc42703          	lw	a4,-36(s0)
80003554:	00400793          	li	a5,4
80003558:	06f70a63          	beq	a4,a5,800035cc <get_seed_32+0xa8>
8000355c:	fdc42703          	lw	a4,-36(s0)
80003560:	00400793          	li	a5,4
80003564:	08e7c463          	blt	a5,a4,800035ec <get_seed_32+0xc8>
80003568:	fdc42703          	lw	a4,-36(s0)
8000356c:	00300793          	li	a5,3
80003570:	04f70663          	beq	a4,a5,800035bc <get_seed_32+0x98>
80003574:	fdc42703          	lw	a4,-36(s0)
80003578:	00300793          	li	a5,3
8000357c:	06e7c863          	blt	a5,a4,800035ec <get_seed_32+0xc8>
80003580:	fdc42703          	lw	a4,-36(s0)
80003584:	00100793          	li	a5,1
80003588:	00f70a63          	beq	a4,a5,8000359c <get_seed_32+0x78>
8000358c:	fdc42703          	lw	a4,-36(s0)
80003590:	00200793          	li	a5,2
80003594:	00f70c63          	beq	a4,a5,800035ac <get_seed_32+0x88>
80003598:	0540006f          	j	800035ec <get_seed_32+0xc8>
    {
        case 1:
            retval = seed1_volatile;
8000359c:	800057b7          	lui	a5,0x80005
800035a0:	1887a783          	lw	a5,392(a5) # 80005188 <seed1_volatile>
800035a4:	fef42623          	sw	a5,-20(s0)
            break;
800035a8:	04c0006f          	j	800035f4 <get_seed_32+0xd0>
        case 2:
            retval = seed2_volatile;
800035ac:	800057b7          	lui	a5,0x80005
800035b0:	18c7a783          	lw	a5,396(a5) # 8000518c <seed2_volatile>
800035b4:	fef42623          	sw	a5,-20(s0)
            break;
800035b8:	03c0006f          	j	800035f4 <get_seed_32+0xd0>
        case 3:
            retval = seed3_volatile;
800035bc:	800057b7          	lui	a5,0x80005
800035c0:	1907a783          	lw	a5,400(a5) # 80005190 <seed3_volatile>
800035c4:	fef42623          	sw	a5,-20(s0)
            break;
800035c8:	02c0006f          	j	800035f4 <get_seed_32+0xd0>
        case 4:
            retval = seed4_volatile;
800035cc:	800057b7          	lui	a5,0x80005
800035d0:	1947a783          	lw	a5,404(a5) # 80005194 <seed4_volatile>
800035d4:	fef42623          	sw	a5,-20(s0)
            break;
800035d8:	01c0006f          	j	800035f4 <get_seed_32+0xd0>
        case 5:
            retval = seed5_volatile;
800035dc:	800057b7          	lui	a5,0x80005
800035e0:	1ac7a783          	lw	a5,428(a5) # 800051ac <seed5_volatile>
800035e4:	fef42623          	sw	a5,-20(s0)
            break;
800035e8:	00c0006f          	j	800035f4 <get_seed_32+0xd0>
        default:
            retval = 0;
800035ec:	fe042623          	sw	zero,-20(s0)
            break;
800035f0:	00000013          	nop
    }
    return retval;
800035f4:	fec42783          	lw	a5,-20(s0)
}
800035f8:	00078513          	mv	a0,a5
800035fc:	02c12083          	lw	ra,44(sp)
80003600:	02812403          	lw	s0,40(sp)
80003604:	03010113          	addi	sp,sp,48
80003608:	00008067          	ret

8000360c <crcu8>:
        Service functions to calculate 16b CRC code.

*/
ee_u16
crcu8(ee_u8 data, ee_u16 crc)
{
8000360c:	fd010113          	addi	sp,sp,-48
80003610:	02112623          	sw	ra,44(sp)
80003614:	02812423          	sw	s0,40(sp)
80003618:	03010413          	addi	s0,sp,48
8000361c:	00050793          	mv	a5,a0
80003620:	00058713          	mv	a4,a1
80003624:	fcf40fa3          	sb	a5,-33(s0)
80003628:	00070793          	mv	a5,a4
8000362c:	fcf41e23          	sh	a5,-36(s0)
    ee_u8 i = 0, x16 = 0, carry = 0;
80003630:	fe0407a3          	sb	zero,-17(s0)
80003634:	fe0406a3          	sb	zero,-19(s0)
80003638:	fe040723          	sb	zero,-18(s0)

    for (i = 0; i < 8; i++)
8000363c:	fe0407a3          	sb	zero,-17(s0)
80003640:	0bc0006f          	j	800036fc <crcu8+0xf0>
    {
        x16 = (ee_u8)((data & 1) ^ ((ee_u8)crc & 1));
80003644:	fdc45783          	lhu	a5,-36(s0)
80003648:	01879713          	slli	a4,a5,0x18
8000364c:	41875713          	srai	a4,a4,0x18
80003650:	fdf40783          	lb	a5,-33(s0)
80003654:	00f747b3          	xor	a5,a4,a5
80003658:	01879793          	slli	a5,a5,0x18
8000365c:	4187d793          	srai	a5,a5,0x18
80003660:	0ff7f793          	zext.b	a5,a5
80003664:	0017f793          	andi	a5,a5,1
80003668:	fef406a3          	sb	a5,-19(s0)
        data >>= 1;
8000366c:	fdf44783          	lbu	a5,-33(s0)
80003670:	0017d793          	srli	a5,a5,0x1
80003674:	fcf40fa3          	sb	a5,-33(s0)

        if (x16 == 1)
80003678:	fed44703          	lbu	a4,-19(s0)
8000367c:	00100793          	li	a5,1
80003680:	02f71463          	bne	a4,a5,800036a8 <crcu8+0x9c>
        {
            crc ^= 0x4002;
80003684:	fdc45783          	lhu	a5,-36(s0)
80003688:	00078713          	mv	a4,a5
8000368c:	000047b7          	lui	a5,0x4
80003690:	00278793          	addi	a5,a5,2 # 4002 <_start-0x7fffbffe>
80003694:	00f747b3          	xor	a5,a4,a5
80003698:	fcf41e23          	sh	a5,-36(s0)
            carry = 1;
8000369c:	00100793          	li	a5,1
800036a0:	fef40723          	sb	a5,-18(s0)
800036a4:	0080006f          	j	800036ac <crcu8+0xa0>
        }
        else
            carry = 0;
800036a8:	fe040723          	sb	zero,-18(s0)
        crc >>= 1;
800036ac:	fdc45783          	lhu	a5,-36(s0)
800036b0:	0017d793          	srli	a5,a5,0x1
800036b4:	fcf41e23          	sh	a5,-36(s0)
        if (carry)
800036b8:	fee44783          	lbu	a5,-18(s0)
800036bc:	00078e63          	beqz	a5,800036d8 <crcu8+0xcc>
            crc |= 0x8000;
800036c0:	fdc45783          	lhu	a5,-36(s0)
800036c4:	00078713          	mv	a4,a5
800036c8:	ffff87b7          	lui	a5,0xffff8
800036cc:	00f767b3          	or	a5,a4,a5
800036d0:	fcf41e23          	sh	a5,-36(s0)
800036d4:	01c0006f          	j	800036f0 <crcu8+0xe4>
        else
            crc &= 0x7fff;
800036d8:	fdc45783          	lhu	a5,-36(s0)
800036dc:	00078713          	mv	a4,a5
800036e0:	000087b7          	lui	a5,0x8
800036e4:	fff78793          	addi	a5,a5,-1 # 7fff <_start-0x7fff8001>
800036e8:	00f777b3          	and	a5,a4,a5
800036ec:	fcf41e23          	sh	a5,-36(s0)
    for (i = 0; i < 8; i++)
800036f0:	fef44783          	lbu	a5,-17(s0)
800036f4:	00178793          	addi	a5,a5,1
800036f8:	fef407a3          	sb	a5,-17(s0)
800036fc:	fef44703          	lbu	a4,-17(s0)
80003700:	00700793          	li	a5,7
80003704:	f4e7f0e3          	bgeu	a5,a4,80003644 <crcu8+0x38>
    }
    return crc;
80003708:	fdc45783          	lhu	a5,-36(s0)
}
8000370c:	00078513          	mv	a0,a5
80003710:	02c12083          	lw	ra,44(sp)
80003714:	02812403          	lw	s0,40(sp)
80003718:	03010113          	addi	sp,sp,48
8000371c:	00008067          	ret

80003720 <crcu16>:
ee_u16
crcu16(ee_u16 newval, ee_u16 crc)
{
80003720:	fe010113          	addi	sp,sp,-32
80003724:	00112e23          	sw	ra,28(sp)
80003728:	00812c23          	sw	s0,24(sp)
8000372c:	02010413          	addi	s0,sp,32
80003730:	00050793          	mv	a5,a0
80003734:	00058713          	mv	a4,a1
80003738:	fef41723          	sh	a5,-18(s0)
8000373c:	00070793          	mv	a5,a4
80003740:	fef41623          	sh	a5,-20(s0)
    crc = crcu8((ee_u8)(newval), crc);
80003744:	fee45783          	lhu	a5,-18(s0)
80003748:	0ff7f793          	zext.b	a5,a5
8000374c:	fec45703          	lhu	a4,-20(s0)
80003750:	00070593          	mv	a1,a4
80003754:	00078513          	mv	a0,a5
80003758:	eb5ff0ef          	jal	8000360c <crcu8>
8000375c:	00050793          	mv	a5,a0
80003760:	fef41623          	sh	a5,-20(s0)
    crc = crcu8((ee_u8)((newval) >> 8), crc);
80003764:	fee45783          	lhu	a5,-18(s0)
80003768:	0087d793          	srli	a5,a5,0x8
8000376c:	01079793          	slli	a5,a5,0x10
80003770:	0107d793          	srli	a5,a5,0x10
80003774:	0ff7f793          	zext.b	a5,a5
80003778:	fec45703          	lhu	a4,-20(s0)
8000377c:	00070593          	mv	a1,a4
80003780:	00078513          	mv	a0,a5
80003784:	e89ff0ef          	jal	8000360c <crcu8>
80003788:	00050793          	mv	a5,a0
8000378c:	fef41623          	sh	a5,-20(s0)
    return crc;
80003790:	fec45783          	lhu	a5,-20(s0)
}
80003794:	00078513          	mv	a0,a5
80003798:	01c12083          	lw	ra,28(sp)
8000379c:	01812403          	lw	s0,24(sp)
800037a0:	02010113          	addi	sp,sp,32
800037a4:	00008067          	ret

800037a8 <crcu32>:
ee_u16
crcu32(ee_u32 newval, ee_u16 crc)
{
800037a8:	fe010113          	addi	sp,sp,-32
800037ac:	00112e23          	sw	ra,28(sp)
800037b0:	00812c23          	sw	s0,24(sp)
800037b4:	02010413          	addi	s0,sp,32
800037b8:	fea42623          	sw	a0,-20(s0)
800037bc:	00058793          	mv	a5,a1
800037c0:	fef41523          	sh	a5,-22(s0)
    crc = crc16((ee_s16)newval, crc);
800037c4:	fec42783          	lw	a5,-20(s0)
800037c8:	01079793          	slli	a5,a5,0x10
800037cc:	4107d793          	srai	a5,a5,0x10
800037d0:	fea45703          	lhu	a4,-22(s0)
800037d4:	00070593          	mv	a1,a4
800037d8:	00078513          	mv	a0,a5
800037dc:	04c000ef          	jal	80003828 <crc16>
800037e0:	00050793          	mv	a5,a0
800037e4:	fef41523          	sh	a5,-22(s0)
    crc = crc16((ee_s16)(newval >> 16), crc);
800037e8:	fec42783          	lw	a5,-20(s0)
800037ec:	0107d793          	srli	a5,a5,0x10
800037f0:	01079793          	slli	a5,a5,0x10
800037f4:	4107d793          	srai	a5,a5,0x10
800037f8:	fea45703          	lhu	a4,-22(s0)
800037fc:	00070593          	mv	a1,a4
80003800:	00078513          	mv	a0,a5
80003804:	024000ef          	jal	80003828 <crc16>
80003808:	00050793          	mv	a5,a0
8000380c:	fef41523          	sh	a5,-22(s0)
    return crc;
80003810:	fea45783          	lhu	a5,-22(s0)
}
80003814:	00078513          	mv	a0,a5
80003818:	01c12083          	lw	ra,28(sp)
8000381c:	01812403          	lw	s0,24(sp)
80003820:	02010113          	addi	sp,sp,32
80003824:	00008067          	ret

80003828 <crc16>:
ee_u16
crc16(ee_s16 newval, ee_u16 crc)
{
80003828:	fe010113          	addi	sp,sp,-32
8000382c:	00112e23          	sw	ra,28(sp)
80003830:	00812c23          	sw	s0,24(sp)
80003834:	02010413          	addi	s0,sp,32
80003838:	00050793          	mv	a5,a0
8000383c:	00058713          	mv	a4,a1
80003840:	fef41723          	sh	a5,-18(s0)
80003844:	00070793          	mv	a5,a4
80003848:	fef41623          	sh	a5,-20(s0)
    return crcu16((ee_u16)newval, crc);
8000384c:	fee45783          	lhu	a5,-18(s0)
80003850:	fec45703          	lhu	a4,-20(s0)
80003854:	00070593          	mv	a1,a4
80003858:	00078513          	mv	a0,a5
8000385c:	ec5ff0ef          	jal	80003720 <crcu16>
80003860:	00050793          	mv	a5,a0
}
80003864:	00078513          	mv	a0,a5
80003868:	01c12083          	lw	ra,28(sp)
8000386c:	01812403          	lw	s0,24(sp)
80003870:	02010113          	addi	sp,sp,32
80003874:	00008067          	ret

80003878 <check_data_types>:

ee_u8
check_data_types()
{
80003878:	fe010113          	addi	sp,sp,-32
8000387c:	00112e23          	sw	ra,28(sp)
80003880:	00812c23          	sw	s0,24(sp)
80003884:	02010413          	addi	s0,sp,32
    ee_u8 retval = 0;
80003888:	fe0407a3          	sb	zero,-17(s0)
    {
        ee_printf(
            "ERROR: ee_ptr_int is not a datatype that holds an int pointer!\n");
        retval++;
    }
    if (retval > 0)
8000388c:	fef44783          	lbu	a5,-17(s0)
80003890:	00078863          	beqz	a5,800038a0 <check_data_types+0x28>
    {
        ee_printf("ERROR: Please modify the datatypes in core_portme.h!\n");
80003894:	800057b7          	lui	a5,0x80005
80003898:	08878513          	addi	a0,a5,136 # 80005088 <__modsi3+0x534>
8000389c:	158010ef          	jal	800049f4 <ee_printf>
    }
    return retval;
800038a0:	fef44783          	lbu	a5,-17(s0)
}
800038a4:	00078513          	mv	a0,a5
800038a8:	01c12083          	lw	ra,28(sp)
800038ac:	01812403          	lw	s0,24(sp)
800038b0:	02010113          	addi	sp,sp,32
800038b4:	00008067          	ret

800038b8 <barebones_clock>:
   cpu clock cycles performance counter etc. Sample implementation for standard
   time.h and windows.h definitions included.
*/
CORETIMETYPE
barebones_clock()
{
800038b8:	ff010113          	addi	sp,sp,-16
800038bc:	00112623          	sw	ra,12(sp)
800038c0:	00812423          	sw	s0,8(sp)
800038c4:	01010413          	addi	s0,sp,16
    
}
800038c8:	00000013          	nop
800038cc:	00078513          	mv	a0,a5
800038d0:	00c12083          	lw	ra,12(sp)
800038d4:	00812403          	lw	s0,8(sp)
800038d8:	01010113          	addi	sp,sp,16
800038dc:	00008067          	ret

800038e0 <start_time>:
   example code) or zeroing some system parameters - e.g. setting the cpu clocks
   cycles to 0.
*/
void
start_time(void)
{
800038e0:	ff010113          	addi	sp,sp,-16
800038e4:	00112623          	sw	ra,12(sp)
800038e8:	00812423          	sw	s0,8(sp)
800038ec:	01010413          	addi	s0,sp,16
    GETMYTIME(&start_time_val);
800038f0:	fc9ff0ef          	jal	800038b8 <barebones_clock>
800038f4:	00050713          	mv	a4,a0
800038f8:	800057b7          	lui	a5,0x80005
800038fc:	1ae7a223          	sw	a4,420(a5) # 800051a4 <start_time_val>
}
80003900:	00000013          	nop
80003904:	00c12083          	lw	ra,12(sp)
80003908:	00812403          	lw	s0,8(sp)
8000390c:	01010113          	addi	sp,sp,16
80003910:	00008067          	ret

80003914 <stop_time>:
   example code) or other system parameters - e.g. reading the current value of
   cpu cycles counter.
*/
void
stop_time(void)
{
80003914:	ff010113          	addi	sp,sp,-16
80003918:	00112623          	sw	ra,12(sp)
8000391c:	00812423          	sw	s0,8(sp)
80003920:	01010413          	addi	s0,sp,16
    GETMYTIME(&stop_time_val);
80003924:	f95ff0ef          	jal	800038b8 <barebones_clock>
80003928:	00050713          	mv	a4,a0
8000392c:	800057b7          	lui	a5,0x80005
80003930:	1ae7a423          	sw	a4,424(a5) # 800051a8 <stop_time_val>
}
80003934:	00000013          	nop
80003938:	00c12083          	lw	ra,12(sp)
8000393c:	00812403          	lw	s0,8(sp)
80003940:	01010113          	addi	sp,sp,16
80003944:	00008067          	ret

80003948 <get_time>:
   sample implementation returns millisecs by default, and the resolution is
   controlled by <TIMER_RES_DIVIDER>
*/
CORE_TICKS
get_time(void)
{
80003948:	ff010113          	addi	sp,sp,-16
8000394c:	00112623          	sw	ra,12(sp)
80003950:	00812423          	sw	s0,8(sp)
80003954:	01010413          	addi	s0,sp,16
    // CORE_TICKS elapsed
    //     = (CORE_TICKS)(MYTIMEDIFF(stop_time_val, start_time_val));
    // return elapsed;
    return 1;
80003958:	00100793          	li	a5,1
}
8000395c:	00078513          	mv	a0,a5
80003960:	00c12083          	lw	ra,12(sp)
80003964:	00812403          	lw	s0,8(sp)
80003968:	01010113          	addi	sp,sp,16
8000396c:	00008067          	ret

80003970 <time_in_secs>:
   floating point. Default implementation implemented by the EE_TICKS_PER_SEC
   macro above.
*/
secs_ret
time_in_secs(CORE_TICKS ticks)
{
80003970:	fe010113          	addi	sp,sp,-32
80003974:	00112e23          	sw	ra,28(sp)
80003978:	00812c23          	sw	s0,24(sp)
8000397c:	02010413          	addi	s0,sp,32
80003980:	fea42623          	sw	a0,-20(s0)
    // secs_ret retval = ((secs_ret)ticks) / (secs_ret)EE_TICKS_PER_SEC;
    // return retval;
    return 1;
80003984:	00100793          	li	a5,1
}
80003988:	00078513          	mv	a0,a5
8000398c:	01c12083          	lw	ra,28(sp)
80003990:	01812403          	lw	s0,24(sp)
80003994:	02010113          	addi	sp,sp,32
80003998:	00008067          	ret

8000399c <portable_init>:
        Target specific initialization code
        Test for some common mistakes.
*/
void
portable_init(core_portable *p, int *argc, char *argv[])
{
8000399c:	fe010113          	addi	sp,sp,-32
800039a0:	00112e23          	sw	ra,28(sp)
800039a4:	00812c23          	sw	s0,24(sp)
800039a8:	02010413          	addi	s0,sp,32
800039ac:	fea42623          	sw	a0,-20(s0)
800039b0:	feb42423          	sw	a1,-24(s0)
800039b4:	fec42223          	sw	a2,-28(s0)
//     if (sizeof(ee_u32) != 4)
//     {
//         ee_printf("ERROR! Please define ee_u32 to a 32b unsigned type!\n");
//     }
//     p->portable_id = 1;
}
800039b8:	00000013          	nop
800039bc:	01c12083          	lw	ra,28(sp)
800039c0:	01812403          	lw	s0,24(sp)
800039c4:	02010113          	addi	sp,sp,32
800039c8:	00008067          	ret

800039cc <portable_fini>:
/* Function : portable_fini
        Target specific final code
*/
void
portable_fini(core_portable *p)
{
800039cc:	fe010113          	addi	sp,sp,-32
800039d0:	00112e23          	sw	ra,28(sp)
800039d4:	00812c23          	sw	s0,24(sp)
800039d8:	02010413          	addi	s0,sp,32
800039dc:	fea42623          	sw	a0,-20(s0)
    p->portable_id = 0;
800039e0:	fec42783          	lw	a5,-20(s0)
800039e4:	00078023          	sb	zero,0(a5)
}
800039e8:	00000013          	nop
800039ec:	01c12083          	lw	ra,28(sp)
800039f0:	01812403          	lw	s0,24(sp)
800039f4:	02010113          	addi	sp,sp,32
800039f8:	00008067          	ret

800039fc <strnlen>:
static char *    upper_digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static ee_size_t strnlen(const char *s, ee_size_t count);

static ee_size_t
strnlen(const char *s, ee_size_t count)
{
800039fc:	fd010113          	addi	sp,sp,-48
80003a00:	02112623          	sw	ra,44(sp)
80003a04:	02812423          	sw	s0,40(sp)
80003a08:	03010413          	addi	s0,sp,48
80003a0c:	fca42e23          	sw	a0,-36(s0)
80003a10:	fcb42c23          	sw	a1,-40(s0)
    const char *sc;
    for (sc = s; *sc != '\0' && count--; ++sc)
80003a14:	fdc42783          	lw	a5,-36(s0)
80003a18:	fef42623          	sw	a5,-20(s0)
80003a1c:	0100006f          	j	80003a2c <strnlen+0x30>
80003a20:	fec42783          	lw	a5,-20(s0)
80003a24:	00178793          	addi	a5,a5,1
80003a28:	fef42623          	sw	a5,-20(s0)
80003a2c:	fec42783          	lw	a5,-20(s0)
80003a30:	0007c783          	lbu	a5,0(a5)
80003a34:	00078a63          	beqz	a5,80003a48 <strnlen+0x4c>
80003a38:	fd842783          	lw	a5,-40(s0)
80003a3c:	fff78713          	addi	a4,a5,-1
80003a40:	fce42c23          	sw	a4,-40(s0)
80003a44:	fc079ee3          	bnez	a5,80003a20 <strnlen+0x24>
        ;
    return sc - s;
80003a48:	fec42703          	lw	a4,-20(s0)
80003a4c:	fdc42783          	lw	a5,-36(s0)
80003a50:	40f707b3          	sub	a5,a4,a5
}
80003a54:	00078513          	mv	a0,a5
80003a58:	02c12083          	lw	ra,44(sp)
80003a5c:	02812403          	lw	s0,40(sp)
80003a60:	03010113          	addi	sp,sp,48
80003a64:	00008067          	ret

80003a68 <skip_atoi>:

static int
skip_atoi(const char **s)
{
80003a68:	fd010113          	addi	sp,sp,-48
80003a6c:	02112623          	sw	ra,44(sp)
80003a70:	02812423          	sw	s0,40(sp)
80003a74:	03010413          	addi	s0,sp,48
80003a78:	fca42e23          	sw	a0,-36(s0)
    int i = 0;
80003a7c:	fe042623          	sw	zero,-20(s0)
    while (is_digit(**s))
80003a80:	0400006f          	j	80003ac0 <skip_atoi+0x58>
        i = i * 10 + *((*s)++) - '0';
80003a84:	fec42703          	lw	a4,-20(s0)
80003a88:	00070793          	mv	a5,a4
80003a8c:	00279793          	slli	a5,a5,0x2
80003a90:	00e787b3          	add	a5,a5,a4
80003a94:	00179793          	slli	a5,a5,0x1
80003a98:	00078613          	mv	a2,a5
80003a9c:	fdc42783          	lw	a5,-36(s0)
80003aa0:	0007a783          	lw	a5,0(a5)
80003aa4:	00178693          	addi	a3,a5,1
80003aa8:	fdc42703          	lw	a4,-36(s0)
80003aac:	00d72023          	sw	a3,0(a4)
80003ab0:	0007c783          	lbu	a5,0(a5)
80003ab4:	00f607b3          	add	a5,a2,a5
80003ab8:	fd078793          	addi	a5,a5,-48
80003abc:	fef42623          	sw	a5,-20(s0)
    while (is_digit(**s))
80003ac0:	fdc42783          	lw	a5,-36(s0)
80003ac4:	0007a783          	lw	a5,0(a5)
80003ac8:	0007c703          	lbu	a4,0(a5)
80003acc:	02f00793          	li	a5,47
80003ad0:	00e7fc63          	bgeu	a5,a4,80003ae8 <skip_atoi+0x80>
80003ad4:	fdc42783          	lw	a5,-36(s0)
80003ad8:	0007a783          	lw	a5,0(a5)
80003adc:	0007c703          	lbu	a4,0(a5)
80003ae0:	03900793          	li	a5,57
80003ae4:	fae7f0e3          	bgeu	a5,a4,80003a84 <skip_atoi+0x1c>
    return i;
80003ae8:	fec42783          	lw	a5,-20(s0)
}
80003aec:	00078513          	mv	a0,a5
80003af0:	02c12083          	lw	ra,44(sp)
80003af4:	02812403          	lw	s0,40(sp)
80003af8:	03010113          	addi	sp,sp,48
80003afc:	00008067          	ret

80003b00 <number>:

static char *
number(char *str, long num, int base, int size, int precision, int type)
{
80003b00:	f8010113          	addi	sp,sp,-128
80003b04:	06112e23          	sw	ra,124(sp)
80003b08:	06812c23          	sw	s0,120(sp)
80003b0c:	08010413          	addi	s0,sp,128
80003b10:	f8a42e23          	sw	a0,-100(s0)
80003b14:	f8b42c23          	sw	a1,-104(s0)
80003b18:	f8c42a23          	sw	a2,-108(s0)
80003b1c:	f8d42823          	sw	a3,-112(s0)
80003b20:	f8e42623          	sw	a4,-116(s0)
80003b24:	f8f42423          	sw	a5,-120(s0)
    char  c, sign, tmp[66];
    char *dig = digits;
80003b28:	800057b7          	lui	a5,0x80005
80003b2c:	19c7a783          	lw	a5,412(a5) # 8000519c <digits>
80003b30:	fef42423          	sw	a5,-24(s0)
    int   i;

    if (type & UPPERCASE)
80003b34:	f8842783          	lw	a5,-120(s0)
80003b38:	0407f793          	andi	a5,a5,64
80003b3c:	00078863          	beqz	a5,80003b4c <number+0x4c>
        dig = upper_digits;
80003b40:	800057b7          	lui	a5,0x80005
80003b44:	1a07a783          	lw	a5,416(a5) # 800051a0 <upper_digits>
80003b48:	fef42423          	sw	a5,-24(s0)
    if (type & LEFT)
80003b4c:	f8842783          	lw	a5,-120(s0)
80003b50:	0107f793          	andi	a5,a5,16
80003b54:	00078863          	beqz	a5,80003b64 <number+0x64>
        type &= ~ZEROPAD;
80003b58:	f8842783          	lw	a5,-120(s0)
80003b5c:	ffe7f793          	andi	a5,a5,-2
80003b60:	f8f42423          	sw	a5,-120(s0)
    if (base < 2 || base > 36)
80003b64:	f9442703          	lw	a4,-108(s0)
80003b68:	00100793          	li	a5,1
80003b6c:	00e7d863          	bge	a5,a4,80003b7c <number+0x7c>
80003b70:	f9442703          	lw	a4,-108(s0)
80003b74:	02400793          	li	a5,36
80003b78:	00e7d663          	bge	a5,a4,80003b84 <number+0x84>
        return 0;
80003b7c:	00000793          	li	a5,0
80003b80:	3140006f          	j	80003e94 <number+0x394>

    c    = (type & ZEROPAD) ? '0' : ' ';
80003b84:	f8842783          	lw	a5,-120(s0)
80003b88:	0017f793          	andi	a5,a5,1
80003b8c:	00078863          	beqz	a5,80003b9c <number+0x9c>
80003b90:	03000793          	li	a5,48
80003b94:	fef407a3          	sb	a5,-17(s0)
80003b98:	00c0006f          	j	80003ba4 <number+0xa4>
80003b9c:	02000793          	li	a5,32
80003ba0:	fef407a3          	sb	a5,-17(s0)
    sign = 0;
80003ba4:	fe040723          	sb	zero,-18(s0)
    if (type & SIGN)
80003ba8:	f8842783          	lw	a5,-120(s0)
80003bac:	0027f793          	andi	a5,a5,2
80003bb0:	06078a63          	beqz	a5,80003c24 <number+0x124>
    {
        if (num < 0)
80003bb4:	f9842783          	lw	a5,-104(s0)
80003bb8:	0207d463          	bgez	a5,80003be0 <number+0xe0>
        {
            sign = '-';
80003bbc:	02d00793          	li	a5,45
80003bc0:	fef40723          	sb	a5,-18(s0)
            num  = -num;
80003bc4:	f9842783          	lw	a5,-104(s0)
80003bc8:	40f007b3          	neg	a5,a5
80003bcc:	f8f42c23          	sw	a5,-104(s0)
            size--;
80003bd0:	f9042783          	lw	a5,-112(s0)
80003bd4:	fff78793          	addi	a5,a5,-1
80003bd8:	f8f42823          	sw	a5,-112(s0)
80003bdc:	0480006f          	j	80003c24 <number+0x124>
        }
        else if (type & PLUS)
80003be0:	f8842783          	lw	a5,-120(s0)
80003be4:	0047f793          	andi	a5,a5,4
80003be8:	00078e63          	beqz	a5,80003c04 <number+0x104>
        {
            sign = '+';
80003bec:	02b00793          	li	a5,43
80003bf0:	fef40723          	sb	a5,-18(s0)
            size--;
80003bf4:	f9042783          	lw	a5,-112(s0)
80003bf8:	fff78793          	addi	a5,a5,-1
80003bfc:	f8f42823          	sw	a5,-112(s0)
80003c00:	0240006f          	j	80003c24 <number+0x124>
        }
        else if (type & SPACE)
80003c04:	f8842783          	lw	a5,-120(s0)
80003c08:	0087f793          	andi	a5,a5,8
80003c0c:	00078c63          	beqz	a5,80003c24 <number+0x124>
        {
            sign = ' ';
80003c10:	02000793          	li	a5,32
80003c14:	fef40723          	sb	a5,-18(s0)
            size--;
80003c18:	f9042783          	lw	a5,-112(s0)
80003c1c:	fff78793          	addi	a5,a5,-1
80003c20:	f8f42823          	sw	a5,-112(s0)
        }
    }

    if (type & HEX_PREP)
80003c24:	f8842783          	lw	a5,-120(s0)
80003c28:	0207f793          	andi	a5,a5,32
80003c2c:	02078c63          	beqz	a5,80003c64 <number+0x164>
    {
        if (base == 16)
80003c30:	f9442703          	lw	a4,-108(s0)
80003c34:	01000793          	li	a5,16
80003c38:	00f71a63          	bne	a4,a5,80003c4c <number+0x14c>
            size -= 2;
80003c3c:	f9042783          	lw	a5,-112(s0)
80003c40:	ffe78793          	addi	a5,a5,-2
80003c44:	f8f42823          	sw	a5,-112(s0)
80003c48:	01c0006f          	j	80003c64 <number+0x164>
        else if (base == 8)
80003c4c:	f9442703          	lw	a4,-108(s0)
80003c50:	00800793          	li	a5,8
80003c54:	00f71863          	bne	a4,a5,80003c64 <number+0x164>
            size--;
80003c58:	f9042783          	lw	a5,-112(s0)
80003c5c:	fff78793          	addi	a5,a5,-1
80003c60:	f8f42823          	sw	a5,-112(s0)
    }

    i = 0;
80003c64:	fe042223          	sw	zero,-28(s0)

    if (num == 0)
80003c68:	f9842783          	lw	a5,-104(s0)
80003c6c:	08079063          	bnez	a5,80003cec <number+0x1ec>
        tmp[i++] = '0';
80003c70:	fe442783          	lw	a5,-28(s0)
80003c74:	00178713          	addi	a4,a5,1
80003c78:	fee42223          	sw	a4,-28(s0)
80003c7c:	ff078793          	addi	a5,a5,-16
80003c80:	008787b3          	add	a5,a5,s0
80003c84:	03000713          	li	a4,48
80003c88:	fae78823          	sb	a4,-80(a5)
80003c8c:	0680006f          	j	80003cf4 <number+0x1f4>
    else
    {
        while (num != 0)
        {
            tmp[i++] = dig[((unsigned long)num) % (unsigned)base];
80003c90:	f9842783          	lw	a5,-104(s0)
80003c94:	f9442703          	lw	a4,-108(s0)
80003c98:	00070593          	mv	a1,a4
80003c9c:	00078513          	mv	a0,a5
80003ca0:	681000ef          	jal	80004b20 <__umodsi3>
80003ca4:	00050793          	mv	a5,a0
80003ca8:	00078713          	mv	a4,a5
80003cac:	fe842783          	lw	a5,-24(s0)
80003cb0:	00e78733          	add	a4,a5,a4
80003cb4:	fe442783          	lw	a5,-28(s0)
80003cb8:	00178693          	addi	a3,a5,1
80003cbc:	fed42223          	sw	a3,-28(s0)
80003cc0:	00074703          	lbu	a4,0(a4)
80003cc4:	ff078793          	addi	a5,a5,-16
80003cc8:	008787b3          	add	a5,a5,s0
80003ccc:	fae78823          	sb	a4,-80(a5)
            num      = ((unsigned long)num) / (unsigned)base;
80003cd0:	f9842783          	lw	a5,-104(s0)
80003cd4:	f9442703          	lw	a4,-108(s0)
80003cd8:	00070593          	mv	a1,a4
80003cdc:	00078513          	mv	a0,a5
80003ce0:	5f9000ef          	jal	80004ad8 <__hidden___udivsi3>
80003ce4:	00050793          	mv	a5,a0
80003ce8:	f8f42c23          	sw	a5,-104(s0)
        while (num != 0)
80003cec:	f9842783          	lw	a5,-104(s0)
80003cf0:	fa0790e3          	bnez	a5,80003c90 <number+0x190>
        }
    }

    if (i > precision)
80003cf4:	fe442703          	lw	a4,-28(s0)
80003cf8:	f8c42783          	lw	a5,-116(s0)
80003cfc:	00e7d663          	bge	a5,a4,80003d08 <number+0x208>
        precision = i;
80003d00:	fe442783          	lw	a5,-28(s0)
80003d04:	f8f42623          	sw	a5,-116(s0)
    size -= precision;
80003d08:	f9042703          	lw	a4,-112(s0)
80003d0c:	f8c42783          	lw	a5,-116(s0)
80003d10:	40f707b3          	sub	a5,a4,a5
80003d14:	f8f42823          	sw	a5,-112(s0)
    if (!(type & (ZEROPAD | LEFT)))
80003d18:	f8842783          	lw	a5,-120(s0)
80003d1c:	0117f793          	andi	a5,a5,17
80003d20:	02079663          	bnez	a5,80003d4c <number+0x24c>
        while (size-- > 0)
80003d24:	0180006f          	j	80003d3c <number+0x23c>
            *str++ = ' ';
80003d28:	f9c42783          	lw	a5,-100(s0)
80003d2c:	00178713          	addi	a4,a5,1
80003d30:	f8e42e23          	sw	a4,-100(s0)
80003d34:	02000713          	li	a4,32
80003d38:	00e78023          	sb	a4,0(a5)
        while (size-- > 0)
80003d3c:	f9042783          	lw	a5,-112(s0)
80003d40:	fff78713          	addi	a4,a5,-1
80003d44:	f8e42823          	sw	a4,-112(s0)
80003d48:	fef040e3          	bgtz	a5,80003d28 <number+0x228>
    if (sign)
80003d4c:	fee44783          	lbu	a5,-18(s0)
80003d50:	00078c63          	beqz	a5,80003d68 <number+0x268>
        *str++ = sign;
80003d54:	f9c42783          	lw	a5,-100(s0)
80003d58:	00178713          	addi	a4,a5,1
80003d5c:	f8e42e23          	sw	a4,-100(s0)
80003d60:	fee44703          	lbu	a4,-18(s0)
80003d64:	00e78023          	sb	a4,0(a5)

    if (type & HEX_PREP)
80003d68:	f8842783          	lw	a5,-120(s0)
80003d6c:	0207f793          	andi	a5,a5,32
80003d70:	06078263          	beqz	a5,80003dd4 <number+0x2d4>
    {
        if (base == 8)
80003d74:	f9442703          	lw	a4,-108(s0)
80003d78:	00800793          	li	a5,8
80003d7c:	00f71e63          	bne	a4,a5,80003d98 <number+0x298>
            *str++ = '0';
80003d80:	f9c42783          	lw	a5,-100(s0)
80003d84:	00178713          	addi	a4,a5,1
80003d88:	f8e42e23          	sw	a4,-100(s0)
80003d8c:	03000713          	li	a4,48
80003d90:	00e78023          	sb	a4,0(a5)
80003d94:	0400006f          	j	80003dd4 <number+0x2d4>
        else if (base == 16)
80003d98:	f9442703          	lw	a4,-108(s0)
80003d9c:	01000793          	li	a5,16
80003da0:	02f71a63          	bne	a4,a5,80003dd4 <number+0x2d4>
        {
            *str++ = '0';
80003da4:	f9c42783          	lw	a5,-100(s0)
80003da8:	00178713          	addi	a4,a5,1
80003dac:	f8e42e23          	sw	a4,-100(s0)
80003db0:	03000713          	li	a4,48
80003db4:	00e78023          	sb	a4,0(a5)
            *str++ = digits[33];
80003db8:	800057b7          	lui	a5,0x80005
80003dbc:	19c7a703          	lw	a4,412(a5) # 8000519c <digits>
80003dc0:	f9c42783          	lw	a5,-100(s0)
80003dc4:	00178693          	addi	a3,a5,1
80003dc8:	f8d42e23          	sw	a3,-100(s0)
80003dcc:	02174703          	lbu	a4,33(a4)
80003dd0:	00e78023          	sb	a4,0(a5)
        }
    }

    if (!(type & LEFT))
80003dd4:	f8842783          	lw	a5,-120(s0)
80003dd8:	0107f793          	andi	a5,a5,16
80003ddc:	04079263          	bnez	a5,80003e20 <number+0x320>
        while (size-- > 0)
80003de0:	0180006f          	j	80003df8 <number+0x2f8>
            *str++ = c;
80003de4:	f9c42783          	lw	a5,-100(s0)
80003de8:	00178713          	addi	a4,a5,1
80003dec:	f8e42e23          	sw	a4,-100(s0)
80003df0:	fef44703          	lbu	a4,-17(s0)
80003df4:	00e78023          	sb	a4,0(a5)
        while (size-- > 0)
80003df8:	f9042783          	lw	a5,-112(s0)
80003dfc:	fff78713          	addi	a4,a5,-1
80003e00:	f8e42823          	sw	a4,-112(s0)
80003e04:	fef040e3          	bgtz	a5,80003de4 <number+0x2e4>
    while (i < precision--)
80003e08:	0180006f          	j	80003e20 <number+0x320>
        *str++ = '0';
80003e0c:	f9c42783          	lw	a5,-100(s0)
80003e10:	00178713          	addi	a4,a5,1
80003e14:	f8e42e23          	sw	a4,-100(s0)
80003e18:	03000713          	li	a4,48
80003e1c:	00e78023          	sb	a4,0(a5)
    while (i < precision--)
80003e20:	f8c42783          	lw	a5,-116(s0)
80003e24:	fff78713          	addi	a4,a5,-1
80003e28:	f8e42623          	sw	a4,-116(s0)
80003e2c:	fe442703          	lw	a4,-28(s0)
80003e30:	fcf74ee3          	blt	a4,a5,80003e0c <number+0x30c>
    while (i-- > 0)
80003e34:	0240006f          	j	80003e58 <number+0x358>
        *str++ = tmp[i];
80003e38:	f9c42783          	lw	a5,-100(s0)
80003e3c:	00178713          	addi	a4,a5,1
80003e40:	f8e42e23          	sw	a4,-100(s0)
80003e44:	fe442703          	lw	a4,-28(s0)
80003e48:	ff070713          	addi	a4,a4,-16
80003e4c:	00870733          	add	a4,a4,s0
80003e50:	fb074703          	lbu	a4,-80(a4)
80003e54:	00e78023          	sb	a4,0(a5)
    while (i-- > 0)
80003e58:	fe442783          	lw	a5,-28(s0)
80003e5c:	fff78713          	addi	a4,a5,-1
80003e60:	fee42223          	sw	a4,-28(s0)
80003e64:	fcf04ae3          	bgtz	a5,80003e38 <number+0x338>
    while (size-- > 0)
80003e68:	0180006f          	j	80003e80 <number+0x380>
        *str++ = ' ';
80003e6c:	f9c42783          	lw	a5,-100(s0)
80003e70:	00178713          	addi	a4,a5,1
80003e74:	f8e42e23          	sw	a4,-100(s0)
80003e78:	02000713          	li	a4,32
80003e7c:	00e78023          	sb	a4,0(a5)
    while (size-- > 0)
80003e80:	f9042783          	lw	a5,-112(s0)
80003e84:	fff78713          	addi	a4,a5,-1
80003e88:	f8e42823          	sw	a4,-112(s0)
80003e8c:	fef040e3          	bgtz	a5,80003e6c <number+0x36c>

    return str;
80003e90:	f9c42783          	lw	a5,-100(s0)
}
80003e94:	00078513          	mv	a0,a5
80003e98:	07c12083          	lw	ra,124(sp)
80003e9c:	07812403          	lw	s0,120(sp)
80003ea0:	08010113          	addi	sp,sp,128
80003ea4:	00008067          	ret

80003ea8 <eaddr>:

static char *
eaddr(char *str, unsigned char *addr, int size, int precision, int type)
{
80003ea8:	fa010113          	addi	sp,sp,-96
80003eac:	04112e23          	sw	ra,92(sp)
80003eb0:	04812c23          	sw	s0,88(sp)
80003eb4:	06010413          	addi	s0,sp,96
80003eb8:	faa42e23          	sw	a0,-68(s0)
80003ebc:	fab42c23          	sw	a1,-72(s0)
80003ec0:	fac42a23          	sw	a2,-76(s0)
80003ec4:	fad42823          	sw	a3,-80(s0)
80003ec8:	fae42623          	sw	a4,-84(s0)
    char  tmp[24];
    char *dig = digits;
80003ecc:	800057b7          	lui	a5,0x80005
80003ed0:	19c7a783          	lw	a5,412(a5) # 8000519c <digits>
80003ed4:	fef42623          	sw	a5,-20(s0)
    int   i, len;

    if (type & UPPERCASE)
80003ed8:	fac42783          	lw	a5,-84(s0)
80003edc:	0407f793          	andi	a5,a5,64
80003ee0:	00078863          	beqz	a5,80003ef0 <eaddr+0x48>
        dig = upper_digits;
80003ee4:	800057b7          	lui	a5,0x80005
80003ee8:	1a07a783          	lw	a5,416(a5) # 800051a0 <upper_digits>
80003eec:	fef42623          	sw	a5,-20(s0)
    len = 0;
80003ef0:	fe042223          	sw	zero,-28(s0)
    for (i = 0; i < 6; i++)
80003ef4:	fe042423          	sw	zero,-24(s0)
80003ef8:	0ac0006f          	j	80003fa4 <eaddr+0xfc>
    {
        if (i != 0)
80003efc:	fe842783          	lw	a5,-24(s0)
80003f00:	02078063          	beqz	a5,80003f20 <eaddr+0x78>
            tmp[len++] = ':';
80003f04:	fe442783          	lw	a5,-28(s0)
80003f08:	00178713          	addi	a4,a5,1
80003f0c:	fee42223          	sw	a4,-28(s0)
80003f10:	ff078793          	addi	a5,a5,-16
80003f14:	008787b3          	add	a5,a5,s0
80003f18:	03a00713          	li	a4,58
80003f1c:	fce78e23          	sb	a4,-36(a5)
        tmp[len++] = dig[addr[i] >> 4];
80003f20:	fe842783          	lw	a5,-24(s0)
80003f24:	fb842703          	lw	a4,-72(s0)
80003f28:	00f707b3          	add	a5,a4,a5
80003f2c:	0007c783          	lbu	a5,0(a5)
80003f30:	0047d793          	srli	a5,a5,0x4
80003f34:	0ff7f793          	zext.b	a5,a5
80003f38:	00078713          	mv	a4,a5
80003f3c:	fec42783          	lw	a5,-20(s0)
80003f40:	00e78733          	add	a4,a5,a4
80003f44:	fe442783          	lw	a5,-28(s0)
80003f48:	00178693          	addi	a3,a5,1
80003f4c:	fed42223          	sw	a3,-28(s0)
80003f50:	00074703          	lbu	a4,0(a4)
80003f54:	ff078793          	addi	a5,a5,-16
80003f58:	008787b3          	add	a5,a5,s0
80003f5c:	fce78e23          	sb	a4,-36(a5)
        tmp[len++] = dig[addr[i] & 0x0F];
80003f60:	fe842783          	lw	a5,-24(s0)
80003f64:	fb842703          	lw	a4,-72(s0)
80003f68:	00f707b3          	add	a5,a4,a5
80003f6c:	0007c783          	lbu	a5,0(a5)
80003f70:	00f7f793          	andi	a5,a5,15
80003f74:	fec42703          	lw	a4,-20(s0)
80003f78:	00f70733          	add	a4,a4,a5
80003f7c:	fe442783          	lw	a5,-28(s0)
80003f80:	00178693          	addi	a3,a5,1
80003f84:	fed42223          	sw	a3,-28(s0)
80003f88:	00074703          	lbu	a4,0(a4)
80003f8c:	ff078793          	addi	a5,a5,-16
80003f90:	008787b3          	add	a5,a5,s0
80003f94:	fce78e23          	sb	a4,-36(a5)
    for (i = 0; i < 6; i++)
80003f98:	fe842783          	lw	a5,-24(s0)
80003f9c:	00178793          	addi	a5,a5,1
80003fa0:	fef42423          	sw	a5,-24(s0)
80003fa4:	fe842703          	lw	a4,-24(s0)
80003fa8:	00500793          	li	a5,5
80003fac:	f4e7d8e3          	bge	a5,a4,80003efc <eaddr+0x54>
    }

    if (!(type & LEFT))
80003fb0:	fac42783          	lw	a5,-84(s0)
80003fb4:	0107f793          	andi	a5,a5,16
80003fb8:	02079863          	bnez	a5,80003fe8 <eaddr+0x140>
        while (len < size--)
80003fbc:	0180006f          	j	80003fd4 <eaddr+0x12c>
            *str++ = ' ';
80003fc0:	fbc42783          	lw	a5,-68(s0)
80003fc4:	00178713          	addi	a4,a5,1
80003fc8:	fae42e23          	sw	a4,-68(s0)
80003fcc:	02000713          	li	a4,32
80003fd0:	00e78023          	sb	a4,0(a5)
        while (len < size--)
80003fd4:	fb442783          	lw	a5,-76(s0)
80003fd8:	fff78713          	addi	a4,a5,-1
80003fdc:	fae42a23          	sw	a4,-76(s0)
80003fe0:	fe442703          	lw	a4,-28(s0)
80003fe4:	fcf74ee3          	blt	a4,a5,80003fc0 <eaddr+0x118>
    for (i = 0; i < len; ++i)
80003fe8:	fe042423          	sw	zero,-24(s0)
80003fec:	0300006f          	j	8000401c <eaddr+0x174>
        *str++ = tmp[i];
80003ff0:	fbc42783          	lw	a5,-68(s0)
80003ff4:	00178713          	addi	a4,a5,1
80003ff8:	fae42e23          	sw	a4,-68(s0)
80003ffc:	fe842703          	lw	a4,-24(s0)
80004000:	ff070713          	addi	a4,a4,-16
80004004:	00870733          	add	a4,a4,s0
80004008:	fdc74703          	lbu	a4,-36(a4)
8000400c:	00e78023          	sb	a4,0(a5)
    for (i = 0; i < len; ++i)
80004010:	fe842783          	lw	a5,-24(s0)
80004014:	00178793          	addi	a5,a5,1
80004018:	fef42423          	sw	a5,-24(s0)
8000401c:	fe842703          	lw	a4,-24(s0)
80004020:	fe442783          	lw	a5,-28(s0)
80004024:	fcf746e3          	blt	a4,a5,80003ff0 <eaddr+0x148>
    while (len < size--)
80004028:	0180006f          	j	80004040 <eaddr+0x198>
        *str++ = ' ';
8000402c:	fbc42783          	lw	a5,-68(s0)
80004030:	00178713          	addi	a4,a5,1
80004034:	fae42e23          	sw	a4,-68(s0)
80004038:	02000713          	li	a4,32
8000403c:	00e78023          	sb	a4,0(a5)
    while (len < size--)
80004040:	fb442783          	lw	a5,-76(s0)
80004044:	fff78713          	addi	a4,a5,-1
80004048:	fae42a23          	sw	a4,-76(s0)
8000404c:	fe442703          	lw	a4,-28(s0)
80004050:	fcf74ee3          	blt	a4,a5,8000402c <eaddr+0x184>

    return str;
80004054:	fbc42783          	lw	a5,-68(s0)
}
80004058:	00078513          	mv	a0,a5
8000405c:	05c12083          	lw	ra,92(sp)
80004060:	05812403          	lw	s0,88(sp)
80004064:	06010113          	addi	sp,sp,96
80004068:	00008067          	ret

8000406c <iaddr>:

static char *
iaddr(char *str, unsigned char *addr, int size, int precision, int type)
{
8000406c:	fa010113          	addi	sp,sp,-96
80004070:	04112e23          	sw	ra,92(sp)
80004074:	04812c23          	sw	s0,88(sp)
80004078:	04912a23          	sw	s1,84(sp)
8000407c:	06010413          	addi	s0,sp,96
80004080:	faa42e23          	sw	a0,-68(s0)
80004084:	fab42c23          	sw	a1,-72(s0)
80004088:	fac42a23          	sw	a2,-76(s0)
8000408c:	fad42823          	sw	a3,-80(s0)
80004090:	fae42623          	sw	a4,-84(s0)
    char tmp[24];
    int  i, n, len;

    len = 0;
80004094:	fe042223          	sw	zero,-28(s0)
    for (i = 0; i < 4; i++)
80004098:	fe042623          	sw	zero,-20(s0)
8000409c:	1bc0006f          	j	80004258 <iaddr+0x1ec>
    {
        if (i != 0)
800040a0:	fec42783          	lw	a5,-20(s0)
800040a4:	02078063          	beqz	a5,800040c4 <iaddr+0x58>
            tmp[len++] = '.';
800040a8:	fe442783          	lw	a5,-28(s0)
800040ac:	00178713          	addi	a4,a5,1
800040b0:	fee42223          	sw	a4,-28(s0)
800040b4:	ff078793          	addi	a5,a5,-16
800040b8:	008787b3          	add	a5,a5,s0
800040bc:	02e00713          	li	a4,46
800040c0:	fce78e23          	sb	a4,-36(a5)
        n = addr[i];
800040c4:	fec42783          	lw	a5,-20(s0)
800040c8:	fb842703          	lw	a4,-72(s0)
800040cc:	00f707b3          	add	a5,a4,a5
800040d0:	0007c783          	lbu	a5,0(a5)
800040d4:	fef42423          	sw	a5,-24(s0)

        if (n == 0)
800040d8:	fe842783          	lw	a5,-24(s0)
800040dc:	02079663          	bnez	a5,80004108 <iaddr+0x9c>
            tmp[len++] = digits[0];
800040e0:	800057b7          	lui	a5,0x80005
800040e4:	19c7a703          	lw	a4,412(a5) # 8000519c <digits>
800040e8:	fe442783          	lw	a5,-28(s0)
800040ec:	00178693          	addi	a3,a5,1
800040f0:	fed42223          	sw	a3,-28(s0)
800040f4:	00074703          	lbu	a4,0(a4)
800040f8:	ff078793          	addi	a5,a5,-16
800040fc:	008787b3          	add	a5,a5,s0
80004100:	fce78e23          	sb	a4,-36(a5)
80004104:	1480006f          	j	8000424c <iaddr+0x1e0>
        else
        {
            if (n >= 100)
80004108:	fe842703          	lw	a4,-24(s0)
8000410c:	06300793          	li	a5,99
80004110:	0ae7d863          	bge	a5,a4,800041c0 <iaddr+0x154>
            {
                tmp[len++] = digits[n / 100];
80004114:	800057b7          	lui	a5,0x80005
80004118:	19c7a483          	lw	s1,412(a5) # 8000519c <digits>
8000411c:	fe842783          	lw	a5,-24(s0)
80004120:	06400593          	li	a1,100
80004124:	00078513          	mv	a0,a5
80004128:	1a9000ef          	jal	80004ad0 <__divsi3>
8000412c:	00050793          	mv	a5,a0
80004130:	00f48733          	add	a4,s1,a5
80004134:	fe442783          	lw	a5,-28(s0)
80004138:	00178693          	addi	a3,a5,1
8000413c:	fed42223          	sw	a3,-28(s0)
80004140:	00074703          	lbu	a4,0(a4)
80004144:	ff078793          	addi	a5,a5,-16
80004148:	008787b3          	add	a5,a5,s0
8000414c:	fce78e23          	sb	a4,-36(a5)
                n          = n % 100;
80004150:	fe842783          	lw	a5,-24(s0)
80004154:	06400593          	li	a1,100
80004158:	00078513          	mv	a0,a5
8000415c:	1f9000ef          	jal	80004b54 <__modsi3>
80004160:	00050793          	mv	a5,a0
80004164:	fef42423          	sw	a5,-24(s0)
                tmp[len++] = digits[n / 10];
80004168:	800057b7          	lui	a5,0x80005
8000416c:	19c7a483          	lw	s1,412(a5) # 8000519c <digits>
80004170:	fe842783          	lw	a5,-24(s0)
80004174:	00a00593          	li	a1,10
80004178:	00078513          	mv	a0,a5
8000417c:	155000ef          	jal	80004ad0 <__divsi3>
80004180:	00050793          	mv	a5,a0
80004184:	00f48733          	add	a4,s1,a5
80004188:	fe442783          	lw	a5,-28(s0)
8000418c:	00178693          	addi	a3,a5,1
80004190:	fed42223          	sw	a3,-28(s0)
80004194:	00074703          	lbu	a4,0(a4)
80004198:	ff078793          	addi	a5,a5,-16
8000419c:	008787b3          	add	a5,a5,s0
800041a0:	fce78e23          	sb	a4,-36(a5)
                n          = n % 10;
800041a4:	fe842783          	lw	a5,-24(s0)
800041a8:	00a00593          	li	a1,10
800041ac:	00078513          	mv	a0,a5
800041b0:	1a5000ef          	jal	80004b54 <__modsi3>
800041b4:	00050793          	mv	a5,a0
800041b8:	fef42423          	sw	a5,-24(s0)
800041bc:	0640006f          	j	80004220 <iaddr+0x1b4>
            }
            else if (n >= 10)
800041c0:	fe842703          	lw	a4,-24(s0)
800041c4:	00900793          	li	a5,9
800041c8:	04e7dc63          	bge	a5,a4,80004220 <iaddr+0x1b4>
            {
                tmp[len++] = digits[n / 10];
800041cc:	800057b7          	lui	a5,0x80005
800041d0:	19c7a483          	lw	s1,412(a5) # 8000519c <digits>
800041d4:	fe842783          	lw	a5,-24(s0)
800041d8:	00a00593          	li	a1,10
800041dc:	00078513          	mv	a0,a5
800041e0:	0f1000ef          	jal	80004ad0 <__divsi3>
800041e4:	00050793          	mv	a5,a0
800041e8:	00f48733          	add	a4,s1,a5
800041ec:	fe442783          	lw	a5,-28(s0)
800041f0:	00178693          	addi	a3,a5,1
800041f4:	fed42223          	sw	a3,-28(s0)
800041f8:	00074703          	lbu	a4,0(a4)
800041fc:	ff078793          	addi	a5,a5,-16
80004200:	008787b3          	add	a5,a5,s0
80004204:	fce78e23          	sb	a4,-36(a5)
                n          = n % 10;
80004208:	fe842783          	lw	a5,-24(s0)
8000420c:	00a00593          	li	a1,10
80004210:	00078513          	mv	a0,a5
80004214:	141000ef          	jal	80004b54 <__modsi3>
80004218:	00050793          	mv	a5,a0
8000421c:	fef42423          	sw	a5,-24(s0)
            }

            tmp[len++] = digits[n];
80004220:	800057b7          	lui	a5,0x80005
80004224:	19c7a703          	lw	a4,412(a5) # 8000519c <digits>
80004228:	fe842783          	lw	a5,-24(s0)
8000422c:	00f70733          	add	a4,a4,a5
80004230:	fe442783          	lw	a5,-28(s0)
80004234:	00178693          	addi	a3,a5,1
80004238:	fed42223          	sw	a3,-28(s0)
8000423c:	00074703          	lbu	a4,0(a4)
80004240:	ff078793          	addi	a5,a5,-16
80004244:	008787b3          	add	a5,a5,s0
80004248:	fce78e23          	sb	a4,-36(a5)
    for (i = 0; i < 4; i++)
8000424c:	fec42783          	lw	a5,-20(s0)
80004250:	00178793          	addi	a5,a5,1
80004254:	fef42623          	sw	a5,-20(s0)
80004258:	fec42703          	lw	a4,-20(s0)
8000425c:	00300793          	li	a5,3
80004260:	e4e7d0e3          	bge	a5,a4,800040a0 <iaddr+0x34>
        }
    }

    if (!(type & LEFT))
80004264:	fac42783          	lw	a5,-84(s0)
80004268:	0107f793          	andi	a5,a5,16
8000426c:	02079863          	bnez	a5,8000429c <iaddr+0x230>
        while (len < size--)
80004270:	0180006f          	j	80004288 <iaddr+0x21c>
            *str++ = ' ';
80004274:	fbc42783          	lw	a5,-68(s0)
80004278:	00178713          	addi	a4,a5,1
8000427c:	fae42e23          	sw	a4,-68(s0)
80004280:	02000713          	li	a4,32
80004284:	00e78023          	sb	a4,0(a5)
        while (len < size--)
80004288:	fb442783          	lw	a5,-76(s0)
8000428c:	fff78713          	addi	a4,a5,-1
80004290:	fae42a23          	sw	a4,-76(s0)
80004294:	fe442703          	lw	a4,-28(s0)
80004298:	fcf74ee3          	blt	a4,a5,80004274 <iaddr+0x208>
    for (i = 0; i < len; ++i)
8000429c:	fe042623          	sw	zero,-20(s0)
800042a0:	0300006f          	j	800042d0 <iaddr+0x264>
        *str++ = tmp[i];
800042a4:	fbc42783          	lw	a5,-68(s0)
800042a8:	00178713          	addi	a4,a5,1
800042ac:	fae42e23          	sw	a4,-68(s0)
800042b0:	fec42703          	lw	a4,-20(s0)
800042b4:	ff070713          	addi	a4,a4,-16
800042b8:	00870733          	add	a4,a4,s0
800042bc:	fdc74703          	lbu	a4,-36(a4)
800042c0:	00e78023          	sb	a4,0(a5)
    for (i = 0; i < len; ++i)
800042c4:	fec42783          	lw	a5,-20(s0)
800042c8:	00178793          	addi	a5,a5,1
800042cc:	fef42623          	sw	a5,-20(s0)
800042d0:	fec42703          	lw	a4,-20(s0)
800042d4:	fe442783          	lw	a5,-28(s0)
800042d8:	fcf746e3          	blt	a4,a5,800042a4 <iaddr+0x238>
    while (len < size--)
800042dc:	0180006f          	j	800042f4 <iaddr+0x288>
        *str++ = ' ';
800042e0:	fbc42783          	lw	a5,-68(s0)
800042e4:	00178713          	addi	a4,a5,1
800042e8:	fae42e23          	sw	a4,-68(s0)
800042ec:	02000713          	li	a4,32
800042f0:	00e78023          	sb	a4,0(a5)
    while (len < size--)
800042f4:	fb442783          	lw	a5,-76(s0)
800042f8:	fff78713          	addi	a4,a5,-1
800042fc:	fae42a23          	sw	a4,-76(s0)
80004300:	fe442703          	lw	a4,-28(s0)
80004304:	fcf74ee3          	blt	a4,a5,800042e0 <iaddr+0x274>

    return str;
80004308:	fbc42783          	lw	a5,-68(s0)
}
8000430c:	00078513          	mv	a0,a5
80004310:	05c12083          	lw	ra,92(sp)
80004314:	05812403          	lw	s0,88(sp)
80004318:	05412483          	lw	s1,84(sp)
8000431c:	06010113          	addi	sp,sp,96
80004320:	00008067          	ret

80004324 <ee_vsprintf>:

#endif

static int
ee_vsprintf(char *buf, const char *fmt, va_list args)
{
80004324:	fb010113          	addi	sp,sp,-80
80004328:	04112623          	sw	ra,76(sp)
8000432c:	04812423          	sw	s0,72(sp)
80004330:	05010413          	addi	s0,sp,80
80004334:	faa42e23          	sw	a0,-68(s0)
80004338:	fab42c23          	sw	a1,-72(s0)
8000433c:	fac42a23          	sw	a2,-76(s0)
    int field_width; // Width of output field
    int precision;   // Min. # of digits for integers; max number of chars for
                     // from string
    int qualifier;   // 'h', 'l', or 'L' for integer fields

    for (str = buf; *fmt; fmt++)
80004340:	fbc42783          	lw	a5,-68(s0)
80004344:	fef42023          	sw	a5,-32(s0)
80004348:	64c0006f          	j	80004994 <ee_vsprintf+0x670>
    {
        if (*fmt != '%')
8000434c:	fb842783          	lw	a5,-72(s0)
80004350:	0007c703          	lbu	a4,0(a5)
80004354:	02500793          	li	a5,37
80004358:	02f70063          	beq	a4,a5,80004378 <ee_vsprintf+0x54>
        {
            *str++ = *fmt;
8000435c:	fb842703          	lw	a4,-72(s0)
80004360:	fe042783          	lw	a5,-32(s0)
80004364:	00178693          	addi	a3,a5,1
80004368:	fed42023          	sw	a3,-32(s0)
8000436c:	00074703          	lbu	a4,0(a4)
80004370:	00e78023          	sb	a4,0(a5)
            continue;
80004374:	6140006f          	j	80004988 <ee_vsprintf+0x664>
        }

        // Process flags
        flags = 0;
80004378:	fc042c23          	sw	zero,-40(s0)
    repeat:
        fmt++; // This also skips first '%'
8000437c:	fb842783          	lw	a5,-72(s0)
80004380:	00178793          	addi	a5,a5,1
80004384:	faf42c23          	sw	a5,-72(s0)
        switch (*fmt)
80004388:	fb842783          	lw	a5,-72(s0)
8000438c:	0007c783          	lbu	a5,0(a5)
80004390:	03000713          	li	a4,48
80004394:	08e78063          	beq	a5,a4,80004414 <ee_vsprintf+0xf0>
80004398:	03000713          	li	a4,48
8000439c:	08f74463          	blt	a4,a5,80004424 <ee_vsprintf+0x100>
800043a0:	02d00713          	li	a4,45
800043a4:	02e78863          	beq	a5,a4,800043d4 <ee_vsprintf+0xb0>
800043a8:	02d00713          	li	a4,45
800043ac:	06f74c63          	blt	a4,a5,80004424 <ee_vsprintf+0x100>
800043b0:	02b00713          	li	a4,43
800043b4:	02e78863          	beq	a5,a4,800043e4 <ee_vsprintf+0xc0>
800043b8:	02b00713          	li	a4,43
800043bc:	06f74463          	blt	a4,a5,80004424 <ee_vsprintf+0x100>
800043c0:	02000713          	li	a4,32
800043c4:	02e78863          	beq	a5,a4,800043f4 <ee_vsprintf+0xd0>
800043c8:	02300713          	li	a4,35
800043cc:	02e78c63          	beq	a5,a4,80004404 <ee_vsprintf+0xe0>
800043d0:	0540006f          	j	80004424 <ee_vsprintf+0x100>
        {
            case '-':
                flags |= LEFT;
800043d4:	fd842783          	lw	a5,-40(s0)
800043d8:	0107e793          	ori	a5,a5,16
800043dc:	fcf42c23          	sw	a5,-40(s0)
                goto repeat;
800043e0:	f9dff06f          	j	8000437c <ee_vsprintf+0x58>
            case '+':
                flags |= PLUS;
800043e4:	fd842783          	lw	a5,-40(s0)
800043e8:	0047e793          	ori	a5,a5,4
800043ec:	fcf42c23          	sw	a5,-40(s0)
                goto repeat;
800043f0:	f8dff06f          	j	8000437c <ee_vsprintf+0x58>
            case ' ':
                flags |= SPACE;
800043f4:	fd842783          	lw	a5,-40(s0)
800043f8:	0087e793          	ori	a5,a5,8
800043fc:	fcf42c23          	sw	a5,-40(s0)
                goto repeat;
80004400:	f7dff06f          	j	8000437c <ee_vsprintf+0x58>
            case '#':
                flags |= HEX_PREP;
80004404:	fd842783          	lw	a5,-40(s0)
80004408:	0207e793          	ori	a5,a5,32
8000440c:	fcf42c23          	sw	a5,-40(s0)
                goto repeat;
80004410:	f6dff06f          	j	8000437c <ee_vsprintf+0x58>
            case '0':
                flags |= ZEROPAD;
80004414:	fd842783          	lw	a5,-40(s0)
80004418:	0017e793          	ori	a5,a5,1
8000441c:	fcf42c23          	sw	a5,-40(s0)
                goto repeat;
80004420:	f5dff06f          	j	8000437c <ee_vsprintf+0x58>
        }

        // Get field width
        field_width = -1;
80004424:	fff00793          	li	a5,-1
80004428:	fcf42a23          	sw	a5,-44(s0)
        if (is_digit(*fmt))
8000442c:	fb842783          	lw	a5,-72(s0)
80004430:	0007c703          	lbu	a4,0(a5)
80004434:	02f00793          	li	a5,47
80004438:	02e7f463          	bgeu	a5,a4,80004460 <ee_vsprintf+0x13c>
8000443c:	fb842783          	lw	a5,-72(s0)
80004440:	0007c703          	lbu	a4,0(a5)
80004444:	03900793          	li	a5,57
80004448:	00e7ec63          	bltu	a5,a4,80004460 <ee_vsprintf+0x13c>
            field_width = skip_atoi(&fmt);
8000444c:	fb840793          	addi	a5,s0,-72
80004450:	00078513          	mv	a0,a5
80004454:	e14ff0ef          	jal	80003a68 <skip_atoi>
80004458:	fca42a23          	sw	a0,-44(s0)
8000445c:	0540006f          	j	800044b0 <ee_vsprintf+0x18c>
        else if (*fmt == '*')
80004460:	fb842783          	lw	a5,-72(s0)
80004464:	0007c703          	lbu	a4,0(a5)
80004468:	02a00793          	li	a5,42
8000446c:	04f71263          	bne	a4,a5,800044b0 <ee_vsprintf+0x18c>
        {
            fmt++;
80004470:	fb842783          	lw	a5,-72(s0)
80004474:	00178793          	addi	a5,a5,1
80004478:	faf42c23          	sw	a5,-72(s0)
            field_width = va_arg(args, int);
8000447c:	fb442783          	lw	a5,-76(s0)
80004480:	00478713          	addi	a4,a5,4
80004484:	fae42a23          	sw	a4,-76(s0)
80004488:	0007a783          	lw	a5,0(a5)
8000448c:	fcf42a23          	sw	a5,-44(s0)
            if (field_width < 0)
80004490:	fd442783          	lw	a5,-44(s0)
80004494:	0007de63          	bgez	a5,800044b0 <ee_vsprintf+0x18c>
            {
                field_width = -field_width;
80004498:	fd442783          	lw	a5,-44(s0)
8000449c:	40f007b3          	neg	a5,a5
800044a0:	fcf42a23          	sw	a5,-44(s0)
                flags |= LEFT;
800044a4:	fd842783          	lw	a5,-40(s0)
800044a8:	0107e793          	ori	a5,a5,16
800044ac:	fcf42c23          	sw	a5,-40(s0)
            }
        }

        // Get the precision
        precision = -1;
800044b0:	fff00793          	li	a5,-1
800044b4:	fcf42823          	sw	a5,-48(s0)
        if (*fmt == '.')
800044b8:	fb842783          	lw	a5,-72(s0)
800044bc:	0007c703          	lbu	a4,0(a5)
800044c0:	02e00793          	li	a5,46
800044c4:	08f71063          	bne	a4,a5,80004544 <ee_vsprintf+0x220>
        {
            ++fmt;
800044c8:	fb842783          	lw	a5,-72(s0)
800044cc:	00178793          	addi	a5,a5,1
800044d0:	faf42c23          	sw	a5,-72(s0)
            if (is_digit(*fmt))
800044d4:	fb842783          	lw	a5,-72(s0)
800044d8:	0007c703          	lbu	a4,0(a5)
800044dc:	02f00793          	li	a5,47
800044e0:	02e7f463          	bgeu	a5,a4,80004508 <ee_vsprintf+0x1e4>
800044e4:	fb842783          	lw	a5,-72(s0)
800044e8:	0007c703          	lbu	a4,0(a5)
800044ec:	03900793          	li	a5,57
800044f0:	00e7ec63          	bltu	a5,a4,80004508 <ee_vsprintf+0x1e4>
                precision = skip_atoi(&fmt);
800044f4:	fb840793          	addi	a5,s0,-72
800044f8:	00078513          	mv	a0,a5
800044fc:	d6cff0ef          	jal	80003a68 <skip_atoi>
80004500:	fca42823          	sw	a0,-48(s0)
80004504:	0340006f          	j	80004538 <ee_vsprintf+0x214>
            else if (*fmt == '*')
80004508:	fb842783          	lw	a5,-72(s0)
8000450c:	0007c703          	lbu	a4,0(a5)
80004510:	02a00793          	li	a5,42
80004514:	02f71263          	bne	a4,a5,80004538 <ee_vsprintf+0x214>
            {
                ++fmt;
80004518:	fb842783          	lw	a5,-72(s0)
8000451c:	00178793          	addi	a5,a5,1
80004520:	faf42c23          	sw	a5,-72(s0)
                precision = va_arg(args, int);
80004524:	fb442783          	lw	a5,-76(s0)
80004528:	00478713          	addi	a4,a5,4
8000452c:	fae42a23          	sw	a4,-76(s0)
80004530:	0007a783          	lw	a5,0(a5)
80004534:	fcf42823          	sw	a5,-48(s0)
            }
            if (precision < 0)
80004538:	fd042783          	lw	a5,-48(s0)
8000453c:	0007d463          	bgez	a5,80004544 <ee_vsprintf+0x220>
                precision = 0;
80004540:	fc042823          	sw	zero,-48(s0)
        }

        // Get the conversion qualifier
        qualifier = -1;
80004544:	fff00793          	li	a5,-1
80004548:	fcf42623          	sw	a5,-52(s0)
        if (*fmt == 'l' || *fmt == 'L')
8000454c:	fb842783          	lw	a5,-72(s0)
80004550:	0007c703          	lbu	a4,0(a5)
80004554:	06c00793          	li	a5,108
80004558:	00f70a63          	beq	a4,a5,8000456c <ee_vsprintf+0x248>
8000455c:	fb842783          	lw	a5,-72(s0)
80004560:	0007c703          	lbu	a4,0(a5)
80004564:	04c00793          	li	a5,76
80004568:	00f71e63          	bne	a4,a5,80004584 <ee_vsprintf+0x260>
        {
            qualifier = *fmt;
8000456c:	fb842783          	lw	a5,-72(s0)
80004570:	0007c783          	lbu	a5,0(a5)
80004574:	fcf42623          	sw	a5,-52(s0)
            fmt++;
80004578:	fb842783          	lw	a5,-72(s0)
8000457c:	00178793          	addi	a5,a5,1
80004580:	faf42c23          	sw	a5,-72(s0)
        }

        // Default base
        base = 10;
80004584:	00a00793          	li	a5,10
80004588:	fef42223          	sw	a5,-28(s0)

        switch (*fmt)
8000458c:	fb842783          	lw	a5,-72(s0)
80004590:	0007c783          	lbu	a5,0(a5)
80004594:	07800713          	li	a4,120
80004598:	2ee78c63          	beq	a5,a4,80004890 <ee_vsprintf+0x56c>
8000459c:	07800713          	li	a4,120
800045a0:	30f74663          	blt	a4,a5,800048ac <ee_vsprintf+0x588>
800045a4:	07500713          	li	a4,117
800045a8:	36e78063          	beq	a5,a4,80004908 <ee_vsprintf+0x5e4>
800045ac:	07500713          	li	a4,117
800045b0:	2ef74e63          	blt	a4,a5,800048ac <ee_vsprintf+0x588>
800045b4:	07300713          	li	a4,115
800045b8:	10e78663          	beq	a5,a4,800046c4 <ee_vsprintf+0x3a0>
800045bc:	07300713          	li	a4,115
800045c0:	2ef74663          	blt	a4,a5,800048ac <ee_vsprintf+0x588>
800045c4:	07000713          	li	a4,112
800045c8:	1ee78263          	beq	a5,a4,800047ac <ee_vsprintf+0x488>
800045cc:	07000713          	li	a4,112
800045d0:	2cf74e63          	blt	a4,a5,800048ac <ee_vsprintf+0x588>
800045d4:	06f00713          	li	a4,111
800045d8:	2ae78063          	beq	a5,a4,80004878 <ee_vsprintf+0x554>
800045dc:	06f00713          	li	a4,111
800045e0:	2cf74663          	blt	a4,a5,800048ac <ee_vsprintf+0x588>
800045e4:	06900713          	li	a4,105
800045e8:	2ae78a63          	beq	a5,a4,8000489c <ee_vsprintf+0x578>
800045ec:	06900713          	li	a4,105
800045f0:	2af74e63          	blt	a4,a5,800048ac <ee_vsprintf+0x588>
800045f4:	06400713          	li	a4,100
800045f8:	2ae78263          	beq	a5,a4,8000489c <ee_vsprintf+0x578>
800045fc:	06400713          	li	a4,100
80004600:	2af74663          	blt	a4,a5,800048ac <ee_vsprintf+0x588>
80004604:	06300713          	li	a4,99
80004608:	02e78863          	beq	a5,a4,80004638 <ee_vsprintf+0x314>
8000460c:	06300713          	li	a4,99
80004610:	28f74e63          	blt	a4,a5,800048ac <ee_vsprintf+0x588>
80004614:	06100713          	li	a4,97
80004618:	1ee78a63          	beq	a5,a4,8000480c <ee_vsprintf+0x4e8>
8000461c:	06100713          	li	a4,97
80004620:	28f74663          	blt	a4,a5,800048ac <ee_vsprintf+0x588>
80004624:	04100713          	li	a4,65
80004628:	1ce78c63          	beq	a5,a4,80004800 <ee_vsprintf+0x4dc>
8000462c:	05800713          	li	a4,88
80004630:	24e78a63          	beq	a5,a4,80004884 <ee_vsprintf+0x560>
80004634:	2780006f          	j	800048ac <ee_vsprintf+0x588>
        {
            case 'c':
                if (!(flags & LEFT))
80004638:	fd842783          	lw	a5,-40(s0)
8000463c:	0107f793          	andi	a5,a5,16
80004640:	02079863          	bnez	a5,80004670 <ee_vsprintf+0x34c>
                    while (--field_width > 0)
80004644:	0180006f          	j	8000465c <ee_vsprintf+0x338>
                        *str++ = ' ';
80004648:	fe042783          	lw	a5,-32(s0)
8000464c:	00178713          	addi	a4,a5,1
80004650:	fee42023          	sw	a4,-32(s0)
80004654:	02000713          	li	a4,32
80004658:	00e78023          	sb	a4,0(a5)
                    while (--field_width > 0)
8000465c:	fd442783          	lw	a5,-44(s0)
80004660:	fff78793          	addi	a5,a5,-1
80004664:	fcf42a23          	sw	a5,-44(s0)
80004668:	fd442783          	lw	a5,-44(s0)
8000466c:	fcf04ee3          	bgtz	a5,80004648 <ee_vsprintf+0x324>
                *str++ = (unsigned char)va_arg(args, int);
80004670:	fb442783          	lw	a5,-76(s0)
80004674:	00478713          	addi	a4,a5,4
80004678:	fae42a23          	sw	a4,-76(s0)
8000467c:	0007a683          	lw	a3,0(a5)
80004680:	fe042783          	lw	a5,-32(s0)
80004684:	00178713          	addi	a4,a5,1
80004688:	fee42023          	sw	a4,-32(s0)
8000468c:	0ff6f713          	zext.b	a4,a3
80004690:	00e78023          	sb	a4,0(a5)
                while (--field_width > 0)
80004694:	0180006f          	j	800046ac <ee_vsprintf+0x388>
                    *str++ = ' ';
80004698:	fe042783          	lw	a5,-32(s0)
8000469c:	00178713          	addi	a4,a5,1
800046a0:	fee42023          	sw	a4,-32(s0)
800046a4:	02000713          	li	a4,32
800046a8:	00e78023          	sb	a4,0(a5)
                while (--field_width > 0)
800046ac:	fd442783          	lw	a5,-44(s0)
800046b0:	fff78793          	addi	a5,a5,-1
800046b4:	fcf42a23          	sw	a5,-44(s0)
800046b8:	fd442783          	lw	a5,-44(s0)
800046bc:	fcf04ee3          	bgtz	a5,80004698 <ee_vsprintf+0x374>
                continue;
800046c0:	2c80006f          	j	80004988 <ee_vsprintf+0x664>

            case 's':
                s = va_arg(args, char *);
800046c4:	fb442783          	lw	a5,-76(s0)
800046c8:	00478713          	addi	a4,a5,4
800046cc:	fae42a23          	sw	a4,-76(s0)
800046d0:	0007a783          	lw	a5,0(a5)
800046d4:	fcf42e23          	sw	a5,-36(s0)
                if (!s)
800046d8:	fdc42783          	lw	a5,-36(s0)
800046dc:	00079863          	bnez	a5,800046ec <ee_vsprintf+0x3c8>
                    s = "<NULL>";
800046e0:	800057b7          	lui	a5,0x80005
800046e4:	11078793          	addi	a5,a5,272 # 80005110 <__modsi3+0x5bc>
800046e8:	fcf42e23          	sw	a5,-36(s0)
                len = strnlen(s, precision);
800046ec:	fd042783          	lw	a5,-48(s0)
800046f0:	00078593          	mv	a1,a5
800046f4:	fdc42503          	lw	a0,-36(s0)
800046f8:	b04ff0ef          	jal	800039fc <strnlen>
800046fc:	00050793          	mv	a5,a0
80004700:	fcf42423          	sw	a5,-56(s0)
                if (!(flags & LEFT))
80004704:	fd842783          	lw	a5,-40(s0)
80004708:	0107f793          	andi	a5,a5,16
8000470c:	02079863          	bnez	a5,8000473c <ee_vsprintf+0x418>
                    while (len < field_width--)
80004710:	0180006f          	j	80004728 <ee_vsprintf+0x404>
                        *str++ = ' ';
80004714:	fe042783          	lw	a5,-32(s0)
80004718:	00178713          	addi	a4,a5,1
8000471c:	fee42023          	sw	a4,-32(s0)
80004720:	02000713          	li	a4,32
80004724:	00e78023          	sb	a4,0(a5)
                    while (len < field_width--)
80004728:	fd442783          	lw	a5,-44(s0)
8000472c:	fff78713          	addi	a4,a5,-1
80004730:	fce42a23          	sw	a4,-44(s0)
80004734:	fc842703          	lw	a4,-56(s0)
80004738:	fcf74ee3          	blt	a4,a5,80004714 <ee_vsprintf+0x3f0>
                for (i = 0; i < len; ++i)
8000473c:	fe042423          	sw	zero,-24(s0)
80004740:	0300006f          	j	80004770 <ee_vsprintf+0x44c>
                    *str++ = *s++;
80004744:	fdc42703          	lw	a4,-36(s0)
80004748:	00170793          	addi	a5,a4,1
8000474c:	fcf42e23          	sw	a5,-36(s0)
80004750:	fe042783          	lw	a5,-32(s0)
80004754:	00178693          	addi	a3,a5,1
80004758:	fed42023          	sw	a3,-32(s0)
8000475c:	00074703          	lbu	a4,0(a4)
80004760:	00e78023          	sb	a4,0(a5)
                for (i = 0; i < len; ++i)
80004764:	fe842783          	lw	a5,-24(s0)
80004768:	00178793          	addi	a5,a5,1
8000476c:	fef42423          	sw	a5,-24(s0)
80004770:	fe842703          	lw	a4,-24(s0)
80004774:	fc842783          	lw	a5,-56(s0)
80004778:	fcf746e3          	blt	a4,a5,80004744 <ee_vsprintf+0x420>
                while (len < field_width--)
8000477c:	0180006f          	j	80004794 <ee_vsprintf+0x470>
                    *str++ = ' ';
80004780:	fe042783          	lw	a5,-32(s0)
80004784:	00178713          	addi	a4,a5,1
80004788:	fee42023          	sw	a4,-32(s0)
8000478c:	02000713          	li	a4,32
80004790:	00e78023          	sb	a4,0(a5)
                while (len < field_width--)
80004794:	fd442783          	lw	a5,-44(s0)
80004798:	fff78713          	addi	a4,a5,-1
8000479c:	fce42a23          	sw	a4,-44(s0)
800047a0:	fc842703          	lw	a4,-56(s0)
800047a4:	fcf74ee3          	blt	a4,a5,80004780 <ee_vsprintf+0x45c>
                continue;
800047a8:	1e00006f          	j	80004988 <ee_vsprintf+0x664>

            case 'p':
                if (field_width == -1)
800047ac:	fd442703          	lw	a4,-44(s0)
800047b0:	fff00793          	li	a5,-1
800047b4:	00f71c63          	bne	a4,a5,800047cc <ee_vsprintf+0x4a8>
                {
                    field_width = 2 * sizeof(void *);
800047b8:	00800793          	li	a5,8
800047bc:	fcf42a23          	sw	a5,-44(s0)
                    flags |= ZEROPAD;
800047c0:	fd842783          	lw	a5,-40(s0)
800047c4:	0017e793          	ori	a5,a5,1
800047c8:	fcf42c23          	sw	a5,-40(s0)
                }
                str = number(str,
                             (unsigned long)va_arg(args, void *),
800047cc:	fb442783          	lw	a5,-76(s0)
800047d0:	00478713          	addi	a4,a5,4
800047d4:	fae42a23          	sw	a4,-76(s0)
800047d8:	0007a783          	lw	a5,0(a5)
                str = number(str,
800047dc:	00078593          	mv	a1,a5
800047e0:	fd842783          	lw	a5,-40(s0)
800047e4:	fd042703          	lw	a4,-48(s0)
800047e8:	fd442683          	lw	a3,-44(s0)
800047ec:	01000613          	li	a2,16
800047f0:	fe042503          	lw	a0,-32(s0)
800047f4:	b0cff0ef          	jal	80003b00 <number>
800047f8:	fea42023          	sw	a0,-32(s0)
                             16,
                             field_width,
                             precision,
                             flags);
                continue;
800047fc:	18c0006f          	j	80004988 <ee_vsprintf+0x664>

            case 'A':
                flags |= UPPERCASE;
80004800:	fd842783          	lw	a5,-40(s0)
80004804:	0407e793          	ori	a5,a5,64
80004808:	fcf42c23          	sw	a5,-40(s0)

            case 'a':
                if (qualifier == 'l')
8000480c:	fcc42703          	lw	a4,-52(s0)
80004810:	06c00793          	li	a5,108
80004814:	02f71a63          	bne	a4,a5,80004848 <ee_vsprintf+0x524>
                    str = eaddr(str,
80004818:	fb442783          	lw	a5,-76(s0)
8000481c:	00478713          	addi	a4,a5,4
80004820:	fae42a23          	sw	a4,-76(s0)
80004824:	0007a783          	lw	a5,0(a5)
80004828:	fd842703          	lw	a4,-40(s0)
8000482c:	fd042683          	lw	a3,-48(s0)
80004830:	fd442603          	lw	a2,-44(s0)
80004834:	00078593          	mv	a1,a5
80004838:	fe042503          	lw	a0,-32(s0)
8000483c:	e6cff0ef          	jal	80003ea8 <eaddr>
80004840:	fea42023          	sw	a0,-32(s0)
                    str = iaddr(str,
                                va_arg(args, unsigned char *),
                                field_width,
                                precision,
                                flags);
                continue;
80004844:	1440006f          	j	80004988 <ee_vsprintf+0x664>
                    str = iaddr(str,
80004848:	fb442783          	lw	a5,-76(s0)
8000484c:	00478713          	addi	a4,a5,4
80004850:	fae42a23          	sw	a4,-76(s0)
80004854:	0007a783          	lw	a5,0(a5)
80004858:	fd842703          	lw	a4,-40(s0)
8000485c:	fd042683          	lw	a3,-48(s0)
80004860:	fd442603          	lw	a2,-44(s0)
80004864:	00078593          	mv	a1,a5
80004868:	fe042503          	lw	a0,-32(s0)
8000486c:	801ff0ef          	jal	8000406c <iaddr>
80004870:	fea42023          	sw	a0,-32(s0)
                continue;
80004874:	1140006f          	j	80004988 <ee_vsprintf+0x664>

            // Integer number formats - set up the flags and "break"
            case 'o':
                base = 8;
80004878:	00800793          	li	a5,8
8000487c:	fef42223          	sw	a5,-28(s0)
                break;
80004880:	08c0006f          	j	8000490c <ee_vsprintf+0x5e8>

            case 'X':
                flags |= UPPERCASE;
80004884:	fd842783          	lw	a5,-40(s0)
80004888:	0407e793          	ori	a5,a5,64
8000488c:	fcf42c23          	sw	a5,-40(s0)

            case 'x':
                base = 16;
80004890:	01000793          	li	a5,16
80004894:	fef42223          	sw	a5,-28(s0)
                break;
80004898:	0740006f          	j	8000490c <ee_vsprintf+0x5e8>

            case 'd':
            case 'i':
                flags |= SIGN;
8000489c:	fd842783          	lw	a5,-40(s0)
800048a0:	0027e793          	ori	a5,a5,2
800048a4:	fcf42c23          	sw	a5,-40(s0)

            case 'u':
                break;
800048a8:	0600006f          	j	80004908 <ee_vsprintf+0x5e4>
                continue;

#endif

            default:
                if (*fmt != '%')
800048ac:	fb842783          	lw	a5,-72(s0)
800048b0:	0007c703          	lbu	a4,0(a5)
800048b4:	02500793          	li	a5,37
800048b8:	00f70c63          	beq	a4,a5,800048d0 <ee_vsprintf+0x5ac>
                    *str++ = '%';
800048bc:	fe042783          	lw	a5,-32(s0)
800048c0:	00178713          	addi	a4,a5,1
800048c4:	fee42023          	sw	a4,-32(s0)
800048c8:	02500713          	li	a4,37
800048cc:	00e78023          	sb	a4,0(a5)
                if (*fmt)
800048d0:	fb842783          	lw	a5,-72(s0)
800048d4:	0007c783          	lbu	a5,0(a5)
800048d8:	02078063          	beqz	a5,800048f8 <ee_vsprintf+0x5d4>
                    *str++ = *fmt;
800048dc:	fb842703          	lw	a4,-72(s0)
800048e0:	fe042783          	lw	a5,-32(s0)
800048e4:	00178693          	addi	a3,a5,1
800048e8:	fed42023          	sw	a3,-32(s0)
800048ec:	00074703          	lbu	a4,0(a4)
800048f0:	00e78023          	sb	a4,0(a5)
                else
                    --fmt;
                continue;
800048f4:	0940006f          	j	80004988 <ee_vsprintf+0x664>
                    --fmt;
800048f8:	fb842783          	lw	a5,-72(s0)
800048fc:	fff78793          	addi	a5,a5,-1
80004900:	faf42c23          	sw	a5,-72(s0)
                continue;
80004904:	0840006f          	j	80004988 <ee_vsprintf+0x664>
                break;
80004908:	00000013          	nop
        }

        if (qualifier == 'l')
8000490c:	fcc42703          	lw	a4,-52(s0)
80004910:	06c00793          	li	a5,108
80004914:	00f71e63          	bne	a4,a5,80004930 <ee_vsprintf+0x60c>
            num = va_arg(args, unsigned long);
80004918:	fb442783          	lw	a5,-76(s0)
8000491c:	00478713          	addi	a4,a5,4
80004920:	fae42a23          	sw	a4,-76(s0)
80004924:	0007a783          	lw	a5,0(a5)
80004928:	fef42623          	sw	a5,-20(s0)
8000492c:	03c0006f          	j	80004968 <ee_vsprintf+0x644>
        else if (flags & SIGN)
80004930:	fd842783          	lw	a5,-40(s0)
80004934:	0027f793          	andi	a5,a5,2
80004938:	00078e63          	beqz	a5,80004954 <ee_vsprintf+0x630>
            num = va_arg(args, int);
8000493c:	fb442783          	lw	a5,-76(s0)
80004940:	00478713          	addi	a4,a5,4
80004944:	fae42a23          	sw	a4,-76(s0)
80004948:	0007a783          	lw	a5,0(a5)
8000494c:	fef42623          	sw	a5,-20(s0)
80004950:	0180006f          	j	80004968 <ee_vsprintf+0x644>
        else
            num = va_arg(args, unsigned int);
80004954:	fb442783          	lw	a5,-76(s0)
80004958:	00478713          	addi	a4,a5,4
8000495c:	fae42a23          	sw	a4,-76(s0)
80004960:	0007a783          	lw	a5,0(a5)
80004964:	fef42623          	sw	a5,-20(s0)

        str = number(str, num, base, field_width, precision, flags);
80004968:	fec42583          	lw	a1,-20(s0)
8000496c:	fd842783          	lw	a5,-40(s0)
80004970:	fd042703          	lw	a4,-48(s0)
80004974:	fd442683          	lw	a3,-44(s0)
80004978:	fe442603          	lw	a2,-28(s0)
8000497c:	fe042503          	lw	a0,-32(s0)
80004980:	980ff0ef          	jal	80003b00 <number>
80004984:	fea42023          	sw	a0,-32(s0)
    for (str = buf; *fmt; fmt++)
80004988:	fb842783          	lw	a5,-72(s0)
8000498c:	00178793          	addi	a5,a5,1
80004990:	faf42c23          	sw	a5,-72(s0)
80004994:	fb842783          	lw	a5,-72(s0)
80004998:	0007c783          	lbu	a5,0(a5)
8000499c:	9a0798e3          	bnez	a5,8000434c <ee_vsprintf+0x28>
    }

    *str = '\0';
800049a0:	fe042783          	lw	a5,-32(s0)
800049a4:	00078023          	sb	zero,0(a5)
    return str - buf;
800049a8:	fe042703          	lw	a4,-32(s0)
800049ac:	fbc42783          	lw	a5,-68(s0)
800049b0:	40f707b3          	sub	a5,a4,a5
}
800049b4:	00078513          	mv	a0,a5
800049b8:	04c12083          	lw	ra,76(sp)
800049bc:	04812403          	lw	s0,72(sp)
800049c0:	05010113          	addi	sp,sp,80
800049c4:	00008067          	ret

800049c8 <uart_send_char>:

void
uart_send_char(char c)
{
800049c8:	fe010113          	addi	sp,sp,-32
800049cc:	00112e23          	sw	ra,28(sp)
800049d0:	00812c23          	sw	s0,24(sp)
800049d4:	02010413          	addi	s0,sp,32
800049d8:	00050793          	mv	a5,a0
800049dc:	fef407a3          	sb	a5,-17(s0)
    return ;
800049e0:	00000013          	nop
//             while (*UART_CONTROL_ADDRESS != UART_READY);

//             Check the UART sample code on your platform or the board
//        documentation.
//     */
}
800049e4:	01c12083          	lw	ra,28(sp)
800049e8:	01812403          	lw	s0,24(sp)
800049ec:	02010113          	addi	sp,sp,32
800049f0:	00008067          	ret

800049f4 <ee_printf>:

int
ee_printf(const char *fmt, ...)
{
800049f4:	bb010113          	addi	sp,sp,-1104
800049f8:	42112623          	sw	ra,1068(sp)
800049fc:	42812423          	sw	s0,1064(sp)
80004a00:	43010413          	addi	s0,sp,1072
80004a04:	bca42e23          	sw	a0,-1060(s0)
80004a08:	00b42223          	sw	a1,4(s0)
80004a0c:	00c42423          	sw	a2,8(s0)
80004a10:	00d42623          	sw	a3,12(s0)
80004a14:	00e42823          	sw	a4,16(s0)
80004a18:	00f42a23          	sw	a5,20(s0)
80004a1c:	01042c23          	sw	a6,24(s0)
80004a20:	01142e23          	sw	a7,28(s0)
    char    buf[1024], *p;
    va_list args;
    int     n = 0;
80004a24:	fe042423          	sw	zero,-24(s0)

    va_start(args, fmt);
80004a28:	02040793          	addi	a5,s0,32
80004a2c:	bcf42c23          	sw	a5,-1064(s0)
80004a30:	bd842783          	lw	a5,-1064(s0)
80004a34:	fe478793          	addi	a5,a5,-28
80004a38:	bef42223          	sw	a5,-1052(s0)
    ee_vsprintf(buf, fmt, args);
80004a3c:	be442703          	lw	a4,-1052(s0)
80004a40:	be840793          	addi	a5,s0,-1048
80004a44:	00070613          	mv	a2,a4
80004a48:	bdc42583          	lw	a1,-1060(s0)
80004a4c:	00078513          	mv	a0,a5
80004a50:	8d5ff0ef          	jal	80004324 <ee_vsprintf>
    va_end(args);
    p = buf;
80004a54:	be840793          	addi	a5,s0,-1048
80004a58:	fef42623          	sw	a5,-20(s0)
    while (*p)
80004a5c:	02c0006f          	j	80004a88 <ee_printf+0x94>
    {
        uart_send_char(*p);
80004a60:	fec42783          	lw	a5,-20(s0)
80004a64:	0007c783          	lbu	a5,0(a5)
80004a68:	00078513          	mv	a0,a5
80004a6c:	f5dff0ef          	jal	800049c8 <uart_send_char>
        n++;
80004a70:	fe842783          	lw	a5,-24(s0)
80004a74:	00178793          	addi	a5,a5,1
80004a78:	fef42423          	sw	a5,-24(s0)
        p++;
80004a7c:	fec42783          	lw	a5,-20(s0)
80004a80:	00178793          	addi	a5,a5,1
80004a84:	fef42623          	sw	a5,-20(s0)
    while (*p)
80004a88:	fec42783          	lw	a5,-20(s0)
80004a8c:	0007c783          	lbu	a5,0(a5)
80004a90:	fc0798e3          	bnez	a5,80004a60 <ee_printf+0x6c>
    }

    return n;
80004a94:	fe842783          	lw	a5,-24(s0)
}
80004a98:	00078513          	mv	a0,a5
80004a9c:	42c12083          	lw	ra,1068(sp)
80004aa0:	42812403          	lw	s0,1064(sp)
80004aa4:	45010113          	addi	sp,sp,1104
80004aa8:	00008067          	ret

80004aac <__mulsi3>:
/* Our RV64 64-bit routine is equivalent to our RV32 32-bit routine.  */
# define __muldi3 __mulsi3
#endif

FUNC_BEGIN (__muldi3)
  mv     a2, a0
80004aac:	00050613          	mv	a2,a0
  li     a0, 0
80004ab0:	00000513          	li	a0,0
.L1:
  andi   a3, a1, 1
80004ab4:	0015f693          	andi	a3,a1,1
  beqz   a3, .L2
80004ab8:	00068463          	beqz	a3,80004ac0 <__mulsi3+0x14>
  add    a0, a0, a2
80004abc:	00c50533          	add	a0,a0,a2
.L2:
  srli   a1, a1, 1
80004ac0:	0015d593          	srli	a1,a1,0x1
  slli   a2, a2, 1
80004ac4:	00161613          	slli	a2,a2,0x1
  bnez   a1, .L1
80004ac8:	fe0596e3          	bnez	a1,80004ab4 <__mulsi3+0x8>
  ret
80004acc:	00008067          	ret

80004ad0 <__divsi3>:
  li    t0, -1
  beq   a1, t0, .L20
#endif

FUNC_BEGIN (__divdi3)
  bltz  a0, .L10
80004ad0:	06054063          	bltz	a0,80004b30 <__umodsi3+0x10>
  bltz  a1, .L11
80004ad4:	0605c663          	bltz	a1,80004b40 <__umodsi3+0x20>

80004ad8 <__hidden___udivsi3>:
  /* Since the quotient is positive, fall into __udivdi3.  */

FUNC_BEGIN (__udivdi3)
  mv    a2, a1
80004ad8:	00058613          	mv	a2,a1
  mv    a1, a0
80004adc:	00050593          	mv	a1,a0
  li    a0, -1
80004ae0:	fff00513          	li	a0,-1
  beqz  a2, .L5
80004ae4:	02060c63          	beqz	a2,80004b1c <__hidden___udivsi3+0x44>
  li    a3, 1
80004ae8:	00100693          	li	a3,1
  bgeu  a2, a1, .L2
80004aec:	00b67a63          	bgeu	a2,a1,80004b00 <__hidden___udivsi3+0x28>
.L1:
  blez  a2, .L2
80004af0:	00c05863          	blez	a2,80004b00 <__hidden___udivsi3+0x28>
  slli  a2, a2, 1
80004af4:	00161613          	slli	a2,a2,0x1
  slli  a3, a3, 1
80004af8:	00169693          	slli	a3,a3,0x1
  bgtu  a1, a2, .L1
80004afc:	feb66ae3          	bltu	a2,a1,80004af0 <__hidden___udivsi3+0x18>
.L2:
  li    a0, 0
80004b00:	00000513          	li	a0,0
.L3:
  bltu  a1, a2, .L4
80004b04:	00c5e663          	bltu	a1,a2,80004b10 <__hidden___udivsi3+0x38>
  sub   a1, a1, a2
80004b08:	40c585b3          	sub	a1,a1,a2
  or    a0, a0, a3
80004b0c:	00d56533          	or	a0,a0,a3
.L4:
  srli  a3, a3, 1
80004b10:	0016d693          	srli	a3,a3,0x1
  srli  a2, a2, 1
80004b14:	00165613          	srli	a2,a2,0x1
  bnez  a3, .L3
80004b18:	fe0696e3          	bnez	a3,80004b04 <__hidden___udivsi3+0x2c>
.L5:
  ret
80004b1c:	00008067          	ret

80004b20 <__umodsi3>:
FUNC_END (__udivdi3)
HIDDEN_DEF (__udivdi3)

FUNC_BEGIN (__umoddi3)
  /* Call __udivdi3(a0, a1), then return the remainder, which is in a1.  */
  move  t0, ra
80004b20:	00008293          	mv	t0,ra
  jal   HIDDEN_JUMPTARGET(__udivdi3)
80004b24:	fb5ff0ef          	jal	80004ad8 <__hidden___udivsi3>
  move  a0, a1
80004b28:	00058513          	mv	a0,a1
  jr    t0
80004b2c:	00028067          	jr	t0
FUNC_END (__umoddi3)

  /* Handle negative arguments to __divdi3.  */
.L10:
  neg   a0, a0
80004b30:	40a00533          	neg	a0,a0
  /* Zero is handled as a negative so that the result will not be inverted.  */
  bgtz  a1, .L12     /* Compute __udivdi3(-a0, a1), then negate the result.  */
80004b34:	00b04863          	bgtz	a1,80004b44 <__umodsi3+0x24>

  neg   a1, a1
80004b38:	40b005b3          	neg	a1,a1
  j     HIDDEN_JUMPTARGET(__udivdi3)     /* Compute __udivdi3(-a0, -a1).  */
80004b3c:	f9dff06f          	j	80004ad8 <__hidden___udivsi3>
.L11:                /* Compute __udivdi3(a0, -a1), then negate the result.  */
  neg   a1, a1
80004b40:	40b005b3          	neg	a1,a1
.L12:
  move  t0, ra
80004b44:	00008293          	mv	t0,ra
  jal   HIDDEN_JUMPTARGET(__udivdi3)
80004b48:	f91ff0ef          	jal	80004ad8 <__hidden___udivsi3>
  neg   a0, a0
80004b4c:	40a00533          	neg	a0,a0
  jr    t0
80004b50:	00028067          	jr	t0

80004b54 <__modsi3>:
FUNC_END (__divdi3)

FUNC_BEGIN (__moddi3)
  move   t0, ra
80004b54:	00008293          	mv	t0,ra
  bltz   a1, .L31
80004b58:	0005ca63          	bltz	a1,80004b6c <__modsi3+0x18>
  bltz   a0, .L32
80004b5c:	00054c63          	bltz	a0,80004b74 <__modsi3+0x20>
.L30:
  jal    HIDDEN_JUMPTARGET(__udivdi3)    /* The dividend is not negative.  */
80004b60:	f79ff0ef          	jal	80004ad8 <__hidden___udivsi3>
  move   a0, a1
80004b64:	00058513          	mv	a0,a1
  jr     t0
80004b68:	00028067          	jr	t0
.L31:
  neg    a1, a1
80004b6c:	40b005b3          	neg	a1,a1
  bgez   a0, .L30
80004b70:	fe0558e3          	bgez	a0,80004b60 <__modsi3+0xc>
.L32:
  neg    a0, a0
80004b74:	40a00533          	neg	a0,a0
  jal    HIDDEN_JUMPTARGET(__udivdi3)    /* The dividend is hella negative.  */
80004b78:	f61ff0ef          	jal	80004ad8 <__hidden___udivsi3>
  neg    a0, a1
80004b7c:	40b00533          	neg	a0,a1
  jr     t0
80004b80:	00028067          	jr	t0
