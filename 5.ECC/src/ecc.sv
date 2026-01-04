`timescale 1ns/1ns

module ecc #(
    parameter int LEN = 256
) (
    // 椭圆曲线参数
    input [LENI:0] a,
    input [LENI:0] b,
    input [LENI:0] p,
    input [LENI:0] p_prime,
    input [LENI:0] r2_mod_p,
    // 时钟
    input clk,
    input enable,
    // 坐标
    input [LENI:0] x,
    input [LENI:0] y,
    // 次数
    input [LENI:0] k,
    // 结果
    output [LENI:0] x_res,
    output [LENI:0] y_res,
    output valid,
    output reg done
);
localparam int WI = $clog2(LEN) - 1;
localparam int LENI = LEN - 1;


reg [LENI:0] x1_now, y1_now, z1_now;
reg [LENI:0] x2_now, y2_now, z2_now;


// check
point_check #(
    .LEN(LEN)
) point_check_inst (
    .a(a),
    .b(b),
    .p(p),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .x(x),
    .y(y),
    .valid(valid)
);

// double
reg [LENI:0] x_inp_double, y_inp_double, z_inp_double;
wire [LENI:0] x_opt_double, y_opt_double, z_opt_double;
point_double #(
    .LEN(LEN)
) point_double_inst (
    .a(a),
    .p(p),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .px(x_inp_double),
    .py(y_inp_double),
    .pz(z_inp_double),
    .rx(x_opt_double),
    .ry(y_opt_double),
    .rz(z_opt_double)
);


// add
wire [LENI:0] x_opt_add, y_opt_add, z_opt_add;
point_add #(
    .LEN(LEN)
) point_add_inst (
    .p(p),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .px(x1_now),
    .py(y1_now),
    .pz(z1_now),
    .qx(x2_now),
    .qy(y2_now),
    .qz(z2_now),
    .rx(x_opt_add),
    .ry(y_opt_add),
    .rz(z_opt_add)
);

// affine
reg enable_affine, done_affine;
point_affine #(
    .LEN(LEN)
) point_affine_inst (
    .p(p),
    .p_prime(p_prime),
    .r2_mod_p(r2_mod_p),
    .enable(enable_affine),
    .clk(clk),
    .x(x1_now),
    .y(y1_now),
    .z(z1_now),
    .rx(x_res),
    .ry(y_res),
    .done(done_affine)
);

reg [WI:0] bit_idx;
reg start;

wire k_bit = k[bit_idx];
wire bit_stop = bit_idx[WI] & bit_idx[0];

always @(negedge clk) begin
    if (start) begin
        x2_now = x_opt_double;
        y2_now = y_opt_double;
        z2_now = z_opt_double;
        if (bit_stop) begin
            done = 1;
        end else begin
            bit_idx = bit_idx - 1;
        end
        start = 0;
        // $display("loop neg, %d start:\n %h\n %h", bit_idx, x_inp_double, x_opt_double);
    end else if (!done) begin
        if (!bit_stop) begin
            if (k_bit) begin
                x1_now = x_opt_add;
                y1_now = y_opt_add;
                z1_now = z_opt_add;
                x2_now = x_opt_double;
                y2_now = y_opt_double;
                z2_now = z_opt_double;
            end else begin
                x2_now = x_opt_add;
                y2_now = y_opt_add;
                z2_now = z_opt_add;
                x1_now = x_opt_double;
                y1_now = y_opt_double;
                z1_now = z_opt_double;
            end
            bit_idx = bit_idx - 1;
            // $display("loop neg, %d after: %h %h", bit_idx, x1_now, x2_now);
        end
    end
end

always @(posedge clk) begin
    if (start) begin
    end else if (!done) begin
        if (bit_stop) begin
            if (!enable_affine) begin
                enable_affine = 1;
                // $display("loop pos start affine: %h", x1_now);
            end else if (done_affine) begin
                enable_affine = 0;
                done = 1;
                // $display("loop pos end affine");
            end
        end else begin
            // $display("loop pos, %d before", bit_idx);
            if (k_bit) begin
                x_inp_double = x2_now;
                y_inp_double = y2_now;
                z_inp_double = z2_now;
            end else begin
                x_inp_double = x1_now;
                y_inp_double = y1_now;
                z_inp_double = z1_now;
            end
        end
    end
end


always @(posedge enable) begin
    if (enable) begin
        bit_idx = LENI;
        while (bit_idx > 0 && k_bit == 1'b0) bit_idx = bit_idx - 1;
        x1_now = x;
        y1_now = y;
        z1_now = 1;
        x_inp_double = x;
        y_inp_double = y;
        z_inp_double = 1;
        start <= 1;
        enable_affine = 0;
        done <= 0;
        // $display("enable, start, %d, %d, %h", bit_idx, start, x_inp_double);
    end
end



endmodule
