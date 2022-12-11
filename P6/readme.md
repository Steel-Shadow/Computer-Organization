mult, multu, div, divu, mfhi, mflo, mthi, mtlo

乘除法部件中内置了 HI 和 LO 两个寄存器，这两个寄存器同时也是与外界沟通的窗口。另外乘除法部件有天然的运算功能，因此其余的端口设计类似于 GRF 和 ALU，此处就不再赘述了。

​乘除模块行为约定如下：

    自 Start 信号有效后的第 1 个 clock 上升沿开始，乘除法部件开始执行运算，同时将 Busy 置位为 1。
    在运算结果保存到 HI 寄存器和 LO 寄存器后，Busy 位清除为 0。
    当 Busy 信号或 Start 信号为 1 时，mult, multu, div, divu, mfhi, mflo, mthi, mtlo 等乘除法相关的指令均被阻塞在 D 流水级。
    数据写入 HI 寄存器或 LO 寄存器，均只需 1 个时钟周期。

一些同学的实现中，为了获得更好的性能，当 Busy 信号或 Start 信号为 1（正在进行乘除法计算）时，执行乘除法指令 mult, multu, div, divu 将取消先前的乘除法计算。

对于这部分同学，我们保证你不会因为 CPU 执行周期过少而无法通过评测（评测数据中不存在连续两条乘除法指令，保证每一条乘除法指令执行完都会先进行 mfhi 和 mflo 操作）。

mult, multu, div, divu，Tnew为1，reg_addr为0

Wrong instruction behaviour. 
We got 
'@000031f0: $ 5 <= 00000000'
when we expected 
'@000031f0: $ 5 <= 00000001'. *