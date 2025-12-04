
module mix_columns (
    input [127:0] data_in,
    output [127:0] data_out
);


function automatic [15:0] xtwo;
    input [15:0] data;
    xtwo = (data & 16'h80) ? ((data << 1) ^ 16'h1b) : (data << 1);
endfunction


function automatic [15:0] xthree;
    input [15:0] data;
    xthree = xtwo(data) ^ data;
endfunction


genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin: gen_col
        localparam int START1 = 120 - i * 8;
        localparam int START2 = 88 - i * 8;
        localparam int START3 = 56 - i * 8;
        localparam int START4 = 24 - i * 8;
        wire [7:0] col_inp1 = data_in[START1+:8];
        wire [7:0] col_inp2 = data_in[START2+:8];
        wire [7:0] col_inp3 = data_in[START3+:8];
        wire [7:0] col_inp4 = data_in[START4+:8];
        assign data_out[START1+:8] = xtwo(col_inp1) ^ xthree(col_inp2) ^ col_inp3 ^ col_inp4;
        assign data_out[START2+:8] = col_inp1 ^ xtwo(col_inp2) ^ xthree(col_inp3) ^ col_inp4;
        assign data_out[START3+:8] = col_inp1 ^ col_inp2 ^ xtwo(col_inp3) ^ xthree(col_inp4);
        assign data_out[START4+:8] = xthree(col_inp1) ^ col_inp2 ^ col_inp3 ^ xtwo(col_inp4);
    end
endgenerate

endmodule
