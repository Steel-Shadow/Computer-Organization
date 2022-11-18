# cpu 设计文档

## 设计说明
处理器为 32 位单周期处理器，不考虑延迟槽，应支持的指令集为：
add, sub, ori, lw, sw, beq, lui, jal, jr, nop     
nop 为空指令，机器码 0x00000000，不进行任何有效行为（修改寄存器等）。

add, sub 按无符号加减法处理（不考虑溢出）。     
需要采用模块化和层次化设计。顶层文件为 mips.v，有效的驱动信号要求包括且仅包括同步复位信号 reset和时钟信号 clk。

复位后，PC 指向 0x00003000，此处为第一条指令的地址，GRF 和 DM 中的所有数据清零。注意与 MARS 中的设置保持一致。在复位期间对存储单元进行操作请不要输出任何信息，以免影响评测结果。

在 GRF 模块中，每个时钟上升沿到来时若要写入数据（即写使能信号为 1 且非 reset 时）则输出写入的位置及写入的值，格式（请注意空格）为：
```verilog
$display("@%h: $%d <= %h", WPC, Waddr, WData);
```
其中 WPC 表示相应指令的储存地址，从 0x00003000 开始；Waddr 表示输入的 5 位写寄存器的地址；WData 表示输入的 32 位写入寄存器的值。
不足 8 位需要补零。

在 DM 模块中，每个时钟上升沿到来时若要写入数据（即写使能信号为 1 且非 reset 时）则输出写入的位置及写入的值，格式（请注意空格）为：
```verilog
$display("@%h: *%h <= %h", pc, addr, din);
```

## DATAPATH 数据通路

### PC 程序计数器
clk reset next_pc_op in0-7      
pc_out

与 logisim 版本不同，NPC 模块被合并到 pc 中     
复位后，PC 指向 0x00003000，此处为第一条指令的地址，与 MARS 的 Memory Configuration 相匹配     

### IM 指令存储器
pc
instr

IM 容量为 16KiB（4096 × 32bit）

实际 inst_mem 只有1024字
pc_index = pc - 32'h3000;

code.txt 应当放在工作主目录下！！！
```verilog
initial begin
    $readmemh("code.txt", inst_mem);
end
```

### GRF 寄存器堆
reset clk pc reg_write a1 a2(rt) reg_addr reg_data  
read1 read2

### ALU 算术单元
a b alu_op
alu_out

add, sub, ori, lw, sw, beq, lui, jal, jr, nop

### DM 数据存储器
clk reset pc mem_write mem_addr_byte mem_data  
dm_out

DM 容量为 12KiB（3072 × 32bit）
实际容量为4096字

未检查 DM 写入地址是否与 IM 冲突

## controller CU 控制器 
instruct    

rs rt rd shamt imm j_address    
next_pc_op       
reg_write a1_op reg_addr_op reg_data_op    
alu_op alu_b_op  
mem_write

支持指令 add, sub, ori, lw, sw, beq, lui, jal, jr, nop 
添加指令 sll    
lh slt srav 未在下表中列出信号      

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
alu_op 为 3 位   
compare(>1 ==0 <-1) 有符号比较

| alu_b_op |   0   |      1       |      2       |       3        |
| :------: | :---: | :----------: | :----------: | :------------: |
|  instr   | else  |    lw sw     |     ori      |      sll       |
|  alu_b   | read2 | sign_ext imm | zero_ext imm | zero_ext shamt |

# 测试方案
运行 test\construct.exe (讨论区) 输出 random_code.asm 再复制到test_code.asm 
或者自行编写 test_code.asm      
运行 easy_mars.bat，得到 Hex 机械码 code.txt (讨论区)，正确输出 mars_out.txt     
手动打开 ISE 仿真输出 cpu_out.txt，比较结果

# 思考题
1.  阅读下面给出的 DM 的输入示例中（示例 DM 容量为 4KB，即 32bit × 1024字），根据你的理解回答，这个 addr 信号又是从哪里来的？地址信号 addr 位数为什么是 [11:2] 而不是 [9:0] ？

    访存字地址 addr 由 ALU 计算产生。ALU 的结算结果 addrByte，但 DM 按字编址，访存地址 addr = addrByte/4。

2.  思考上述两种控制器设计的译码方式，给出代码示例，并尝试对比各方式的优劣。

    指令对应的控制信号如何取值
    方便指令添加，利于指令控制信号检查
    指令关系不明朗，需另外标注分组

    记录下控制信号每种取值所对应的指令
    添加指令较繁琐，需要找到各个信号逐一添加，不利于指令信号检查
    同类指令控制信号相同，指令关系清晰

3.  在相应的部件中，复位信号的设计都是同步复位，这与 P3 中的设计要求不同。请对比同步复位与异步复位这两种方式的 reset 信号与 clk 信号优先级的关系。

    异步复位： reset 优先级更高， reset 为 1 时，clk被忽略，触发复位
    同步复位： clk 优先级更高， 当 clk 上升沿且 reset 为 1 时，才触发复位

4. C 语言是一种弱类型程序设计语言。C 语言中不对计算结果溢出进行处理，这意味着 C 语言要求程序员必须很清楚计算结果是否会导致溢出。因此，如果仅仅支持 C 语言，MIPS 指令的所有计算指令均可以忽略溢出。 请说明为什么在忽略溢出的前提下，addi 与 addiu 是等价的，add 与 addu 是等价的。提示：阅读《MIPS32? Architecture For Programmers Volume II: The MIPS32? Instruction Set》中相关指令的 Operation 部分 。

    addi
    temp <- (GPR[rs]31 || GPR[rs]) + sign_extend(immediate)
    if temp32 ≠ temp31 then
        SignalException(IntegerOverflow)
    else
        GPR[rt] ← temp31..0
    endif

    addiu
    GPR[rt] <- GPR[rs] + sign_extend(immediate)

    addi 指令中的 temp 和 addiu 的右值的区别在于，最高位拼接了 GPR[rs]的最高位，但是0~31位是相同的。
