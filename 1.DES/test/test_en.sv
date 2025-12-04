
module test_en;

reg [63:0] out;
reg [63:0] data;
reg [63:0] key;

des_en des_en_inst (
    .data_in(data),
    .key(key),
    .data_out(out)
);

initial begin
    $dumpfile("des_en.vcd");
    $dumpvars(0, test_en);

    #5;
    key = 64'h133457799BBCDFF1;
    data = 64'h0123456789abcdef;
    #20;
    $display("DES: %h\n   - 85e813540f0ab405", out);
    $finish;
end

endmodule
