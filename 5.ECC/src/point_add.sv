
// R = P + Q(P != Q)
module point_add #(
    parameter int LEN = 256
)  (
    // 定义参数
    input [LENI:0] p,
    input [LENI:0] p_prime,
    input [LENI:0] r2_mod_p,
    // p
    input [LENI:0] px,
    input [LENI:0] py,
    input [LENI:0] pz,
    // q
    input [LENI:0] qx,
    input [LENI:0] qy,
    input [LENI:0] qz,
    // out
    output [LENI:0] rx,
    output [LENI:0] ry,
    output [LENI:0] rz
);

localparam int LENI = LEN - 1;


// Temporary wires
wire [LENI:0] pz2;
wire [LENI:0] pz3;
wire [LENI:0] qz2;
wire [LENI:0] qz3;
wire [LENI:0] U1;
wire [LENI:0] U2;
wire [LENI:0] S1;
wire [LENI:0] S2;
wire [LENI:0] H, r;
wire [LENI:0] H2, H3, r2, U1H2, twoU1H2, temp1, Z1_Z2, U1H2X3, temp2, S1H3;

// Step 1: Z2^2, Z2^3
mod_mul #(
    .LEN(LEN)
) step1_1 (
    .a(pz),
    .b(pz),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(pz2)
);
mod_mul #(
    .LEN(LEN)
) step1_2 (
    .a(pz2),
    .b(pz),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(pz3)
);

// Step 2: Z1^2, Z1^3
mod_mul #(
    .LEN(LEN)
) step2_1 (
    .a(qz),
    .b(qz),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(qz2)
);
mod_mul #(
    .LEN(LEN)
) step2_2 (
    .a(qz2),
    .b(qz),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(qz3)
);

// Step 3: U1 = X1 * Z2^2, U2 = X2 * Z1^2
mod_mul #(
    .LEN(LEN)
) step3_1 (
    .a(px),
    .b(qz2),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(U1)
);
mod_mul #(
    .LEN(LEN)
) step3_2 (
    .a(qx),
    .b(pz2),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(U2)
);

// Step 4: S1 = Y1 * Z2^3, S2 = Y2 * Z1^3
mod_mul #(
    .LEN(LEN)
) step4_1 (
    .a(py),
    .b(qz3),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(S1)
);
mod_mul #(
    .LEN(LEN)
) step4_2 (
    .a(qy),
    .b(pz3),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(S2)
);


// Step 5: H = U2 - U1, r = S2 - S1
mod_sub #(
    .LEN(LEN)
) step5_1 (
    .a(U2),
    .b(U1),
    .p(p),
    .c(H)
);
mod_sub #(
    .LEN(LEN)
) step5_2 (
    .a(S2),
    .b(S1),
    .p(p),
    .c(r)
);

// Step 6: H^2, H^3
mod_mul #(
    .LEN(LEN)
) step6_1 (
    .a(H),
    .b(H),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(H2)
);
mod_mul #(
    .LEN(LEN)
) step6_2 (
    .a(H2),
    .b(H),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(H3)
);


// Step 7: U1 * H^2
mod_mul #(
    .LEN(LEN)
) step7_1 (
    .a(U1),
    .b(H2),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(U1H2)
);

// Step 8: X3 = r^2 - H^3 - 2*U1*H^2
mod_mul #(
    .LEN(LEN)
) step8_1 (
    .a(r),
    .b(r),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(r2)
);
mod_add #(
    .LEN(LEN)
) step8_2 (
    .a(U1H2),
    .b(U1H2),
    .p(p),
    .c(twoU1H2)
);
mod_sub #(
    .LEN(LEN)
) step8_3 (
    .a(r2),
    .b(H3),
    .p(p),
    .c(temp1)
);
mod_sub #(
    .LEN(LEN)
) step8_4 (
    .a(temp1),
    .b(twoU1H2),
    .p(p),
    .c(rx)
);

// Step 9: Y3 = r*(U1*H^2 - X3) - S1*H^3
mod_sub #(
    .LEN(LEN)
) step9_1 (
    .a(U1H2),
    .b(rx),
    .p(p),
    .c(U1H2X3)
);
mod_mul #(
    .LEN(LEN)
) step9_2 (
    .a(r),
    .b(U1H2X3),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(temp2)
);
mod_mul #(
    .LEN(LEN)
) step9_3 (
    .a(S1),
    .b(H3),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(S1H3)
);
mod_sub #(
    .LEN(LEN)
) step9_4 (
    .a(temp2),
    .b(S1H3),
    .p(p),
    .c(ry)
);

// Step 10: Z3 = H * Z1 * Z2
mod_mul #(
    .LEN(LEN)
) step10_1 (
    .a(pz),
    .b(qz),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(Z1_Z2)
);
mod_mul #(
    .LEN(LEN)
) step10_2 (
    .a(H),
    .b(Z1_Z2),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(rz)
);

endmodule
