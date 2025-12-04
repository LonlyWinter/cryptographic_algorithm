
module test_key;

reg [127:0] key;
reg [1407:0] keys_all;

key_expansion #(
    .LEN_KEY(128),
    .NUM_ROUND(10)
) key_inst (
    .data_in(key),
    .data_out(keys_all)
);

initial begin
    $dumpfile("test_key.vcd");
    $dumpvars(0, test_key);
    key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    #10;
    $display("key_all: %h", test_key.keys_all);
    $finish;
end

endmodule
