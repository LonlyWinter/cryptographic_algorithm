

// (a ^ E) mod n
module modexp1 #(
    parameter int LEN = 2048,
    parameter int E = 65537
) (
    input [LENI:0] a,
    input [LENI:0] n,
    input [LENI:0] n_prime,
    input [LENI:0] r2_mod_n,
    output reg [LENI:0] res
);

localparam int LENI = LEN - 1;
localparam int LEND = LEN * 2 - 1;


wire [LEN*NUM+LENI:0] base_bar;
mont_mul #(
    .LEN(LEN)
) a_bar_redc_inst (
    .a(a),
    .b(r2_mod_n),
    .n(n),
    .n_prime(n_prime),
    .res(base_bar[0+:LEN])
);


wire [LEN*NUM+LENI:0] res_bar;
mont_redc #(
    .LEN(LEN)
) res_bar_redc_inst (
    .x({{(LEN){1'b0}}, r2_mod_n}),
    .n(n),
    .n_prime(n_prime),
    .res(res_bar[0+:LEN])
);

genvar i;
localparam int NUM = $clog2(E);
generate
    for (i = 0; i < NUM; i = i + 1) begin: gen_bit
        localparam logic EI = (E >> i) & 1;
        localparam logic START = i * LEN;
        if (EI) begin: gen_e
            mont_mul #(
                .LEN(LEN)
            ) res_redc_inst (
                .a(res_bar[START+:LEN]),
                .b(base_bar[START+:LEN]),
                .n(n),
                .n_prime(n_prime),
                .res(res_bar[START+LEN+:LEN])
            );
        end else
            assign res_bar[START+LEN+:LEN] = res_bar[START+:LEN];

        mont_mul #(
            .LEN(LEN)
        ) base_redc_inst (
            .a(base_bar[START+:LEN]),
            .b(base_bar[START+:LEN]),
            .n(n),
            .n_prime(n_prime),
            .res(base_bar[START+LEN+:LEN])
        );
    end
endgenerate



mont_redc #(
    .LEN(LEN)
) res_redc_inst (
    .x({{(LEN){1'b0}}, res_bar[LEN*NUM+:LEN]}),
    .n(n),
    .n_prime(n_prime),
    .res(res)
);

endmodule
