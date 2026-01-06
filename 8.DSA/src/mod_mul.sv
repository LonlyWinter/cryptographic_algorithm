

// (a * b) mod n
module mod_mul #(
    parameter int LEN = 2048
) (
    input [LENI:0] a,
    input [LENI:0] b,
    input [LENI:0] n,
    input [LENI:0] n_prime,
    input [LENI:0] r2_mod_n,
    output reg [LENI:0] res
);

localparam int LENI = LEN - 1;
localparam int LEND = LEN * 2 - 1;

wire [LENI:0] a_mont;
wire [LENI:0] b_mont;
mont_mul #(
    .LEN(LEN)
) a_mont_inst (
    .a(a),
    .b(r2_mod_n),
    .n(n),
    .n_prime(n_prime),
    .res(a_mont)
);
mont_mul #(
    .LEN(LEN)
) b_mont_inst (
    .a(b),
    .b(r2_mod_n),
    .n(n),
    .n_prime(n_prime),
    .res(b_mont)
);


wire [LENI:0] ab_mont;
mont_mul #(
    .LEN(LEN)
) ab_mont_inst (
    .a(a_mont),
    .b(b_mont),
    .n(n),
    .n_prime(n_prime),
    .res(ab_mont)
);


mont_redc #(
    .LEN(LEN)
) res_inst (
    .x({{(LEN){1'b0}}, ab_mont}),
    .n(n),
    .n_prime(n_prime),
    .res(res)
);
endmodule
