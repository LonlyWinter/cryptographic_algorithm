
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
    data_right[32-32], data_right[32-1], data_right[32-2],
    data_right[32-3], data_right[32-4], data_right[32-5],
    data_right[32-4], data_right[32-5], data_right[32-6],
    data_right[32-7], data_right[32-8], data_right[32-9],
    data_right[32-8], data_right[32-9], data_right[32-10],
    data_right[32-11], data_right[32-12], data_right[32-13],
    data_right[32-12], data_right[32-13], data_right[32-14],
    data_right[32-15], data_right[32-16], data_right[32-17],
    data_right[32-16], data_right[32-17], data_right[32-18],
    data_right[32-19], data_right[32-20], data_right[32-21],
    data_right[32-20], data_right[32-21], data_right[32-22],
    data_right[32-23], data_right[32-24], data_right[32-25],
    data_right[32-24], data_right[32-25], data_right[32-26],
    data_right[32-27], data_right[32-28], data_right[32-29],
    data_right[32-28], data_right[32-29], data_right[32-30],
    data_right[32-31], data_right[32-32], data_right[32-1]
} ^ key;

// Substitution Boxes
sbox sbox_inst (
    .data_in(data_expansion),
    .data_out(data_sbox)
);

// Permutation P-Box
// XOR
assign data_out[31:0] = {
    data_sbox[32-16], data_sbox[32-7], data_sbox[32-20], data_sbox[32-21],
    data_sbox[32-29], data_sbox[32-12], data_sbox[32-28], data_sbox[32-17],
    data_sbox[32-1], data_sbox[32-15], data_sbox[32-23], data_sbox[32-26],
    data_sbox[32-5], data_sbox[32-18], data_sbox[32-31], data_sbox[32-10],
    data_sbox[32-2], data_sbox[32-8], data_sbox[32-24], data_sbox[32-14],
    data_sbox[32-32], data_sbox[32-27], data_sbox[32-3], data_sbox[32-9],
    data_sbox[32-19], data_sbox[32-13], data_sbox[32-30], data_sbox[32-6],
    data_sbox[32-22], data_sbox[32-11], data_sbox[32-4], data_sbox[32-25]
} ^ data_in[63:32];


endmodule
