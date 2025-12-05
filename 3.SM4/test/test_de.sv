
module test_de;

reg [127:0] data;
reg [127:0] key;
reg [127:0] out;

sm4_de sm4_de_inst (
    .data_in(data),
    .key(key),
    .data_out(out)
);

initial begin
    $dumpfile("sm4_de.vcd");
    $dumpvars(0, test_de);
    data = 128'h681edf34d206965e86b3e94f536e4246;
    key = 128'h0123456789abcdeffedcba9876543210;
    #10;
    $display("SM4: %h\n   - 0123456789abcdeffedcba9876543210", out);
    $finish;
end

endmodule
