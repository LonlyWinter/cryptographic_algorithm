
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
    key = 64'h0123456789abcdef;
    data = 64'h6a7d7274181d689f;
    #20;

    $finish;
end

endmodule
