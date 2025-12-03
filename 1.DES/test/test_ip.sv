
module test_ip;

reg [63:0] data;
reg [63:0] out;


ip #(
    .EN(1'b1)
) ip_inst1 (
    .data_in(data),
    .data_out(out)
);

initial begin
    $dumpfile("des_ip.vcd");
    $dumpvars(0, test_ip);

    #5;
    data = 64'h0123456789abcdef;
    #20;

    $finish;
end

endmodule
