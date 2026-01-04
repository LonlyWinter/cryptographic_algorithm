
module point_affine #(
    parameter int LEN = 256
)  (
    // 定义参数
    input [LENI:0] p,
    input [LENI:0] p_prime,
    input [LENI:0] r2_mod_p,
    // 时钟
    input clk,
    input enable,
    // p
    input [LENI:0] x,
    input [LENI:0] y,
    input [LENI:0] z,
    // out
    output [LENI:0] rx,
    output [LENI:0] ry,
    output done
);

localparam int LENI = LEN - 1;

// affine
// x = X3 / Z3^2, y = Y3 / Z3^3
wire [LENI:0] rz_temp2, rz_temp2_inv, rz_temp3, rz_temp3_inv;
wire done1, done2;
mod_mul #(
    .LEN(LEN)
) step1 (
    .a(z),
    .b(z),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(rz_temp2)
);
mod_mul #(
    .LEN(LEN)
) step2 (
    .a(rz_temp2),
    .b(z),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(rz_temp3)
);
mod_inv #(
    .LEN(LEN)
) step3 (
    .a(rz_temp2),
    .p(p),
    .enable(enable),
    .clk(clk),
    .c(rz_temp2_inv),
    .running(done1)
);
mod_inv #(
    .LEN(LEN)
) step4 (
    .a(rz_temp3),
    .p(p),
    .enable(enable),
    .clk(clk),
    .c(rz_temp3_inv),
    .running(done2)
);
mod_mul #(
    .LEN(LEN)
) step5 (
    .a(x),
    .b(rz_temp2_inv),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(rx)
);
mod_mul #(
    .LEN(LEN)
) step6 (
    .a(y),
    .b(rz_temp3_inv),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(ry)
);

assign done = (~done1) & (~done2);

endmodule
