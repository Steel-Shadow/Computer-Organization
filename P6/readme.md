mult, multu, div, divu, mfhi, mflo, mthi, mtlo

​乘除模块行为约定如下：

    自 Start 信号有效后的第 1 个 clock 上升沿开始，乘除法部件开始执行运算，同时将 Busy 置位为 1。
    在运算结果保存到 HI 寄存器和 LO 寄存器后，Busy 位清除为 0。
    当 Busy 信号或 Start 信号为 1 时，mult, multu, div, divu, mfhi, mflo, mthi, mtlo 等乘除法相关的指令均被阻塞在 D 流水级。
    数据写入 HI 寄存器或 LO 寄存器，均只需 1 个时钟周期。
