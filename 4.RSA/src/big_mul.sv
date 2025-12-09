
// c = a * b
module big_mul #(
    parameter int LEN = 2048
) (
    input [LENI:0] a,
    input [LENI:0] b,
    output reg [LENO:0] c
);

localparam int LENI = LEN - 1;
localparam int LENO = LEN * 2 - 1;

integer i;
always_comb begin
    c = 0;
    for (i = 0; i < LEN; i = i + 1) begin
        if (b[i])
            c = c + (a << i);
    end
end

endmodule
