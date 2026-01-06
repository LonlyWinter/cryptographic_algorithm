
module sm3 #(
    parameter int NUM = 1
) (
    input [DI:0] data,
    output [255:0] res
);

localparam int DI = NUM * 512 - 1;
localparam int MI = NUM * 256 + 256 - 1;

wire [MI:0] data_mid;

assign data_mid[255:0] = {
    32'h7380166F,
    32'h4914B2B9,
    32'h172442D7,
    32'hDA8A0600,
    32'hA96F30BC,
    32'h163138AA,
    32'hE38DEE4D,
    32'hB0FB0E4E
};

genvar index;
generate
    for (index = 0; index < NUM; index = index + 1) begin: gen_block
        localparam int IDX0 = (NUM - index - 1) * 512;
        localparam int IDX1 = index * 256;
        sm3_block block_inst (
            .data(data[IDX0+:512]),
            .state_init(data_mid[IDX1+:256]),
            .state_res(data_mid[IDX1+256+:256])
        );
    end
endgenerate

assign res = data_mid[NUM*256+:256];

endmodule
