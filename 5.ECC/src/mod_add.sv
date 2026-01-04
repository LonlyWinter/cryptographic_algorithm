
// 0 <= a/b < p
// c = (a + b) mod p
module mod_add #(
    parameter int LEN = 256
) (
    input [LENI:0] a,
    input [LENI:0] b,
    input [LENI:0] p,
    output [LENI:0] c
);

localparam int LENI = LEN - 1;

wire [LEN:0] p_temp = {1'b0, p};
wire [LEN:0] sum = {1'b0, a} + {1'b0, b};
wire [LEN:0] sum_p = sum - p_temp;

assign c = (sum >= p_temp) ? sum_p[LENI:0] : sum[LENI:0];

endmodule
