
// https://github.com/XKCP/XKCP/blob/master/tests/TestVectors/KeccakF-1600-IntermediateValues.txt

module test_kf;

reg [1599:0] data, res;
reg [63:0] res_temp1, res_temp2;

kf #(
    .NUM(4)
) kf_inst (
    .state_inp(data),
    .state_opt(res)
);

initial begin
    $dumpfile("test_kf.vcd");
    $dumpvars(0, test_kf);

    data = 1600'h0;
    res_temp1 = 64'h0838573A4DEB6243;
    res_temp2 = 64'h6542BC007F6BD7A3;
    #10;
    $display(
        "Keccak-f\ndata = %h\nres = %h/%h\n    - %h/%h",
        data[1536+:64],
        res[0+:64],
        res[1536+:64],
        res_temp1,
        res_temp2
    );

    $finish;
end

endmodule
