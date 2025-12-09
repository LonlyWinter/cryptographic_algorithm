
module test_modexp;

reg clk = 0;
reg start = 0;
reg [255:0] a, e, n, n_prime, r2, res_real;
wire [255:0] res;
wire done;

modexp #(
    .LEN(256)
) modexp_inst (
    .clk(clk),
    .start(start),
    .a(a),
    .e(e),
    .n(n),
    .n_prime(n_prime),
    .r2_mod_n(r2),
    .res(res),
    .done(done)
);

always #2 clk = ~clk;

initial begin
    $dumpfile("test_modexp.vcd");
    $dumpvars(0, test_modexp);
    start = 0;
    a = 256'ha1b2c3d4e5f67890123456789012345678901234567890123456789012345678;
    e = 256'h0000000000000000000000000000000000000000000000000000000000010001;
    n = 256'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;
    n_prime = 256'hc9bd1905155383999c46c2c295f2b761bcb223fedc24a059d838091dd2253531;
    r2 = 256'h000000000000000000000000000000000000000000000001000007a2000e90a1;
    res_real = 256'h6529839e9bf0ce322932bdcc612f5f3866cf4c7abf15bff66b324e253bb35bc3;
    #10;
    start = 1;
    #1;
    start = 0;
    #300;
    $display(
        "Montgomery ModExp\n  a = %h\n  n = %h\nres = %h\n    - %h",
        a, n, res, res_real
    );
    $finish;
end

endmodule
