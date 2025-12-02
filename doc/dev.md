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


## 功能仿真

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

## 板级测试

使用[ACX750开发板](https://item.taobao.com/item.htm?id=758253035042)进行UART串口测试DES

生成并写入bit文件
``` bash
cd dir_has_1.DES
vivado -mode tcl
# copy or source serial_uart.tcl
source 1.DES/bin/serial_uart.tcl
```

PowerShell，WSL连接主机串口
``` bash
usbipd list
usbipd bind --busid 5-3
usbipd attach --wsl --busid=5-3
usbipd detach --busid=5-3
usbipd unbind --busid=5-3
```

使用python调用串口: `1.DES/bin/serial_uart.py`

