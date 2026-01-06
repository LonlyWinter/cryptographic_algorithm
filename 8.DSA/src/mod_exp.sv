

// (a ^ e) mod n
module mod_exp #(
    parameter int LEN = 2048
) (
    input clk,
    input start,
    input [LENI:0] a,
    input [LENI:0] e,
    input [LENI:0] n,
    input [LENI:0] n_prime,
    input [LENI:0] r2_mod_n,
    output reg [LENI:0] res,
    output reg done
);

localparam int LENI = LEN - 1;
localparam int LEND = LEN * 2 - 1;


wire [LENI:0] base_bar_init;
mont_mul #(
    .LEN(LEN)
) a_bar_mul_inst (
    .a(a),
    .b(r2_mod_n),
    .n(n),
    .n_prime(n_prime),
    .res(base_bar_init)
);


reg [LEND:0] redc_inp;
reg [LENI:0] redc_opt;
mont_redc #(
    .LEN(LEN)
) res_bar_redc_inst (
    .x(redc_inp),
    .n(n),
    .n_prime(n_prime),
    .res(redc_opt)
);

reg [LENI:0] res_bar;
reg [LENI:0] base_bar;

reg [LENI:0] e_reg;
reg [2:0] e_state = 3'd0;
reg [LENI:0] temp_inp;
reg [LENI:0] temp_opt;
mont_mul #(
    .LEN(LEN)
) temp_mul_inst (
    .a(temp_inp),
    .b(base_bar),
    .n(n),
    .n_prime(n_prime),
    .res(temp_opt)
);

reg new_exp;

always @(posedge clk) begin
    if (e_state == 3'd6) begin
        res_bar = redc_opt;
        base_bar = base_bar_init;
        e_state = 3'd0;
    end else if (e_reg > 0) begin
        case (e_state)
            3'd0: begin
                if (e_reg[0])
                    e_state = 3'd1;
                else
                    e_state = 3'd3;
            end

            3'd1: begin
                temp_inp = res_bar;
                e_state = 3'd2;
            end

            3'd2: begin
                res_bar = temp_opt;
                e_state = 3'd3;
            end

            3'd3: begin
                temp_inp = base_bar;
                e_state = 3'd4;
            end

            3'd4: begin
                base_bar = temp_opt;
                e_reg = {1'b0, e_reg[LENI:1]};
                e_state = e_reg == 0 ? 3'd5 : 3'd0;
                redc_inp = {{(LEN){1'b0}}, res_bar};
            end
            default: e_state = 3'd0;
        endcase
    end else if (e_state == 3'd5) begin
        res = redc_opt;
        e_state = 3'd0;
        done <= 1;
    end else if (new_exp & start) begin
        done = 0;
        e_reg = e;
        e_state = 3'd6;
        redc_inp = {{(LEN){1'b0}}, r2_mod_n};
        new_exp = 0;
    end
end

always @(posedge start) begin
    new_exp = 1;
end

endmodule
