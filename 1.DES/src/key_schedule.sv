
module key_schedule (
    input [63:0] data_in,
    output [767:0] data_out
);

wire [55:0] data_mid[17];

// PC-1
assign data_mid[0] = {
    data_in[57-1], data_in[49-1], data_in[41-1], data_in[33-1],
    data_in[25-1], data_in[17-1], data_in[9-1], data_in[1-1],
    data_in[58-1], data_in[50-1], data_in[42-1], data_in[34-1],
    data_in[26-1], data_in[18-1], data_in[10-1], data_in[2-1],
    data_in[59-1], data_in[51-1], data_in[43-1], data_in[35-1],
    data_in[27-1], data_in[19-1], data_in[11-1], data_in[3-1],
    data_in[60-1], data_in[52-1], data_in[44-1], data_in[36-1],
    data_in[63-1], data_in[55-1], data_in[47-1], data_in[39-1],
    data_in[31-1], data_in[23-1], data_in[15-1], data_in[7-1],
    data_in[62-1], data_in[54-1], data_in[46-1], data_in[38-1],
    data_in[30-1], data_in[22-1], data_in[14-1], data_in[6-1],
    data_in[61-1], data_in[53-1], data_in[45-1], data_in[37-1],
    data_in[29-1], data_in[21-1], data_in[13-1], data_in[5-1],
    data_in[28-1], data_in[20-1], data_in[12-1], data_in[4-1]
};

genvar index;
generate
    for (index = 0; index < 16; index = index + 1) begin: gen_key
        localparam logic N = index == 0 || index == 1 || index == 8 || index == 15 ? 1'd0 : 3'd1;
        // Left Circular Shift
        assign data_mid[index+1] = {
            data_mid[index][55-N-1:28],
            data_mid[index][55:55-N],
            data_mid[index][27-N-1:0],
            data_mid[index][27:27-N]
        };
        // PC-2
        assign data_out[index*48+47:index*48] = {
            data_mid[index+1][14-1], data_mid[index+1][17-1], data_mid[index+1][11-1],
            data_mid[index+1][24-1], data_mid[index+1][1-1], data_mid[index+1][5-1],
            data_mid[index+1][3-1], data_mid[index+1][28-1], data_mid[index+1][15-1],
            data_mid[index+1][6-1], data_mid[index+1][21-1], data_mid[index+1][10-1],
            data_mid[index+1][23-1], data_mid[index+1][19-1], data_mid[index+1][12-1],
            data_mid[index+1][4-1], data_mid[index+1][26-1], data_mid[index+1][8-1],
            data_mid[index+1][16-1], data_mid[index+1][7-1], data_mid[index+1][27-1],
            data_mid[index+1][20-1], data_mid[index+1][13-1], data_mid[index+1][2-1],
            data_mid[index+1][41-1], data_mid[index+1][52-1], data_mid[index+1][31-1],
            data_mid[index+1][37-1], data_mid[index+1][47-1], data_mid[index+1][55-1],
            data_mid[index+1][30-1], data_mid[index+1][40-1], data_mid[index+1][51-1],
            data_mid[index+1][45-1], data_mid[index+1][33-1], data_mid[index+1][48-1],
            data_mid[index+1][44-1], data_mid[index+1][49-1], data_mid[index+1][39-1],
            data_mid[index+1][56-1], data_mid[index+1][34-1], data_mid[index+1][53-1],
            data_mid[index+1][46-1], data_mid[index+1][42-1], data_mid[index+1][50-1],
            data_mid[index+1][36-1], data_mid[index+1][29-1], data_mid[index+1][32-1]
        };
    end
endgenerate


endmodule
