
module ip #(
    // 加密还是解密
    parameter logic EN = 1
) (
    // 数据
    input [63:0] data_in,
    // 结果
    output [63:0] data_out
);

// Initial Permutation
if (EN)
    // 加密
    assign data_out = {
        data_in[64-58], data_in[64-50], data_in[64-42], data_in[64-34],
        data_in[64-26], data_in[64-18], data_in[64-10], data_in[64-2],
        data_in[64-60], data_in[64-52], data_in[64-44], data_in[64-36],
        data_in[64-28], data_in[64-20], data_in[64-12], data_in[64-4],
        data_in[64-62], data_in[64-54], data_in[64-46], data_in[64-38],
        data_in[64-30], data_in[64-22], data_in[64-14], data_in[64-6],
        data_in[64-64], data_in[64-56], data_in[64-48], data_in[64-40],
        data_in[64-32], data_in[64-24], data_in[64-16], data_in[64-8],
        data_in[64-57], data_in[64-49], data_in[64-41], data_in[64-33],
        data_in[64-25], data_in[64-17], data_in[64-9], data_in[64-1],
        data_in[64-59], data_in[64-51], data_in[64-43], data_in[64-35],
        data_in[64-27], data_in[64-19], data_in[64-11], data_in[64-3],
        data_in[64-61], data_in[64-53], data_in[64-45], data_in[64-37],
        data_in[64-29], data_in[64-21], data_in[64-13], data_in[64-5],
        data_in[64-63], data_in[64-55], data_in[64-47], data_in[64-39],
        data_in[64-31], data_in[64-23], data_in[64-15], data_in[64-7]
    };
else
    // 解密
    assign data_out = {
        data_in[64-40], data_in[64-8], data_in[64-48], data_in[64-16],
        data_in[64-56], data_in[64-24], data_in[64-64], data_in[64-32],
        data_in[64-39], data_in[64-7], data_in[64-47], data_in[64-15],
        data_in[64-55], data_in[64-23], data_in[64-63], data_in[64-31],
        data_in[64-38], data_in[64-6], data_in[64-46], data_in[64-14],
        data_in[64-54], data_in[64-22], data_in[64-62], data_in[64-30],
        data_in[64-37], data_in[64-5], data_in[64-45], data_in[64-13],
        data_in[64-53], data_in[64-21], data_in[64-61], data_in[64-29],
        data_in[64-36], data_in[64-4], data_in[64-44], data_in[64-12],
        data_in[64-52], data_in[64-20], data_in[64-60], data_in[64-28],
        data_in[64-35], data_in[64-3], data_in[64-43], data_in[64-11],
        data_in[64-51], data_in[64-19], data_in[64-59], data_in[64-27],
        data_in[64-34], data_in[64-2], data_in[64-42], data_in[64-10],
        data_in[64-50], data_in[64-18], data_in[64-58], data_in[64-26],
        data_in[64-33], data_in[64-1], data_in[64-41], data_in[64-9],
        data_in[64-49], data_in[64-17], data_in[64-57], data_in[64-25]
    };

endmodule
