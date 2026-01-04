
// y^2 == x^3 + ax + b (mod p)
module point_check #(
    parameter int LEN = 256
) (
    input [LENI:0] a,
    input [LENI:0] b,
    input [LENI:0] p,
    input [LENI:0] p_prime,
    input [LENI:0] r2_mod_p,
    input [LENI:0] x,
    input [LENI:0] y,
    output valid
);

localparam int LENI = LEN - 1;

wire [LENI:0] y2, x2, x3, ax, add_ax, add_b;
mod_mul #(
    .LEN(LEN)
) step1 (
    .a(y),
    .b(y),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(y2)
);
mod_mul #(
    .LEN(LEN)
) step2 (
    .a(x),
    .b(x),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(x2)
);
mod_mul #(
    .LEN(LEN)
) step3 (
    .a(x2),
    .b(x),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(x3)
);
mod_mul #(
    .LEN(LEN)
) step4 (
    .a(a),
    .b(x),
    .n(p),
    .n_prime(p_prime),
    .r2_mod_n(r2_mod_p),
    .res(ax)
);
mod_add #(
    .LEN(LEN)
) step5 (
    .a(x3),
    .b(ax),
    .p(p),
    .c(add_ax)
);
mod_add #(
    .LEN(LEN)
) step6 (
    .a(add_ax),
    .b(b),
    .p(p),
    .c(add_b)
);


assign valid = y2 == add_b;

endmodule
