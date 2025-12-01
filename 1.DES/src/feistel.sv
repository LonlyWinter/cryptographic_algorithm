
module feistel (
    input [63:0] data_in,
    input [47:0] key,
    output [63:0] data_out
);

wire [31:0] data_right;
wire [31:0] data_sbox;
wire [47:0] data_expansion;

assign data_right = data_in[31:0];
assign data_out[63:32] = data_in[31:0];

// Expansion Function
// XOR
assign data_expansion = {
    data_right[32-1], data_right[1-1], data_right[2-1],
    data_right[3-1], data_right[4-1], data_right[5-1],
    data_right[4-1], data_right[5-1], data_right[6-1],
    data_right[7-1], data_right[8-1], data_right[9-1],
    data_right[8-1], data_right[9-1], data_right[10-1],
    data_right[11-1], data_right[12-1], data_right[13-1],
    data_right[12-1], data_right[13-1], data_right[14-1],
    data_right[15-1], data_right[16-1], data_right[17-1],
    data_right[16-1], data_right[17-1], data_right[18-1],
    data_right[19-1], data_right[20-1], data_right[21-1],
    data_right[20-1], data_right[21-1], data_right[22-1],
    data_right[23-1], data_right[24-1], data_right[25-1],
    data_right[24-1], data_right[25-1], data_right[26-1],
    data_right[27-1], data_right[28-1], data_right[29-1],
    data_right[28-1], data_right[29-1], data_right[30-1],
    data_right[31-1], data_right[32-1], data_right[1-1]
} ^ key;

// Substitution Boxes
sbox sbox_inst (
    .data_in(data_expansion),
    .data_out(data_sbox)
);

// Permutation P-Box
// XOR
assign data_out[31:0] = {
    data_sbox[16-1], data_sbox[7-1], data_sbox[20-1], data_sbox[21-1],
    data_sbox[29-1], data_sbox[12-1], data_sbox[28-1], data_sbox[17-1],
    data_sbox[1-1], data_sbox[15-1], data_sbox[23-1], data_sbox[26-1],
    data_sbox[5-1], data_sbox[18-1], data_sbox[31-1], data_sbox[10-1],
    data_sbox[2-1], data_sbox[8-1], data_sbox[24-1], data_sbox[14-1],
    data_sbox[32-1], data_sbox[27-1], data_sbox[3-1], data_sbox[9-1],
    data_sbox[19-1], data_sbox[13-1], data_sbox[30-1], data_sbox[6-1],
    data_sbox[22-1], data_sbox[11-1], data_sbox[4-1], data_sbox[25-1]
} ^ data_in[63:32];


endmodule
