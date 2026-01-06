module mont_redc #(
    parameter int LEN = 2048
) (
    input [LENDI:0] x,
    input [LENI:0] n,
    input [LENI:0] n_prime,
    output [LENI:0] res
);

localparam int LEND = LEN * 2;
localparam int LENDI = LEND - 1;
localparam int LENI  = LEN - 1;

wire [LENI:0] u_i = x[0+:LEN] * n_prime;
wire [LENDI:0] temp0;
big_mul #(
    .LEN(LEN)
) temp_inst (
    .a(u_i),
    .b(n),
    .c(temp0)
);
wire [LEND:0] temp1 = x + temp0;
wire [LENDI:0] Nt = { {(LEN){1'b0}}, n };
wire [LENDI:0] temp2 = {{(LENI){1'b0}}, temp1[LEN+:LEN+1]};
wire b = temp2 >= Nt;
wire [LENDI:0] temp3 = b ? (temp2 - Nt) : temp2;
assign res[0+:LEN] = temp3[0+:LEN];

endmodule
