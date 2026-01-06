
// 参数(p, q, g, y)/x/k，数据z，签名结果(r, s)
module dsa_sign #(
    parameter int LEN = 64
) (
    input clk,
    input start,
    input [LENI:0] p,
    input [LENI:0] q,
    input [LENI:0] g,
    input [LENI:0] y,
    input [LENI:0] x,
    input [LENI:0] k,
    input [LENI:0] z,
    input [LENI:0] p_prime,
    input [LENI:0] r2_mod_p,
    input [LENI:0] q_prime,
    input [LENI:0] r2_mod_q,
    output [LENI:0] r,
    output [LENI:0] s,
    output done
);

localparam int LENI = LEN - 1;

// r
wire [LENI:0] r_temp0;
wire [LENI:0] r_temp1;
wire r_done_temp;
mod_exp #(
    .LEN(LEN)
) r_exp_inst (
    .clk(clk),
    .start(start),
    .a(g),
    .e(k),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(r_temp0),
    .done(r_done_temp)
);
mont_mul #(
    .LEN(LEN)
) a_bar_redc_inst (
    .a(r_temp0),
    .b(r2_mod_q),
    .n(q),
    .n_prime(q_prime),
    .res(r_temp1)
);
mont_redc #(
    .LEN(LEN)
) r_redc_inst (
    .x({{(LEN){1'b0}}, r_temp1}),
    .n(q),
    .n_prime(q_prime),
    .res(r)
);

// s
wire [LENI:0] s_inv_temp;
wire s_inv_running_temp;
mod_inv #(
    .LEN(LEN)
) s_inv_inst (
    .a(k),
    .p(q),
    .clk(clk),
    .enable(r_done_temp),
    .c(s_inv_temp),
    .running(s_inv_running_temp)
);
wire [LEN*2-1:0] s_mul_temp;
big_mul #(
    .LEN(LEN)
) s_mul_inst0 (
    .a(x),
    .b(r),
    .c(s_mul_temp)
);
wire [LENI:0] s_add_temp = z + s_mul_temp[LENI:0];
mod_mul #(
    .LEN(LEN)
) s_mul_inst (
    .a(s_inv_temp),
    .b(s_add_temp),
    .n(q),
    .n_prime(q_prime),
    .r2_mod_n(r2_mod_q),
    .res(s)
);

assign done = r_done_temp & (~s_inv_running_temp);

endmodule
