
// state T
// 127-96
// 95-64
// 63-32
// 31-0

module shift_rows (
    input [127:0] data_in,
    output [127:0] data_out
);


assign data_out = {
    data_in[127:96],
    data_in[87:64],
    data_in[95:88],
    data_in[47:32],
    data_in[63:48],
    data_in[7:0],
    data_in[31:8]
};

endmodule
