
module mix_columns #(
    parameter logic EN = 1
) (
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

function automatic [15:0] xfunc9;
    input [15:0] data;
    xfunc9 = xtwo(xtwo(xtwo(data))) ^ data;
endfunction

function automatic [15:0] xfuncb;
    input [15:0] data;
    xfuncb = xfunc9(data) ^ xtwo(data);
endfunction

function automatic [15:0] xfuncd;
    input [15:0] data;
    xfuncd = xfunc9(data) ^ xtwo(xtwo(data));
endfunction

function automatic [15:0] xfunce;
    input [15:0] data;
    xfunce = xtwo(xtwo(xtwo(data))) ^ xtwo(xtwo(data)) ^ xtwo(data);
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

        if (EN) begin: gen_en
            assign data_out[START1+:8] = xtwo(col_inp1) ^ xthree(col_inp2) ^ col_inp3 ^ col_inp4;
            assign data_out[START2+:8] = col_inp1 ^ xtwo(col_inp2) ^ xthree(col_inp3) ^ col_inp4;
            assign data_out[START3+:8] = col_inp1 ^ col_inp2 ^ xtwo(col_inp3) ^ xthree(col_inp4);
            assign data_out[START4+:8] = xthree(col_inp1) ^ col_inp2 ^ col_inp3 ^ xtwo(col_inp4);
        end else begin: gen_de
            assign data_out[START1+:8] = xfunce(col_inp1) ^ xfuncb(col_inp2)
                                        ^ xfuncd(col_inp3) ^ xfunc9(col_inp4);
            assign data_out[START2+:8] = xfunc9(col_inp1) ^ xfunce(col_inp2)
                                        ^ xfuncb(col_inp3) ^ xfuncd(col_inp4);
            assign data_out[START3+:8] = xfuncd(col_inp1) ^ xfunc9(col_inp2)
                                        ^ xfunce(col_inp3) ^ xfuncb(col_inp4);
            assign data_out[START4+:8] = xfuncb(col_inp1) ^ xfuncd(col_inp2)
                                        ^ xfunc9(col_inp3) ^ xfunce(col_inp4);
        end
    end
endgenerate

endmodule
