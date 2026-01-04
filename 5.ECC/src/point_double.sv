
// R = P + Q(P == Q)
module point_double #(
    parameter int LEN = 256
)  (
    // 定义参数
    input [LENI:0] a,
    input [LENI:0] p,
    input [LENI:0] p_prime,
    input [LENI:0] r2_mod_p,
    // p
    input [LENI:0] px,
    input [LENI:0] py,
    input [LENI:0] pz,
    // out
    output [LENI:0] rx,
    output [LENI:0] ry,
    output [LENI:0] rz
);

localparam int LENI = LEN - 1;
wire [LENI:0] py2, px_py2, two_px_py2, S;
wire [LENI:0] px2, two_px2, three_px2, pz2, pz4, apz4, M;
wire [LENI:0] M2, two_S;
wire [LENI:0] S_rx, M_S_rx, py4, two_py4, four_py4, eight_py4;
wire [LENI:0] two_py2;


mod_mul #(
    .LEN(LEN)
) step1_1 (
    .a(py),
    .b(py),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(py2)
);
mod_mul #(
    .LEN(LEN)
) step1_2 (
    .a(px),
    .b(py2),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(px_py2)
);
mod_add #(
    .LEN(LEN)
) step1_3 (
    .a(px_py2),
    .b(px_py2),
    .p(p),
    .c(two_px_py2)
);
mod_add #(
    .LEN(LEN)
) step1_4 (
    .a(two_px_py2),
    .b(two_px_py2),
    .p(p),
    .c(S)
);


mod_mul #(
    .LEN(LEN)
) step2_1 (
    .a(px),
    .b(px),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(px2)
);
mod_add #(
    .LEN(LEN)
) step2_2 (
    .a(px2),
    .b(px2),
    .p(p),
    .c(two_px2)
);
mod_add #(
    .LEN(LEN)
) step2_3 (
    .a(two_px2),
    .b(px2),
    .p(p),
    .c(three_px2)
);
mod_mul #(
    .LEN(LEN)
) step2_4 (
    .a(pz),
    .b(pz),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(pz2)
);
mod_mul #(
    .LEN(LEN)
) step2_5 (
    .a(pz2),
    .b(pz2),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(pz4)
);
mod_mul #(
    .LEN(LEN)
) step2_6 (
    .a(a),
    .b(pz4),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(apz4)
);
mod_add #(
    .LEN(LEN)
) step2_7 (
    .a(three_px2),
    .b(apz4),
    .p(p),
    .c(M)
);



mod_mul #(
    .LEN(LEN)
) step3_1 (
    .a(M),
    .b(M),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(M2)
);
mod_add #(
    .LEN(LEN)
) step3_2 (
    .a(S),
    .b(S),
    .p(p),
    .c(two_S)
);
mod_sub #(
    .LEN(LEN)
) step3_3 (
    .a(M2),
    .b(two_S),
    .p(p),
    .c(rx)
);



mod_sub #(
    .LEN(LEN)
) step4_1 (
    .a(S),
    .b(rx),
    .p(p),
    .c(S_rx)
);
mod_mul #(
    .LEN(LEN)
) step4_2 (
    .a(M),
    .b(S_rx),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(M_S_rx)
);
mod_mul #(
    .LEN(LEN)
) step4_3 (
    .a(py2),
    .b(py2),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(py4)
);
mod_add #(
    .LEN(LEN)
) step4_4 (
    .a(py4),
    .b(py4),
    .p(p),
    .c(two_py4)
);
mod_add #(
    .LEN(LEN)
) step4_5 (
    .a(two_py4),
    .b(two_py4),
    .p(p),
    .c(four_py4)
);
mod_add #(
    .LEN(LEN)
) step4_6 (
    .a(four_py4),
    .b(four_py4),
    .p(p),
    .c(eight_py4)
);
mod_sub #(
    .LEN(LEN)
) step4_7 (
    .a(M_S_rx),
    .b(eight_py4),
    .p(p),
    .c(ry)
);


mod_add #(
    .LEN(LEN)
) step5_1 (
    .a(py),
    .b(py),
    .p(p),
    .c(two_py2)
);
mod_mul #(
    .LEN(LEN)
) step5_2 (
    .a(two_py2),
    .b(pz),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(rz)
);




endmodule
