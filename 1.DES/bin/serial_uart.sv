`timescale 1ns/1ns

// 使用串口进行板级测试
// UART传输8bit，每接收64bit数据进行操作
// 操作后将结果送出

module serial_uart (
    input clk,
    // 接收
    input uart_rx,
    // 发送
    output reg uart_tx,
    output status1,
    output status2,
    output status3,
    output status4
);

parameter int CLK_FREQ = 50_000_000;
parameter int BAUD = 9600;
parameter int MCNT_BAUD = CLK_FREQ / BAUD - 1;

// 每次接收的数据
reg [7:0] data = 8'd0;
// UART在第几位上面
// 0-7为正在接收或发送的8位数据，8为结束位
// 4'b1001，9为等待接收
reg [3:0] index = 4'd9;
// 2'b10为接收，2'b01为发送，其余状态为正在处理
reg [1:0] status = 2'b10;
// 需要接收完毕的数据
reg [63:0] data_key = 64'd0;
reg [71:0] data_rx = 72'd0;
reg [63:0] data_tx = 64'd0;
// 每次接收数据放在第几个8bit
reg [3:0] data_index = 4'd0;

reg [14:0] baud_index = 15'd0;


reg [127:0] data_calc;
des_en des_en_inst (
    .data_in(data_rx[71:8]),
    .key(data_key),
    .data_out(data_calc[63:0])
);
des_de des_de_inst (
    .data_in(data_rx[71:8]),
    .key(data_key),
    .data_out(data_calc[127:64])
);
assign status1 = data_rx[0];
assign status2 = data_rx[4];
assign status3 = status[0];
assign status4 = status[1];

always @(posedge clk) begin
    baud_index = baud_index + 1;
    if (baud_index == MCNT_BAUD || (status == 2'b10 && index == 4'd9 && !uart_rx)) begin
        baud_index = 15'd0;
        if (status == 2'b01) begin
            // 发送
            if (index < 4'd8) begin
                // 数据
                uart_tx = data[index];
                index = index + 1;
            end
            else if (index == 4'd9) begin
                // 开始位
                // index=9, uart_rx拉低
                // 准备传输数据
                index = 0;
                uart_tx = 0;
                data = data_tx[data_index*8+:8];
            end
            else if (index == 4'd8) begin
                // 结束位
                // index=8, uart_rx拉高
                // 恢复开始位
                // 数据写入
                index = 4'd9;
                uart_tx = 1;
                if (data_index == 4'd7) begin
                    // 发送完毕，开始接收新一轮
                    status = 2'b10;
                    data_index = 4'd0;
                end
                else
                    data_index = data_index + 1;
            end
            else begin
                // 开始或结束校验错误
                // 恢复开始位
                // 数据重新读取
                index = 4'd9;
                data_index = 4'd0;
            end
        end
        else if (status == 2'b10) begin
            // 接收
            if (index < 4'd8) begin
                // 数据
                data[index] = uart_rx;
                index = index + 1;
            end
            else if (index == 4'd9 && !uart_rx)
                // 开始位
                // index=9, uart_rx拉低
                // 准备传输数据
                index = 0;
            else if (index == 4'd8 && uart_rx) begin
                // 结束位
                // index=8, uart_rx拉高
                // 恢复开始位
                // 数据写入
                index = 4'd9;
                data_rx[data_index*8+:8] = data;
                if (data_index == 4'd8) begin
                    // 接收完毕，开始处理
                    status = 2'b00;
                    data_index = 4'd0;
                end
                else
                    data_index = data_index + 1;
            end
            else begin
                // 开始或结束校验错误
                // 恢复开始位
                // 数据重新读取
                index = 4'd9;
                data_index = 4'd0;
            end
        end
        else begin
            // 正在处理
            case (data_rx[7:0])
                // 密钥
                // 继续接收数据
                8'b11111111: begin
                    data_key = data_rx[71:8];
                    status = 2'b10;
                end
                // 加密
                // 处理完毕，开始发送
                8'b00001111: begin
                    data_tx = data_calc[63:0];
                    status = 2'b01;
                end
                // 解密
                // 处理完毕，开始发送
                8'b11110000: begin
                    data_tx = data_calc[127:64];
                    status = 2'b01;
                end
                default: begin
                    // 错误，重新接收数据
                    status = 2'b10;
                end
            endcase
            data_index = 4'd0;
            index = 4'd9;
        end
    end
end



endmodule

