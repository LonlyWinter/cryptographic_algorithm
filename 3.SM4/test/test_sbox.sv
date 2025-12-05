
module test_sbox;

reg [31:0] data;
reg [31:0] out;

sbox #(
    .NUM(4)
) sbox_inst (
    .data_in(data),
    .data_out(out)
);

initial begin
    $dumpfile("test_sbox.vcd");
    $dumpvars(0, test_sbox);
    data = 32'h1a2b3cef;
    #10;
    $display("S-Box: %h\n     - 13437584", out);
    $finish;
end

endmodule
