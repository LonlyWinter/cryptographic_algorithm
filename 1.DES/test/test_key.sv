
module test_key;

reg [63:0] key;
reg [767:0] out;

key_schedule key_inst (
    .data_in(key),
    .data_out(out)
);

initial begin
    $dumpfile("des_key.vcd");
    $dumpvars(0, test_key);

    #5;
    key = 64'h0123456789abcdef;
    #20;
    $finish;
end

endmodule
