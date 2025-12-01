# 开发环境

## 搭建

``` bash
# 符号解析
micromamba install universal-ctags
# LSP
micromamba install verible
# 功能仿真
micromamba install iverilog
```


## 测试

以DES为例
``` bash
cd 1.DES
# 功能仿真
iverilog src/*.sv test/*.sv -s test_en -g2009 -o test_en.run
# 运行功能仿真，生成vcd波形文件
./test_en.run
# 预览vcd
# vscode extension: surfer-project.surfer
```

