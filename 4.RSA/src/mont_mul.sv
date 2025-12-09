module mont_mul #(
    parameter int LEN = 2048
) (
    input [LENI:0] a,
    input [LENI:0] b,
    input [LENI:0] n,
    input [LENI:0] n_prime,
    output [LENI:0] res
);

localparam int LENI = LEN - 1;
localparam int LEND = LEN * 2 - 1;

wire [LEND:0] temp;
big_mul #(
    .LEN(LEN)
) res_mul_inst (
    .a(a),
    .b(b),
    .c(temp)
);

mont_redc #(
    .LEN(LEN)
) res_redc_inst (
    .x(temp),
    .n(n),
    .n_prime(n_prime),
    .res(res)
);

endmodule
