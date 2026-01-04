
// 0 <= a/b < p
// c = (a - b) mod p
module mod_sub #(
    parameter int LEN = 256
) (
    input [LENI:0] a,
    input [LENI:0] b,
    input [LENI:0] p,
    output [LENI:0] c
);

localparam int LENI = LEN - 1;

wire [LENI:0] diff = a - b;

assign c = (a < b) ? (diff + p) : diff;

endmodule
