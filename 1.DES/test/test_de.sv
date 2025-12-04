
module test_de;

reg [63:0] out;
reg [63:0] data;
reg [63:0] key;

des_de des_de_inst (
    .data_in(data),
    .key(key),
    .data_out(out)
);

initial begin
    $dumpfile("des_de.vcd");
    $dumpvars(0, des_de_inst);

    #5;
    key = 64'h133457799BBCDFF1;
    data = 64'h85E813540F0AB405;
    #20;
    $display("DES: %h\n   - 0123456789abcdef", out);
    $finish;
end

endmodule
