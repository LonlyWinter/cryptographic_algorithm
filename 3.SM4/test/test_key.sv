
module test_key;

reg [127:0] key;
reg [1023:0] keys_all;

key_expansion key_inst (
    .data_in(key),
    .data_out(keys_all)
);

initial begin
    $dumpfile("test_key.vcd");
    $dumpvars(0, test_key);
    key = 128'h0123456789ABCDEFFEDCBA9876543210;
    #10;
    $display("key_all: %h", test_key.keys_all);
    $finish;
end

endmodule
