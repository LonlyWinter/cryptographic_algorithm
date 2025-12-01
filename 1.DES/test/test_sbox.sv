
module test_sbox;

reg [47:0] data;
reg [31:0] out;

sbox sbox (
    .data_in(data),
    .data_out(out)
);

initial begin
    $dumpfile("des_sbox.vcd");
    $dumpvars(0, test_sbox);

    #5;
    data = 48'h79f45d7e5955;
    #20;
    $finish;
end

endmodule
