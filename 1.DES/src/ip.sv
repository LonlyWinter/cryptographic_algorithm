
module ip (
    // 数据
    input [63:0] data_in,
    // 结果
    output [63:0] data_out
);

// 加密还是解密
parameter logic EN = 1;

// Initial Permutation
if (EN)
    // 加密
    assign data_out = {
        data_in[58-1], data_in[50-1], data_in[42-1], data_in[34-1],
        data_in[26-1], data_in[18-1], data_in[10-1], data_in[2-1],
        data_in[60-1], data_in[52-1], data_in[44-1], data_in[36-1],
        data_in[28-1], data_in[20-1], data_in[12-1], data_in[4-1],
        data_in[62-1], data_in[54-1], data_in[46-1], data_in[38-1],
        data_in[30-1], data_in[22-1], data_in[14-1], data_in[6-1],
        data_in[64-1], data_in[56-1], data_in[48-1], data_in[40-1],
        data_in[32-1], data_in[24-1], data_in[16-1], data_in[8-1],
        data_in[57-1], data_in[49-1], data_in[41-1], data_in[33-1],
        data_in[25-1], data_in[17-1], data_in[9-1], data_in[1-1],
        data_in[59-1], data_in[51-1], data_in[43-1], data_in[35-1],
        data_in[27-1], data_in[19-1], data_in[11-1], data_in[3-1],
        data_in[61-1], data_in[53-1], data_in[45-1], data_in[37-1],
        data_in[29-1], data_in[21-1], data_in[13-1], data_in[5-1],
        data_in[63-1], data_in[55-1], data_in[47-1], data_in[39-1],
        data_in[31-1], data_in[23-1], data_in[15-1], data_in[7-1]
    };
else
    // 解密
    assign data_out = {
        data_in[40-1], data_in[8-1], data_in[48-1], data_in[16-1],
        data_in[56-1], data_in[24-1], data_in[64-1], data_in[32-1],
        data_in[39-1], data_in[7-1], data_in[47-1], data_in[15-1],
        data_in[55-1], data_in[23-1], data_in[63-1], data_in[31-1],
        data_in[38-1], data_in[6-1], data_in[46-1], data_in[14-1],
        data_in[54-1], data_in[22-1], data_in[62-1], data_in[30-1],
        data_in[37-1], data_in[5-1], data_in[45-1], data_in[13-1],
        data_in[53-1], data_in[21-1], data_in[61-1], data_in[29-1],
        data_in[36-1], data_in[4-1], data_in[44-1], data_in[12-1],
        data_in[52-1], data_in[20-1], data_in[60-1], data_in[28-1],
        data_in[35-1], data_in[3-1], data_in[43-1], data_in[11-1],
        data_in[51-1], data_in[19-1], data_in[59-1], data_in[27-1],
        data_in[34-1], data_in[2-1], data_in[42-1], data_in[10-1],
        data_in[50-1], data_in[18-1], data_in[58-1], data_in[26-1],
        data_in[33-1], data_in[1-1], data_in[41-1], data_in[9-1],
        data_in[49-1], data_in[17-1], data_in[57-1], data_in[25-1]
    };

endmodule
