
// 参数(p, q, g, y)/x/k，数据z，签名结果(r, s)
module dsa_check #(
    parameter int LEN = 64
) (
    input clk,
    input start,
    input [LENI:0] p,
    input [LENI:0] q,
    input [LENI:0] g,
    input [LENI:0] y,
    input [LENI:0] r,
    input [LENI:0] s,
    input [LENI:0] z,
    input [LENI:0] p_prime,
    input [LENI:0] r2_mod_p,
    input [LENI:0] q_prime,
    input [LENI:0] r2_mod_q,
    output valid,
    output done
);

localparam int LENI = LEN - 1;

// range
wire valid_r = r < q ? (r > 0 ? 1'b1 : 1'b0) : 1'b0;
wire valid_s = s < q ? (s > 0 ? 1'b1 : 1'b0) : 1'b0;

// w
wire [LENI:0] w;
wire w_running;
mod_inv #(
    .LEN(LEN)
) w_inst (
    .a(s),
    .p(q),
    .clk(clk),
    .enable(start),
    .c(w),
    .running(w_running)
);

// u1/u2
wire [LENI:0] u1, u2;
mod_mul #(
    .LEN(LEN)
) u1_inst (
    .a(z),
    .b(w),
    .n(q),
    .n_prime(q_prime),
    .r2_mod_n(r2_mod_q),
    .res(u1)
);
mod_mul #(
    .LEN(LEN)
) u2_inst (
    .a(r),
    .b(w),
    .n(q),
    .n_prime(q_prime),
    .r2_mod_n(r2_mod_q),
    .res(u2)
);

// v
wire [LENI:0] v1, v2, v3, v3_temp, v;
wire v1_done, v2_done;
mod_exp #(
    .LEN(LEN)
) v1_inst (
    .clk(clk),
    .start(~w_running),
    .a(g),
    .e(u1),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(v1),
    .done(v1_done)
);
mod_exp #(
    .LEN(LEN)
) v2_inst (
    .clk(clk),
    .start(~w_running),
    .a(y),
    .e(u2),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(v2),
    .done(v2_done)
);
mod_mul #(
    .LEN(LEN)
) s_mul_inst (
    .a(v1),
    .b(v2),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(v3)
);
mont_mul #(
    .LEN(LEN)
) a_bar_redc_inst (
    .a(v3),
    .b(r2_mod_q),
    .n(q),
    .n_prime(q_prime),
    .res(v3_temp)
);
mont_redc #(
    .LEN(LEN)
) r_redc_inst (
    .x({{(LEN){1'b0}}, v3_temp}),
    .n(q),
    .n_prime(q_prime),
    .res(v)
);

assign valid = valid_r & valid_s & (v == r);
assign done = v1_done & v2_done;

endmodule
