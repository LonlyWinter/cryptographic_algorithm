
module test_en;

reg [127:0] data;
reg [127:0] key;
reg [127:0] out;

sm4_en sm4_en_inst (
    .data_in(data),
    .key(key),
    .data_out(out)
);

initial begin
    $dumpfile("sm4_en.vcd");
    $dumpvars(0, test_en);
    data = 128'h0123456789ABCDEFFEDCBA9876543210;
    key = 128'h0123456789ABCDEFFEDCBA9876543210;
    #10;
    $display("SM4: %h\n   - 681edf34d206965e86b3e94f536e4246", out);
    $finish;
end

endmodule
