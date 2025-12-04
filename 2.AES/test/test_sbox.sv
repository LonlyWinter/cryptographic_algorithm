
module test_sbox;

reg [7:0] data_in1;
reg [7:0] data_out1;

sbox #(
    .NUM(1)
) sbox_inst1 (
    .data_in(data_in1),
    .data_out(data_out1)
);

reg [15:0] data_in2;
reg [15:0] data_out2;

sbox #(
    .NUM(2)
) sbox_inst2 (
    .data_in(data_in2),
    .data_out(data_out2)
);

initial begin
    $dumpfile("test_sbox.vcd");
    $dumpvars(0, test_sbox);
    data_in1 = 8'h00;
    data_in2 = 16'hff80;
    #10;
    data_in1 = 8'h4f;
    data_in2 = 16'h2f8d;
    #10;
    $finish;
end


endmodule
