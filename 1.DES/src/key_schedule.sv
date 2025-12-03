
module key_schedule (
    input [63:0] data_in,
    output [767:0] data_out
);

wire [55:0] data_mid[17];

// PC-1
assign data_mid[0] = {
    data_in[64-57], data_in[64-49], data_in[64-41], data_in[64-33],
    data_in[64-25], data_in[64-17], data_in[64-9], data_in[64-1],
    data_in[64-58], data_in[64-50], data_in[64-42], data_in[64-34],
    data_in[64-26], data_in[64-18], data_in[64-10], data_in[64-2],
    data_in[64-59], data_in[64-51], data_in[64-43], data_in[64-35],
    data_in[64-27], data_in[64-19], data_in[64-11], data_in[64-3],
    data_in[64-60], data_in[64-52], data_in[64-44], data_in[64-36],
    data_in[64-63], data_in[64-55], data_in[64-47], data_in[64-39],
    data_in[64-31], data_in[64-23], data_in[64-15], data_in[64-7],
    data_in[64-62], data_in[64-54], data_in[64-46], data_in[64-38],
    data_in[64-30], data_in[64-22], data_in[64-14], data_in[64-6],
    data_in[64-61], data_in[64-53], data_in[64-45], data_in[64-37],
    data_in[64-29], data_in[64-21], data_in[64-13], data_in[64-5],
    data_in[64-28], data_in[64-20], data_in[64-12], data_in[64-4]
};

genvar index;
generate
    for (index = 0; index < 16; index = index + 1) begin: gen_key
        localparam int N = index == 0 || index == 1 || index == 8 || index == 15 ? 0 : 1;
        localparam int IN = index + 1;
        // Left Circular Shift
        assign data_mid[IN] = {
            data_mid[index][55-N-1:28],
            data_mid[index][55:55-N],
            data_mid[index][27-N-1:0],
            data_mid[index][27:27-N]
        };
        // PC-2
        assign data_out[index*48+:48] = {
            data_mid[IN][56-14], data_mid[IN][56-17], data_mid[IN][56-11],
            data_mid[IN][56-24], data_mid[IN][56-1], data_mid[IN][56-5],
            data_mid[IN][56-3], data_mid[IN][56-28], data_mid[IN][56-15],
            data_mid[IN][56-6], data_mid[IN][56-21], data_mid[IN][56-10],
            data_mid[IN][56-23], data_mid[IN][56-19], data_mid[IN][56-12],
            data_mid[IN][56-4], data_mid[IN][56-26], data_mid[IN][56-8],
            data_mid[IN][56-16], data_mid[IN][56-7], data_mid[IN][56-27],
            data_mid[IN][56-20], data_mid[IN][56-13], data_mid[IN][56-2],
            data_mid[IN][56-41], data_mid[IN][56-52], data_mid[IN][56-31],
            data_mid[IN][56-37], data_mid[IN][56-47], data_mid[IN][56-55],
            data_mid[IN][56-30], data_mid[IN][56-40], data_mid[IN][56-51],
            data_mid[IN][56-45], data_mid[IN][56-33], data_mid[IN][56-48],
            data_mid[IN][56-44], data_mid[IN][56-49], data_mid[IN][56-39],
            data_mid[IN][56-56], data_mid[IN][56-34], data_mid[IN][56-53],
            data_mid[IN][56-46], data_mid[IN][56-42], data_mid[IN][56-50],
            data_mid[IN][56-36], data_mid[IN][56-29], data_mid[IN][56-32]
        };
    end
endgenerate


endmodule
