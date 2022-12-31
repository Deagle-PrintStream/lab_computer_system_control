# 计算机控制基础结课大作业

> TAGS: Fundamentals of Computer Control , cybernetics , USTC , UAV , MATLAB .
> 计算机控制基础 中科大 控制论 无人机
> A shallow repository of the MATLAB script for the closing thesis of lesson EE3006.01 in USTC 2022.

结课大作业要求见`大实验要求.pdf`，
需要指出的是:
- 状态向量 $X$ 中的第九个变量不是 $\Delta$ 而是 $\Delta\psi$。
- 状态向量 $X$ 中 $q=\dot\psi$
- 第四题部分要求是无解的
- 第五题的题目重复了一遍

matlab脚本见`lab_control_temp.m`。
其中每道题需要的脚本分别封装成了函数，例如Q8，需要自行带入参数取演算。其中可行解被设定为默认参数，以供参考。

仓库中有部分图像，少数是错误的，
