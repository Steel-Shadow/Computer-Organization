# cpu ����ĵ�

## ���˵��
������Ϊ 32 λ�����ڴ��������������ӳٲۣ�Ӧ֧�ֵ�ָ�Ϊ��
add, sub, ori, lw, sw, beq, lui, jal, jr, nop     
nop Ϊ��ָ������� 0x00000000���������κ���Ч��Ϊ���޸ļĴ����ȣ���

add, sub ���޷��żӼ��������������������     
��Ҫ����ģ�黯�Ͳ�λ���ơ������ļ�Ϊ mips.v����Ч�������ź�Ҫ������ҽ�����ͬ����λ�ź� reset��ʱ���ź� clk��

��λ��PC ָ�� 0x00003000���˴�Ϊ��һ��ָ��ĵ�ַ��GRF �� DM �е������������㡣ע���� MARS �е����ñ���һ�¡��ڸ�λ�ڼ�Դ洢��Ԫ���в����벻Ҫ����κ���Ϣ������Ӱ����������

�� GRF ģ���У�ÿ��ʱ�������ص���ʱ��Ҫд�����ݣ���дʹ���ź�Ϊ 1 �ҷ� reset ʱ�������д���λ�ü�д���ֵ����ʽ����ע��ո�Ϊ��
```verilog
$display("@%h: $%d <= %h", WPC, Waddr, WData);
```
���� WPC ��ʾ��Ӧָ��Ĵ����ַ���� 0x00003000 ��ʼ��Waddr ��ʾ����� 5 λд�Ĵ����ĵ�ַ��WData ��ʾ����� 32 λд��Ĵ�����ֵ��
���� 8 λ��Ҫ���㡣

�� DM ģ���У�ÿ��ʱ�������ص���ʱ��Ҫд�����ݣ���дʹ���ź�Ϊ 1 �ҷ� reset ʱ�������д���λ�ü�д���ֵ����ʽ����ע��ո�Ϊ��
```verilog
$display("@%h: *%h <= %h", pc, addr, din);
```

## DATAPATH ����ͨ·

### PC ���������
clk reset next_pc_op in0-7      
pc_out

�� logisim �汾��ͬ��NPC ģ�鱻�ϲ��� pc ��     
��λ��PC ָ�� 0x00003000���˴�Ϊ��һ��ָ��ĵ�ַ���� MARS �� Memory Configuration ��ƥ��     

### IM ָ��洢��
pc
instr

IM ����Ϊ 16KiB��4096 �� 32bit��

ʵ�� inst_mem ֻ��1024��
pc_index = pc - 32'h3000;

code.txt Ӧ�����ڹ�����Ŀ¼�£�����
```verilog
initial begin
    $readmemh("code.txt", inst_mem);
end
```

### GRF �Ĵ�����
reset clk pc reg_write a1 a2(rt) reg_addr reg_data  
read1 read2

### ALU ������Ԫ
a b alu_op
alu_out

add, sub, ori, lw, sw, beq, lui, jal, jr, nop

### DM ���ݴ洢��
clk reset pc mem_write mem_addr_byte mem_data  
dm_out

DM ����Ϊ 12KiB��3072 �� 32bit��
ʵ������Ϊ4096��

δ��� DM д���ַ�Ƿ��� IM ��ͻ

## controller CU ������ 
instruct    

rs rt rd shamt imm j_address    
next_pc_op       
reg_write a1_op reg_addr_op reg_data_op    
alu_op alu_b_op  
mem_write

֧��ָ�� add, sub, ori, lw, sw, beq, lui, jal, jr, nop 
���ָ�� sll    
lh slt srav δ���±����г��ź�      

PC
-----------------------------------------------------------------------------
| next_pc_op |   0   |   1    |     2     |   3   |   4   |
| :--------: | :---: | :----: | :-------: | :---: | :---: |
|   instr    | else  |  beq   |    jal    |  jr   |       |
|  next_pc   | pc+4  | pc+4+? | j_address | read1 |       |

GRF
-----------------------------------------------------------------------------
| a1_op |   0   |   1   |
| :---: | :---: | :---: |
| instr | else  |  sll  |
|  a1   |  rs   |  rt   |

| reg_addr_op |      0      |     1      |   2    |   3   |
| :---------: | :---------: | :--------: | :----: | :---: |
|    instr    | add sub sll | lw lui ori |  jal   | else  |
|  reg_addr   |     rd      |     rt     | 31 $ra |       |

| reg_data_op |    0    |   1    |    2     |   3   |
| :---------: | :-----: | :----: | :------: | :---: |
|    instr    |  else   |   lw   |   lui    |  jal  |
|  reg_data   | alu_out | dm_out | imm_0^16 | pc+4  |

ALU
-------------------------------------------------------------------------------
| alu_op  |   0   |   1   |   2   |     3      |   4   |
| :-----: | :---: | :---: | :---: | :--------: | :---: |
|  instr  | else  |  sub  |  ori  |    beq     |  sll  |
| alu_out |   +   |   -   |  or   | >1 ==0 <-1 | a<<B  |
alu_op Ϊ 3 λ   
compare(>1 ==0 <-1) �з��űȽ�

| alu_b_op |   0   |      1       |      2       |       3        |
| :------: | :---: | :----------: | :----------: | :------------: |
|  instr   | else  |    lw sw     |     ori      |      sll       |
|  alu_b   | read2 | sign_ext imm | zero_ext imm | zero_ext shamt |

# ���Է���
���� test\construct.exe (������) ��� random_code.asm �ٸ��Ƶ�test_code.asm 
�������б�д test_code.asm      
���� easy_mars.bat���õ� Hex ��е�� code.txt (������)����ȷ��� mars_out.txt     
�ֶ��� ISE ������� cpu_out.txt���ȽϽ��

# ˼����
1.  �Ķ���������� DM ������ʾ���У�ʾ�� DM ����Ϊ 4KB���� 32bit �� 1024�֣�������������ش���� addr �ź����Ǵ��������ģ���ַ�ź� addr λ��Ϊʲô�� [11:2] ������ [9:0] ��

    �ô��ֵ�ַ addr �� ALU ���������ALU �Ľ����� addrByte���� DM ���ֱ�ַ���ô��ַ addr = addrByte/4��

2.  ˼���������ֿ�������Ƶ����뷽ʽ����������ʾ���������ԶԱȸ���ʽ�����ӡ�

    ָ���Ӧ�Ŀ����ź����ȡֵ
    ����ָ����ӣ�����ָ������źż��
    ָ���ϵ�����ʣ��������ע����

    ��¼�¿����ź�ÿ��ȡֵ����Ӧ��ָ��
    ���ָ��Ϸ�������Ҫ�ҵ������ź���һ��ӣ�������ָ���źż��
    ͬ��ָ������ź���ͬ��ָ���ϵ����

3.  ����Ӧ�Ĳ����У���λ�źŵ���ƶ���ͬ����λ������ P3 �е����Ҫ��ͬ����Ա�ͬ����λ���첽��λ�����ַ�ʽ�� reset �ź��� clk �ź����ȼ��Ĺ�ϵ��

    �첽��λ�� reset ���ȼ����ߣ� reset Ϊ 1 ʱ��clk�����ԣ�������λ
    ͬ����λ�� clk ���ȼ����ߣ� �� clk �������� reset Ϊ 1 ʱ���Ŵ�����λ

4. C ������һ�������ͳ���������ԡ�C �����в��Լ�����������д�������ζ�� C ����Ҫ�����Ա���������������Ƿ�ᵼ���������ˣ��������֧�� C ���ԣ�MIPS ָ������м���ָ������Ժ�������� ��˵��Ϊʲô�ں��������ǰ���£�addi �� addiu �ǵȼ۵ģ�add �� addu �ǵȼ۵ġ���ʾ���Ķ���MIPS32? Architecture For Programmers Volume II: The MIPS32? Instruction Set�������ָ��� Operation ���� ��

    addi
    temp <- (GPR[rs]31 || GPR[rs]) + sign_extend(immediate)
    if temp32 �� temp31 then
        SignalException(IntegerOverflow)
    else
        GPR[rt] �� temp31..0
    endif

    addiu
    GPR[rt] <- GPR[rs] + sign_extend(immediate)

    addi ָ���е� temp �� addiu ����ֵ���������ڣ����λƴ���� GPR[rs]�����λ������0~31λ����ͬ�ġ�
